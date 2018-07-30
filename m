Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:53306 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726259AbeG3HVW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Jul 2018 03:21:22 -0400
Subject: [PATCH 01/14] xfs: refactor the xrep_extent_list into xfs_bitmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 29 Jul 2018 22:47:54 -0700
Message-ID: <153292967384.24509.6676118910447905441.stgit@magnolia>
In-Reply-To: <153292966714.24509.15809693393247424274.stgit@magnolia>
References: <153292966714.24509.15809693393247424274.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com, david@fromorbit.com, allison.henderson@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

As mentioned previously, the xrep_extent_list basically implements a
bitmap with two functions: set and disjoint union.  Rename all these
functions to xfs_bitmap to shorten the name and make it more obvious
what we're doing.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/bitmap.c |  183 +++++++++++++++++++++++++------------------------
 fs/xfs/scrub/bitmap.h |   35 ++++-----
 fs/xfs/scrub/repair.c |   85 ++++++++++-------------
 fs/xfs/scrub/repair.h |    8 +-
 fs/xfs/scrub/trace.h  |    1 
 5 files changed, 149 insertions(+), 163 deletions(-)


diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index a7c2f4773f98..c770e2d0b6aa 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -16,183 +16,186 @@
 #include "scrub/repair.h"
 #include "scrub/bitmap.h"
 
-/* Collect a dead btree extent for later disposal. */
+/*
+ * Set a range of this bitmap.  Caller must ensure the range is not set.
+ *
+ * This is the logical equivalent of bitmap |= mask(start, len).
+ */
 int
-xrep_collect_btree_extent(
-	struct xfs_scrub	*sc,
-	struct xrep_extent_list	*exlist,
-	xfs_fsblock_t		fsbno,
-	xfs_extlen_t		len)
+xfs_bitmap_set(
+	struct xfs_bitmap	*bitmap,
+	uint64_t		start,
+	uint64_t		len)
 {
-	struct xrep_extent	*rex;
+	struct xfs_bitmap_range	*bmr;
 
-	trace_xrep_collect_btree_extent(sc->mp,
-			XFS_FSB_TO_AGNO(sc->mp, fsbno),
-			XFS_FSB_TO_AGBNO(sc->mp, fsbno), len);
-
-	rex = kmem_alloc(sizeof(struct xrep_extent), KM_MAYFAIL);
-	if (!rex)
+	bmr = kmem_alloc(sizeof(struct xfs_bitmap_range), KM_MAYFAIL);
+	if (!bmr)
 		return -ENOMEM;
 
-	INIT_LIST_HEAD(&rex->list);
-	rex->fsbno = fsbno;
-	rex->len = len;
-	list_add_tail(&rex->list, &exlist->list);
+	INIT_LIST_HEAD(&bmr->list);
+	bmr->start = start;
+	bmr->len = len;
+	list_add_tail(&bmr->list, &bitmap->list);
 
 	return 0;
 }
 
-/*
- * An error happened during the rebuild so the transaction will be cancelled.
- * The fs will shut down, and the administrator has to unmount and run repair.
- * Therefore, free all the memory associated with the list so we can die.
- */
+/* Free everything related to this bitmap. */
 void
