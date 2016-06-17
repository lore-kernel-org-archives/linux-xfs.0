Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 335D38024
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:31:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3F7730404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:07 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kASfPg0aHDpr8km3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:31:04 -0700 (PDT)
Subject: [PATCH 002/145] libxfs: port changes from kernel libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:30:58 -0700
Message-ID: <146612705805.16048.1345024248406024616.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Port various changes between the kernel and xfsprogs.  This
cleans up both so that we can develop rmap and reflink on the
same libxfs code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c     |    5 +++--
 libxfs/xfs_btree.c     |    4 ++--
 libxfs/xfs_da_btree.c  |   51 ++++++++++++++++++++++++------------------------
 libxfs/xfs_dir2_node.c |    2 ++
 libxfs/xfs_dquot_buf.c |   10 +++++----
 libxfs/xfs_format.h    |    3 +--
 libxfs/xfs_ialloc.c    |    5 ++---
 libxfs/xfs_inode_buf.c |    3 +--
 libxfs/xfs_inode_buf.h |    2 --
 libxfs/xfs_sb.c        |   19 ++++++++++++++++++
 10 files changed, 61 insertions(+), 43 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index af40270..28b3fb9 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2411,8 +2411,9 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
-		/* XXX: pagb_tree doesn't exist in userspace */
-		//pag->pagb_tree = RB_ROOT;
+#ifdef __KERNEL__
+		pag->pagb_tree = RB_ROOT;
+#endif
 		pag->pagf_init = 1;
 	}
 #ifdef DEBUG
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index a736cb5..1448fd6 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -243,7 +243,7 @@ xfs_btree_lblock_verify_crc(
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.l.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_LBLOCK_CRC_OFF);
@@ -281,7 +281,7 @@ xfs_btree_sblock_verify_crc(
 	struct xfs_btree_block  *block = XFS_BUF_TO_BLOCK(bp);
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 
-	if (xfs_sb_version_hascrc(&bp->b_target->bt_mount->m_sb)) {
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
 		if (!xfs_log_check_lsn(mp, be64_to_cpu(block->bb_u.s.bb_lsn)))
 			return false;
 		return xfs_buf_verify_cksum(bp, XFS_BTREE_SBLOCK_CRC_OFF);
diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index f3c04ab..298252e 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -351,6 +351,7 @@ xfs_da3_split(
 	struct xfs_da_state_blk	*newblk;
 	struct xfs_da_state_blk	*addblk;
 	struct xfs_da_intnode	*node;
+	struct xfs_buf		*bp;
 	int			max;
 	int			action = 0;
 	int			error;
@@ -391,9 +392,7 @@ xfs_da3_split(
 				break;
 			}
 			/*
-			 * Entry wouldn't fit, split the leaf again. The new
-			 * extrablk will be consumed by xfs_da3_node_split if
-			 * the node is split.
+			 * Entry wouldn't fit, split the leaf again.
 			 */
 			state->extravalid = 1;
 			if (state->inleaf) {
@@ -442,14 +441,6 @@ xfs_da3_split(
 		return 0;
 
 	/*
-	 * xfs_da3_node_split() should have consumed any extra blocks we added
-	 * during a double leaf split in the attr fork. This is guaranteed as
-	 * we can't be here if the attr fork only has a single leaf block.
-	 */
-	ASSERT(state->extravalid == 0 ||
-	       state->path.blk[max].magic == XFS_DIR2_LEAFN_MAGIC);
-
-	/*
 	 * Split the root node.
 	 */
 	ASSERT(state->path.active == 0);
@@ -461,31 +452,41 @@ xfs_da3_split(
 	}
 
 	/*
-	 * Update pointers to the node which used to be block 0 and just got
-	 * bumped because of the addition of a new root node.  Note that the
-	 * original block 0 could be at any position in the list of blocks in
-	 * the tree.
+	 * Update pointers to the node which used to be block 0 and
+	 * just got bumped because of the addition of a new root node.
+	 * There might be three blocks involved if a double split occurred,
+	 * and the original block 0 could be at any position in the list.
 	 *
-	 * Note: the magic numbers and sibling pointers are in the same physical
-	 * place for both v2 and v3 headers (by design). Hence it doesn't matter
-	 * which version of the xfs_da_intnode structure we use here as the
-	 * result will be the same using either structure.
+	 * Note: the magic numbers and sibling pointers are in the same
+	 * physical place for both v2 and v3 headers (by design). Hence it
+	 * doesn't matter which version of the xfs_da_intnode structure we use
+	 * here as the result will be the same using either structure.
 	 */
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.forw) {
-		ASSERT(be32_to_cpu(node->hdr.info.forw) == addblk->blkno);
-		node = addblk->bp->b_addr;
+		if (be32_to_cpu(node->hdr.info.forw) == addblk->blkno) {
+			bp = addblk->bp;
+		} else {
+			ASSERT(state->extravalid);
+			bp = state->extrablk.bp;
+		}
+		node = bp->b_addr;
 		node->hdr.info.back = cpu_to_be32(oldblk->blkno);
-		xfs_trans_log_buf(state->args->trans, addblk->bp,
+		xfs_trans_log_buf(state->args->trans, bp,
 				  XFS_DA_LOGRANGE(node, &node->hdr.info,
 				  sizeof(node->hdr.info)));
 	}
 	node = oldblk->bp->b_addr;
 	if (node->hdr.info.back) {
-		ASSERT(be32_to_cpu(node->hdr.info.back) == addblk->blkno);
-		node = addblk->bp->b_addr;
+		if (be32_to_cpu(node->hdr.info.back) == addblk->blkno) {
+			bp = addblk->bp;
+		} else {
+			ASSERT(state->extravalid);
+			bp = state->extrablk.bp;
+		}
+		node = bp->b_addr;
 		node->hdr.info.forw = cpu_to_be32(oldblk->blkno);
-		xfs_trans_log_buf(state->args->trans, addblk->bp,
+		xfs_trans_log_buf(state->args->trans, bp,
 				  XFS_DA_LOGRANGE(node, &node->hdr.info,
 				  sizeof(node->hdr.info)));
 	}
diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c
index 224daa6..04fecf1 100644
--- a/libxfs/xfs_dir2_node.c
+++ b/libxfs/xfs_dir2_node.c
@@ -2146,12 +2146,14 @@ xfs_dir2_node_replace(
 	state = xfs_da_state_alloc();
 	state->args = args;
 	state->mp = args->dp->i_mount;
+
 	/*
 	 * We have to save new inode number and ftype since
 	 * xfs_da3_node_lookup_int() is going to overwrite them
 	 */
 	inum = args->inumber;
 	ftype = args->filetype;
+
 	/*
 	 * Lookup the entry to change in the btree.
 	 */
diff --git a/libxfs/xfs_dquot_buf.c b/libxfs/xfs_dquot_buf.c
index 433abe4..7b7ea83 100644
--- a/libxfs/xfs_dquot_buf.c
+++ b/libxfs/xfs_dquot_buf.c
@@ -37,11 +37,8 @@ int
 xfs_calc_dquots_per_chunk(
 	unsigned int		nbblks)	/* basic block units */
 {
-
-	ASSERT(nbblks > 0);
-	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
-
-#if 0	/* kernel code that goes wrong in userspace! */
+#ifdef __KERNEL__
+	/* kernel code that goes wrong in userspace! */
 	unsigned int	ndquots;
 
 	ASSERT(nbblks > 0);
@@ -49,6 +46,9 @@ xfs_calc_dquots_per_chunk(
 	do_div(ndquots, sizeof(xfs_dqblk_t));
 
 	return ndquots;
+#else
+	ASSERT(nbblks > 0);
+	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
 #endif
 }
 
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f89b6e0..825fa0c 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -469,7 +469,6 @@ xfs_sb_has_ro_compat_feature(
 #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
 #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
 #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
-
 #define XFS_SB_FEAT_INCOMPAT_ALL \
 		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
 		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
@@ -533,7 +532,7 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
  * user-visible UUID to be changed on V5 filesystems which have a
  * filesystem UUID stamped into every piece of metadata.
  */
-static inline int xfs_sb_version_hasmetauuid(xfs_sb_t *sbp)
+static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 {
 	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 64c3acf..72e9ff7 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1822,8 +1822,7 @@ xfs_difree_inode_chunk(
 
 	if (!xfs_inobt_issparse(rec->ir_holemask)) {
 		/* not sparse, calculate extent info directly */
-		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno,
-				  XFS_AGINO_TO_AGBNO(mp, rec->ir_startino)),
+		xfs_bmap_add_free(mp, flist, XFS_AGB_TO_FSB(mp, agno, sagbno),
 				  mp->m_ialloc_blks);
 		return;
 	}
@@ -2228,7 +2227,7 @@ xfs_imap_lookup(
 	}
 
 	xfs_trans_brelse(tp, agbp);
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, error ? XFS_BTREE_ERROR : XFS_BTREE_NOERROR);
 	if (error)
 		return error;
 
diff --git a/libxfs/xfs_inode_buf.c b/libxfs/xfs_inode_buf.c
index e3d674d..c21a4e6 100644
--- a/libxfs/xfs_inode_buf.c
+++ b/libxfs/xfs_inode_buf.c
@@ -375,7 +375,7 @@ xfs_log_dinode_to_disk(
 	}
 }
 
-bool
+static bool
 xfs_dinode_verify(
 	struct xfs_mount	*mp,
 	xfs_ino_t		ino,
@@ -514,7 +514,6 @@ xfs_iread(
 	}
 
 	ASSERT(ip->i_d.di_version >= 2);
-
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/libxfs/xfs_inode_buf.h b/libxfs/xfs_inode_buf.h
index 4ece9bf..958c543 100644
--- a/libxfs/xfs_inode_buf.h
+++ b/libxfs/xfs_inode_buf.h
@@ -72,8 +72,6 @@ void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
 void	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
 void	xfs_log_dinode_to_disk(struct xfs_log_dinode *from,
 			       struct xfs_dinode *to);
-bool	xfs_dinode_verify(struct xfs_mount *mp, xfs_ino_t ino,
-			  struct xfs_dinode *dip);
 
 bool	xfs_dinode_good_version(struct xfs_mount *mp, __u8 version);
 
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 78ad889..67c7a65 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -256,6 +256,19 @@ xfs_mount_validate_sb(
 	}
 
 	/*
+	 * Until this is fixed only page-sized or smaller data blocks work.
+	 */
+#ifdef __KERNEL__
+	if (unlikely(sbp->sb_blocksize > PAGE_SIZE)) {
+		xfs_warn(mp,
+		"File system with blocksize %d bytes. "
+		"Only pagesize (%ld) or less will currently work.",
+				sbp->sb_blocksize, PAGE_SIZE);
+		return -ENOSYS;
+	}
+#endif
+
+	/*
 	 * Currently only very few inode sizes are supported.
 	 */
 	switch (sbp->sb_inodesize) {
@@ -277,6 +290,12 @@ xfs_mount_validate_sb(
 		return -EFBIG;
 	}
 
+#ifdef __KERNEL__
+	if (check_inprogress && sbp->sb_inprogress) {
+		xfs_warn(mp, "Offline file system operation in progress!");
+		return -EFSCORRUPTED;
+	}
+#endif
 	return 0;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
