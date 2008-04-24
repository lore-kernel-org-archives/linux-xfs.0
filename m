Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Apr 2008 18:49:07 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3O1mEXW000838
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 18:48:48 -0700
Received: from py-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E4FC4DEDBD
	for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 18:48:55 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.181]) by cuda.sgi.com with ESMTP id U1xisE5u0nVVI2D0 for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 18:48:55 -0700 (PDT)
Received: by py-out-1112.google.com with SMTP id j37so3056902pyc.4
        for <xfs@oss.sgi.com>; Wed, 23 Apr 2008 18:48:54 -0700 (PDT)
Message-ID: <c33e4330804231848n72ce683cqd48a8d45937f302@mail.gmail.com>
Date: Wed, 23 Apr 2008 21:48:53 -0400
From: "Michael Darling" <darlingm@gmail.com>
Subject: XFS drops create/delete files to 6.6% of EXT3 (software raid) and to 0.6% of EXT3 (3ware hardware raid)
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I am preparing a new server, and benchmarking EXT3 against XFS, both using
software RAID and hardware RAID using a 3ware 9650SE-4LPML.

Using bonnie++ as a benchmark, I am seeing significant performance boosts in
my block sequential reads and writes moving from EXT3 to XFS.  I am aware
that XFS won't create and delete files as quickly as EXT3, however I am
seeing drops from 29455/second to 1957/second using software RAID, and from
32524/second to 189/second using hardware RAID.  I'm not sure if when using
software raid, if creating and deleting files should drop to 6.6% of EXT3.
But, what I'm pretty sure of, is when using hardware raid, that creating and
deleting files shouldn't drop to 0.6% of EXT3.

When using the 3ware card, mkfs.xfs defaulted to "data sunit=0 swidth=0
blks", which made me think that might be the problem, so I tried "-d
sunit=128,swidth=384" with no effect.  My 3ware card is using 64k stripes,
so I calculated 64k stripes / 512 bytes = sunit 128, and multiplied by 3
drives (3 usable in a 4 drive raid 5) to get swidth 384.  This is my first
time calculating these values, so I'm not sure if I did this right.
Unfortunately, these settings had no performance change.

If anyone could give me some pointers, I would much appreciate it!

BONNIE++ - SOFTWARE RAID 5 - 4 DRIVES - SETRA 16384 - EXT3
-----------------------------------------------------------------------------------------------------

"/sbin/mdadm --create /dev/md0 --verbose --level=raid5 --raid-devices=4
/dev/sd{b,c,d,e}"
"/sbin/mke2fs -j /dev/md0"
"mount /dev/md0 /newraid"
"chmod 777 /newraid"
"bonnie++ -d /newraid" (as non-root)

 Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
servo.runtimecc. 8G 54852  96 116904  37 52572  15 63851  96 189073  25
352.8   1
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
                 16 29455  89 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++
+++

BONNIE++ - SOFTWARE RAID 5 - 4 DRIVES - SETRA 16384 - XFS
---------------------------------------------------------------------------------------------------
"/sbin/mdadm --create /dev/md0 --verbose --level=raid5 --raid-devices=4
/dev/sd{b,c,d,e}"
"/sbin/mkfs.xfs -i size=512 /dev/md0"
"mount /dev/md0 /newraid"
"chmod 777 /newraid"
"bonnie++ -d /newraid" (as non-root)

Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
servo.runtimecc. 8G 61281  97 146610  32 48509  17 57977  89 180168  26
479.4   0
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
                 16  1597  11 +++++ +++  1348   7  1398  10 +++++ +++
954   5

BONNIE++ - 9650SE HARDWARE RAID 5 - 4 DRIVES - SETRA 16384 - EXT3
------------------------------------------------------------------------------------------------------------------

(Using default 9650SE values, except turning write cache on and setting
StorSave to balance)
(I tried max_sectors_kb=64 and nr_requests=512 alone and together, and
performance went down)
"/sbin/mke2fs -j /dev/sdb1"
"mount /dev/sdb1 /newraid"
"chmod 777 /newraid"
"bonnie++ -d /newraid" (as non-root)

Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
servo.runtimecc. 8G 53483  93 108314  31 57674  12 62134  91 227582  19
329.9   0
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
                 16 32524  95 +++++ +++ +++++ +++ +++++ +++ +++++ +++ +++++
+++

BONNIE++ - 9650SE HARDWARE RAID 5 - 4 DRIVES - SETRA 16384 - XFS
-----------------------------------------------------------------------------------------------------------------

(Using default 9650SE values, except turning write cache on and setting
StorSave to balance)
(I tried max_sectors_kb=64 and nr_requests=512 alone and together, and
performance went down)
"/sbin/mkfs.xfs -i size=512 /dev/sdb1"
meta-data=/dev/sdb1              isize=512    agcount=32, agsize=11443802
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=366201664, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

sunit=swidth=0 worried me, so I tried "/sbin/mkfs.xfs -i size=512 -d
sunit=128,swidth=384 /dev/sdb1" and got within 1-2% of the results below.
"mount /dev/sdb1 /newraid"
"chmod 777 /newraid"
"bonnie++ -d /newraid" (as non-root)

Version  1.03       ------Sequential Output------ --Sequential Input-
--Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
--Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec
%CP
servo.runtimecc. 8G 62518  99 211622  33 78473  12 68182  99 214218  15
484.6   0
                    ------Sequential Create------ --------Random
Create--------
                    -Create-- --Read--- -Delete-- -Create-- --Read---
-Delete--
              files  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec
%CP
                 16   189   1 +++++ +++   172   0   186   1 +++++ +++
122   0


[[HTML alternate version deleted]]
