Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E430CCA473
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiFOHxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245299AbiFOHxg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:36 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF6344133A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:34 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 2516510E74EF
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRY-S7
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJyK-R6
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/14] xfs: move CIL ordering to the logvec chain
Date:   Wed, 15 Jun 2022 17:53:27 +1000
Message-Id: <20220615075330.3651541-12-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=kwNYBIauJPz-SwNxrc4A:9 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log_cil.c | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index e7bf3c780cb4..2728886c2963 100644
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
index 0e69e855d710..8bb251d2b4d3 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1095,10 +1095,10 @@ xlog_cil_order_cmp(
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
@@ -1117,8 +1117,6 @@ xlog_cil_build_lv_chain(
 	uint32_t		*num_iovecs,
 	uint32_t		*num_bytes)
 {
-	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
-
 	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
 		struct xfs_log_vec	*lv;
@@ -1133,6 +1131,7 @@ xlog_cil_build_lv_chain(
 		}
 
 		lv = item->li_lv;
+		lv->lv_order_id = item->li_order_id;
 
 		/* we don't write ordered log vectors */
 		if (lv->lv_buf_len != XFS_LOG_VEC_ORDERED)
@@ -1292,6 +1291,13 @@ xlog_cil_push_work(
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
2.35.1

