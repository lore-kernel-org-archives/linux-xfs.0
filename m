Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AC3DCCA47F
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 07:53:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244037AbiFOHxr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245255AbiFOHxk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 03:53:40 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B917E41617
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 00:53:39 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5CCE05ECB34
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 17:53:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-006rR3-Hw
        for linux-xfs@vger.kernel.org; Wed, 15 Jun 2022 17:53:32 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1NqG-00FJxY-Gx
        for linux-xfs@vger.kernel.org;
        Wed, 15 Jun 2022 17:53:32 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/14] xfs: use the CIL space used counter for emptiness checks
Date:   Wed, 15 Jun 2022 17:53:17 +1000
Message-Id: <20220615075330.3651541-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615075330.3651541-1-david@fromorbit.com>
References: <20220615075330.3651541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62a98ffe
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=pnGdOrXIZPBWx_jS1wIA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

In the next patches we are going to make the CIL list itself
per-cpu, and so we cannot use list_empty() to check is the list is
empty. Replace the list_empty() checks with a flag in the CIL to
indicate we have committed at least one transaction to the CIL and
hence the CIL is not empty.

We need this flag to be an atomic so that we can clear it without
holding any locks in the commit fast path, but we also need to be
careful to avoid atomic operations in the fast path. Hence we use
the fact that test_bit() is not an atomic op to first check if the
flag is set and then run the atomic test_and_clear_bit() operation
to clear it and steal the initial unit reservation for the CIL
context checkpoint.

When we are switching to a new context in a push, we place the
setting of the XLOG_CIL_EMPTY flag under the xc_push_lock. THis
allows all the other places that need to check whether the CIL is
empty to use test_bit() and still be serialised correctly with the
CIL context swaps that set the bit.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c  | 43 ++++++++++++++++++++++++-------------------
 fs/xfs/xfs_log_priv.h |  4 ++++
 2 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index db6cb7800251..36c0ce77d41b 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -61,7 +61,7 @@ xlog_item_in_current_chkpt(
 	struct xfs_cil		*cil,
 	struct xfs_log_item	*lip)
 {
-	if (list_empty(&lip->li_cil))
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		return false;
 
 	/*
@@ -102,6 +102,7 @@ xlog_cil_ctx_switch(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
+	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
 	ctx->sequence = ++cil->xc_current_sequence;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
@@ -468,13 +469,12 @@ xlog_cil_insert_items(
 		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 
 	/*
-	 * Now transfer enough transaction reservation to the context ticket
-	 * for the checkpoint. The context ticket is special - the unit
-	 * reservation has to grow as well as the current reservation as we
-	 * steal from tickets so we can correctly determine the space used
-	 * during the transaction commit.
+	 * We need to take the CIL checkpoint unit reservation on the first
+	 * commit into the CIL. Test the XLOG_CIL_EMPTY bit first so we don't
+	 * unnecessarily do an atomic op in the fast path here.
 	 */
-	if (ctx->ticket->t_curr_res == 0) {
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) &&
+	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
 		ctx_res = ctx->ticket->t_unit_res;
 		ctx->ticket->t_curr_res = ctx_res;
 		tp->t_ticket->t_curr_res -= ctx_res;
@@ -1054,7 +1054,7 @@ xlog_cil_push_work(
 	 * move on to a new sequence number and so we have to be able to push
 	 * this sequence again later.
 	 */
-	if (list_empty(&cil->xc_cil)) {
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
 		cil->xc_push_seq = 0;
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
@@ -1235,9 +1235,10 @@ xlog_cil_push_background(
 
 	/*
 	 * The cil won't be empty because we are called while holding the
-	 * context lock so whatever we added to the CIL will still be there
+	 * context lock so whatever we added to the CIL will still be there.
 	 */
 	ASSERT(!list_empty(&cil->xc_cil));
+	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
 	 * Don't do a background push if we haven't used up all the
@@ -1334,7 +1335,8 @@ xlog_cil_push_now(
 	 * If the CIL is empty or we've already pushed the sequence then
 	 * there's no more work that we need to do.
 	 */
-	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) ||
+	    push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
@@ -1352,7 +1354,7 @@ xlog_cil_empty(
 	bool		empty = false;
 
 	spin_lock(&cil->xc_push_lock);
-	if (list_empty(&cil->xc_cil))
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		empty = true;
 	spin_unlock(&cil->xc_push_lock);
 	return empty;
@@ -1568,7 +1570,7 @@ xlog_cil_force_seq(
 	 * we would have found the context on the committing list.
 	 */
 	if (sequence == cil->xc_current_sequence &&
-	    !list_empty(&cil->xc_cil)) {
+	    !test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
 		spin_unlock(&cil->xc_push_lock);
 		goto restart;
 	}
@@ -1636,14 +1638,17 @@ void
 xlog_cil_destroy(
 	struct xlog	*log)
 {
-	if (log->l_cilp->xc_ctx) {
-		if (log->l_cilp->xc_ctx->ticket)
-			xfs_log_ticket_put(log->l_cilp->xc_ctx->ticket);
-		kmem_free(log->l_cilp->xc_ctx);
+	struct xfs_cil	*cil = log->l_cilp;
+
+	if (cil->xc_ctx) {
+		if (cil->xc_ctx->ticket)
+			xfs_log_ticket_put(cil->xc_ctx->ticket);
+		kmem_free(cil->xc_ctx);
 	}
 
-	ASSERT(list_empty(&log->l_cilp->xc_cil));
-	destroy_workqueue(log->l_cilp->xc_push_wq);
-	kmem_free(log->l_cilp);
+	ASSERT(list_empty(&cil->xc_cil));
+	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	destroy_workqueue(cil->xc_push_wq);
+	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 686c01eb3661..8fad33ea2582 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -248,6 +248,7 @@ struct xfs_cil_ctx {
  */
 struct xfs_cil {
 	struct xlog		*xc_log;
+	unsigned long		xc_flags;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
 	struct workqueue_struct	*xc_push_wq;
@@ -265,6 +266,9 @@ struct xfs_cil {
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
+/* xc_flags bit values */
+#define	XLOG_CIL_EMPTY		1
+
 /*
  * The amount of log space we allow the CIL to aggregate is difficult to size.
  * Whatever we choose, we have to make sure we can get a reservation for the
-- 
2.35.1

