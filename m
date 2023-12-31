Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C888BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GcfgstWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F811C433C8;
	Sun, 31 Dec 2023 21:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057853;
	bh=RNgg9NdRoOBIL7zqGc8JuibypPGkJdQF/1bt85WzwUg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GcfgstWvg+VNE/g0qWuUe+vODWdNQ0OIf5M4hKB+DYdFGMWzF115USANYLIUgHyNz
	 TkwW9USXZyhMi3jPSZDcwM7HBxYABqtMKm1q8U2O8w1aVq/AKUWgBFAmojVhyWDR1Z
	 EaVKYm8IZPO6CKeTF7EsikMK2L6/vdiZEB0eAhBpuekmgjhCpBNRNXfnGs61yY8rHK
	 GsxsIv/ARWJqsxM77pUvyrsfpjlwD3n8rvA3H7GcReVJRTBWIB7b8f3yD4eRqhh0tk
	 pnl6LyCeg20yL1UET+mZeQpf2gQJDfNYTHv1u5yL4ON/6x4YkD5PdC+3b3+7b/3qbM
	 /mzf16bX4XgDg==
Date: Sun, 31 Dec 2023 13:24:13 -0800
Subject: [PATCH 08/14] xfs: standardize the btree maxrecs function parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404847495.1763835.6401942364499065695.stgit@frogsfrogsfrogs>
In-Reply-To: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
References: <170404847334.1763835.8921217007526026461.stgit@frogsfrogsfrogs>
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

