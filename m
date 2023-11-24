Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BD73BB2A
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 23:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gdnak3lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B64BC433C7;
	Fri, 24 Nov 2023 23:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700869802;
	bh=PzLq/bHp/AbN9vWaogo8jOO1a42QPx6JNz3Z+jJALRg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gdnak3ljIN2TYumYcUdOza4TLWM4HQJDF4M06idpn+/E6novTkonYDgTYwfy+Lpxv
	 uEqHhFenT35YlpUFFiN1fi8izf0/N+vCbIZtykLY8PcHAiJVa/L/FAUZFjDxGipd5K
	 tVc/UN+yvvGUts8cU0gDF3Uvi+by5vKC0/80SzfYkgQRblWrzqLFJ0jL3wo7QCTnwJ
	 HPyb2lSads4EqN720mjPONmxnBwHPCfWUAl8qSjZPv/syPSeEtV9aYpQmRmR9yNfsE
	 nVZkB6MvjsYsWW6PfBYg9CiRqR5tiEybbAbzu4SP+zjEhO08pUI3MkwWrcRo+6w6dG
	 f/5EsB2bEJbMA==
Date: Fri, 24 Nov 2023 15:50:02 -0800
Subject: [PATCH 1/5] xfs: create separate structures and code for u32 bitmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170086927011.2770967.5667556103424812308.stgit@frogsfrogsfrogs>
In-Reply-To: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Create a version of the xbitmap that handles 32-bit integer intervals
and adapt the xfs_agblock_t bitmap to use it.  This reduces the size of
the interval tree nodes from 48 to 36 bytes and enables us to use a more
efficient slab (:0000040 instead of :0000048) which allows us to pack
more nodes into a single slab page (102 vs 85).

As a side effect, the users of these bitmaps no longer have to convert
between u32 and u64 quantities just to use the bitmap; and the hairy
overflow checking code in xagb_bitmap_test goes away.

Later in this patchset we're going to add bitmaps for xfs_agino_t,
xfs_rgblock_t, and xfs_dablk_t, so the increase in code size (5622 vs.
9959 bytes) seems worth it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/agheader_repair.c |    9 -
 fs/xfs/scrub/bitmap.c          |  404 ++++++++++++++++++++++++++++++++++------
 fs/xfs/scrub/bitmap.h          |   70 ++++---
 fs/xfs/scrub/reap.c            |    5 
 4 files changed, 390 insertions(+), 98 deletions(-)


diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 36c511f96b004..9d541d2087da8 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -495,12 +495,11 @@ xrep_agfl_walk_rmap(
 /* Strike out the blocks that are cross-linked according to the rmapbt. */
 STATIC int
 xrep_agfl_check_extent(
-	uint64_t		start,
-	uint64_t		len,
+	uint32_t		agbno,
+	uint32_t		len,
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
-	xfs_agblock_t		agbno = start;
 	xfs_agblock_t		last_agbno = agbno + len - 1;
 	int			error;
 
@@ -648,8 +647,8 @@ struct xrep_agfl_fill {
 /* Fill the AGFL with whatever blocks are in this extent. */
 static int
 xrep_agfl_fill(
-	uint64_t		start,
-	uint64_t		len,
+	uint32_t		start,
+	uint32_t		len,
 	void			*priv)
 {
 	struct xrep_agfl_fill	*af = priv;
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index e0c89a9a0ca07..1b5add26c1d8d 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -16,6 +16,8 @@
 
 #include <linux/interval_tree_generic.h>
 
+/* u64 bitmap */
+
 struct xbitmap_node {
 	struct rb_node	bn_rbnode;
 
@@ -228,6 +230,345 @@ xbitmap_disunion(
 	return 0;
 }
 
+/* How many bits are set in this bitmap? */
+uint64_t
+xbitmap_hweight(
+	struct xbitmap		*bitmap)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		ret = 0;
+
+	for_each_xbitmap_extent(bn, bitmap)
+		ret += bn->bn_last - bn->bn_start + 1;
+
+	return ret;
+}
+
+/* Call a function for every run of set bits in this bitmap. */
+int
+xbitmap_walk(
+	struct xbitmap		*bitmap,
+	xbitmap_walk_fn		fn,
+	void			*priv)
+{
+	struct xbitmap_node	*bn;
+	int			error = 0;
+
+	for_each_xbitmap_extent(bn, bitmap) {
+		error = fn(bn->bn_start, bn->bn_last - bn->bn_start + 1, priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+/* Does this bitmap have no bits set at all? */
+bool
+xbitmap_empty(
+	struct xbitmap		*bitmap)
+{
+	return bitmap->xb_root.rb_root.rb_node == NULL;
+}
+
+/* Is the start of the range set or clear?  And for how long? */
+bool
+xbitmap_test(
+	struct xbitmap		*bitmap,
+	uint64_t		start,
+	uint64_t		*len)
+{
+	struct xbitmap_node	*bn;
+	uint64_t		last = start + *len - 1;
+
+	bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return false;
+	if (bn->bn_start <= start) {
+		if (bn->bn_last < last)
+			*len = bn->bn_last - start + 1;
+		return true;
+	}
+	*len = bn->bn_start - start;
+	return false;
+}
+
+/* u32 bitmap */
+
+struct xbitmap32_node {
+	struct rb_node	bn_rbnode;
+
+	/* First set bit of this interval and subtree. */
+	uint32_t	bn_start;
+
+	/* Last set bit of this interval. */
+	uint32_t	bn_last;
+
+	/* Last set bit of this subtree.  Do not touch this. */
+	uint32_t	__bn_subtree_last;
+};
+
+/* Define our own interval tree type with uint32_t parameters. */
+
+/*
+ * These functions are defined by the INTERVAL_TREE_DEFINE macro, but we'll
+ * forward-declare them anyway for clarity.
+ */
+static inline void
+xbitmap32_tree_insert(struct xbitmap32_node *node, struct rb_root_cached *root);
+
+static inline void
+xbitmap32_tree_remove(struct xbitmap32_node *node, struct rb_root_cached *root);
+
+static inline struct xbitmap32_node *
+xbitmap32_tree_iter_first(struct rb_root_cached *root, uint32_t start,
+			  uint32_t last);
+
+static inline struct xbitmap32_node *
+xbitmap32_tree_iter_next(struct xbitmap32_node *node, uint32_t start,
+			 uint32_t last);
+
+INTERVAL_TREE_DEFINE(struct xbitmap32_node, bn_rbnode, uint32_t,
+		__bn_subtree_last, START, LAST, static inline, xbitmap32_tree)
+
+/* Iterate each interval of a bitmap.  Do not change the bitmap. */
+#define for_each_xbitmap32_extent(bn, bitmap) \
+	for ((bn) = rb_entry_safe(rb_first(&(bitmap)->xb_root.rb_root), \
+				   struct xbitmap32_node, bn_rbnode); \
+	     (bn) != NULL; \
+	     (bn) = rb_entry_safe(rb_next(&(bn)->bn_rbnode), \
+				   struct xbitmap32_node, bn_rbnode))
+
+/* Clear a range of this bitmap. */
+int
+xbitmap32_clear(
+	struct xbitmap32	*bitmap,
+	uint32_t		start,
+	uint32_t		len)
+{
+	struct xbitmap32_node	*bn;
+	struct xbitmap32_node	*new_bn;
+	uint32_t		last = start + len - 1;
+
+	while ((bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last))) {
+		if (bn->bn_start < start && bn->bn_last > last) {
+			uint32_t	old_last = bn->bn_last;
+
+			/* overlaps with the entire clearing range */
+			xbitmap32_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_last = start - 1;
+			xbitmap32_tree_insert(bn, &bitmap->xb_root);
+
+			/* add an extent */
+			new_bn = kmalloc(sizeof(struct xbitmap32_node),
+					XCHK_GFP_FLAGS);
+			if (!new_bn)
+				return -ENOMEM;
+			new_bn->bn_start = last + 1;
+			new_bn->bn_last = old_last;
+			xbitmap32_tree_insert(new_bn, &bitmap->xb_root);
+		} else if (bn->bn_start < start) {
+			/* overlaps with the left side of the clearing range */
+			xbitmap32_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_last = start - 1;
+			xbitmap32_tree_insert(bn, &bitmap->xb_root);
+		} else if (bn->bn_last > last) {
+			/* overlaps with the right side of the clearing range */
+			xbitmap32_tree_remove(bn, &bitmap->xb_root);
+			bn->bn_start = last + 1;
+			xbitmap32_tree_insert(bn, &bitmap->xb_root);
+			break;
+		} else {
+			/* in the middle of the clearing range */
+			xbitmap32_tree_remove(bn, &bitmap->xb_root);
+			kfree(bn);
+		}
+	}
+
+	return 0;
+}
+
+/* Set a range of this bitmap. */
+int
+xbitmap32_set(
+	struct xbitmap32	*bitmap,
+	uint32_t		start,
+	uint32_t		len)
+{
+	struct xbitmap32_node	*left;
+	struct xbitmap32_node	*right;
+	uint32_t		last = start + len - 1;
+	int			error;
+
+	/* Is this whole range already set? */
+	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
+	if (left && left->bn_start <= start && left->bn_last >= last)
+		return 0;
+
+	/* Clear out everything in the range we want to set. */
+	error = xbitmap32_clear(bitmap, start, len);
+	if (error)
+		return error;
+
+	/* Do we have a left-adjacent extent? */
+	left = xbitmap32_tree_iter_first(&bitmap->xb_root, start - 1, start - 1);
+	ASSERT(!left || left->bn_last + 1 == start);
+
+	/* Do we have a right-adjacent extent? */
+	right = xbitmap32_tree_iter_first(&bitmap->xb_root, last + 1, last + 1);
+	ASSERT(!right || right->bn_start == last + 1);
+
+	if (left && right) {
+		/* combine left and right adjacent extent */
+		xbitmap32_tree_remove(left, &bitmap->xb_root);
+		xbitmap32_tree_remove(right, &bitmap->xb_root);
+		left->bn_last = right->bn_last;
+		xbitmap32_tree_insert(left, &bitmap->xb_root);
+		kfree(right);
+	} else if (left) {
+		/* combine with left extent */
+		xbitmap32_tree_remove(left, &bitmap->xb_root);
+		left->bn_last = last;
+		xbitmap32_tree_insert(left, &bitmap->xb_root);
+	} else if (right) {
+		/* combine with right extent */
+		xbitmap32_tree_remove(right, &bitmap->xb_root);
+		right->bn_start = start;
+		xbitmap32_tree_insert(right, &bitmap->xb_root);
+	} else {
+		/* add an extent */
+		left = kmalloc(sizeof(struct xbitmap32_node), XCHK_GFP_FLAGS);
+		if (!left)
+			return -ENOMEM;
+		left->bn_start = start;
+		left->bn_last = last;
+		xbitmap32_tree_insert(left, &bitmap->xb_root);
+	}
+
+	return 0;
+}
+
+/* Free everything related to this bitmap. */
+void
+xbitmap32_destroy(
+	struct xbitmap32	*bitmap)
+{
+	struct xbitmap32_node	*bn;
+
+	while ((bn = xbitmap32_tree_iter_first(&bitmap->xb_root, 0, -1U))) {
+		xbitmap32_tree_remove(bn, &bitmap->xb_root);
+		kfree(bn);
+	}
+}
+
+/* Set up a per-AG block bitmap. */
+void
+xbitmap32_init(
+	struct xbitmap32	*bitmap)
+{
+	bitmap->xb_root = RB_ROOT_CACHED;
+}
+
+/*
+ * Remove all the blocks mentioned in @sub from the extents in @bitmap.
+ *
+ * The intent is that callers will iterate the rmapbt for all of its records
+ * for a given owner to generate @bitmap; and iterate all the blocks of the
+ * metadata structures that are not being rebuilt and have the same rmapbt
+ * owner to generate @sub.  This routine subtracts all the extents
+ * mentioned in sub from all the extents linked in @bitmap, which leaves
+ * @bitmap as the list of blocks that are not accounted for, which we assume
+ * are the dead blocks of the old metadata structure.  The blocks mentioned in
+ * @bitmap can be reaped.
+ *
+ * This is the logical equivalent of bitmap &= ~sub.
+ */
+int
+xbitmap32_disunion(
+	struct xbitmap32	*bitmap,
+	struct xbitmap32	*sub)
+{
+	struct xbitmap32_node	*bn;
+	int			error;
+
+	if (xbitmap32_empty(bitmap) || xbitmap32_empty(sub))
+		return 0;
+
+	for_each_xbitmap32_extent(bn, sub) {
+		error = xbitmap32_clear(bitmap, bn->bn_start,
+				bn->bn_last - bn->bn_start + 1);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/* How many bits are set in this bitmap? */
+uint32_t
+xbitmap32_hweight(
+	struct xbitmap32	*bitmap)
+{
+	struct xbitmap32_node	*bn;
+	uint32_t		ret = 0;
+
+	for_each_xbitmap32_extent(bn, bitmap)
+		ret += bn->bn_last - bn->bn_start + 1;
+
+	return ret;
+}
+
+/* Call a function for every run of set bits in this bitmap. */
+int
+xbitmap32_walk(
+	struct xbitmap32	*bitmap,
+	xbitmap32_walk_fn	fn,
+	void			*priv)
+{
+	struct xbitmap32_node	*bn;
+	int			error = 0;
+
+	for_each_xbitmap32_extent(bn, bitmap) {
+		error = fn(bn->bn_start, bn->bn_last - bn->bn_start + 1, priv);
+		if (error)
+			break;
+	}
+
+	return error;
+}
+
+/* Does this bitmap have no bits set at all? */
+bool
+xbitmap32_empty(
+	struct xbitmap32	*bitmap)
+{
+	return bitmap->xb_root.rb_root.rb_node == NULL;
+}
+
+/* Is the start of the range set or clear?  And for how long? */
+bool
+xbitmap32_test(
+	struct xbitmap32	*bitmap,
+	uint32_t		start,
+	uint32_t		*len)
+{
+	struct xbitmap32_node	*bn;
+	uint32_t		last = start + *len - 1;
+
+	bn = xbitmap32_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return false;
+	if (bn->bn_start <= start) {
+		if (bn->bn_last < last)
+			*len = bn->bn_last - start + 1;
+		return true;
+	}
+	*len = bn->bn_start - start;
+	return false;
+}
+
+/* xfs_agblock_t bitmap */
+
 /*
  * Record all btree blocks seen while iterating all records of a btree.
  *
@@ -316,66 +657,3 @@ xagb_bitmap_set_btcur_path(
 
 	return 0;
 }
-
-/* How many bits are set in this bitmap? */
-uint64_t
-xbitmap_hweight(
-	struct xbitmap		*bitmap)
-{
-	struct xbitmap_node	*bn;
-	uint64_t		ret = 0;
-
-	for_each_xbitmap_extent(bn, bitmap)
-		ret += bn->bn_last - bn->bn_start + 1;
-
-	return ret;
-}
-
-/* Call a function for every run of set bits in this bitmap. */
-int
-xbitmap_walk(
-	struct xbitmap		*bitmap,
-	xbitmap_walk_fn		fn,
-	void			*priv)
-{
-	struct xbitmap_node	*bn;
-	int			error = 0;
-
-	for_each_xbitmap_extent(bn, bitmap) {
-		error = fn(bn->bn_start, bn->bn_last - bn->bn_start + 1, priv);
-		if (error)
-			break;
-	}
-
-	return error;
-}
-
-/* Does this bitmap have no bits set at all? */
-bool
-xbitmap_empty(
-	struct xbitmap		*bitmap)
-{
-	return bitmap->xb_root.rb_root.rb_node == NULL;
-}
-
-/* Is the start of the range set or clear?  And for how long? */
-bool
-xbitmap_test(
-	struct xbitmap		*bitmap,
-	uint64_t		start,
-	uint64_t		*len)
-{
-	struct xbitmap_node	*bn;
-	uint64_t		last = start + *len - 1;
-
-	bn = xbitmap_tree_iter_first(&bitmap->xb_root, start, last);
-	if (!bn)
-		return false;
-	if (bn->bn_start <= start) {
-		if (bn->bn_last < last)
-			*len = bn->bn_last - start + 1;
-		return true;
-	}
-	*len = bn->bn_start - start;
-	return false;
-}
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 4fe58bad67345..9cdc41b6cb02d 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -6,6 +6,8 @@
 #ifndef __XFS_SCRUB_BITMAP_H__
 #define __XFS_SCRUB_BITMAP_H__
 
+/* u64 bitmap */
+
 struct xbitmap {
 	struct rb_root_cached	xb_root;
 };
@@ -32,72 +34,86 @@ int xbitmap_walk(struct xbitmap *bitmap, xbitmap_walk_fn fn,
 bool xbitmap_empty(struct xbitmap *bitmap);
 bool xbitmap_test(struct xbitmap *bitmap, uint64_t start, uint64_t *len);
 
+/* u32 bitmap */
+
+struct xbitmap32 {
+	struct rb_root_cached	xb_root;
+};
+
+void xbitmap32_init(struct xbitmap32 *bitmap);
+void xbitmap32_destroy(struct xbitmap32 *bitmap);
+
+int xbitmap32_clear(struct xbitmap32 *bitmap, uint32_t start, uint32_t len);
+int xbitmap32_set(struct xbitmap32 *bitmap, uint32_t start, uint32_t len);
+int xbitmap32_disunion(struct xbitmap32 *bitmap, struct xbitmap32 *sub);
+uint32_t xbitmap32_hweight(struct xbitmap32 *bitmap);
+
+/*
+ * Return codes for the bitmap iterator functions are 0 to continue iterating,
+ * and non-zero to stop iterating.  Any non-zero value will be passed up to the
+ * iteration caller.  The special value -ECANCELED can be used to stop
+ * iteration, because neither bitmap iterator ever generates that error code on
+ * its own.  Callers must not modify the bitmap while walking it.
+ */
+typedef int (*xbitmap32_walk_fn)(uint32_t start, uint32_t len, void *priv);
+int xbitmap32_walk(struct xbitmap32 *bitmap, xbitmap32_walk_fn fn,
+		void *priv);
+
+bool xbitmap32_empty(struct xbitmap32 *bitmap);
+bool xbitmap32_test(struct xbitmap32 *bitmap, uint32_t start, uint32_t *len);
+
 /* Bitmaps, but for type-checked for xfs_agblock_t */
 
 struct xagb_bitmap {
-	struct xbitmap	agbitmap;
+	struct xbitmap32	agbitmap;
 };
 
 static inline void xagb_bitmap_init(struct xagb_bitmap *bitmap)
 {
-	xbitmap_init(&bitmap->agbitmap);
+	xbitmap32_init(&bitmap->agbitmap);
 }
 
 static inline void xagb_bitmap_destroy(struct xagb_bitmap *bitmap)
 {
-	xbitmap_destroy(&bitmap->agbitmap);
+	xbitmap32_destroy(&bitmap->agbitmap);
 }
 
 static inline int xagb_bitmap_clear(struct xagb_bitmap *bitmap,
 		xfs_agblock_t start, xfs_extlen_t len)
 {
-	return xbitmap_clear(&bitmap->agbitmap, start, len);
+	return xbitmap32_clear(&bitmap->agbitmap, start, len);
 }
 static inline int xagb_bitmap_set(struct xagb_bitmap *bitmap,
 		xfs_agblock_t start, xfs_extlen_t len)
 {
-	return xbitmap_set(&bitmap->agbitmap, start, len);
+	return xbitmap32_set(&bitmap->agbitmap, start, len);
 }
 
-static inline bool
-xagb_bitmap_test(
-	struct xagb_bitmap	*bitmap,
-	xfs_agblock_t		start,
-	xfs_extlen_t		*len)
+static inline bool xagb_bitmap_test(struct xagb_bitmap *bitmap,
+		xfs_agblock_t start, xfs_extlen_t *len)
 {
-	uint64_t		biglen = *len;
-	bool			ret;
-
-	ret = xbitmap_test(&bitmap->agbitmap, start, &biglen);
-
-	if (start + biglen >= UINT_MAX) {
-		ASSERT(0);
-		biglen = UINT_MAX - start;
-	}
-
-	*len = biglen;
-	return ret;
+	return xbitmap32_test(&bitmap->agbitmap, start, len);
 }
 
 static inline int xagb_bitmap_disunion(struct xagb_bitmap *bitmap,
 		struct xagb_bitmap *sub)
 {
-	return xbitmap_disunion(&bitmap->agbitmap, &sub->agbitmap);
+	return xbitmap32_disunion(&bitmap->agbitmap, &sub->agbitmap);
 }
 
 static inline uint32_t xagb_bitmap_hweight(struct xagb_bitmap *bitmap)
 {
-	return xbitmap_hweight(&bitmap->agbitmap);
+	return xbitmap32_hweight(&bitmap->agbitmap);
 }
 static inline bool xagb_bitmap_empty(struct xagb_bitmap *bitmap)
 {
-	return xbitmap_empty(&bitmap->agbitmap);
+	return xbitmap32_empty(&bitmap->agbitmap);
 }
 
 static inline int xagb_bitmap_walk(struct xagb_bitmap *bitmap,
-		xbitmap_walk_fn fn, void *priv)
+		xbitmap32_walk_fn fn, void *priv)
 {
-	return xbitmap_walk(&bitmap->agbitmap, fn, priv);
+	return xbitmap32_walk(&bitmap->agbitmap, fn, priv);
 }
 
 int xagb_bitmap_set_btblocks(struct xagb_bitmap *bitmap,
diff --git a/fs/xfs/scrub/reap.c b/fs/xfs/scrub/reap.c
index ee26fcb500b78..c8c8e3f9bc7a4 100644
--- a/fs/xfs/scrub/reap.c
+++ b/fs/xfs/scrub/reap.c
@@ -430,13 +430,12 @@ xreap_agextent_iter(
  */
 STATIC int
 xreap_agmeta_extent(
-	uint64_t		fsbno,
-	uint64_t		len,
+	uint32_t		agbno,
+	uint32_t		len,
 	void			*priv)
 {
 	struct xreap_state	*rs = priv;
 	struct xfs_scrub	*sc = rs->sc;
-	xfs_agblock_t		agbno = fsbno;
 	xfs_agblock_t		agbno_next = agbno + len;
 	int			error = 0;
 

