Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A38C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Mar 2022 05:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiCIFaw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Mar 2022 00:30:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiCIFaw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Mar 2022 00:30:52 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF8BF3DA6F
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 21:29:53 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 58C9353117E
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 16:29:40 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-003H5e-UX
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 16:29:39 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRotH-00BJXk-TK
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 16:29:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/16] xfs: CIL context doesn't need to count iovecs
Date:   Wed,  9 Mar 2022 16:29:37 +1100
Message-Id: <20220309052937.2696447-17-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309052937.2696447-1-david@fromorbit.com>
References: <20220309052937.2696447-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62283b4f
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=gPvcfxenbUqeSasRKroA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we account for log opheaders in the log item formatting
code, we don't actually use the aggregated count of log iovecs in
the CIL for anything. Remove it and the tracking code that
calculates it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_log_cil.c  | 22 ++++++----------------
 fs/xfs/xfs_log_priv.h |  1 -
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f887184c77a4..5179436b6603 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -284,22 +284,18 @@ xlog_cil_alloc_shadow_bufs(
 
 /*
  * Prepare the log item for insertion into the CIL. Calculate the difference in
- * log space and vectors it will consume, and if it is a new item pin it as
- * well.
+ * log space it will consume, and if it is a new item pin it as well.
  */
 STATIC void
 xfs_cil_prepare_item(
 	struct xlog		*log,
 	struct xfs_log_vec	*lv,
 	struct xfs_log_vec	*old_lv,
-	int			*diff_len,
-	int			*diff_iovecs)
+	int			*diff_len)
 {
 	/* Account for the new LV being passed in */
-	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED) {
+	if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 		*diff_len += lv->lv_bytes;
-		*diff_iovecs += lv->lv_niovecs;
-	}
 
 	/*
 	 * If there is no old LV, this is the first time we've seen the item in
@@ -316,7 +312,6 @@ xfs_cil_prepare_item(
 		ASSERT(lv->lv_buf_len != XFS_LOG_VEC_ORDERED);
 
 		*diff_len -= old_lv->lv_bytes;
-		*diff_iovecs -= old_lv->lv_niovecs;
 		lv->lv_item->li_lv_shadow = old_lv;
 	}
 
@@ -365,12 +360,10 @@ static void
 xlog_cil_insert_format_items(
 	struct xlog		*log,
 	struct xfs_trans	*tp,
-	int			*diff_len,
-	int			*diff_iovecs)
+	int			*diff_len)
 {
 	struct xfs_log_item	*lip;
 
-
 	/* Bail out if we didn't find a log item.  */
 	if (list_empty(&tp->t_items)) {
 		ASSERT(0);
@@ -413,7 +406,6 @@ xlog_cil_insert_format_items(
 			 * set the item up as though it is a new insertion so
 			 * that the space reservation accounting is correct.
 			 */
-			*diff_iovecs -= lv->lv_niovecs;
 			*diff_len -= lv->lv_bytes;
 
 			/* Ensure the lv is set up according to ->iop_size */
@@ -438,7 +430,7 @@ xlog_cil_insert_format_items(
 		ASSERT(IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)));
 		lip->li_ops->iop_format(lip, lv);
 insert:
-		xfs_cil_prepare_item(log, lv, old_lv, diff_len, diff_iovecs);
+		xfs_cil_prepare_item(log, lv, old_lv, diff_len);
 	}
 }
 
@@ -458,7 +450,6 @@ xlog_cil_insert_items(
 	struct xfs_cil_ctx	*ctx = cil->xc_ctx;
 	struct xfs_log_item	*lip;
 	int			len = 0;
-	int			diff_iovecs = 0;
 	int			iclog_space;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 
@@ -468,7 +459,7 @@ xlog_cil_insert_items(
 	 * We can do this safely because the context can't checkpoint until we
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
-	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
+	xlog_cil_insert_format_items(log, tp, &len);
 
 	spin_lock(&cil->xc_cil_lock);
 
@@ -503,7 +494,6 @@ xlog_cil_insert_items(
 	}
 	tp->t_ticket->t_curr_res -= len;
 	ctx->space_used += len;
-	ctx->nvecs += diff_iovecs;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 3008c0c884c7..a3981567c42a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -221,7 +221,6 @@ struct xfs_cil_ctx {
 	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
-	int			nvecs;		/* number of regions */
 	int			space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
-- 
2.33.0

