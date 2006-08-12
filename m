Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Aug 2006 20:16:27 -0700 (PDT)
Received: from rwcrmhc11.comcast.net (rwcrmhc11.comcast.net [204.127.192.81])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7C3G8DW003579
	for <xfs@oss.sgi.com>; Fri, 11 Aug 2006 20:16:08 -0700
Message-ID: <44DD46A5.7010308@comcast.net>
Date: Fri, 11 Aug 2006 23:10:29 -0400
From: Brian Davis <bridavis@comcast.net>
MIME-Version: 1.0
Subject: Negligible improvement when using su/sw for hardware RAID5, expected?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Is this expected? I thought I would see more improvement when tweaking 
my su/sw values for hardware RAID 5.

Details, 3x300GB drives, 3Ware 7506-4LP Hardware RAID 5 using a 64K 
stripe size (non-configurable on this card).

FS creation and Bonnie++ results:

Untweaked:---------------------------------------------------------------------- 


localhost / # mkfs.xfs -f /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=32, agsize=4578999 
blks
        =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=146527968, imaxpct=25
        =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
localhost / # mount -t xfs /dev/sda1 /raid
localhost / # cd /raid
localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Version 1.93c       ------Sequential Output------ --Sequential Input- 
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  
/sec %CP
localhost       30G           27722  40 23847  37           98367  99  
88.6  11
Latency                         891ms     693ms             16968us     
334ms

Tweaked:------------------------------------------------------------------------- 


localhost / # mkfs.xfs -f -d sw=2,su=64k /dev/sda1
meta-data=/dev/sda1              isize=256    agcount=32, agsize=4578992 
blks
        =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=146527744, imaxpct=25
        =                       sunit=16     swidth=32 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
        =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=65536  blocks=0, rtextents=0
localhost / # mount -t xfs /dev/sda1 /raid
localhost / # cd /raid
localhost raid # bonnie++ -n0 -u0 -r 768 -s 30720 -b -f
Using uid:0, gid:0.
Writing intelligently...done
Rewriting...done
Reading intelligently...done
start 'em...done...done...done...done...done...
Version 1.93c       ------Sequential Output------ --Sequential Input- 
--Random-
Concurrency   1     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- 
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  
/sec %CP
localhost       30G           27938  43 23880  40           98066  99  
91.8   9
Latency                         772ms     584ms             19889us     
340ms
