Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFCC9C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:38:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJBSih (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiJBSig (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:38:36 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEB03C14C
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:38:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01B3DCE0A4A
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38565C433D6;
        Sun,  2 Oct 2022 18:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735911;
        bh=xoQP+TxquuNNgoMV5pPSmV0Tb5s9NlXA1okLDVk9t3g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=leFMPxNjkiiMuhzrJreUJ43gXt31bobRHO8dSdutrb4sI+DuRvBHGB3BgC6yX/qrh
         HzmJzNKW3/xboWseZmvcdln4q9Ftu0rIs0ZBU4SPH/Jaultdbx0Gd/IqGNZHIvJYfg
         5KNlJbFWZGqE4vyRhbXCC/aZCfPt5VNJrUy2ygWLHnRs4ec5F6dedQmfeRK+SE/PAN
         UR1+w+wfwNT26Fvb2apzaSd+6KcYz/fNJ/O/Y7qp9FReqYLHwTtrKCoDy7Iy4Xn9lL
         Bl+GnFJTFROQApprhXphgQSzagkNDS1zuijaqRFVKulupp+ebe+L0JWL/3TTzVAvc0
         8toVcae4LJ2xA==
Subject: [PATCH 3/3] xfs: convert xbitmap to interval tree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:44 -0700
Message-ID: <166473484457.1085359.3279530640209708925.stgit@magnolia>
In-Reply-To: <166473484410.1085359.13141946672747602766.stgit@magnolia>
References: <166473484410.1085359.13141946672747602766.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert the xbitmap code to use interval trees instead of linked lists.
This reduces the amount of coding required to handle the disunion
operation and in the future will make it easier to set bits in arbitrary
order yet later be able to extract maximally sized extents, which we'll
need for rebuilding certain structures.  We define our own interval tree
type so that it can deal with 64-bit indices even on 32-bit machines.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |   12 +
 fs/xfs/scrub/bitmap.c          |  323 ++++++++++++++++++++++------------------
 fs/xfs/scrub/bitmap.h          |   11 -
 3 files changed, 187 insertions(+), 159 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 26bce2f12b09..c22dc71fdd82 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -662,7 +662,7 @@ xrep_agfl_fill(
 }
 
 /* Write out a totally new AGFL. */
-STATIC void
+STATIC int
 xrep_agfl_init_header(
 	struct xfs_scrub	*sc,
 	struct xfs_buf		*agfl_bp,
@@ -675,6 +675,7 @@ xrep_agfl_init_header(
 	};
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_agfl		*agfl;
+	int			error;
 
 	ASSERT(flcount <= xfs_agfl_size(mp));
 
@@ -696,12 +697,15 @@ xrep_agfl_init_header(
 	xbitmap_init(&af.used_extents);
 	af.agfl_bno = xfs_buf_to_agfl_bno(agfl_bp),
 	xbitmap_walk(agfl_extents, xrep_agfl_fill, &af);
-	xbitmap_disunion(agfl_extents, &af.used_extents);
+	error = xbitmap_disunion(agfl_extents, &af.used_extents);
+	if (error)
+		return error;
 
 	/* Write new AGFL to disk. */
 	xfs_trans_buf_set_type(sc->tp, agfl_bp, XFS_BLFT_AGFL_BUF);
 	xfs_trans_log_buf(sc->tp, agfl_bp, 0, BBTOB(agfl_bp->b_length) - 1);
 	xbitmap_destroy(&af.used_extents);
+	return 0;
 }
 
 /* Repair the AGFL. */
@@ -754,7 +758,9 @@ xrep_agfl(
 	 * buffers until we know that part works.
 	 */
 	xrep_agfl_update_agf(sc, agf_bp, flcount);
-	xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
+	error = xrep_agfl_init_header(sc, agfl_bp, &agfl_extents, flcount);
+	if (error)
+		goto err;
 
 	/*
 	 * Ok, the AGFL should be ready to go now.  Roll the transaction to
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index f8ebc4d61462..1b04d2ce020a 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -13,31 +13,160 @@
 #include "scrub/scrub.h"
 #include "scrub/bitmap.h"
 
+#include <linux/interval_tree_generic.h>
+
+struct xbitmap_node {
+	struct rb_node	bn_rbnode;
+
+	/* First set bit of this interval and subtree. */
+	uint64_t	bn_start;
+
+	/* Last set bit of this interval. */
+	uint64_t	bn_last;
+
+	/* Last set bit of this subtree.  Do not touch this. */
+	uint64_t	__bn_subtree_last;
+};
+
+/* Define our own interval tree type with uint64_t parameters. */
+
+#define START(node) ((node)->bn_start)
+#define LAST(node)  ((node)->bn_last)
+
+/*
+ * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
+ * forward-declare them anyway for clarity.
+ */
+static inline void
+xbitmap_tree_insert(struct xbitmap_node *node, struct rb_root_cached *root);
+
+static inline void
+xbitmap_tree_remove(struct xbitmap_node *node, struct rb_root_cached *root);
+
+static inline struct xbitmap_node *
+xbitmap_tree_iter_first(struct rb_root_cached *root, uint64_t start,
+			uint64_t last);
+
+static inline struct xbitmap_node *
+xbitmap_tree_iter_next(struct xbitmap_node *node, uint64_t start,
+		       uint64_t last);
+
+INTERVAL_TREE_DEFINE(struct xbitmap_node, bn_rbnode, uint64_t,
+		__bn_subtree_last, START, LAST, static inline, xbitmap_tree)
+
 /* Iterate each interval of a bitmap.  Do not change the bitmap. */
-#define for_each_xbitmap_extent(bex, bitmap) \
-	list_for_each_entry((bex), &(bitmap)->list, list)
-
-/*
- * Set a range of this bitmap.  Caller must ensure the range is not set.
- *
- * This is the logical equivalent of bitmap |= mask(start, len).
- */
+#define for_each_xbitmap_extent(bn, bitmap) \
+	for ((bn) = rb_entry_safe(rb_first(&(bitmap)->xb_root.rb_root), \
+				   struct xbitmap_node, bn_rbnode); \
+	     (bn) != NULL; \
+	     (bn) = rb_entry_safe(rb_next(&(bn)->bn_rbnode), \
+				   struct xbitmap_node, bn_rbnode))
+
+/* Clear a range of this bitmap. */
+int
+xbitmap_clear(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		len)
+{
+	struct xbitmap_node	*bn;
+	struct xbitmap_node	*new_bn;
+	uint64_t		last = start + len - 1;
+
+	while ((bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last))) {
+		if (bn->bn_start < start && bn->bn_last > last) {
+			uint64_t	old_last = bn->bn_last;
+
+			/* overlaps with the entire clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_last = start - 1;
+			xbitmap_tree_insert(bn, &bitmap->xb_root);
+
+			/* add an extent */
+			new_bn = kmalloc(sizeof(struct xbitmap_node),
+					XCHK_GFP_FLAGS);
+			if (!new_bn)
+				return -ENOMEM;
+			new_bn->bn_start = last + 1;
+			new_bn->bn_last = old_last;
+			xbitmap_tree_insert(new_bn, &bitmap->xb_root);
+		} else if (bn->bn_start < start) {
+			/* overlaps with the left side of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_last = start - 1;
+			xbitmap_tree_insert(bn, &bitmap->xb_root);
+		} else if (bn->bn_last > last) {
+			/* overlaps with the right side of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_start = last + 1;
+			xbitmap_tree_insert(bn, &bitmap->xb_root);
+			break;
+		} else {
+			/* in the middle of the clearing range */
+			xbitmap_tree_remove(bn, &bitmap->xb_root);
+			kfree(bn);
+		}
+	}
+
+	return 0;
+}
+
+/* Set a range of this bitmap. */
 int
 xbitmap_set(
 	struct xbitmap		*bitmap,
 	uint64_t		start,
 	uint64_t		len)
 {
-	struct xbitmap_range	*bmr;
+	struct xbitmap_node	*left;
+	struct xbitmap_node	*right;
+	uint64_t		last = start + len - 1;
+	int			error;
 
-	bmr = kmalloc(sizeof(struct xbitmap_range), XCHK_GFP_FLAGS);
-	if (!bmr)
-		return -ENOMEM;
+	/* Is this whole range already set? */
+	left = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (left && left->bn_start <= start && left->bn_last >= last)
+		return 0;
 
-	INIT_LIST_HEAD(&bmr->list);
-	bmr->start = start;
-	bmr->len = len;
-	list_add_tail(&bmr->list, &bitmap->list);
+	/* Clear out everything in the range we want to set. */
+	error = xbitmap_clear(bitmap, start, len);
+	if (error)
+		return error;
+
+	/* Do we have a left-adjacent extent? */
+	left = xbitmap_tree_iter_first(&bitmap->xb_root, start - 1, start - 1);
+	ASSERT(!left || left->bn_last + 1 == start);
+
+	/* Do we have a right-adjacent extent? */
+	right = xbitmap_tree_iter_first(&bitmap->xb_root, last + 1, last + 1);
+	ASSERT(!right || right->bn_start == last + 1);
+
+	if (left && right) {
+		/* combine left and right adjacent extent */
+		xbitmap_tree_remove(left, &bitmap->xb_root);
+		xbitmap_tree_remove(right, &bitmap->xb_root);
+		left->bn_last = right->bn_last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+		kfree(right);
+	} else if (left) {
+		/* combine with left extent */
+		xbitmap_tree_remove(left, &bitmap->xb_root);
+		left->bn_last = last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+	} else if (right) {
+		/* combine with right extent */
+		xbitmap_tree_remove(right, &bitmap->xb_root);
+		right->bn_start = start;
+		xbitmap_tree_insert(right, &bitmap->xb_root);
+	} else {
+		/* add an extent */
+		left = kmalloc(sizeof(struct xbitmap_node), XCHK_GFP_FLAGS);
+		if (!left)
+			return -ENOMEM;
+		left->bn_start = start;
+		left->bn_last = last;
+		xbitmap_tree_insert(left, &bitmap->xb_root);
+	}
 
 	return 0;
 }
@@ -47,11 +176,11 @@ void
 xbitmap_destroy(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr, *n;
+	struct xbitmap_node	*bn;
 
-	list_for_each_entry_safe(bmr, n, &bitmap->list, list) {
-		list_del(&bmr->list);
-		kfree(bmr);
+	while ((bn = xbitmap_tree_iter_first(&bitmap->xb_root, 0, -1ULL))) {
+		xbitmap_tree_remove(bn, &bitmap->xb_root);
+		kfree(bn);
 	}
 }
 
@@ -60,27 +189,7 @@ void
 xbitmap_init(
 	struct xbitmap		*bitmap)
 {
-	INIT_LIST_HEAD(&bitmap->list);
-}
-
-/* Compare two btree extents. */
-static int
-xbitmap_range_cmp(
-	void			*priv,
-	const struct list_head	*a,
-	const struct list_head	*b)
-{
-	struct xbitmap_range	*ap;
-	struct xbitmap_range	*bp;
-
-	ap = container_of(a, struct xbitmap_range, list);
-	bp = container_of(b, struct xbitmap_range, list);
-
-	if (ap->start > bp->start)
-		return 1;
-	if (ap->start < bp->start)
-		return -1;
-	return 0;
+	bitmap->xb_root = RB_ROOT_CACHED;
 }
 
 /*
@@ -97,118 +206,26 @@ xbitmap_range_cmp(
  *
  * This is the logical equivalent of bitmap &= ~sub.
  */
-#define LEFT_ALIGNED	(1 << 0)
-#define RIGHT_ALIGNED	(1 << 1)
 int
 xbitmap_disunion(
 	struct xbitmap		*bitmap,
 	struct xbitmap		*sub)
 {
-	struct list_head	*lp;
-	struct xbitmap_range	*br;
-	struct xbitmap_range	*new_br;
-	struct xbitmap_range	*sub_br;
-	uint64_t		sub_start;
-	uint64_t		sub_len;
-	int			state;
-	int			error = 0;
+	struct xbitmap_node	*bn;
+	int			error;
 
-	if (list_empty(&bitmap->list) || list_empty(&sub->list))
+	if (xbitmap_empty(bitmap) || xbitmap_empty(sub))
 		return 0;
-	ASSERT(!list_empty(&sub->list));
 
-	list_sort(NULL, &bitmap->list, xbitmap_range_cmp);
-	list_sort(NULL, &sub->list, xbitmap_range_cmp);
-
-	/*
-	 * Now that we've sorted both lists, we iterate bitmap once, rolling
-	 * forward through sub and/or bitmap as necessary until we find an
-	 * overlap or reach the end of either list.  We do not reset lp to the
-	 * head of bitmap nor do we reset sub_br to the head of sub.  The
-	 * list traversal is similar to merge sort, but we're deleting
-	 * instead.  In this manner we avoid O(n^2) operations.
-	 */
-	sub_br = list_first_entry(&sub->list, struct xbitmap_range,
-			list);
-	lp = bitmap->list.next;
-	while (lp != &bitmap->list) {
-		br = list_entry(lp, struct xbitmap_range, list);
-
-		/*
-		 * Advance sub_br and/or br until we find a pair that
-		 * intersect or we run out of extents.
-		 */
-		while (sub_br->start + sub_br->len <= br->start) {
-			if (list_is_last(&sub_br->list, &sub->list))
-				goto out;
-			sub_br = list_next_entry(sub_br, list);
-		}
-		if (sub_br->start >= br->start + br->len) {
-			lp = lp->next;
-			continue;
-		}
-
-		/* trim sub_br to fit the extent we have */
-		sub_start = sub_br->start;
-		sub_len = sub_br->len;
-		if (sub_br->start < br->start) {
-			sub_len -= br->start - sub_br->start;
-			sub_start = br->start;
-		}
-		if (sub_len > br->len)
-			sub_len = br->len;
-
-		state = 0;
-		if (sub_start == br->start)
-			state |= LEFT_ALIGNED;
-		if (sub_start + sub_len == br->start + br->len)
-			state |= RIGHT_ALIGNED;
-		switch (state) {
-		case LEFT_ALIGNED:
-			/* Coincides with only the left. */
-			br->start += sub_len;
-			br->len -= sub_len;
-			break;
-		case RIGHT_ALIGNED:
-			/* Coincides with only the right. */
-			br->len -= sub_len;
-			lp = lp->next;
-			break;
-		case LEFT_ALIGNED | RIGHT_ALIGNED:
-			/* Total overlap, just delete ex. */
-			lp = lp->next;
-			list_del(&br->list);
-			kfree(br);
-			break;
-		case 0:
-			/*
-			 * Deleting from the middle: add the new right extent
-			 * and then shrink the left extent.
-			 */
-			new_br = kmalloc(sizeof(struct xbitmap_range),
-					XCHK_GFP_FLAGS);
-			if (!new_br) {
-				error = -ENOMEM;
-				goto out;
-			}
-			INIT_LIST_HEAD(&new_br->list);
-			new_br->start = sub_start + sub_len;
-			new_br->len = br->start + br->len - new_br->start;
-			list_add(&new_br->list, &br->list);
-			br->len = sub_start - br->start;
-			lp = lp->next;
-			break;
-		default:
-			ASSERT(0);
-			break;
-		}
+	for_each_xbitmap_extent(bn, sub) {
+		error = xbitmap_clear(bitmap, bn->bn_start,
+				bn->bn_last - bn->bn_start + 1);
+		if (error)
+			return error;
 	}
 
-out:
-	return error;
+	return 0;
 }
-#undef LEFT_ALIGNED
-#undef RIGHT_ALIGNED
 
 /*
  * Record all btree blocks seen while iterating all records of a btree.
@@ -307,11 +324,11 @@ uint64_t
 xbitmap_hweight(
 	struct xbitmap		*bitmap)
 {
-	struct xbitmap_range	*bmr;
+	struct xbitmap_node	*bn;
 	uint64_t		ret = 0;
 
-	for_each_xbitmap_extent(bmr, bitmap)
-		ret += bmr->len;
+	for_each_xbitmap_extent(bn, bitmap)
+		ret += bn->bn_last - bn->bn_start + 1;
 
 	return ret;
 }
@@ -320,14 +337,14 @@ xbitmap_hweight(
 int
 xbitmap_walk(
 	struct xbitmap		*bitmap,
-	xbitmap_walk_fn	fn,
+	xbitmap_walk_fn		fn,
 	void			*priv)
 {
-	struct xbitmap_range	*bex;
+	struct xbitmap_node	*bn;
 	int			error = 0;
 
-	for_each_xbitmap_extent(bex, bitmap) {
-		error = fn(bex->start, bex->len, priv);
+	for_each_xbitmap_extent(bn, bitmap) {
+		error = fn(bn->bn_start, bn->bn_last - bn->bn_start + 1, priv);
 		if (error)
 			break;
 	}
@@ -371,3 +388,11 @@ xbitmap_walk_bits(
 
 	return xbitmap_walk(bitmap, xbitmap_walk_bits_in_run, &wb);
 }
+
+/* Does this bitmap have no bits set at all? */
+bool
+xbitmap_empty(
+	struct xbitmap		*bitmap)
+{
+	return bitmap->xb_root.rb_root.rb_node == NULL;
+}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 53601d281ffb..7afd64a318d1 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,19 +6,14 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
-struct xbitmap_range {
-	struct list_head	list;
-	uint64_t		start;
-	uint64_t		len;
-};
-
 struct xbitmap {
-	struct list_head	list;
+	struct rb_root_cached	xb_root;
 };
 
 void xbitmap_init(struct xbitmap *bitmap);
 void xbitmap_destroy(struct xbitmap *bitmap);
 
+int xbitmap_clear(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_set(struct xbitmap *bitmap, uint64_t start, uint64_t len);
 int xbitmap_disunion(struct xbitmap *bitmap, struct xbitmap *sub);
 int xbitmap_set_btcur_path(struct xbitmap *bitmap,
@@ -42,4 +37,6 @@ typedef int (*xbitmap_walk_bits_fn)(uint64_t bit, void *priv);
 int xbitmap_walk_bits(struct xbitmap *bitmap, xbitmap_walk_bits_fn fn,
 		void *priv);
 
+bool xbitmap_empty(struct xbitmap *bitmap);
+
 #endif	/* __XFS_SCRUB_BITMAP_H__ */

