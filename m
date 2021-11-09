Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3105C433FE
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C99E961175
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Nov 2021 01:52:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbhKIBzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Nov 2021 20:55:32 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:39540 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241477AbhKIBzb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:31 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id A1C961041589
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Za5-05
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJX-006Uia-V0
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/14] xfs: implement percpu cil space used calculation
Date:   Tue,  9 Nov 2021 12:52:31 +1100
Message-Id: <20211109015240.1547991-6-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=6189d46c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=PXk8bsAeJqfsh4AIjdsA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have the CIL percpu structures in place, implement the
space used counter with a fast sum check similar to the
percpu_counter infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 64 ++++++++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_log_priv.h |  3 +-
 2 files changed, 59 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 2de1ca43bcde..ddc8d262d9f9 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -76,6 +76,30 @@ xlog_cil_ctx_alloc(void)
 	return ctx;
 }
 
+/*
+ * Aggregate the CIL per cpu structures into global counts, lists, etc and
+ * clear the percpu state ready for the next context to use.
+ */
+static void
+xlog_cil_pcp_aggregate(
+	struct xfs_cil		*cil,
+	struct xfs_cil_ctx	*ctx)
+{
+	struct xlog_cil_pcp	*cilpcp;
+	int			cpu;
+
+	for_each_online_cpu(cpu) {
+		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+
+		/*
+		 * We're in the middle of switching cil contexts.  Reset the
+		 * counter we use to detect when the current context is nearing
+		 * full.
+		 */
+		cilpcp->space_used = 0;
+	}
+}
+
 static void
 xlog_cil_ctx_switch(
 	struct xfs_cil		*cil,
@@ -441,6 +465,8 @@ xlog_cil_insert_items(
 	struct xfs_log_item	*lip;
 	int			len = 0;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
+	int			space_used;
+	struct xlog_cil_pcp	*cilpcp;
 
 	ASSERT(tp);
 
@@ -477,8 +503,9 @@ xlog_cil_insert_items(
 	 *
 	 * This can steal more than we need, but that's OK.
 	 */
+	space_used = atomic_read(&ctx->space_used);
 	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
-	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+	    space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		int	split_res = log->l_iclog_hsize +
 					sizeof(struct xlog_op_header);
 		if (ctx_res)
@@ -488,16 +515,34 @@ xlog_cil_insert_items(
 		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
 	}
 
+	/*
+	 * Update the CIL percpu pointer. This updates the global counter when
+	 * over the percpu batch size or when the CIL is over the space limit.
+	 * This means low lock overhead for normal updates, and when over the
+	 * limit the space used is immediately accounted. This makes enforcing
+	 * the hard limit much more accurate. The per cpu fold threshold is
+	 * based on how close we are to the hard limit.
+	 */
+	cilpcp = get_cpu_ptr(cil->xc_pcp);
+	cilpcp->space_used += len;
+	if (space_used >= XLOG_CIL_SPACE_LIMIT(log) ||
+	    cilpcp->space_used >
+			((XLOG_CIL_BLOCKING_SPACE_LIMIT(log) - space_used) /
+					num_online_cpus())) {
+		atomic_add(cilpcp->space_used, &ctx->space_used);
+		cilpcp->space_used = 0;
+	}
+	put_cpu_ptr(cilpcp);
+
 	spin_lock(&cil->xc_cil_lock);
-	tp->t_ticket->t_curr_res -= ctx_res + len;
 	ctx->ticket->t_unit_res += ctx_res;
 	ctx->ticket->t_curr_res += ctx_res;
-	ctx->space_used += len;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
 	 * the log items. Shutdown is imminent...
 	 */
+	tp->t_ticket->t_curr_res -= ctx_res + len;
 	if (WARN_ON(tp->t_ticket->t_curr_res < 0)) {
 		xfs_warn(log->l_mp, "Transaction log reservation overrun:");
 		xfs_warn(log->l_mp,
@@ -1044,6 +1089,8 @@ xlog_cil_push_work(
 	xfs_flush_bdev_async(&bio, log->l_mp->m_ddev_targp->bt_bdev,
 				&bdev_flush);
 
+	xlog_cil_pcp_aggregate(cil, ctx);
+
 	/*
 	 * Pull all the log vectors off the items in the CIL, and remove the
 	 * items from the CIL. We don't need the CIL lock here because it's only
@@ -1210,6 +1257,7 @@ xlog_cil_push_background(
 	struct xlog	*log) __releases(cil->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
+	int		space_used = atomic_read(&cil->xc_ctx->space_used);
 
 	/*
 	 * The cil won't be empty because we are called while holding the
@@ -1222,7 +1270,7 @@ xlog_cil_push_background(
 	 * Don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
-	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
 		up_read(&cil->xc_ctx_lock);
 		return;
 	}
@@ -1251,10 +1299,10 @@ xlog_cil_push_background(
 	 * The ctx->xc_push_lock provides the serialisation necessary for safely
 	 * using the lockless waitqueue_active() check in this context.
 	 */
-	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
+	if (space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log) ||
 	    waitqueue_active(&cil->xc_push_wait)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
-		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+		ASSERT(space_used < log->l_logsize);
 		xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);
 		return;
 	}
@@ -1551,9 +1599,11 @@ xlog_cil_pcp_dead(
 	unsigned int		cpu)
 {
 	struct xfs_cil		*cil = log->l_cilp;
+	struct xlog_cil_pcp	*cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
 
 	down_write(&cil->xc_ctx_lock);
-	/* move stuff on dead CPU to context */
+	atomic_add(cilpcp->space_used, &cil->xc_ctx->space_used);
+	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 0a744ccddbd6..b9c96609705b 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -222,7 +222,7 @@ struct xfs_cil_ctx {
 	xfs_lsn_t		commit_lsn;	/* chkpt commit record lsn */
 	struct xlog_in_core	*commit_iclog;
 	struct xlog_ticket	*ticket;	/* chkpt ticket */
-	int			space_used;	/* aggregate size of regions */
+	atomic_t		space_used;	/* aggregate size of regions */
 	struct list_head	busy_extents;	/* busy extents in chkpt */
 	struct xfs_log_vec	*lv_chain;	/* logvecs being pushed */
 	struct list_head	iclog_entry;
@@ -235,6 +235,7 @@ struct xfs_cil_ctx {
  * Per-cpu CIL tracking items
  */
 struct xlog_cil_pcp {
+	uint32_t		space_used;
 	struct list_head	busy_extents;
 	struct list_head	log_items;
 };
-- 
2.33.0

