Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CD138F82
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734989937; cv=none; b=ba/uHKp3n9IWUiMFIvjGu9ipEa0NKw2Dm3j01XRP1Za9NX3uPvQqAzEpXdBFIFjeK9ITGOlNR2LXX6m7GgWVtMPTWdG6TW0gnrM8kK3XRG9RoCpsTuAOoNTbrUFkguM+Wxzak55tewFe+cevYVr+SciCcai1vSxLdTkPsmSLYj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734989937; c=relaxed/simple;
	bh=xNkBbAkfwwI7O9Y10A696imuvyKJY0Vf40MFhN8OAg0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i4w3AtZ9b59BlqCMT3aDKD4WBi5lnT3GgWLL2EfVe1/XHMKSU2WApLDSBF+FEI9LPvBAuc38umjiYC7RMcfnZRmQ/VYD3Ntqor5yEkoRLNm1S/gQ+M8/qYQfQo6GXm9e1vUvvOQtOJ8qQFq0GVKRIjYdpSrJQjsvyX+GVy9w+L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSbHoHV8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSbHoHV8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6257BC4CED3;
	Mon, 23 Dec 2024 21:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734989937;
	bh=xNkBbAkfwwI7O9Y10A696imuvyKJY0Vf40MFhN8OAg0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MSbHoHV8oZOHi023Nb5+IvjB6lEppbxY/l0mKGf4Ek6m2aAx4zruPYQpj+1S0k8Ks
	 7tSjqZUtCLhufL+dTuZAoDpzdzB4e3VkOO6N6gDvV/RYHGUUx1OTs5Mgrl/fXQQYNl
	 Ix+tJinxVhAxhvugAOC9nTihgHDanBnxKbKMWsealAy1r7z6ncMteXpLdO442qj5TC
	 sJxGB8QAMDvQyM6EJQ+N72PjZEcNr9cclBwwOmSBlJ/AlXmyDGyswo+M/T/usa9KHS
	 4pfj3kUZr2Km8u9FnBwmCFJjwjVAJGUKTJPbdptFPnj9hKvs4M5NyVyJYzfrO4W1cC
	 +pbfKfA/jELPQ==
Date: Mon, 23 Dec 2024 13:38:56 -0800
Subject: [PATCH 07/36] xfs: add xfs_agbno_to_fsb and xfs_agbno_to_daddr
 helpers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498940054.2293042.10537369242149586587.stgit@frogsfrogsfrogs>
In-Reply-To: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
References: <173498939893.2293042.8029858406528247316.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 856a920ac2bbb2352ef6aa9e1e052f2e80677df7

Add helpers to convert an agbno to a daddr or fsbno based on a pag
structure.

This provides a simpler conversion and better type safety compared to the
existing code that passes the mount structure and the agno separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_ag.c             |    2 +-
 libxfs/xfs_ag.h             |   16 ++++++++++++++++
 libxfs/xfs_alloc.c          |   14 ++++++--------
 libxfs/xfs_btree.c          |    7 +++----
 libxfs/xfs_ialloc.c         |   29 +++++++++++++----------------
 libxfs/xfs_ialloc_btree.c   |    2 +-
 libxfs/xfs_refcount.c       |   11 ++++-------
 libxfs/xfs_refcount_btree.c |    3 +--
 8 files changed, 45 insertions(+), 39 deletions(-)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 62fc21fe7109b9..a6b5a7d71bbf80 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -867,7 +867,7 @@ xfs_ag_shrink_space(
 
 	/* internal log shouldn't also show up in the free space btrees */
 	error = xfs_alloc_vextent_exact_bno(&args,
-			XFS_AGB_TO_FSB(mp, pag->pag_agno, aglen - delta));
+			xfs_agbno_to_fsb(pag, aglen - delta));
 	if (!error && args.agbno == NULLAGBLOCK)
 		error = -ENOSPC;
 
diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 958ca82524292f..c0a30141ddc330 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -330,4 +330,20 @@ int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
 
+static inline xfs_fsblock_t
+xfs_agbno_to_fsb(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno)
+{
+	return XFS_AGB_TO_FSB(pag->pag_mount, pag->pag_agno, agbno);
+}
+
+static inline xfs_daddr_t
+xfs_agbno_to_daddr(
+	struct xfs_perag	*pag,
+	xfs_agblock_t		agbno)
+{
+	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
+}
+
 #endif /* __LIBXFS_AG_H */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 1f4740cced73a1..19b38eaf45dd07 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -1255,7 +1255,7 @@ xfs_alloc_ag_vextent_small(
 		struct xfs_buf	*bp;
 
 		error = xfs_trans_get_buf(args->tp, args->mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(args->mp, args->agno, fbno),
+				xfs_agbno_to_daddr(args->pag, fbno),
 				args->mp->m_bsize, 0, &bp);
 		if (error)
 			goto error;
