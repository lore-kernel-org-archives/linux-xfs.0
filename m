Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741821D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424441; cv=none; b=biX0LwIkkugQ/OPpUoF5i0/+IILl8/jBhXoyJ+Mv6XB8hPN6KfWA9WU0rm3KKufoIBnksC8byh9BJOI6FfhJNs1SLPOQn9fKokZmXhauOG78XN2wbU8yQvfLd2NsPX+pmVlqVJy8W8ypaunOStGSVK3ETAkLSnzoPaip1RP4E1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424441; c=relaxed/simple;
	bh=766n7tQxJQjnPPM76AMscMF/C6ZRvuhplVrsneNcJHo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1206K0C4Kin75VJPxy7kjRScenQelFP30C5s7IjAuE1W3aEeZsd8pMUAEGhvTogLNrqPd/nxkGNXZBaP98UBHPaEwrKQBH++tswHRn8A0SNDxeEdvsLj3Y83FUO2yVIhqIEIWic+dvWEKikLSo86fDjeFCAAKabgpWshlcZo1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mg+NNhLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mg+NNhLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C3BC433C7;
	Tue, 26 Mar 2024 03:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424441;
	bh=766n7tQxJQjnPPM76AMscMF/C6ZRvuhplVrsneNcJHo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Mg+NNhLixtJ5sd9gIyJM6RmRapfzLqot224HgvSm8wnTYVlCAoxWaIgsrrgYTFwPF
	 UAsrbzg6vaL/psY+U5IpFYY3YxQTYE6CR+0fhOXa6H8XFviJyrvnpgXzOZlHPMrFY1
	 XyLD8D6MI/k9g63jJh4Xzl1u4zTwzXb46hp370q/j+ld0KOZbElgMCpWIRKb41AvM9
	 qp9xv0Utqymjs+UN/2vuSLyC1jVipFZmyxE0j3pjEoGKLchl1WtyqsvSegUnWjn3OW
	 XuqoSzl1ZaiIRCaJYrE3jgDS9ZBXmv8QbA0yOt4FUwZDMPwWV+jV2WH7GWi8hqZ2v0
	 qIDHKMR8diihA==
Date: Mon, 25 Mar 2024 20:40:40 -0700
Subject: [PATCH 047/110] xfs: split out a btree type from the btree ops
 geometry flags
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142132061.2215168.6979887718198922782.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 4f0cd5a555072e21fb589975607b70798e073f8f

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
 libxfs/xfs_alloc_btree.c    |    3 ++
 libxfs/xfs_bmap_btree.c     |    2 +
 libxfs/xfs_btree.c          |   66 +++++++++++++++++++++++--------------------
 libxfs/xfs_btree.h          |   15 +++++++---
 libxfs/xfs_btree_staging.c  |   12 ++++----
 libxfs/xfs_btree_staging.h  |    3 +-
 libxfs/xfs_ialloc_btree.c   |    4 +++
 libxfs/xfs_refcount_btree.c |    2 +
 libxfs/xfs_rmap_btree.c     |    1 +
 9 files changed, 65 insertions(+), 43 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index e1637580cdd1..b18ac70451eb 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -453,6 +453,8 @@ xfs_allocbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bnobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