-xrep_cancel_btree_extents(
-	struct xfs_scrub	*sc,
-	struct xrep_extent_list	*exlist)
+xfs_bitmap_destroy(
+	struct xfs_bitmap	*bitmap)
 {
-	struct xrep_extent	*rex;
-	struct xrep_extent	*n;
+	struct xfs_bitmap_range	*bmr;
+	struct xfs_bitmap_range	*n;
 
-	for_each_xrep_extent_safe(rex, n, exlist) {
-		list_del(&rex->list);
-		kmem_free(rex);
+	for_each_xfs_bitmap_extent(bmr, n, bitmap) {
+		list_del(&bmr->list);
+		kmem_free(bmr);
 	}
 }
 
+/* Set up a per-AG block bitmap. */
+void
+xfs_bitmap_init(
+	struct xfs_bitmap	*bitmap)
+{
+	INIT_LIST_HEAD(&bitmap->list);
+}
+
 /* Compare two btree extents. */
 static int
-xrep_btree_extent_cmp(
+xfs_bitmap_range_cmp(
 	void			*priv,
 	struct list_head	*a,
 	struct list_head	*b)
 {
-	struct xrep_extent	*ap;
-	struct xrep_extent	*bp;
+	struct xfs_bitmap_range	*ap;
+	struct xfs_bitmap_range	*bp;
 
-	ap = container_of(a, struct xrep_extent, list);
-	bp = container_of(b, struct xrep_extent, list);
+	ap = container_of(a, struct xfs_bitmap_range, list);
+	bp = container_of(b, struct xfs_bitmap_range, list);
 
-	if (ap->fsbno > bp->fsbno)
+	if (ap->start > bp->start)
 		return 1;
-	if (ap->fsbno < bp->fsbno)
+	if (ap->start < bp->start)
 		return -1;
 	return 0;
 }
 
 /*
- * Remove all the blocks mentioned in @sublist from the extents in @exlist.
+ * Remove all the blocks mentioned in @sub from the extents in @bitmap.
  *
  * The intent is that callers will iterate the rmapbt for all of its records
- * for a given owner to generate @exlist; and iterate all the blocks of the
+ * for a given owner to generate @bitmap; and iterate all the blocks of the
  * metadata structures that are not being rebuilt and have the same rmapbt
- * owner to generate @sublist.  This routine subtracts all the extents
- * mentioned in sublist from all the extents linked in @exlist, which leaves
- * @exlist as the list of blocks that are not accounted for, which we assume
+ * owner to generate @sub.  This routine subtracts all the extents
+ * mentioned in sub from all the extents linked in @bitmap, which leaves
+ * @bitmap as the list of blocks that are not accounted for, which we assume
  * are the dead blocks of the old metadata structure.  The blocks mentioned in
- * @exlist can be reaped.
+ * @bitmap can be reaped.
+ *
+ * This is the logical equivalent of bitmap &= ~sub.
  */
 #define LEFT_ALIGNED	(1 << 0)
 #define RIGHT_ALIGNED	(1 << 1)
 int
-xrep_subtract_extents(
-	struct xfs_scrub	*sc,
-	struct xrep_extent_list	*exlist,
-	struct xrep_extent_list	*sublist)
+xfs_bitmap_disunion(
+	struct xfs_bitmap	*bitmap,
+	struct xfs_bitmap	*sub)
 {
 	struct list_head	*lp;
-	struct xrep_extent	*ex;
-	struct xrep_extent	*newex;
-	struct xrep_extent	*subex;
-	xfs_fsblock_t		sub_fsb;
-	xfs_extlen_t		sub_len;
+	struct xfs_bitmap_range	*br;
+	struct xfs_bitmap_range	*new_br;
+	struct xfs_bitmap_range	*sub_br;
+	uint64_t		sub_start;
+	uint64_t		sub_len;
 	int			state;
 	int			error = 0;
 
-	if (list_empty(&exlist->list) || list_empty(&sublist->list))
+	if (list_empty(&bitmap->list) || list_empty(&sub->list))
 		return 0;
-	ASSERT(!list_empty(&sublist->list));
+	ASSERT(!list_empty(&sub->list));
 
-	list_sort(NULL, &exlist->list, xrep_btree_extent_cmp);
-	list_sort(NULL, &sublist->list, xrep_btree_extent_cmp);
+	list_sort(NULL, &bitmap->list, xfs_bitmap_range_cmp);
+	list_sort(NULL, &sub->list, xfs_bitmap_range_cmp);
 
 	/*
-	 * Now that we've sorted both lists, we iterate exlist once, rolling
-	 * forward through sublist and/or exlist as necessary until we find an
+	 * Now that we've sorted both lists, we iterate bitmap once, rolling
+	 * forward through sub and/or bitmap as necessary until we find an
 	 * overlap or reach the end of either list.  We do not reset lp to the
-	 * head of exlist nor do we reset subex to the head of sublist.  The
+	 * head of bitmap nor do we reset sub_br to the head of sub.  The
 	 * list traversal is similar to merge sort, but we're deleting
 	 * instead.  In this manner we avoid O(n^2) operations.
 	 */
-	subex = list_first_entry(&sublist->list, struct xrep_extent,
+	sub_br = list_first_entry(&sub->list, struct xfs_bitmap_range,
 			list);
-	lp = exlist->list.next;
-	while (lp != &exlist->list) {
-		ex = list_entry(lp, struct xrep_extent, list);
+	lp = bitmap->list.next;
+	while (lp != &bitmap->list) {
+		br = list_entry(lp, struct xfs_bitmap_range, list);
 
 		/*
-		 * Advance subex and/or ex until we find a pair that
+		 * Advance sub_br and/or br until we find a pair that
 		 * intersect or we run out of extents.
 		 */
-		while (subex->fsbno + subex->len <= ex->fsbno) {
-			if (list_is_last(&subex->list, &sublist->list))
+		while (sub_br->start + sub_br->len <= br->start) {
+			if (list_is_last(&sub_br->list, &sub->list))
 				goto out;
-			subex = list_next_entry(subex, list);
+			sub_br = list_next_entry(sub_br, list);
 		}
-		if (subex->fsbno >= ex->fsbno + ex->len) {
+		if (sub_br->start >= br->start + br->len) {
 			lp = lp->next;
 			continue;
 		}
 
-		/* trim subex to fit the extent we have */
-		sub_fsb = subex->fsbno;
-		sub_len = subex->len;
-		if (subex->fsbno < ex->fsbno) {
-			sub_len -= ex->fsbno - subex->fsbno;
-			sub_fsb = ex->fsbno;
+		/* trim sub_br to fit the extent we have */
+		sub_start = sub_br->start;
+		sub_len = sub_br->len;
+		if (sub_br->start < br->start) {
+			sub_len -= br->start - sub_br->start;
+			sub_start = br->start;
 		}
-		if (sub_len > ex->len)
-			sub_len = ex->len;
+		if (sub_len > br->len)
+			sub_len = br->len;
 
 		state = 0;
-		if (sub_fsb == ex->fsbno)
+		if (sub_start == br->start)
 			state |= LEFT_ALIGNED;
-		if (sub_fsb + sub_len == ex->fsbno + ex->len)
+		if (sub_start + sub_len == br->start + br->len)
 			state |= RIGHT_ALIGNED;
 		switch (state) {
 		case LEFT_ALIGNED:
 			/* Coincides with only the left. */
-			ex->fsbno += sub_len;
-			ex->len -= sub_len;
+			br->start += sub_len;
+			br->len -= sub_len;
 			break;
 		case RIGHT_ALIGNED:
 			/* Coincides with only the right. */
-			ex->len -= sub_len;
+			br->len -= sub_len;
 			lp = lp->next;
 			break;
 		case LEFT_ALIGNED | RIGHT_ALIGNED:
 			/* Total overlap, just delete ex. */
 			lp = lp->next;
-			list_del(&ex->list);
-			kmem_free(ex);
+			list_del(&br->list);
+			kmem_free(br);
 			break;
 		case 0:
 			/*
 			 * Deleting from the middle: add the new right extent
 			 * and then shrink the left extent.
 			 */
-			newex = kmem_alloc(sizeof(struct xrep_extent),
+			new_br = kmem_alloc(sizeof(struct xfs_bitmap_range),
 					KM_MAYFAIL);
-			if (!newex) {
+			if (!new_br) {
 				error = -ENOMEM;
 				goto out;
 			}
-			INIT_LIST_HEAD(&newex->list);
-			newex->fsbno = sub_fsb + sub_len;
-			newex->len = ex->fsbno + ex->len - newex->fsbno;
-			list_add(&newex->list, &ex->list);
-			ex->len = sub_fsb - ex->fsbno;
+			INIT_LIST_HEAD(&new_br->list);
+			new_br->start = sub_start + sub_len;
+			new_br->len = br->start + br->len - new_br->start;
+			list_add(&new_br->list, &br->list);
+			br->len = sub_start - br->start;
 			lp = lp->next;
 			break;
 		default:
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 1038157695a8..dad652ee9177 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,32 +6,27 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
-struct xrep_extent {
+struct xfs_bitmap_range {
 	struct list_head	list;
-	xfs_fsblock_t		fsbno;
-	xfs_extlen_t		len;
+	uint64_t		start;
+	uint64_t		len;
 };
 
-struct xrep_extent_list {
+struct xfs_bitmap {
 	struct list_head	list;
 };
 
-static inline void
-xrep_init_extent_list(
-	struct xrep_extent_list		*exlist)
-{
-	INIT_LIST_HEAD(&exlist->list);
-}
+void xfs_bitmap_init(struct xfs_bitmap *bitmap);
+void xfs_bitmap_destroy(struct xfs_bitmap *bitmap);
 
-#define for_each_xrep_extent_safe(rbe, n, exlist) \
-	list_for_each_entry_safe((rbe), (n), &(exlist)->list, list)
-int xrep_collect_btree_extent(struct xfs_scrub *sc,
-		struct xrep_extent_list *btlist, xfs_fsblock_t fsbno,
-		xfs_extlen_t len);
-void xrep_cancel_btree_extents(struct xfs_scrub *sc,
-		struct xrep_extent_list *btlist);
-int xrep_subtract_extents(struct xfs_scrub *sc,
-		struct xrep_extent_list *exlist,
-		struct xrep_extent_list *sublist);
+#define for_each_xfs_bitmap_extent(bex, n, bitmap) \
+	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list)
+
+#define for_each_xfs_bitmap_block(b, bex, n, bitmap) \
+	list_for_each_entry_safe((bex), (n), &(bitmap)->list, list) \
+		for ((b) = bex->start; (b) < bex->start + bex->len; (b)++)
+
+int xfs_bitmap_set(struct xfs_bitmap *bitmap, uint64_t start, uint64_t len);
+int xfs_bitmap_disunion(struct xfs_bitmap *bitmap, struct xfs_bitmap *sub);
 
 #endif	/* __XFS_SCRUB_BITMAP_H__ */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 27a904ef6189..85b048b341a0 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -368,17 +368,17 @@ xrep_init_btblock(
  *
  * However, that leaves the matter of removing all the metadata describing the
  * old broken structure.  For primary metadata we use the rmap data to collect
- * every extent with a matching rmap owner (exlist); we then iterate all other
+ * every extent with a matching rmap owner (bitmap); we then iterate all other
  * metadata structures with the same rmap owner to collect the extents that
- * cannot be removed (sublist).  We then subtract sublist from exlist to
+ * cannot be removed (sublist).  We then subtract sublist from bitmap to
  * derive the blocks that were used by the old btree.  These blocks can be
  * reaped.
  *
  * For rmapbt reconstructions we must use different tactics for extent
  * collection.  First we iterate all primary metadata (this excludes the old
  * rmapbt, obviously) to generate new rmap records.  The gaps in the rmap
- * records are collected as exlist.  The bnobt records are collected as
- * sublist.  As with the other btrees we subtract sublist from exlist, and the
+ * records are collected as bitmap.  The bnobt records are collected as
+ * sublist.  As with the other btrees we subtract sublist from bitmap, and the
  * result (since the rmapbt lives in the free space) are the blocks from the
  * old rmapbt.
  *
@@ -386,11 +386,11 @@ xrep_init_btblock(
  *
  * Now that we've constructed a new btree to replace the damaged one, we want
  * to dispose of the blocks that (we think) the old btree was using.
- * Previously, we used the rmapbt to collect the extents (exlist) with the
+ * Previously, we used the rmapbt to collect the extents (bitmap) with the
  * rmap owner corresponding to the tree we rebuilt, collected extents for any
  * blocks with the same rmap owner that are owned by another data structure
- * (sublist), and subtracted sublist from exlist.  In theory the extents
- * remaining in exlist are the old btree's blocks.
+ * (sublist), and subtracted sublist from bitmap.  In theory the extents
+ * remaining in bitmap are the old btree's blocks.
  *
  * Unfortunately, it's possible that the btree was crosslinked with other
  * blocks on disk.  The rmap data can tell us if there are multiple owners, so
@@ -406,7 +406,7 @@ xrep_init_btblock(
  * If there are no rmap records at all, we also free the block.  If the btree
  * being rebuilt lives in the free space (bnobt/cntbt/rmapbt) then there isn't
  * supposed to be a rmap record and everything is ok.  For other btrees there
- * had to have been an rmap entry for the block to have ended up on @exlist,
+ * had to have been an rmap entry for the block to have ended up on @bitmap,
  * so if it's gone now there's something wrong and the fs will shut down.
  *
  * Note: If there are multiple rmap records with only the same rmap owner as
@@ -419,7 +419,7 @@ xrep_init_btblock(
  * The caller is responsible for locking the AG headers for the entire rebuild
  * operation so that nothing else can sneak in and change the AG state while
  * we're not looking.  We also assume that the caller already invalidated any
- * buffers associated with @exlist.
+ * buffers associated with @bitmap.
  */
 
 /*
@@ -429,13 +429,12 @@ xrep_init_btblock(
 int
 xrep_invalidate_blocks(
 	struct xfs_scrub	*sc,
-	struct xrep_extent_list	*exlist)
+	struct xfs_bitmap	*bitmap)
 {
-	struct xrep_extent	*rex;
-	struct xrep_extent	*n;
+	struct xfs_bitmap_range	*bmr;
+	struct xfs_bitmap_range	*n;
 	struct xfs_buf		*bp;
 	xfs_fsblock_t		fsbno;
-	xfs_agblock_t		i;
 
 	/*
 	 * For each block in each extent, see if there's an incore buffer for
@@ -445,18 +444,16 @@ xrep_invalidate_blocks(
 	 * because we never own those; and if we can't TRYLOCK the buffer we
 	 * assume it's owned by someone else.
 	 */
-	for_each_xrep_extent_safe(rex, n, exlist) {
-		for (fsbno = rex->fsbno, i = rex->len; i > 0; fsbno++, i--) {
-			/* Skip AG headers and post-EOFS blocks */
-			if (!xfs_verify_fsbno(sc->mp, fsbno))
-				continue;
-			bp = xfs_buf_incore(sc->mp->m_ddev_targp,
-					XFS_FSB_TO_DADDR(sc->mp, fsbno),
-					XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
-			if (bp) {
-				xfs_trans_bjoin(sc->tp, bp);
-				xfs_trans_binval(sc->tp, bp);
-			}
+	for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
+		/* Skip AG headers and post-EOFS blocks */
+		if (!xfs_verify_fsbno(sc->mp, fsbno))
+			continue;
+		bp = xfs_buf_incore(sc->mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(sc->mp, fsbno),
+				XFS_FSB_TO_BB(sc->mp, 1), XBF_TRYLOCK);
+		if (bp) {
+			xfs_trans_bjoin(sc->tp, bp);
+			xfs_trans_binval(sc->tp, bp);
 		}
 	}
 
@@ -519,9 +516,9 @@ xrep_put_freelist(
 	return 0;
 }
 
-/* Dispose of a single metadata block. */
+/* Dispose of a single block. */
 STATIC int
-xrep_dispose_btree_block(
+xrep_reap_block(
 	struct xfs_scrub	*sc,
 	xfs_fsblock_t		fsbno,
 	struct xfs_owner_info	*oinfo,
@@ -593,41 +590,35 @@ xrep_dispose_btree_block(
 	return error;
 }
 
-/* Dispose of btree blocks from an old per-AG btree. */
+/* Dispose of every block of every extent in the bitmap. */
 int
-xrep_reap_btree_extents(
+xrep_reap_extents(
 	struct xfs_scrub	*sc,
-	struct xrep_extent_list	*exlist,
+	struct xfs_bitmap	*bitmap,
 	struct xfs_owner_info	*oinfo,
 	enum xfs_ag_resv_type	type)
 {
-	struct xrep_extent	*rex;
-	struct xrep_extent	*n;
+	struct xfs_bitmap_range	*bmr;
+	struct xfs_bitmap_range	*n;
+	xfs_fsblock_t		fsbno;
 	int			error = 0;
 
 	ASSERT(xfs_sb_version_hasrmapbt(&sc->mp->m_sb));
 
-	/* Dispose of every block from the old btree. */
-	for_each_xrep_extent_safe(rex, n, exlist) {
+	for_each_xfs_bitmap_block(fsbno, bmr, n, bitmap) {
 		ASSERT(sc->ip != NULL ||
-		       XFS_FSB_TO_AGNO(sc->mp, rex->fsbno) == sc->sa.agno);
-
+		       XFS_FSB_TO_AGNO(sc->mp, fsbno) == sc->sa.agno);
 		trace_xrep_dispose_btree_extent(sc->mp,
-				XFS_FSB_TO_AGNO(sc->mp, rex->fsbno),
-				XFS_FSB_TO_AGBNO(sc->mp, rex->fsbno), rex->len);
+				XFS_FSB_TO_AGNO(sc->mp, fsbno),
+				XFS_FSB_TO_AGBNO(sc->mp, fsbno), 1);
 
-		for (; rex->len > 0; rex->len--, rex->fsbno++) {
-			error = xrep_dispose_btree_block(sc, rex->fsbno,
-					oinfo, type);
-			if (error)
-				goto out;
-		}
-		list_del(&rex->list);
-		kmem_free(rex);
+		error = xrep_reap_block(sc, fsbno, oinfo, type);
+		if (error)
+			goto out;
 	}
 
 out:
-	xrep_cancel_btree_extents(sc, exlist);
+	xfs_bitmap_destroy(bitmap);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index a3d491a438f4..5a4e92221916 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -27,13 +27,11 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
 
-struct xrep_extent_list;
+struct xfs_bitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
-int xrep_invalidate_blocks(struct xfs_scrub *sc,
-		struct xrep_extent_list *btlist);
-int xrep_reap_btree_extents(struct xfs_scrub *sc,
-		struct xrep_extent_list *exlist,
+int xrep_invalidate_blocks(struct xfs_scrub *sc, struct xfs_bitmap *btlist);
+int xrep_reap_extents(struct xfs_scrub *sc, struct xfs_bitmap *exlist,
 		struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 struct xrep_find_ag_btree {
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 93db22c39b51..4e20f0e48232 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -511,7 +511,6 @@ DEFINE_EVENT(xrep_extent_class, name, \
 		 xfs_agblock_t agbno, xfs_extlen_t len), \
 	TP_ARGS(mp, agno, agbno, len))
 DEFINE_REPAIR_EXTENT_EVENT(xrep_dispose_btree_extent);
-DEFINE_REPAIR_EXTENT_EVENT(xrep_collect_btree_extent);
 DEFINE_REPAIR_EXTENT_EVENT(xrep_agfl_insert);
 
 DECLARE_EVENT_CLASS(xrep_rmap_class,

