Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53068 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755252AbeFNNnI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Jun 2018 09:43:08 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 77C1F738E7
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 13:43:07 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 617962023450
        for <linux-xfs@vger.kernel.org>; Thu, 14 Jun 2018 13:43:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 1/2] xfs: refactor buffer submission into a common helper
Date: Thu, 14 Jun 2018 09:43:07 -0400
Message-Id: <20180614134307.26868-1-bfoster@redhat.com>
In-Reply-To: <20180613110516.65494-2-bfoster@redhat.com>
References: <20180613110516.65494-2-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Sync and async buffer submission both do generally similar things
with a couple odd exceptions. Refactor the core buffer submission
code into a common helper to isolate buffer submission from
completion handling of synchronous buffer I/O.

This patch does not change behavior. It is a step towards support
for using synchronous buffer I/O via synchronous delwri queue
submission.

Designed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
---

v3:
- Leave tracepoint in __xfs_buf_submit and kill
  trace_xfs_buf_submit_wait().

 fs/xfs/xfs_buf.c   | 85 ++++++++++++++++++++--------------------------
 fs/xfs/xfs_trace.h |  1 -
 2 files changed, 37 insertions(+), 49 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e9c058e3761c..7b0f7c79cd62 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1458,22 +1458,20 @@ _xfs_buf_ioapply(
  * a call to this function unless the caller holds an additional reference
  * itself.
  */
-void
-xfs_buf_submit(
+static int
+__xfs_buf_submit(
 	struct xfs_buf	*bp)
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
+		return -EIO;
 	}
 
 	if (bp->b_flags & XBF_WRITE)
@@ -1482,23 +1480,14 @@ xfs_buf_submit(
 	/* clear the internal error state to avoid spurious errors */
 	bp->b_io_error = 0;
 
-	/*
-	 * The caller's reference is released during I/O completion.
-	 * This occurs some time after the last b_io_remaining reference is
-	 * released, so after we drop our Io reference we have to have some
-	 * other reference to ensure the buffer doesn't go away from underneath
-	 * us. Take a direct reference to ensure we have safe access to the
-	 * buffer until we are finished with it.
-	 */
-	xfs_buf_hold(bp);
-
 	/*
 	 * Set the count to 1 initially, this will stop an I/O completion
 	 * callout which happens before we have started all the I/O from calling
 	 * xfs_buf_ioend too early.
 	 */
 	atomic_set(&bp->b_io_remaining, 1);
-	xfs_buf_ioacct_inc(bp);
+	if (bp->b_flags & XBF_ASYNC)
+		xfs_buf_ioacct_inc(bp);
 	_xfs_buf_ioapply(bp);
 
 	/*
@@ -1507,14 +1496,39 @@ xfs_buf_submit(
 	 * that we don't return to the caller with completion still pending.
 	 */
 	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		if (bp->b_error)
+		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
 			xfs_buf_ioend(bp);
 		else
 			xfs_buf_ioend_async(bp);
 	}
 
-	xfs_buf_rele(bp);
+	return 0;
+}
+
+void
+xfs_buf_submit(
+	struct xfs_buf	*bp)
+{
+	int		error;
+
+	ASSERT(bp->b_flags & XBF_ASYNC);
+
+	/*
+	 * The caller's reference is released during I/O completion.
+	 * This occurs some time after the last b_io_remaining reference is
+	 * released, so after we drop our Io reference we have to have some
+	 * other reference to ensure the buffer doesn't go away from underneath
+	 * us. Take a direct reference to ensure we have safe access to the
+	 * buffer until we are finished with it.
+	 */
+	xfs_buf_hold(bp);
+
+	error = __xfs_buf_submit(bp);
+	if (error)
+		xfs_buf_ioend(bp);
+
 	/* Note: it is not safe to reference bp now we've dropped our ref */
+	xfs_buf_rele(bp);
 }
 
 /*
@@ -1526,22 +1540,7 @@ xfs_buf_submit_wait(
 {
 	int		error;
 
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
+	ASSERT(!(bp->b_flags & XBF_ASYNC));
 
 	/*
 	 * For synchronous IO, the IO does not inherit the submitters reference
@@ -1551,20 +1550,9 @@ xfs_buf_submit_wait(
 	 */
 	xfs_buf_hold(bp);
 
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
+	error = __xfs_buf_submit(bp);
+	if (error)
+		goto out;
 
 	/* wait for completion before gathering the error from the buffer */
 	trace_xfs_buf_iowait(bp, _RET_IP_);
@@ -1572,6 +1560,7 @@ xfs_buf_submit_wait(
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 	error = bp->b_error;
 
+out:
 	/*
 	 * all done now, we can release the hold that keeps the buffer
 	 * referenced for the entire IO.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 972d45d28097..c2d2e513d722 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -310,7 +310,6 @@ DEFINE_BUF_EVENT(xfs_buf_hold);
 DEFINE_BUF_EVENT(xfs_buf_rele);
 DEFINE_BUF_EVENT(xfs_buf_iodone);
 DEFINE_BUF_EVENT(xfs_buf_submit);
-DEFINE_BUF_EVENT(xfs_buf_submit_wait);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
 DEFINE_BUF_EVENT(xfs_buf_trylock_fail);
-- 
2.17.1

