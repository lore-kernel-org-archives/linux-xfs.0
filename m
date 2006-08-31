Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 00:22:07 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7V7LVDW023833
	for <linux-xfs@oss.sgi.com>; Thu, 31 Aug 2006 00:21:42 -0700
Subject: TAKE 955674 - xfssyncd lock up when filesystem full
Message-Id: <20060831061638.0F83058CF851@chook.melbourne.sgi.com>
Date: Thu, 31 Aug 2006 16:16:37 +1000 (EST)
From: dgc@sgi.com (David Chinner)
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: slinx-xfs@engr.sgi.com
Cc: linux-xfs@oss.sgi.com, sdoyon@max-t.com, lnx1138@us.ibm.com

Prevent free space oversubscription and xfssyncd looping.

The fix for recent ENOSPC deadlocks introduced certain limitations
on allocations. The fix could cause xfssyncd to loop endlessly if
we did not leave some space free for the allocator to work
correctly. Basically, we needed to ensure that we had at least 4
blocks free for an AG free list and a block for the inode bmap btree
at all times.

However, this did not take into account the fact that each AG has a
free list that needs 4 blocks. Hence any filesystem with more than
one AG could cause oversubscription of free space and make xfssyncd
spin forever trying to allocate space needed for AG freelists that
was not available in the AG.

The following patch reserves space for the free lists in all AGs
plus the inode bmap btree which prevents oversubscription. It also
prevents those blocks from being reported as free space (as they can
never be used) and makes the SMP in-core superblock accounting code and
the reserved block ioctl respect this requirement.

Date:  Thu Aug 31 16:14:16 AEST 2006
Workarea:  chook.melbourne.sgi.com:/build/dgc/isms/2.6.x-xfs-new
Inspected by:  nathans

The following file(s) were checked into:
  longdrop.melbourne.sgi.com:/isms/linux/2.6.x-xfs-melb


Modid:  xfs-linux-melb:xfs-kern:26894a
fs/xfs/xfs_vfsops.c - 1.510 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vfsops.c.diff?r1=text&tr1=1.510&r2=text&tr2=1.509&f=h
	- Don't report the space needed by the AG freelists as usable space.

fs/xfs/xfs_mount.c - 1.385 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_mount.c.diff?r1=text&tr1=1.385&r2=text&tr2=1.384&f=h
	- Ensure we don't allocate the space we need for the AG freelists.

fs/xfs/xfs_alloc.h - 1.61 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_alloc.h.diff?r1=text&tr1=1.61&r2=text&tr2=1.60&f=h
	- Move definition of free space needed for AG free lists here.

fs/xfs/xfs_fsops.c - 1.119 - changed
http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_fsops.c.diff?r1=text&tr1=1.119&r2=text&tr2=1.118&f=h
	- Prevent reserve space from using the space we need for AG freelists.
