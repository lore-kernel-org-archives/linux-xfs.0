Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53C9DDDC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051604; cv=none; b=AwEGG7y3bTBssEQ3Hu9zW4GbdEk2hhr4/j4vML/PGMBa2v2qK4O0b15gc81zNA4fUFYi0BKk71cXPDpcZz6iOMEjbKyUxsT82WQE/+zuiOtnYBubT6DeimYFQ8Tq98QlppnZd1D+rmjXp/Q1hSVNNGsjm4YzeyfT/cVGvRGsGZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051604; c=relaxed/simple;
	bh=cAVmFIGGg8MNHEqaT8gU4BUe3LqOT87yT/6Gbjmabfs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mJIxlVq8fkbwrwXtLBi4oRaAtzbFo0gnsRppNQsZmMI4CdgyfuH2AnBb2ow+x0tv7EZWucBKSjWO2D2FDR719qsevknYEo4dtUyHO70DHkyWcQgYCQxfTbcXcmg3rU0DKyMB55i2rMD3tbVbpQIaTc1vMEDJb4ZYM6qVVJdV5j8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bs08bTo3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bs08bTo3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB7AC4CECE;
	Fri, 13 Dec 2024 01:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051604;
	bh=cAVmFIGGg8MNHEqaT8gU4BUe3LqOT87yT/6Gbjmabfs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bs08bTo3X0nY5ut3KSFLRdQik3FF4QHKmsBD5hjONn3mpPOfZWH8s/YgPGd+jq5Jc
	 U9SFH+t7qcfpVMIy6k5uPwVkp9iM1RWksTjwxk++VO1SVBFdp4GiEqN8EXrF/LN5Ir
	 HDDNx/THhzGQOjD7OAMFEr+Naht6l3cND6f5MaET5GCf401V+h5a9ZYX2NfsOrTofc
	 h2L8rQrCRAtEc1mzcVbWM8DU4JQaVrUBLohN3wiwiK1juG+F7x+xSPvMmC7LBz8fqz
	 gmdtvMtn3DoewBfEw/jKt42QyE/c92gVKfuW+SLPykHLghJi7XhxneBfhVrd8/iB+q
	 kKhmVt/sSMhiw==
Date: Thu, 12 Dec 2024 17:00:03 -0800
Subject: [PATCH 8/8] xfs: support storing records in the inode core root
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405122297.1180922.14475265699161663487.stgit@frogsfrogsfrogs>
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

Add the necessary flags and code so that we can support storing leaf
records in the inode root block of a btree.  This hasn't been necessary
before, but the realtime rmapbt will need to be able to do this.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c         |  138 ++++++++++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h         |    2 -
 fs/xfs/libxfs/xfs_btree_staging.c |    9 ++
 3 files changed, 132 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e83a8de5fb8746..5ab201ef041e7d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1537,12 +1537,16 @@ xfs_btree_log_recs(
 	int			first,
 	int			last)
 {
+	if (!bp) {
+		xfs_trans_log_inode(cur->bc_tp, cur->bc_ino.ip,
+				xfs_ilog_fbroot(cur->bc_ino.whichfork));
+		return;
+	}
 
 	xfs_trans_buf_set_type(cur->bc_tp, bp, XFS_BLFT_BTREE_BUF);
 	xfs_trans_log_buf(cur->bc_tp, bp,
 			  xfs_btree_rec_offset(cur, first),
 			  xfs_btree_rec_offset(cur, last + 1) - 1);
-
 }
 
 /*
@@ -3078,6 +3082,59 @@ xfs_btree_split(
 #define xfs_btree_split	__xfs_btree_split
 #endif /* __KERNEL__ */
 
