Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCEFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:18:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiLaBS0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbiLaBSZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:18:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF9D1CB3B
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:18:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F29F161D7A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85DC433D2;
        Sat, 31 Dec 2022 01:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449503;
        bh=B35otfMdKkqr0KVqGqvaq8OdQgRhK7ZnGmNc70w6pgk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TS0tqrd7MZDp34K0UmsLCWYeZUznrXjTk5rJ7OyZrexc8ukIOwwWSHh2ntPNrUtt5
         F578d6wrMT2qEZ1wMCReuQWRkRSlSUPwFdE2UNPhq1NieB4KMWAh6p9V9Mn3guiYZI
         Oalby4trFAvGKw48Lj4BtQJb3G7FGRq9kx0qSnotDcGKwRleaD9fgjVcgM4Hl1lCvg
         af4pKUt+Qh1HOPACR71vYc45PeaidGsIRyRvCK2cYq4nxpLey7PK+lX6UtTFgAzbaT
         TLs8Da60thbjAmvXvxMeIrnVmKyJslbJiy7LvX20Ari7ZkdWLeWGvxiwRONvPyUMlM
         YOAXLx0w82KnQ==
Subject: [PATCH 08/14] xfs: standardize the btree maxrecs function parameters
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:32 -0800
Message-ID: <167243865220.708933.2761563685766499261.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 6f17fee31872..7f375c853492 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
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
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 45df893ef6bb..f61f51d0bd76 100644
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
index 98bd32da142d..eda20bb5c4af 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -565,7 +565,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
-	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
+	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, false) == 1);
 
 	pp = xfs_bmap_broot_ptr_addr(mp, rblock, 1, ifp->if_broot_bytes);
 	cbno = be64_to_cpu(*pp);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 973fa6cc7aa6..1d226b284db3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -682,11 +682,11 @@ xfs_bmbt_commit_staged_btree(
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
index 5a3bae94debd..a9ddc9b42e61 100644
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
index 1d1c3cb0389c..331d22a60272 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2880,8 +2880,8 @@ xfs_ialloc_setup_geometry(
 
 	/* Compute inode btree geometry. */
 	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
-	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 1);
-	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, 0);
+	igeo->inobt_mxr[0] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, true);
+	igeo->inobt_mxr[1] = xfs_inobt_maxrecs(mp, sbp->sb_blocksize, false);
 	igeo->inobt_mnr[0] = igeo->inobt_mxr[0] / 2;
 	igeo->inobt_mnr[1] = igeo->inobt_mxr[1] / 2;
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 84094e326a6e..9f3104db9171 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -560,11 +560,11 @@ xfs_inobt_block_maxrecs(
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
index 6d8d6bcd594d..1f219fae59c2 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -52,7 +52,8 @@ extern struct xfs_btree_cur *xfs_inobt_init_cursor(struct xfs_mount *mp,
 struct xfs_btree_cur *xfs_inobt_stage_cursor(struct xfs_mount *mp,
 		struct xbtree_afakeroot *afake, struct xfs_perag *pag,
 		xfs_btnum_t btnum);
-extern int xfs_inobt_maxrecs(struct xfs_mount *, int, int);
+unsigned int xfs_inobt_maxrecs(struct xfs_mount *mp, unsigned int blocklen,
+		bool leaf);
 
 /* ir_holemask to inode allocation bitmap conversion */
 uint64_t xfs_inobt_irec_to_allocmask(const struct xfs_inobt_rec_incore *irec);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index ceab02b19d26..a9610452ca3a 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -462,7 +462,7 @@ xfs_iroot_realloc(
 	}
 
 	/* Compute the new and old record count and space requirements. */
-	cur_max = xfs_bmbt_maxrecs(mp, old_size, 0);
+	cur_max = xfs_bmbt_maxrecs(mp, old_size, false);
 	new_max = cur_max + rec_diff;
 	ASSERT(new_max >= 0);
 	new_size = xfs_bmap_broot_space_calc(mp, new_max);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index b037fd949f8c..674a846aa121 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -439,9 +439,10 @@ xfs_refcountbt_block_maxrecs(
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
index d66b37259bed..fe3c20d67790 100644
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
index 1b88766ac497..81af6444e4b9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -588,7 +588,7 @@ xfs_rmapbt_mem_verify(
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
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index a27a236111dd..bf88fba0392a 100644
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
index dbbea5b86f27..54f93e1b0f00 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1049,23 +1049,23 @@ xfs_sb_mount_common(
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
 

