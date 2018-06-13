Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935205AbeFMLFR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jun 2018 07:05:17 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CED344022414
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 11:05:16 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B951F210C6DC
        for <linux-xfs@vger.kernel.org>; Wed, 13 Jun 2018 11:05:16 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 1/2] xfs: refactor buffer submission into a common helper
Date: Wed, 13 Jun 2018 07:05:15 -0400
Message-Id: <20180613110516.65494-2-bfoster@redhat.com>
In-Reply-To: <20180613110516.65494-1-bfoster@redhat.com>
References: <20180613110516.65494-1-bfoster@redhat.com>
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
 fs/xfs/xfs_buf.c | 86 +++++++++++++++++++++---------------------------
 1 file changed, 38 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e9c058e3761c..112999ddb75e 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1458,22 +1458,18 @@ _xfs_buf_ioapply(
  * a call to this function unless the caller holds an additional reference
  * itself.
  */
-void
-xfs_buf_submit(
+static int
+__xfs_buf_submit(
 	struct xfs_buf	*bp)
 {
-	trace_xfs_buf_submit(bp, _RET_IP_);
-
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
@@ -1482,23 +1478,14 @@ xfs_buf_submit(
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
@@ -1507,14 +1494,40 @@ xfs_buf_submit(
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
+	trace_xfs_buf_submit(bp, _RET_IP_);
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
@@ -1528,20 +1541,7 @@ xfs_buf_submit_wait(
 
 	trace_xfs_buf_submit_wait(bp, _RET_IP_);
 
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
@@ -1551,20 +1551,9 @@ xfs_buf_submit_wait(
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
@@ -1572,6 +1561,7 @@ xfs_buf_submit_wait(
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
 	error = bp->b_error;
 
+out:
 	/*
 	 * all done now, we can release the hold that keeps the buffer
 	 * referenced for the entire IO.
-- 
2.17.1

