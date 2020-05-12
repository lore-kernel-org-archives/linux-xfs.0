Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284D0C54E4A
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AAB72075E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgELJ2X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:28:23 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33014 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729125AbgELJ2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:28:22 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 1F7B6D79224
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 19:28:15 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-0004H7-Cw
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-007kYb-4A
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Date:   Tue, 12 May 2020 19:28:10 +1000
Message-Id: <20200512092811.1846252-5-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
In-Reply-To: <20200512092811.1846252-1-david@fromorbit.com>
References: <20200512092811.1846252-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=xl2qj0nMbg3rt_t4oVwA:9
        a=iK1Nx_DWJ8jIP1s-:21 a=Z9_Xw1WqqA7Fm-cJ:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Next on the list to getting rid of the xc_cil_lock is making the CIL
itself per-cpu.

This requires a trade-off: we no longer move items forward in the
CIL; once they are on the CIL they remain there as we treat the
percpu lists as lockless.

XXX: preempt_disable() around the list operations to ensure they
stay local to the CPU.

XXX: this needs CPU hotplug notifiers to clean up when cpus go
offline.

Performance now increases substantially - the transaction rate goes
from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
for the first time.

Using a 32-way concurrent create/unlink on a 32p/16GB virtual
machine:

	    create time     rate            unlink time
unpatched	1m56s      533k/s+/-28k/s      2m34s
patched		1m49s	   523k/s+/-14k/s      2m00s

Notably, the system time for the create went up, while variance went
down. This indicates we're starting to hit some other contention
limit as we reduce the amount of time we spend contending on the
xc_cil_lock.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
 fs/xfs/xfs_log_priv.h |  2 +-
 2 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 746c841757ed1..af444bc69a7cd 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -467,28 +467,28 @@ xlog_cil_insert_items(
 	if (!list_empty(&tp->t_busy))
 		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 
+	spin_unlock(&cil->xc_cil_lock);
+
 	/*
 	 * Now (re-)position everything modified at the tail of the CIL.
 	 * We do this here so we only need to take the CIL lock once during
 	 * the transaction commit.
+	 * Move everything to the tail of the local per-cpu CIL list.
 	 */
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
-
 		/* Skip items which aren't dirty in this transaction. */
 		if (!test_bit(XFS_LI_DIRTY, &lip->li_flags))
 			continue;
 
 		/*
-		 * Only move the item if it isn't already at the tail. This is
-		 * to prevent a transient list_empty() state when reinserting
-		 * an item that is already the only item in the CIL.
+		 * If the item is already in the CIL, don't try to reposition it
+		 * because we don't know what per-cpu list it is on.
 		 */
-		if (!list_is_last(&lip->li_cil, &cil->xc_cil))
-			list_move_tail(&lip->li_cil, &cil->xc_cil);
+		if (!list_empty(&lip->li_cil))
+			continue;
+		list_add_tail(&lip->li_cil, this_cpu_ptr(cil->xc_cil));
 	}
 
-	spin_unlock(&cil->xc_cil_lock);
-
 	if (tp->t_ticket->t_curr_res < 0)
 		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 }
