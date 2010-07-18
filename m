Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6ILFLqf165749 for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 16:15:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E7CF15EDA90
	for <xfs@oss.sgi.com>; Sun, 18 Jul 2010 14:18:21 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KN2mnVCUD0Sqv0DG for
	<xfs@oss.sgi.com>; Sun, 18 Jul 2010 14:18:21 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OabFc-0005RF-SE
	for xfs@oss.sgi.com; Sun, 18 Jul 2010 21:18:20 +0000
Message-Id: <20100718211820.739557136@bombadil.infradead.org>
Date: Sun, 18 Jul 2010 17:17:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs simplify and speed up direct I/O completions
References: <20100718211708.327705876@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-unwritten-speedup
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

Our current handling of direct I/O completions is rather suboptimal,
because we defer it to a workqueue more often than needed, and we
perform a much to aggressive flush of the workqueue in case unwritten
extent conversions happen.

This patch changes the direct I/O reads to not even use a completion
handler, as we don't bother to use it at all, and to perform the unwritten
extent conversions in caller context for synchronous direct I/O.

For a small I/O size direct I/O workload on a consumer grade SSD, such as
the untar of a kernel tree inside qemu this patch gives speedups of
about 5%.  Getting us much closer to the speed of a native block device,
or a fully allocated XFS file.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-07-18 22:41:48.896494681 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-07-18 22:46:52.366494681 +0200
@@ -202,23 +202,17 @@ xfs_setfilesize(
 }
 
 /*
- * Schedule IO completion handling on a xfsdatad if this was
- * the final hold on this ioend. If we are asked to wait,
- * flush the workqueue.
+ * Schedule IO completion handling on the final put of an ioend.
  */
 STATIC void
 xfs_finish_ioend(
-	xfs_ioend_t	*ioend,
-	int		wait)
+	struct xfs_ioend	*ioend)
 {
 	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		struct workqueue_struct *wq;
-
-		wq = (ioend->io_type == IO_UNWRITTEN) ?
-			xfsconvertd_workqueue : xfsdatad_workqueue;
-		queue_work(wq, &ioend->io_work);
-		if (wait)
-			flush_workqueue(wq);
+		if (ioend->io_type == IO_UNWRITTEN)
+			queue_work(xfsconvertd_workqueue, &ioend->io_work);
+		else
+			queue_work(xfsdatad_workqueue, &ioend->io_work);
 	}
 }
 
