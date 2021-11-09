Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1ABC433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE8E661159
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241509AbhKIBzd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:33 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49306 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241489AbhKIBzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:31 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C686E1BB27D
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006ZaF-4X
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Uip-2t
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/14] xfs: Add order IDs to log items in CIL
Date:   Tue,  9 Nov 2021 12:52:34 +1100
Message-Id: <20211109015240.1547991-9-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6189d46c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ZhUTVmLJXROoAbz5Ur0A:9 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log_cil.c  | 38 ++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_trans.h    |  1 +
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 32b445a541f7..d07c3cf1b3b7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -475,6 +475,7 @@ xlog_cil_insert_items(
 	int			len = 0;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 	int			space_used;
+	int			order;
 	struct xlog_cil_pcp	*cilpcp;
 
 	ASSERT(tp);
@@ -564,10 +565,12 @@ xlog_cil_insert_items(
 	}
 
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
 
@@ -575,13 +578,10 @@ xlog_cil_insert_items(
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
@@ -977,6 +977,26 @@ xlog_cil_build_trans_hdr(
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
  * Push the Committed Item List to the log.
  *
@@ -1104,6 +1124,7 @@ xlog_cil_push_work(
 	 * needed on the transaction commit side which is currently locked out
 	 * by the flush lock.
 	 */
+	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
 	lv = NULL;
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
@@ -1111,6 +1132,7 @@ xlog_cil_push_work(
 		item = list_first_entry(&cil->xc_cil,
 					struct xfs_log_item, li_cil);
 		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
 		if (!ctx->lv_chain)
 			ctx->lv_chain = item->li_lv;
 		else
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 5150b4a7d086..2b3236ef1f5c 100644
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
index a487b264a9eb..309c0f114e26 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -44,6 +44,7 @@ struct xfs_log_item {
 	struct xfs_log_vec		*li_lv;		/* active log vector */
 	struct xfs_log_vec		*li_lv_shadow;	/* standby vector */
 	xfs_csn_t			li_seq;		/* CIL commit seq */
+	uint32_t			li_order_id;	/* CIL commit order */
 };
 
 /*
-- 
2.33.0

