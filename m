Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C153BCA48
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cU3HcwVs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4278DC433C7;
	Mon,  1 Jan 2024 00:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067393;
	bh=PJ3Ff2hI/ATBxE1sY5LmFIwUOmcSX8/jgcWgSjB8hks=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cU3HcwVsLJim8nkU9fdU+9XAjKQrrX8bK9AMjAadY9Ktq0dv8wGPImLQ5I3hPfZ/o
	 Cm2xd4BxK7bsKLlJWQOsHXQS76epljol/+5k44syWbz+9MehMe2DSShOusMl0UlJ/o
	 gXxK43mcnEfKBKL5VabufKYQnBqi3ax1J/ucDOzBnBqo60UMbC8XW12rLvVmYDF+GD
	 t9zqWCnUNtuDf0MAcvHGF5bTqQaOBzVIM+o2Gyjb6Iav6nmT27i9Lb3wbXAmfFe2z4
	 utpTxC1on/jCe4ADzNeTgsd5SwfJPwMn3q4gVxxmzwWbylgbTIiut99JuJF3bLM7kz
	 g/DQgRcP5kUjg==
Date: Sun, 31 Dec 2023 16:03:12 +9900
Subject: [PATCH 08/14] xfs: standardize the btree maxrecs function parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405013308.1812545.6517298968207740103.stgit@frogsfrogsfrogs>
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

Standardize the parameters in xfs_{alloc,bm,ino,rmap,refcount}bt_maxrecs
so that we have consistent calling conventions.  This doesn't affect the
kernel that much, but enables us to clean up userspace a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/btheight.c               |   18 ++++--------------
 libxfs/xfs_alloc_btree.c    |    6 +++---
 libxfs/xfs_alloc_btree.h    |    3 ++-
 libxfs/xfs_bmap.c           |    2 +-
 libxfs/xfs_bmap_btree.c     |    6 +++---
 libxfs/xfs_bmap_btree.h     |    5 +++--
 libxfs/xfs_ialloc.c         |    4 ++--
 libxfs/xfs_ialloc_btree.c   |    6 +++---
 libxfs/xfs_ialloc_btree.h   |    3 ++-
 libxfs/xfs_inode_fork.c     |    2 +-
 libxfs/xfs_refcount_btree.c |    5 +++--
 libxfs/xfs_refcount_btree.h |    3 ++-
 libxfs/xfs_rmap_btree.c     |    9 +++++----
 libxfs/xfs_rmap_btree.h     |    3 ++-
 libxfs/xfs_sb.c             |   16 ++++++++--------
 repair/phase5.c             |   16 ++++++++--------
 16 files changed, 52 insertions(+), 55 deletions(-)


diff --git a/db/btheight.c b/db/btheight.c
index 0b421ab50a3..6643489c82c 100644
--- a/db/btheight.c
+++ b/db/btheight.c
@@ -12,21 +12,11 @@
 #include "input.h"
 #include "libfrog/convert.h"
 
