Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBLF9uJ6013823 for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 09:09:56 -0600
Received: from mail-bw0-f10.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 788F51769536
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 07:09:52 -0800 (PST)
Received: from mail-bw0-f10.google.com (mail-bw0-f10.google.com
	[209.85.218.10]) by cuda.sgi.com with ESMTP id kR5WMy6Z6gi1OtUr
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 07:09:52 -0800 (PST)
Received: by bwz3 with SMTP id 3so3497731bwz.20
	for <xfs@oss.sgi.com>; Sun, 21 Dec 2008 07:09:51 -0800 (PST)
Message-ID: <7bcfcfff0812210703r4bd889cave8e2d60c56587e3e@mail.gmail.com>
Date: Sun, 21 Dec 2008 10:03:19 -0500
From: "David Bernick" <dbernick@gmail.com>
Subject: xfs_repair problem.
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I have a filesystem where an xfs_growfs went bad. We were adding
storage to a pre-existing infrastructure and when growing, we received
an error. SInce then, we've been unable to mount.

It's a large filesystem (see below) and the addition of the extra data
has made it larger. We tried an xfs_repair but it died, as the machine
only has 4GB RAM. We're going to put 32 GB in RAM and see if that
helps. The original FS size is about 13T and the addition brought it
to 29T.
Since we've been unable to write or mount, we've "backed off" the
addition and are left with our original, which we'd like to mount.

We try to mount and get an error about the root inode not being
readable. Makes sense as the root inode is null (according to xfs_db).

So before we run another big xfs_repair:

1. What is the math of filesystems size, number of files and how much
RAM is needed for such a task? Is 32 GB enough for 1/2 Billion files
and 13 TB?

2. Any way I can just find my rootino,rbmino,rsumino and put them in the DB?

Any other advice?

/proc/partitions:
 253     0 13084291072 dm-0

--- Logical volume ---
LV Name                /dev/docs/v5Docs
VG Name                docs
LV UUID                G85Zi9-s63C-yWrU-yyf0-STP6-YOhJ-6Ne3pS
LV Write Access        read/write
LV Status              available
# open                 1
LV Size                12.19 TB
Current LE             3194407
Segments               2
Allocation             inherit
Read ahead sectors     0
Block device           253:0

DB:
magicnum = 0x58465342
blocksize = 4096
dblocks = 3064987648
rblocks = 0
rextents = 0
uuid = f086bb71-d67b-4cc1-b622-1f10349e6a49
logstart = 1073741828
rootino = null
rbmino = null
rsumino = null
rextsize = 1
agblocks = 67108864
agcount = 46
rbmblocks = 0
logblocks = 32768
versionnum = 0x3084
sectsize = 512
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 9
inodelog = 8
inopblog = 4
agblklog = 26
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 0
ifree = 0
fdblocks = 0
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
logsunit = 0
features2 = 0


[[HTML alternate version deleted]]

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