@@ -666,6 +666,8 @@ xlog_cil_push_work(
 	struct xfs_log_vec	lvhdr = { NULL };
 	xfs_lsn_t		commit_lsn;
 	xfs_lsn_t		push_seq;
+	LIST_HEAD		(cil_items);
+	int			cpu;
 
 	new_ctx = kmem_zalloc(sizeof(*new_ctx), KM_NOFS);
 	new_ctx->ticket = xlog_cil_ticket_alloc(log);
@@ -687,7 +689,7 @@ xlog_cil_push_work(
 	 * move on to a new sequence number and so we have to be able to push
 	 * this sequence again later.
 	 */
-	if (list_empty(&cil->xc_cil)) {
+	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
 		cil->xc_push_seq = 0;
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
@@ -728,17 +730,21 @@ xlog_cil_push_work(
 	spin_unlock(&cil->xc_push_lock);
 
 	/*
-	 * pull all the log vectors off the items in the CIL, and
-	 * remove the items from the CIL. We don't need the CIL lock
-	 * here because it's only needed on the transaction commit
-	 * side which is currently locked out by the flush lock.
+	 * Remove the items from the per-cpu CIL lists and then pull all the
+	 * log vectors off the items. We hold the xc_ctx_lock exclusively here,
+	 * so nothing can be adding or removing from the per-cpu lists here.
 	 */
+	/* XXX: hotplug! */
+	for_each_online_cpu(cpu) {
+		list_splice_tail_init(per_cpu_ptr(cil->xc_cil, cpu), &cil_items);
+	}
+
 	lv = NULL;
 	num_iovecs = 0;
-	while (!list_empty(&cil->xc_cil)) {
+	while (!list_empty(&cil_items)) {
 		struct xfs_log_item	*item;
 
-		item = list_first_entry(&cil->xc_cil,
+		item = list_first_entry(&cil_items,
 					struct xfs_log_item, li_cil);
 		list_del_init(&item->li_cil);
 		if (!ctx->lv_chain)
@@ -927,7 +933,7 @@ xlog_cil_push_background(
 	 * The cil won't be empty because we are called while holding the
 	 * context lock so whatever we added to the CIL will still be there
 	 */
-	ASSERT(!list_empty(&cil->xc_cil));
+	ASSERT(space_used != 0);
 
 	/*
 	 * don't do a background push if we haven't used up all the
@@ -993,7 +999,8 @@ xlog_cil_push_now(
 	 * there's no work we need to do.
 	 */
 	spin_lock(&cil->xc_push_lock);
-	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+	if (percpu_counter_read(&cil->xc_curr_res) == 0 ||
+	    push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
@@ -1011,7 +1018,7 @@ xlog_cil_empty(
 	bool		empty = false;
 
 	spin_lock(&cil->xc_push_lock);
-	if (list_empty(&cil->xc_cil))
+	if (percpu_counter_read(&cil->xc_curr_res) == 0)
 		empty = true;
 	spin_unlock(&cil->xc_push_lock);
 	return empty;
@@ -1163,7 +1170,7 @@ xlog_cil_force_lsn(
 	 * we would have found the context on the committing list.
 	 */
 	if (sequence == cil->xc_current_sequence &&
-	    !list_empty(&cil->xc_cil)) {
+	    percpu_counter_read(&cil->xc_curr_res) != 0) {
 		spin_unlock(&cil->xc_push_lock);
 		goto restart;
 	}
@@ -1223,6 +1230,7 @@ xlog_cil_init(
 	struct xfs_cil	*cil;
 	struct xfs_cil_ctx *ctx;
 	int		error = -ENOMEM;
+	int		cpu;
 
 	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
@@ -1232,16 +1240,24 @@ xlog_cil_init(
 	if (!ctx)
 		goto out_free_cil;
 
+	/* XXX: CPU hotplug!!! */
+	cil->xc_cil = alloc_percpu_gfp(struct list_head, GFP_KERNEL);
+	if (!cil->xc_cil)
+		goto out_free_ctx;
+
+	for_each_possible_cpu(cpu) {
+		INIT_LIST_HEAD(per_cpu_ptr(cil->xc_cil, cpu));
+	}
+
 	error = percpu_counter_init(&cil->xc_space_used, 0, GFP_KERNEL);
 	if (error)
-		goto out_free_ctx;
+		goto out_free_pcp_cil;
 
 	error = percpu_counter_init(&cil->xc_curr_res, 0, GFP_KERNEL);
 	if (error)
 		goto out_free_space;
 
 	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
-	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
 	spin_lock_init(&cil->xc_push_lock);
@@ -1262,6 +1278,8 @@ xlog_cil_init(
 
 out_free_space:
 	percpu_counter_destroy(&cil->xc_space_used);
+out_free_pcp_cil:
+	free_percpu(cil->xc_cil);
 out_free_ctx:
 	kmem_free(ctx);
 out_free_cil:
@@ -1274,6 +1292,7 @@ xlog_cil_destroy(
 	struct xlog	*log)
 {
 	struct xfs_cil  *cil = log->l_cilp;
+	int		cpu;
 
 	if (cil->xc_ctx) {
 		if (cil->xc_ctx->ticket)
@@ -1283,7 +1302,10 @@ xlog_cil_destroy(
 	percpu_counter_destroy(&cil->xc_space_used);
 	percpu_counter_destroy(&cil->xc_curr_res);
 
-	ASSERT(list_empty(&cil->xc_cil));
+	for_each_possible_cpu(cpu) {
+		ASSERT(list_empty(per_cpu_ptr(cil->xc_cil, cpu)));
+	}
+	free_percpu(cil->xc_cil);
 	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index f5e79a7d44c8e..0bb982920d070 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -264,7 +264,7 @@ struct xfs_cil {
 	struct xlog		*xc_log;
 	struct percpu_counter	xc_space_used;
 	struct percpu_counter	xc_curr_res;
-	struct list_head	xc_cil;
+	struct list_head __percpu *xc_cil;
 	spinlock_t		xc_cil_lock;
 
 	struct rw_semaphore	xc_ctx_lock ____cacheline_aligned_in_smp;
-- 
2.26.1.301.g55bc3eb7cb9

