Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MJPk5u227602 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 14:25:46 -0500
Received: from coco.kroah.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B56D1057B71
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:27:46 -0700 (PDT)
Received: from coco.kroah.org (kroah.org [198.145.64.141]) by cuda.sgi.com
	with ESMTP id fljwCpEHksq9ma38 for <xfs@oss.sgi.com>;
	Thu, 22 Apr 2010 12:27:46 -0700 (PDT)
Message-Id: <20100422190909.720368125@kvm.kroah.org>
Date: Thu, 22 Apr 2010 12:07:57 -0700
From: Greg KH <gregkh@suse.de>
Subject: [026/197] xfs: Non-blocking inode locking in IO completion
In-Reply-To: <20100422191857.GA13268@kroah.com>
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
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: xfs@oss.sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, stable-review@kernel.org, alan@lxorguk.ukuu.org.uk

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Chinner <david@fromorbit.com>

commit 77d7a0c2eeb285c9069e15396703d0cb9690ac50 upstream

The introduction of barriers to loop devices has created a new IO
order completion dependency that XFS does not handle. The loop
device implements barriers using fsync and so turns a log IO in the
XFS filesystem on the loop device into a data IO in the backing
filesystem. That is, the completion of log IOs in the loop
filesystem are now dependent on completion of data IO in the backing
filesystem.

This can cause deadlocks when a flush daemon issues a log force with
an inode locked because the IO completion of IO on the inode is
blocked by the inode lock. This in turn prevents further data IO
completion from occuring on all XFS filesystems on that CPU (due to
the shared nature of the completion queues). This then prevents the
log IO from completing because the log is waiting for data IO
completion as well.

The fix for this new completion order dependency issue is to make
the IO completion inode locking non-blocking. If the inode lock
can't be grabbed, simply requeue the IO completion back to the work
queue so that it can be processed later. This prevents the
completion queue from being blocked and allows data IO completion on
other inodes to proceed, hence avoiding completion order dependent
deadlocks.

Signed-off-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/linux-2.6/xfs_aops.c |  118 ++++++++++++++++++++++++++++++--------------
 1 file changed, 82 insertions(+), 36 deletions(-)

--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -204,14 +204,17 @@ xfs_ioend_new_eof(
 }
 
 /*
- * Update on-disk file size now that data has been written to disk.
- * The current in-memory file size is i_size.  If a write is beyond
- * eof i_new_size will be the intended file size until i_size is
- * updated.  If this write does not extend all the way to the valid
- * file size then restrict this update to the end of the write.
+ * Update on-disk file size now that data has been written to disk.  The
+ * current in-memory file size is i_size.  If a write is beyond eof i_new_size
+ * will be the intended file size until i_size is updated.  If this write does
+ * not extend all the way to the valid file size then restrict this update to
+ * the end of the write.
+ *
+ * This function does not block as blocking on the inode lock in IO completion
+ * can lead to IO completion order dependency deadlocks.. If it can't get the
+ * inode ilock it will return EAGAIN. Callers must handle this.
  */
