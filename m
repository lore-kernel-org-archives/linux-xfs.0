Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B997CC4709E
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F730613F2
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhFCFZK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:25:10 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:46692 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229789AbhFCFZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:25:10 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1AEC16824E
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:52 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-008Mre-Ja
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-000imv-C4
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 36/39] xfs: move CIL ordering to the logvec chain
Date:   Thu,  3 Jun 2021 15:22:37 +1000
Message-Id: <20210603052240.171998-37-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=CAXtJn9xtY6DaSJ1L1YA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Adding a list_sort() call to the CIL push work while the xc_ctx_lock
is held exclusively has resulted in fairly long lock hold times and
that stops all front end transaction commits from making progress.

We can move the sorting out of the xc_ctx_lock if we can transfer
the ordering information to the log vectors as they are detached
from the log items and then we can sort the log vectors.  With these
changes, we can move the list_sort() call to just before we call
xlog_write() when we aren't holding any locks at all.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.h     |  1 +
 fs/xfs/xfs_log_cil.c | 23 ++++++++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index b4ad0e37a0c5..93aaee7c276e 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -10,6 +10,7 @@ struct xfs_cil_ctx;
 
 struct xfs_log_vec {
 	struct list_head	lv_list;	/* CIL lv chain ptrs */
+	uint32_t		lv_order_id;	/* chain ordering info */
 	int			lv_niovecs;	/* number of iovecs in lv */
 	struct xfs_log_iovec	*lv_iovecp;	/* iovec array */
 	struct xfs_log_item	*lv_item;	/* owner */
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 65910fca652f..21384474715f 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -798,10 +798,10 @@ xlog_cil_order_cmp(
 	const struct list_head	*a,
 	const struct list_head	*b)
 {
-	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
-	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
+	struct xfs_log_vec	*l1 = container_of(a, struct xfs_log_vec, lv_list);
+	struct xfs_log_vec	*l2 = container_of(b, struct xfs_log_vec, lv_list);
 
-	return l1->li_order_id > l2->li_order_id;
+	return l1->lv_order_id > l2->lv_order_id;
 }
 
 /*
@@ -918,24 +918,22 @@ xlog_cil_push_work(
 
 	xlog_cil_pcp_aggregate(cil, ctx);
 
-	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
 	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
 
 		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
 		lv = item->li_lv;
-		list_del_init(&item->li_cil);
-		item->li_order_id = 0;
-		item->li_lv = NULL;
-
+		lv->lv_order_id = item->li_order_id;
 		num_iovecs += lv->lv_niovecs;
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
 			num_bytes += lv->lv_bytes;
 
 		list_add_tail(&lv->lv_list, &ctx->lv_chain);
-
+		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
+		item->li_lv = NULL;
 	}
 
 	/*
@@ -968,6 +966,13 @@ xlog_cil_push_work(
 	spin_unlock(&cil->xc_push_lock);
 	up_write(&cil->xc_ctx_lock);
 
+	/*
+	 * Sort the log vector chain before we add the transaction headers.
+	 * This ensures we always have the transaction headers at the start
+	 * of the chain.
+	 */
+	list_sort(NULL, &ctx->lv_chain, xlog_cil_order_cmp);
+
 	/*
 	 * Build a checkpoint transaction header and write it to the log to
 	 * begin the transaction. We need to account for the space used by the
-- 
2.31.1

