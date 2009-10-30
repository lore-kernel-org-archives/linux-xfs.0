Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U9Baom174671 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 04:11:36 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 23DB717FD6E5
	for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:11:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id zBUedoEC6ZkNpDc3 for
	<xfs@oss.sgi.com>; Fri, 30 Oct 2009 02:11:48 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N3nWN-0006u2-Qo
	for xfs@oss.sgi.com; Fri, 30 Oct 2009 09:11:47 +0000
Date: Fri, 30 Oct 2009 05:11:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: cleanup data end I/O handlers
Message-ID: <20091030091147.GB23188@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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


Currently we have various different end I/O handler for read vs the different
types of write I/O.  But they are all very similar so we could just use one
with a few conditionals and reduce code size a lot.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2009-10-30 10:05:46.680256053 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2009-10-30 10:08:54.235024030 +0100
@@ -235,71 +235,36 @@ xfs_setfilesize(
 }
 
 /*
- * Buffered IO write completion for delayed allocate extents.
+ * IO write completion.
  */
 STATIC void
-xfs_end_bio_delalloc(
-	struct work_struct	*work)
-{
-	xfs_ioend_t		*ioend =
-		container_of(work, xfs_ioend_t, io_work);
-
-	xfs_setfilesize(ioend);
-	xfs_destroy_ioend(ioend);
-}
-
-/*
- * Buffered IO write completion for regular, written extents.
- */
-STATIC void
-xfs_end_bio_written(
-	struct work_struct	*work)
-{
-	xfs_ioend_t		*ioend =
-		container_of(work, xfs_ioend_t, io_work);
-
-	xfs_setfilesize(ioend);
-	xfs_destroy_ioend(ioend);
-}
-
-/*
- * IO write completion for unwritten extents.
- *
- * Issue transactions to convert a buffer range from unwritten
- * to written extents.
- */
-STATIC void
-xfs_end_bio_unwritten(
+xfs_end_io(
 	struct work_struct	*work)
 {
 	xfs_ioend_t		*ioend =
 		container_of(work, xfs_ioend_t, io_work);
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
-	xfs_off_t		offset = ioend->io_offset;
-	size_t			size = ioend->io_size;
 
-	if (likely(!ioend->io_error)) {
-		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-			int error;
-			error = xfs_iomap_write_unwritten(ip, offset, size);
-			if (error)
-				ioend->io_error = error;
-		}
-		xfs_setfilesize(ioend);
+	/*
+	 * For unwritten extents we need to issue transactions to convert a
+	 * range to normal written extens after the data I/O has finished.
+	 */
+	if (ioend->io_type == IOMAP_UNWRITTEN &&
+	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
+		int error;
+
+		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
+						 ioend->io_size);
+		if (error)
+			ioend->io_error = error;
 	}
-	xfs_destroy_ioend(ioend);
-}
-
-/*
- * IO read completion for regular, written extents.
- */
-STATIC void
-xfs_end_bio_read(
-	struct work_struct	*work)
-{
-	xfs_ioend_t		*ioend =
-		container_of(work, xfs_ioend_t, io_work);
 
+	/*
+	 * We might have to update the on-disk file size after extending
+	 * writes.
+	 */
+	if (ioend->io_type != IOMAP_READ)
+		xfs_setfilesize(ioend);
 	xfs_destroy_ioend(ioend);
 }
 
@@ -314,10 +279,10 @@ xfs_finish_ioend(
 	int		wait)
 {
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		struct workqueue_struct *wq = xfsdatad_workqueue;
-		if (ioend->io_work.func == xfs_end_bio_unwritten)
-			wq = xfsconvertd_workqueue;
+		struct workqueue_struct *wq;
 
+		wq = (ioend->io_type == IOMAP_UNWRITTEN) ?
+			xfsconvertd_workqueue : xfsdatad_workqueue;
 		queue_work(wq, &ioend->io_work);
 		if (wait)
 			flush_workqueue(wq);
@@ -355,15 +320,7 @@ xfs_alloc_ioend(
 	ioend->io_offset = 0;
 	ioend->io_size = 0;
 
-	if (type == IOMAP_UNWRITTEN)
-		INIT_WORK(&ioend->io_work, xfs_end_bio_unwritten);
-	else if (type == IOMAP_DELAY)
-		INIT_WORK(&ioend->io_work, xfs_end_bio_delalloc);
-	else if (type == IOMAP_READ)
-		INIT_WORK(&ioend->io_work, xfs_end_bio_read);
-	else
-		INIT_WORK(&ioend->io_work, xfs_end_bio_written);
-
+	INIT_WORK(&ioend->io_work, xfs_end_io);
 	return ioend;
 }
 
@@ -1538,7 +1495,7 @@ xfs_end_io_direct(
 		 * didn't map an unwritten extent so switch it's completion
 		 * handler.
 		 */
-		INIT_WORK(&ioend->io_work, xfs_end_bio_written);
+		ioend->io_type = IOMAP_NEW;
 		xfs_finish_ioend(ioend, 0);
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
