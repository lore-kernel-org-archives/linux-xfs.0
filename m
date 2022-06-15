Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0850C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243638AbiFOHxq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244091AbiFOHxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:40 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 045F14133A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id AE39E10E74FE
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rRR-QD
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJyA-PF
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/14] xfs: convert CIL to unordered per cpu lists
Date:   Wed, 15 Jun 2022 17:53:25 +1000
Message-Id: <20220615075330.3651541-10-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=LeOBFmjP2KjtsCjRVtEA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

So that we can remove the cil_lock which is a global serialisation
point. We've already got ordering sorted, so all we need to do is
treat the CIL list like the busy extent list and reconstruct it
before the push starts.

This is what we're trying to avoid:

 -   75.35%     1.83%  [kernel]            [k] xfs_log_commit_cil
    - 46.35% xfs_log_commit_cil
       - 41.54% _raw_spin_lock
          - 67.30% do_raw_spin_lock
               66.96% __pv_queued_spin_lock_slowpath

Which happens on a 32p system when running a 32-way 'rm -rf'
workload. After this patch:

-   20.90%     3.23%  [kernel]               [k] xfs_log_commit_cil
   - 17.67% xfs_log_commit_cil
      - 6.51% xfs_log_ticket_ungrant
           1.40% xfs_log_space_wake
        2.32% memcpy_erms
      - 2.18% xfs_buf_item_committing
         - 2.12% xfs_buf_item_release
            - 1.03% xfs_buf_unlock
                 0.96% up
              0.72% xfs_buf_rele
        1.33% xfs_inode_item_format
        1.19% down_read
        0.91% up_read
        0.76% xfs_buf_item_format
      - 0.68% kmem_alloc_large
         - 0.67% kmem_alloc
              0.64% __kmalloc
        0.50% xfs_buf_item_size

It kinda looks like the workload is running out of log space all
the time. But all the spinlock contention is gone and the
transaction commit rate has gone from 800k/s to 1.3M/s so the amount
of real work being done has gone up a *lot*.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 35 ++++++++++++++++-------------------
 fs/xfs/xfs_log_priv.h |  3 +--
 2 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 6bc540898e3a..a0792b8db38b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -104,6 +104,7 @@ xlog_cil_ctx_alloc(void)
 	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	INIT_LIST_HEAD(&ctx->log_items);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
 	return ctx;
 }
@@ -132,6 +133,8 @@ xlog_cil_push_pcp_aggregate(
 			list_splice_init(&cilpcp->busy_extents,
 					&ctx->busy_extents);
 		}
+		if (!list_empty(&cilpcp->log_items))
+			list_splice_init(&cilpcp->log_items, &ctx->log_items);
 
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
@@ -579,10 +582,9 @@ xlog_cil_insert_items(
 	/*
 	 * We need to take the CIL checkpoint unit reservation on the first
 	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
-	 * unnecessarily do an atomic op in the fast path here. We don't need to
-	 * hold the xc_cil_lock here to clear the XLOG_CIL_EMPTY bit as we are
-	 * under the xc_ctx_lock here and that needs to be held exclusively to
-	 * reset the XLOG_CIL_EMPTY bit.
+	 * unnecessarily do an atomic op in the fast path here. We can clear the
+	 * XLOG_CIL_EMPTY bit as we are under the xc_ctx_lock here and that
+	 * needs to be held exclusively to reset the XLOG_CIL_EMPTY bit.
 	 */
 	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
 	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
@@ -643,7 +645,6 @@ xlog_cil_insert_items(
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
-	put_cpu_ptr(cilpcp);
 
 	/*
 	 * Now update the order of everything modified in the transaction
@@ -652,7 +653,6 @@ xlog_cil_insert_items(
 	 * the transaction commit.
 	 */
 	order = atomic_inc_return(&ctx->order_id);
-	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
@@ -661,10 +661,9 @@ xlog_cil_insert_items(
 		lip->li_order_id = order;
 		if (!list_empty(&lip->li_cil))
 			continue;
-		list_add_tail(&lip->li_cil, &cil->xc_cil);
+		list_add_tail(&lip->li_cil, &cilpcp->log_items);
 	}
-
-	spin_unlock(&cil->xc_cil_lock);
+	put_cpu_ptr(cilpcp);
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
@@ -1113,7 +1112,6 @@ xlog_cil_order_cmp(
  */
 static void
 xlog_cil_build_lv_chain(
-	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx,
 	struct list_head	*whiteouts,
 	uint32_t		*num_iovecs,
@@ -1121,12 +1119,12 @@ xlog_cil_build_lv_chain(
 {
 	struct xfs_log_vec	*lv = NULL;
 
-	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
+	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
 
-	while (!list_empty(&cil->xc_cil)) {
+	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
 
-		item = list_first_entry(&cil->xc_cil,
+		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
 
 		if (test_bit(XFS_LI_WHITEOUT, &item->li_flags)) {
@@ -1265,7 +1263,7 @@ xlog_cil_push_work(
 	list_add(&ctx->committing, &cil->xc_committing);
 	spin_unlock(&cil->xc_push_lock);
 
-	xlog_cil_build_lv_chain(cil, ctx, &whiteouts, &num_iovecs, &num_bytes);
+	xlog_cil_build_lv_chain(ctx, &whiteouts, &num_iovecs, &num_bytes);
 
 	/*
 	 * Switch the contexts so we can drop the context lock and move out
@@ -1409,7 +1407,6 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there.
 	 */
-	ASSERT(!list_empty(&cil->xc_cil));
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
@@ -1656,7 +1653,7 @@ xlog_cil_flush(
 	 * If the CIL is empty, make sure that any previous checkpoint that may
 	 * still be in an active iclog is pushed to stable storage.
 	 */
-	if (list_empty(&log->l_cilp->xc_cil))
+	if (test_bit(XLOG_CIL_EMPTY, &log->l_cilp->xc_flags))
 		xfs_log_force(log->l_mp, 0);
 }
 
@@ -1784,6 +1781,8 @@ xlog_cil_pcp_dead(
 		ctx->ticket->t_curr_res += cilpcp->space_reserved;
 	cilpcp->space_reserved = 0;
 
+	if (!list_empty(&cilpcp->log_items))
+		list_splice_init(&cilpcp->log_items, &ctx->log_items);
 	if (!list_empty(&cilpcp->busy_extents))
 		list_splice_init(&cilpcp->busy_extents, &ctx->busy_extents);
 	atomic_add(cilpcp->space_used, &ctx->space_used);
@@ -1824,11 +1823,10 @@ xlog_cil_init(
 	for_each_possible_cpu(cpu) {
 		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
 		INIT_LIST_HEAD(&cilpcp->busy_extents);
+		INIT_LIST_HEAD(&cilpcp->log_items);
 	}
 
-	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
-	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
@@ -1859,7 +1857,6 @@ xlog_cil_destroy(
 		kmem_free(cil->xc_ctx);
 	}
 
-	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 	free_percpu(cil->xc_pcp);
 	destroy_workqueue(cil->xc_push_wq);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 563145ea0f7d..f00f11c18116 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -224,6 +224,7 @@ struct xfs_cil_ctx {
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
 	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct list_head	log_items;	/* log items in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
@@ -262,8 +263,6 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	unsigned long		xc_flags;
 	atomic_t		xc_iclog_hdrs;
-	struct list_head	xc_cil;
-	spinlock_t		xc_cil_lock;
 	struct workqueue_struct	*xc_push_wq;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
-- 
2.35.1

