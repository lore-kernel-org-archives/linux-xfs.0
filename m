Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 May 2008 13:34:54 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4GKYoHS010614
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 13:34:51 -0700
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1C47316DA3A7
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 13:35:37 -0700 (PDT)
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64]) by cuda.sgi.com with ESMTP id BLfM7bJFabfEx1y8 for <xfs@oss.sgi.com>; Fri, 16 May 2008 13:35:37 -0700 (PDT)
Received: from smtp7-g19.free.fr (localhost [127.0.0.1])
	by smtp7-g19.free.fr (Postfix) with ESMTP id AD51A322813
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 22:35:15 +0200 (CEST)
Received: from galadriel.home (pla78-1-82-235-234-79.fbx.proxad.net [82.235.234.79])
	by smtp7-g19.free.fr (Postfix) with ESMTP id 726093227FB
	for <xfs@oss.sgi.com>; Fri, 16 May 2008 22:35:15 +0200 (CEST)
Date: Fri, 16 May 2008 22:27:55 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: XFS filesystem reports as full though it isn't
Message-ID: <20080516222755.3e557c00@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I have a 64 bits (x86_64) machine running Linux 2.6.22.19 with a 24TB
XFS filesystem. There are some 15TB of data on it. All is well, no
error except that I can't create a single file (touch foo : no space
left on device). I don't understand what can be going wrong... 

History : this filesystem was extended (xfs_growfs) from 16TB to 24.

I've tought about all XFS problems I can remember of; first, inode
exhaustion :

cluster1:/proc/sys/fs# df -i
Sys. de fich.         Inodes   IUtil.  ILib. %IUti. Mont?sur
/dev/sda1                  0       0       0    -  /
tmpfs                2058624       3 2058621    1% /lib/init/rw
udev                 2058624    1445 2057179    1% /dev
tmpfs                2058624       1 2058623    1% /dev/shm
/dev/mapper/vg0-lv0  25379856384    4287 25379852097    1% /mnt/raid

OK so there's still plenty of inodes available here, that should be OK.
Then maybe we have something wrong elsewhere :

cluster1:/proc/sys/fs# xfs_db -r -c 'freesp -s -a 0' /dev/vg0/lv0
   from      to extents  blocks    pct
      1       1       5       5  71.43
      2       3       1       2  28.57
total free extents 6
total free blocks 7
average free extent size 1.16667

7 blocks free? But there are 9 TB of free space! 

Here is the output from xfs_info /dev/vg0/lv0

meta-data=/dev/vg0/lv0           isize=256    agcount=47,
agsize=137245616 blks =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=6344964096,
imaxpct=25 =                       sunit=16     swidth=32 blks,
unwritten=1 naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks
realtime =none                   extsz=131072 blocks=0, rtextents=0

I fail to see nothing special there however.

The only significant thing I see is that the FS is really close to 16
TB of allocated data (15.7TB). I tried mounting it with "inode64"
option with no more loving.

Any help would be tremendously welcome. Users are starving for more
space and they can't even create a single file! 

-- 
--------------------------------------------------
Emmanuel Florac               www.intellique.com   
--------------------------------------------------