@@ -2929,9 +2929,8 @@ xfs_alloc_fix_freelist(
 		 * Deferring the free disconnects freeing up the AGFL slot from
 		 * freeing the block.
 		 */
-		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, args->agno, bno), 1,
-				&targs.oinfo, XFS_AG_RESV_AGFL, 0);
+		error = xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, bno),
+				1, &targs.oinfo, XFS_AG_RESV_AGFL, 0);
 		if (error)
 			goto out_agbp_relse;
 	}
@@ -3590,7 +3589,7 @@ xfs_alloc_vextent_finish(
 		goto out_drop_perag;
 	}
 
-	args->fsbno = XFS_AGB_TO_FSB(mp, args->agno, args->agbno);
+	args->fsbno = xfs_agbno_to_fsb(args->pag, args->agbno);
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
@@ -3642,7 +3641,6 @@ xfs_alloc_vextent_this_ag(
 	struct xfs_alloc_arg	*args,
 	xfs_agnumber_t		agno)
 {
-	struct xfs_mount	*mp = args->mp;
 	xfs_agnumber_t		minimum_agno;
 	uint32_t		alloc_flags = 0;
 	int			error;
@@ -3655,8 +3653,8 @@ xfs_alloc_vextent_this_ag(
 
 	trace_xfs_alloc_vextent_this_ag(args);
 
-	error = xfs_alloc_vextent_check_args(args, XFS_AGB_TO_FSB(mp, agno, 0),
-			&minimum_agno);
+	error = xfs_alloc_vextent_check_args(args,
+			xfs_agbno_to_fsb(args->pag, 0), &minimum_agno);
 	if (error) {
 		if (error == -ENOSPC)
 			return 0;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index bb53b6d7af22f6..4f04a92f6513bf 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1015,21 +1015,20 @@ xfs_btree_readahead_agblock(
 	struct xfs_btree_block	*block)
 {
 	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_agnumber_t		agno = cur->bc_ag.pag->pag_agno;
 	xfs_agblock_t		left = be32_to_cpu(block->bb_u.s.bb_leftsib);
 	xfs_agblock_t		right = be32_to_cpu(block->bb_u.s.bb_rightsib);
 	int			rval = 0;
 
 	if ((lr & XFS_BTCUR_LEFTRA) && left != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, left),
+				xfs_agbno_to_daddr(cur->bc_ag.pag, left),
 				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
 
 	if ((lr & XFS_BTCUR_RIGHTRA) && right != NULLAGBLOCK) {
 		xfs_buf_readahead(mp->m_ddev_targp,
-				XFS_AGB_TO_DADDR(mp, agno, right),
+				xfs_agbno_to_daddr(cur->bc_ag.pag, right),
 				mp->m_bsize, cur->bc_ops->buf_ops);
 		rval++;
 	}
@@ -1089,7 +1088,7 @@ xfs_btree_ptr_to_daddr(
 
 	switch (cur->bc_ops->type) {
 	case XFS_BTREE_TYPE_AG:
-		*daddr = XFS_AGB_TO_DADDR(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+		*daddr = xfs_agbno_to_daddr(cur->bc_ag.pag,
 				be32_to_cpu(ptr->s));
 		break;
 	case XFS_BTREE_TYPE_INODE:
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 10d88eb0b5bc32..6694ee2370411a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -763,8 +763,7 @@ xfs_ialloc_ag_alloc(
 		/* Allow space for the inode btree to split. */
 		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_exact_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						args.agbno));
+				xfs_agbno_to_fsb(pag, args.agbno));
 		if (error)
 			return error;
 
@@ -806,8 +805,8 @@ xfs_ialloc_ag_alloc(
 		 */
 		args.minleft = igeo->inobt_maxlevels;
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -819,8 +818,8 @@ xfs_ialloc_ag_alloc(
 	if (isaligned && args.fsbno == NULLFSBLOCK) {
 		args.alignment = igeo->cluster_align;
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 	}
@@ -855,8 +854,8 @@ xfs_ialloc_ag_alloc(
 				 igeo->ialloc_blks;
 
 		error = xfs_alloc_vextent_near_bno(&args,
-				XFS_AGB_TO_FSB(args.mp, pag->pag_agno,
-						be32_to_cpu(agi->agi_root)));
+				xfs_agbno_to_fsb(pag,
+					be32_to_cpu(agi->agi_root)));
 		if (error)
 			return error;
 
@@ -1973,7 +1972,6 @@ xfs_difree_inode_chunk(
 	struct xfs_inobt_rec_incore	*rec)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_agnumber_t			agno = pag->pag_agno;
 	xfs_agblock_t			sagbno = XFS_AGINO_TO_AGBNO(mp,
 							rec->ir_startino);
 	int				startidx, endidx;
@@ -1984,8 +1982,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		return xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, sagbno),
+		return xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, sagbno),
 				M_IGEO(mp)->ialloc_blks, &XFS_RMAP_OINFO_INODES,
 				XFS_AG_RESV_NONE, 0);
 	}
@@ -2031,9 +2028,9 @@ xfs_difree_inode_chunk(
 
 		ASSERT(agbno % mp->m_sb.sb_spino_align == 0);
 		ASSERT(contigblk % mp->m_sb.sb_spino_align == 0);
-		error = xfs_free_extent_later(tp,
-				XFS_AGB_TO_FSB(mp, agno, agbno), contigblk,
-				&XFS_RMAP_OINFO_INODES, XFS_AG_RESV_NONE, 0);
+		error = xfs_free_extent_later(tp, xfs_agbno_to_fsb(pag, agbno),
+				contigblk, &XFS_RMAP_OINFO_INODES,
+				XFS_AG_RESV_NONE, 0);
 		if (error)
 			return error;
 
@@ -2503,7 +2500,7 @@ xfs_imap(
 		offset = XFS_INO_TO_OFFSET(mp, ino);
 		ASSERT(offset < mp->m_sb.sb_inopblock);
 
-		imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, agbno);
+		imap->im_blkno = xfs_agbno_to_daddr(pag, agbno);
 		imap->im_len = XFS_FSB_TO_BB(mp, 1);
 		imap->im_boffset = (unsigned short)(offset <<
 							mp->m_sb.sb_inodelog);
@@ -2533,7 +2530,7 @@ xfs_imap(
 	offset = ((agbno - cluster_agbno) * mp->m_sb.sb_inopblock) +
 		XFS_INO_TO_OFFSET(mp, ino);
 
-	imap->im_blkno = XFS_AGB_TO_DADDR(mp, pag->pag_agno, cluster_agbno);
+	imap->im_blkno = xfs_agbno_to_daddr(pag, cluster_agbno);
 	imap->im_len = XFS_FSB_TO_BB(mp, M_IGEO(mp)->blocks_per_cluster);
 	imap->im_boffset = (unsigned short)(offset << mp->m_sb.sb_inodelog);
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index ffca4a80219d6d..f80368b4d5fa5f 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -119,7 +119,7 @@ __xfs_inobt_alloc_block(
 	args.resv = resv;
 
 	error = xfs_alloc_vextent_near_bno(&args,
-			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno, sbno));
+			xfs_agbno_to_fsb(args.pag, sbno));
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 22f8afb27ece1c..eeddec68a08539 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -1153,8 +1153,7 @@ xfs_refcount_adjust_extents(
 					goto out_error;
 				}
 			} else {
-				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-						cur->bc_ag.pag->pag_agno,
+				fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
 						tmp.rc_startblock);
 				error = xfs_free_extent_later(cur->bc_tp, fsbno,
 						  tmp.rc_blockcount, NULL,
@@ -1216,8 +1215,7 @@ xfs_refcount_adjust_extents(
 			}
 			goto advloop;
 		} else {
-			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno,
+			fsbno = xfs_agbno_to_fsb(cur->bc_ag.pag,
 					ext.rc_startblock);
 			error = xfs_free_extent_later(cur->bc_tp, fsbno,
 					ext.rc_blockcount, NULL,
@@ -1319,7 +1317,7 @@ xfs_refcount_continue_op(
 		return -EFSCORRUPTED;
 	}
 
-	ri->ri_startblock = XFS_AGB_TO_FSB(mp, pag->pag_agno, new_agbno);
+	ri->ri_startblock = xfs_agbno_to_fsb(pag, new_agbno);
 
 	ASSERT(xfs_verify_fsbext(mp, ri->ri_startblock, ri->ri_blockcount));
 	ASSERT(pag->pag_agno == XFS_FSB_TO_AGNO(mp, ri->ri_startblock));
@@ -1955,8 +1953,7 @@ xfs_refcount_recover_cow_leftovers(
 			goto out_free;
 
 		/* Free the orphan record */
-		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
-				rr->rr_rrec.rc_startblock);
+		fsb = xfs_agbno_to_fsb(pag, rr->rr_rrec.rc_startblock);
 		xfs_refcount_free_cow_extent(tp, fsb,
 				rr->rr_rrec.rc_blockcount);
 
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 9028dea06b0c07..5913f4176889ea 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -73,8 +73,7 @@ xfs_refcountbt_alloc_block(
 	args.resv = XFS_AG_RESV_METADATA;
 
 	error = xfs_alloc_vextent_near_bno(&args,
-			XFS_AGB_TO_FSB(args.mp, args.pag->pag_agno,
-					xfs_refc_block(args.mp)));
+			xfs_agbno_to_fsb(args.pag, xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
 	if (args.fsbno == NULLFSBLOCK) {

