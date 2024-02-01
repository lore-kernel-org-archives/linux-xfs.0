Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B378A12FB04
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816646; cv=none; b=sLMqEZIrdSzPHFppK+wCUtc2pP3xYXqhOhWP76+NYj5EEePnM7CrkFGWioWma+imbeTGimfQhr5+j/3VE9jF+qQD8teQd9fKomxJIitrmDW2avB+7XfPWTjVLNqnj3rGcF6t1p3nN3P8PcezHq27EgSEUT/1gjHruapHGxysazQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816646; c=relaxed/simple;
	bh=XgQMp7MV2mOqS2aovxL0iHYfeVOO2G2lbB0dT+4TxgQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iL7787lRIeg4pnE5HiRr8VRQAqkSr0dVHQuUxGVYRSoBEno2/tl+kaXiyods9C3WKK20/jzkF1hZxAUCGucR9kC1uqS4a6vTWojB0bO3p6NEYNW/uymyfmgXrG8VqYgVWuO89z92m133yc/dTto4SurPCjMJRzw13QUgpJLzHxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txmWSWb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txmWSWb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8354CC433F1;
	Thu,  1 Feb 2024 19:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816646;
	bh=XgQMp7MV2mOqS2aovxL0iHYfeVOO2G2lbB0dT+4TxgQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=txmWSWb6ZG32men8t8SFtwOFDvb2mk7Dib4b/edRipk/nxWOAJ5mGbqxijrHBWCoE
	 awLaVfXuwnIo7wZsOG9z0zuXGr0/VU+rj85FiHSx0jUeKEaSXb284bPfFGslrJaCCM
	 BevnVTR1o/oC+xlDIE7N4/fWGftPiLTwejuDjrGaBbksFc/4UKtKmTshPdv0mES4iZ
	 FpOQ1NoDlr0DNky5KBCaLBZw2Q5qml6cmQHBHKXS7W4/TR55sgfrqObctAO0r3S3wu
	 xdUGavCxZGTaLZ9nid0mi3JSvlxRNU0M+22F5adI+n/ZmRQqM3yea1GPfp9u3mQtuF
	 g6hpa5EhuQkow==
Date: Thu, 01 Feb 2024 11:44:06 -0800
Subject: [PATCH 17/23] xfs: move the btree stats offset into struct btree_ops
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681334217.1604831.8814522677527632414.stgit@frogsfrogsfrogs>
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

The statistics offset is completely static, move it into the btree_ops
structure instead of the cursor.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   17 +++++++----------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_btree.h          |   10 +++++++---
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   20 +++++++++-----------
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 +--
 fs/xfs/libxfs/xfs_rmap_btree.c     |    3 +--
 6 files changed, 26 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 045c7954ef1b1..85ac0ba3c1f1b 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -459,6 +459,7 @@ const struct xfs_btree_ops xfs_bnobt_ops = {
 	.key_len		= sizeof(xfs_alloc_key_t),
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_abtb_2),
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -486,6 +487,7 @@ const struct xfs_btree_ops xfs_cntbt_ops = {
 	.key_len		= sizeof(xfs_alloc_key_t),
 
 	.lru_refs		= XFS_ALLOC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_abtc_2),
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -514,22 +516,17 @@ xfs_allocbt_init_common(
 	struct xfs_perag	*pag,
 	xfs_btnum_t		btnum)
 {
+	const struct xfs_btree_ops *ops = &xfs_bnobt_ops;
 	struct xfs_btree_cur	*cur;
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	if (btnum == XFS_BTNUM_CNT) {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
-				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-	} else {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
-				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
-	}
+	if (btnum == XFS_BTNUM_CNT)
+		ops = &xfs_cntbt_ops;
 
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops, mp->m_alloc_maxlevels,
+			xfs_allocbt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 43dc9fa6b26f9..2d7a8a852596a 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -531,6 +531,7 @@ const struct xfs_btree_ops xfs_bmbt_ops = {
 	.key_len		= sizeof(xfs_bmbt_key_t),
 
 	.lru_refs		= XFS_BMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_bmbt_2),
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
@@ -564,7 +565,6 @@ xfs_bmbt_init_common(
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 892d1b9b5b1e9..c26321b460d39 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -87,9 +87,11 @@ uint32_t xfs_btree_magic(struct xfs_mount *mp, const struct xfs_btree_ops *ops);
  * Generic stats interface
  */
 #define XFS_BTREE_STATS_INC(cur, stat)	\
-	XFS_STATS_INC_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat)
+	XFS_STATS_INC_OFF((cur)->bc_mp, \
+		(cur)->bc_ops->statoff + __XBTS_ ## stat)
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
-	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
+	XFS_STATS_ADD_OFF((cur)->bc_mp, \
+		(cur)->bc_ops->statoff + __XBTS_ ## stat, val)
 
 enum xbtree_key_contig {
 	XBTREE_KEY_GAP = 0,
@@ -123,6 +125,9 @@ struct xfs_btree_ops {
 	/* LRU refcount to set on each btree buffer created */
 	unsigned int		lru_refs;
 
+	/* offset of btree stats array */
+	unsigned int		statoff;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -280,7 +285,6 @@ struct xfs_btree_cur
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
 	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
-	int			bc_statoff; /* offset of btree stats array */
 
 	/*
 	 * Short btree pointers need an agno to be able to turn the pointers
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index a2a8c15a6c9e7..8ac7896501067 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -403,6 +403,7 @@ const struct xfs_btree_ops xfs_inobt_ops = {
 	.key_len		= sizeof(xfs_inobt_key_t),
 
 	.lru_refs		= XFS_INO_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_ibt_2),
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_inobt_set_root,
@@ -427,6 +428,7 @@ const struct xfs_btree_ops xfs_finobt_ops = {
 	.key_len		= sizeof(xfs_inobt_key_t),
 
 	.lru_refs		= XFS_INO_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_fibt_2),
 
 	.dup_cursor		= xfs_inobt_dup_cursor,
 	.set_root		= xfs_finobt_set_root,
@@ -456,20 +458,16 @@ xfs_inobt_init_common(
 	xfs_btnum_t		btnum)		/* ialloc or free ino btree */
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	const struct xfs_btree_ops *ops = &xfs_inobt_ops;
 	struct xfs_btree_cur	*cur;
 
-	if (btnum == XFS_BTNUM_INO) {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_inobt_ops,
-				M_IGEO(mp)->inobt_maxlevels,
-				xfs_inobt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
-	} else {
-		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_finobt_ops,
-				M_IGEO(mp)->inobt_maxlevels,
-				xfs_inobt_cur_cache);
-		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
-	}
+	ASSERT(btnum == XFS_BTNUM_INO || btnum == XFS_BTNUM_FINO);
 
+	if (btnum == XFS_BTNUM_FINO)
+		ops = &xfs_finobt_ops;
+
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, ops,
+			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index eaed9517e7956..b12b1ccd1f27c 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -322,6 +322,7 @@ const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.key_len		= sizeof(struct xfs_refcount_key),
 
 	.lru_refs		= XFS_REFC_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_refcbt_2),
 
 	.dup_cursor		= xfs_refcountbt_dup_cursor,
 	.set_root		= xfs_refcountbt_set_root,
@@ -357,8 +358,6 @@ xfs_refcountbt_init_common(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
 			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
 			xfs_refcountbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 8abe90c25f71f..e0ae6da94fc3e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -479,6 +479,7 @@ const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
 
 	.lru_refs		= XFS_RMAP_BTREE_REF,
+	.statoff		= XFS_STATS_CALC_INDEX(xs_rmap_2),
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
@@ -509,8 +510,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }

