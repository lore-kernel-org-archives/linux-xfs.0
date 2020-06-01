Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E1EC433E3
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3987A207BB
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgFAVm5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:42:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:51483 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728546AbgFAVm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:56 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 49426821347
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000Wi-BD
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU5g-2m
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/30] xfs: handle buffer log item IO errors directly
Date:   Tue,  2 Jun 2020 07:42:34 +1000
Message-Id: <20200601214251.4167140-14-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=fCk64Ch_kNl6iE2esdcA:9
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
---
 fs/xfs/xfs_buf_item.c | 167 ++++++++++++++++++++++++++++--------------
 1 file changed, 112 insertions(+), 55 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 09bfe9c52dbdb..b6995719e877b 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -987,20 +987,18 @@ xfs_buf_do_callbacks_fail(
 }
 
 static bool
-xfs_buf_iodone_callback_error(
+xfs_buf_ioerror_sync(
 	struct xfs_buf		*bp)
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
-	struct xfs_error_cfg	*cfg;
-
 	/*
 	 * If we've already decided to shutdown the filesystem because of
 	 * I/O errors, there's no point in giving this a retry.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp))
-		goto out_stale;
+		return true;
 
 	if (bp->b_target != lasttarg ||
 	    time_after(jiffies, (lasttime + 5*HZ))) {
@@ -1011,19 +1009,15 @@ xfs_buf_iodone_callback_error(
 
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
+static bool
+xfs_buf_ioerror_retry(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
 	if (!(bp->b_flags & (XBF_STALE | XBF_WRITE_FAIL)) ||
 	     bp->b_last_error != bp->b_error) {
 		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
@@ -1031,36 +1025,80 @@ xfs_buf_iodone_callback_error(
 		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
 		    !bp->b_first_retry_time)
 			bp->b_first_retry_time = jiffies;
-
-		xfs_buf_ioerror(bp, 0);
-		xfs_buf_submit(bp);
 		return true;
 	}
+	return false;
+}
 
-	/*
-	 * Repeated failure on an async write. Take action according to the
-	 * error configuration we have been set up to use.
-	 */
+static bool
+xfs_buf_ioerror_permanent(
+	struct xfs_buf		*bp,
+	struct xfs_error_cfg	*cfg)
+{
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
 	    ++bp->b_retries > cfg->max_retries)
-			goto permanent_error;
+			return true;
 	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
 	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
-			goto permanent_error;
+			return true;
 
 	/* At unmount we may treat errors differently */
 	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+		return true;
+
+	return false;
+}
+
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
+ * 0: clear IO error retry state and run callback completions
+ * 1: resubmitted immediately, do not run any completions
+ * 2: transient error, run failure callback completions and then
+ *    release the buffer
+ */
+static int
+xfs_buf_iodone_error(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_error_cfg	*cfg;
+
+	if (xfs_buf_ioerror_sync(bp))
+		goto out_stale;
+
+	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
+
+	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	if (xfs_buf_ioerror_retry(bp, cfg)) {
+		xfs_buf_ioerror(bp, 0);
+		xfs_buf_submit(bp);
+		return 1;
+	}
+
+	if (xfs_buf_ioerror_permanent(bp, cfg))
 		goto permanent_error;
 
 	/*
 	 * Still a transient error, run IO completion failure callbacks and let
 	 * the higher layers retry the buffer.
 	 */
-	xfs_buf_do_callbacks_fail(bp);
 	xfs_buf_ioerror(bp, 0);
-	xfs_buf_relse(bp);
-	return true;
+	return 2;
 
 	/*
 	 * Permanent error - we need to trigger a shutdown if we haven't already
@@ -1072,30 +1110,7 @@ xfs_buf_iodone_callback_error(
 	xfs_buf_stale(bp);
 	bp->b_flags |= XBF_DONE;
 	trace_xfs_buf_error_relse(bp, _RET_IP_);
-	return false;
-}
-
-static inline bool
-xfs_buf_had_callback_errors(
-	struct xfs_buf		*bp)
-{
-
-	/*
-	 * If there is an error, process it. Some errors require us to run
-	 * callbacks after failure processing is done so we detect that and take
-	 * appropriate action.
-	 */
-	if (bp->b_error && xfs_buf_iodone_callback_error(bp))
-		return true;
-
-	/*
-	 * Successful IO or permanent error. Either way, we can clear the
-	 * retry state here in preparation for the next error that may occur.
-	 */
-	bp->b_last_error = 0;
-	bp->b_retries = 0;
-	bp->b_first_retry_time = 0;
-	return false;
+	return 0;
 }
 
 static void
@@ -1122,6 +1137,15 @@ xfs_buf_item_done(
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
@@ -1129,9 +1153,20 @@ void
 xfs_buf_inode_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+		if (!ret)
+			goto finish_iodone;
+		if (ret == 1)
+			return;
+		ASSERT(ret == 2);
+		xfs_buf_do_callbacks_fail(bp);
+		xfs_buf_relse(bp);
 		return;
+	}
 
+finish_iodone:
+	xfs_buf_clear_ioerror_retry_state(bp);
 	xfs_buf_item_done(bp);
 	xfs_iflush_done(bp);
 	xfs_buf_ioend_finish(bp);
@@ -1144,9 +1179,20 @@ void
 xfs_buf_dquot_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+		if (!ret)
+			goto finish_iodone;
+		if (ret == 1)
+			return;
+		ASSERT(ret == 2);
+		xfs_buf_do_callbacks_fail(bp);
+		xfs_buf_relse(bp);
 		return;
+	}
 
+finish_iodone:
+	xfs_buf_clear_ioerror_retry_state(bp);
 	/* a newly allocated dquot buffer might have a log item attached */
 	xfs_buf_item_done(bp);
 	xfs_dquot_done(bp);
@@ -1163,9 +1209,20 @@ void
 xfs_buf_iodone(
 	struct xfs_buf		*bp)
 {
-	if (xfs_buf_had_callback_errors(bp))
+	if (bp->b_error) {
+		int ret = xfs_buf_iodone_error(bp);
+		if (!ret)
+			goto finish_iodone;
+		if (ret == 1)
+			return;
+		ASSERT(ret == 2);
+		xfs_buf_do_callbacks_fail(bp);
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

