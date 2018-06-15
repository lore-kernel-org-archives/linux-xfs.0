Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755650AbeFOMQD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 08:16:03 -0400
Date: Fri, 15 Jun 2018 05:16:02 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] xfs: use sync buffer I/O for sync delwri queue
 submission
Message-ID: <20180615121602.GA32099@infradead.org>
References: <20180613110516.65494-1-bfoster@redhat.com>
 <20180613110516.65494-3-bfoster@redhat.com>
 <20180615112820.GB3230@infradead.org>
 <20180615115334.GC2857@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180615115334.GC2857@bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org

On Fri, Jun 15, 2018 at 07:53:35AM -0400, Brian Foster wrote:
> Not totally sure I follow... do you essentially mean to rename
> xfs_buf_submit_wait() -> xfs_buf_submit() and make the iowait
> conditional on !XBF_ASYNC and absence of some new "sync_nowait"
> parameter to the function? Could you clarify how you envision the
> updated xfs_buf_submit() function signature to look?
> 
> If I'm following correctly, that seems fairly reasonable at first
> thought. This is a separate patch though (refactoring the interface vs.
> refactoring the implementation to fix a bug).

Well.  I'd suggest something like the patch below for patch 1:

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 55661cbdb51b..5504525d345b 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1417,28 +1417,33 @@ _xfs_buf_ioapply(
 	blk_finish_plug(&plug);
 }
 
-/*
- * Asynchronous IO submission path. This transfers the buffer lock ownership and
- * the current reference to the IO. It is not safe to reference the buffer after
- * a call to this function unless the caller holds an additional reference
- * itself.
- */
-void
-xfs_buf_submit(
+static int
+xfs_buf_iowait(
 	struct xfs_buf	*bp)
+{
+	trace_xfs_buf_iowait(bp, _RET_IP_);
+	wait_for_completion(&bp->b_iowait);
+	trace_xfs_buf_iowait_done(bp, _RET_IP_);
+	return bp->b_error;
+}
+
+static int
+__xfs_buf_submit(
+	struct xfs_buf	*bp,
+	bool		wait)
 {
 	trace_xfs_buf_submit(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
-	ASSERT(bp->b_flags & XBF_ASYNC);
 
 	/* on shutdown we stale and complete the buffer immediately */
 	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
 		xfs_buf_ioerror(bp, -EIO);
 		bp->b_flags &= ~XBF_DONE;
 		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
-		return;
+		if (!wait)
+			xfs_buf_ioend(bp);
+		return -EIO;
 	}
 
 	if (bp->b_flags & XBF_WRITE)
@@ -1463,7 +1468,8 @@ xfs_buf_submit(
 	 * xfs_buf_ioend too early.
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
-	xfs_buf_ioacct_inc(bp);
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_ioacct_inc(bp);
 	_xfs_buf_ioapply(bp);
 
 	/*
@@ -1472,14 +1478,31 @@ xfs_buf_submit(
 	 * that we don't return to the caller with completion still pending.
 	 */
 	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		if (bp->b_error)
+		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
 			xfs_buf_ioend(bp);
 		else
 			xfs_buf_ioend_async(bp);
 	}
 
+	if (wait)
+		xfs_buf_iowait(bp);
 	xfs_buf_rele(bp);
 	/* Note: it is not safe to reference bp now we've dropped our ref */
+	return 0;
+}
+
+/*
+ * Asynchronous IO submission path. This transfers the buffer lock ownership and
+ * the current reference to the IO. It is not safe to reference the buffer after
+ * a call to this function unless the caller holds an additional reference
+ * itself.
+ */
+void
+xfs_buf_submit(
+	struct xfs_buf	*bp)
+{
+	ASSERT(bp->b_flags & XBF_ASYNC);
+	__xfs_buf_submit(bp, false);
 }
 
 /*
@@ -1489,60 +1512,8 @@ int
 xfs_buf_submit_wait(
 	struct xfs_buf	*bp)
 {
-	int		error;
-
-	trace_xfs_buf_submit_wait(bp, _RET_IP_);
-
-	ASSERT(!(bp->b_flags & (_XBF_DELWRI_Q | XBF_ASYNC)));
-
-	if (XFS_FORCED_SHUTDOWN(bp->b_target->bt_mount)) {
-		xfs_buf_ioerror(bp, -EIO);
-		xfs_buf_stale(bp);
-		bp->b_flags &= ~XBF_DONE;
-		return -EIO;
-	}
-
-	if (bp->b_flags & XBF_WRITE)
-		xfs_buf_wait_unpin(bp);
-
-	/* clear the internal error state to avoid spurious errors */
-	bp->b_io_error = 0;
-
-	/*
-	 * For synchronous IO, the IO does not inherit the submitters reference
-	 * count, nor the buffer lock. Hence we cannot release the reference we
-	 * are about to take until we've waited for all IO completion to occur,
-	 * including any xfs_buf_ioend_async() work that may be pending.
-	 */
-	xfs_buf_hold(bp);
-
-	/*
-	 * Set the count to 1 initially, this will stop an I/O completion
-	 * callout which happens before we have started all the I/O from calling
-	 * xfs_buf_ioend too early.
-	 */
-	atomic_set(&bp->b_io_remaining, 1);
-	_xfs_buf_ioapply(bp);
-
-	/*
-	 * make sure we run completion synchronously if it raced with us and is
-	 * already complete.
-	 */
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend(bp);
-
-	/* wait for completion before gathering the error from the buffer */
-	trace_xfs_buf_iowait(bp, _RET_IP_);
-	wait_for_completion(&bp->b_iowait);
-	trace_xfs_buf_iowait_done(bp, _RET_IP_);
-	error = bp->b_error;
-
-	/*
-	 * all done now, we can release the hold that keeps the buffer
-	 * referenced for the entire IO.
-	 */
-	xfs_buf_rele(bp);
-	return error;
+	ASSERT(!(bp->b_flags & XBF_ASYNC));
+	return __xfs_buf_submit(bp, true);
 }
 
 void *
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8955254b900e..4d3a9adf0ce3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -322,7 +322,6 @@ DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_submit);
-DEFINE_BUF_EVENT(xfs_buf_submit_wait);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_trylock_fail);
