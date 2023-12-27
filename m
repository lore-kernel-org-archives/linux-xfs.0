Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D9ACA46
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CdmM9OEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2ACC433C7;
	Mon,  1 Jan 2024 00:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067471;
	bh=BjYNrI/mCye+aCefFL7b1KQTA6dl2/2G9bEcL6hezpE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CdmM9OEMtkmLJSfqE+aNxxItx0/1QJVMEVzpgNDkhtK+l6637rFqRROOCcBXTV89o
	 fcvlTzj4FDbSmJeCXfaXbnuy1QRuIuswq1VALzN6mu8WDYG28NLeK1QYyOrIXMi+Qy
	 2Y09I4Ynud8XP72JeNuwsK/JTeoRJJoOTE4LyOgdWYpuTOR3PJhaRSnmHGfqjPVzkF
	 vcU/Ec1tYfNqhV3OuA09zTz7rqwhtlHPPxiO5rY7FbTWdpIpWJAFnm4AKMv/nLoVo1
	 NXmq0D1mKE4nv05aPL/8nfVHCEbbOdQxznWaroJsO0dZYBHsQ9lFasMUNpeU4f1DaZ
	 h2MFMykYhQuZw==
Date: Sun, 31 Dec 2023 16:04:31 +9900
Subject: [PATCH 13/14] xfs: support storing records in the inode core root
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013375.1812545.9158447302101408118.stgit@frogsfrogsfrogs>
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

Add the necessary flags and code so that we can support storing leaf
records in the inode root block of a btree.  This hasn't been necessary
before, but the realtime rmapbt will need to be able to do this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c         |  150 ++++++++++++++++++++++++++++++++++++++++----
 libxfs/xfs_btree.h         |    1 
 libxfs/xfs_btree_staging.c |    4 +
 3 files changed, 141 insertions(+), 14 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 0f0198ae0cd..df13656ffe6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -264,6 +264,11 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
+	/* Don't check the inode-core root. */
+	if ((cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) &&
+	    level == cur->bc_nlevels - 1)
+		return 0;
+
 	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
 		return xfs_btree_check_lblock(cur, block, level, bp);
 	else
@@ -1544,12 +1549,16 @@ xfs_btree_log_recs(
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
@@ -3079,6 +3088,64 @@ xfs_btree_iroot_realloc(
 			cur->bc_ops->iroot_ops, rec_diff);
 }
 
