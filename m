Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFEDCA48
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fbKxjvrz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7808C433C7;
	Mon,  1 Jan 2024 00:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067408;
	bh=IWWSvEepVd7rrGRtVO2MDHib1J53KBYI76gw0pDGUXg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fbKxjvrzfG2kZSvb1RapMM18ZAtlG08+4y7GAYg1igLd2UQ+Pcknbg6CjO1X5wteV
	 rlua4TEE7tT+dEbWvSNTNbXZI+p2ja8E2S1LwQ5CoUWi4LX6ryC8Pc55n2Uc2g8uXn
	 ziBtMHBM1hIDuE7o0itfuL5GJT9qQMvIT277aZcQ6s95PuvmDc1nxiwxX/vVr4WdZG
	 /VkqPKWLtHZK/5zuKUcntTrjffixj9b20ms7f6e0cAS8jSTePM8WuecllOgdQO+fVS
	 v696s8Jrng0rtEB0NKCtYrnB1iG+lNOeIKZA6JIA/uf7YQnfpH/XZmrzhqYxmJpCB9
	 QoUYSa+K/Y5Tg==
Date: Sun, 31 Dec 2023 16:03:28 +9900
Subject: [PATCH 09/14] xfs: generalize the btree root reallocation function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013322.1812545.8613646119898261500.stgit@frogsfrogsfrogs>
In-Reply-To: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
References: <170405013189.1812545.1581948480545654103.stgit@frogsfrogsfrogs>
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

In preparation for storing realtime rmap btree roots in an inode fork,
make xfs_iroot_realloc take an ops structure that takes care of all the
btree-specific geometry pieces.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap_btree.c |   51 +++++++++++++++++++++++++++++
 libxfs/xfs_btree.c      |   22 ++++++++-----
 libxfs/xfs_btree.h      |    3 ++
 libxfs/xfs_inode_fork.c |   82 ++++++++++-------------------------------------
 libxfs/xfs_inode_fork.h |   23 +++++++++++++
 5 files changed, 107 insertions(+), 74 deletions(-)


diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 1e7b89e7730..4156e23a2da 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -511,6 +511,56 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
+/* Move the bmap btree root from one incore buffer to another. */
+static void
+xfs_bmbt_broot_move(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	struct xfs_btree_block	*dst_broot,
+	size_t			dst_bytes,
+	struct xfs_btree_block	*src_broot,
+	size_t			src_bytes,
+	unsigned int		numrecs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	void			*dptr;
+	void			*sptr;
+
+	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
+
+	/*
+	 * We always have to move the pointers because they are not butted
+	 * against the btree block header.
+	 */
+	if (numrecs) {
+		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
+		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
+		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
+	}
+
+	if (src_broot == dst_broot)
+		return;
+
+	/*
+	 * If the root is being totally relocated, we have to migrate the block
+	 * header and the keys that come after it.
+	 */
+	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
+
+	/* Now copy the keys, which come right after the header. */
+	if (numrecs) {
+		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
+		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
+		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
+	}
+}
+
+static const struct xfs_ifork_broot_ops xfs_bmbt_iroot_ops = {
+	.maxrecs		= xfs_bmbt_maxrecs,
+	.size			= xfs_bmap_broot_space_calc,
+	.move			= xfs_bmbt_broot_move,
+};
+
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
@@ -534,6 +584,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 	.keys_contiguous	= xfs_bmbt_keys_contiguous,
+	.iroot_ops		= &xfs_bmbt_iroot_ops,
 };
 
 static struct xfs_btree_cur *
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 7cc6379a113..b6f73fcc6d6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3068,6 +3068,16 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
+static inline void
+xfs_btree_iroot_realloc(
+	struct xfs_btree_cur		*cur,
+	int				rec_diff)
+{
+	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
+
+	xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			cur->bc_ops->iroot_ops, rec_diff);
+}
 
 /*
  * Copy the old inode root contents into a real block and make the
@@ -3152,9 +3162,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_ino.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_ino.whichfork);
+	xfs_btree_iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3324,7 +3332,7 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
+			xfs_btree_iroot_realloc(cur, 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3732,8 +3740,7 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_ino.ip, index,
-				  cur->bc_ino.whichfork);
+		xfs_btree_iroot_realloc(cur, index);
 		block = ifp->if_broot;
 	}
 
@@ -3930,8 +3937,7 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_ino.ip, -1,
-					  cur->bc_ino.whichfork);
+			xfs_btree_iroot_realloc(cur, -1);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 339b5561e5b..7872fc1739b 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -205,6 +205,9 @@ struct xfs_btree_ops {
 			       const union xfs_btree_key *key1,
 			       const union xfs_btree_key *key2,
 			       const union xfs_btree_key *mask);
+
+	/* Functions for manipulating the btree root block. */
+	const struct xfs_ifork_broot_ops *iroot_ops;
 };
 
 /*
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index bb66028bff0..50422bbeb8f 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -381,50 +381,6 @@ xfs_iroot_free(
 	ifp->if_broot = NULL;
 }
 
-/* Move the bmap btree root from one incore buffer to another. */
-static void
-xfs_ifork_move_broot(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	struct xfs_btree_block	*dst_broot,
-	size_t			dst_bytes,
-	struct xfs_btree_block	*src_broot,
-	size_t			src_bytes,
-	unsigned int		numrecs)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	void			*dptr;
-	void			*sptr;
-
-	ASSERT(xfs_bmap_bmdr_space(src_broot) <= xfs_inode_fork_size(ip, whichfork));
-
-	/*
-	 * We always have to move the pointers because they are not butted
-	 * against the btree block header.
-	 */
-	if (numrecs) {
-		sptr = xfs_bmap_broot_ptr_addr(mp, src_broot, 1, src_bytes);
-		dptr = xfs_bmap_broot_ptr_addr(mp, dst_broot, 1, dst_bytes);
-		memmove(dptr, sptr, numrecs * sizeof(xfs_fsblock_t));
-	}
-
-	if (src_broot == dst_broot)
-		return;
-
-	/*
-	 * If the root is being totally relocated, we have to migrate the block
-	 * header and the keys that come after it.
-	 */
-	memcpy(dst_broot, src_broot, xfs_bmbt_block_len(mp));
-
-	/* Now copy the keys, which come right after the header. */
-	if (numrecs) {
-		sptr = xfs_bmbt_key_addr(mp, src_broot, 1);
-		dptr = xfs_bmbt_key_addr(mp, dst_broot, 1);
-		memcpy(dptr, sptr, numrecs * sizeof(struct xfs_bmbt_key));
-	}
-}
-
 /*
  * Reallocate the space for if_broot based on the number of records
  * being added or deleted as indicated in rec_diff.  Move the records
@@ -438,24 +394,21 @@ xfs_ifork_move_broot(
  * if we are adding records, one will be allocated.  The caller must also
  * not request that the number of records go below zero, although
  * it can go to zero.
- *
- * ip -- the inode whose if_broot area is changing
- * ext_diff -- the change in the number of records, positive or negative,
- *	 requested for the if_broot array.
  */
 void
 xfs_iroot_realloc(
-	struct xfs_inode	*ip,
-	int			rec_diff,
-	int			whichfork)
+	struct xfs_inode		*ip,
+	int				whichfork,
+	const struct xfs_ifork_broot_ops *ops,
+	int				rec_diff)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	struct xfs_btree_block	*new_broot;
-	size_t			new_size;
-	size_t			old_size = ifp->if_broot_bytes;
-	int			cur_max;
-	int			new_max;
+	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp = xfs_ifork_ptr(ip, whichfork);
+	struct xfs_btree_block		*new_broot;
+	size_t				new_size;
+	size_t				old_size = ifp->if_broot_bytes;
+	int				cur_max;
+	int				new_max;
 
 	/* Handle degenerate cases. */
 	if (rec_diff == 0)
