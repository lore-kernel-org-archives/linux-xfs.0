Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1PNBtBs137256 for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 17:11:55 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACD3C1F7C95
	for <xfs@oss.sgi.com>; Thu, 25 Feb 2010 15:13:16 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	zFc51CVSdf4p4GHs for <xfs@oss.sgi.com>;
	Thu, 25 Feb 2010 15:13:16 -0800 (PST)
Date: Fri, 26 Feb 2010 10:06:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH V2] xfs: Non-blocking inode locking in IO completion
Message-ID: <20100225230628.GB18369@discord.disaster>
References: <1266384989-28928-1-git-send-email-david@fromorbit.com>
	<20100217192938.GA14015@infradead.org>
	<20100217211312.GQ28392@discord.disaster>
	<20100218123512.GA6016@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100218123512.GA6016@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, Feb 18, 2010 at 07:35:13AM -0500, Christoph Hellwig wrote:
> On Thu, Feb 18, 2010 at 08:13:12AM +1100, Dave Chinner wrote:
> > > The patch looks good to me - while I hate introducing random delay()
> > > calls I don't really see a way around this. 
> > 
> > I thought about using queue_delayed_work(), but then the change
> > became much bigger and has other side effects like increasing the
> > size of the ioend structure.
> 
> Yes, now that the normal work struct and the delayed work struct are
> different it would be a pain, agreed.

Version with updated commit message below.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: Non-blocking inode locking in IO completion

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
---
 fs/xfs/linux-2.6/xfs_aops.c |   93 ++++++++++++++++++++++++++-----------------
 1 files changed, 56 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_aops.c b/fs/xfs/linux-2.6/xfs_aops.c
index 66abe36..059f159 100644
--- a/fs/xfs/linux-2.6/xfs_aops.c
+++ b/fs/xfs/linux-2.6/xfs_aops.c
@@ -163,14 +163,17 @@ xfs_ioend_new_eof(
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
@@ -181,9 +184,11 @@ xfs_setfilesize(
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
@@ -191,6 +196,28 @@ xfs_setfilesize(
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
@@ -198,11 +225,11 @@ xfs_setfilesize(
  */
 STATIC void
 xfs_end_io(
-	struct work_struct	*work)
+	struct work_struct *work)
 {
-	xfs_ioend_t		*ioend =
-		container_of(work, xfs_ioend_t, io_work);
-	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	xfs_ioend_t	*ioend = container_of(work, xfs_ioend_t, io_work);
+	struct xfs_inode *ip = XFS_I(ioend->io_inode);
+	int		error = 0;
 
 	/*
 	 * For unwritten extents we need to issue transactions to convert a
@@ -210,7 +237,6 @@ xfs_end_io(
 	 */
 	if (ioend->io_type == IOMAP_UNWRITTEN &&
 	    likely(!ioend->io_error && !XFS_FORCED_SHUTDOWN(ip->i_mount))) {
-		int error;
 
 		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
 						 ioend->io_size);
@@ -222,30 +248,23 @@ xfs_end_io(
 	 * We might have to update the on-disk file size after extending
 	 * writes.
 	 */
-	if (ioend->io_type != IOMAP_READ)
-		xfs_setfilesize(ioend);
-	xfs_destroy_ioend(ioend);
-}
-
-/*
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
-		struct workqueue_struct *wq;
-
-		wq = (ioend->io_type == IOMAP_UNWRITTEN) ?
-			xfsconvertd_workqueue : xfsdatad_workqueue;
-		queue_work(wq, &ioend->io_work);
-		if (wait)
-			flush_workqueue(wq);
+	if (ioend->io_type != IOMAP_READ) {
+		error = xfs_setfilesize(ioend);
+		ASSERT(!error || error == EAGAIN);
 	}
+
+	/*
+	 * If we didn't complete processing of the ioend, requeue it to the
+	 * tail of the workqueue for another attempt later. Otherwise destroy
+	 * it.
+	 */
+	if (error == EAGAIN) {
+		atomic_inc(&ioend->io_remaining);
+		xfs_finish_ioend(ioend, 0);
+		/* ensure we don't spin on blocked ioends */
+		delay(1);
+	} else
+		xfs_destroy_ioend(ioend);
 }
 
 /*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
