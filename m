Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C047462
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994508; cv=none; b=bqcCFgWOytbyDm7lrphlFmd5ZWhm2oYOJsULK1/+HePDobtUJI28HXYn/r4WT/LJ4geCJmZQVSsdw6q45xa7583147kr6rK3i+9A4SY59qfG2yUj+62TRUnpIjNnwwuGpdOFPXlJQJGs4VFUoqxahN01FNeiUPm9EV0AE9k4SlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994508; c=relaxed/simple;
	bh=IX1v6P+yhVBBre45Tupl1mNIKWZhEafHgMu9cgq3+e8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mf5DxhoEDmq5zx547Spf6g2QAdrGaNiq6DkojRPcNOJRMSTOKggcUTDgM85JZNNwMeGK6p7Hgr0ryHXVN6rwUVmU7OGIRm4Gp0xpC3VDytVNAPrl/lSG5OBQ8pQ+yLULa6uQQBlzWMzJ2Gs/meFtQEB6LolCMcG7FbG5xpR4obo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q+JEgatB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q+JEgatB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B5EC4CED3;
	Mon, 23 Dec 2024 22:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994506;
	bh=IX1v6P+yhVBBre45Tupl1mNIKWZhEafHgMu9cgq3+e8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q+JEgatBQrmiV6YwdyjA7zW5e+MLcbFnludP2TUr4Eeenk+3azTaMPcE1shWCZlwL
	 4hh+t2uIuGgNkeDT8mIMEVDcEpEd/LHRC/SKuznDNvpw+2jL/sWjmh77fXY3+S6epG
	 cUfJxzYV9/W16k5JyvE47MmCnD3cUcxQJlMnRKJVshqk9o791ReiSbp8doJNIuZ1IX
	 r8fcD2sEjbNwkFvkj9pJ3eHr2UxseFel7488u+WCCzn5zWPC4frOuLqKm/pStKrqTN
	 9LxUF1bLPXUYr2ChR89Z08vDXVhH0OIM4YzcG6Z8CBBBypxqJ4s4xbjeFBmsmWsnEv
	 l1ygZeaE7pd/Q==
Date: Mon, 23 Dec 2024 14:55:05 -0800
Subject: [PATCH 4/8] xfs: make xfs_iroot_realloc a bmap btree function
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499417667.2379682.12902369681216385535.stgit@frogsfrogsfrogs>
In-Reply-To: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
References: <173499417579.2379682.13016361690239662927.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Move the inode fork btree root reallocation function part of the btree
ops because it's now mostly bmbt-specific code.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  104 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    3 +
 fs/xfs/libxfs/xfs_btree.c      |   11 ++--
 fs/xfs/libxfs/xfs_btree.h      |   16 ++++++
 fs/xfs/libxfs/xfs_inode_fork.c |   96 -------------------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |    2 -
 7 files changed, 130 insertions(+), 108 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8ab38f07cb78dd..0842577755f7bb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -615,7 +615,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, whichfork, 0);
