Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 27 May 2008 13:35:05 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4RKZ2NN009971
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 13:35:03 -0700
Received: from wa-out-1112.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4150A173A0FE
	for <xfs@oss.sgi.com>; Tue, 27 May 2008 13:35:53 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.179]) by cuda.sgi.com with ESMTP id rJh3zAkpppXlYehV for <xfs@oss.sgi.com>; Tue, 27 May 2008 13:35:53 -0700 (PDT)
Received: by wa-out-1112.google.com with SMTP id j5so3219371wah.18
        for <xfs@oss.sgi.com>; Tue, 27 May 2008 13:35:53 -0700 (PDT)
Message-ID: <ebe74d2a0805271335x5844239eje2eeed606d7cc8b8@mail.gmail.com>
Date: Tue, 27 May 2008 22:35:53 +0200
From: "Sebastian M" <sebcio@gmail.com>
Subject: xfs_repair getting stuck
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello

I was a happy user of the XFS untill yesterday. I had to move data off
the XFS partition
to other storage. I exported it via NFS.
After half a day of moving files a kernel panic appeared on nfs server.
(sorry, but currently I don't have any logs). After reboot I wasn't able to
mount XFS partition anymore (got random kernel panics). I've tried to
xfs_repair, however it didn't work out. I had to use -L option.
As for now I can mount the partition, but most of my folders are not accessible:
ls -la /
drwxrwxrwx 221 99   98 4096 V 23 14:37 .
drwxrwxrwx   3 99 root   21 II  5 01:11 ..
??????????   ? ?  ?       ?          ? 05
??????????   ? ?  ?       ?          ? 26
??????????   ? ?  ?       ?          ? 29
??????????   ? ?  ?       ?          ? 2A
??????????   ? ?  ?       ?          ? 2B
??????????   ? ?  ?       ?          ? 2C
and so on.
(few files went to the lost+found)

When I try to run xfs_repair now it gets stuck every time on the same moment:

kaszanka:~ # xfs_repair -P /dev/md0
Phase 1 - find and verify superblock...
Phase 2 - using internal log
       - zero log...
       - scan filesystem freespace and inode maps...
block (3,1055347) already used, state 2
block (3,1055348) already used, state 2
bad on-disk superblock 4 - bad magic number
primary/secondary superblock 4 conflict - AG superblock geometry info
conflicts with filesystem geometry
bad magic # 0x8cb4f for agi 4
bad sequence # 576384 for agi 4
bad length # 66 for agi 4, should be 4883888
reset bad sb for ag 4
reset bad agi for ag 4
bad magic # 0x58443242 in inobt block 4/3
expected level 576591 got 2568 in inobt block 4/3
bad magic # 0x9c1ac711 in inobt block 4/2112
bad magic # 0x9cd4974b in inobt block 4/329816
bad magic # 0x8f1662e7 in inobt block 4/2160
bad magic # 0x75edc52e in inobt block 4/2184
bad magic # 0x58443242 in inobt block 4/2208
bad magic # 0x8632ebfd in inobt block 4/2232
expected level 576590 got 1 in inobt block 4/98
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x553c5125 in inobt block 4/58339
bad magic # 0x77db49b2 in inobt block 4/15
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x58443242 in inobt block 4/2
bad magic # 0xc9c0c923 in inobt block 4/344821
bad magic # 0x58443242 in inobt block 4/99
expected level 576590 got 1 in inobt block 4/98
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x85a7f11f in inobt block 4/51210
bad magic # 0x28d25805 in inobt block 4/13
bad magic # 0x58443242 in inobt block 4/1
bad magic # 0x58443242 in inobt block 4/2
bad magic # 0xb69f6a9c in inobt block 4/447057
bad magic # 0x58443242 in inobt block 4/99
expected level 576590 got 1 in inobt block 4/98
bad magic # 0x58443242 in inobt block 4/1

Strace shows following:

strace -p

write(2, "bad magic # 0x58443242 in inobt "..., 42) = 42
write(2, "bad magic # 0x58443242 in inobt "..., 42) = 42
pread(4, "\205\247\361\37\306\235:\307U\327\265\0\3260\304\253ej\220\2050\216\2401\37|\373\221]p|\310"...,
4096, 80227377152) = 4096
write(2, "bad magic # 0x85a7f11f in inobt "..., 46) = 46
pread(4, "(\322X\5\265\301
s\33\\^\370\351\226}n+\375$8k\200\263f\256n*\254\246\313\375\2"...,
4096, 80017674240) = 4096
write(2, "bad magic # 0x28d25805 in inobt "..., 43) = 43
write(2, "bad magic # 0x58443242 in inobt "..., 42) = 42
write(2, "bad magic # 0x58443242 in inobt "..., 42) = 42
pread(4, "\266\237j\234\2\222d\214\364\3540\5\0008\\\310\2272\177\246!F`\311o*\26\362\370\302\214\237"...,
4096, 81848766464) = 4096
write(2, "bad magic # 0xb69f6a9c in inobt "..., 47) = 47
write(2, "bad magic # 0x58443242 in inobt "..., 43) = 43
write(2, "expected level 576590 got 1 in i"..., 48) = 48
write(2, "bad magic # 0x58443242 in inobt "..., 42) = 42
futex(0xb80c88, FUTEX_WAIT, 2, NULL

I've tried xfs_repair -P but the problem remains - it stuck on the same moment.

My xfs partition (2.6TB) is created on the top of software raid 5 (10x 320gb)
Right now Im using OpenSuse with 2.6.22.17-0.1-default x86_64 kernel.
My box got 2 Gigs of ram.
SATA disks are connected with SIL 3114 raid controllers.

Im using XFSProgs version 2.9.7

Xfs_info:

kaszanka:~ # xfs_info /dev/md0
meta-data=/dev/md0               isize=256    agcount=144, agsize=4883888 blks
        =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=703279296, imaxpct=25
        =                       sunit=16     swidth=48 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
        =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=196608 blocks=0, rtextents=0

Mounting and unmounting looks normal:

May 27 17:25:23 kaszanka kernel: SGI XFS with ACLs, security
attributes, realtime, large block/inode numbers, no debug enabled
May 27 17:25:23 kaszanka kernel: SGI XFS Quota Management subsystem
May 27 17:25:23 kaszanka kernel: Filesystem "md0": Disabling barriers,
not supported by the underlying device
May 27 17:25:23 kaszanka kernel: XFS mounting filesystem md0
May 27 17:25:25 kaszanka kernel: Ending clean XFS mount for filesystem: md0

Is there any chance of repearing that partition ?
I've made metadump of that partition - its quite big - more than 3GB. I can
put it somewhere if any of developers is interested.

Thanks,
Sebastian
