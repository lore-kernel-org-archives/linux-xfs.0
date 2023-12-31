Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A77C129
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gO9mHrLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483DDC433C8;
	Sun, 31 Dec 2023 22:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061217;
	bh=V4Brrj7DTC7ADNdHZ5wi+7XiJSDRA2Z/o7pZa+6/vN0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gO9mHrLuc4r8MpkH0LRJlRMUPpizdiUzeqvxNxC1r62mr0+jKF8v3bC0hdLVFudNd
	 fzHYeq7yvHobRG6aNEiUItHcfFEUnwW3CvjNR243Kq5JD9Z3hlXXGDTaIuwsIykqve
	 Of/4ALW9viFZ6t3TCTqvlizTi3U4fnFrsKsYXb7ocxTS9RtaiaJhr0ovczdV1ER9Rw
	 BF1fVy3jT4S87orwvxdKmOoS9jt2x5ZDiOHgSUZJ/wxzyzq+MZ/aE3KO63+wLyUb5B
	 KL6C4HEao88Ke2+CuYFDKyXIUakyMpMIoc0DlOkW9QZRAS9aDq/D0unn0OwahhvE7l
	 nZw/FzHqPTRBg==
Date: Sun, 31 Dec 2023 14:20:16 -0800
Subject: [PATCH 2/9] xfs: encode the default bc_flags in the btree ops
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994015.1795132.7396849220541714922.stgit@frogsfrogsfrogs>
In-Reply-To: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
References: <170404993983.1795132.17312636757680803212.stgit@frogsfrogsfrogs>
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

Certain btree flags never change for the life of a btree cursor because
they describe the geometry of the btree itself.  Encode these in the
btree ops structure and reduce the amount of code required in each btree
type's init_cursor functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc_btree.c    |    8 ++------
 libxfs/xfs_bmap_btree.c     |    5 +----
 libxfs/xfs_btree.h          |    6 ++++++
 libxfs/xfs_ialloc_btree.c   |    3 ---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    6 +++---
 6 files changed, 12 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 16f683e1dc8..2d33e0e66d5 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -478,6 +478,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
+	.geom_flags		= XFS_BTREE_LASTREC_UPDATE,
 
 	.dup_cursor		= xfs_allocbt_dup_cursor,
 	.set_root		= xfs_allocbt_set_root,
@@ -514,19 +515,14 @@ xfs_allocbt_init_common(
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_cntbt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtc_2);
-		cur->bc_flags = XFS_BTREE_LASTREC_UPDATE;
 	} else {
 		cur = xfs_btree_alloc_cursor(mp, tp, btnum, &xfs_bnobt_ops,
 				mp->m_alloc_maxlevels, xfs_allocbt_cur_cache);
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_abtb_2);
 	}
-	cur->bc_ag.abt.active = false;
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
-
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
+	cur->bc_ag.abt.active = false;
 	return cur;
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index cfb0684f7b2..020b8274c47 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -516,6 +516,7 @@ xfs_bmbt_keys_contiguous(
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
+	.geom_flags		= XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE,
 
 	.dup_cursor		= xfs_bmbt_dup_cursor,
 	.update_cursor		= xfs_bmbt_update_cursor,
@@ -551,10 +552,6 @@ xfs_bmbt_init_common(
 			mp->m_bm_maxlevels[whichfork], xfs_bmbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
-	cur->bc_flags = XFS_BTREE_LONG_PTRS | XFS_BTREE_ROOT_IN_INODE;
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ino.ip = ip;
 	cur->bc_ino.allocated = 0;
 	cur->bc_ino.flags = 0;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ed138889031..2c2d5db94b1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -116,6 +116,9 @@ struct xfs_btree_ops {
 	size_t	key_len;
 	size_t	rec_len;
 
+	/* XFS_BTREE_* flags that determine the geometry of the btree */
+	unsigned int	geom_flags;
+
 	/* cursor operations */
 	struct xfs_btree_cur *(*dup_cursor)(struct xfs_btree_cur *);
 	void	(*update_cursor)(struct xfs_btree_cur *src,
@@ -750,6 +753,9 @@ xfs_btree_alloc_cursor(
 	cur->bc_btnum = btnum;
 	cur->bc_maxlevels = maxlevels;
 	cur->bc_cache = cache;
+	cur->bc_flags = ops->geom_flags;
+	if (xfs_has_crc(mp))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
 
 	return cur;
 }
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 5ea08cca25b..dea661afc4d 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -465,9 +465,6 @@ xfs_inobt_init_common(
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_fibt_2);
 	}
 
-	if (xfs_has_crc(mp))
-		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	return cur;
 }
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 561b732b474..1ecd670a9eb 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -356,8 +356,6 @@ xfs_refcountbt_init_common(
 			xfs_refcountbt_cur_cache);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
-	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
-
 	cur->bc_ag.pag = xfs_perag_hold(pag);
 	cur->bc_ag.refc.nr_ops = 0;
 	cur->bc_ag.refc.shape_changes = 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index c4085a1befb..bedadb8b5bc 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -487,6 +487,7 @@ xfs_rmapbt_keys_contiguous(
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
 
 	.dup_cursor		= xfs_rmapbt_dup_cursor,
 	.set_root		= xfs_rmapbt_set_root,
@@ -517,7 +518,6 @@ xfs_rmapbt_init_common(
 	/* Overlapping btree; 2 keys per pointer. */
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP, &xfs_rmapbt_ops,
 			mp->m_rmap_maxlevels, xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 
 	cur->bc_ag.pag = xfs_perag_hold(pag);
@@ -611,6 +611,8 @@ static const struct xfs_buf_ops xfs_rmapbt_mem_buf_ops = {
 static const struct xfs_btree_ops xfs_rmapbt_mem_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
+	.geom_flags		= XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
+				  XFS_BTREE_IN_XFILE,
 
 	.dup_cursor		= xfbtree_dup_cursor,
 	.set_root		= xfbtree_set_root,
@@ -645,8 +647,6 @@ xfs_rmapbt_mem_cursor(
 	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
 			&xfs_rmapbt_mem_ops, mp->m_rmap_maxlevels,
 			xfs_rmapbt_cur_cache);
-	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING |
-			XFS_BTREE_IN_XFILE;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_mem.xfbtree = xfbtree;
 	cur->bc_mem.head_bp = head_bp;