+	xfs_bmap_broot_realloc(ip, whichfork, 0);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -659,7 +659,7 @@ xfs_bmap_extents_to_btree(
 	 * Make space in the inode incore. This needs to be undone if we fail
 	 * to expand the root.
 	 */
-	block = xfs_iroot_realloc(ip, whichfork, 1);
+	block = xfs_bmap_broot_realloc(ip, whichfork, 1);
 
 	/*
 	 * Fill in the root.
@@ -745,7 +745,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, whichfork, 0);
+	xfs_bmap_broot_realloc(ip, whichfork, 0);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3464be771f95d8..22cf2059d54dd4 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,109 @@ xfs_bmbt_keys_contiguous(
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
 
+/*
+ * Reallocate the space for if_broot based on the number of records.  Move the
+ * records and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by the caller.
+ * When growing this will create holes to be filled in by the caller.
+ *
+ * The caller must not request to add more records than would fit in the
+ * on-disk inode root.  If the if_broot is currently NULL, then if we are
+ * adding records, one will be allocated.  The caller must also not request
+ * that the number of records go below zero, although it can go to zero.
+ *
+ * ip -- the inode whose if_broot area is changing
+ * whichfork -- which inode fork to change
+ * new_numrecs -- the new number of records requested for the if_broot array
+ *
+ * Returns the incore btree root block.
+ */
+struct xfs_btree_block *
+xfs_bmap_broot_realloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	unsigned int		new_numrecs)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+	char			*np;
+	char			*op;
+	unsigned int		new_size;
+	unsigned int		old_size = ifp->if_broot_bytes;
+
+	/*
+	 * Block mapping btrees do not support storing zero records; if this
+	 * happens, the fork is being changed to FMT_EXTENTS.  Free the broot
+	 * and get out.
+	 */
+	if (new_numrecs == 0)
+		return xfs_broot_realloc(ifp, 0);
+
+	new_size = xfs_bmap_broot_space_calc(mp, new_numrecs);
+
+	/* Handle the nop case quietly. */
+	if (new_size == old_size)
+		return ifp->if_broot;
+
+	if (new_size > old_size) {
+		unsigned int	old_numrecs;
+
+		/*
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
+		 */
+		if (old_size == 0)
+			return xfs_broot_realloc(ifp, new_size);
+
+		/*
+		 * If there is already an existing if_broot, then we need
+		 * to realloc() it and shift the pointers to their new
+		 * location.  The records don't change location because
+		 * they are kept butted up against the btree block header.
+		 */
+		old_numrecs = xfs_bmbt_maxrecs(mp, old_size, false);
+		xfs_broot_realloc(ifp, new_size);
+		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
+						     old_size);
+		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
+						     (int)new_size);
+		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+			xfs_inode_fork_size(ip, whichfork));
+		memmove(np, op, old_numrecs * (uint)sizeof(xfs_fsblock_t));
+		return ifp->if_broot;
+	}
+
+	/*
+	 * We're reducing, but not totally eliminating, numrecs.  In this case,
+	 * we are shrinking the if_broot buffer, so it must already exist.
+	 */
+	ASSERT(ifp->if_broot != NULL && old_size > 0 && new_size > 0);
+
+	/*
+	 * Shrink the btree root by moving the bmbt pointers, since they are
+	 * not butted up against the btree block header, then reallocating
+	 * broot.
+	 */
+	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
+	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
+					     (int)new_size);
+	memmove(np, op, new_numrecs * (uint)sizeof(xfs_fsblock_t));
+
+	xfs_broot_realloc(ifp, new_size);
+	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
+	       xfs_inode_fork_size(ip, whichfork));
+	return ifp->if_broot;
+}
+
+static struct xfs_btree_block *
+xfs_bmbt_broot_realloc(
+	struct xfs_btree_cur	*cur,
+	unsigned int		new_numrecs)
+{
+	return xfs_bmap_broot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			new_numrecs);
+}
+
 const struct xfs_btree_ops xfs_bmbt_ops = {
 	.name			= "bmap",
 	.type			= XFS_BTREE_TYPE_INODE,
@@ -543,6 +646,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 	.keys_contiguous	= xfs_bmbt_keys_contiguous,
+	.broot_realloc		= xfs_bmbt_broot_realloc,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 49a3bae3f6ecec..b238d559ab0369 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -198,4 +198,7 @@ xfs_bmap_bmdr_space(struct xfs_btree_block *bb)
 	return xfs_bmdr_space_calc(be16_to_cpu(bb->bb_numrecs));
 }
 
+struct xfs_btree_block *xfs_bmap_broot_realloc(struct xfs_inode *ip,
+		int whichfork, unsigned int new_numrecs);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5714bec26c2084..672746f7217cff 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3161,7 +3161,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork, 1);
+	cur->bc_ops->broot_realloc(cur, 1);
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3345,8 +3345,7 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, cur->bc_ino.whichfork,
-					numrecs + 1);
+			cur->bc_ops->broot_realloc(cur, numrecs + 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3758,8 +3757,7 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	block = xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
-			numrecs);
+	block = cur->bc_ops->broot_realloc(cur, numrecs);
 
 	block->bb_numrecs = be16_to_cpu(numrecs);
 	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
