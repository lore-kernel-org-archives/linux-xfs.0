Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F24C7FAD
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 07:34:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F8518F8035
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2014 05:34:51 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	cwp9ZMbRyhZerw88 for <xfs@oss.sgi.com>;
	Thu, 25 Sep 2014 05:34:48 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1XX8Fb-0006nH-Vp
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:24 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1XX8Fb-0007gy-UY
	for xfs@oss.sgi.com; Thu, 25 Sep 2014 22:34:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/11] xfs: introduce xfs_buf_submit[_wait]
Date: Thu, 25 Sep 2014 22:34:19 +1000
Message-Id: <1411648461-29003-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1411648461-29003-1-git-send-email-david@fromorbit.com>
References: <1411648461-29003-1-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

There is a lot of cookie-cutter code that looks like:

	if (shutdown)
		handle buffer error
	xfs_buf_iorequest(bp)
	error = xfs_buf_iowait(bp)
	if (error)
		handle buffer error

spread through XFS. There's significant complexity now in
xfs_buf_iorequest() to specifically handle this sort of synchronous
IO pattern, but there's all sorts of nasty surprises in different
error handling code dependent on who owns the buffer references and
the locks.

Pull this pattern into a single helper, where we can hide all the
synchronous IO warts and hence make the error handling for all the
callers much saner. This removes the need for a special extra
reference to protect IO completion processing, as we can now hold a
single reference across dispatch and waiting, simplifying the sync
IO smeantics and error handling.

In doing this, also rename xfs_buf_iorequest to xfs_buf_submit and
make it explicitly handle on asynchronous IO. This forces all users
to be switched specifically to one interface or the other and
removes any ambiguity between how the interfaces are to be used. It
also means that xfs_buf_iowait() goes away.

