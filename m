Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE79219488
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191278; cv=none; b=eY9N03nS4Yitz7iprpwcT78CX3F1xpxTWyDLReoZDom8dvSuOv539V/WfRYxB+4dGOGEGCCcuwyp8JtXYhDFRxLN2d6bNSvWza4F5A2+aV4uGMvGqE94lgxwY2K+RCy3o3dSdJ/j9QEarUyqOY1o/7oDf3F13/82BWwYlAiaRbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191278; c=relaxed/simple;
	bh=YGoRT+ODaJAExPN9GqV3BY+sdiklUwoAy1ZtaSAXABY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hXZ4feHt6ox0BtQJkSL1REI7I7mfDGBjgLPHxHb/rokj+PhAHlPdb1i7tYxOCGsiihM5bejzGs4mE+BNJcijgHiBr5Eycxr7XyZN864ikxohZWKfDbiUn0R9HbjStPXekKi/YTb8afXmeI0THbE96CgIYcYg++2y8lwdb7FARxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eIy6v5t7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eIy6v5t7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F01C4CEC3;
	Thu, 17 Oct 2024 18:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191278;
	bh=YGoRT+ODaJAExPN9GqV3BY+sdiklUwoAy1ZtaSAXABY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eIy6v5t7FI7uznc9S/i59gWlmeJ1A1h0EFMJltSM6BWgqBhiEMiOttZp5XTvGz8Yx
	 NbScgZuz9AGweQ5fc8UYzTmD7TqxHKCM6wTvX61X8VKd2ZZq5OSbhSGPrtb34mIHg8
	 KNmNikASXoj4YIWpxVj4OpiEcmis/cka7SUI0bRCiC5UmT47iXHXmz8joUHAqogKNU
	 rDX8OlJNPSyrLJy6v3aDkQk3T7UkzqDaWoEKkxeN7/OhZJnv9QrpgacgBXjPPtQpqJ
	 pq7hkjSu3mleXtR7uNGMoAEQhZIMPOU6kKJKy9scmhxd28BUk1DztpiErAucQdXF/z
	 AXvM8Syso+/2Q==
