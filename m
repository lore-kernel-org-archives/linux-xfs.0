Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0D4NoFG115384 for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 22:23:50 -0600
Received: from mail-yw0-f191.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7D0C51247632
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 20:24:45 -0800 (PST)
Received: from mail-yw0-f191.google.com (mail-yw0-f191.google.com
	[209.85.211.191]) by cuda.sgi.com with ESMTP id
	G90Q0GGwGlIzHJAG for <xfs@oss.sgi.com>;
	Tue, 12 Jan 2010 20:24:45 -0800 (PST)
Received: by ywh29 with SMTP id 29so1118220ywh.32
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2010 20:24:45 -0800 (PST)
From: Ian MacColl <imaccoll@gmail.com>
Subject: broken XFS filesystem?
Date: Wed, 13 Jan 2010 14:24:38 +1000
Message-Id: <A668A7CF-103A-4C95-9CF1-12544A31E7FD@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1077)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Ian MacColl <imaccoll@gmail.com>

Hello

I'm hoping for some suggestions for sorting out a problem with an XFS filesystem running on top of an mdadm-based linear array.

The original hardware was a lacie Ethernet Big Disk (ARM-based Marvell CPU, I think) with two seagate 500GB disks. The power supply died and I'm trying to retrieve the files. The array is a backup of a readynas RAID that has also died (with a more complex setup, so I decided to start with the lacie).

One disk (originally sda) has several partitions including linux root (sda8) and about half of the main storage (sda2). The other disk (originally sdb) is unpartitioned and provides the other half of the main storage.

Both disks have been copied without errors to img files which I'm mounting as loop devices on an Intel Macbook running Debian over vmware.

Surprisingly (to me, at least), mdadm --examine reveals an md superblock on sdb but not sda2, even though sda2 is listed before sdb in mdadm.conf. The array (md0) can be started via --create with assume-clean if the underlying volumes are read-write, or via --build if not. The array can be mounted but much of the directory hierarchy isn't accessible, giving "Structure needs cleaning" messages.

xfs_repair -n reveals many errors, apparently stemming from problems with superblocks 16 through 31 inclusive (bad magic number, conflicting geometry, bad sizes, bad flags, and so on). xfs_repair recovers about 100GB of 700GB, including some parts of the original directory hierarchy plus a large number of orphaned directories in lost+found, named by inode.

The array comprised of sda2 and sdb (md0) has xfs superblocks, apparently 0 through 15 from sda2 and 16 through 31 from sdb

+ sb0 seems sensible
+ sb1-15 differ from sb0 in that:
	+ rootino, rbmino, rsumino are null (except sb15.rootino is 128)
	+ inprogress is 1 rather than 0
	+ icount is 0 rather than 324032
	+ ifree is 0 rather than 854
	+ fdblocks is 243908608 rather than 71789361
+ sb16-23 contain 0s
+ sb24 contains rubbish
+ sb25 contains 0s
+ sb26-31 contain rubbish

I'm not sure whether the sb1-15 differences with sb0 are a problem since I understand sb0 is used operationally and the others are only used for recovery. 

For the underlying volumes, xfs_db reveals an xfs superblock on sda2 but not sdb. On sda2, the superblocks look to be the same as sb0-15 for md0 (including sb15.rootino value of 128). On sdb, there appears to be an xfs superblock at offset 0x1EB80000, preceded by 0s. xfs_db gives sensible results for sb0-15  on a loop device set up at the offset . 

I'm naively wondering whether this might somehow be related to the offset and the composition of the array but starting the array with offset loop device instead of sdb doesn't give anything useful. Also, nothing in the original config suggests sdb was mounted with a(similar to sb1-15 on md0) n offset.

Walking the inode tree of md0 from the root seems to quickly fall off the end of the world at the point where traversing the directory fails. For example:

	128 (rootino)
		131 share
			2281701564 xxx (all 0s/needs cleaning)
		132 lacie
			...

Basically, I'm unsure whether the problem lies with mdadm or xfs. Either way, I'm after suggestions as to how to proceed (possibly including advice that I should give up and start on the readynas)

regards

Ian
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
