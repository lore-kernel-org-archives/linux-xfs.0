Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8533AC54E8B
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69525207FF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgELJ2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:28:19 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35755 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725889AbgELJ2S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:28:18 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5FD283A2E4C
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 19:28:15 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-0004H5-BY
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-007kYW-2S
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] [RFC] xfs: use percpu counters for CIL context counters
Date:   Tue, 12 May 2020 19:28:09 +1000
Message-Id: <20200512092811.1846252-4-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
In-Reply-To: <20200512092811.1846252-1-david@fromorbit.com>
References: <20200512092811.1846252-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=EZ1i1sUKn3mE4C4D1V4A:9
        a=0fyGEN4HqmrUkTAy:21 a=GkttGSZADD73hktX:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

With the m_active_trans atomic bottleneck out of the way, the CIL
xc_cil_lock is the next bottleneck that causes cacheline contention.
This protects several things, the first of which is the CIL context
reservation ticket and space usage counters.

We can lift them out of the xc_cil_lock by converting them to
percpu counters. THis involves two things, the first of which is
lifting calculations and samples that don't actually need protecting
from races outside the xc_cil lock.

The second is converting the counters to percpu counters and lifting
them outside the lock. This requires a couple of tricky things to
minimise initial state races and to ensure we take into account
split reservations. We do this by erring on the "take the
reservation just in case" side, which largely lost in the noise of
many frequent large transactions.

We use a trick with percpu_counter_add_batch() to ensure the global
sum is updated immediately on first reservation, hence allowing us
to use fast counter reads everywhere to determine if the CIL is
empty or not, rather than using the list itself. This is important
for later patches where the CIL is moved to percpu lists
and hence cannot use list_empty() to detect an empty CIL. Hence we
provide a low overhead, lockless mechanism for determining if the
CIL is empty or not via this mechanisms. All other percpu counter
updates use a large batch count so they aggregate on the local CPU
and minimise global sum updates.

The xc_ctx_lock rwsem protects draining the percpu counters to the
context's ticket, similar to the way it allows access to the CIL
without using the xc_cil_lock. i.e. the CIL push has exclusive
access to the CIL, the context and the percpu counters while holding
the xc_ctx_lock. This ensures that we can sum and zero the counters
atomically from the perspective of the transaction commit side of
the push. i.e. they reset to zero atomically with the CIL context
swap and hence we don't need to have the percpu counters attached to
the CIL context.

Performance wise, this increases the transaction rate from
~620,000/s to around 750,000/second. Using a 32-way concurrent
create instead of 16-way on a 32p/16GB virtual machine:

		create time	rate		unlink time
unpatched	  2m03s      472k/s+/-9k/s	 3m6s
patched		  1m56s	     533k/s+/-28k/s	 2m34

Notably, the system time for the create went from 44m20s down to
38m37s, whilst going faster. There is more variance, but I think
that is from the cacheline contention having inconsistent overhead.

