Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Feb 2008 17:33:53 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1G1XlNV021699
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 17:33:48 -0800
Received: from flyingAngel.upjs.sk (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 960115E1BCD
	for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 17:34:11 -0800 (PST)
Received: from flyingAngel.upjs.sk (static113-109.rudna.net [212.20.113.109]) by cuda.sgi.com with ESMTP id ZXKQA7fB1OQa1UtD for <xfs@oss.sgi.com>; Fri, 15 Feb 2008 17:34:11 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by flyingAngel.upjs.sk (Postfix) with ESMTP id 90D212235A2
	for <xfs@oss.sgi.com>; Sat, 16 Feb 2008 02:34:08 +0100 (CET)
Date: Sat, 16 Feb 2008 02:34:08 +0100 (CET)
From: Jan Derfinak <ja@mail.upjs.sk>
Subject: Differences in mkfs.xfs and xfs_info output.
Message-ID: <Pine.LNX.4.63.0802160149590.4592@alienAngel.home.sk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hello.

I found following problem with xfs_info (xfs_grows -p xfs_info) command:

# mkfs.xfs -f /dev/loop0     
meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=128000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal log           bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
# mount /dev/loop0 /mnt/usb
# xfs_info /mnt/usb
meta-data=/dev/loop0             isize=256    agcount=4, agsize=32000 blks
         =                       sectsz=512   attr=0
data     =                       bsize=4096   blocks=128000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096  
log      =internal               bsize=4096   blocks=1200, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=0
realtime =none                   extsz=4096   blocks=0, rtextents=0

Can somebody explain the difference in attr and lazy-count parameters?
Which output is the right one?

mkfs.xfs version 2.9.6
SGI-XFS CVS-2008-02-14_08:00_UTC with ACLs, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
architecture x86_64

# xfs_db -r /dev/loop0 
xfs_db> sb
xfs_db> print
magicnum = 0x58465342
blocksize = 4096
dblocks = 128000
rblocks = 0
rextents = 0
uuid = 925f5530-62d4-4385-ad9e-e5c72e2fb609
logstart = 65540
rootino = 128
rbmino = 129
rsumino = 130
rextsize = 1
agblocks = 32000
agcount = 4
rbmblocks = 0
logblocks = 1200
versionnum = 0xb4a4
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 15
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 64
ifree = 61
fdblocks = 126780
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 0
width = 0
dirblklog = 0
logsectlog = 0
logsectsize = 0
logsunit = 1
features2 = 0

Thanks,
Jan

-- 
