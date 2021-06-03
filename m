Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A984AC4709B
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9276A613E6
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbhFCFZJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:25:09 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:56964 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229826AbhFCFZI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:25:08 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id ED94E105745
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-008MrU-Fp
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-000imm-8F
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 33/39] xfs: Add order IDs to log items in CIL
Date:   Thu,  3 Jun 2021 15:22:34 +1000
Message-Id: <20210603052240.171998-34-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
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
 fs/xfs/xfs_log_cil.c  | 38 ++++++++++++++++++++++++++++++--------
 fs/xfs/xfs_log_priv.h |  1 +
 fs/xfs/xfs_trans.h    |  1 +
 3 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 0baabcd216fe..dd3493058161 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -468,6 +468,7 @@ xlog_cil_insert_items(
 	int			len = 0;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 	int			space_used;
+	int			order;
 	struct xlog_cil_pcp	*cilpcp;
 
 	ASSERT(tp);
@@ -557,10 +558,12 @@ xlog_cil_insert_items(
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
 
@@ -568,13 +571,10 @@ xlog_cil_insert_items(
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
@@ -787,6 +787,26 @@ xlog_cil_build_trans_hdr(
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
@@ -907,6 +927,7 @@ xlog_cil_push_work(
 	 * needed on the transaction commit side which is currently locked out
 	 * by the flush lock.
 	 */
+	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
 	lv = NULL;
 	while (!list_empty(&cil->xc_cil)) {
 		struct xfs_log_item	*item;
@@ -914,6 +935,7 @@ xlog_cil_push_work(
 		item = list_first_entry(&cil->xc_cil,
 					struct xfs_log_item, li_cil);
 		list_del_init(&item->li_cil);
+		item->li_order_id = 0;
 		if (!ctx->lv_chain)
 			ctx->lv_chain = item->li_lv;
 		else
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b80cb3a0edb7..466862a943ba 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -225,6 +225,7 @@ struct xfs_cil_ctx {
 	struct list_head	committing;	/* ctx committing list */
 	struct work_struct	discard_endio_work;
 	struct work_struct	push_work;
+	atomic_t		order_id;
 };
 
 /*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 50da47f23a07..2d1cc1ff93c7 100644
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
2.31.1

