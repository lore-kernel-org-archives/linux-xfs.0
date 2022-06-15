Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C367FCCA47B
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343605AbiFOHxk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245659AbiFOHxh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 73F794163A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:35 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 113DA5ECB27
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:33 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRI-PM
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJy5-O6
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/14] xfs: Add order IDs to log items in CIL
Date:   Wed, 15 Jun 2022 17:53:24 +1000
Message-Id: <20220615075330.3651541-9-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=CQLCtQqWn6iW24E7Yj8A:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Before we split the ordered CIL up into per cpu lists, we need a
mechanism to track the order of the items in the CIL. We need to do
this because there are rules around the order in which related items
must physically appear in the log even inside a single checkpoint
transaction.

An example of this is intents - an intent must appear in the log
before it's intent done record so that log recovery can cancel the
intent correctly. If we have these two records misordered in the
CIL, then they will not be recovered correctly by journal replay.

We also will not be able to move items to the tail of
the CIL list when they are relogged, hence the log items will need
some mechanism to allow the correct log item order to be recreated
before we write log items to the hournal.

Hence we need to have a mechanism for recording global order of
transactions in the log items  so that we can recover that order
from un-ordered per-cpu lists.

Do this with a simple monotonic increasing commit counter in the CIL
context. Each log item in the transaction gets stamped with the
current commit order ID before it is added to the CIL. If the item
is already in the CIL, leave it where it is instead of moving it to
the tail of the list and instead sort the list before we start the
push work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 39 +++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_trans.h    |  1 +
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index f02a75d5a03e..6bc540898e3a 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -550,6 +550,7 @@ xlog_cil_insert_items(
 	int			len = 0;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 	int			space_used;
+	int			order;
 	struct xlog_cil_pcp	*cilpcp;
 
 	ASSERT(tp);
@@ -645,23 +646,22 @@ xlog_cil_insert_items(
 	put_cpu_ptr(cilpcp);
 
 	/*
-	 * Now (re-)position everything modified at the tail of the CIL.
+	 * Now update the order of everything modified in the transaction
+	 * and insert items into the CIL if they aren't already there.
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
 	 */
+	order = atomic_inc_return(&ctx->order_id);
 	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
 			continue;
 
-		/*
-		 * Only move the item if it isn't already at the tail. This is
-		 * to prevent a transient list_empty() state when reinserting
-		 * an item that is already the only item in the CIL.
-		 */
-		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
-			list_move_tail(&lip->li_cil, &cil->xc_cil);
+		lip->li_order_id = order;
+		if (!list_empty(&lip->li_cil))
+			continue;
+		list_add_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
 	spin_unlock(&cil->xc_cil_lock);
@@ -1082,6 +1082,26 @@ xlog_cil_build_trans_hdr(
 	tic->t_curr_res -= lvhdr->lv_bytes;
 }
 
+/*
+ * CIL item reordering compare function. We want to order in ascending ID order,
+ * but we want to leave items with the same ID in the order they were added to
+ * the list. This is important for operations like reflink where we log 4 order
+ * dependent intents in a single transaction when we overwrite an existing
+ * shared extent with a new shared extent. i.e. BUI(unmap), CUI(drop),
+ * CUI (inc), BUI(remap)...
+ */
+static int
+xlog_cil_order_cmp(
+	void			*priv,
+	const struct list_head	*a,
+	const struct list_head	*b)
+{
+	struct xfs_log_item	*l1 = container_of(a, struct xfs_log_item, li_cil);
+	struct xfs_log_item	*l2 = container_of(b, struct xfs_log_item, li_cil);
+
+	return l1->li_order_id > l2->li_order_id;
+}
+
 /*
  * Pull all the log vectors off the items in the CIL, and remove the items from
  * the CIL. We don't need the CIL lock here because it's only needed on the
@@ -1101,6 +1121,8 @@ xlog_cil_build_lv_chain(
 {
 	struct xfs_log_vec	*lv = NULL;
 
+	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
+
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
 
@@ -1114,6 +1136,7 @@ xlog_cil_build_lv_chain(
 		}
 
 		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
 		if (!ctx->lv_chain)
 			ctx->lv_chain = item->li_lv;
 		else
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 05a5668d8789..563145ea0f7d 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -229,6 +229,7 @@ struct xfs_cil_ctx {
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
 	struct work_struct	push_work;
+	atomic_t		order_id;
 };
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 9561f193e7e1..29927ceecf82 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -45,6 +45,7 @@ struct xfs_log_item {
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
 	xfs_csn_t			li_seq;		/* CIL commit seq */
+	uint32_t			li_order_id;	/* CIL commit order */
 };
 
 /*
-- 
2.35.1

