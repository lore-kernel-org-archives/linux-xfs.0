Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 881D318052
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734990203; cv=none; b=Z4vXqoChhkgJtiuyO/WHJsSVTcOMbfnyaXdyVeiyJ4F6V9++bkYGgxTjB+mrZzkrblXqjUqnwKQijMQmltNz6WkYDLgkOBeUiEKykfljFmgFcxbyCc6ho62Tym+sZVwgq9j0xvrpjqpgTNApQOVHRYFkSRwbLRrM9C5ERbNNq7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734990203; c=relaxed/simple;
	bh=onSbLMLAArbA54vKb0rc6mZB7izQJ0wsTC9dYCwv2yU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nXQKfGA/X7dapcgDTigm8TyjNKICeSMhsZ++XpfAkOqaI2hZiwMjiCge44AtzvmizxqqtTfjA+oEYzmYuN7FEs603jVvOWgHTpBBPr5DBYy72hR3HXdbNr1XE5K2vwpVYZsh4xiYsIsKjMwHGdcjWnV7lbSFQIb/uIgA8iIegE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IirczKFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IirczKFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168CCC4CED3;
	Mon, 23 Dec 2024 21:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734990203;
	bh=onSbLMLAArbA54vKb0rc6mZB7izQJ0wsTC9dYCwv2yU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IirczKFdYdSmSS8NTWqLJ8poi4TgvOLNaj4P/kLjhlHQ8HqpfLOqfi0dg7XJ+rOPL
	 o81EjKQ9wasmXDCEszHCC/uZrefGsBXZc1HzOJNThJtZc+X4/1MozaWuAEFNdrRwJH
	 +bwTd7TgdfoXc93kLoUCwE7cuQlF6l03TPRIKg1qUnfGdo2+Bm4YarIDNk41eFUs8U
	 XzX9qp4TK5sUVKxYAB3xtPKTS8IQs0FdD9B9zetYRWWe7Du0IzpsFzWWhPEl6jN5Zy
	 PH2nuRAwpUF02fY6Si4bxh7I6b2D8tD236yXvBEBYY7waYYL5bbfDfKeBNo3DAK605
	 BqWPIjJUvYM/Q==
Date: Mon, 23 Dec 2024 13:43:22 -0800
Subject: [PATCH 24/36] xfs: store a generic group structure in the intents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940310.2293042.13926732996733732522.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e5e5cae05b71aa5b5e291c0e74b4e4d98a0b05d4

Replace the pag pointers in the extent free, bmap, rmap and refcount
intent structures with a pointer to the generic group to prepare
for adding intents for realtime groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h   |   11 ++++++-----
 libxfs/defer_item.c   |   31 ++++++++++++++++++-------------
 libxfs/xfs_alloc.h    |    2 +-
 libxfs/xfs_bmap.h     |    2 +-
 libxfs/xfs_refcount.c |    9 +++++----
 libxfs/xfs_refcount.h |    2 +-
 libxfs/xfs_rmap.c     |   16 +++++++++-------
 libxfs/xfs_rmap.h     |    2 +-
 8 files changed, 42 insertions(+), 33 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 1d36e3986ead2f..1179a80d9df94e 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -11,6 +11,7 @@ struct xfs_inode;
 struct xfs_buftarg;
 struct xfs_da_geometry;
 struct libxfs_init;
+struct xfs_group;
 
 typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
 
@@ -328,12 +329,12 @@ struct xfs_defer_drain { /* empty */ };
 #define xfs_defer_drain_init(dr)		((void)0)
 #define xfs_defer_drain_free(dr)		((void)0)
 
-#define xfs_perag_intent_get(mp, agno) \
-	xfs_perag_get((mp), XFS_FSB_TO_AGNO((mp), (agno)))
-#define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
+#define xfs_group_intent_get(mp, fsbno, type) \
+	xfs_group_get_by_fsb((mp), (fsbno), (type))
+#define xfs_group_intent_put(xg)		xfs_group_put(xg)
 
-static inline void xfs_perag_intent_hold(struct xfs_perag *pag) {}
-static inline void xfs_perag_intent_rele(struct xfs_perag *pag) {}
+static inline void xfs_group_intent_hold(struct xfs_group *xg) {}
+static inline void xfs_group_intent_rele(struct xfs_group *xg) {}
 
 static inline void libxfs_buftarg_drain(struct xfs_buftarg *btp)
 {
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index f0f35361a0ff97..eee84ffbe625d5 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -28,6 +28,7 @@
 #include "xfs_ag.h"
 #include "xfs_exchmaps.h"
 #include "defer_item.h"
+#include "xfs_group.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -48,7 +49,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return pag_agno(ra->xefi_pag) - pag_agno(rb->xefi_pag);
+	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
 }
 
 /* Get an EFI. */
@@ -85,7 +86,8 @@ xfs_extent_free_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
+	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
+			XG_TYPE_AG);
 	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
 		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
 				&xfs_agfl_free_defer_type);
