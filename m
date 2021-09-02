Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC9BC4320A
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E488760724
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbhIBKAd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:33 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35576 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233451AbhIBKAd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:33 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D0D0E82ACE5
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIo-Md
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCr-F0
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: factor a move some code in xfs_log_cil.c
Date:   Thu,  2 Sep 2021 19:59:23 +1000
Message-Id: <20210902095927.911100-4-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210902095927.911100-1-david@fromorbit.com>
References: <20210902095927.911100-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=DuwViXhcNxx-DairCVUA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In preparation for adding support for intent item whiteouts.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 109 +++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 9488db6c6b21..bd2c8178255e 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -58,6 +58,38 @@ xlog_cil_set_iclog_hdr_count(struct xfs_cil *cil)
 			(log->l_iclog_size - log->l_iclog_hsize)));
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
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
+		return false;
+
+	/*
+	 * li_seq is written on the first commit of a log item to record the
+	 * first checkpoint it is written to. Hence if it is different to the
+	 * current sequence, we're in a new checkpoint.
+	 */
+	return lip->li_seq == cil->xc_ctx->sequence;
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
@@ -995,6 +1027,37 @@ xlog_cil_order_cmp(
 	return l1->lv_order_id > l2->lv_order_id;
 }
 
+/*
+ * Build a log vector chain from the current CIL.
+ */
+static void
+xlog_cil_build_lv_chain(
+	struct xfs_cil_ctx	*ctx,
+	uint32_t		*num_iovecs,
+	uint32_t		*num_bytes)
+{
+
+	while (!list_empty(&ctx->log_items)) {
+		struct xfs_log_item	*item;
+		struct xfs_log_vec	*lv;
+
+		item = list_first_entry(&ctx->log_items,
+					struct xfs_log_item, li_cil);
+
+		lv = item->li_lv;
+		lv->lv_order_id = item->li_order_id;
+		*num_iovecs += lv->lv_niovecs;
+		/* we don't write ordered log vectors */
+		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
+			*num_bytes += lv->lv_bytes;
+
+		list_add_tail(&lv->lv_list, &ctx->lv_chain);
+		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
+		item->li_lv = NULL;
+	}
+}
+
 /*
  * Push the Committed Item List to the log.
  *
@@ -1017,7 +1080,6 @@ xlog_cil_push_work(
 		container_of(work, struct xfs_cil_ctx, push_work);
 	struct xfs_cil		*cil = ctx->cil;
 	struct xlog		*log = cil->xc_log;
-	struct xfs_log_vec	*lv;
 	struct xfs_cil_ctx	*new_ctx;
 	int			num_iovecs = 0;
 	int			num_bytes = 0;
@@ -1116,24 +1178,7 @@ xlog_cil_push_work(
 				&bdev_flush);
 
 	xlog_cil_pcp_aggregate(cil, ctx);
-
-	while (!list_empty(&ctx->log_items)) {
-		struct xfs_log_item	*item;
-
-		item = list_first_entry(&ctx->log_items,
-					struct xfs_log_item, li_cil);
-		lv = item->li_lv;
-		lv->lv_order_id = item->li_order_id;
-		num_iovecs += lv->lv_niovecs;
-		/* we don't write ordered log vectors */
-		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
-			num_bytes += lv->lv_bytes;
-
-		list_add_tail(&lv->lv_list, &ctx->lv_chain);
-		list_del_init(&item->li_cil);
-		item->li_order_id = 0;
-		item->li_lv = NULL;
-	}
+	xlog_cil_build_lv_chain(ctx, &num_iovecs, &num_bytes);
 
 	/*
 	 * Switch the contexts so we can drop the context lock and move out
@@ -1612,32 +1657,6 @@ xlog_cil_force_seq(
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
-	struct xfs_log_item *lip)
-{
-	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
-
-	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
-		return false;
-
-	/*
-	 * li_seq is written on the first commit of a log item to record the
-	 * first checkpoint it is written to. Hence if it is different to the
-	 * current sequence, we're in a new checkpoint.
-	 */
-	return lip->li_seq == cil->xc_ctx->sequence;
-}
-
 /*
  * Move dead percpu state to the relevant CIL context structures.
  *
-- 
2.31.1

