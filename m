Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9051C43219
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Mar 2022 22:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245482AbiCNWIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Mar 2022 18:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245480AbiCNWHs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Mar 2022 18:07:48 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D94ED3DA63
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 15:06:37 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7B7B710E417D
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 09:06:34 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nTspl-005W6L-KK
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 09:06:33 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nTspl-00CyiX-JO
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 09:06:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Date:   Tue, 15 Mar 2022 09:06:28 +1100
Message-Id: <20220314220631.3093283-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314220631.3093283-1-david@fromorbit.com>
References: <20220314220631.3093283-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=622fbc6a
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=PG9pAWaIsfS1tTKE14sA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In preparation for adding support for intent item whiteouts.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 119 ++++++++++++++++++++++++-------------------
 1 file changed, 67 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 5179436b6603..dda71f1a25c5 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -47,6 +47,38 @@ xlog_cil_ticket_alloc(
 	return tic;
 }
 
+/*
+ * Check if the current log item was first committed in this sequence.
+ * We can't rely on just the log item being in the CIL, we have to check
+ * the recorded commit sequence number.
+ *
+ * Note: for this to be used in a non-racy manner, it has to be called with
+ * CIL flushing locked out. As a result, it should only be used during the
+ * transaction commit process when deciding what to format into the item.
+ */
+static bool
+xlog_item_in_current_chkpt(
+	struct xfs_cil		*cil,
+	struct xfs_log_item	*lip)
+{
+	if (list_empty(&lip->li_cil))
+		return false;
+
+	/*
+	 * li_seq is written on the first commit of a log item to record the
+	 * first checkpoint it is written to. Hence if it is different to the
+	 * current sequence, we're in a new checkpoint.
+	 */
+	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
+}
+
+bool
+xfs_log_item_in_current_chkpt(
+	struct xfs_log_item *lip)
+{
+	return xlog_item_in_current_chkpt(lip->li_mountp->m_log->l_cilp, lip);
+}
+
 /*
  * Unavoidable forward declaration - xlog_cil_push_work() calls
  * xlog_cil_ctx_alloc() itself.
@@ -924,6 +956,40 @@ xlog_cil_build_trans_hdr(
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
+/*
+ * Pull all the log vectors off the items in the CIL, and remove the items from
+ * the CIL. We don't need the CIL lock here because it's only needed on the
+ * transaction commit side which is currently locked out by the flush lock.
+ */
+static void
+xlog_cil_build_lv_chain(
+	struct xfs_cil		*cil,
+	struct xfs_cil_ctx	*ctx,
+	uint32_t		*num_iovecs,
+	uint32_t		*num_bytes)
+{
+	struct xfs_log_vec	*lv = NULL;
+
+	while (!list_empty(&cil->xc_cil)) {
+		struct xfs_log_item	*item;
+
+		item = list_first_entry(&cil->xc_cil,
+					struct xfs_log_item, li_cil);
+		list_del_init(&item->li_cil);
+		if (!ctx->lv_chain)
+			ctx->lv_chain = item->li_lv;
+		else
+			lv->lv_next = item->li_lv;
+		lv = item->li_lv;
+		item->li_lv = NULL;
+		*num_iovecs += lv->lv_niovecs;
+
+		/* we don't write ordered log vectors */
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+			*num_bytes += lv->lv_bytes;
+	}
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -946,7 +1012,6 @@ xlog_cil_push_work(
 		container_of(work, struct xfs_cil_ctx, push_work);
 	struct xfs_cil		*cil = ctx->cil;
 	struct xlog		*log = cil->xc_log;
-	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
 	int			num_iovecs = 0;
 	int			num_bytes = 0;
@@ -1043,31 +1108,7 @@ xlog_cil_push_work(
 	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
 				&bdev_flush);
 
-	/*
-	 * Pull all the log vectors off the items in the CIL, and remove the
-	 * items from the CIL. We don't need the CIL lock here because it's only
-	 * needed on the transaction commit side which is currently locked out
-	 * by the flush lock.
-	 */
-	lv = NULL;
-	while (!list_empty(&cil->xc_cil)) {
-		struct xfs_log_item	*item;
-
-		item = list_first_entry(&cil->xc_cil,
-					struct xfs_log_item, li_cil);
-		list_del_init(&item->li_cil);
-		if (!ctx->lv_chain)
-			ctx->lv_chain = item->li_lv;
-		else
-			lv->lv_next = item->li_lv;
-		lv = item->li_lv;
-		item->li_lv = NULL;
-		num_iovecs += lv->lv_niovecs;
-
-		/* we don't write ordered log vectors */
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
-			num_bytes += lv->lv_bytes;
-	}
+	xlog_cil_build_lv_chain(cil, ctx, &num_iovecs, &num_bytes);
 
 	/*
 	 * Switch the contexts so we can drop the context lock and move out
@@ -1508,32 +1549,6 @@ xlog_cil_force_seq(
 	return 0;
 }
 
-/*
- * Check if the current log item was first committed in this sequence.
- * We can't rely on just the log item being in the CIL, we have to check
- * the recorded commit sequence number.
- *
- * Note: for this to be used in a non-racy manner, it has to be called with
- * CIL flushing locked out. As a result, it should only be used during the
- * transaction commit process when deciding what to format into the item.
- */
-bool
-xfs_log_item_in_current_chkpt(
-	struct xfs_log_item	*lip)
-{
-	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
-
-	if (list_empty(&lip->li_cil))
-		return false;
-
-	/*
-	 * li_seq is written on the first commit of a log item to record the
-	 * first checkpoint it is written to. Hence if it is different to the
-	 * current sequence, we're in a new checkpoint.
-	 */
-	return lip->li_seq == READ_ONCE(cil->xc_current_sequence);
-}
-
 /*
  * Perform initial CIL structure initialisation.
  */
-- 
2.35.1

