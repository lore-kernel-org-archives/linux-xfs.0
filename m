Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CC2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 084C364EC4
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 03:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhBYDi6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Feb 2021 22:38:58 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33195 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232085AbhBYDix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:53 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1E51082809B
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038B1-IV
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00EvjW-B6
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/12] xfs: convert CIL to unordered per cpu lists
Date:   Thu, 25 Feb 2021 14:37:22 +1100
Message-Id: <20210225033725.3558450-10-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=LeOBFmjP2KjtsCjRVtEA:9
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
---
 fs/xfs/xfs_log_cil.c  | 61 ++++++++++++++++++++-----------------------
 fs/xfs/xfs_log_priv.h |  2 --
 2 files changed, 29 insertions(+), 34 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index be2e6627340d..810ebb226f94 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -448,10 +448,9 @@ xlog_cil_insert_items(
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
@@ -505,24 +504,6 @@ xlog_cil_insert_items(
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
@@ -530,7 +511,6 @@ xlog_cil_insert_items(
 	 * the transaction commit.
 	 */
 	order = atomic_inc_return(&ctx->order_id);
-	spin_lock(&cil->xc_cil_lock);
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 
 		/* Skip items which aren't dirty in this transaction. */
@@ -540,10 +520,26 @@ xlog_cil_insert_items(
 		lip->li_order_id = order;
 		if (!list_empty(&lip->li_cil))
 			continue;
-		list_add(&lip->li_cil, &cil->xc_cil);
+		list_add(&lip->li_cil, &cilpcp->log_items);
+	}
+	put_cpu_ptr(cilpcp);
+
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
 	}
 
-	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
@@ -805,6 +801,7 @@ xlog_cil_push_work(
 	bool			commit_iclog_sync = false;
 	int			cpu;
 	struct xlog_cil_pcp	*cilpcp;
+	LIST_HEAD		(log_items);
 
 	new_ctx = xlog_cil_ctx_alloc();
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -821,6 +818,9 @@ xlog_cil_push_work(
 			list_splice_init(&cilpcp->busy_extents,
 					&ctx->busy_extents);
 		}
+		if (!list_empty(&cilpcp->log_items)) {
+			list_splice_init(&cilpcp->log_items, &log_items);
+		}
 	}
 
 	spin_lock(&cil->xc_push_lock);
@@ -905,12 +905,12 @@ xlog_cil_push_work(
 	 * needed on the transaction commit side which is currently locked out
 	 * by the flush lock.
 	 */
-	list_sort(NULL, &cil->xc_cil, xlog_cil_order_cmp);
+	list_sort(NULL, &log_items, xlog_cil_order_cmp);
 	lv = NULL;
-	while (!list_empty(&cil->xc_cil)) {
+	while (!list_empty(&log_items)) {
 		struct xfs_log_item	*item;
 
-		item = list_first_entry(&cil->xc_cil,
+		item = list_first_entry(&log_items,
 					struct xfs_log_item, li_cil);
 		list_del_init(&item->li_cil);
 		item->li_order_id = 0;
@@ -1094,7 +1094,6 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there.
 	 */
-	ASSERT(!list_empty(&cil->xc_cil));
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
@@ -1486,6 +1485,7 @@ xlog_cil_pcp_alloc(
 	for_each_possible_cpu(cpu) {
 		cilpcp = per_cpu_ptr(pcptr, cpu);
 		INIT_LIST_HEAD(&cilpcp->busy_extents);
+		INIT_LIST_HEAD(&cilpcp->log_items);
 	}
 
 	if (xlog_cil_pcp_hpadd(cil) < 0) {
@@ -1526,9 +1526,7 @@ xlog_cil_init(
 		return -ENOMEM;
 	}
 
-	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
-	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
 	init_waitqueue_head(&cil->xc_push_wait);
 	init_rwsem(&cil->xc_ctx_lock);
@@ -1554,7 +1552,6 @@ xlog_cil_destroy(
 		kmem_free(cil->xc_ctx);
 	}
 
-	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 	xlog_cil_pcp_free(cil, cil->xc_pcp);
 	kmem_free(cil);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ceebb787cc40..fb8399414131 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -262,8 +262,6 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	unsigned long		xc_flags;
 	atomic_t		xc_iclog_hdrs;
-	struct list_head	xc_cil;
-	spinlock_t		xc_cil_lock;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
 	struct xfs_cil_ctx	*xc_ctx;
-- 
2.28.0

