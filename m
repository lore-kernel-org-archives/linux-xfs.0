Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABD02C433FC
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95C20206FA
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgFVIQW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:16:22 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:59417 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbgFVIQP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:15 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 827C0109009
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:10 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-00045i-7O
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcb-007d5K-Uo
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Date:   Mon, 22 Jun 2020 18:15:48 +1000
Message-Id: <20200622081605.1818434-14-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=1Txx6-oBkrdBIOE7CJkA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently when a buffer with attached log items has an IO error
it called ->iop_error for each attched log item. These all call
xfs_set_li_failed() to handle the error, but we are about to change
the way log items manage buffers. hence we first need to remove the
per-item dependency on buffer handling done by xfs_set_li_failed().

We already have specific buffer type IO completion routines, so move
the log item error handling out of the generic error handling and
into the log item specific functions so we can implement per-type
error handling easily.

This requires a more complex return value from the error handling
code so that we can take the correct action the failure handling
requires.  This results in some repeated boilerplate in the
functions, but that can be cleaned up later once all the changes
cascade through this code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_buf_item.c | 214 ++++++++++++++++++++++++++++--------------
 1 file changed, 144 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 09bfe9c52dbd..f80fc5bd3bff 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -986,21 +986,24 @@ xfs_buf_do_callbacks_fail(
 	spin_unlock(&ailp->ail_lock);
 }
 
+/*
+ * Decide if we're going to retry the write after a failure, and prepare
+ * the buffer for retrying the write.
+ */
 static bool
-xfs_buf_iodone_callback_error(
+xfs_buf_ioerror_fail_without_retry(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
-	struct xfs_error_cfg	*cfg;
 
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp))
-		goto out_stale;
+		return true;
 
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
@@ -1011,91 +1014,114 @@ xfs_buf_iodone_callback_error(
 
 	/* synchronous writes will have callers process the error */
 	if (!(bp->b_flags & XBF_ASYNC))
-		goto out_stale;
-
-	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
-
-	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+		return true;
+	return false;
+}
 
-	/*
-	 * If the write was asynchronous then no one will be looking for the
-	 * error.  If this is the first failure of this type, clear the error
-	 * state and write the buffer out again. This means we always retry an
-	 * async write failure at least once, but we also need to set the buffer
-	 * up to behave correctly now for repeated failures.
-	 */
-	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
-	     bp->b_last_error != bp->b_error) {
-		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
-		bp->b_last_error = bp->b_error;
-		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
-		    !bp->b_first_retry_time)
-			bp->b_first_retry_time = jiffies;
+static bool
+xfs_buf_ioerror_retry(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
+	if ((bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) &&
+	    bp->b_last_error == bp->b_error)
+		return false;
 
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_submit(bp);
-		return true;
-	}
+	bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
+	bp->b_last_error = bp->b_error;
+	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+	    !bp->b_first_retry_time)
+		bp->b_first_retry_time = jiffies;
+	return true;
+}
 
-	/*
-	 * Repeated failure on an async write. Take action according to the
-	 * error configuration we have been set up to use.
-	 */
+/*
+ * Account for this latest trip around the retry handler, and decide if
+ * we've failed enough times to constitute a permanent failure.
+ */
+static bool
+xfs_buf_ioerror_permanent(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
 	    ++bp->b_retries > cfg->max_retries)
-			goto permanent_error;
+		return true;
 	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
 	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
-			goto permanent_error;
+		return true;
 
 	/* At unmount we may treat errors differently */
 	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
-		goto permanent_error;
-
-	/*
-	 * Still a transient error, run IO completion failure callbacks and let
-	 * the higher layers retry the buffer.
-	 */
-	xfs_buf_do_callbacks_fail(bp);
-	xfs_buf_ioerror(bp, 0);
-	xfs_buf_relse(bp);
-	return true;
+		return true;
 
-	/*
-	 * Permanent error - we need to trigger a shutdown if we haven't already
-	 * to indicate that inconsistency will result from this action.
-	 */
-permanent_error:
-	xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
-out_stale:
-	xfs_buf_stale(bp);
-	bp->b_flags |= XBF_DONE;
-	trace_xfs_buf_error_relse(bp, _RET_IP_);
 	return false;
 }
 
