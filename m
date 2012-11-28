Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAS1x2TF121956 for <xfs@oss.sgi.com>; Tue, 27 Nov 2012 19:59:02 -0600
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	OTGjnuTDRtHuxG8q for <xfs@oss.sgi.com>;
	Tue, 27 Nov 2012 18:01:17 -0800 (PST)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1TdWxf-0003zU-Qk
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:15 +1100
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1TdWxV-0000SJ-Lg
	for xfs@oss.sgi.com; Wed, 28 Nov 2012 13:01:05 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/4] xfs: fix direct IO nested transaction deadlock.
Date: Wed, 28 Nov 2012 13:01:00 +1100
Message-Id: <1354068063-1692-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1354068063-1692-1-git-send-email-david@fromorbit.com>
References: <1354068063-1692-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

The direct IO path can do a nested transaction reservation when
writing past the EOF. The first transaction is the append
transaction for setting the filesize at IO completion, but we can
also need a transaction for allocation of blocks. If the log is low
on space due to reservations and small log, the append transaction
can be granted after wating for space as the only active transaction
in the system. This then attempts a reservation for an allocation,
which there isn't space in the log for, and the reservation sleeps.
The result is that there is nothing left in the system to wake up
all the processes waiting for log space to come free.

The stack trace that shows this deadlock is relatively innocuous:

 xlog_grant_head_wait
 xlog_grant_head_check
 xfs_log_reserve
 xfs_trans_reserve
 xfs_iomap_write_direct
 __xfs_get_blocks
 xfs_get_blocks_direct
 do_blockdev_direct_IO
 __blockdev_direct_IO
 xfs_vm_direct_IO
 generic_file_direct_write
 xfs_file_dio_aio_writ
 xfs_file_aio_write
 do_sync_write
 vfs_write

This was discovered on a filesystem with a log of only 10MB, and a
log stripe unit of 256k whih increased the base reservations by
512k. Hence a allocation transaction requires 1.2MB of log space to
be available instead of only 260k, and so greatly increased the
chance that there wouldn't be enough log space available for the
nested transaction to succeed. The key to reproducing it is this
mkfs command:

mkfs.xfs -f -d agcount=16,su=256k,sw=12 -l su=256k,size=2560b $SCRATCH_DEV

The test case was a 1000 fsstress processes running with random
freeze and unfreezes every few seconds. Thanks to Eryu Guan
(eguan@redhat.com) for writing the test that found this on a system
with a somewhat unique default configuration....

