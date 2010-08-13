Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7DFDrM7068879 for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 10:13:54 -0500
Received: from mail.nethype.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D548170364D
	for <xfs@oss.sgi.com>; Fri, 13 Aug 2010 08:14:18 -0700 (PDT)
Received: from mail.nethype.de (mail.nethype.de [78.47.73.129]) by
	cuda.sgi.com with ESMTP id slOIfda7MqwCLpNO for
	<xfs@oss.sgi.com>; Fri, 13 Aug 2010 08:14:18 -0700 (PDT)
Received: from [10.9.0.44] by mail.nethype.de with esmtp (Exim 4.69)
	(envelope-from <marco@nethype.de>) id 1OjvxZ-0006Jm-9C
	for xfs@oss.sgi.com; Fri, 13 Aug 2010 15:14:17 +0000
Message-ID: <4C656149.6050604@nethype.de>
Date: Fri, 13 Aug 2010 17:14:17 +0200
From: Marco Maisenhelder <marco@nethype.de>
MIME-Version: 1.0
Subject: fs corruption not detected by xfs_check or _repair
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi list,

I have a little bit of a problem after a catastrophic hardware failure 
(power supply went up in smoke and took half of my server with it - 
luckily only one of my raid5 disks though). My xfs data partition on my 
raid has some severe corruption that prevents me from accessing some 
files and directories on the partition. This is how the problem 
manifests itself:

*marco:/etc# ls -lrt /store/xfs_corruption/x/
ls: cannot access /store/xfs_corruption/x/db.backup2: Invalid argument
ls: cannot access /store/xfs_corruption/x/db.backup1: Invalid argument
total 0
?????????? ? ? ? ?                ? db.backup2
?????????? ? ? ? ?                ? db.backup1

xfs_check does not report any errors. xfs_repair does not repair anything.

xfs_repair version 3.1.2
xfs_check version 3.1.2
System is Debian stable using a 2.6.26-2-amd64 kernel

*marco:/etc# xfs_info /store/
meta-data=/dev/mapper/vgraid-rstore isize=256    agcount=48, 
agsize=11443904 blks
          =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=549307392, imaxpct=25
          =                       sunit=64     swidth=192 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
          =                       sectsz=512   sunit=64 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

There's nothing in any of the system logs that would hint to the 
filesystem being corrupt.

I have done a metadump but after looking into it found that there's 
still sensitive information in there. I would be ok sharing it with 
individual developers but I can't put that on an open mailinglist.

I have managed to recover most of the lost data from the filesystem by 
other means but if there's a chance to recover all of it that would be 
nice ;) My main problem at the moment is that I don't trust the 
filesystem in this state and that I can't delete any of the garbled 
entries without hacking the fs which I think would be suicidal with my 
current experience level... albeit interesting ;).

I'm willing to provide any requested data provided that there is no 
sensitive information inside.

Additional info:

I ran an xfs_ncheck on the fs and looked for the broken 
files/directories (example):

marco:~# grep xfs_corruption /tmp/filelist
   270700128 xfs_corruption/.
   823523611 xfs_corruption/x/.
  8589948676 xfs_corruption/x/db.backup2/.
  8589948686 xfs_corruption/x/db.backup2/annotations.db
  8589948688 xfs_corruption/x/db.backup2/log.0000000010
  8589948689 xfs_corruption/x/db.backup2/mailboxes.db
  8864332545 xfs_corruption/x/db.backup1/.
  8864332554 xfs_corruption/x/db.backup1/annotations.db
  8864332555 xfs_corruption/x/db.backup1/log.0000000010
  8864332556 xfs_corruption/x/db.backup1/mailboxes.db

xfs_db> blockget -i 8589948676
inode 8589948676 add link, now 1
inode 8589948676 mode 040700 fmt local afmt extents nex 0 anex 0 nblk 0 
sz 83
inode 8589948676 nlink 2 is dir
inode 8589948676 add link, now 2
dir 8589948676 entry . 8589948676
dir 8589948676 entry annotations.db offset 48 8589948686
dir 8589948676 entry log.0000000010 offset 80 8589948688
dir 8589948676 entry mailboxes.db offset 112 8589948689
dir 8589948676 entry .. 823523611
inode 8589948676 parent 823523611

xfs_db> blockget -i 823523611
inode 823523611 add link, now 1
inode 823523611 mode 040750 fmt local afmt extents nex 0 anex 0 nblk 0 sz 52
inode 823523611 nlink 4 is dir
inode 823523611 add link, now 2
dir 823523611 entry . 823523611
dir 823523611 entry db.backup2 offset 928 8589948676
dir 823523611 entry db.backup1 offset 952 8864332545
dir 823523611 entry .. 270700128
inode 823523611 parent 270700128
inode 823523611 add link, now 3
inode 8589948676 parent 823523611
inode 823523611 add link, now 4
inode 8864332545 parent 823523611

