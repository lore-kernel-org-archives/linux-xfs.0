Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 09 Sep 2007 08:39:51 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l89Fdl4p015134
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 08:39:48 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l89FdlA5020024
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 9 Sep 2007 17:39:47 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l89Fdlwr020022
	for xfs@oss.sgi.com; Sun, 9 Sep 2007 17:39:47 +0200
Date: Sun, 9 Sep 2007 17:39:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill BMAPI_DEVICE
Message-ID: <20070909153947.GA19986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

There is no reason to go into the iomap machinery just to get the
right block device for an inode.  Instead look at the realtime flag
in the inode and grab the right device from the mount structure.

I created a new helper, xfs_find_bdev_for_inode instead of opencoding
it because I plan to use it in other places in the future.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_aops.c	2007-08-23 14:59:55.000000000 +0200
@@ -107,6 +107,18 @@ xfs_page_trace(
 #define xfs_page_trace(tag, inode, page, pgoff)
 #endif
 
+STATIC struct block_device *
+xfs_find_bdev_for_inode(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (ip->i_d.di_flags & XFS_DIFLAG_REALTIME)
+		return mp->m_rtdev_targp->bt_bdev;
+	else
+		return mp->m_ddev_targp->bt_bdev;
+}
+
 /*
  * Schedule IO completion handling on a xfsdatad if this was
  * the final hold on this ioend. If we are asked to wait,
@@ -1476,28 +1488,21 @@ xfs_vm_direct_IO(
 {
 	struct file	*file = iocb->ki_filp;
 	struct inode	*inode = file->f_mapping->host;
-	xfs_iomap_t	iomap;
-	int		maps = 1;
-	int		error;
+	struct block_device *bdev;
 	ssize_t		ret;
 
-	error = xfs_bmap(XFS_I(inode), offset, 0,
-				BMAPI_DEVICE, &iomap, &maps);
-	if (error)
-		return -error;
+	bdev = xfs_find_bdev_for_inode(XFS_I(inode));
 
 	if (rw == WRITE) {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_UNWRITTEN);
 		ret = blockdev_direct_IO_own_locking(rw, iocb, inode,
-			iomap.iomap_target->bt_bdev,
-			iov, offset, nr_segs,
+			bdev, iov, offset, nr_segs,
 			xfs_get_blocks_direct,
 			xfs_end_io_direct);
 	} else {
 		iocb->private = xfs_alloc_ioend(inode, IOMAP_READ);
 		ret = blockdev_direct_IO_no_locking(rw, iocb, inode,
-			iomap.iomap_target->bt_bdev,
-			iov, offset, nr_segs,
+			bdev, iov, offset, nr_segs,
 			xfs_get_blocks_direct,
 			xfs_end_io_direct);
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.c	2007-08-23 14:39:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.c	2007-08-23 14:59:55.000000000 +0200
@@ -193,7 +193,7 @@ xfs_iomap(
 
 	switch (flags &
 		(BMAPI_READ | BMAPI_WRITE | BMAPI_ALLOCATE |
-		 BMAPI_UNWRITTEN | BMAPI_DEVICE)) {
+		 BMAPI_UNWRITTEN)) {
 	case BMAPI_READ:
 		xfs_iomap_enter_trace(XFS_IOMAP_READ_ENTER, io, offset, count);
 		lockmode = XFS_LCK_MAP_SHARED(mp, io);
@@ -220,13 +220,6 @@ xfs_iomap(
 		break;
 	case BMAPI_UNWRITTEN:
 		goto phase2;
-	case BMAPI_DEVICE:
-		lockmode = XFS_LCK_MAP_SHARED(mp, io);
-		iomapp->iomap_target = io->io_flags & XFS_IOCORE_RT ?
-			mp->m_rtdev_targp : mp->m_ddev_targp;
-		error = 0;
-		*niomaps = 1;
-		goto out;
 	default:
 		BUG();
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_iomap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iomap.h	2007-08-23 14:39:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iomap.h	2007-08-23 14:59:55.000000000 +0200
@@ -43,7 +43,6 @@ typedef enum {
 	BMAPI_MMAP = (1 << 6),		/* allocate for mmap write */
 	BMAPI_SYNC = (1 << 7),		/* sync write to flush delalloc space */
 	BMAPI_TRYLOCK = (1 << 8),	/* non-blocking request */
-	BMAPI_DEVICE = (1 << 9),	/* we only want to know the device */
 } bmapi_flags_t;
 
 
