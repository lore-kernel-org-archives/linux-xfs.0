Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9993ABA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DSBzfKn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66854C433C8;
	Sun, 31 Dec 2023 20:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053833;
	bh=FYnirEIvbUg3rreIzKy0Q4N4vSw5Qo7JERHsIJlI2v4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DSBzfKn0OmnSUqeRFVLYIARRFH9lpelB6e4iGY9EiFX9FBletkAYR0wmdnLHsIyw/
	 y+u2xkYgtFf8T8YkX0l/eQopEv2V5tMGSg5xdjr65V6yHAGXo45P7pwmVpuBkTgn4E
	 LStrQDf2YI9KwQUws+hRCVMcUT0Yi8ki6+2omINzFizVGVjpLogRVeU8xJnyW7jB1c
	 cNAT5YmhTN81ZbK4JtagMcYktp5zjiUWWQeYNaIo7dpSq6Wz6WduYYB9rvbHxJm1if
	 59cXdepmo55u+u5u1/2gCN64Hn+QJqnfaaVBcT8BEi1PDnkHGbmGk/iCecvbozAInd
	 pMIlEYrCBj2nQ==
Date: Sun, 31 Dec 2023 12:17:12 -0800
Subject: [PATCH 1/9] xfs: set the btree cursor bc_ops in
 xfs_btree_alloc_cursor
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404830527.1749286.13289496123261254387.stgit@frogsfrogsfrogs>
In-Reply-To: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
References: <170404830490.1749286.17145905891935561298.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |   11 +++++------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 +--
 fs/xfs/libxfs/xfs_btree.h          |    2 ++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   10 ++++++----
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 +++----
 fs/xfs/scrub/xfbtree.c             |    4 ++--
 7 files changed, 21 insertions(+), 20 deletions(-)


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
index 3e6bdbc507039..ed1388890315b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -737,12 +737,14 @@ xfs_btree_alloc_cursor(
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
index e29ae6d0f79d4..e0c60ee5b59db 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -517,11 +517,10 @@ xfs_rmapbt_init_common(
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
@@ -646,11 +645,11 @@ xfs_rmapbt_mem_cursor(
 
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
-			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
+			&xfs_rmapbt_mem_ops, mp->m_rmap_maxlevels,
+			xfs_rmapbt_cur_cache);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
 			XFS_BTREE_IN_XFILE;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
-	cur->bc_ops = &xfs_rmapbt_mem_ops;
 	cur->bc_mem.xfbtree = xfbtree;
 	cur->bc_mem.head_bp = head_bp;
 	cur->bc_nlevels = xfs_btree_mem_head_nlevels(head_bp);
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 8879b54068a75..c5ef0ea8cad22 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -289,11 +289,11 @@ xfbtree_dup_cursor(
 	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
 
 	ncur = xfs_btree_alloc_cursor(cur->bc_mp, cur->bc_tp, cur->bc_btnum,
-			cur->bc_maxlevels, cur->bc_cache);
+			cur->bc_ops, cur->bc_maxlevels, cur->bc_cache);
 	ncur->bc_flags = cur->bc_flags;
 	ncur->bc_nlevels = cur->bc_nlevels;
 	ncur->bc_statoff = cur->bc_statoff;
-	ncur->bc_ops = cur->bc_ops;
+
 	memcpy(&ncur->bc_mem, &cur->bc_mem, sizeof(cur->bc_mem));
 
 	if (cur->bc_mem.pag)