@@ -3944,8 +3942,7 @@ xfs_btree_delrec(
 	 * nothing left to do.  numrecs was decremented above.
 	 */
 	if (xfs_btree_at_iroot(cur, level)) {
-		xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
-				numrecs);
+		cur->bc_ops->broot_realloc(cur, numrecs);
 
 		error = xfs_btree_kill_iroot(cur);
 		if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index c5bff273cae255..8380ae0a64dd5e 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -213,6 +213,22 @@ struct xfs_btree_ops {
 			       const union xfs_btree_key *key1,
 			       const union xfs_btree_key *key2,
 			       const union xfs_btree_key *mask);
+
+	/*
+	 * Reallocate the space for if_broot to fit the number of records.
+	 * Move the records and pointers in if_broot to fit the new size.  When
+	 * shrinking this will eliminate holes between the records and pointers
+	 * created by the caller.  When growing this will create holes to be
+	 * filled in by the caller.
+	 *
+	 * The caller must not request to add more records than would fit in
+	 * the on-disk inode root.  If the if_broot is currently NULL, then if
+	 * we are adding records, one will be allocated.  The caller must also
+	 * not request that the number of records go below zero, although it
+	 * can go to zero.
+	 */
+	struct xfs_btree_block *(*broot_realloc)(struct xfs_btree_cur *cur,
+				unsigned int new_numrecs);
 };
 
 /* btree geometry flags */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 53bfdf422ad820..60853bac289a39 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -422,102 +422,6 @@ xfs_broot_realloc(
 	return ifp->if_broot;
 }
 
-/*
- * Reallocate the space for if_broot based on the number of records.  Move the
- * records and pointers in if_broot to fit the new size.  When shrinking this
- * will eliminate holes between the records and pointers created by the caller.
- * When growing this will create holes to be filled in by the caller.
- *
- * The caller must not request to add more records than would fit in
- * the on-disk inode root.  If the if_broot is currently NULL, then
- * if we are adding records, one will be allocated.  The caller must also
- * not request that the number of records go below zero, although
- * it can go to zero.
- *
- * ip -- the inode whose if_broot area is changing
- * whichfork -- which inode fork to change
- * new_numrecs -- the new number of records requested for the if_broot array
- *
- * Returns the incore btree root block.
- */
-struct xfs_btree_block *
-xfs_iroot_realloc(
-	struct xfs_inode	*ip,
-	int			whichfork,
-	unsigned int		new_numrecs)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	char			*np;
-	char			*op;
-	unsigned int		new_size;
-	unsigned int		old_size = ifp->if_broot_bytes;
-
-	/*
-	 * Block mapping btrees do not support storing zero records; if this
-	 * happens, the fork is being changed to FMT_EXTENTS.  Free the broot
-	 * and get out.
-	 */
-	if (new_numrecs == 0)
-		return xfs_broot_realloc(ifp, 0);
-
-	new_size = xfs_bmap_broot_space_calc(mp, new_numrecs);
-
-	/* Handle the nop case quietly. */
-	if (new_size == old_size)
-		return ifp->if_broot;
-
-	if (new_size > old_size) {
-		unsigned int	old_numrecs;
-
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (old_size == 0)
-			return xfs_broot_realloc(ifp, new_size);
-
-		/*
-		 * If there is already an existing if_broot, then we need
-		 * to realloc() it and shift the pointers to their new
-		 * location.  The records don't change location because
-		 * they are kept butted up against the btree block header.
-		 */
-		old_numrecs = xfs_bmbt_maxrecs(mp, old_size, false);
-		xfs_broot_realloc(ifp, new_size);
-		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     old_size);
-		np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, old_numrecs * (uint)sizeof(xfs_fsblock_t));
-		return ifp->if_broot;
-	}
-
-	/*
-	 * We're reducing, but not totally eliminating, numrecs.  In this case,
-	 * we are shrinking the if_broot buffer, so it must already exist.
-	 */
-	ASSERT(ifp->if_broot != NULL && old_size > 0 && new_size > 0);
-
-	/*
-	 * Shrink the btree root by moving the bmbt pointers, since they are
-	 * not butted up against the btree block header, then reallocating
-	 * broot.
-	 */
-	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
-	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
-					     (int)new_size);
-	memmove(np, op, new_numrecs * (uint)sizeof(xfs_fsblock_t));
-
-	xfs_broot_realloc(ifp, new_size);
-	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
-	       xfs_inode_fork_size(ip, whichfork));
-	return ifp->if_broot;
-}
-
-
 /*
  * This is called when the amount of space needed for if_data
  * is increased or decreased.  The change in size is indicated by
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index d05eb0bad864e1..69ed0919d60b12 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -175,8 +175,6 @@ struct xfs_btree_block *xfs_broot_alloc(struct xfs_ifork *ifp,
 struct xfs_btree_block *xfs_broot_realloc(struct xfs_ifork *ifp,
 				size_t new_size);
 
-struct xfs_btree_block *xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
-				unsigned int new_numrecs);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);

