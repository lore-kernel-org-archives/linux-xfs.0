Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 16 Feb 2008 13:49:41 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1GLnaYu029187
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 13:49:38 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC7EF5E49DD
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 13:50:00 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id 21GCuVFo0AwXBcht for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 13:50:00 -0800 (PST)
Date: Sat, 16 Feb 2008 22:49:58 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Re: Differences in mkfs.xfs and xfs_info output.
In-Reply-To: <20080216074019.GV155407@sgi.com>
Message-ID: <Pine.LNX.4.63.0802162218320.6528@alienAngel.home.sk>
References: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
 <20080216074019.GV155407@sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com


Thanks Eric and David.


On Sat, 16 Feb 2008, Eric Sandeen wrote:

> You're on x86_64 aren't you...

Yes, as I wrote in my mail architecture is x86_64.

> if you hexdump out the filesystem that was made you'll see

Here is hexdump:
00000000  58 46 53 42 00 00 10 00  00 00 00 00 00 01 f4 00  |XFSB............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020  92 5f 55 30 62 d4 43 85  ad 9e e5 c7 2e 2f b6 09  |._U0b.C....../..|
00000030  00 00 00 00 00 01 00 04  00 00 00 00 00 00 00 80  |................|
00000040  00 00 00 00 00 00 00 81  00 00 00 00 00 00 00 82  |................|
00000050  00 00 00 01 00 00 7d 00  00 00 00 04 00 00 00 00  |......}.........|
00000060  00 00 04 b0 b4 a4 02 00  01 00 00 10 00 00 00 00  |................|
00000070  00 00 00 00 00 00 00 00  0c 09 08 04 0f 00 00 19  |................|
00000080  00 00 00 00 00 00 00 40  00 00 00 00 00 00 00 3d  |.......@.......=|
00000090  00 00 00 00 00 01 ef 3c  00 00 00 00 00 00 00 00  |.......<........|
000000a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000000b0  00 00 00 00 00 00 00 02  00 00 00 00 00 00 00 00  |................|
000000c0  00 00 00 00 00 00 00 01  00 00 00 00 00 00 00 0a  |................|
000000d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  58 41 47 46 00 00 00 01  00 00 00 00 00 00 7d 00  |XAGF..........}.|
00000210  00 00 00 01 00 00 00 02  00 00 00 00 00 00 00 01  |................|
00000220  00 00 00 01 00 00 00 00  00 00 00 00 00 00 00 03  |................|
00000230  00 00 00 04 00 00 7c f4  00 00 7c f4 00 00 00 00  |......|...|.....|
00000240  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*

> Does this make it happier for you?  Hmm actually the kernel needs
> the analogous change too.  And then probably something to fix up 
> all the misformatted filesystems out there.... yuck.

The patched mkfs corretly sets attr2 and lazy-count. If I understand
right it is a long lasting bug. Are there any plans to fix mkfs?

> do you happen to have a 32-bit mkfs and a 64-bit kernrel?

No, both mkfs and kernel are 64-bit:
# file `which mkfs.xfs`
/sbin/mkfs.xfs: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), for GNU/Linux 2.6.4, dynamically linked (uses shared libs), not stripped
# ldd `which mkfs.xfs`
        linux-vdso.so.1 =>  (0x00007fffe97fe000)
        libuuid.so.1 => /lib64/libuuid.so.1 (0x00002ae4c15ba000)
        librt.so.1 => /lib64/librt.so.1 (0x00002ae4c17be000)
        libpthread.so.0 => /lib64/libpthread.so.0 (0x00002ae4c19c7000)
        libc.so.6 => /lib64/libc.so.6 (0x00002ae4c1be3000)
        /lib64/ld-linux-x86-64.so.2 (0x00002ae4c139d000)

On Sat, 16 Feb 2008, David Chinner wrote:

> had time. The patch below should fix the problem - mkfs.xfs is writing
> the features2 field to the wrong location in the superblock, and
> this patch detects and corrects it. You'll probably see the output:

I confirm that your patch fix feature2 on previously created fs's:

dmesg:
XFS: correcting sb_features alignment problem
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0

# xfs_info /usr
meta-data=/dev/mapper/system-usr isize=256    agcount=4, agsize=170496 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=681984, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=2560, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# xfs_db -r /dev/mapper/system-usr 
xfs_db> sb
xfs_db> print
magicnum = 0x58465342
blocksize = 4096
dblocks = 681984
.
.
.
logsunit = 1
features2 = 0xa


Cheers,

jan


-- 