@@ -101,7 +103,7 @@ xfs_extent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_perag_intent_put(xefi->xefi_pag);
+	xfs_group_intent_put(xefi->xefi_group);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
@@ -127,7 +129,7 @@ xfs_extent_free_finish_item(
 	agbno = XFS_FSB_TO_AGBNO(tp->t_mountp, xefi->xefi_startblock);
 
 	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED)) {
-		error = xfs_free_extent(tp, xefi->xefi_pag, agbno,
+		error = xfs_free_extent(tp, to_perag(xefi->xefi_group), agbno,
 				xefi->xefi_blockcount, &oinfo,
 				XFS_AG_RESV_NONE);
 	}
@@ -179,7 +181,7 @@ xfs_agfl_free_finish_item(
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
 
-	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
+	error = xfs_alloc_read_agf(to_perag(xefi->xefi_group), tp, 0, &agbp);
 	if (!error)
 		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
 				XFS_AG_RESV_AGFL);
@@ -215,7 +217,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
+	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
 }
 
 /* Get an RUI. */
@@ -253,7 +255,8 @@ xfs_rmap_defer_add(
 
 	trace_xfs_rmap_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
+			XG_TYPE_AG);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
@@ -264,7 +267,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_group_intent_put(ri->ri_group);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -336,7 +339,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
+	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
 }
 
 /* Get an CUI. */
@@ -374,7 +377,8 @@ xfs_refcount_defer_add(
 
 	trace_xfs_refcount_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock,
+			XG_TYPE_AG);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
@@ -385,7 +389,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_group_intent_put(ri->ri_group);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
@@ -508,7 +512,8 @@ xfs_bmap_update_get_group(
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
 	 */
-	bi->bi_pag = xfs_perag_intent_get(mp, bi->bi_bmap.br_startblock);
+	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
+			XG_TYPE_AG);
 }
 
 /* Add this deferred BUI to the transaction. */
@@ -542,7 +547,7 @@ xfs_bmap_update_put_group(
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
 		return;
 
-	xfs_perag_intent_put(bi->bi_pag);
+	xfs_group_intent_put(bi->bi_group);
 }
 
 /* Cancel a deferred bmap update. */
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 88fbce5001185f..efbde04fbbb15f 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -248,7 +248,7 @@ struct xfs_extent_free_item {
 	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	struct xfs_perag	*xefi_pag;
+	struct xfs_group	*xefi_group;
 	unsigned int		xefi_flags;
 	enum xfs_ag_resv_type	xefi_agresv;
 };
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index 7592d46e97c661..4b721d9359943b 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -248,7 +248,7 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
-	struct xfs_perag			*bi_pag;
+	struct xfs_group			*bi_group;
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 3eccb998545d6f..709e2a94176da5 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1357,7 +1357,7 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
+	if (rcur != NULL && rcur->bc_group != ri->ri_group) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_btree_del_cursor(rcur, 0);
@@ -1365,13 +1365,14 @@ xfs_refcount_finish_one(
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
-		error = xfs_alloc_read_agf(ri->ri_pag, tp,
+		struct xfs_perag	*pag = to_perag(ri->ri_group);
+
+		error = xfs_alloc_read_agf(pag, tp,
 				XFS_ALLOC_FLAG_FREEING, &agbp);
 		if (error)
 			return error;
 
-		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp,
-							  ri->ri_pag);
+		*pcur = rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, pag);
 		rcur->bc_refc.nr_ops = nr_ops;
 		rcur->bc_refc.shape_changes = shape_changes;
 	}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 68acb0b1b4a878..62d78afcf1f3ff 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -56,7 +56,7 @@ enum xfs_refcount_intent_type {
 
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
-	struct xfs_perag			*ri_pag;
+	struct xfs_group			*ri_group;
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 07bcdf82d10081..dabc7003586ce4 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -2585,28 +2585,30 @@ xfs_rmap_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
+	if (rcur != NULL && rcur->bc_group != ri->ri_group) {
 		xfs_btree_del_cursor(rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
 	}
 	if (rcur == NULL) {
+		struct xfs_perag	*pag = to_perag(ri->ri_group);
+
 		/*
 		 * Refresh the freelist before we start changing the
 		 * rmapbt, because a shape change could cause us to
 		 * allocate blocks.
 		 */
-		error = xfs_free_extent_fix_freelist(tp, ri->ri_pag, &agbp);
+		error = xfs_free_extent_fix_freelist(tp, pag, &agbp);
 		if (error) {
-			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 			return error;
 		}
 		if (XFS_IS_CORRUPT(tp->t_mountp, !agbp)) {
-			xfs_ag_mark_sick(ri->ri_pag, XFS_SICK_AG_AGFL);
+			xfs_ag_mark_sick(pag, XFS_SICK_AG_AGFL);
 			return -EFSCORRUPTED;
 		}
 
-		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, ri->ri_pag);
+		*pcur = rcur = xfs_rmapbt_init_cursor(mp, tp, agbp, pag);
 	}
 
 	xfs_rmap_ino_owner(&oinfo, ri->ri_owner, ri->ri_whichfork,
@@ -2619,8 +2621,8 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
-			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	xfs_rmap_update_hook(tp, ri->ri_group, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index d409b463bc6662..96b4321d831007 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -173,7 +173,7 @@ struct xfs_rmap_intent {
 	int					ri_whichfork;
 	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
-	struct xfs_perag			*ri_pag;
+	struct xfs_group			*ri_group;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */

