Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74D1442E8
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 23:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724801780; cv=none; b=j2nX5lW85myerga/bzJj+3SUPn+WDl4cFzCWv+R5nFo90NxpqLh0KlfBcetldAAsuV84NgfmbcctHCuw9h43khTn8fo16c3q+Ta1PsoyZIUZZhIl6f5jcsQ4i7V4pIAQZUDJW994QpWF1KUxMNUkt3rSimI3xCw7PEH4dPGNzK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724801780; c=relaxed/simple;
	bh=7vjVwIftBxdrigt0s5BBUPk1KH/1L3edbODt/VKy3KA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dg5J+pnApKHLOvumuBrSurZRzS+YYVxPAue3lLHN4iCFjSUDHyxEpAAXW3aKeVuz1pdv5QW9LrbqBU4jHK77FRNsnXayBU7l/BqkF0JvpeAdEPQRk6ddW15CNU6AnJztX6zFemNhIgut/G9qFRy+ealN4ZkJKBEmgyUmK7OWlgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=in2RubrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="in2RubrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B34C3C5677C;
	Tue, 27 Aug 2024 23:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724801780;
	bh=7vjVwIftBxdrigt0s5BBUPk1KH/1L3edbODt/VKy3KA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=in2RubrEoYzSEVb1d0L9ZWEr5D+IgRZKyAGR/4Kv65WsuxnaftLfGNbLGtbZI2/Jc
	 Mu5Qe81qosPQcpPg+gKB8ELBE3m7o8yzV2tUmEO0rf158H5bl1falk8grsLzUMsK0U
	 Nbt1H3hlxp6AlikUp0pTryhbGKKXKrqxvP8Ei7AmDCeyCWPdeLmzVyeYxSYO9G5V2s
	 OdAMKUPR3Pskboiml5BzditPSxEywhXrvGIEgUDGURJn/QMtzTn73Ova/ZaeO34loq
	 mWfQU+1DAhBzfe66OLIdGVd/xi983xiMWX0/tAUR7LdNeCR50IbNZVqSo+dfa+v4Lv
	 uHOBzajqaxO8w==
Date: Tue, 27 Aug 2024 16:36:20 -0700
Subject: [PATCH 10/10] xfs: standardize the btree maxrecs function parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172480131678.2291268.7444633174884927311.stgit@frogsfrogsfrogs>
In-Reply-To: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
References: <172480131476.2291268.1290356315337515850.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_rmap_btree.c     |    7 ++++---
 fs/xfs/libxfs/xfs_rmap_btree.h     |    3 ++-
 fs/xfs/libxfs/xfs_sb.c             |   16 ++++++++--------
 14 files changed, 39 insertions(+), 32 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 585e98e87ef9e..aada676eee519 100644
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
index 155b47f231ab2..12647f9aaa6d7 100644
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
index e3922cf75381c..37a1a1339027c 100644
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
index 0769644d30412..b811fb38a839a 100644
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
index a187f4b120ea1..df6a60452260e 100644
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
index fc70601e8d8ee..20bb5ce381345 100644
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
index 797d5b5f7b725..401b42d52af68 100644
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
index 6472ec1ecbb45..300edf5bc0094 100644
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
index 306106b78d088..847fbfdd87f8c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -480,7 +480,7 @@ xfs_iroot_realloc(
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index cb3b1d42ae9a8..795928d1a66d8 100644
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
index 1e0ab25f6c680..beb93bef6a814 100644
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
index 56fd6c4bd8b41..ac2f1f499b76f 100644
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
index eb90d89e80866..119b1567cd0ee 100644
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
index a6fa9aedb28b0..d95409f3cba66 100644
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
 