Standardize the parameters in xfs_{alloc,bm,ino,rmap,refcount}bt_maxrecs
so that we have consistent calling conventions.  This doesn't affect the
kernel that much, but enables us to clean up userspace a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +++---
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 ++-
 fs/xfs/libxfs/xfs_bmap.c           |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.h     |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.c         |    4 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c     |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++--
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    9 +++++----
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
 fs/xfs/libxfs/xfs_sb.c             |   16 ++++++++--------
 14 files changed, 40 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index fd769e62cc35b..928680b182761 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -611,11 +611,11 @@ xfs_allocbt_block_maxrecs(
 /*
  * Calculate number of records in an alloc btree block.
  */
-int
+unsigned int
 xfs_allocbt_maxrecs(
 	struct xfs_mount	*mp,
-	int			blocklen,
-	int			leaf)
+	unsigned int		blocklen,
+	bool			leaf)
 {
 	blocklen -= XFS_ALLOC_BLOCK_LEN(mp);
 	return xfs_allocbt_block_maxrecs(blocklen, leaf);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 45df893ef6bb0..f61f51d0bd76d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -53,7 +53,8 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
 struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
-extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_allocbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index bfc93cf0bd470..2bc0b76bcfbbb 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -566,7 +566,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false) == 1);
 
 	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1bdb942c87e22..27b11d496f809 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -666,11 +666,11 @@ xfs_bmbt_commit_staged_btree(
 /*
  * Calculate number of records in a bmap btree block.
  */
-int
+unsigned int
 xfs_bmbt_maxrecs(
 	struct xfs_mount	*mp,
-	int			blocklen,
-	int			leaf)
+	unsigned int		blocklen,
+	bool			leaf)
 {
 	blocklen -= xfs_bmbt_block_len(mp);
 	return xfs_bmbt_block_maxrecs(blocklen, leaf);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 5a3bae94debd4..a9ddc9b42e614 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -35,7 +35,8 @@ extern void xfs_bmbt_to_bmdr(struct xfs_mount *, struct xfs_btree_block *, int,
 
 extern int xfs_bmbt_get_maxrecs(struct xfs_btree_cur *, int level);
 extern int xfs_bmdr_maxrecs(int blocklen, int leaf);
-extern int xfs_bmbt_maxrecs(struct xfs_mount *, int blocklen, int leaf);
+unsigned int xfs_bmbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 extern int xfs_bmbt_change_owner(struct xfs_trans *tp, struct xfs_inode *ip,
 				 int whichfork, xfs_ino_t new_owner,
@@ -150,7 +151,7 @@ xfs_bmap_broot_ptr_addr(
 	unsigned int		i,
 	unsigned int		sz)
 {
-	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0));
+	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, false));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 96d22f9698a7a..7278392a8f949 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2919,8 +2919,8 @@ xfs_ialloc_setup_geometry(
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, true);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, false);
 	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
 	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index cdb1f99970724..4a220946d99ca 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -559,11 +559,11 @@ xfs_inobt_block_maxrecs(
 /*
  * Calculate number of records in an inobt btree block.
  */
-int
+unsigned int
 xfs_inobt_maxrecs(
 	struct xfs_mount	*mp,
-	int			blocklen,
-	int			leaf)
+	unsigned int		blocklen,
+	bool			leaf)
 {
 	blocklen -= XFS_INOBT_BLOCK_LEN(mp);
 	return xfs_inobt_block_maxrecs(blocklen, leaf);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 3262c3fe5ebee..ed0f619fd3361 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -50,7 +50,8 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
 struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
 		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
-extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 /* ir_holemask to inode allocation bitmap conversion */
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c2de6fbf5d128..ec393840dd945 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -476,7 +476,7 @@ xfs_iroot_realloc(
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 06a2f062b58cb..ce42ecd3e3715 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -434,9 +434,10 @@ xfs_refcountbt_block_maxrecs(
 /*
  * Calculate the number of records in a refcount btree block.
  */
-int
+unsigned int
 xfs_refcountbt_maxrecs(
-	int			blocklen,
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
 	bool			leaf)
 {
 	blocklen -= XFS_REFCOUNT_BLOCK_LEN;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index d66b37259bedb..fe3c20d67790d 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -50,7 +50,8 @@ extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
-extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
+unsigned int xfs_refcountbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 71d32f9fee14d..71887cc23e03f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -589,7 +589,7 @@ xfs_rmapbt_mem_verify(
 	}
 
 	return xfbtree_sblock_verify(bp,
-			xfs_rmapbt_maxrecs(xfo_to_b(1), level == 0));
+			xfs_rmapbt_maxrecs(mp, xfo_to_b(1), level == 0));
 }
 
 static void
@@ -717,10 +717,11 @@ xfs_rmapbt_block_maxrecs(
 /*
  * Calculate number of records in an rmap btree block.
  */
-int
+unsigned int
 xfs_rmapbt_maxrecs(
-	int			blocklen,
-	int			leaf)
+	struct xfs_mount	*mp,
+	unsigned int		blocklen,
+	bool			leaf)
 {
 	blocklen -= XFS_RMAP_BLOCK_LEN;
 	return xfs_rmapbt_block_maxrecs(blocklen, leaf);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index 5d0454fd05299..415fad8dad73e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -48,7 +48,8 @@ struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-int xfs_rmapbt_maxrecs(int blocklen, int leaf);
+unsigned int xfs_rmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 8298334f4ee8d..8178a8e8097ff 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1110,23 +1110,23 @@ xfs_sb_mount_common(
 	mp->m_rgblklog = log2_if_power2(sbp->sb_rgblocks);
 	mp->m_rgblkmask = mask64_if_power2(sbp->sb_rgblocks);
 
-	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_alloc_mxr[0] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_alloc_mxr[1] = xfs_allocbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_alloc_mnr[0] = mp->m_alloc_mxr[0] / 2;
 	mp->m_alloc_mnr[1] = mp->m_alloc_mxr[1] / 2;
 
-	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
-	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
 	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
 
-	mp->m_rmap_mxr[0] = xfs_rmapbt_maxrecs(sbp->sb_blocksize, 1);
-	mp->m_rmap_mxr[1] = xfs_rmapbt_maxrecs(sbp->sb_blocksize, 0);
+	mp->m_rmap_mxr[0] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_rmap_mxr[1] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
-	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, true);
-	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(sbp->sb_blocksize, false);
+	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, true);
+	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize, false);
 	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
 	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
 

