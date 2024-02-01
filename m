Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A4C8527B
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816710; cv=none; b=l0IwXS9OB957sRy+N2M1cDg5vqX0/gv3LtUbXWxI1umSE+Q2tIPVvsTLnxALWESeGRIcQlCsjMBwd1GKwOBnku5LAkQeMd3i9/r5yaCbSho/IMZpzujLDH6ItuFi1iAaZM9lo/z1v+ni6DA3J7A+g4oyIQTU41Air4FM6+kPDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816710; c=relaxed/simple;
	bh=/H9Lsqv9WJVn+4Y5lXI9U8HLrKAoO5b9XUpq17an9/Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyJJ+46S9v2fzqMzG8zk1lBOYLhtGuVNur9exzQx53BQUOOtzmbP23HqHdoSZiYk0ANHWBXOXrAXJrJJWASnqERK931QTrqhR8tJX6kueKRlc2ouNN4PXQ7Mp4vlCcGBtTJdyDPdrT0992B96EWE3EkIJqiy4eSf3kBsy5cQG7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HtuRr/k5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HtuRr/k5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16766C433F1;
	Thu,  1 Feb 2024 19:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816709;
	bh=/H9Lsqv9WJVn+4Y5lXI9U8HLrKAoO5b9XUpq17an9/Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HtuRr/k5X3dJHIhcvJKQCXqy+FTVox4kbZXkfNBE36U1nbsCMOqf35X/Qsqfwzv7i
	 eSMbka73Rtb87bEXZc3mtvvRlsX/zpfej0drBwIupBwyQCfcPbkfyvpNHvQ2rRTqMC
	 lMtUrJallEvAXA8NAiiK7OR0G4sVgZkA9Ui5SJHl63wFPje1RqS8qhsIWcjYPVyMnI
	 j2KbKWAEIWD/GxP3nzgX7J4wzKNWHQbgE8EvcTi/wyLkM6HYnn2H1LMZgdkCO1HrRg
	 1KvO/2N4xO07xVh6KzXYQm2hXlWaGpzz/vK8PYjB/UZXQL6HXBbsNAobvjXX2kDk/V
	 GzvhaEkVXzoLw==
Date: Thu, 01 Feb 2024 11:45:08 -0800
Subject: [PATCH 21/23] xfs: split out a btree type from the btree ops geometry
 flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334283.1604831.6966472906593365276.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Two of the btree cursor flags are always used together and encode
the fundamental btree type.  There currently are two such types:

 1) an on-disk AG-rooted btree with 32-bit pointers
 2) an on-disk inode-rooted btree with 64-bit pointers

and we're about to add:

 3) an in-memory btree with 64-bit pointers

Introduce a new enum and a new type field in struct xfs_btree_geom
to encode this type directly instead of using flags and change most
code to switch on this enum.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: make the pointer lengths explicit]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    3 ++
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +
 fs/xfs/libxfs/xfs_btree.c          |   66 ++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_btree.h          |   15 ++++++--
 fs/xfs/libxfs/xfs_btree_staging.c  |   12 +++----
 fs/xfs/libxfs/xfs_btree_staging.h  |    3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    4 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |    1 +
 fs/xfs/scrub/btree.c               |   12 +++----
 fs/xfs/scrub/trace.c               |    2 +
 fs/xfs/xfs_trace.h                 |    4 +-
 12 files changed, 74 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 9b81b4407444f..7d9798535dba9 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -455,6 +455,8 @@ xfs_allocbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bnobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
@@ -482,6 +484,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_cntbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 59a5f75a45e14..90ab644b98b4e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -525,7 +525,7 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
-	.geom_flags		= XFS_BTGEO_ROOT_IN_INODE,
+	.type			= XFS_BTREE_TYPE_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1c15f20cb8ac5..f5f98928dc3d1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -447,10 +447,19 @@ xfs_btree_del_cursor(
 	 */
 	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
+
+	switch (cur->bc_ops->type) {
+	case XFS_BTREE_TYPE_AG:
+		if (cur->bc_ag.pag)
+			xfs_perag_put(cur->bc_ag.pag);
+		break;
+	case XFS_BTREE_TYPE_INODE:
+		/* nothing to do */
+		break;
+	}
+
 	if (unlikely(cur->bc_flags & XFS_BTREE_STAGING))
 		kmem_free(cur->bc_ops);
-	if (!(cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) && cur->bc_ag.pag)
-		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
@@ -708,7 +717,7 @@ struct xfs_ifork *
 xfs_btree_ifork_ptr(
 	struct xfs_btree_cur	*cur)
 {
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 
 	if (cur->bc_flags & XFS_BTREE_STAGING)
 		return cur->bc_ino.ifake->if_fork;
@@ -740,8 +749,8 @@ xfs_btree_get_block(
 	int			level,	/* level in btree */
 	struct xfs_buf		**bpp)	/* buffer containing the block */
 {
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level == cur->bc_nlevels - 1)) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    level == cur->bc_nlevels - 1) {
 		*bpp = NULL;
 		return xfs_btree_get_iroot(cur);
 	}
