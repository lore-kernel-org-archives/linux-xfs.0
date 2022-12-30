Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455A1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiL3WgW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3WgW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:36:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E62B41021
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:36:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F8BBB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B28C433EF;
        Fri, 30 Dec 2022 22:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439778;
        bh=cnTGZRRlNXBrLSoJ9WTv4cHiujZjNCwSsN/prkIKvGs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IxXuKglwZN0pum1ksbty+JSxSEjv4FrA8E0BPsF0WOSW297SbmNHdvjHvyoZyqCOk
         M9mHYYn58pUvC5PBwW7+GI6ku3riyQHhV2jIhKjPZw8uaaUXyJGODkhKAP5BXvWuEL
         Ln/a8ou2Z4CcAof8ZZnmEjnFhtFX88iZdlM7UCrCmyk0aLhGQCeoQpnTQT99AmeQB8
         pac2LHJLefL8s5IQYvvxPL/V9QgnCBrRpauZxzOb0exbWM5dBPcF/jTZ7Hdza+49vr
         aTVhOz54f/biJXbG2bEFb6wsArcze5PMP+7jO0cRG8CrH9DQQcTPZWkqLHa5b7iVCu
         xISwQS8G68LjA==
Subject: [PATCH 5/5] xfs: give xfs_refcount_intent its own perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:01 -0800
Message-ID: <167243826147.683449.5541940667449680335.stgit@magnolia>
In-Reply-To: <167243826070.683449.502057797810903920.stgit@magnolia>
References: <167243826070.683449.502057797810903920.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Give the xfs_refcount_intent an active reference to the perag structure
data.  This reference will be used to enable scrub intent draining
functionality in subsequent patches.  Later, shrink will use these
active references to know if an AG is quiesced or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   33 ++++++++++++++-------------------
 fs/xfs/libxfs/xfs_refcount.h |    4 ++++
 fs/xfs/xfs_refcount_item.c   |   36 ++++++++++++++++++++++++++++++++----
 3 files changed, 50 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index bcf46aa0d08b..6dc968618e66 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1332,26 +1332,22 @@ xfs_refcount_finish_one(
 	xfs_agblock_t			bno;
 	unsigned long			nr_ops = 0;
 	int				shape_changes = 0;
-	struct xfs_perag		*pag;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
 
 	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock),
 			ri->ri_type, XFS_FSB_TO_AGBNO(mp, ri->ri_startblock),
 			ri->ri_blockcount);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE)) {
-		error = -EIO;
-		goto out_drop;
-	}
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
+		return -EIO;
 
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.pag != pag) {
+	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		nr_ops = rcur->bc_ag.refc.nr_ops;
 		shape_changes = rcur->bc_ag.refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
@@ -1359,12 +1355,12 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_FREEING,
-				&agbp);
+		error = xfs_alloc_read_agf(ri->ri_pag, tp,
+				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
-			goto out_drop;
+			return error;
 
-		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
+		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 		rcur->bc_ag.refc.nr_ops = nr_ops;
 		rcur->bc_ag.refc.shape_changes = shape_changes;
 	}
@@ -1375,7 +1371,7 @@ xfs_refcount_finish_one(
 		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
 				XFS_REFCOUNT_ADJUST_INCREASE);
 		if (error)
-			goto out_drop;
+			return error;
 		if (ri->ri_blockcount > 0)
 			error = xfs_refcount_continue_op(rcur, ri, bno);
 		break;
