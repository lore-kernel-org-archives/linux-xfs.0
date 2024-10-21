Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0519E2CA9
	for <linux-xfs@vger.kernel.org>; Mon, 21 Oct 2024 22:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729548281; cv=none; b=R1hmO3f46T7mH87U4po5mWWgdomCRDyVOcXPnHlcbodNXFiq58fQiOiRybE0N5QkHWf80pooZYMVnoYOK4YXzo4nXoEffibDoKcdvxJUDP/j0I1KmASDuM8g6liuLsRvxUCtO9LF/xNWJEwNlnIkznaRRq3H86MH2z4QELWOjMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729548281; c=relaxed/simple;
	bh=EkPPmN6EQjA2v34CdC404WfKpOHTXHLekHSl+Wu3CPg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ur/VMFuKX1rvBrGfzfV3yXtxFpRELKvE4e8tjrLOlqh1DONAMz3yequ2muvV2yberjXxZY1t4HSTC4baxe17cbOaY3EJm89+I6q4jbCmoadeGVXPg9VJ3gQjH6xkNfoXZF474qGehTmvQdyu/JT6bYw7E5pw6vJ0vXAodCk2tK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D9aj0GD/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D9aj0GD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89CC8C4CEC3;
	Mon, 21 Oct 2024 22:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729548280;
	bh=EkPPmN6EQjA2v34CdC404WfKpOHTXHLekHSl+Wu3CPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=D9aj0GD/AZYPUpjxif51YCkIJ9sVMkhgTSBDAe44ptJf8R23aG1c3fADDgz2Laf4W
	 SxYE8Jtu53bJ9nG7SCJ4r76Lw6vs8Q31WZD96trKpgjlr1MTgEmQVqwGIVqjJp+Rx8
	 IEiRU6asj7NS2D97qa5r9pUv5ZBBI1XtZ9bRoXS+Ippav01/gz84TMBAjnNNbMJf3D
	 RLb5QKRKpV+ogTS4yDX53uTPfyvKh+O9hqda8Zs9kq/JyUTWP94tRM+DHxpePsVpQK
	 cYbE5VKLcxA1LYU1AUsDdroTQmn1gqXUjwMqpoC02mHFD+rt3ERcgFLeUTZ3G7qI5T
	 EUqQidt2L2XSg==
Date: Mon, 21 Oct 2024 15:04:40 -0700
Subject: [PATCH 22/37] xfs: standardize the btree maxrecs function parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172954783804.34558.513117039396977201.stgit@frogsfrogsfrogs>
In-Reply-To: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
References: <172954783428.34558.6301509765231998083.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 411a71256de6f5a0015a28929cfbe6bc36c503dc

Standardize the parameters in xfs_{alloc,bm,ino,rmap,refcount}bt_maxrecs
so that we have consistent calling conventions.  This doesn't affect the
kernel that much, but enables us to clean up userspace a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
 libxfs/xfs_inode_fork.c     |    4 ++--
 libxfs/xfs_refcount_btree.c |    5 +++--
 libxfs/xfs_refcount_btree.h |    3 ++-
 libxfs/xfs_rmap_btree.c     |    7 ++++---
 libxfs/xfs_rmap_btree.h     |    3 ++-
 libxfs/xfs_sb.c             |   16 ++++++++--------
 repair/phase5.c             |   16 ++++++++--------
 16 files changed, 52 insertions(+), 55 deletions(-)


diff --git a/db/btheight.c b/db/btheight.c
index 0b421ab50a3a76..6643489c82c4c9 100644
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
index 9140dec00645f0..4a711f2463cd30 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -567,11 +567,11 @@ xfs_allocbt_block_maxrecs(
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
index 155b47f231ab2f..12647f9aaa6d79 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -53,7 +53,8 @@ struct xfs_btree_cur *xfs_bnobt_init_cursor(struct xfs_mount *mp,
 struct xfs_btree_cur *xfs_cntbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_perag *pag);
-extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_allocbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index a85a75da954c4e..4ee8d9b07a0ca7 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -578,7 +578,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false) == 1);
 
 	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index cac644c8ce35a5..62e79d8fc49784 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -644,11 +644,11 @@ xfs_bmbt_commit_staged_btree(
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
index d006798d591bc2..49a3bae3f6ecec 100644
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
@@ -151,7 +152,7 @@ xfs_bmap_broot_ptr_addr(
 	unsigned int		i,
 	unsigned int		sz)
 {
-	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0));
+	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, false));
 }
 
 /*
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 83e3d7d7c5a1b3..141b2d397b1fe7 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2943,8 +2943,8 @@ xfs_ialloc_setup_geometry(
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, true);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, false);
 	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
 	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 489c080fb22d05..ffca4a80219d6d 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -571,11 +571,11 @@ xfs_inobt_block_maxrecs(
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
index 6472ec1ecbb458..300edf5bc00949 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -50,7 +50,8 @@ struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 struct xfs_btree_cur *xfs_finobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 /* ir_holemask to inode allocation bitmap conversion */
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
diff --git a/libxfs/xfs_inode_fork.c b/libxfs/xfs_inode_fork.c
index fd79da64e43a8d..a71a5e98bf408b 100644
--- a/libxfs/xfs_inode_fork.c
+++ b/libxfs/xfs_inode_fork.c
@@ -420,7 +420,7 @@ xfs_iroot_realloc(
 		 * location.  The records don't change location because
 		 * they are kept butted up against the btree block header.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
@@ -442,7 +442,7 @@ xfs_iroot_realloc(
 	 * records, just get rid of the root and clear the status bit.
 	 */
 	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 162f9e6896a590..9028dea06b0c07 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -416,9 +416,10 @@ xfs_refcountbt_block_maxrecs(
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
index 1e0ab25f6c6808..beb93bef6a8141 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -48,7 +48,8 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag);
-extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
+unsigned int xfs_refcountbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index f1732b72d13db1..ada58e92645020 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -730,10 +730,11 @@ xfs_rmapbt_block_maxrecs(
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
index eb90d89e808666..119b1567cd0ee8 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -47,7 +47,8 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-int xfs_rmapbt_maxrecs(int blocklen, int leaf);
+unsigned int xfs_rmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 5f7ff4fa4e49b1..0603e5087f2e46 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -997,23 +997,23 @@ xfs_sb_mount_common(
 	mp->m_blockwmask = mp->m_blockwsize - 1;
 	xfs_mount_sb_set_rextsize(mp, sbp);
 
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
index 52666ad8823312..d18ec095b0524b 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -641,21 +641,21 @@ phase5(xfs_mount_t *mp)
 
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