cc: <stable@vger.kernel.org>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c |   81 +++++++++++++++++++----------------------------------
 fs/xfs/xfs_log.c  |    3 +-
 2 files changed, 31 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 71361da..4111a40 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -124,7 +124,7 @@ xfs_setfilesize_trans_alloc(
 	ioend->io_append_trans = tp;
 
 	/*
-	 * We will pass freeze protection with a transaction.  So tell lockdep
+	 * We may pass freeze protection with a transaction.  So tell lockdep
 	 * we released it.
 	 */
 	rwsem_release(&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
@@ -149,11 +149,13 @@ xfs_setfilesize(
 	xfs_fsize_t		isize;
 
 	/*
-	 * The transaction was allocated in the I/O submission thread,
-	 * thus we need to mark ourselves as beeing in a transaction
-	 * manually.
+	 * The transaction may have been allocated in the I/O submission thread,
+	 * thus we need to mark ourselves as beeing in a transaction manually.
+	 * Similarly for freeze protection.
 	 */
 	current_set_flags_nested(&tp->t_pflags, PF_FSTRANS);
+	rwsem_acquire_read(&VFS_I(ip)->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
+			   0, 1, _THIS_IP_);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	isize = xfs_new_eof(ip, ioend->io_offset + ioend->io_size);
@@ -187,7 +189,8 @@ xfs_finish_ioend(
 
 		if (ioend->io_type == XFS_IO_UNWRITTEN)
 			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
-		else if (ioend->io_append_trans)
+		else if (ioend->io_append_trans ||
+			 (ioend->io_isdirect && xfs_ioend_is_append(ioend)))
 			queue_work(mp->m_data_workqueue, &ioend->io_work);
 		else
 			xfs_destroy_ioend(ioend);
@@ -205,15 +208,6 @@ xfs_end_io(
 	struct xfs_inode *ip = XFS_I(ioend->io_inode);
 	int		error = 0;
 
-	if (ioend->io_append_trans) {
-		/*
-		 * We've got freeze protection passed with the transaction.
-		 * Tell lockdep about it.
-		 */
-		rwsem_acquire_read(
-			&ioend->io_inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
-			0, 1, _THIS_IP_);
-	}
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		ioend->io_error = -EIO;
 		goto done;
@@ -226,35 +220,31 @@ xfs_end_io(
 	 * range to normal written extens after the data I/O has finished.
 	 */
 	if (ioend->io_type == XFS_IO_UNWRITTEN) {
+		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
+						  ioend->io_size);
+	} else if (ioend->io_isdirect && xfs_ioend_is_append(ioend)) {
 		/*
-		 * For buffered I/O we never preallocate a transaction when
-		 * doing the unwritten extent conversion, but for direct I/O
-		 * we do not know if we are converting an unwritten extent
-		 * or not at the point where we preallocate the transaction.
+		 * For direct I/O we do not know if we need to allocate blocks
+		 * or not so we can't preallocate an append transaction as that
+		 * results in nested reservations and log space deadlocks. Hence
+		 * allocate the transaction here. While this is sub-optimal and
+		 * can block IO completion for some time, we're stuck with doing
+		 * it this way until we can pass the ioend to the direct IO
+		 * allocation callbacks and avoid nesting that way.
 		 */
-		if (ioend->io_append_trans) {
-			ASSERT(ioend->io_isdirect);
-
-			current_set_flags_nested(
-				&ioend->io_append_trans->t_pflags, PF_FSTRANS);
-			xfs_trans_cancel(ioend->io_append_trans, 0);
-		}
-
-		error = xfs_iomap_write_unwritten(ip, ioend->io_offset,
-						 ioend->io_size);
-		if (error) {
-			ioend->io_error = -error;
+		error = xfs_setfilesize_trans_alloc(ioend);
+		if (error)
 			goto done;
-		}
+		error = xfs_setfilesize(ioend);
 	} else if (ioend->io_append_trans) {
 		error = xfs_setfilesize(ioend);
-		if (error)
-			ioend->io_error = -error;
 	} else {
 		ASSERT(!xfs_ioend_is_append(ioend));
 	}
 
 done:
+	if (error)
+		ioend->io_error = -error;
 	xfs_destroy_ioend(ioend);
 }
 
@@ -1432,25 +1422,21 @@ xfs_vm_direct_IO(
 		size_t size = iov_length(iov, nr_segs);
 
 		/*
-		 * We need to preallocate a transaction for a size update
-		 * here.  In the case that this write both updates the size
-		 * and converts at least on unwritten extent we will cancel
-		 * the still clean transaction after the I/O has finished.
+		 * We cannot preallocate a size update transaction here as we
+		 * don't know whether allocation is necessary or not. Hence we
+		 * can only tell IO completion that one is necessary if we are
+		 * not doing unwritten extent conversion.
 		 */
 		iocb->private = ioend = xfs_alloc_ioend(inode, XFS_IO_DIRECT);
-		if (offset + size > XFS_I(inode)->i_d.di_size) {
-			ret = xfs_setfilesize_trans_alloc(ioend);
-			if (ret)
-				goto out_destroy_ioend;
+		if (offset + size > XFS_I(inode)->i_d.di_size)
 			ioend->io_isdirect = 1;
-		}
 
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
 					    xfs_get_blocks_direct,
 					    xfs_end_io_direct_write, NULL, 0);
 		if (ret != -EIOCBQUEUED && iocb->private)
-			goto out_trans_cancel;
+			goto out_destroy_ioend;
 	} else {
 		ret = __blockdev_direct_IO(rw, iocb, inode, bdev, iov,
 					    offset, nr_segs,
@@ -1460,15 +1446,6 @@ xfs_vm_direct_IO(
 
 	return ret;
 
-out_trans_cancel:
-	if (ioend->io_append_trans) {
-		current_set_flags_nested(&ioend->io_append_trans->t_pflags,
-					 PF_FSTRANS);
-		rwsem_acquire_read(
-			&inode->i_sb->s_writers.lock_map[SB_FREEZE_FS-1],
-			0, 1, _THIS_IP_);
-		xfs_trans_cancel(ioend->io_append_trans, 0);
-	}
 out_destroy_ioend:
 	xfs_destroy_ioend(ioend);
 	return ret;
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c6d6e13..c49e2c1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -460,7 +460,8 @@ xfs_log_reserve(
 	tic->t_trans_type = t_type;
 	*ticp = tic;
 
-	xlog_grant_push_ail(log, tic->t_unit_res * tic->t_cnt);
+	xlog_grant_push_ail(log, tic->t_cnt ? tic->t_unit_res * tic->t_cnt
+					    : tic->t_unit_res);
 
 	trace_xfs_log_reserve(log, tic);
 
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