@@ -1383,31 +1379,29 @@ xfs_refcount_finish_one(
 		error = xfs_refcount_adjust(rcur, &bno, &ri->ri_blockcount,
 				XFS_REFCOUNT_ADJUST_DECREASE);
 		if (error)
-			goto out_drop;
+			return error;
 		if (ri->ri_blockcount > 0)
 			error = xfs_refcount_continue_op(rcur, ri, bno);
 		break;
 	case XFS_REFCOUNT_ALLOC_COW:
 		error = __xfs_refcount_cow_alloc(rcur, bno, ri->ri_blockcount);
 		if (error)
-			goto out_drop;
+			return error;
 		ri->ri_blockcount = 0;
 		break;
 	case XFS_REFCOUNT_FREE_COW:
 		error = __xfs_refcount_cow_free(rcur, bno, ri->ri_blockcount);
 		if (error)
-			goto out_drop;
+			return error;
 		ri->ri_blockcount = 0;
 		break;
 	default:
 		ASSERT(0);
-		error = -EFSCORRUPTED;
+		return -EFSCORRUPTED;
 	}
 	if (!error && ri->ri_blockcount > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, pag->pag_agno,
+		trace_xfs_refcount_finish_one_leftover(mp, ri->ri_pag->pag_agno,
 				ri->ri_type, bno, ri->ri_blockcount);
-out_drop:
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1435,6 +1429,7 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
+	xfs_refcount_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index c633477ce3ce..c89f0fcd1ee3 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -50,6 +50,7 @@ enum xfs_refcount_intent_type {
 
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
+	struct xfs_perag			*ri_pag;
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
@@ -67,6 +68,9 @@ xfs_refcount_check_domain(
 	return true;
 }
 
+void xfs_refcount_update_get_group(struct xfs_mount *mp,
+		struct xfs_refcount_intent *ri);
+
 void xfs_refcount_increase_extent(struct xfs_trans *tp,
 		struct xfs_bmbt_irec *irec);
 void xfs_refcount_decrease_extent(struct xfs_trans *tp,
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 48d771a76add..4c4706a15056 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_cui_cache;
 struct kmem_cache	*xfs_cud_cache;
@@ -279,14 +280,13 @@ xfs_refcount_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_mount		*mp = priv;
 	struct xfs_refcount_intent	*ra;
 	struct xfs_refcount_intent	*rb;
 
 	ra = container_of(a, struct xfs_refcount_intent, ri_list);
 	rb = container_of(b, struct xfs_refcount_intent, ri_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->ri_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->ri_startblock);
+
+	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
 /* Set the phys extent flags for this reverse mapping. */
@@ -365,6 +365,26 @@ xfs_refcount_update_create_done(
 	return &xfs_trans_get_cud(tp, CUI_ITEM(intent))->cud_item;
 }
 
+/* Take an active ref to the AG containing the space we're refcounting. */
+void
+xfs_refcount_update_get_group(
+	struct xfs_mount		*mp,
+	struct xfs_refcount_intent	*ri)
+{
+	xfs_agnumber_t			agno;
+
+	agno = XFS_FSB_TO_AGNO(mp, ri->ri_startblock);
+	ri->ri_pag = xfs_perag_get(mp, agno);
+}
+
+/* Release an active AG ref after finishing refcounting work. */
+static inline void
+xfs_refcount_update_put_group(
+	struct xfs_refcount_intent	*ri)
+{
+	xfs_perag_put(ri->ri_pag);
+}
+
 /* Process a deferred refcount update. */
 STATIC int
 xfs_refcount_update_finish_item(
@@ -386,6 +406,8 @@ xfs_refcount_update_finish_item(
 		       ri->ri_type == XFS_REFCOUNT_DECREASE);
 		return -EAGAIN;
 	}
+
+	xfs_refcount_update_put_group(ri);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 	return error;
 }
@@ -406,6 +428,8 @@ xfs_refcount_update_cancel_item(
 	struct xfs_refcount_intent	*ri;
 
 	ri = container_of(item, struct xfs_refcount_intent, ri_list);
+
+	xfs_refcount_update_put_group(ri);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
@@ -520,9 +544,13 @@ xfs_cui_item_recover(
 
 		fake.ri_startblock = pmap->pe_startblock;
 		fake.ri_blockcount = pmap->pe_len;
-		if (!requeue_only)
+
+		if (!requeue_only) {
+			xfs_refcount_update_get_group(mp, &fake);
 			error = xfs_trans_log_finish_refcount_update(tp, cudp,
 					&fake, &rcur);
+			xfs_refcount_update_put_group(&fake);
+		}
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					&cuip->cui_format,