-
-STATIC void
+STATIC int
 xfs_setfilesize(
 	xfs_ioend_t		*ioend)
 {
@@ -222,9 +225,11 @@ xfs_setfilesize(
 	ASSERT(ioend->io_type != IOMAP_READ);
 
 	if (unlikely(ioend->io_error))
-		return;
+		return 0;
+
+	if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL))
+		return EAGAIN;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_ioend_new_eof(ioend);
 	if (isize) {
 		ip->i_d.di_size = isize;
@@ -232,6 +237,28 @@ xfs_setfilesize(
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Schedule IO completion handling on a xfsdatad if this was
+ * the final hold on this ioend. If we are asked to wait,
+ * flush the workqueue.
+ */
+STATIC void
+xfs_finish_ioend(
+	xfs_ioend_t	*ioend,
+	int		wait)
+{
+	if (atomic_dec_and_test(&ioend->io_remaining)) {
+		struct workqueue_struct *wq;
+
+		wq = (ioend->io_type == IOMAP_UNWRITTEN) ?
+			xfsconvertd_workqueue : xfsdatad_workqueue;
+		queue_work(wq, &ioend->io_work);
+		if (wait)
+			flush_workqueue(wq);
+	}
 }
 
 /*
@@ -243,9 +270,23 @@ xfs_end_bio_delalloc(
 {
 	xfs_ioend_t		*ioend =
 		container_of(work, xfs_ioend_t, io_work);
+	int			error;
 
-	xfs_setfilesize(ioend);
-	xfs_destroy_ioend(ioend);
+	/*
+	 * If we didn't complete processing of the ioend, requeue it to the
+	 * tail of the workqueue for another attempt later. Otherwise destroy
+	 * it.
+	 */
+	error = xfs_setfilesize(ioend);
+	if (error == EAGAIN) {
+		atomic_inc(&ioend->io_remaining);
+		xfs_finish_ioend(ioend, 0);
+		/* ensure we don't spin on blocked ioends */
+		delay(1);
+	} else {
+		ASSERT(!error);
+		xfs_destroy_ioend(ioend);
+	}
 }
 
 /*
@@ -257,9 +298,23 @@ xfs_end_bio_written(
 {
 	xfs_ioend_t		*ioend =
 		container_of(work, xfs_ioend_t, io_work);
+	int			error;
 
-	xfs_setfilesize(ioend);
-	xfs_destroy_ioend(ioend);
+	/*
+	 * If we didn't complete processing of the ioend, requeue it to the
+	 * tail of the workqueue for another attempt later. Otherwise destroy
+	 * it.
+	 */
+	error = xfs_setfilesize(ioend);
+	if (error == EAGAIN) {
+		atomic_inc(&ioend->io_remaining);
+		xfs_finish_ioend(ioend, 0);
+		/* ensure we don't spin on blocked ioends */
+		delay(1);
+	} else {
+		ASSERT(!error);
+		xfs_destroy_ioend(ioend);
+	}
 }
 
 /*
@@ -279,13 +334,25 @@ xfs_end_bio_unwritten(
 	size_t			size = ioend->io_size;
 
 	if (likely(!ioend->io_error)) {
+		int	error;
 		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-			int error;
 			error = xfs_iomap_write_unwritten(ip, offset, size);
 			if (error)
 				ioend->io_error = error;
 		}
-		xfs_setfilesize(ioend);
+		/*
+		 * If we didn't complete processing of the ioend, requeue it to the
+		 * tail of the workqueue for another attempt later. Otherwise destroy
+		 * it.
+		 */
+		error = xfs_setfilesize(ioend);
+		if (error == EAGAIN) {
+			atomic_inc(&ioend->io_remaining);
+			xfs_finish_ioend(ioend, 0);
+			/* ensure we don't spin on blocked ioends */
+			delay(1);
+			return;
+		}
 	}
 	xfs_destroy_ioend(ioend);
 }
@@ -304,27 +371,6 @@ xfs_end_bio_read(
 }
 
 /*
- * Schedule IO completion handling on a xfsdatad if this was
- * the final hold on this ioend. If we are asked to wait,
- * flush the workqueue.
- */
-STATIC void
-xfs_finish_ioend(
-	xfs_ioend_t	*ioend,
-	int		wait)
-{
-	if (atomic_dec_and_test(&ioend->io_remaining)) {
-		struct workqueue_struct *wq = xfsdatad_workqueue;
-		if (ioend->io_work.func == xfs_end_bio_unwritten)
-			wq = xfsconvertd_workqueue;
-
-		queue_work(wq, &ioend->io_work);
-		if (wait)
-			flush_workqueue(wq);
-	}
-}
-
-/*
  * Allocate and initialise an IO completion structure.
  * We need to track unwritten extent write completion here initially.
  * We'll need to extend this for updating the ondisk inode size later


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