+/* Move the records from a root leaf block to a separate block. */
+STATIC void
+xfs_btree_promote_leaf_iroot(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*block,
+	struct xfs_buf		*cbp,
+	union xfs_btree_ptr	*cptr,
+	struct xfs_btree_block	*cblock)
+{
+	union xfs_btree_rec	*rp;
+	union xfs_btree_rec	*crp;
+	union xfs_btree_key	*kp;
+	union xfs_btree_ptr	*pp;
+	struct xfs_btree_block	*broot;
+	int			numrecs = xfs_btree_get_numrecs(block);
+
+	/* Copy the records from the leaf broot into the new child block. */
+	rp = xfs_btree_rec_addr(cur, 1, block);
+	crp = xfs_btree_rec_addr(cur, 1, cblock);
+	xfs_btree_copy_recs(cur, crp, rp, numrecs);
+
+	/*
+	 * Increment the tree height.
+	 *
+	 * Trickery here: The amount of memory that we need per record for the
+	 * ifork's btree root block may change when we convert the broot from a
+	 * leaf to a node block.  Free the existing leaf broot so that nobody
+	 * thinks we need to migrate node pointers when we realloc the broot
+	 * buffer after bumping nlevels.
+	 */
+	cur->bc_ops->broot_realloc(cur, 0);
+	cur->bc_nlevels++;
+	cur->bc_levels[1].ptr = 1;
+
+	/*
+	 * Allocate a new node broot and initialize it to point to the new
+	 * child block.
+	 */
+	broot = cur->bc_ops->broot_realloc(cur, 1);
+	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops,
+			cur->bc_nlevels - 1, 1, cur->bc_ino.ip->i_ino);
+
+	pp = xfs_btree_ptr_addr(cur, 1, broot);
+	kp = xfs_btree_key_addr(cur, 1, broot);
+	xfs_btree_copy_ptrs(cur, pp, cptr, 1);
+	xfs_btree_get_keys(cur, cblock, kp);
+
+	/* Attach the new block to the cursor and log it. */
+	xfs_btree_setbuf(cur, 0, cbp);
+	xfs_btree_log_block(cur, cbp, XFS_BB_ALL_BITS);
+	xfs_btree_log_recs(cur, cbp, 1, numrecs);
+}
+
 /*
  * Move the keys and pointers from a root block to a separate block.
  *
@@ -3163,7 +3220,7 @@ xfs_btree_new_iroot(
 	struct xfs_buf		*cbp;		/* buffer for cblock */
 	struct xfs_btree_block	*block;		/* btree block */
 	struct xfs_btree_block	*cblock;	/* child btree block */
-	union xfs_btree_ptr	*pp;
+	union xfs_btree_ptr	aptr;
 	union xfs_btree_ptr	nptr;		/* new block addr */
 	int			level;		/* btree level */
 	int			error;		/* error return code */