Date: Thu, 17 Oct 2024 11:54:37 -0700
Subject: [PATCH 16/16] xfs: store a generic group structure in the intents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068956.3450737.2941149468344931746.stgit@frogsfrogsfrogs>
In-Reply-To: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
References: <172919068618.3450737.15265130869882039127.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Replace the pag pointers in the extent free, bmap, rmap and refcount
intent structures with a pointer to the generic group to prepare
for adding intents for realtime groups.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.h    |    2 +-
 fs/xfs/libxfs/xfs_bmap.h     |    2 +-
 fs/xfs/libxfs/xfs_refcount.c |    9 +++++----
 fs/xfs/libxfs/xfs_refcount.h |    2 +-
 fs/xfs/libxfs/xfs_rmap.c     |   16 +++++++++-------
 fs/xfs/libxfs/xfs_rmap.h     |    2 +-
 fs/xfs/xfs_bmap_item.c       |    5 +++--
 fs/xfs/xfs_drain.c           |   36 ++++++++++++++++++------------------
 fs/xfs/xfs_drain.h           |   12 ++++++------
 fs/xfs/xfs_extfree_item.c    |   14 ++++++++------
 fs/xfs/xfs_refcount_item.c   |    9 +++++----
 fs/xfs/xfs_rmap_item.c       |    9 +++++----
 12 files changed, 63 insertions(+), 55 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 88fbce5001185f..efbde04fbbb15f 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -248,7 +248,7 @@ struct xfs_extent_free_item {
 	uint64_t		xefi_owner;
 	xfs_fsblock_t		xefi_startblock;/* starting fs block number */
 	xfs_extlen_t		xefi_blockcount;/* number of blocks in extent */
-	struct xfs_perag	*xefi_pag;
+	struct xfs_group	*xefi_group;
 	unsigned int		xefi_flags;
 	enum xfs_ag_resv_type	xefi_agresv;
 };
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 7592d46e97c661..4b721d9359943b 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -248,7 +248,7 @@ struct xfs_bmap_intent {
 	enum xfs_bmap_intent_type		bi_type;
 	int					bi_whichfork;
 	struct xfs_inode			*bi_owner;
-	struct xfs_perag			*bi_pag;
+	struct xfs_group			*bi_group;
 	struct xfs_bmbt_irec			bi_bmap;
 };
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index ed943f6e616d96..2dbab68b4fe69f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1358,7 +1358,7 @@ xfs_refcount_finish_one(
 	 * If we haven't gotten a cursor or the cursor AG doesn't match
 	 * the startblock, get one now.
 	 */
-	if (rcur != NULL && to_perag(rcur->bc_group) != ri->ri_pag) {
+	if (rcur != NULL && rcur->bc_group != ri->ri_group) {
 		nr_ops = rcur->bc_refc.nr_ops;
 		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_btree_del_cursor(rcur, 0);
@@ -1366,13 +1366,14 @@ xfs_refcount_finish_one(
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
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 68acb0b1b4a878..62d78afcf1f3ff 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -56,7 +56,7 @@ enum xfs_refcount_intent_type {
 
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
-	struct xfs_perag			*ri_pag;
+	struct xfs_group			*ri_group;
 	enum xfs_refcount_intent_type		ri_type;
 	xfs_extlen_t				ri_blockcount;
 	xfs_fsblock_t				ri_startblock;
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 0c404625986163..d0df68dc313185 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2586,28 +2586,30 @@ xfs_rmap_finish_one(
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
@@ -2620,8 +2622,8 @@ xfs_rmap_finish_one(
 	if (error)
 		return error;
 
-	xfs_rmap_update_hook(tp, pag_group(ri->ri_pag), ri->ri_type, bno,
-			     ri->ri_bmap.br_blockcount, unwritten, &oinfo);
+	xfs_rmap_update_hook(tp, ri->ri_group, ri->ri_type, bno,
+			ri->ri_bmap.br_blockcount, unwritten, &oinfo);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index d409b463bc6662..96b4321d831007 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -173,7 +173,7 @@ struct xfs_rmap_intent {
 	int					ri_whichfork;
 	uint64_t				ri_owner;
 	struct xfs_bmbt_irec			ri_bmap;
-	struct xfs_perag			*ri_pag;
+	struct xfs_group			*ri_group;
 };
 
 /* functions for updating the rmapbt based on bmbt map/unmap operations */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 35a8c1b8b3cb34..37dab184c2dfc2 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -334,7 +334,8 @@ xfs_bmap_update_get_group(
 	 * intent drops the intent count, ensuring that the intent count
 	 * remains nonzero across the transaction roll.
 	 */
-	bi->bi_pag = xfs_perag_intent_get(mp, bi->bi_bmap.br_startblock);
+	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
+			XG_TYPE_AG);
 }
 
 /* Add this deferred BUI to the transaction. */
@@ -368,7 +369,7 @@ xfs_bmap_update_put_group(
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
 		return;
 
-	xfs_perag_intent_put(bi->bi_pag);
+	xfs_group_intent_put(bi->bi_group);
 }
 
 /* Cancel a deferred bmap update. */
diff --git a/fs/xfs/xfs_drain.c b/fs/xfs/xfs_drain.c
index 7a728a04f7a6b1..5ede81fadbd8ca 100644
--- a/fs/xfs/xfs_drain.c
+++ b/fs/xfs/xfs_drain.c
@@ -94,39 +94,39 @@ static inline int xfs_defer_drain_wait(struct xfs_defer_drain *dr)
 }
 
 /*
- * Get a passive reference to the AG that contains a fsbno and declare an
+ * Get a passive reference to the group that contains a fsbno and declare an
  * intent to update its metadata.
  *
  * Other threads that need exclusive access can decide to back off if they see
  * declared intentions.
  */
-struct xfs_perag *
-xfs_perag_intent_get(
+struct xfs_group *
+xfs_group_intent_get(
 	struct xfs_mount	*mp,
-	xfs_fsblock_t		fsbno)
+	xfs_fsblock_t		fsbno,
+	enum xfs_group_type	type)
 {
-	struct xfs_perag	*pag;
+	struct xfs_group	*xg;
 
-	pag = xfs_perag_get(mp, XFS_FSB_TO_AGNO(mp, fsbno));
-	if (!pag)
+	xg = xfs_group_get_by_fsb(mp, fsbno, type);
+	if (!xg)
 		return NULL;
-
-	trace_xfs_group_intent_hold(pag_group(pag), __return_address);
-	xfs_defer_drain_grab(pag_group(pag).xg_intents_drain);
-	return pag;
+	trace_xfs_group_intent_hold(xg, __return_address);
+	xfs_defer_drain_grab(&xg->xg_intents_drain);
+	return xg;
 }
 
 /*
- * Release our intent to update this AG's metadata, and then release our
- * passive ref to the AG.
+ * Release our intent to update this groups metadata, and then release our
+ * passive ref to it.
  */
 void
-xfs_perag_intent_put(
-	struct xfs_perag	*pag)
+xfs_group_intent_put(
+	struct xfs_group	*xg)
 {
-	trace_xfs_group_intent_rele(pag_group(pag), __return_address);
-	xfs_defer_drain_rele(pag_group(pag).xg_intents_drain);
-	xfs_perag_put(pag);
+	trace_xfs_group_intent_rele(xg, __return_address);
+	xfs_defer_drain_rele(&xg->xg_intents_drain);
+	xfs_group_put(xg);
 }
 
 /*
diff --git a/fs/xfs/xfs_drain.h b/fs/xfs/xfs_drain.h
index 3e6143572e52d2..efcf88df9a5e70 100644
--- a/fs/xfs/xfs_drain.h
+++ b/fs/xfs/xfs_drain.h
@@ -62,9 +62,9 @@ void xfs_drain_wait_enable(void);
  * soon as the item is added to the transaction and cannot drop the counter
  * until the item is finished or cancelled.
  */
-struct xfs_perag *xfs_perag_intent_get(struct xfs_mount *mp,
-		xfs_fsblock_t fsbno);
-void xfs_perag_intent_put(struct xfs_perag *pag);
+struct xfs_group *xfs_group_intent_get(struct xfs_mount *mp,
+		xfs_fsblock_t fsbno, enum xfs_group_type type);
+void xfs_group_intent_put(struct xfs_group *rtg);
 
 int xfs_group_intent_drain(struct xfs_group *xg);
 bool xfs_group_intent_busy(struct xfs_group *xg);
@@ -75,9 +75,9 @@ struct xfs_defer_drain { /* empty */ };
 #define xfs_defer_drain_free(dr)		((void)0)
 #define xfs_defer_drain_init(dr)		((void)0)
 
-#define xfs_perag_intent_get(mp, fsbno) \
-	xfs_perag_get((mp), XFS_FSB_TO_AGNO(mp, fsbno))
-#define xfs_perag_intent_put(pag)		xfs_perag_put(pag)
+#define xfs_group_intent_get(_mp, _fsbno, _type) \
+	xfs_group_get_by_fsb((_mp), (_fsbno), (_type))
+#define xfs_group_intent_put(xg)		xfs_group_put(xg)
 
 #endif /* CONFIG_XFS_DRAIN_INTENTS */
 
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index c198962edea163..e469510986e8d0 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -362,7 +362,7 @@ xfs_extent_free_diff_items(
 	struct xfs_extent_free_item	*ra = xefi_entry(a);
 	struct xfs_extent_free_item	*rb = xefi_entry(b);
 
-	return pag_agno(ra->xefi_pag) - pag_agno(rb->xefi_pag);
+	return ra->xefi_group->xg_gno - rb->xefi_group->xg_gno;
 }
 
 /* Log a free extent to the intent item. */
@@ -447,7 +447,8 @@ xfs_extent_free_defer_add(
 
 	trace_xfs_extent_free_defer(mp, xefi);
 
-	xefi->xefi_pag = xfs_perag_intent_get(mp, xefi->xefi_startblock);
+	xefi->xefi_group = xfs_group_intent_get(mp, xefi->xefi_startblock,
+			XG_TYPE_AG);
 	if (xefi->xefi_agresv == XFS_AG_RESV_AGFL)
 		*dfpp = xfs_defer_add(tp, &xefi->xefi_list,
 				&xfs_agfl_free_defer_type);
@@ -463,7 +464,7 @@ xfs_extent_free_cancel_item(
 {
 	struct xfs_extent_free_item	*xefi = xefi_entry(item);
 
-	xfs_perag_intent_put(xefi->xefi_pag);
+	xfs_group_intent_put(xefi->xefi_group);
 	kmem_cache_free(xfs_extfree_item_cache, xefi);
 }
 
@@ -499,7 +500,7 @@ xfs_extent_free_finish_item(
 	 * in this EFI to the EFD so this works correctly.
 	 */
 	if (!(xefi->xefi_flags & XFS_EFI_CANCELLED))
-		error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
+		error = __xfs_free_extent(tp, to_perag(xefi->xefi_group), agbno,
 				xefi->xefi_blockcount, &oinfo, xefi->xefi_agresv,
 				xefi->xefi_flags & XFS_EFI_SKIP_DISCARD);
 	if (error == -EAGAIN) {
@@ -545,7 +546,7 @@ xfs_agfl_free_finish_item(
 
 	trace_xfs_agfl_free_deferred(mp, xefi);
 
-	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
+	error = xfs_alloc_read_agf(to_perag(xefi->xefi_group), tp, 0, &agbp);
 	if (!error)
 		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
 				XFS_AG_RESV_AGFL);
@@ -578,7 +579,8 @@ xfs_efi_recover_work(
 	xefi->xefi_blockcount = extp->ext_len;
 	xefi->xefi_agresv = XFS_AG_RESV_NONE;
 	xefi->xefi_owner = XFS_RMAP_OWN_UNKNOWN;
-	xefi->xefi_pag = xfs_perag_intent_get(mp, extp->ext_start);
+	xefi->xefi_group = xfs_group_intent_get(mp, extp->ext_start,
+			XG_TYPE_AG);
 
 	xfs_defer_add_item(dfp, &xefi->xefi_list);
 }
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 29f101005f3eda..bede1c96c33011 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -244,7 +244,7 @@ xfs_refcount_update_diff_items(
 	struct xfs_refcount_intent	*ra = ci_entry(a);
 	struct xfs_refcount_intent	*rb = ci_entry(b);
 
-	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
+	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
 }
 
 /* Log refcount updates in the intent item. */
@@ -330,7 +330,7 @@ xfs_refcount_defer_add(
 
 	trace_xfs_refcount_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock, XG_TYPE_AG);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
@@ -341,7 +341,7 @@ xfs_refcount_update_cancel_item(
 {
 	struct xfs_refcount_intent	*ri = ci_entry(item);
 
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_group_intent_put(ri->ri_group);
 	kmem_cache_free(xfs_refcount_intent_cache, ri);
 }
 
@@ -431,7 +431,8 @@ xfs_cui_recover_work(
 	ri->ri_type = pmap->pe_flags & XFS_REFCOUNT_EXTENT_TYPE_MASK;
 	ri->ri_startblock = pmap->pe_startblock;
 	ri->ri_blockcount = pmap->pe_len;
-	ri->ri_pag = xfs_perag_intent_get(mp, pmap->pe_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, pmap->pe_startblock,
+			XG_TYPE_AG);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 1b83d09351f028..76b3c0ed3b4f63 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -243,7 +243,7 @@ xfs_rmap_update_diff_items(
 	struct xfs_rmap_intent		*ra = ri_entry(a);
 	struct xfs_rmap_intent		*rb = ri_entry(b);
 
-	return pag_agno(ra->ri_pag) - pag_agno(rb->ri_pag);
+	return ra->ri_group->xg_gno - rb->ri_group->xg_gno;
 }
 
 /* Log rmap updates in the intent item. */
@@ -353,7 +353,8 @@ xfs_rmap_defer_add(
 
 	trace_xfs_rmap_defer(mp, ri);
 
-	ri->ri_pag = xfs_perag_intent_get(mp, ri->ri_bmap.br_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
+			XG_TYPE_AG);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
@@ -364,7 +365,7 @@ xfs_rmap_update_cancel_item(
 {
 	struct xfs_rmap_intent		*ri = ri_entry(item);
 
-	xfs_perag_intent_put(ri->ri_pag);
+	xfs_group_intent_put(ri->ri_group);
 	kmem_cache_free(xfs_rmap_intent_cache, ri);
 }
 
@@ -494,7 +495,7 @@ xfs_rui_recover_work(
 	ri->ri_bmap.br_blockcount = map->me_len;
 	ri->ri_bmap.br_state = (map->me_flags & XFS_RMAP_EXTENT_UNWRITTEN) ?
 			XFS_EXT_UNWRITTEN : XFS_EXT_NORM;
-	ri->ri_pag = xfs_perag_intent_get(mp, map->me_startblock);
+	ri->ri_group = xfs_group_intent_get(mp, map->me_startblock, XG_TYPE_AG);
 
 	xfs_defer_add_item(dfp, &ri->ri_list);
 }