@@ -468,16 +421,16 @@ xfs_iroot_realloc(
 	if (old_size == 0) {
 		ASSERT(rec_diff > 0);
 
-		new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
+		new_size = ops->size(mp, rec_diff);
 		xfs_iroot_alloc(ip, whichfork, new_size);
 		return;
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
+	cur_max = ops->maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
-	new_size = xfs_bmap_broot_space_calc(mp, new_max);
+	new_size = ops->size(mp, new_max);
 
 	if (rec_diff > 0) {
 		/*
@@ -488,7 +441,7 @@ xfs_iroot_realloc(
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
 					 GFP_NOFS | __GFP_NOFAIL);
 		ifp->if_broot_bytes = new_size;
-		xfs_ifork_move_broot(ip, whichfork, ifp->if_broot, new_size,
+		ops->move(ip, whichfork, ifp->if_broot, new_size,
 				ifp->if_broot, old_size, cur_max);
 		return;
 	}
@@ -505,15 +458,14 @@ xfs_iroot_realloc(
 
 	/* Reallocate the btree root and move the contents. */
 	new_broot = kmem_alloc(new_size, KM_NOFS);
-	xfs_ifork_move_broot(ip, whichfork, new_broot, new_size, ifp->if_broot,
-			old_size, new_max);
+	ops->move(ip, whichfork, new_broot, new_size, ifp->if_broot,
+			ifp->if_broot_bytes, new_max);
 
 	kmem_free(ifp->if_broot);
 	ifp->if_broot = new_broot;
 	ifp->if_broot_bytes = new_size;
 }
 
-
 /*
  * This is called when the amount of space needed for if_data
  * is increased or decreased.  The change in size is indicated by
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index 18ea2d27777..1ac9a7a8b5f 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -175,7 +175,6 @@ void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 void		xfs_iroot_alloc(struct xfs_inode *ip, int whichfork,
 				size_t bytes);
 void		xfs_iroot_free(struct xfs_inode *ip, int whichfork);
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
@@ -274,4 +273,26 @@ static inline bool xfs_need_iread_extents(const struct xfs_ifork *ifp)
 	return smp_load_acquire(&ifp->if_needextents) != 0;
 }
 
+struct xfs_ifork_broot_ops {
+	/* Calculate the number of records/keys in the incore btree block. */
+	unsigned int (*maxrecs)(struct xfs_mount *mp, unsigned int blocksize,
+			bool leaf);
+
+	/* Calculate the bytes required for the incore btree root block. */
+	size_t (*size)(struct xfs_mount *mp, unsigned int nrecs);
+
+	/*
+	 * Move an incore btree root from one buffer to another.  Note that
+	 * src_broot and dst_broot could be the same or they could be totally
+	 * separate memory regions.
+	 */
+	void (*move)(struct xfs_inode *ip, int whichfork,
+			struct xfs_btree_block *dst_broot, size_t dst_bytes,
+			struct xfs_btree_block *src_broot, size_t src_bytes,
+			unsigned int numrecs);
+};
+
+void xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
+		const struct xfs_ifork_broot_ops *ops, int rec_diff);
+
 #endif	/* __XFS_INODE_FORK_H__ */