@@ -3175,10 +3232,15 @@ xfs_btree_new_iroot(
 	level = cur->bc_nlevels - 1;
 
 	block = xfs_btree_get_iroot(cur);
-	pp = xfs_btree_ptr_addr(cur, 1, block);
+	ASSERT(level > 0 || (cur->bc_ops->geom_flags & XFS_BTGEO_IROOT_RECORDS));
+	if (level > 0)
+		aptr = *xfs_btree_ptr_addr(cur, 1, block);
+	else
+		aptr.l = cpu_to_be64(XFS_INO_TO_FSB(cur->bc_mp,
+				cur->bc_ino.ip->i_ino));
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = xfs_btree_alloc_block(cur, pp, &nptr, stat);
+	error = xfs_btree_alloc_block(cur, &aptr, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3204,10 +3266,14 @@ xfs_btree_new_iroot(
 			cblock->bb_u.s.bb_blkno = bno;
 	}
 
-	error = xfs_btree_promote_node_iroot(cur, block, level, cbp, &nptr,
-			cblock);
-	if (error)
-		goto error0;
+	if (level > 0) {
+		error = xfs_btree_promote_node_iroot(cur, block, level, cbp,
+				&nptr, cblock);
+		if (error)
+			goto error0;
+	} else {
+		xfs_btree_promote_leaf_iroot(cur, block, cbp, &nptr, cblock);
+	}
 
 	*logflags |= XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
 	*stat = 1;
@@ -3726,6 +3792,43 @@ xfs_btree_insert(
 	return error;
 }
 
+/* Move the records from a child leaf block to the root block. */
+STATIC void
+xfs_btree_demote_leaf_child(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*cblock,
+	int			numrecs)
+{
+	union xfs_btree_rec	*rp;
+	union xfs_btree_rec	*crp;
+	struct xfs_btree_block	*broot;
+
+	/*
+	 * Decrease the tree height.
+	 *
+	 * Trickery here: The amount of memory that we need per record for the
+	 * ifork's btree root block may change when we convert the broot from a
+	 * node to a leaf.  Free the old node broot so that we can get a fresh
+	 * leaf broot.
+	 */
+	cur->bc_ops->broot_realloc(cur, 0);
+	cur->bc_nlevels--;
+
+	/*
+	 * Allocate a new leaf broot and copy the records from the old child.
+	 * Detach the old child from the cursor.
+	 */
+	broot = cur->bc_ops->broot_realloc(cur, numrecs);
+	xfs_btree_init_block(cur->bc_mp, broot, cur->bc_ops, 0, numrecs,
+			cur->bc_ino.ip->i_ino);
+
+	rp = xfs_btree_rec_addr(cur, 1, broot);
+	crp = xfs_btree_rec_addr(cur, 1, cblock);
+	xfs_btree_copy_recs(cur, rp, crp, numrecs);
+
+	cur->bc_levels[0].bp = NULL;
+}
+
 /*
  * Move the keyptrs from a child node block to the root block.
  *
@@ -3804,14 +3907,19 @@ xfs_btree_kill_iroot(
 #endif
 
 	ASSERT(cur->bc_ops->type == XFS_BTREE_TYPE_INODE);
-	ASSERT(cur->bc_nlevels > 1);
+	ASSERT((cur->bc_ops->geom_flags & XFS_BTGEO_IROOT_RECORDS) ||
+	       cur->bc_nlevels > 1);
 
 	/*
 	 * Don't deal with the root block needs to be a leaf case.
 	 * We're just going to turn the thing back into extents anyway.
 	 */
 	level = cur->bc_nlevels - 1;
-	if (level == 1)
+	if (level == 1 && !(cur->bc_ops->geom_flags & XFS_BTGEO_IROOT_RECORDS))
+		goto out0;
+
+	/* If we're already a leaf, jump out. */
+	if (level == 0)
 		goto out0;
 
 	/*
@@ -3841,9 +3949,13 @@ xfs_btree_kill_iroot(
 	ASSERT(xfs_btree_ptr_is_null(cur, &ptr));
 #endif
 
-	error = xfs_btree_demote_node_child(cur, cblock, level, numrecs);
-	if (error)
-		return error;
+	if (level > 1) {
+		error = xfs_btree_demote_node_child(cur, cblock, level,
+				numrecs);
+		if (error)
+			return error;
+	} else
+		xfs_btree_demote_leaf_child(cur, cblock, numrecs);
 
 	error = xfs_btree_free_block(cur, cbp);
 	if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8380ae0a64dd5e..3b8c2ccad90847 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -233,7 +233,7 @@ struct xfs_btree_ops {
 
 /* btree geometry flags */
 #define XFS_BTGEO_OVERLAPPING		(1U << 0) /* overlapping intervals */
-
+#define XFS_BTGEO_IROOT_RECORDS		(1U << 1) /* iroot can store records */
 
 union xfs_btree_irec {
 	struct xfs_alloc_rec_incore	a;
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 6949297031529e..58c146b5c9d479 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -573,6 +573,7 @@ xfs_btree_bload_compute_geometry(
 	struct xfs_btree_bload	*bbl,
 	uint64_t		nr_records)
 {
+	const struct xfs_btree_ops *ops = cur->bc_ops;
 	uint64_t		nr_blocks = 0;
 	uint64_t		nr_this_level;
 
@@ -599,7 +600,7 @@ xfs_btree_bload_compute_geometry(
 		xfs_btree_bload_level_geometry(cur, bbl, level, nr_this_level,
 				&avg_per_block, &level_blocks, &dontcare64);
 
-		if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE) {
+		if (ops->type == XFS_BTREE_TYPE_INODE) {
 			/*
 			 * If all the items we want to store at this level
 			 * would fit in the inode root block, then we have our
@@ -607,7 +608,9 @@ xfs_btree_bload_compute_geometry(
 			 *
 			 * Note that bmap btrees forbid records in the root.
 			 */
-			if (level != 0 && nr_this_level <= avg_per_block) {
+			if ((level != 0 ||
+			     (ops->geom_flags & XFS_BTGEO_IROOT_RECORDS)) &&
+			    nr_this_level <= avg_per_block) {
 				nr_blocks++;
 				break;
 			}
@@ -658,7 +661,7 @@ xfs_btree_bload_compute_geometry(
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;
-	if (cur->bc_ops->type == XFS_BTREE_TYPE_INODE)
+	if (ops->type == XFS_BTREE_TYPE_INODE)
 		bbl->nr_blocks = nr_blocks - 1;
 	else
 		bbl->nr_blocks = nr_blocks;

