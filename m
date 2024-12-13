Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403BC14287
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 00:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051526; cv=none; b=usoZFDZ7sFmmoReLNJrtNSyRmpDprqkQhpmxbQA1uCyG66eA5vIDR95DLtYrq4vPWPLSkHOSoNRfYjHEetYuWfXHJyKbKGY6UQLYxMgLkskJTrFmINTas4BjwUhIDsqjMZ6LPNocEEwENhziObkkfWKBpGq/rWvHkCJ+vFY9b2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051526; c=relaxed/simple;
	bh=F0qXIAamfsTXC6+7+9dgtAzctZZLlj1edl/SCek6wXQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a8NI1OOnL4T89IwT+279f5wgE7AU820E+o+mH6eMc8LsANoHoEUsXhRTogrLHXAvaHPYARM/x0kc4sZifm169sGA7YTm155zWmz/+aXHa4UE+qW1IEGGNVSt9ovJVYH8RrqvXS8XOaeGpAF4BYQkzh8ACCFRXSHTrk808HaMWOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMgrHZra; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMgrHZra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CB4C4CECE;
	Fri, 13 Dec 2024 00:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051526;
	bh=F0qXIAamfsTXC6+7+9dgtAzctZZLlj1edl/SCek6wXQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMgrHZrauwJh84hjANIKl1mUCQ0+LWhimcVrpvt/TTF9kLbmFfcdNEi7DrMqpH21d
	 8RkJl6iEjQuE70Ru5NVJhZRIlEtyTSAhUhQF1Iiw5wBrqA9LsdVajSiJq2N52rS8/n
	 AyusMRJ7w3k/biVyfHnm8pBCV4a6GCfrnCRE/EfhTMDmQtZHhD8wq+5A/mZ7Bl9nDv
	 x6sydl1YZUrpKXEoRyOh3LgalN4Z9Fu0Qka+5jLaNWEcmMm635Ob0TR5neuCsXiBpc
	 2iAV7yXYMm33l19+ugNf+RGAaAFFNsOIWs3m5GqDGD5qopho+BzwLIwHcIwr2lm9if
	 CHRzqOYkNz9OQ==
Date: Thu, 12 Dec 2024 16:58:45 -0800
Subject: [PATCH 3/8] xfs: make xfs_iroot_realloc take the new numrecs instead
 of deltas
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122210.1180922.1051140780688294093.stgit@frogsfrogsfrogs>
In-Reply-To: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
References: <173405122140.1180922.1477850791026540480.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Change the calling signature of xfs_iroot_realloc to take the ifork and
the new number of records in the btree block, not a diff against the
current number.  This will make the callsites easier to understand.

Note that this function is misnamed because it is very specific to the
single type of inode-rooted btree supported.  This will be addressed in
a subsequent patch.

Return the new btree root to reduce the amount of code clutter.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |    7 +--
 fs/xfs/libxfs/xfs_btree.c      |   25 ++++--------
 fs/xfs/libxfs/xfs_inode_fork.c |   83 ++++++++++++++++++----------------------
 fs/xfs/libxfs/xfs_inode_fork.h |    3 +
 4 files changed, 51 insertions(+), 67 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 5255f93bae31f3..8ab38f07cb78dd 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -615,7 +615,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_realloc(ip, whichfork, 0);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -659,12 +659,11 @@ xfs_bmap_extents_to_btree(
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
@@ -746,7 +745,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_realloc(ip, whichfork, 0);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 68ee1c299c25fd..5714bec26c2084 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3161,9 +3161,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_ino.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_ino.whichfork);
+	xfs_iroot_realloc(cur->bc_ino.ip, cur->bc_ino.whichfork, 1);
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3347,7 +3345,8 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_ino.whichfork);
+			xfs_iroot_realloc(ip, cur->bc_ino.whichfork,
+					numrecs + 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3705,9 +3704,7 @@ STATIC int
 xfs_btree_kill_iroot(
 	struct xfs_btree_cur	*cur)
 {
-	int			whichfork = cur->bc_ino.whichfork;
 	struct xfs_inode	*ip = cur->bc_ino.ip;
-	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_block	*block;
 	struct xfs_btree_block	*cblock;
 	union xfs_btree_key	*kp;
@@ -3716,7 +3713,6 @@ xfs_btree_kill_iroot(
 	union xfs_btree_ptr	*cpp;
 	struct xfs_buf		*cbp;
 	int			level;
-	int			index;
 	int			numrecs;
 	int			error;
 #ifdef DEBUG
@@ -3762,14 +3758,10 @@ xfs_btree_kill_iroot(
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
@@ -3949,10 +3941,11 @@ xfs_btree_delrec(
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
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index da18e60b774199..36b557fadb0218 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -424,12 +424,10 @@ xfs_broot_realloc(
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
@@ -438,40 +436,47 @@ xfs_broot_realloc(
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
@@ -479,10 +484,7 @@ xfs_iroot_realloc(
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
@@ -490,27 +492,15 @@ xfs_iroot_realloc(
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
@@ -520,11 +510,12 @@ xfs_iroot_realloc(
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
 
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index e3c5c9121044fd..d05eb0bad864e1 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -175,7 +175,8 @@ struct xfs_btree_block *xfs_broot_alloc(struct xfs_ifork *ifp,
 struct xfs_btree_block *xfs_broot_realloc(struct xfs_ifork *ifp,
 				size_t new_size);
 
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
+struct xfs_btree_block *xfs_iroot_realloc(struct xfs_inode *ip, int whichfork,
+				unsigned int new_numrecs);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);