-static int refc_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
-{
-	return libxfs_refcountbt_maxrecs(blocklen, leaf != 0);
-}
-
-static int rmap_maxrecs(struct xfs_mount *mp, int blocklen, int leaf)
-{
-	return libxfs_rmapbt_maxrecs(blocklen, leaf);
-}
-
 struct btmap {
 	const char	*tag;
 	unsigned int	(*maxlevels)(void);
-	int		(*maxrecs)(struct xfs_mount *mp, int blocklen,
-				   int leaf);
+	unsigned int	(*maxrecs)(struct xfs_mount *mp, unsigned int blocklen,
+				   bool leaf);
 } maps[] = {
 	{
 		.tag		= "bnobt",
@@ -56,12 +46,12 @@ struct btmap {
 	{
 		.tag		= "refcountbt",
 		.maxlevels	= libxfs_refcountbt_maxlevels_ondisk,
-		.maxrecs	= refc_maxrecs,
+		.maxrecs	= libxfs_refcountbt_maxrecs,
 	},
 	{
 		.tag		= "rmapbt",
 		.maxlevels	= libxfs_rmapbt_maxlevels_ondisk,
-		.maxrecs	= rmap_maxrecs,
+		.maxrecs	= libxfs_rmapbt_maxrecs,
 	},
 };
 
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 93faa832e5b..a03a8776c21 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -609,11 +609,11 @@ xfs_allocbt_block_maxrecs(
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
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 45df893ef6b..f61f51d0bd7 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -53,7 +53,8 @@ extern struct xfs_btree_cur *xfs_allocbt_init_cursor(struct xfs_mount *mp,
 struct xfs_btree_cur *xfs_allocbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
-extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_allocbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5935f87833b..7fefbb7d21c 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -560,7 +560,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false) == 1);
 
 	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 1dd8d12af8f..1e7b89e7730 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -664,11 +664,11 @@ xfs_bmbt_commit_staged_btree(
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
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 5a3bae94deb..a9ddc9b42e6 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
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
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 19543f76994..8aae4b79c85 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2914,8 +2914,8 @@ xfs_ialloc_setup_geometry(
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, true);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, false);
 	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
 	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 4275244b15c..80d28d3fea5 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -558,11 +558,11 @@ xfs_inobt_block_maxrecs(
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
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 3262c3fe5eb..ed0f619fd33 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -50,7 +50,8 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_btnum_t btnum);
 struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_perag *pag,
 		struct xbtree_afakeroot *afake, xfs_btnum_t btnum);
-extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 /* ir_holemask to inode allocation bitmap conversion */
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index d070e0524b9..bb66028bff0 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -474,7 +474,7 @@ xfs_iroot_realloc(
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index ab8925051a9..1fbd250c1a8 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -433,9 +433,10 @@ xfs_refcountbt_block_maxrecs(
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
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index d66b37259be..fe3c20d6779 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -50,7 +50,8 @@ extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 struct xfs_btree_cur *xfs_refcountbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
-extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
+unsigned int xfs_refcountbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7342623ed5e..23ea9cd992f 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -587,7 +587,7 @@ xfs_rmapbt_mem_verify(
 	}
 
 	return xfbtree_sblock_verify(bp,
-			xfs_rmapbt_maxrecs(xfo_to_b(1), level == 0));
+			xfs_rmapbt_maxrecs(mp, xfo_to_b(1), level == 0));
 }
 
 static void
@@ -715,10 +715,11 @@ xfs_rmapbt_block_maxrecs(
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
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 5d0454fd052..415fad8dad7 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -48,7 +48,8 @@ struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-int xfs_rmapbt_maxrecs(int blocklen, int leaf);
+unsigned int xfs_rmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index d04a8e15331..aff2ab79f9b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1108,23 +1108,23 @@ xfs_sb_mount_common(
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
 
diff --git a/repair/phase5.c b/repair/phase5.c
index 983f2169228..74594d53a87 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -644,21 +644,21 @@ phase5(xfs_mount_t *mp)
 
 #ifdef XR_BLD_FREE_TRACE
 	fprintf(stderr, "inobt level 1, maxrec = %d, minrec = %d\n",
-		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
-		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, false),
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, false) / 2);
 	fprintf(stderr, "inobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
-		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, true),
+		libxfs_inobt_maxrecs(mp, mp->m_sb.sb_blocksize, true) / 2);
 	fprintf(stderr, "xr inobt level 0 (leaf), maxrec = %d\n",
 		XR_INOBT_BLOCK_MAXRECS(mp, 0));
 	fprintf(stderr, "xr inobt level 1 (int), maxrec = %d\n",
 		XR_INOBT_BLOCK_MAXRECS(mp, 1));
 	fprintf(stderr, "bnobt level 1, maxrec = %d, minrec = %d\n",
-		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0),
-		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 0) / 2);
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, false),
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, false) / 2);
 	fprintf(stderr, "bnobt level 0 (leaf), maxrec = %d, minrec = %d\n",
-		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1),
-		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, 1) / 2);
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, true),
+		libxfs_allocbt_maxrecs(mp, mp->m_sb.sb_blocksize, true) / 2);
 #endif
 	/*
 	 * make sure the root and realtime inodes show up allocated

