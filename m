Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F7FAC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 02:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357161AbiD0C0Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 22:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357158AbiD0C0O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:14 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 781BB14B671
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:04 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0B5F210E5EFE
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-004yyG-TU
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uv7-S8
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/8] xfs: factor and move some code in xfs_log_cil.c
Date:   Wed, 27 Apr 2022 12:22:56 +1000
Message-Id: <20220427022259.695399-6-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427022259.695399-1-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=bNR77jJvHOTF9d2als0A:9
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
index e5ab62f08c19..0d8d092447ad 100644
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
+	return xlog_item_in_current_chkpt(lip->li_log->l_cilp, lip);
+}
+
 /*
  * Unavoidable forward declaration - xlog_cil_push_work() calls
  * xlog_cil_ctx_alloc() itself.
@@ -934,6 +966,40 @@ xlog_cil_build_trans_hdr(
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
@@ -956,7 +1022,6 @@ xlog_cil_push_work(
 		container_of(work, struct xfs_cil_ctx, push_work);
 	struct xfs_cil		*cil = ctx->cil;
 	struct xlog		*log = cil->xc_log;
-	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
 	int			num_iovecs = 0;
 	int			num_bytes = 0;
@@ -1033,31 +1098,7 @@ xlog_cil_push_work(
 	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 
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
-	struct xfs_cil		*cil = lip->li_log->l_cilp;
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