xfs_db> inode 8589948676
xfs_db> print
core.magic = 0x494e
core.mode = 040700
core.version = 2
core.format = 1 (local)
core.nlinkv2 = 2
core.onlink = 0
core.projid = 0
core.uid = 109
core.gid = 8
core.flushiter = 16
core.atime.sec = Wed Aug  4 20:20:30 2010
core.atime.nsec = 405290860
core.mtime.sec = Wed Aug  4 20:20:30 2010
core.mtime.nsec = 444295242
core.ctime.sec = Wed Aug  4 20:50:30 2010
core.ctime.nsec = 716289102
core.size = 83
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 1967827294
next_unlinked = null
u.sfdir2.hdr.count = 3
u.sfdir2.hdr.i8count = 3
u.sfdir2.hdr.parent.i8 = 823523611
u.sfdir2.list[0].namelen = 14
u.sfdir2.list[0].offset = 0x30
u.sfdir2.list[0].name = "annotations.db"
u.sfdir2.list[0].inumber.i8 = 8589948686
u.sfdir2.list[1].namelen = 14
u.sfdir2.list[1].offset = 0x50
u.sfdir2.list[1].name = "log.0000000010"
u.sfdir2.list[1].inumber.i8 = 8589948688
u.sfdir2.list[2].namelen = 12
u.sfdir2.list[2].offset = 0x70
u.sfdir2.list[2].name = "mailboxes.db"
u.sfdir2.list[2].inumber.i8 = 8589948689

xfs_db> ring
       type    bblock  bblen    fsbno     inode
* 0: inode   283762312     8 51470225 823523611
xfs_db> type inode
xfs_db> p
core.magic = 0x494e
core.mode = 040750
core.version = 2
core.format = 1 (local)
core.nlinkv2 = 4
core.onlink = 0
core.projid = 0
core.uid = 110
core.gid = 8
core.flushiter = 14526
core.atime.sec = Sat Aug  7 01:32:24 2010
core.atime.nsec = 351022120
core.mtime.sec = Sat Aug  7 01:32:38 2010
core.mtime.nsec = 547022120
core.ctime.sec = Sat Aug  7 01:32:38 2010
core.ctime.nsec = 547022120
core.size = 52
core.nblocks = 0
core.extsize = 0
core.nextents = 0
core.naextents = 0
core.forkoff = 0
core.aformat = 2 (extents)
core.dmevmask = 0
core.dmstate = 0
core.newrtbm = 0
core.prealloc = 0
core.realtime = 0
core.immutable = 0
core.append = 0
core.sync = 0
core.noatime = 0
core.nodump = 0
core.rtinherit = 0
core.projinherit = 0
core.nosymlinks = 0
core.extsz = 0
core.extszinherit = 0
core.nodefrag = 0
core.filestream = 0
core.gen = 677480964
next_unlinked = null
u.sfdir2.hdr.count = 2
u.sfdir2.hdr.i8count = 2
u.sfdir2.hdr.parent.i8 = 270700128
u.sfdir2.list[0].namelen = 10
u.sfdir2.list[0].offset = 0x3a0
u.sfdir2.list[0].name = "db.backup2"
u.sfdir2.list[0].inumber.i8 = 8589948676
u.sfdir2.list[1].namelen = 10
u.sfdir2.list[1].offset = 0x3b8
u.sfdir2.list[1].name = "db.backup1"
u.sfdir2.list[1].inumber.i8 = 8864332545
xfs_db> type text
xfs_db> p
00:  49 4e 41 e8 02 01 00 00 00 00 00 6e 00 00 00 08  INA........n....
10:  00 00 00 04 00 00 00 00 00 00 00 00 00 00 38 be  ..............8.
20:  4c 5c 9b 88 14 ec 2c 28 4c 5c 9b 96 20 9a e5 28  L.......L.......
30:  4c 5c 9b 96 20 9a e5 28 00 00 00 00 00 00 00 34  L..............4
40:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
50:  00 00 00 02 00 00 00 00 00 00 00 00 28 61 8a 04  .............a..
60:  ff ff ff ff 02 02 00 00 00 00 10 22 8e 60 0a 03  ................
70:  a0 64 62 2e 62 61 63 6b 75 70 32 00 00 00 02 00  .db.backup2.....
80:  00 37 04 0a 03 b8 64 62 2e 62 61 63 6b 75 70 31  .7....db.backup1
90:  00 00 00 02 10 5a fb 01 00 00 00 00 00 00 00 00  .....Z..........
a0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
b0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
c0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
d0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
e0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
f0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

Hope this helps!

Marco

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