XXX: probably should split into two patches

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c  | 99 ++++++++++++++++++++++++++++++-------------
 fs/xfs/xfs_log_priv.h |  2 +
 2 files changed, 72 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b43f0e8f43f2e..746c841757ed1 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -393,7 +393,7 @@ xlog_cil_insert_items(
 	struct xfs_log_item	*lip;
 	int			len = 0;
 	int			diff_iovecs = 0;
-	int			iclog_space;
+	int			iclog_space, space_used;
 	int			iovhdr_res = 0, split_res = 0, ctx_res = 0;
 
 	ASSERT(tp);
@@ -403,17 +403,16 @@ xlog_cil_insert_items(
 	 * are done so it doesn't matter exactly how we update the CIL.
 	 */
 	xlog_cil_insert_format_items(log, tp, &len, &diff_iovecs);
-
-	spin_lock(&cil->xc_cil_lock);
-
 	/* account for space used by new iovec headers  */
+
 	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
 	len += iovhdr_res;
 	ctx->nvecs += diff_iovecs;
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
+	/*
+	 * The ticket can't go away from us here, so we can do racy sampling
+	 * and precalculate everything.
+	 */
 
 	/*
 	 * Now transfer enough transaction reservation to the context ticket
@@ -421,27 +420,28 @@ xlog_cil_insert_items(
 	 * reservation has to grow as well as the current reservation as we
 	 * steal from tickets so we can correctly determine the space used
 	 * during the transaction commit.
+	 *
+	 * We use percpu_counter_add_batch() here to force the addition into the
+	 * global sum immediately. This will result in percpu_counter_read() now
+	 * always returning a non-zero value, and hence we'll only ever have a
+	 * very short race window on new contexts.
 	 */
-	if (ctx->ticket->t_curr_res == 0) {
+	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
 		ctx_res = ctx->ticket->t_unit_res;
-		ctx->ticket->t_curr_res = ctx_res;
 		tp->t_ticket->t_curr_res -= ctx_res;
+		percpu_counter_add_batch(&cil->xc_curr_res, ctx_res, ctx_res - 1);
 	}
 
 	/* do we need space for more log record headers? */
-	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
-	if (len > 0 && (ctx->space_used / iclog_space !=
-				(ctx->space_used + len) / iclog_space)) {
+	if (len > 0 && !ctx_res) {
+		iclog_space = log->l_iclog_size - log->l_iclog_hsize;
 		split_res = (len + iclog_space - 1) / iclog_space;
 		/* need to take into account split region headers, too */
 		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
-		ctx->ticket->t_unit_res += split_res;
-		ctx->ticket->t_curr_res += split_res;
 		tp->t_ticket->t_curr_res -= split_res;
 		ASSERT(tp->t_ticket->t_curr_res >= len);
 	}
 	tp->t_ticket->t_curr_res -= len;
-	ctx->space_used += len;
 
 	/*
 	 * If we've overrun the reservation, dump the tx details before we move
@@ -458,6 +458,15 @@ xlog_cil_insert_items(
 		xlog_print_trans(tp);
 	}
 
+	percpu_counter_add_batch(&cil->xc_curr_res, split_res, 1000 * 1000);
+	percpu_counter_add_batch(&cil->xc_space_used, len, 1000 * 1000);
+
+	spin_lock(&cil->xc_cil_lock);
+
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &ctx->busy_extents);
+
 	/*
 	 * Now (re-)position everything modified at the tail of the CIL.
 	 * We do this here so we only need to take the CIL lock once during
@@ -741,6 +750,18 @@ xlog_cil_push_work(
 		num_iovecs += lv->lv_niovecs;
 	}
 
+	/*
+	 * Drain per cpu counters back to context so they can be re-initialised
+	 * to zero before we allow commits to the new context we are about to
+	 * switch to.
+	 */
+	ctx->space_used = percpu_counter_sum(&cil->xc_space_used);
+	ctx->ticket->t_curr_res = percpu_counter_sum(&cil->xc_curr_res);
+	ctx->ticket->t_unit_res = ctx->ticket->t_curr_res;
+	percpu_counter_set(&cil->xc_space_used, 0);
+	percpu_counter_set(&cil->xc_curr_res, 0);
+
+
 	/*
 	 * initialise the new context and attach it to the CIL. Then attach
 	 * the current context to the CIL committing lsit so it can be found
@@ -900,6 +921,7 @@ xlog_cil_push_background(
 	struct xlog	*log) __releases(cil->xc_ctx_lock)
 {
 	struct xfs_cil	*cil = log->l_cilp;
+	s64		space_used = percpu_counter_read(&cil->xc_space_used);
 
 	/*
 	 * The cil won't be empty because we are called while holding the
@@ -911,7 +933,7 @@ xlog_cil_push_background(
 	 * don't do a background push if we haven't used up all the
 	 * space available yet.
 	 */
-	if (cil->xc_ctx->space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
 		up_read(&cil->xc_ctx_lock);
 		return;
 	}
@@ -934,9 +956,9 @@ xlog_cil_push_background(
 	 * If we are well over the space limit, throttle the work that is being
 	 * done until the push work on this context has begun.
 	 */
-	if (cil->xc_ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
+	if (space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
 		trace_xfs_log_cil_wait(log, cil->xc_ctx->ticket);
-		ASSERT(cil->xc_ctx->space_used < log->l_logsize);
+		ASSERT(space_used < log->l_logsize);
 		xlog_wait(&cil->xc_ctx->push_wait, &cil->xc_push_lock);
 		return;
 	}
@@ -1200,16 +1222,23 @@ xlog_cil_init(
 {
 	struct xfs_cil	*cil;
 	struct xfs_cil_ctx *ctx;
+	int		error = -ENOMEM;
 
 	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
-		return -ENOMEM;
+		return error;
 
 	ctx = kmem_zalloc(sizeof(*ctx), KM_MAYFAIL);
-	if (!ctx) {
-		kmem_free(cil);
-		return -ENOMEM;
-	}
+	if (!ctx)
+		goto out_free_cil;
+
+	error = percpu_counter_init(&cil->xc_space_used, 0, GFP_KERNEL);
+	if (error)
+		goto out_free_ctx;
+
+	error = percpu_counter_init(&cil->xc_curr_res, 0, GFP_KERNEL);
+	if (error)
+		goto out_free_space;
 
 	INIT_WORK(&cil->xc_push_work, xlog_cil_push_work);
 	INIT_LIST_HEAD(&cil->xc_cil);
@@ -1230,19 +1259,31 @@ xlog_cil_init(
 	cil->xc_log = log;
 	log->l_cilp = cil;
 	return 0;
+
+out_free_space:
+	percpu_counter_destroy(&cil->xc_space_used);
+out_free_ctx:
+	kmem_free(ctx);
+out_free_cil:
+	kmem_free(cil);
+	return error;
 }
 
 void
 xlog_cil_destroy(
 	struct xlog	*log)
 {
-	if (log->l_cilp->xc_ctx) {
-		if (log->l_cilp->xc_ctx->ticket)
-			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
-		kmem_free(log->l_cilp->xc_ctx);
+	struct xfs_cil  *cil = log->l_cilp;
+
+	if (cil->xc_ctx) {
+		if (cil->xc_ctx->ticket)
+			xfs_log_ticket_put(cil->xc_ctx->ticket);
+		kmem_free(cil->xc_ctx);
 	}
+	percpu_counter_destroy(&cil->xc_space_used);
+	percpu_counter_destroy(&cil->xc_curr_res);
 
-	ASSERT(list_empty(&log->l_cilp->xc_cil));
-	kmem_free(log->l_cilp);
+	ASSERT(list_empty(&cil->xc_cil));
+	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index ec22c7a3867f1..f5e79a7d44c8e 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -262,6 +262,8 @@ struct xfs_cil_ctx {
  */
 struct xfs_cil {
 	struct xlog		*xc_log;
+	struct percpu_counter	xc_space_used;
+	struct percpu_counter	xc_curr_res;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
 
-- 
2.26.1.301.g55bc3eb7cb9

