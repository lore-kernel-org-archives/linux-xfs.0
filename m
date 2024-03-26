Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049661D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424175; cv=none; b=ZqFw0gzAeK3lDq0+dP38LxiRKUrysCoSWKY3oxen1zenK+Z6M44LA8+Jyc84n09khhZ6e0sD1asJFQlX/irb/PHnKqrXoaIqGO2uI1ognTYHsHjEMawru0sno/x0jNHtiTKmikNdgL0Ed4mLQv+iyxSYlKTikO2SR+AYT50kLAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424175; c=relaxed/simple;
	bh=CSGtP2tpt+gSDJqSTy3nTZfMmaFrkr+smYWLd5Dq234=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=llumMpMpz+W6Yq8Clcsu3VVfw1YtN/buRwbuaJSDt06FwkwMjHqi6oVhIR9KfoS+CBk9NsxupDKt5ZV9wXu2M1nZVUnTur4j1c8oICAYdXQbQOXvULbUhpnpIGaZPYIq/q5OuAQpaOJQQ/KjQmxRSzWiSBILCVXcCaytAzjUOdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drflp1Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drflp1Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906F3C433C7;
	Tue, 26 Mar 2024 03:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424174;
	bh=CSGtP2tpt+gSDJqSTy3nTZfMmaFrkr+smYWLd5Dq234=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=drflp1ZxIDxKi7DKdgOckl7SgfAm1Hs7FOiwP19sY8prSX8lihhfHOupizmhS9Sbj
	 tRWeRqTmzyEL9pXN6k6cO2w8uyU3r4iKn80uYzoN4nsFeYIbQIhumn1s5novBz3O6l
	 hDoSSv6lQX51ZblFrLS6BR74/V8W+Y6Cf0hlsnbJnk70BHu+nvbyoYsmHCgcq+AeEr
	 6CNjkFkwvRGeXBXyCBb8G6tJPgxWejrLRHjBEedHOzCIIK0aPOof48ZMHfhhQy7NT4
	 IB2AAf2OUpaejY3k32stmv7f/ABBJIbUApoF4vwv/1MzNsKk+qsHNMCbHMpbGlGYSh
	 6s/COXuJHC+6g==
Date: Mon, 25 Mar 2024 20:36:14 -0700
Subject: [PATCH 030/110] xfs: set the btree cursor bc_ops in
 xfs_btree_alloc_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131817.2215168.9683633607667076105.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 056d22c87132cf4968f5e702116439bea9795930

This is a precursor to putting more static data in the btree ops structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_alloc_btree.c    |   11 +++++------
 libxfs/xfs_bmap_btree.c     |    3 +--
 libxfs/xfs_btree.h          |    2 ++
 libxfs/xfs_ialloc_btree.c   |   10 ++++++----
 libxfs/xfs_refcount_btree.c |    4 ++--
 libxfs/xfs_rmap_btree.c     |    3 +--
 6 files changed, 17 insertions(+), 16 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index a472ec6d21a2..16f683e1dc84 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -510,18 +510,17 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_alloc_maxlevels,
-			xfs_allocbt_cur_cache);
-	cur->bc_ag.abt.active = false;
-
 	if (btnum == XFS_BTNUM_CNT) {
-		cur->bc_ops = &xfs_cntbt_ops;
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
+				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
 		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
-		cur->bc_ops = &xfs_bnobt_ops;
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
+				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
+	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 887ba56f3b7b..751ae73c55cc 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -548,11 +548,10 @@ xfs_bmbt_init_common(
 
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 75a0e2c8e115..c053fb934dc7 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -720,6 +720,7 @@ xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
+	const struct xfs_btree_ops *ops,
 	uint8_t			maxlevels,
 	struct kmem_cache	*cache)
 {
@@ -728,6 +729,7 @@ xfs_btree_alloc_cursor(
 	/* BMBT allocations can come through from non-transactional context. */
 	cur = kmem_cache_zalloc(cache,
 			GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
+	cur->bc_ops = ops;
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 593cb1fcc1d9..5ea08cca25b4 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -453,14 +453,16 @@ xfs_inobt_init_common(
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
-			M_IGEO(mp)->inobt_maxlevels, xfs_inobt_cur_cache);
 	if (btnum == XFS_BTNUM_INO) {
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_inobt_ops,
+				M_IGEO(mp)->inobt_maxlevels,
+				xfs_inobt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
-		cur->bc_ops = &xfs_inobt_ops;
 	} else {
+		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_finobt_ops,
+				M_IGEO(mp)->inobt_maxlevels,
+				xfs_inobt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
-		cur->bc_ops = &xfs_finobt_ops;
 	}
 
 	if (xfs_has_crc(mp))
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 9a3c2270c254..561b732b4746 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -352,7 +352,8 @@ xfs_refcountbt_init_common(
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
+			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
+			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -360,7 +361,6 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	return cur;
 }
 
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index e894a22e087c..36231272964b 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -501,11 +501,10 @@ xfs_rmapbt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	/* Overlapping btree; 2 keys per pointer. */
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-	cur->bc_ops = &xfs_rmapbt_ops;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;

