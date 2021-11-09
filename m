Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E5AEC4167D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC7826115B
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241524AbhKIBzf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:35 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58534 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241543AbhKIBzd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:33 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id DCC8246CA78
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006ZaO-8m
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Uj4-7F
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/14] xfs: move CIL ordering to the logvec chain
Date:   Tue,  9 Nov 2021 12:52:37 +1100
Message-Id: <20211109015240.1547991-12-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d46d
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
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
index 31e8a9f15c32..4f9f0a572ae9 100644
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
index aa3a86ca3d25..84924da6396d 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -989,10 +989,10 @@ xlog_cil_order_cmp(
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
@@ -1116,24 +1116,22 @@ xlog_cil_push_work(
 
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
@@ -1166,6 +1164,13 @@ xlog_cil_push_work(
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
2.33.0

