Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Sep 2007 11:54:38 -0700 (PDT)
Received: from rv-out-0910.google.com (rv-out-0910.google.com [209.85.198.186])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8JIsUuw009824
	for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 11:54:32 -0700
Received: by rv-out-0910.google.com with SMTP id k20so225946rvb
        for <xfs@oss.sgi.com>; Wed, 19 Sep 2007 11:54:33 -0700 (PDT)
Message-ID: <728b8e3b0709191129j27b7c319h2efd51ffc9cb64f3@mail.gmail.com>
Date: Wed, 19 Sep 2007 20:29:35 +0200
From: "Jochen K." <jochen.f.k@googlemail.com>
Subject: Cant find sunit and swidth on luks encrypted raid6 device
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I tried to create a xfs filesystem on a big encrypted mapped device but it
isnt working at all.
Also got latest kernel and kernel.org drivers for the raid controller.
I hope you guys have any idea what might have happened here :)
With ext3 its workin but i have no clue how to fix this problem.


Kernel: 2.6.22.5-76.fc7 #1 SMP Thu Aug 30 13:47:21 EDT 2007 i686 i686 i386
GNU/Linux
mdadm - v2.6.3 - 20th August 2007
cryptsetup 1.0.5
mkfs.xfs version 2.9.4

--added encryption--
/sbin/cryptsetup -c aes-cbc-essiv:sha256 -y -s 256 luksFormat /dev/md0
/sbin/cryptsetup luksOpen /dev/md0 raid6

[output without encryption]

mkfs.xfs /dev/md0

meta-data=/dev/md0               isize=256    agcount=32, agsize=53412608
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=1709202880, imaxpct=25
         =                       sunit=32     swidth=448 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=1835008 blocks=0, rtextents=0

:Workin fine here! swidth/sunit = 14 used hdds which is useable space on the
raid6

[output with encryption]

mkfs.xfs -f /dev/mapper/raid6

meta-data=/dev/mapper/raid6      isize=256    agcount=32, agsize=53412581
blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=1709202592, imaxpct=25
         =                       sunit=0      swidth=0 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=1
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0
b7f57ad0: Badness in key lookup (length)
bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096 bytes)

: not workin at all :/

[output with usin dev/md0 values]

mkfs.xfs -s size=4096 -d sunit=32,swidth=448 -r extsize=1835008
/dev/mapper/raid6

meta-data=/dev/mapper/raid6      isize=256    agcount=32, agsize=53412584
blks
         =                       sectsz=4096  attr=0
data     =                       bsize=4096   blocks=1709202592, imaxpct=25
         =                       sunit=4      swidth=56 blks, unwritten=1
naming   =version 2              bsize=4096
log      =internal log           bsize=4096   blocks=32768, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=0
realtime =none                   extsz=1835008 blocks=0, rtextents=0
b7f66ad0: Badness in key lookup (length)
bp=(bno 13673620728, len 131072 bytes) key=(bno 13673620728, len 4096 bytes)


:its still using wrong values here :/

[System Details]

mdadm --detail /dev/md0
/dev/md0:
        Version : 00.90.03
  Creation Time : Tue Sep 18 09:51:12 2007
     Raid Level : raid6
     Array Size : 6836811520 ( 6520.09 GiB 7000.89 GB)
  Used Dev Size : 488343680 (465.72 GiB 500.06 GB)
   Raid Devices : 16
  Total Devices : 16
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Wed Sep 19 19:53:29 2007
          State : clean
 Active Devices : 16
Working Devices : 16
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 128K

           UUID : ae1231f4:1b4dc7a0:370b3052:b437b3a1
         Events : 0.18

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       3       8       65        3      active sync   /dev/sde1
       4       8       81        4      active sync   /dev/sdf1
       5       8       97        5      active sync   /dev/sdg1
       6       8      113        6      active sync   /dev/sdh1
       7       8      129        7      active sync   /dev/sdi1
       8       8      145        8      active sync   /dev/sdj1
       9       8      161        9      active sync   /dev/sdk1
      10       8      177       10      active sync   /dev/sdl1
      11       8      193       11      active sync   /dev/sdm1
      12       8      209       12      active sync   /dev/sdn1
      13       8      225       13      active sync   /dev/sdo1
      14       8      241       14      active sync   /dev/sdp1
      15      65        1       15      active sync   /dev/sdq1

cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid6 sdb1[0] sdq1[15] sdp1[14] sdo1[13] sdn1[12] sdm1[11]
sdl1[10] sdk1[9] sdj1[8] sdi1[7] sdh1[6] sdg1[5] sdf1[4] sde1[3] sdd1[2]
sdc1[1]
      6836811520 blocks level 6, 128k chunk, algorithm 2 [16/16]
[UUUUUUUUUUUUUUUU]

------------------------------------------------


Best regards,
Jochen.


[[HTML alternate version deleted]]
