Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B6E12FB04
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816725; cv=none; b=bCQ8EEonaJ1x6df7zhgdmwzKiuJ/TtnBN2IHLDBe70wMOfoM2/OvXqnDHo8CE3ljH35JxXLDJlX+3Y01qViXAITpLQPgLA6wgNmLkF6NaPiDPi9ZiDqVp0pQ5V3vX8rbaHkfa+a9TPT+mWdp45+lo47gkK2Mma+GwK8jXGq779E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816725; c=relaxed/simple;
	bh=RMIeaSnr1y+LEtmS7zZ5QHXCXPjwwodahINYzG7yel8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZUdqlPVdVAuTf3xxDdNh2eNLr2PyK/1gtfP9a5wo3rjkryurgzizEwg2G4s9GGtIFIaLI5yoR4+ifY53iSd4pxWEvtT3RPy3EqBqbKlCT8b/qHvuXdcBJ3eKQnGlUMm3XhGDJIgNuJQ9Rvf4nIJ3vZRksx/qmidDy32aYD8ttHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvpfqTMf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvpfqTMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F76C433C7;
	Thu,  1 Feb 2024 19:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816724;
	bh=RMIeaSnr1y+LEtmS7zZ5QHXCXPjwwodahINYzG7yel8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LvpfqTMfr1Iinul7xtJZc/RIdK+eUXptWbqs7mTIe4reyZ10yikqyeEMGsSJeu7g9
	 7K6L7rftFJ7RCUbcjZRjU1MNYxJujEByT+/EBUzFWKYFqEGg+IrIBqTseygORqe3SQ
	 yS5IgNMWzsMGhimkF4flyWbds+UWuIO/h9n7sZLqlFJpE9Iz+kZMYswY6bz8sIgzBM
	 X59kxfx9i267aTApQ7wNUSjWRPv4YnIwwY8w2uKkhazHoRHbQvqLI+jHqVdf2fOWkp
	 nGOmA+s5BEYG13kZBEHcf8jxCf1d72KivARyRZQKuKHwL37LEdnM/J1Lqeqn6ippNC
	 qIYMfbIkQFH2w==
Date: Thu, 01 Feb 2024 11:45:24 -0800
Subject: [PATCH 22/23] xfs: split the per-btree union in struct xfs_btree_cur
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334301.1604831.756748259160360679.stgit@frogsfrogsfrogs>
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

Split up the union that encodes btree-specific fields in struct
xfs_btree_cur.  Most fields in there are specific to the btree type
encoded in xfs_btree_ops.type, and we can use the obviously named union
for that.  But one field is specific to the bmapbt and two are shared by
the refcount and rtrefcountbt.  Move those to a separate union to make
the usage clear and not need a separate struct for the refcount-related
fields.

This will also make unnecessary some very awkward btree cursor
refc/rtrefc switching logic in the rtrefcount patchset.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c           |   22 +++++++-------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    9 +++---
 fs/xfs/libxfs/xfs_btree.c          |    2 +
 fs/xfs/libxfs/xfs_btree.h          |   55 +++++++++++++++---------------------
 fs/xfs/libxfs/xfs_btree_staging.c  |    1 +
 fs/xfs/libxfs/xfs_refcount.c       |   24 ++++++++--------
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 +--
 7 files changed, 54 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d519feea84ec1..347801f1ba7b1 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -676,7 +676,7 @@ xfs_bmap_extents_to_btree(
 		goto out_root_realloc;
 	}
 
-	cur->bc_ino.allocated++;
+	cur->bc_bmap.allocated++;
 	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	error = xfs_trans_get_buf(tp, mp->m_ddev_targp,
@@ -894,7 +894,7 @@ xfs_bmap_add_attrfork_btree(
 			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 			return -ENOSPC;
 		}
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	}
 	return 0;
@@ -922,7 +922,7 @@ xfs_bmap_add_attrfork_extents(
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
 					  XFS_DATA_FORK);
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -1746,7 +1746,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_ino.allocated : 0));
+			(bma->cur ? bma->cur->bc_bmap.allocated : 0));
 
 		PREV.br_startoff = new_endoff;
 		PREV.br_blockcount = temp;
@@ -1836,7 +1836,7 @@ xfs_bmap_add_extent_delay_real(
 		temp = PREV.br_blockcount - new->br_blockcount;
 		da_new = XFS_FILBLKS_MIN(xfs_bmap_worst_indlen(bma->ip, temp),
 			startblockval(PREV.br_startblock) -
-			(bma->cur ? bma->cur->bc_ino.allocated : 0));
+			(bma->cur ? bma->cur->bc_bmap.allocated : 0));
 
 		PREV.br_startblock = nullstartblock(da_new);
 		PREV.br_blockcount = temp;
