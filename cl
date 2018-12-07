#!/bin/sh
mkdir /etc/shadowvpn-new


sername=XXX
serverip=XXX.XXX.XX.X
serport=10XX
vpngate=10.7.X
net=$vpngate.2/24
intf=tunXX
serpasswd=XXXX
mtu=1432

shadowvpn -c /etc/shadowvpn-new/$sername -s stop

echo 33333
sleep 3





##############################################################################
cat > /etc/shadowvpn-new/zvpnup$sername <<EOF
#!/bin/sh

sysctl -w net.ipv4.ip_forward=1


ip addr add $net dev $intf
ip link set $intf mtu $mtu
ip link set $intf up

# Turn on NAT over VPN
iptables -t nat -A POSTROUTING -o $intf -j MASQUERADE
iptables -I FORWARD 1 -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -I FORWARD 1 -o $intf -j ACCEPT

# Direct route to VPN server's public IP via current gateway
ip route add $server via $(ip route show 0/0|grep -v tun | sed -e 's/.* via \([^ ]*\).*/\1/')

# Shadow default route using two /1 subnets
#ip route add   0/1 dev $intf
#ip route add 128/1 dev $intf
echo $(echo $)0 done
#echo $0 done



EOF
##############################################################################





##############################################################################
cat > /etc/shadowvpn-new/zvpndown$sername <<EOF
#!/bin/sh


iptables -t nat -D POSTROUTING -o $intf -j MASQUERADE
iptables -D FORWARD -i $intf -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -D FORWARD -o $intf -j ACCEPT

# Restore routing table
ip route del $serverip
ip route del   0/1
ip route del 128/1
echo $(echo $)0 done
#echo $0 done



EOF
##############################################################################







##############################################################################
cat > /etc/shadowvpn-new/$sername <<EOF

server=$serverip
port=$serport
net=$net
intf=$intf
password=$serpasswd
mode=client
concurrency=1
mtu=$mtu
up=/etc/shadowvpn-new/zvpnup$sername
down=/etc/shadowvpn-new/zvpndown$sername
pidfile=/var/run/shadowvpn.$sername.pid
logfile=/var/log/shadowvpn.$sername.log

EOF
##############################################################################


##############################################################################
cat > /root/cl.$sername <<EOF
#!/bin/sh
shadowvpn -c /etc/shadowvpn-new/$sername -s stop
echo 333
sleep 3
shadowvpn -c /etc/shadowvpn-new/$sername -s start
sleep 5
ping $vpngate.1 -c 3 -W 1

EOF
##############################################################################
sleep 1
chmod 777 /root/cl.$sername;
#chmod 777 /etc/shadowvpn-new/*;

echo finishhhhhhhhhhhhhh write
sleep 2

#shadowvpn -c /etc/shadowvpn-new/$sername -s start
#sleep 5
#ping $vpngate.1 -c 3 -W 1


echo client name=====cl.$sername
echo client name=====cl.$sername