For the special case of delwri buffer submission and waiting, we
don't need to issue IO synchronously at all. The second pass to cal
xfs_buf_iowait() can now just block on xfs_buf_lock() - the buffer
will be unlocked when the async IO is complete. This formalises a
sane the method of waiting for async IO - take an extra reference,
submit the IO, call xfs_buf_lock() when you want to wait for IO
completion. i.e.:

	bp = xfs_buf_find();
	xfs_buf_hold(bp);
	bp->b_flags |= XBF_ASYNC;
	xfs_buf_iosubmit(bp);
	xfs_buf_lock(bp)
	error = bp->b_error;
	....
	xfs_buf_relse(bp);

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_bmap_util.c   |  14 +---
 fs/xfs/xfs_buf.c         | 169 ++++++++++++++++++++++++++---------------------
 fs/xfs/xfs_buf.h         |   4 +-
 fs/xfs/xfs_buf_item.c    |   4 +-
 fs/xfs/xfs_log.c         |   2 +-
 fs/xfs/xfs_log_recover.c |  30 ++++-----
 fs/xfs/xfs_trace.h       |   3 +-
 fs/xfs/xfs_trans_buf.c   |  19 +-----
 8 files changed, 117 insertions(+), 128 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d8b77b5..41d9488 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1157,12 +1157,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_READ(bp);
 		XFS_BUF_SET_ADDR(bp, xfs_fsb_to_db(ip, imap.br_startblock));
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = -EIO;
-			break;
-		}
-		xfs_buf_iorequest(bp);
-		error = xfs_buf_iowait(bp);
+		error = xfs_buf_submit_wait(bp);
 		if (error) {
 			xfs_buf_ioerror_alert(bp,
 					"xfs_zero_remaining_bytes(read)");
@@ -1175,12 +1170,7 @@ xfs_zero_remaining_bytes(
 		XFS_BUF_UNREAD(bp);
 		XFS_BUF_WRITE(bp);
 
-		if (XFS_FORCED_SHUTDOWN(mp)) {
-			error = -EIO;
-			break;
-		}
-		xfs_buf_iorequest(bp);
-		error = xfs_buf_iowait(bp);
+		error = xfs_buf_submit_wait(bp);
 		if (error) {
 			xfs_buf_ioerror_alert(bp,
 					"xfs_zero_remaining_bytes(write)");
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4696ff5..d1d3fe6 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -623,10 +623,11 @@ _xfs_buf_read(
 	bp->b_flags &= ~(XBF_WRITE | XBF_ASYNC | XBF_READ_AHEAD);
 	bp->b_flags |= flags & (XBF_READ | XBF_ASYNC | XBF_READ_AHEAD);
 
-	xfs_buf_iorequest(bp);
-	if (flags & XBF_ASYNC)
+	if (flags & XBF_ASYNC) {
+		xfs_buf_submit(bp);
 		return 0;
-	return xfs_buf_iowait(bp);
+	}
+	return xfs_buf_submit_wait(bp);
 }
 
 xfs_buf_t *
@@ -708,12 +709,7 @@ xfs_buf_read_uncached(
 	bp->b_flags |= XBF_READ;
 	bp->b_ops = ops;
 
-	if (XFS_FORCED_SHUTDOWN(target->bt_mount)) {
-		xfs_buf_relse(bp);
-		return NULL;
-	}
-	xfs_buf_iorequest(bp);
-	xfs_buf_iowait(bp);
+	xfs_buf_submit_wait(bp);
 	return bp;
 }
 
@@ -1028,12 +1024,8 @@ xfs_buf_ioend(
 		(*(bp->b_iodone))(bp);
 	else if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_relse(bp);
-	else {
+	else
 		complete(&bp->b_iowait);
-
-		/* release the !XBF_ASYNC ref now we are done. */
-		xfs_buf_rele(bp);
-	}
 }
 
 static void
@@ -1086,21 +1078,7 @@ xfs_bwrite(
 	bp->b_flags &= ~(XBF_ASYNC | XBF_READ | _XBF_DELWRI_Q |
 			 XBF_WRITE_FAIL | XBF_DONE);
 
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-		trace_xfs_bdstrat_shut(bp, _RET_IP_);
-
-		xfs_buf_ioerror(bp, -EIO);
-		xfs_buf_stale(bp);
-
-		/* sync IO, xfs_buf_ioend is going to remove a ref here */
-		xfs_buf_hold(bp);
-		xfs_buf_ioend(bp);
-		return -EIO;
-	}
-
-	xfs_buf_iorequest(bp);
-
-	error = xfs_buf_iowait(bp);
+	error = xfs_buf_submit_wait(bp);
 	if (error) {
 		xfs_force_shutdown(bp->b_target->bt_mount,
 				   SHUTDOWN_META_IO_ERROR);
@@ -1209,7 +1187,7 @@ next_chunk:
 	} else {
 		/*
 		 * This is guaranteed not to be the last io reference count
-		 * because the caller (xfs_buf_iorequest) holds a count itself.
+		 * because the caller (xfs_buf_submit) holds a count itself.
 		 */
 		atomic_dec(&bp->b_io_remaining);
 		xfs_buf_ioerror(bp, -EIO);
@@ -1299,13 +1277,29 @@ _xfs_buf_ioapply(
 	blk_finish_plug(&plug);
 }
 
+/*
+ * Asynchronous IO submission path. This transfers the buffer lock ownership and
+ * the current reference to the IO. It is not safe to reference the buffer after
+ * a call to this function unless the caller holds an additional reference
+ * itself.
+ */
 void
-xfs_buf_iorequest(
-	xfs_buf_t		*bp)
+xfs_buf_submit(
+	struct xfs_buf	*bp)
 {
-	trace_xfs_buf_iorequest(bp, _RET_IP_);
+	trace_xfs_buf_submit(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
+	ASSERT(bp->b_flags & XBF_ASYNC);
+
+	/* on shutdown we stale and complete the buffer immediately */
+	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		xfs_buf_ioerror(bp, -EIO);
+		bp->b_flags &= ~XBF_DONE;
+		xfs_buf_stale(bp);
+		xfs_buf_ioend(bp);
+		return;
+	}
 
 	if (bp->b_flags & XBF_WRITE)
 		xfs_buf_wait_unpin(bp);
@@ -1314,25 +1308,14 @@ xfs_buf_iorequest(
 	bp->b_io_error = 0;
 
 	/*
-	 * Take references to the buffer. For XBF_ASYNC buffers, holding a
-	 * reference for as long as submission takes is all that is necessary
-	 * here. The IO inherits the lock and hold count from the submitter,
-	 * and these are release during IO completion processing. Taking a hold
-	 * over submission ensures that the buffer is not freed until we have
-	 * completed all processing, regardless of when IO errors occur or are
-	 * reported.
-	 *
-	 * However, for synchronous IO, the IO does not inherit the submitters
-	 * reference count, nor the buffer lock. Hence we need to take an extra
-	 * reference to the buffer for the for the IO context so that we can
-	 * guarantee the buffer is not freed until all IO completion processing
-	 * is done. Otherwise the caller can drop their reference while the IO
-	 * is still in progress and hence trigger a use-after-free situation.
+	 * The caller's reference is released during I/O completion.
+	 * This occurs some time after the last b_io_remaining reference is
+	 * released, so after we drop our Io reference we have to have some
+	 * other reference to ensure the buffer doesn't go away from underneath
+	 * us. Take a direct reference to ensure we have safe access to the
+	 * buffer until we are finished with it.
 	 */
 	xfs_buf_hold(bp);
-	if (!(bp->b_flags & XBF_ASYNC))
-		xfs_buf_hold(bp);
-
 
 	/*
 	 * Set the count to 1 initially, this will stop an I/O completion
@@ -1343,40 +1326,82 @@ xfs_buf_iorequest(
 	_xfs_buf_ioapply(bp);
 
 	/*
-	 * If _xfs_buf_ioapply failed or we are doing synchronous IO that
-	 * completes extremely quickly, we can get back here with only the IO
-	 * reference we took above. If we drop it to zero, run completion
-	 * processing synchronously so that we don't return to the caller with
-	 * completion still pending. This avoids unnecessary context switches
-	 * associated with the end_io workqueue.
+	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
+	 * reference we took above. If we drop it to zero, run completion so
+	 * that we don't return to the caller with completion still pending.
 	 */
 	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
+		if (bp->b_error)
 			xfs_buf_ioend(bp);
 		else
 			xfs_buf_ioend_async(bp);
 	}
 
 	xfs_buf_rele(bp);
+	/* Note: it is not safe to reference bp now we've dropped our ref */
 }
 
 /*
- * Waits for I/O to complete on the buffer supplied.  It returns immediately if
- * no I/O is pending or there is already a pending error on the buffer, in which
- * case nothing will ever complete.  It returns the I/O error code, if any, or
- * 0 if there was no error.
+ * Synchronous buffer IO submission path, read or write.
  */
 int
-xfs_buf_iowait(
-	xfs_buf_t		*bp)
+xfs_buf_submit_wait(
+	struct xfs_buf	*bp)
 {
-	trace_xfs_buf_iowait(bp, _RET_IP_);
+	int		error;
 
-	if (!bp->b_error)
-		wait_for_completion(&bp->b_iowait);
+	trace_xfs_buf_submit_wait(bp, _RET_IP_);
+
+	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
 
+	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+		xfs_buf_ioerror(bp, -EIO);
+		xfs_buf_stale(bp);
+		bp->b_flags &= ~XBF_DONE;
+		return -EIO;
+	}
+
+	if (bp->b_flags & XBF_WRITE)
+		xfs_buf_wait_unpin(bp);
+
+	/* clear the internal error state to avoid spurious errors */
+	bp->b_io_error = 0;
+
+	/*
+	 * For synchronous IO, the IO does not inherit the submitters reference
+	 * count, nor the buffer lock. Hence we cannot release the reference we
+	 * are about to take until we've waited for all IO completion to occur,
+	 * including any xfs_buf_ioend_async() work that may be pending.
+	 */
+	xfs_buf_hold(bp);
+
+	/*
+	 * Set the count to 1 initially, this will stop an I/O completion
+	 * callout which happens before we have started all the I/O from calling
+	 * xfs_buf_ioend too early.
+	 */
+	atomic_set(&bp->b_io_remaining, 1);
+	_xfs_buf_ioapply(bp);
+
+	/*
+	 * make sure we run completion synchronously if it raced with us and is
+	 * already complete.
+	 */
+	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
+		xfs_buf_ioend(bp);
+
+	/* wait for completion before gathering the error from the buffer */
+	trace_xfs_buf_iowait(bp, _RET_IP_);
+	wait_for_completion(&bp->b_iowait);
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
-	return bp->b_error;
+	error = bp->b_error;
+
+	/*
+	 * all done now, we can release the hold that keeps the buffer
+	 * referenced for the entire IO.
+	 */
+	xfs_buf_rele(bp);
+	return error;
 }
 
 xfs_caddr_t
@@ -1782,15 +1807,7 @@ __xfs_buf_delwri_submit(
 		else
 			list_del_init(&bp->b_list);
 
-		if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-			trace_xfs_bdstrat_shut(bp, _RET_IP_);
-
-			xfs_buf_ioerror(bp, -EIO);
-			xfs_buf_stale(bp);
-			xfs_buf_ioend(bp);
-			continue;
-		}
-		xfs_buf_iorequest(bp);
+		xfs_buf_submit(bp);
 	}
 	blk_finish_plug(&plug);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d8f57f6..0acfc30 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -290,8 +290,8 @@ extern int xfs_bwrite(struct xfs_buf *bp);
 extern void xfs_buf_ioend(struct xfs_buf *bp);
 extern void xfs_buf_ioerror(xfs_buf_t *, int);
 extern void xfs_buf_ioerror_alert(struct xfs_buf *, const char *func);
-extern void xfs_buf_iorequest(xfs_buf_t *);
-extern int xfs_buf_iowait(xfs_buf_t *);
+extern void xfs_buf_submit(struct xfs_buf *bp);
+extern int xfs_buf_submit_wait(struct xfs_buf *bp);
 extern void xfs_buf_iomove(xfs_buf_t *, size_t, size_t, void *,
 				xfs_buf_rw_t);
 #define xfs_buf_zero(bp, off, len) \
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 3916384..f159695 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1081,7 +1081,7 @@ xfs_buf_iodone_callbacks(
 	 * a way to shut the filesystem down if the writes keep failing.
 	 *
 	 * In practice we'll shut the filesystem down soon as non-transient
-	 * erorrs tend to affect the whole device and a failing log write
+	 * errors tend to affect the whole device and a failing log write
 	 * will make us give up.  But we really ought to do better here.
 	 */
 	if (XFS_BUF_ISASYNC(bp)) {
@@ -1094,7 +1094,7 @@ xfs_buf_iodone_callbacks(
 		if (!(bp->b_flags & (XBF_STALE|XBF_WRITE_FAIL))) {
 			bp->b_flags |= XBF_WRITE | XBF_ASYNC |
 				       XBF_DONE | XBF_WRITE_FAIL;
-			xfs_buf_iorequest(bp);
+			xfs_buf_submit(bp);
 		} else {
 			xfs_buf_relse(bp);
 		}
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b5170e5..ed4845f 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1699,7 +1699,7 @@ xlog_bdstrat(
 		return 0;
 	}
 
-	xfs_buf_iorequest(bp);
+	xfs_buf_submit(bp);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 02ad115..c6427b3 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -193,12 +193,8 @@ xlog_bread_noalign(
 	bp->b_io_length = nbblks;
 	bp->b_error = 0;
 
-	if (XFS_FORCED_SHUTDOWN(log->l_mp))
-		return -EIO;
-
-	xfs_buf_iorequest(bp);
-	error = xfs_buf_iowait(bp);
-	if (error)
+	error = xfs_buf_submit_wait(bp);
+	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
 		xfs_buf_ioerror_alert(bp, __func__);
 	return error;
 }
@@ -378,9 +374,11 @@ xlog_recover_iodone(
 		 * We're not going to bother about retrying
 		 * this during recovery. One strike!
 		 */
-		xfs_buf_ioerror_alert(bp, __func__);
-		xfs_force_shutdown(bp->b_target->bt_mount,
-					SHUTDOWN_META_IO_ERROR);
+		if (!XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
+			xfs_buf_ioerror_alert(bp, __func__);
+			xfs_force_shutdown(bp->b_target->bt_mount,
+						SHUTDOWN_META_IO_ERROR);
+		}
 	}
 	bp->b_iodone = NULL;
 	xfs_buf_ioend(bp);
@@ -4400,16 +4398,12 @@ xlog_do_recover(
 	XFS_BUF_UNASYNC(bp);
 	bp->b_ops = &xfs_sb_buf_ops;
 
-	if (XFS_FORCED_SHUTDOWN(log->l_mp)) {
-		xfs_buf_relse(bp);
-		return -EIO;
-	}
-
-	xfs_buf_iorequest(bp);
-	error = xfs_buf_iowait(bp);
+	error = xfs_buf_submit_wait(bp);
 	if (error) {
-		xfs_buf_ioerror_alert(bp, __func__);
-		ASSERT(0);
+		if (!XFS_FORCED_SHUTDOWN(log->l_mp)) {
+			xfs_buf_ioerror_alert(bp, __func__);
+			ASSERT(0);
+		}
 		xfs_buf_relse(bp);
 		return error;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 152f827..51372e3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -349,7 +349,8 @@ DEFINE_BUF_EVENT(xfs_buf_free);
 DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
-DEFINE_BUF_EVENT(xfs_buf_iorequest);
+DEFINE_BUF_EVENT(xfs_buf_submit);
+DEFINE_BUF_EVENT(xfs_buf_submit_wait);
 DEFINE_BUF_EVENT(xfs_buf_bawrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index db4be5b..e2b2216 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -318,23 +318,10 @@ xfs_trans_read_buf_map(
 			XFS_BUF_READ(bp);
 			bp->b_ops = ops;
 
-			/*
-			 * XXX(hch): clean up the error handling here to be less
-			 * of a mess..
-			 */
-			if (XFS_FORCED_SHUTDOWN(mp)) {
-				trace_xfs_bdstrat_shut(bp, _RET_IP_);
-				bp->b_flags &= ~(XBF_READ | XBF_DONE);
-				xfs_buf_ioerror(bp, -EIO);
-				xfs_buf_stale(bp);
-				xfs_buf_relse(bp);
-				return -EIO;
-			}
-
-			xfs_buf_iorequest(bp);
-			error = xfs_buf_iowait(bp);
+			error = xfs_buf_submit_wait(bp);
 			if (error) {
-				xfs_buf_ioerror_alert(bp, __func__);
+				if (!XFS_FORCED_SHUTDOWN(mp))
+					xfs_buf_ioerror_alert(bp, __func__);
 				xfs_buf_relse(bp);
 				/*
 				 * We can gracefully recover from most read
-- 
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