@@ -1959,8 +1959,8 @@ xfs_bmap_add_extent_delay_real(
 		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
 
 	if (bma->cur) {
-		da_new += bma->cur->bc_ino.allocated;
-		bma->cur->bc_ino.allocated = 0;
+		da_new += bma->cur->bc_bmap.allocated;
+		bma->cur->bc_bmap.allocated = 0;
 	}
 
 	/* adjust for changes in reserved delayed indirect blocks */
@@ -2525,7 +2525,7 @@ xfs_bmap_add_extent_unwritten_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		*curp = cur;
 	}
 
@@ -2913,7 +2913,7 @@ xfs_bmap_add_extent_hole_real(
 
 	/* clear out the allocated field, done with it now in any case. */
 	if (cur)
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 
 	xfs_bmap_check_leaf_extents(cur, ip, whichfork);
 done:
@@ -5629,7 +5629,7 @@ __xfs_bunmapi(
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (cur) {
 		if (!error)
-			cur->bc_ino.allocated = 0;
+			cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 	return error;
@@ -6146,7 +6146,7 @@ xfs_bmap_split_extent(
 
 del_cursor:
 	if (cur) {
-		cur->bc_ino.allocated = 0;
+		cur->bc_bmap.allocated = 0;
 		xfs_btree_del_cursor(cur, error);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 90ab644b98b4e..5dad3db4affa0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -198,10 +198,10 @@ xfs_bmbt_update_cursor(
 	ASSERT((dst->bc_tp->t_highest_agno != NULLAGNUMBER) ||
 	       (dst->bc_ino.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
-	dst->bc_ino.allocated += src->bc_ino.allocated;
+	dst->bc_bmap.allocated += src->bc_bmap.allocated;
 	dst->bc_tp->t_highest_agno = src->bc_tp->t_highest_agno;
 
-	src->bc_ino.allocated = 0;
+	src->bc_bmap.allocated = 0;
 }
 
 STATIC int
@@ -256,7 +256,7 @@ xfs_bmbt_alloc_block(
 	}
 
 	ASSERT(args.len == 1);
-	cur->bc_ino.allocated++;
+	cur->bc_bmap.allocated++;
 	cur->bc_ino.ip->i_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_ino.ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(args.tp, cur->bc_ino.ip,
@@ -568,8 +568,7 @@ xfs_bmbt_init_common(
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 
 	cur->bc_ino.ip = ip;
-	cur->bc_ino.allocated = 0;
-
+	cur->bc_bmap.allocated = 0;
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f5f98928dc3d1..17ded4ccec75f 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -445,7 +445,7 @@ xfs_btree_del_cursor(
 	 * zero, then we should be shut down or on our way to shutdown due to
 	 * cancelling a dirty transaction on error.
 	 */
-	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_ino.allocated == 0 ||
+	ASSERT(cur->bc_btnum != XFS_BTNUM_BMAP || cur->bc_bmap.allocated == 0 ||
 	       xfs_is_shutdown(cur->bc_mp) || error != 0);
 
 	switch (cur->bc_ops->type) {
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 5230ca83cfa1a..7fc29562164b4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -243,30 +243,6 @@ union xfs_btree_irec {
 	struct xfs_refcount_irec	rc;
 };
 
-/* Per-AG btree information. */
-struct xfs_btree_cur_ag {
-	struct xfs_perag		*pag;
-	union {
-		struct xfs_buf		*agbp;
-		struct xbtree_afakeroot	*afake;	/* for staging cursor */
-	};
-	union {
-		struct {
-			unsigned int	nr_ops;	/* # record updates */
-			unsigned int	shape_changes;	/* # of extent splits */
-		} refc;
-	};
-};
-
-/* Btree-in-inode cursor information */
-struct xfs_btree_cur_ino {
-	struct xfs_inode		*ip;
-	struct xbtree_ifakeroot		*ifake;	/* for staging cursor */
-	int				allocated;
-	short				forksize;
-	char				whichfork;
-};
-
 struct xfs_btree_level {
 	/* buffer pointer */
 	struct xfs_buf		*bp;
@@ -296,15 +272,30 @@ struct xfs_btree_cur
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
 
-	/*
-	 * Short btree pointers need an agno to be able to turn the pointers
-	 * into physical addresses for IO, so the btree cursor switches between
-	 * bc_ino and bc_ag based on bc_ops->type.
-	 * the cursor.
-	 */
+	/* per-type information */
 	union {
-		struct xfs_btree_cur_ag	bc_ag;
-		struct xfs_btree_cur_ino bc_ino;
+		struct {
+			struct xfs_inode	*ip;
+			short			forksize;
+			char			whichfork;
+			struct xbtree_ifakeroot	*ifake;	/* for staging cursor */
+		} bc_ino;
+		struct {
+			struct xfs_perag	*pag;
+			struct xfs_buf		*agbp;
+			struct xbtree_afakeroot	*afake;	/* for staging cursor */
+		} bc_ag;
+	};
+
+	/* per-format private data */
+	union {
+		struct {
+			int		allocated;
+		} bc_bmap;	/* bmapbt */
+		struct {
+			unsigned int	nr_ops;		/* # record updates */
+			unsigned int	shape_changes;	/* # of extent splits */
+		} bc_refc;	/* refcountbt */
 	};
 
 	/* Must be at the end of the struct! */
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index 602c65ede1b0d..244b22edf6f73 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -172,6 +172,7 @@ xfs_btree_commit_afakeroot(
 	trace_xfs_btree_commit_afakeroot(cur);
 
 	kmem_free((void *)cur->bc_ops);
+	cur->bc_ag.afake = NULL;
 	cur->bc_ag.agbp = agbp;
 	cur->bc_ops = ops;
 	cur->bc_flags &= ~XFS_BTREE_STAGING;
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 90a4526fef929..605319903ef65 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1077,7 +1077,7 @@ xfs_refcount_still_have_space(
 	 * to handle each of the shape changes to the refcount btree.
 	 */
 	overhead = xfs_allocfree_block_count(cur->bc_mp,
-				cur->bc_ag.refc.shape_changes);
+				cur->bc_refc.shape_changes);
 	overhead += cur->bc_mp->m_refc_maxlevels;
 	overhead *= cur->bc_mp->m_sb.sb_blocksize;
 
@@ -1085,17 +1085,17 @@ xfs_refcount_still_have_space(
 	 * Only allow 2 refcount extent updates per transaction if the
 	 * refcount continue update "error" has been injected.
 	 */
-	if (cur->bc_ag.refc.nr_ops > 2 &&
+	if (cur->bc_refc.nr_ops > 2 &&
 	    XFS_TEST_ERROR(false, cur->bc_mp,
 			XFS_ERRTAG_REFCOUNT_CONTINUE_UPDATE))
 		return false;
 
-	if (cur->bc_ag.refc.nr_ops == 0)
+	if (cur->bc_refc.nr_ops == 0)
 		return true;
 	else if (overhead > cur->bc_tp->t_log_res)
 		return false;
-	return  cur->bc_tp->t_log_res - overhead >
-		cur->bc_ag.refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
+	return cur->bc_tp->t_log_res - overhead >
+		cur->bc_refc.nr_ops * XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
 /*
@@ -1155,7 +1155,7 @@ xfs_refcount_adjust_extents(
 			 * Either cover the hole (increment) or
 			 * delete the range (decrement).
 			 */
-			cur->bc_ag.refc.nr_ops++;
+			cur->bc_refc.nr_ops++;
 			if (tmp.rc_refcount) {
 				error = xfs_refcount_insert(cur, &tmp,
 						&found_tmp);
@@ -1216,7 +1216,7 @@ xfs_refcount_adjust_extents(
 		ext.rc_refcount += adj;
 		trace_xfs_refcount_modify_extent(cur->bc_mp,
 				cur->bc_ag.pag->pag_agno, &ext);
-		cur->bc_ag.refc.nr_ops++;
+		cur->bc_refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
 			if (error)
@@ -1305,7 +1305,7 @@ xfs_refcount_adjust(
 	if (shape_changed)
 		shape_changes++;
 	if (shape_changes)
-		cur->bc_ag.refc.shape_changes++;
+		cur->bc_refc.shape_changes++;
 
 	/* Now that we've taken care of the ends, adjust the middle extents */
 	error = xfs_refcount_adjust_extents(cur, agbno, aglen, adj);
@@ -1400,8 +1400,8 @@ xfs_refcount_finish_one(
 	 */
 	rcur = *pcur;
 	if (rcur != NULL && rcur->bc_ag.pag != ri->ri_pag) {
-		nr_ops = rcur->bc_ag.refc.nr_ops;
-		shape_changes = rcur->bc_ag.refc.shape_changes;
+		nr_ops = rcur->bc_refc.nr_ops;
+		shape_changes = rcur->bc_refc.shape_changes;
 		xfs_refcount_finish_one_cleanup(tp, rcur, 0);
 		rcur = NULL;
 		*pcur = NULL;
@@ -1413,8 +1413,8 @@ xfs_refcount_finish_one(
 			return error;
 
 		rcur = xfs_refcountbt_init_cursor(mp, tp, agbp, ri->ri_pag);
-		rcur->bc_ag.refc.nr_ops = nr_ops;
-		rcur->bc_ag.refc.shape_changes = shape_changes;
+		rcur->bc_refc.nr_ops = nr_ops;
+		rcur->bc_refc.shape_changes = shape_changes;
 	}
 	*pcur = rcur;
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 52f3e4a30ecce..2eb94f18ff33b 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -362,8 +362,8 @@ xfs_refcountbt_init_common(
 			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
 			xfs_refcountbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-	cur->bc_ag.refc.nr_ops = 0;
-	cur->bc_ag.refc.shape_changes = 0;
+	cur->bc_refc.nr_ops = 0;
+	cur->bc_refc.shape_changes = 0;
 	return cur;
 }
 

