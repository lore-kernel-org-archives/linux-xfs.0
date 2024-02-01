Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309F2B9B3
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816428; cv=none; b=ASGr+RLvtyc00vrMQ9eYxcTXSDJg+pO0HKy9cij4f4Ck6zY7UthKaquxL6eALWBvEWqk76buzUgSYC48gTiOVu4gEYh8WcF9Agx5Jl9Hr+0W28miPAt2awsFEVuI+UvyrzbLP+bU6mknM3FpGAWbmGe50Uv0fmUklcgwwWBTvNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816428; c=relaxed/simple;
	bh=xIQAB2TahPq+gh32CHixkdCMVesx5M7+qLbBBajQYZo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HdBBK60u6Wig8kA68ngFoYxSdbHhhf44recKdzPH/gC20p7vA25nzukto+dHAMjNA8ncLmgESprQg4tEX0AjbuD4gZPUGDke65wRJyW71fsHmj2VRMJZCUdcIyagTLt5yvaHGWMFty8jRQIBqtq/70T8XPPt0T7UpZiDyjGjGSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ld51FKse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ld51FKse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5C1C433F1;
	Thu,  1 Feb 2024 19:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816427;
	bh=xIQAB2TahPq+gh32CHixkdCMVesx5M7+qLbBBajQYZo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ld51FKse/8SFrHVq9S6J4EHFxaxvWS+fAmhjuhnXq/t/txJRH70Pg0L84LO0iKf4V
	 ueKOcYo+cEidn/WQI3y5FK3MMAbu3PMX/mokOC2w8xxKCqDu7r/a2NJ9yFTmOEfIDQ
	 YAEBqkZM/TegqWUxPf+f/Fnl0zVdzPAZBkGdIDf62o8kutU5qlo2Nry1OqirLMsoo7
	 huaEs/941bPdZdFwoPZIocTvvZ/qOIilMHwfWcXX9jctZDcE4gFICCTxHExYNGI7ra
	 ivUybX1QjcJ1fo/ZZWHMRMyKVNBNSqs98Zl4CxzhKMNcmTzzuaBE25svLfoA5ROEnw
	 O33BzhLZN5sdg==
Date: Thu, 01 Feb 2024 11:40:27 -0800
Subject: [PATCH 03/23] xfs: set the btree cursor bc_ops in
 xfs_btree_alloc_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681333984.1604831.11260590291627868917.stgit@frogsfrogsfrogs>
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

From: Darrick J. Wong <djwong@kernel.org>

This is a precursor to putting more static data in the btree ops structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   11 +++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 +--
 fs/xfs/libxfs/xfs_btree.h          |    2 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 ++++++----
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |    3 +--
 6 files changed, 17 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index a7032bf0cd37a..cdcb2358351c6 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -512,18 +512,17 @@ xfs_allocbt_init_common(
 
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
 
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 71f2d50f78238..19414c7118867 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -549,11 +549,10 @@ xfs_bmbt_init_common(
 
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP, &xfs_bmbt_ops,
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_ops = &xfs_bmbt_ops;
 	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
 	if (xfs_has_crc(mp))
 		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index d906324e25c86..63765346a26a0 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -720,12 +720,14 @@ xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
+	const struct xfs_btree_ops *ops,
 	uint8_t			maxlevels,
 	struct kmem_cache	*cache)
 {
 	struct xfs_btree_cur	*cur;
 
 	cur = kmem_cache_zalloc(cache, GFP_NOFS | __GFP_NOFAIL);
+	cur->bc_ops = ops;
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 42a5e1f227a05..8b705cc62d3d3 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -454,14 +454,16 @@ xfs_inobt_init_common(
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f904a92d1b590..1eb164816825f 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -353,7 +353,8 @@ xfs_refcountbt_init_common(
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
-			mp->m_refc_maxlevels, xfs_refcountbt_cur_cache);
+			&xfs_refcountbt_ops, mp->m_refc_maxlevels,
+			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
@@ -361,7 +362,6 @@ xfs_refcountbt_init_common(
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
-	cur->bc_ops = &xfs_refcountbt_ops;
 	return cur;
 }
 
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 43ff2236f6237..370c36921f659 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -503,11 +503,10 @@ xfs_rmapbt_init_common(
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