@@ -480,6 +482,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_cntbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_LASTREC_UPDATE,
 
 	.rec_len		= sizeof(xfs_alloc_rec_t),
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index d2399ea42dbb..54020dea2e59 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -524,7 +524,7 @@ xfs_bmbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_bmbt_ops = {
-	.geom_flags		= XFS_BTGEO_ROOT_IN_INODE,
+	.type			= XFS_BTREE_TYPE_INODE,
 
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2bce8ebbd77d..f8c348e49286 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -444,10 +444,19 @@ xfs_btree_del_cursor(
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
 		kfree(cur->bc_ops);
-	if (!(cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) && cur->bc_ag.pag)
-		xfs_perag_put(cur->bc_ag.pag);
 	kmem_cache_free(cur->bc_cache, cur);
 }
 
@@ -705,7 +714,7 @@ struct xfs_ifork *
 xfs_btree_ifork_ptr(
 	struct xfs_btree_cur	*cur)
 {
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 
 	if (cur->bc_flags & XFS_BTREE_STAGING)
 		return cur->bc_ino.ifake->if_fork;
@@ -737,8 +746,8 @@ xfs_btree_get_block(
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
@@ -980,8 +989,8 @@ xfs_btree_readahead(
 	 * No readahead needed if we are at the root level and the
 	 * btree root is stored in the inode.
 	 */
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (lev == cur->bc_nlevels - 1))
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    lev == cur->bc_nlevels - 1)
 		return 0;
 
 	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
@@ -1169,14 +1178,12 @@ __xfs_btree_init_block(
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
@@ -1214,7 +1221,7 @@ static inline __u64
 xfs_btree_owner(
 	struct xfs_btree_cur    *cur)
 {
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 		return cur->bc_ino.ip->i_ino;
 	return cur->bc_ag.pag->pag_agno;
 }
@@ -1635,7 +1642,7 @@ xfs_btree_increment(
 	 * confused or have the tree root in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1729,7 +1736,7 @@ xfs_btree_decrement(
 	 * or the root of the tree is in an inode.
 	 */
 	if (lev == cur->bc_nlevels) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE)
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
 			goto out0;
 		ASSERT(0);
 		xfs_btree_mark_sick(cur);
@@ -1804,8 +1811,8 @@ xfs_btree_lookup_get_block(
 	int			error = 0;
 
 	/* special case the root block if in an inode */
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level == cur->bc_nlevels - 1)) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    level == cur->bc_nlevels - 1) {
 		*blkp = xfs_btree_get_iroot(cur);
 		return 0;
 	}
@@ -2340,7 +2347,7 @@ xfs_btree_lshift(
 	int			error;		/* error return value */
 	int			i;
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if ((cur->bc_ops->type == XFS_BTREE_TYPE_INODE) &&
 	    level == cur->bc_nlevels - 1)
 		goto out0;
 
@@ -2536,8 +2543,8 @@ xfs_btree_rshift(
 	int			error;		/* error return value */
 	int			i;		/* loop counter */
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level == cur->bc_nlevels - 1))
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
+	    level == cur->bc_nlevels - 1)
 		goto out0;
 
 	/* Set up variables for this block as "left". */
@@ -2987,7 +2994,6 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
-
 /*
  * Copy the old inode root contents into a real block and make the
  * broot point to it.
@@ -3012,7 +3018,7 @@ xfs_btree_new_iroot(
 
 	XFS_BTREE_STATS_INC(cur, newroot);
 
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 
 	level = cur->bc_nlevels - 1;
 
@@ -3237,7 +3243,7 @@ xfs_btree_make_block_unfull(
 {
 	int			error = 0;
 
-	if ((cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE &&
 	    level == cur->bc_nlevels - 1) {
 		struct xfs_inode *ip = cur->bc_ino.ip;
 
@@ -3323,8 +3329,8 @@ xfs_btree_insrec(
 	 * If we have an external root pointer, and we've made it to the
 	 * root level, allocate a new root block and we're done.
 	 */
-	if (!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) &&
-	    (level >= cur->bc_nlevels)) {
+	if (cur->bc_ops->type != XFS_BTREE_TYPE_INODE &&
+	    level >= cur->bc_nlevels) {
 		error = xfs_btree_new_root(cur, stat);
 		xfs_btree_set_ptr_null(cur, ptrp);
 
@@ -3611,7 +3617,7 @@ xfs_btree_kill_iroot(
 #endif
 	int			i;
 
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_nlevels > 1);
 
 	/*
@@ -3848,7 +3854,7 @@ xfs_btree_delrec(
 	 * nothing left to do.
 	 */
 	if (level == cur->bc_nlevels - 1) {
-		if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 			xfs_iroot_realloc(cur->bc_ino.ip, -1,
 					  cur->bc_ino.whichfork);
 
@@ -3916,7 +3922,7 @@ xfs_btree_delrec(
 	xfs_btree_get_sibling(cur, block, &rptr, XFS_BB_RIGHTSIB);
 	xfs_btree_get_sibling(cur, block, &lptr, XFS_BB_LEFTSIB);
 
-	if (cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE) {
+	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
 		/*
 		 * One child of root, need to get a chance to copy its contents
 		 * into the root and delete it. Can't go up to next level,
@@ -4233,8 +4239,8 @@ xfs_btree_delrec(
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
@@ -4525,7 +4531,7 @@ xfs_btree_block_change_owner(
 	 * though, so everything is consistent in memory.
 	 */
 	if (!bp) {
-		ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+		ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 		ASSERT(level == cur->bc_nlevels - 1);
 		return 0;
 	}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 559066e3ac12..5f2b5ef858ee 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index 39e95a771c3b..e1fd57dee814 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -136,7 +136,7 @@ xfs_btree_stage_afakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(!(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE));
+	ASSERT(cur->bc_ops->type != XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
@@ -217,7 +217,7 @@ xfs_btree_stage_ifakeroot(
 	struct xfs_btree_ops		*nops;
 
 	ASSERT(!(cur->bc_flags & XFS_BTREE_STAGING));
-	ASSERT(cur->bc_ops->geom_flags & XFS_BTGEO_ROOT_IN_INODE);
+	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
 	ASSERT(cur->bc_tp == NULL);
 
 	nops = kmalloc(sizeof(struct xfs_btree_ops), GFP_KERNEL | __GFP_NOFAIL);
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
diff --git a/libxfs/xfs_btree_staging.h b/libxfs/xfs_btree_staging.h
index 9624ae06c83c..8e29cd3cc0f1 100644
--- a/libxfs/xfs_btree_staging.h
+++ b/libxfs/xfs_btree_staging.h
@@ -76,8 +76,7 @@ struct xfs_btree_bload {
 
 	/*
 	 * This function should return the size of the in-core btree root
-	 * block.  It is only necessary for XFS_BTGEO_ROOT_IN_INODE btree
-	 * types.
+	 * block.  It is only necessary for XFS_BTREE_TYPE_INODE btrees.
 	 */
 	xfs_btree_bload_iroot_size_fn	iroot_size;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index a9b2a48a3c6a..79ab04684f37 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -398,6 +398,8 @@ xfs_inobt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_inobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
@@ -424,6 +426,8 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 };
 
 const struct xfs_btree_ops xfs_finobt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 4918c8baebe3..3d61eeaca09b 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -317,6 +317,8 @@ xfs_refcountbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
+
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
 	.ptr_len		= XFS_BTREE_SHORT_PTR_LEN,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index b1d25d99dbbf..f87e34a1dee8 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -471,6 +471,7 @@ xfs_rmapbt_keys_contiguous(
 }
 
 const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.type			= XFS_BTREE_TYPE_AG,
 	.geom_flags		= XFS_BTGEO_OVERLAPPING,
 
 	.rec_len		= sizeof(struct xfs_rmap_rec),

