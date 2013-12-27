Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CDD1D7F3F
	for <linux-xfs@oss.sgi.com>; Fri, 27 Dec 2013 12:07:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56182AC008
	for <linux-xfs@oss.sgi.com>; Fri, 27 Dec 2013 10:07:14 -0800 (PST)
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id NGikAr9mFupc0vE7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 27 Dec 2013 10:07:12 -0800 (PST)
Received: from tom.nabble.com ([192.168.236.105])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lublinkermi@interia.pl>) id 1VwbeC-0001XT-Li
	for linux-xfs@oss.sgi.com; Fri, 27 Dec 2013 09:56:33 -0800
Date: Fri, 27 Dec 2013 09:56:32 -0800 (PST)
From: lublinkermi <lublinkermi@interia.pl>
Message-ID: <1388166992503-35010.post@n7.nabble.com>
Subject: Please help to recover filesystem XFS on RAID 5
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-xfs@oss.sgi.com

Hi!

I had a XFS filesystem on RAID 5, but line of the power supply 230 V had
crash . UPS failed, 2 hard disk drive on RAID (4 hard disk) failed (medium
error) - then before turn of computer I resynchronize this RAID.  Fdisk
recognized filesystem as XFS. Using dd with conv=noerror, sync I clone XFS
filesystem on external hard disk. After restart machine I never can
resynchronize RAID to see XFS filesystem. Then I connect hard disk to
computer I can mount , but I see numbers as filename with extensions.

xfs_db -c "sb 0" -c "p" /dev/sde5 said:
magicnum = 0x58465342
blocksize = 4096
dblocks = 183103920
rblocks = 0
rextents = 0
uuid = e2716dab-5b52-085e-eae2-3d8442c32a1a
logstart = 134217735
rootino = 256
rbmino = 257
rsumino = 258
rextsize = 1
agblocks = 5722000
agcount = 32
rbmblocks = 0
logblocks = 89406
versionnum = 0xbdb4
sectsize = 4096
inodesize = 256
inopblock = 16
fname = "\000\000\000\000\000\000\000\000\000\000\000\000"
blocklog = 12
sectlog = 12
inodelog = 8
inopblog = 4
agblklog = 23
rextslog = 0
inprogress = 0
imax_pct = 25
icount = 37056
ifree = 7341
fdblocks = 181668411
frextents = 0
uquotino = 0
gquotino = 0
qflags = 0
flags = 0
shared_vn = 0
inoalignmt = 2
unit = 16
width = 48
dirblklog = 0
logsectlog = 12
logsectsize = 4096
logsunit = 4096
features2 = 0xa
bad_features2 = 0xa

xfs_repair :
couldn't verify primary superblock not enough secondary superblocks with
matching geometry
attempting to find secondary superblock......................

xfs_check said
cannot init perag data (117).

I use xfs_explorer, UFS Explorer Professional Recovery, photorec, testdisk
to recover files, but any of this nothing do.

It's very important because on filesystem XFS there was a virtual machine
file with many MS SQL databases. I can't have backup because packed backup
file has a 17 GB,  external hard disk destroyed after the supertension of
the energy network.

Please help me...

 



--
View this message in context: http://xfs.9218.n7.nabble.com/Please-help-to-recover-filesystem-XFS-on-RAID-5-tp35010.html
Sent from the linux-xfs mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
