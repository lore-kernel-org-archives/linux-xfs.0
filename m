Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F9023C380
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738881354; cv=none; b=XpJ3KIMFbVcmKYsCIKYfj0KCqm7fj+I5pHmcSGncMHGyz1sA8TjzkqME+R/J0DiMyF/Fz80pCRd4uqVx/fXD+YTVXjjMzAjCLoxufpLb0QB6wP+NXO870nCEljtloCkPfeHU9sMTzQVD8v6x5gVraRBVIgspXe1J20EM+KyYVsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738881354; c=relaxed/simple;
	bh=K+cASQReczDikz6IPEoGgmbE239JSvB92lhyz3FoInY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=erGFRToJSXLnH5gv84yjPaw4pewc8KQ1IzTyNnJ11+fsK7FiPAb4DHosqZA5A56znIuPRIKaCLKhnC7Xl5kx5k5RFqKLLhO/0zY9tP2KjL/cdh7rvIg1VVOXp73R8gcI/xHa08iGvTVl7I4bdXj0+PYKzqkgg89oY0omB6mmWEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PHBKL57m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHBKL57m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFEDC4CEDD;
	Thu,  6 Feb 2025 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738881354;
	bh=K+cASQReczDikz6IPEoGgmbE239JSvB92lhyz3FoInY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PHBKL57mh4yQgmWDqqzOYQQso+hOtWmS6GxGmvD5Z945f2QLInsWB1hq7hs040yo9
	 SKgA2Zf0YZOjLxbsTb59gasMFDq9AYzFl9jOzyqVWwfZXt5YSuwNHB7w8xLGAzy/B/
	 fmYLWtMvf1OONXbphCKBePgKYv/CBDMIIb1eDvnOqes1hVh8rjvULhtZWh3JxmhL8x
	 ePJt+nsySlBIvkuXE0exQ8EYJzhY7Sj9wSkFfyqK54MIvBOsipnUafGFHfeGxim6Dj
	 hRD5Tuhn8eZwtrpUQTb6iRfNjy+i/IysIZb1e0iUfmkp4zB4A3B1aOWoFJetMETEaY
	 8q3T0K67XT9Bg==
Date: Thu, 06 Feb 2025 14:35:53 -0800
Subject: [PATCH 03/56] xfs: make xfs_iroot_realloc take the new numrecs
 instead of deltas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888086836.2739176.13542010587269164390.stgit@frogsfrogsfrogs>
In-Reply-To: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
References: <173888086703.2739176.18069262351115926535.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 6a92924275ecdd768c8105f8975b971300c5ba7d

Change the calling signature of xfs_iroot_realloc to take the ifork and
the new number of records in the btree block, not a diff against the
current number.  This will make the callsites easier to understand.

Note that this function is misnamed because it is very specific to the
single type of inode-rooted btree supported.  This will be addressed in
a subsequent patch.