@@ -262,7 +256,7 @@ xfs_end_io(
 	 */
 	if (error == EAGAIN) {
 		atomic_inc(&ioend->io_remaining);
-		xfs_finish_ioend(ioend, 0);
+		xfs_finish_ioend(ioend);
 		/* ensure we don't spin on blocked ioends */
 		delay(1);
 	} else {
@@ -273,6 +267,17 @@ xfs_end_io(
 }
 
 /*
+ * Call IO completion handling in caller context on the final put of an ioend.
+ */
+STATIC void
+xfs_finish_ioend_sync(
+	struct xfs_ioend	*ioend)
+{
+	if (atomic_dec_and_test(&ioend->io_remaining))
+		xfs_end_io(&ioend->io_work);
+}
+
+/*
  * Allocate and initialise an IO completion structure.
  * We need to track unwritten extent write completion here initially.
  * We'll need to extend this for updating the ondisk inode size later
@@ -353,7 +358,7 @@ xfs_end_bio(
 	bio->bi_end_io = NULL;
 	bio_put(bio);
 
-	xfs_finish_ioend(ioend, 0);
+	xfs_finish_ioend(ioend);
 }
 
 STATIC void
@@ -495,7 +500,7 @@ xfs_submit_ioend(
 		}
 		if (bio)
 			xfs_submit_ioend_bio(wbc, ioend, bio);
-		xfs_finish_ioend(ioend, 0);
+		xfs_finish_ioend(ioend);
 	} while ((ioend = next) != NULL);
 }
 
@@ -1406,70 +1411,56 @@ xfs_get_blocks_direct(
 	return __xfs_get_blocks(inode, iblock, bh_result, create, 1);
 }
 
+/*
+ * Complete a direct I/O write request.
+ *
+ * If the private argument is non-NULL __xfs_get_blocks signals us that we
+ * need to issue a transaction to convert the range from unwritten to written
+ * extents.  In case this is regular synchronous I/O we just call xfs_end_io
+ * to do this and we are done.  But in case this was a successfull AIO
+ * request this handler is called from interrupt context, from which we
+ * can't start transactions.  In that case offload the I/O completion to
+ * the workqueues we also use for buffered I/O completion.
+ */
 STATIC void
-xfs_end_io_direct(
-	struct kiocb	*iocb,
-	loff_t		offset,
-	ssize_t		size,
-	void		*private,
-	int		ret,
-	bool		is_async)
+xfs_end_io_direct_write(
+	struct kiocb		*iocb,
+	loff_t			offset,
+	ssize_t			size,
+	void			*private,
+	int			ret,
+	bool			is_async)
 {
-	xfs_ioend_t	*ioend = iocb->private;
-	bool		complete_aio = is_async;
+	struct xfs_ioend	*ioend = iocb->private;
 
 	/*
-	 * Non-NULL private data means we need to issue a transaction to
-	 * convert a range from unwritten to written extents.  This needs
-	 * to happen from process context but aio+dio I/O completion
-	 * happens from irq context so we need to defer it to a workqueue.
-	 * This is not necessary for synchronous direct I/O, but we do
-	 * it anyway to keep the code uniform and simpler.
-	 *
-	 * Well, if only it were that simple. Because synchronous direct I/O
-	 * requires extent conversion to occur *before* we return to userspace,
-	 * we have to wait for extent conversion to complete. Look at the
-	 * iocb that has been passed to us to determine if this is AIO or
-	 * not. If it is synchronous, tell xfs_finish_ioend() to kick the
-	 * workqueue and wait for it to complete.
-	 *
-	 * The core direct I/O code might be changed to always call the
-	 * completion handler in the future, in which case all this can
-	 * go away.
+	 * blockdev_direct_IO can return an error even after the I/O
+	 * completion handler was called.  Thus we need to protect
+	 * against double-freeing.
 	 */
+	iocb->private = NULL;
+
 	ioend->io_offset = offset;
 	ioend->io_size = size;
-	if (ioend->io_type == IO_READ) {
-		xfs_finish_ioend(ioend, 0);
-	} else if (private && size > 0) {
-		if (is_async) {
+	if (private && size > 0)
+		ioend->io_type = IO_UNWRITTEN;
+
+	if (is_async) {
+		/*
+		 * If we are converting an unwritten extent we need to delay
+		 * the AIO completion until after the unwrittent extent
+		 * conversion has completed, otherwise do it ASAP.
+		 */
+		if (ioend->io_type == IO_UNWRITTEN) {
 			ioend->io_iocb = iocb;
 			ioend->io_result = ret;
-			complete_aio = false;
-			xfs_finish_ioend(ioend, 0);
 		} else {
-			xfs_finish_ioend(ioend, 1);
+			aio_complete(iocb, ret, 0);
 		}
+		xfs_finish_ioend(ioend);
 	} else {
-		/*
-		 * A direct I/O write ioend starts it's life in unwritten
-		 * state in case they map an unwritten extent.  This write
-		 * didn't map an unwritten extent so switch it's completion
-		 * handler.
-		 */
-		ioend->io_type = IO_NEW;
-		xfs_finish_ioend(ioend, 0);
+		xfs_finish_ioend_sync(ioend);
 	}
-
-	/*
-	 * blockdev_direct_IO can return an error even after the I/O
-	 * completion handler was called.  Thus we need to protect
-	 * against double-freeing.
-	 */
-	iocb->private = NULL;
-
-	if (complete_aio)
-		aio_complete(iocb, ret, 0);
 }
 
 STATIC ssize_t
@@ -1480,23 +1471,26 @@ xfs_vm_direct_IO(
 	loff_t			offset,
 	unsigned long		nr_segs)
 {
-	struct file	*file = iocb->ki_filp;
-	struct inode	*inode = file->f_mapping->host;
-	struct block_device *bdev;
-	ssize_t		ret;
-
-	bdev = xfs_find_bdev_for_inode(inode);
-
-	iocb->private = xfs_alloc_ioend(inode, rw == WRITE ?
-					IO_UNWRITTEN : IO_READ);
-
-	ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
-					    offset, nr_segs,
-					    xfs_get_blocks_direct,
-					    xfs_end_io_direct);
+	struct inode		*inode = iocb->ki_filp->f_mapping->host;
+	struct block_device	*bdev = xfs_find_bdev_for_inode(inode);
+	ssize_t			ret;
+
+	if (rw & WRITE) {
+		iocb->private = xfs_alloc_ioend(inode, IO_NEW);
+
+		ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
+						    offset, nr_segs,
+						    xfs_get_blocks_direct,
+						    xfs_end_io_direct_write);
+		if (ret != -EIOCBQUEUED && iocb->private)
+			xfs_destroy_ioend(iocb->private);
+	} else {
+		ret = blockdev_direct_IO_no_locking(rw, iocb, inode, bdev, iov,
+						    offset, nr_segs,
+						    xfs_get_blocks_direct,
+						    NULL);
+	}
 
-	if (unlikely(ret != -EIOCBQUEUED && iocb->private))
-		xfs_destroy_ioend(iocb->private);
 	return ret;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
