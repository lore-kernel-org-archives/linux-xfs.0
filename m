Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Mar 2008 14:21:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2PLL6M7030225
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:21:08 -0700
Received: from adm01.ops.amientertainment.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A54B1102C92E
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:21:40 -0700 (PDT)
Received: from adm01.ops.amientertainment.net (adm01.ops.amientertainment.net [64.141.138.10]) by cuda.sgi.com with ESMTP id hmHazZ1WTQKANbq7 for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 14:21:40 -0700 (PDT)
Received: from dhcp-192-168-6-143.ops.amientertainment.net (dhcp-192-168-6-143.ops.amientertainment.net [192.168.6.143])
	(authenticated bits=0)
	by adm01.ops.amientertainment.net (8.13.1/8.13.1/BCH2.0) with ESMTP id m2PLLda3019457
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 25 Mar 2008 17:21:39 -0400
Subject: XFS performance on LVM2 mirror
From: Scott Tanner <stanner@amientertainment.net>
Content-Type: text/plain
Date: Tue, 25 Mar 2008 17:37:32 -0400
Message-Id: <1206481052.4283.17.camel@dhcp-192-168-6-143>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello,
  I've been doing some benchmarking (using bonnie++) of the XFS
filesystem and found a substantial performance drop in rewrite and
delete operations when using an LVM2 mirror. When using the Linux
Software Raid driver to perform the mirror, XFS performance is quite
good. I've tried a number of the performance tweaks from the mailing
list archives, as seen below. The only option that seemed to make a real
difference was LVM's --corelog, which only worked for 1 test then the
server crashed. 

Are there any special tweaks for XFS on LVM2 mirrors? Recommendations on
my setup?


Thanks,
Scott


Here are some system specs and benchmark results:

Dell 1750 (32bit)
single Xeon 2.8GHz
1GB ram
Centos5 (2.6.18-53.1.14.el5)
Emulex lightpulse L982 HBA

2 x Jetstor Disk Arrays:
     9 Disk Raid 5, 128K stripe
     2 TB LU 

16K readahead set on all disks (blockdev --setra 16384 /dev/sdx)
Adjusted max_sectors_kb - no improvement
Adjusted nr_requests - no improvement
XFS mounted with -o noatime,nodiratime,nobarrier,logbufs=8
All Bonnie++ tests using -s 2016M -n 2:5000000:1000000/64, displaying
average of 3 runs.
---------------------------------------------------------------------

Single 2TB disk (LU) no LVM no XFS options:
fs01,2G,40374,,186139,52,84250,24,43405,98,191468,14,745.0,0,,27,19,51,7,1389,20,26,20,18,1,1089,18
(S.Out Block= 186M/s |S.Out Rewrite= 84M/s |S.In Block=191M/s |Del =
1389)

Linux Software Raid Mirror,  no XFS options:
fs01,2G,39516,,93718,25,75745,22,43253,98,193540,23,1475.8,1,,24,19,36,7,1184,18,24,19,17,2,969,12
(S.Out Block= 93M/s |Seq Out Rewrite= 75M/s |S.In Block=193M/s |Del =
1184)

LVM2 Mirror, no XFS options:
fs01,2G,33459,,93708,28,18752,5,42716,97,196157,20,1031.9,0,,25,21,33,5,180,2,26,22,18,1,226,1
(S.Out Block= 93M/s |S.Out Rewrite= 18M/s |S.In Block=196M/s |Del = 180)

LVM2 Mirror, XFS options logsize=64M sunit=256  swidth=512 blks
fs01,2G,34492,,93389,27,18381,5,43100,97,191331,21,1063.2,0,,23,20,29,4,178,1,24,19,17,1,191,1
(S.Out Block= 93M/s |S.Out Rewrite= 18M/s |S.In Block=191M/s |Del = 178)

LVM2 Mirror  XFS options logsize=64M sunit=64  swidth=1024 blks
fs01,2G,36145,,92566,26,18430,5,43560,99,200523,21,1088.4,0,,23,20,34,5,211,2,25,20,18,1,172,1
(S.Out Block= 92M/s |S.Out Rewrite= 18M/s |S.In Block=200M/s |Del = 211)

LVM2 Mirror  XFS options logsize=64M sunit=32  swidth=256 blks
fs01,2G,36922,,96298,26,18832,6,43623,97,199477,26,1187.2,3,,27,20,33,11,235,4,25,19,20,6,158,3
(S.Out Block= 96M/s |S.Out Rewrite= 18M/s |S.In Block=199M/s |Del = 235)

LVM2 Mirror --metadatasize=64k, XFS options logsize=64M sunit=32
swidth=256 blks
fs01,2G,34508,,96358,25,19132,6,43817,98,200040,27,1202.5,3,,29,22,33,10,234,4,29,23,19,6,195,4
(S.Out Block= 96M/s |S.Out Rewrite= 19M/s |S.In Block=200M/s |Del = 234)

LVM2 Mirror --metadatasize=64k, XFS options logsize=64M sunit=256
swidth=256 blks
fs01,2G,36367,,91923,24,18639,6,43732,97,199305,26,1230.0,3,,26,19,31,10,212,4,30,22,19,6,151,3
(S.Out Block= 91M/s |S.Out Rewrite= 18M/s |S.In Block=199M/s |Del = 212)


LVM2 Mirror --corelog, XFS options logsize=64M sunit=256 swidth=256 blks
fs01,2G,39387,,95708,30,46650,15,43273,98,199461,21,1037.3,0,,25,20,29,4,889,10,26,20,17,1,927,14
(S.Out Block= 95M/s |S.Out Rewrite= 46M/s |S.In Block=199M/s |Del = 889)

And for comparison, EXT3 over LVM2 mirror:
fs01,2G,33028,,117260,75,61222,38,36994,86,196760,45,885.5,2,,33,60,33,11,143,5,31,57,21,7,147,6
(S.Out Block=117M/s |S.Out Rewrite= 61M/s |S.In Block=196M/s |Del = 143)