Return the new btree root to reduce the amount of code clutter.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_bmap.c       |    7 ++--
 libxfs/xfs_btree.c      |   25 +++++---------
 libxfs/xfs_inode_fork.c |   83 +++++++++++++++++++++--------------------------
 libxfs/xfs_inode_fork.h |    3 +-
 4 files changed, 51 insertions(+), 67 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 16ee7403a75f3b..2482f56dbb6ad6 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -609,7 +609,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_realloc(ip, whichfork, 0);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -653,12 +653,11 @@ xfs_bmap_extents_to_btree(
 	 * Make space in the inode incore. This needs to be undone if we fail
 	 * to expand the root.
 	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
+	block = xfs_iroot_realloc(ip, whichfork, 1);
 
 	/*
 	 * Fill in the root.
 	 */
-	block = ifp->if_broot;
 	xfs_bmbt_init_block(ip, block, NULL, 1, 1);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
@@ -740,7 +739,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_realloc(ip, whichfork, 0);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index f4c4db62e2069e..85f4f7b3e9813d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -3159,9 +3159,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_ino.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_ino.whichfork);
+	xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork, 1);
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3345,7 +3343,8 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
+			xfs_iroot_realloc(ip, cur->bc_ino.whichfork,
+					numrecs + 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3703,9 +3702,7 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_ino.whichfork;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
 	union xfs_btree_key	*kp;
@@ -3714,7 +3711,6 @@ xfs_btree_kill_iroot(
 	union xfs_btree_ptr	*cpp;
 	struct xfs_buf		*cbp;
 	int			level;
-	int			index;
 	int			numrecs;
 	int			error;
 #ifdef DEBUG
@@ -3760,14 +3756,10 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
-	if (index) {
-		xfs_iroot_realloc(cur->bc_ino.ip, index,
-				  cur->bc_ino.whichfork);
-		block = ifp->if_broot;
-	}
+	block = xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
+			numrecs);
 
-	be16_add_cpu(&block->bb_numrecs, index);
+	block->bb_numrecs = be16_to_cpu(numrecs);
 	ASSERT(block->bb_numrecs == cblock->bb_numrecs);
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3947,10 +3939,11 @@ xfs_btree_delrec(
 	/*
 	 * We're at the root level.  First, shrink the root block in-memory.
 	 * Try to get rid of the next level down.  If we can't then there's
-	 * nothing left to do.
+	 * nothing left to do.  numrecs was decremented above.
 	 */
 	if (xfs_btree_at_iroot(cur, level)) {
-		xfs_iroot_realloc(cur->bc_ino.ip, -1, cur->bc_ino.whichfork);
+		xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork,
+				numrecs);
 
 		error = xfs_btree_kill_iroot(cur);
 		if (error)
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index 8c779c46d8217b..baebcbc26eb29b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -421,12 +421,10 @@ xfs_broot_realloc(
 }
 
 /*
- * Reallocate the space for if_broot based on the number of records
- * being added or deleted as indicated in rec_diff.  Move the records
- * and pointers in if_broot to fit the new size.  When shrinking this
- * will eliminate holes between the records and pointers created by
- * the caller.  When growing this will create holes to be filled in
- * by the caller.
+ * Reallocate the space for if_broot based on the number of records.  Move the
+ * records and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by the caller.
+ * When growing this will create holes to be filled in by the caller.
  *
  * The caller must not request to add more records than would fit in
  * the on-disk inode root.  If the if_broot is currently NULL, then
@@ -435,40 +433,47 @@ xfs_broot_realloc(
  * it can go to zero.
  *
  * ip -- the inode whose if_broot area is changing
- * ext_diff -- the change in the number of records, positive or negative,
- *	 requested for the if_broot array.
+ * whichfork -- which inode fork to change
+ * new_numrecs -- the new number of records requested for the if_broot array
+ *
+ * Returns the incore btree root block.
  */
-void
+struct xfs_btree_block *
 xfs_iroot_realloc(
 	struct xfs_inode	*ip,
-	int			rec_diff,
-	int			whichfork)
+	int			whichfork,
+	unsigned int		new_numrecs)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	char			*np;
 	char			*op;
-	size_t			new_size;
-	short			old_size = ifp->if_broot_bytes;
-	int			cur_max;
-	int			new_max;
+	unsigned int		new_size;
+	unsigned int		old_size = ifp->if_broot_bytes;
 
 	/*
-	 * Handle the degenerate case quietly.
+	 * Block mapping btrees do not support storing zero records; if this
+	 * happens, the fork is being changed to FMT_EXTENTS.  Free the broot
+	 * and get out.
 	 */
-	if (rec_diff == 0)
-		return;
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
 
-	if (rec_diff > 0) {
 		/*
 		 * If there wasn't any memory allocated before, just
 		 * allocate it now and get out.
 		 */
-		if (old_size == 0) {
-			new_size = xfs_bmap_broot_space_calc(mp, rec_diff);
-			xfs_broot_realloc(ifp, new_size);
-			return;
-		}
+		if (old_size == 0)
+			return xfs_broot_realloc(ifp, new_size);
 
 		/*
 		 * If there is already an existing if_broot, then we need
@@ -476,10 +481,7 @@ xfs_iroot_realloc(
 		 * location.  The records don't change location because
 		 * they are kept butted up against the btree block header.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
-		new_max = cur_max + rec_diff;
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-
+		old_numrecs = xfs_bmbt_maxrecs(mp, old_size, false);
 		xfs_broot_realloc(ifp, new_size);
 		op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 						     old_size);
@@ -487,27 +489,15 @@ xfs_iroot_realloc(
 						     (int)new_size);
 		ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 			xfs_inode_fork_size(ip, whichfork));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
-		return;
+		memmove(np, op, old_numrecs * (uint)sizeof(xfs_fsblock_t));
+		return ifp->if_broot;
 	}
 
 	/*
-	 * rec_diff is less than 0.  In this case, we are shrinking the
-	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
+	 * We're reducing, but not totally eliminating, numrecs.  In this case,
+	 * we are shrinking the if_broot buffer, so it must already exist.
 	 */
-	ASSERT(ifp->if_broot != NULL && old_size > 0);
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = xfs_bmap_broot_space_calc(mp, new_max);
-	else
-		new_size = 0;
-	if (new_size == 0) {
-		xfs_broot_realloc(ifp, 0);
-		return;
-	}
+	ASSERT(ifp->if_broot != NULL && old_size > 0 && new_size > 0);
 
 	/*
 	 * Shrink the btree root by moving the bmbt pointers, since they are
@@ -517,11 +507,12 @@ xfs_iroot_realloc(
 	op = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1, old_size);
 	np = (char *)xfs_bmap_broot_ptr_addr(mp, ifp->if_broot, 1,
 					     (int)new_size);
-	memmove(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
+	memmove(np, op, new_numrecs * (uint)sizeof(xfs_fsblock_t));
 
 	xfs_broot_realloc(ifp, new_size);
 	ASSERT(xfs_bmap_bmdr_space(ifp->if_broot) <=
 	       xfs_inode_fork_size(ip, whichfork));
+	return ifp->if_broot;
 }
 
 
diff --git a/libxfs/xfs_inode_fork.h b/libxfs/xfs_inode_fork.h
index e3c5c9121044fd..d05eb0bad864e1 100644
--- a/libxfs/xfs_inode_fork.h
+++ b/libxfs/xfs_inode_fork.h
@@ -175,7 +175,8 @@ struct xfs_btree_block *xfs_broot_alloc(struct xfs_ifork *ifp,
 struct xfs_btree_block *xfs_broot_realloc(struct xfs_ifork *ifp,
 				size_t new_size);
 
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
+struct xfs_btree_block *xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
+				unsigned int new_numrecs);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);

