Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25E219CC31
	for <linux-xfs@vger.kernel.org>; Mon,  2 Sep 2024 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725302030; cv=none; b=Qfh49iXDZg97skJozD2DnlmEhcs+4ioj6vN0f9a5P17fAout45XDGzIB5EjDUBmlFD9PwlNLrDSNMGAY6eCwcwX/gajqQyfv0u/MegQ9kV0jsHQYAvKPs8aCjqgDwiAnksBNiCGFRtTyAZkEuEDlwLh/UnW7Cn+bw0/L+/sIFHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725302030; c=relaxed/simple;
	bh=NS0IwmMNDirHTfeqtzu2yvjn0ElSJ0IjXzai9YMD0Js=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=betVSnCjeSPtxSOETvh+VpbOOKj3niGAISCBnOpvml9DYuQ7LttOFpKd7LUYEEvJYyC6N+qsxAPeU56Aa92HbCCTbgtt0GyF3fuF64rogU0LbXSQMmPMfbKlb/PQ8/Gi/jyluDvODh/QCSwWt7AneZKovT/hWuhmQlnlQISa9IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AL4kcVb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AL4kcVb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79069C4CEC2;
	Mon,  2 Sep 2024 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725302029;
	bh=NS0IwmMNDirHTfeqtzu2yvjn0ElSJ0IjXzai9YMD0Js=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AL4kcVb49HjjW6bLJgSoBBR7pxMOpT35u8zQV1EHx0nWcauifmFV8QqRB/9+I0IHA
	 NDKXB/fW4lEtSqhbFABOQdFT4mW6Oxgde3hMAW8atP15JlplI05o/23FnOMxAHTD+q
	 ut++Go+6sNK3zjDm/MT4KFQu4KFQ2j/0cfBI9XIVcwEsBioBgZ+67fHPUfDtYilM06
	 4b2JtOvlUMZ6rFkbB2lp3mKeq24gU/twbN+0nY5wGncCKEGD10+qbCkITw75LrFdi+
	 iSVg7iCkmbBy6j3rWDENx25DlyGVzhxq++M1a1hm1ofVVmh5avXu17G6yMf+waptHK
	 PPXw10NvnvwDg==
Date: Mon, 02 Sep 2024 11:33:49 -0700
Subject: [PATCH 2/2] xfs: standardize the btree maxrecs function parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172530108001.3326739.9297034734225872692.stgit@frogsfrogsfrogs>
In-Reply-To: <172530107961.3326739.11577236979175106791.stgit@frogsfrogsfrogs>
References: <172530107961.3326739.11577236979175106791.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +++---
 fs/xfs/libxfs/xfs_alloc_btree.h    |    3 ++-
 fs/xfs/libxfs/xfs_bmap.c           |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    6 +++---
 fs/xfs/libxfs/xfs_bmap_btree.h     |    5 +++--
 fs/xfs/libxfs/xfs_ialloc.c         |    4 ++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 +++---
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    3 ++-
 fs/xfs/libxfs/xfs_inode_fork.c     |    4 ++--
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++--
 fs/xfs/libxfs/xfs_refcount_btree.h |    3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 ++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
 fs/xfs/libxfs/xfs_sb.c             |   16 ++++++++--------
 14 files changed, 40 insertions(+), 33 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 585e98e87ef9..aada676eee51 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -569,11 +569,11 @@ xfs_allocbt_block_maxrecs(
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
index 155b47f231ab..12647f9aaa6d 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -53,7 +53,8 @@ struct xfs_btree_cur *xfs_bnobt_init_cursor(struct xfs_mount *mp,
 struct xfs_btree_cur *xfs_cntbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *bp,
 		struct xfs_perag *pag);
-extern int xfs_allocbt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_allocbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 00cac756c956..28473b6a95cc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -584,7 +584,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false) == 1);
 
 	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 3695b3ad07d4..3464be771f95 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -645,11 +645,11 @@ xfs_bmbt_commit_staged_btree(
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
index d006798d591b..49a3bae3f6ec 100644
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
@@ -151,7 +152,7 @@ xfs_bmap_broot_ptr_addr(
 	unsigned int		i,
 	unsigned int		sz)
 {
-	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, 0));
+	return xfs_bmbt_ptr_addr(mp, bb, i, xfs_bmbt_maxrecs(mp, sz, false));
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index fc70601e8d8e..20bb5ce38134 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2948,8 +2948,8 @@ xfs_ialloc_setup_geometry(
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, true);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, false);
 	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
 	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 797d5b5f7b72..401b42d52af6 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -572,11 +572,11 @@ xfs_inobt_block_maxrecs(
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
index 6472ec1ecbb4..300edf5bc009 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -50,7 +50,8 @@ struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 struct xfs_btree_cur *xfs_finobt_init_cursor(struct xfs_perag *pag,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 /* ir_holemask to inode allocation bitmap conversion */
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 973e027e3d88..1158ca48626b 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -422,7 +422,7 @@ xfs_iroot_realloc(
 		 * location.  The records don't change location because
 		 * they are kept butted up against the btree block header.
 		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
 		new_max = cur_max + rec_diff;
 		new_size = xfs_bmap_broot_space_calc(mp, new_max);
 		ifp->if_broot = krealloc(ifp->if_broot, new_size,
@@ -444,7 +444,7 @@ xfs_iroot_realloc(
 	 * records, just get rid of the root and clear the status bit.
 	 */
 	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	if (new_max > 0)
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index cb3b1d42ae9a..795928d1a66d 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -417,9 +417,10 @@ xfs_refcountbt_block_maxrecs(
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
index 1e0ab25f6c68..beb93bef6a81 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -48,7 +48,8 @@ struct xbtree_afakeroot;
 extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
 		struct xfs_trans *tp, struct xfs_buf *agbp,
 		struct xfs_perag *pag);
-extern int xfs_refcountbt_maxrecs(int blocklen, bool leaf);
+unsigned int xfs_refcountbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_refcountbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 56fd6c4bd8b4..ac2f1f499b76 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -731,10 +731,11 @@ xfs_rmapbt_block_maxrecs(
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
index eb90d89e8086..119b1567cd0e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -47,7 +47,8 @@ struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
 				struct xfs_perag *pag);
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
-int xfs_rmapbt_maxrecs(int blocklen, int leaf);
+unsigned int xfs_rmapbt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a6fa9aedb28b..d95409f3cba6 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1000,23 +1000,23 @@ xfs_sb_mount_common(
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
 