+/*
+ * Move the records from a root leaf block to a separate block.
+ *
+ * Trickery here: The amount of memory that we need per record for the incore
+ * root block changes when we convert a leaf block to an internal block.
+ * Therefore, we copy leaf records into the new btree block (cblock) before
+ * freeing the incore root block and changing the tree height.
+ *
+ * Once we've changed the tree height, we allocate a new incore root block
+ * (which will now be an internal root block) and populate it with a pointer to
+ * cblock and the relevant keys.
+ */
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
+	size_t			size;
+	int			numrecs = xfs_btree_get_numrecs(block);
+
+	/* Copy the records from the leaf root into the new child block. */
+	rp = xfs_btree_rec_addr(cur, 1, block);
+	crp = xfs_btree_rec_addr(cur, 1, cblock);
+	xfs_btree_copy_recs(cur, crp, rp, numrecs);
+
+	/* Zap the old root and change the tree height. */
+	xfs_iroot_free(cur->bc_ino.ip, cur->bc_ino.whichfork);
+	cur->bc_nlevels++;
+	cur->bc_levels[1].ptr = 1;
+
+	/*
+	 * Allocate a new internal root block buffer and reinitialize it to
+	 * point to a single new child.
+	 */
+	size = cur->bc_ops->iroot_ops->size(cur->bc_mp, cur->bc_nlevels - 1, 1);
+	xfs_iroot_alloc(cur->bc_ino.ip, cur->bc_ino.whichfork, size);
+	block = xfs_btree_get_iroot(cur);
+	xfs_btree_init_block(cur->bc_mp, block, cur->bc_ops,
+			cur->bc_nlevels - 1, 1, cur->bc_ino.ip->i_ino);
+
+	pp = xfs_btree_ptr_addr(cur, 1, block);
+	kp = xfs_btree_key_addr(cur, 1, block);
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
@@ -3163,7 +3230,7 @@ xfs_btree_new_iroot(
 	struct xfs_buf		*cbp;		/* buffer for cblock */
 	struct xfs_btree_block	*block;		/* btree block */
 	struct xfs_btree_block	*cblock;	/* child btree block */
-	union xfs_btree_ptr	*pp;
+	union xfs_btree_ptr	aptr;
 	union xfs_btree_ptr	nptr;		/* new block addr */
 	int			level;		/* btree level */
 	int			error;		/* error return code */
@@ -3175,10 +3242,15 @@ xfs_btree_new_iroot(
 	level = cur->bc_nlevels - 1;
 
 	block = xfs_btree_get_iroot(cur);
-	pp = xfs_btree_ptr_addr(cur, 1, block);
+	ASSERT(level > 0 || (cur->bc_flags & XFS_BTREE_IROOT_RECORDS));
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
@@ -3204,10 +3276,14 @@ xfs_btree_new_iroot(
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
 
 	*logflags |=
 		XFS_ILOG_CORE | xfs_ilog_fbroot(cur->bc_ino.whichfork);
@@ -3704,6 +3780,45 @@ xfs_btree_insert(
 	return error;
 }
 
+/*
+ * Move the records from a child leaf block to the root block.
+ *
+ * Trickery here: The amount of memory we need per record for the incore root
+ * block changes when we convert a leaf block to an internal block.  Therefore,
+ * we free the incore root block, change the tree height, allocate a new incore
+ * root, and copy the records from the doomed block into the new root.
+ */
+STATIC void
+xfs_btree_demote_leaf_child(
+	struct xfs_btree_cur	*cur,
+	struct xfs_btree_block	*cblock,
+	int			numrecs)
+{
+	union xfs_btree_rec	*rp;
+	union xfs_btree_rec	*crp;
+	struct xfs_btree_block	*block;
+	size_t			size;
+
+	/* Zap the old root and change the tree height. */
+	xfs_iroot_free(cur->bc_ino.ip, cur->bc_ino.whichfork);
+	cur->bc_levels[0].bp = NULL;
+	cur->bc_nlevels--;
+
+	/*
+	 * Allocate a new internal root block buffer and reinitialize it with
+	 * the leaf records in the child.
+	 */
+	size = cur->bc_ops->iroot_ops->size(cur->bc_mp, 0, numrecs);
+	xfs_iroot_alloc(cur->bc_ino.ip, cur->bc_ino.whichfork, size);
+	block = xfs_btree_get_iroot(cur);
+	xfs_btree_init_block(cur->bc_mp, block, cur->bc_ops, 0, numrecs,
+			cur->bc_ino.ip->i_ino);
+
+	rp = xfs_btree_rec_addr(cur, 1, block);
+	crp = xfs_btree_rec_addr(cur, 1, cblock);
+	xfs_btree_copy_recs(cur, rp, crp, numrecs);
+}
+
 /*
  * Move the keyptrs from a child node block to the root block.
  *
@@ -3785,14 +3900,19 @@ xfs_btree_kill_iroot(
 #endif
 
 	ASSERT(cur->bc_flags & XFS_BTREE_ROOT_IN_INODE);
-	ASSERT(cur->bc_nlevels > 1);
+	ASSERT((cur->bc_flags & XFS_BTREE_IROOT_RECORDS) ||
+	       cur->bc_nlevels > 1);
 
 	/*
 	 * Don't deal with the root block needs to be a leaf case.
 	 * We're just going to turn the thing back into extents anyway.
 	 */
 	level = cur->bc_nlevels - 1;
-	if (level == 1)
+	if (level == 1 && !(cur->bc_flags & XFS_BTREE_IROOT_RECORDS))
+		goto out0;
+
+	/* If we're already a leaf, jump out. */
+	if (level == 0)
 		goto out0;
 
 	/*
@@ -3822,9 +3942,13 @@ xfs_btree_kill_iroot(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 7872fc1739b..bb6c2feecea 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -337,6 +337,7 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
  * is dynamically allocated and must be freed when the cursor is deleted.
  */
 #define XFS_BTREE_STAGING		(1<<5)
+#define XFS_BTREE_IROOT_RECORDS		(1<<6)	/* iroot can store records */
 
 /* btree stored in memory; not compatible with ROOT_IN_INODE */
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index ec496915433..8b2e41dacff 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
@@ -710,7 +710,9 @@ xfs_btree_bload_compute_geometry(
 			 *
 			 * Note that bmap btrees forbid records in the root.
 			 */
-			if (level != 0 && nr_this_level <= avg_per_block) {
+			if ((level != 0 ||
+			     (cur->bc_flags & XFS_BTREE_IROOT_RECORDS)) &&
+			    nr_this_level <= avg_per_block) {
 				nr_blocks++;
 				break;
 			}

