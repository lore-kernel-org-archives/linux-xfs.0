Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D45C433B4
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 691AE61353
	for <linux-xfs@archiver.kernel.org>; Wed, 19 May 2021 12:13:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345033AbhESMOq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 May 2021 08:14:46 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:38368 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346300AbhESMOm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:42 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DA85B1043874
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1c-Cg
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHh-4w
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 26/39] xfs: use the CIL space used counter for emptiness checks
Date:   Wed, 19 May 2021 22:13:04 +1000
Message-Id: <20210519121317.585244-27-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=PUXlccLH651rOZYfVoIA:9 a=AjGcO6oz07-iQ99wixmX:22
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
 fs/xfs/xfs_log_cil.c  | 45 ++++++++++++++++++++++++-------------------
 fs/xfs/xfs_log_priv.h |  4 ++++
 2 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index eca5c82c0d60..f119d8baf504 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -70,6 +70,7 @@ xlog_cil_ctx_switch(
 	struct xfs_cil		*cil,
 	struct xfs_cil_ctx	*ctx)
 {
+	set_bit(XLOG_CIL_EMPTY, &cil->xc_flags);
 	ctx->sequence = ++cil->xc_current_sequence;
 	ctx->cil = cil;
 	cil->xc_ctx = ctx;
@@ -436,13 +437,12 @@ xlog_cil_insert_items(
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
@@ -771,7 +771,7 @@ xlog_cil_push_work(
 	 * move on to a new sequence number and so we have to be able to push
 	 * this sequence again later.
 	 */
-	if (list_empty(&cil->xc_cil)) {
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
 		cil->xc_push_seq = 0;
 		spin_unlock(&cil->xc_push_lock);
 		goto out_skip;
@@ -1020,9 +1020,10 @@ xlog_cil_push_background(
 
 	/*
 	 * The cil won't be empty because we are called while holding the
-	 * context lock so whatever we added to the CIL will still be there
+	 * context lock so whatever we added to the CIL will still be there.
 	 */
 	ASSERT(!list_empty(&cil->xc_cil));
+	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
 	 * Don't do a background push if we haven't used up all the
@@ -1109,7 +1110,8 @@ xlog_cil_push_now(
 	 * there's no work we need to do.
 	 */
 	spin_lock(&cil->xc_push_lock);
-	if (list_empty(&cil->xc_cil) || push_seq <= cil->xc_push_seq) {
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags) ||
+	    push_seq <= cil->xc_push_seq) {
 		spin_unlock(&cil->xc_push_lock);
 		return;
 	}
@@ -1128,7 +1130,7 @@ xlog_cil_empty(
 	bool		empty = false;
 
 	spin_lock(&cil->xc_push_lock);
-	if (list_empty(&cil->xc_cil))
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		empty = true;
 	spin_unlock(&cil->xc_push_lock);
 	return empty;
@@ -1296,7 +1298,7 @@ xlog_cil_force_seq(
 	 * we would have found the context on the committing list.
 	 */
 	if (sequence == cil->xc_current_sequence &&
-	    !list_empty(&cil->xc_cil)) {
+	    !test_bit(XLOG_CIL_EMPTY, &cil->xc_flags)) {
 		spin_unlock(&cil->xc_push_lock);
 		goto restart;
 	}
@@ -1329,9 +1331,9 @@ bool
 xfs_log_item_in_current_chkpt(
 	struct xfs_log_item *lip)
 {
-	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
 
-	if (list_empty(&lip->li_cil))
+	if (test_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
 		return false;
 
 	/*
@@ -1339,7 +1341,7 @@ xfs_log_item_in_current_chkpt(
 	 * first checkpoint it is written to. Hence if it is different to the
 	 * current sequence, we're in a new checkpoint.
 	 */
-	return lip->li_seq == ctx->sequence;
+	return lip->li_seq == cil->xc_ctx->sequence;
 }
 
 /*
@@ -1376,13 +1378,16 @@ void
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
-	kmem_free(log->l_cilp);
+	ASSERT(list_empty(&cil->xc_cil));
+	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 02c94b6d0642..11606c378b7f 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -244,6 +244,7 @@ struct xfs_cil_ctx {
  */
 struct xfs_cil {
 	struct xlog		*xc_log;
+	unsigned long		xc_flags;
 	struct list_head	xc_cil;
 	spinlock_t		xc_cil_lock;
 
@@ -259,6 +260,9 @@ struct xfs_cil {
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
 } ____cacheline_aligned_in_smp;
 
+/* xc_flags bit values */
+#define	XLOG_CIL_EMPTY		1
+
 /*
  * The amount of log space we allow the CIL to aggregate is difficult to size.
  * Whatever we choose, we have to make sure we can get a reservation for the
-- 
2.31.1