-static inline bool
-xfs_buf_had_callback_errors(
+/*
+ * On a sync write or shutdown we just want to stale the buffer and let the
+ * caller handle the error in bp->b_error appropriately.
+ *
+ * If the write was asynchronous then no one will be looking for the error.  If
+ * this is the first failure of this type, clear the error state and write the
+ * buffer out again. This means we always retry an async write failure at least
+ * once, but we also need to set the buffer up to behave correctly now for
+ * repeated failures.
+ *
+ * If we get repeated async write failures, then we take action according to the
+ * error configuration we have been set up to use.
+ *
+ * Multi-state return value:
+ *
+ * XBF_IOERROR_FINISH: clear IO error retry state and run callback completions
+ * XBF_IOERROR_DONE: resubmitted immediately, do not run any completions
+ * XBF_IOERROR_FAIL: transient error, run failure callback completions and then
+ *    release the buffer
+ */
+enum {
+	XBF_IOERROR_FINISH,
+	XBF_IOERROR_DONE,
+	XBF_IOERROR_FAIL,
+};
+
+static int
+xfs_buf_iodone_error(
 	struct xfs_buf		*bp)
 {
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_error_cfg	*cfg;
 
-	/*
-	 * If there is an error, process it. Some errors require us to run
-	 * callbacks after failure processing is done so we detect that and take
-	 * appropriate action.
-	 */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
-		return true;
+	if (xfs_buf_ioerror_fail_without_retry(bp))
+		goto out_stale;
+
+	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+
+	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	if (xfs_buf_ioerror_retry(bp, cfg)) {
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_submit(bp);
+		return XBF_IOERROR_DONE;
+	}
 
 	/*
-	 * Successful IO or permanent error. Either way, we can clear the
-	 * retry state here in preparation for the next error that may occur.
+	 * Permanent error - we need to trigger a shutdown if we haven't already
+	 * to indicate that inconsistency will result from this action.
 	 */
-	bp->b_last_error = 0;
-	bp->b_retries = 0;
-	bp->b_first_retry_time = 0;
-	return false;
+	if (xfs_buf_ioerror_permanent(bp, cfg)) {
+		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		goto out_stale;
+	}
+
+	/* Still considered a transient error. Caller will schedule retries. */
+	return XBF_IOERROR_FAIL;
+
+out_stale:
+	xfs_buf_stale(bp);
+	bp->b_flags |= XBF_DONE;
+	trace_xfs_buf_error_relse(bp, _RET_IP_);
+	return XBF_IOERROR_FINISH;
 }
 
 static void
@@ -1122,6 +1148,15 @@ xfs_buf_item_done(
 	xfs_buf_rele(bp);
 }
 
+static inline void
+xfs_buf_clear_ioerror_retry_state(
+	struct xfs_buf		*bp)
+{
+	bp->b_last_error = 0;
+	bp->b_retries = 0;
+	bp->b_first_retry_time = 0;
+}
+
 /*
  * Inode buffer iodone callback function.
  */
@@ -1129,9 +1164,22 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+
+		if (ret == XBF_IOERROR_FINISH)
+			goto finish_iodone;
+		if (ret == XBF_IOERROR_DONE)
+			return;
+		ASSERT(ret == XBF_IOERROR_FAIL);
+		xfs_buf_do_callbacks_fail(bp);
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_relse(bp);
 		return;
+	}
 
+finish_iodone:
+	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
@@ -1144,9 +1192,22 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+
+		if (ret == XBF_IOERROR_FINISH)
+			goto finish_iodone;
+		if (ret == XBF_IOERROR_DONE)
+			return;
+		ASSERT(ret == XBF_IOERROR_FAIL);
+		xfs_buf_do_callbacks_fail(bp);
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_relse(bp);
 		return;
+	}
 
+finish_iodone:
+	xfs_buf_clear_ioerror_retry_state(bp);
 	/* a newly allocated dquot buffer might have a log item attached */
 	xfs_buf_item_done(bp);
 	xfs_dquot_done(bp);
@@ -1163,9 +1224,22 @@ void
 xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+
+		if (ret == XBF_IOERROR_FINISH)
+			goto finish_iodone;
+		if (ret == XBF_IOERROR_DONE)
+			return;
+		ASSERT(ret == XBF_IOERROR_FAIL);
+		xfs_buf_do_callbacks_fail(bp);
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_relse(bp);
 		return;
+	}
 
+finish_iodone:
+	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_buf_ioend_finish(bp);
 }
-- 
2.26.2.761.g0e0b3e54be

