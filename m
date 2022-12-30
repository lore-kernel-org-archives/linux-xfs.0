Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99DE1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:36:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiL3WgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiL3WgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:36:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BF9C6F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:36:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FC9061645
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C0C9C433EF;
        Fri, 30 Dec 2022 22:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439762;
        bh=qYzX13qj/D7bnKks3rAgmE/Xjtqs79U/GQvScoy2c28=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q9jwxHQrtZb+iHxsc+afpOro7lp0a8Dr/TclPROMN6LA1I8l3LSTkLpod0T/pgj2L
         DXxFolhH15krHk4whZ1QmAjGNZXlLc6gjL+4F/7KP+z1COinGPLMt8ntJUJYjZG41r
         5eklyeuY3rwn93NmH8Z1nNxv+DJfzGVAwES/HTfpaCGvKM9rb4bzZkrv01qFXXkOwV
         2w8a3uuPphwnKBPQLIQDVwAl+tR5/wjlDhKV5kXNS88Z05Ovqd86GDnJcmcXVzCT9/
         nFnCLnbLoL4V7JTyX2cIRuweG3PWexaVrKGQhD/x/THI6cNkUgajcdC6s2PSF9hQoC
         U08T7uy03eC3Q==
Subject: [PATCH 4/5] xfs: give xfs_rmap_intent its own perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:01 -0800
Message-ID: <167243826133.683449.1864785160880700463.stgit@magnolia>
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

Give the xfs_rmap_intent an active reference to the perag structure
data.  This reference will be used to enable scrub intent draining
functionality in subsequent patches.  Later, shrink will use these
active references to know if an AG is quiesced or not.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   29 +++++++++++------------------
 fs/xfs/libxfs/xfs_rmap.h |    4 ++++
 fs/xfs/xfs_rmap_item.c   |   32 +++++++++++++++++++++++++++++---
 3 files changed, 44 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index df720041cd3d..c2624d11f041 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2394,7 +2394,6 @@ xfs_rmap_finish_one(
 	struct xfs_btree_cur		**pcur)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
 	int				error = 0;
@@ -2402,26 +2401,22 @@ xfs_rmap_finish_one(
 	xfs_agblock_t			bno;
 	bool				unwritten;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock));
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
 
-	trace_xfs_rmap_deferred(mp, pag->pag_agno, ri->ri_type, bno,
+	trace_xfs_rmap_deferred(mp, ri->ri_pag->pag_agno, ri->ri_type, bno,
 			ri->ri_owner, ri->ri_whichfork,
 			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
 			ri->ri_bmap.br_state);
 
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE)) {
-		error = -EIO;
-		goto out_drop;
-	}
-
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
+		return -EIO;
 
 	/*
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
 	rcur = *pcur;
-	if (rcur != NULL && rcur->bc_ag.pag != pag) {
+	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
 		xfs_rmap_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -2432,15 +2427,13 @@ xfs_rmap_finish_one(
 		 * rmapbt, because a shape change could cause us to
 		 * allocate blocks.
 		 */
-		error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
+		error = xfs_free_extent_fix_freelist(tp, ri->ri_pag, &agbp);
 		if (error)
-			goto out_drop;
-		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
-			error = -EFSCORRUPTED;
-			goto out_drop;
-		}
+			return error;
+		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp))
+			return -EFSCORRUPTED;
 
-		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
+		rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
 	}
 	*pcur = rcur;
 
@@ -2480,8 +2473,7 @@ xfs_rmap_finish_one(
 		ASSERT(0);
 		error = -EFSCORRUPTED;
 	}
-out_drop:
-	xfs_perag_put(pag);
+
 	return error;
 }
 
@@ -2526,6 +2518,7 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 2dac88cea28d..1472ae570a8a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -162,8 +162,12 @@ struct xfs_rmap_intent {
 	int					ri_whichfork;
 	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
+	struct xfs_perag			*ri_pag;
 };
 
+void xfs_rmap_update_get_group(struct xfs_mount *mp,
+		struct xfs_rmap_intent *ri);
+
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
 void xfs_rmap_map_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 		int whichfork, struct xfs_bmbt_irec *imap);
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index a1619d67015f..10b971d24b5f 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -20,6 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
+#include "xfs_ag.h"
 
 struct kmem_cache	*xfs_rui_cache;
 struct kmem_cache	*xfs_rud_cache;
@@ -320,14 +321,13 @@ xfs_rmap_update_diff_items(
 	const struct list_head		*a,
 	const struct list_head		*b)
 {
-	struct xfs_mount		*mp = priv;
 	struct xfs_rmap_intent		*ra;
 	struct xfs_rmap_intent		*rb;
 
 	ra = container_of(a, struct xfs_rmap_intent, ri_list);
 	rb = container_of(b, struct xfs_rmap_intent, ri_list);
-	return  XFS_FSB_TO_AGNO(mp, ra->ri_bmap.br_startblock) -
-		XFS_FSB_TO_AGNO(mp, rb->ri_bmap.br_startblock);
+
+	return ra->ri_pag->pag_agno - rb->ri_pag->pag_agno;
 }
 
 /* Log rmap updates in the intent item. */
@@ -390,6 +390,26 @@ xfs_rmap_update_create_done(
 	return &xfs_trans_get_rud(tp, RUI_ITEM(intent))->rud_item;
 }
 
+/* Take an active ref to the AG containing the space we're rmapping. */
+void
+xfs_rmap_update_get_group(
+	struct xfs_mount	*mp,
+	struct xfs_rmap_intent	*ri)
+{
+	xfs_agnumber_t		agno;
+
+	agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
+	ri->ri_pag = xfs_perag_get(mp, agno);
+}
+
+/* Release an active AG ref after finishing rmapping work. */
+static inline void
+xfs_rmap_update_put_group(
+	struct xfs_rmap_intent	*ri)
+{
+	xfs_perag_put(ri->ri_pag);
+}
+
 /* Process a deferred rmap update. */
 STATIC int
 xfs_rmap_update_finish_item(
@@ -405,6 +425,8 @@ xfs_rmap_update_finish_item(
 
 	error = xfs_trans_log_finish_rmap_update(tp, RUD_ITEM(done), ri,
 			state);
+
+	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 	return error;
 }
@@ -425,6 +447,8 @@ xfs_rmap_update_cancel_item(
 	struct xfs_rmap_intent		*ri;
 
 	ri = container_of(item, struct xfs_rmap_intent, ri_list);
+
+	xfs_rmap_update_put_group(ri);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -559,11 +583,13 @@ xfs_rui_item_recover(
 		fake.ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 				XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
 
+		xfs_rmap_update_get_group(mp, &fake);
 		error = xfs_trans_log_finish_rmap_update(tp, rudp, &fake,
 				&rcur);
 		if (error == -EFSCORRUPTED)
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					map, sizeof(*map));
+		xfs_rmap_update_put_group(&fake);
 		if (error)
 			goto abort_error;
 