@@ -983,8 +992,8 @@ xfs_btree_readahead(
 	 * No readahead needed if we are at the root level and the
 	 * btree root is stored in the inode.
 	 */
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (lev == cur->bc_nlevels - 1))
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    lev == cur->bc_nlevels - 1)
 		return 0;
 
 	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
@@ -1172,14 +1181,12 @@ __xfs_btree_init_block(
 			buf->bb_u.l.bb_lsn = 0;
 		}
 	} else {
-		/* owner is a 32 bit value on short blocks */
-		__u32 __owner = (__u32)owner;
-
 		buf->bb_u.s.bb_leftsib = cpu_to_be32(NULLAGBLOCK);
 		buf->bb_u.s.bb_rightsib = cpu_to_be32(NULLAGBLOCK);
 		if (crc) {
 			buf->bb_u.s.bb_blkno = cpu_to_be64(blkno);
-			buf->bb_u.s.bb_owner = cpu_to_be32(__owner);
+			/* owner is a 32 bit value on short blocks */
+			buf->bb_u.s.bb_owner = cpu_to_be32((__u32)owner);
 			uuid_copy(&buf->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid);
 			buf->bb_u.s.bb_lsn = 0;
 		}
@@ -1217,7 +1224,7 @@ static inline __u64
 xfs_btree_owner(
 	struct xfs_btree_cur    *cur)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 		return cur->bc_ino.ip->i_ino;
 	return cur->bc_ag.pag->pag_agno;
 }
@@ -1638,7 +1645,7 @@ xfs_btree_increment(
 	 * confused or have the tree root in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1732,7 +1739,7 @@ xfs_btree_decrement(
 	 * or the root of the tree is in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1807,8 +1814,8 @@ xfs_btree_lookup_get_block(
 	int			error = 0;
 
 	/* special case the root block if in an inode */
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level == cur->bc_nlevels - 1)) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    level == cur->bc_nlevels - 1) {
 		*blkp = xfs_btree_get_iroot(cur);
 		return 0;
 	}
@@ -2343,7 +2350,7 @@ xfs_btree_lshift(
 	int			error;		/* error return value */
 	int			i;
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->type == XFS_BTREE_TYPE_INODE) &&
 	    level == cur->bc_nlevels - 1)
 		goto out0;
 
@@ -2539,8 +2546,8 @@ xfs_btree_rshift(
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level == cur->bc_nlevels - 1))
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    level == cur->bc_nlevels - 1)
 		goto out0;
 
 	/* Set up variables for this block as "left". */
