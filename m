Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4139EC4709A
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F10A613F0
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbhFCFZG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:25:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57905 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229761AbhFCFZF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:25:05 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0EAF110438E1
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:52 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-008MrY-Hk
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofoh-000imp-9K
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 34/39] xfs: convert CIL to unordered per cpu lists
Date:   Thu,  3 Jun 2021 15:22:35 +1000
Message-Id: <20210603052240.171998-35-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=LJalFvrMBqGHNnPjixMA:9 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log_cil.c  | 69 +++++++++++++++++++------------------------
 fs/xfs/xfs_log_priv.h |  3 +-
 2 files changed, 31 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index dd3493058161..3ca9fce57584 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -72,6 +72,7 @@ xlog_cil_ctx_alloc(void)
 	ctx = kmem_zalloc(sizeof(*ctx), KM_NOFS);
 	INIT_LIST_HEAD(&ctx->committing);
 	INIT_LIST_HEAD(&ctx->busy_extents);
+	INIT_LIST_HEAD(&ctx->log_items);
 	INIT_WORK(&ctx->push_work, xlog_cil_push_work);
 	return ctx;
 }
@@ -99,6 +100,8 @@ xlog_cil_pcp_aggregate(
 			list_splice_init(&cilpcp->busy_extents,
 					&ctx->busy_extents);
 		}
+		if (!list_empty(&cilpcp->log_items))
+			list_splice_init(&cilpcp->log_items, &ctx->log_items);
 
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
@@ -482,10 +485,9 @@ xlog_cil_insert_items(
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
@@ -539,24 +541,6 @@ xlog_cil_insert_items(
 	/* attach the transaction to the CIL if it has any busy extents */
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
-	put_cpu_ptr(cilpcp);
-
-	/*
-	 * If we've overrun the reservation, dump the tx details before we move
-	 * the log items. Shutdown is imminent...
-	 */
-	tp->t_ticket->t_curr_res -= ctx_res + len;
-	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
-		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
-		xfs_warn(log->l_mp,
-			 "  log items: %d bytes (iov hdrs: %d bytes)",
-			 len, iovhdr_res);
-		xfs_warn(log->l_mp, "  split region headers: %d bytes",
-			 split_res);
-		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
-		xlog_print_trans(tp);
-	}
-
 	/*
 	 * Now update the order of everything modified in the transaction
 	 * and insert items into the CIL if they aren't already there.
@@ -564,7 +548,6 @@ xlog_cil_insert_items(
 	 * the transaction commit.
 	 */
 	order = atomic_inc_return(&ctx->order_id);
-	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -574,10 +557,25 @@ xlog_cil_insert_items(
 		lip->li_order_id = order;
 		if (!list_empty(&lip->li_cil))
 			continue;
-		list_add_tail(&lip->li_cil, &cil->xc_cil);
+		list_add_tail(&lip->li_cil, &cilpcp->log_items);
 	}
+	put_cpu_ptr(cilpcp);
 
-	spin_unlock(&cil->xc_cil_lock);
+	/*
+	 * If we've overrun the reservation, dump the tx details before we move
+	 * the log items. Shutdown is imminent...
+	 */
+	tp->t_ticket->t_curr_res -= ctx_res + len;
+	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
+		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
+		xfs_warn(log->l_mp,
+			 "  log items: %d bytes (iov hdrs: %d bytes)",
+			 len, iovhdr_res);
+		xfs_warn(log->l_mp, "  split region headers: %d bytes",
+			 split_res);
+		xfs_warn(log->l_mp, "  ctx ticket: %d bytes", ctx_res);
+		xlog_print_trans(tp);
+	}
 
 	if (tp->t_ticket->t_curr_res < 0)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -921,18 +919,12 @@ xlog_cil_push_work(
 
 	xlog_cil_pcp_aggregate(cil, ctx);
 
-	/*
-	 * Pull all the log vectors off the items in the CIL, and remove the
-	 * items from the CIL. We don't need the CIL lock here because it's only
-	 * needed on the transaction commit side which is currently locked out
-	 * by the flush lock.
-	 */
-	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
-	lv = NULL;
-	while (!list_empty(&cil->xc_cil)) {
+	list_sort(NULL, &ctx->log_items, xlog_cil_order_cmp);
+
+	while (!list_empty(&ctx->log_items)) {
 		struct xfs_log_item	*item;
 
-		item = list_first_entry(&cil->xc_cil,
+		item = list_first_entry(&ctx->log_items,
 					struct xfs_log_item, li_cil);
 		list_del_init(&item->li_cil);
 		item->li_order_id = 0;
@@ -1125,7 +1117,6 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there.
 	 */
-	ASSERT(!list_empty(&cil->xc_cil));
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
@@ -1484,6 +1475,8 @@ xlog_cil_pcp_dead(
 			list_splice_init(&cilpcp->busy_extents,
 					&ctx->busy_extents);
 		}
+		if (!list_empty(&cilpcp->log_items))
+			list_splice_init(&cilpcp->log_items, &ctx->log_items);
 
 		cilpcp->space_used = 0;
 		cilpcp->space_reserved = 0;
@@ -1556,6 +1549,7 @@ xlog_cil_pcp_alloc(
 	for_each_possible_cpu(cpu) {
 		cilpcp = per_cpu_ptr(pcp, cpu);
 		INIT_LIST_HEAD(&cilpcp->busy_extents);
+		INIT_LIST_HEAD(&cilpcp->log_items);
 	}
 	return pcp;
 }
@@ -1591,9 +1585,7 @@ xlog_cil_init(
 		return -ENOMEM;
 	}
 
-	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
-	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
@@ -1619,7 +1611,6 @@ xlog_cil_destroy(
 		kmem_free(cil->xc_ctx);
 	}
 
-	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 	xlog_cil_pcp_free(cil, cil->xc_pcp);
 	kmem_free(cil);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 466862a943ba..d3bf3b367370 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -220,6 +220,7 @@ struct xfs_cil_ctx {
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
 	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
+	struct list_head	log_items;	/* log items in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
 	struct list_head	committing;	/* ctx committing list */
@@ -258,8 +259,6 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	unsigned long		xc_flags;
 	atomic_t		xc_iclog_hdrs;
-	struct list_head	xc_cil;
-	spinlock_t		xc_cil_lock;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
 	struct xfs_cil_ctx	*xc_ctx;
-- 
2.31.1

