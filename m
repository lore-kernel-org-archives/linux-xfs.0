Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7O61paI014157 for <xfs@oss.sgi.com>; Wed, 24 Aug 2011 01:01:51 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B4E51397668
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 23:04:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	pOUMvHyadRZ0rDZ1 for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 23:04:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1Qw6X7-0003qd-RA
	for xfs@oss.sgi.com; Wed, 24 Aug 2011 06:01:49 +0000
Message-Id: <20110824060149.777198300@bombadil.infradead.org>
Date: Wed, 24 Aug 2011 01:59:25 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/3] xfs: improve ioend error handling
References: <20110824055924.139283426@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-ioend-error-handling
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Return unwritten extent conversion errors to aio_complete.

Skip both unwritten extent conversion and size updates if we had an I/O error
or the filesystem has been shut down.

Return -EIO to the aio/buffer completion handlers in case of a forced shutdown.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_aops.c	2011-08-23 04:27:32.031551647 +0200
+++ xfs/fs/xfs/xfs_aops.c	2011-08-23 04:35:20.822345321 +0200
@@ -88,8 +88,10 @@ xfs_destroy_ioend(
 	}
 
 	if (ioend->io_iocb) {
-		if (ioend->io_isasync)
-			aio_complete(ioend->io_iocb, ioend->io_result, 0);
+		if (ioend->io_isasync) {
+			aio_complete(ioend->io_iocb, ioend->io_error ?
+					ioend->io_error : ioend->io_result, 0);
+		}
 		inode_dio_done(ioend->io_inode);
 	}
 
@@ -141,9 +143,6 @@ xfs_setfilesize(
 	xfs_inode_t		*ip = XFS_I(ioend->io_inode);
 	xfs_fsize_t		isize;
 
-	if (unlikely(ioend->io_error))
-		return 0;
-
 	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
 		return EAGAIN;
 
@@ -189,17 +188,24 @@ xfs_end_io(
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
 	int		error = 0;
 
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
+		error = -EIO;
+		goto done;
+	}
+	if (ioend->io_error)
+		goto done;
+
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
 	 * range to normal written extens after the data I/O has finished.
 	 */
-	if (ioend->io_type == IO_UNWRITTEN &&
-	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
-
+	if (ioend->io_type == IO_UNWRITTEN) {
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						 ioend->io_size);
-		if (error)
-			ioend->io_error = error;
+		if (error) {
+			ioend->io_error = -error;
+			goto done;
+		}
 	}
 
 	/*
@@ -209,6 +215,7 @@ xfs_end_io(
 	error = xfs_setfilesize(ioend);
 	ASSERT(!error || error == EAGAIN);
 
+done:
 	/*
 	 * If we didn't complete processing of the ioend, requeue it to the
 	 * tail of the workqueue for another attempt later. Otherwise destroy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