@@ -2990,7 +2997,6 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
-
 /*
  * Copy the old inode root contents into a real block and make the
  * broot point to it.
@@ -3015,7 +3021,7 @@ xfs_btree_new_iroot(
 
 	XFS_BTREE_STATS_INC(cur, newroot);
 
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 
 	level = cur->bc_nlevels - 1;
 
@@ -3240,7 +3246,7 @@ xfs_btree_make_block_unfull(
 {
 	int			error = 0;
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == cur->bc_nlevels - 1) {
 		struct xfs_inode *ip = cur->bc_ino.ip;
 
@@ -3326,8 +3332,8 @@ xfs_btree_insrec(
 	 * If we have an external root pointer, and we've made it to the
 	 * root level, allocate a new root block and we're done.
 	 */
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level >= cur->bc_nlevels)) {
+	if (cur->bc_ops->type != XFS_BTREE_TYPE_INODE &&
+	    level >= cur->bc_nlevels) {
 		error = xfs_btree_new_root(cur, stat);
 		xfs_btree_set_ptr_null(cur, ptrp);
 
@@ -3614,7 +3620,7 @@ xfs_btree_kill_iroot(
 #endif
 	int			i;
 
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_nlevels > 1);
 
 	/*
@@ -3851,7 +3857,7 @@ xfs_btree_delrec(
 	 * nothing left to do.
 	 */
 	if (level == cur->bc_nlevels - 1) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			xfs_iroot_realloc(cur->bc_ino.ip, -1,
 					  cur->bc_ino.whichfork);
 
@@ -3919,7 +3925,7 @@ xfs_btree_delrec(
 	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
 	xfs_btree_get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 		/*
 		 * One child of root, need to get a chance to copy its contents
 		 * into the root and delete it. Can't go up to next level,
@@ -4236,8 +4242,8 @@ xfs_btree_delrec(
 	 * If we joined with the right neighbor and there's a level above
 	 * us, increment the cursor at that level.
 	 */
-	else if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) ||
-		   (level + 1 < cur->bc_nlevels)) {
+	else if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE ||
+		 level + 1 < cur->bc_nlevels) {
 		error = xfs_btree_increment(cur, level + 1, &i);
 		if (error)
 			goto error0;
@@ -4528,7 +4534,7 @@ xfs_btree_block_change_owner(
 	 * though, so everything is consistent in memory.
 	 */
 	if (!bp) {
-		ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+		ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 		ASSERT(level == cur->bc_nlevels - 1);
 		return 0;
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 09182981756fe..5230ca83cfa1a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -117,7 +117,15 @@ static inline enum xbtree_key_contig xbtree_key_contig(uint64_t x, uint64_t y)
 #define XFS_BTREE_LONG_PTR_LEN		(sizeof(__be64))
 #define XFS_BTREE_SHORT_PTR_LEN		(sizeof(__be32))
 
+enum xfs_btree_type {
+	XFS_BTREE_TYPE_AG,
+	XFS_BTREE_TYPE_INODE,
+};
+
 struct xfs_btree_ops {
+	/* Type of btree - AG-rooted or inode-rooted */
+	enum xfs_btree_type	type;
+
 	/* XFS_BTGEO_* flags that determine the geometry of the btree */
 	unsigned int		geom_flags;
 
@@ -216,9 +224,8 @@ struct xfs_btree_ops {
 };
 
 /* btree geometry flags */
-#define XFS_BTGEO_ROOT_IN_INODE		(1U << 0) /* root may be variable size */
-#define XFS_BTGEO_LASTREC_UPDATE	(1U << 1) /* track last rec externally */
-#define XFS_BTGEO_OVERLAPPING		(1U << 2) /* overlapping intervals */
+#define XFS_BTGEO_LASTREC_UPDATE	(1U << 0) /* track last rec externally */
+#define XFS_BTGEO_OVERLAPPING		(1U << 1) /* overlapping intervals */
 
 /*
  * Reasons for the update_lastrec method to be called.
@@ -292,7 +299,7 @@ struct xfs_btree_cur
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers
 	 * into physical addresses for IO, so the btree cursor switches between
-	 * bc_ino and bc_ag based on whether XFS_BTGEO_ROOT_IN_INODE is set for
+	 * bc_ino and bc_ag based on bc_ops->type.
 	 * the cursor.
 	 */
 	union {
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 9718be22e8414..602c65ede1b0d 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -136,7 +136,7 @@ xfs_btree_stage_afakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE));
+	ASSERT(cur->bc_ops->type != XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
@@ -217,7 +217,7 @@ xfs_btree_stage_ifakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmem_alloc(sizeof(struct xfs_btree_ops), KM_NOFS);
@@ -397,7 +397,7 @@ xfs_btree_bload_prep_block(
 	struct xfs_btree_block		*new_block;
 	int				ret;
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == cur->bc_nlevels - 1) {
 		struct xfs_ifork	*ifp = xfs_btree_ifork_ptr(cur);
 		size_t			new_size;
@@ -702,7 +702,7 @@ xfs_btree_bload_compute_geometry(
 		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
 				&avg_per_block, &level_blocks, &dontcare64);
 
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			/*
 			 * If all the items we want to store at this level
 			 * would fit in the inode root block, then we have our
@@ -761,7 +761,7 @@ xfs_btree_bload_compute_geometry(
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 		bbl->nr_blocks = nr_blocks - 1;
 	else
 		bbl->nr_blocks = nr_blocks;
@@ -888,7 +888,7 @@ xfs_btree_bload(
 	}
 
 	/* Initialize the new root. */
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 		ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 		cur->bc_ino.ifake->if_levels = cur->bc_nlevels;
 		cur->bc_ino.ifake->if_blocks = total_blocks - 1;
diff --git a/fs/xfs/libxfs/xfs_btree_staging.h b/fs/xfs/libxfs/xfs_btree_staging.h
index 9624ae06c83c4..8e29cd3cc0f17 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.h
+++ b/fs/xfs/libxfs/xfs_btree_staging.h
@@ -76,8 +76,7 @@ struct xfs_btree_bload {
 
 	/*
 	 * This function should return the size of the in-core btree root
-	 * block.  It is only necessary for XFS_BTGEO_ROOT_IN_INODE btree
-	 * types.
+	 * block.  It is only necessary for XFS_BTREE_TYPE_INODE btrees.
 	 */
 	xfs_btree_bload_iroot_size_fn	iroot_size;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 964d05f9c5cfd..fc584424ebdfe 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -399,6 +399,8 @@ xfs_inobt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_inobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
@@ -425,6 +427,8 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_finobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index fb05bc2adc251..52f3e4a30ecce 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -318,6 +318,8 @@ xfs_refcountbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 71df1d7d0e016..62efcfaa41730 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -473,6 +473,7 @@ xfs_rmapbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 3d3f82007ac61..71cfb2a454682 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -47,7 +47,7 @@ __xchk_btree_process_error(
 		*error = 0;
 		fallthrough;
 	default:
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			trace_xchk_ifork_btree_op_error(sc, cur, level,
 					*error, ret_ip);
 		else
@@ -91,7 +91,7 @@ __xchk_btree_set_corrupt(
 {
 	sc->sm->sm_flags |= errflag;
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 		trace_xchk_ifork_btree_error(sc, cur, level,
 				ret_ip);
 	else
@@ -239,7 +239,7 @@ xchk_btree_ptr_ok(
 	bool			res;
 
 	/* A btree rooted in an inode has no block pointer to the root. */
-	if ((bs->cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if (bs->cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == bs->cur->bc_nlevels)
 		return true;
 
@@ -390,7 +390,7 @@ xchk_btree_check_block_owner(
 	 * sc->sa so that we can check for the presence of an ownership record
 	 * in the rmap btree for the AG containing the block.
 	 */
-	init_sa = bs->cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE;
+	init_sa = bs->cur->bc_ops->type != XFS_BTREE_TYPE_AG;
 	if (init_sa) {
 		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
@@ -434,7 +434,7 @@ xchk_btree_check_owner(
 	 * up.
 	 */
 	if (bp == NULL) {
-		if (!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE))
+		if (cur->bc_ops->type != XFS_BTREE_TYPE_INODE)
 			xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 		return 0;
 	}
@@ -513,7 +513,7 @@ xchk_btree_check_minrecs(
 	 * child block might be less than the standard minrecs, but that's ok
 	 * provided that there's only one direct child of the root.
 	 */
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == cur->bc_nlevels - 2) {
 		struct xfs_btree_block	*root_block;
 		struct xfs_buf		*root_bp;
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index a7b0d95b8d5da..dc8a331f4b02d 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -37,7 +37,7 @@ xchk_btree_cur_fsbno(
 				xfs_buf_daddr(cur->bc_levels[level].bp));
 
 	if (level == cur->bc_nlevels - 1 &&
-	    (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE))
+	    cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
 
 	return NULLFSBLOCK;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c92eba282863a..f02247f8f185c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2510,7 +2510,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			__entry->agno = 0;
 			__entry->ino = cur->bc_ino.ip->i_ino;
 		} else {
@@ -2557,7 +2557,7 @@ TRACE_EVENT(xfs_btree_free_block,
 		__entry->dev = cur->bc_mp->m_super->s_dev;
 		__entry->agno = xfs_daddr_to_agno(cur->bc_mp,
 							xfs_buf_daddr(bp));
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			__entry->ino = cur->bc_ino.ip->i_ino;
 		else
 			__entry->ino = 0;

