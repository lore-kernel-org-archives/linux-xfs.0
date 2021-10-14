Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4B58C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9393610E6
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbhJNUU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:35750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUU2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA5B610D2;
        Thu, 14 Oct 2021 20:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242703;
        bh=acUmX8m1GFSidt2UirJPdYBAHBUQRkBTIlp5Tbvdth4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ppeG/a5HlGstvjnLA4IF4XtNOdSddryOf0XfAfhGDMZx54Bw3YMCFGv7ThaQRg/tZ
         W6vAW4uI8q6lHrukJjFH0cRSYt/XgDijDQAelRYX+jUqAZ4Ltp4PJ9aJg0r5mFFNpz
         u1/Rrlx37Xqu09QdI/NHZRhGa6dceKsOZRONKwtDYfSHai7NmLGleMVSII8lcQyI8E
         86Ka4CKcpxrnmf702oEtEqiaPf3fsOzlGeoDvjy+HUhUFdAeIW/1bisZ2VxuigPJk2
         K868eGCbw06CWq2sihf8OsHJK0nr8CxUpu5GmC2FvdnTlx2DTx38TXvSywqWkH05LR
         nz46EyCMzFUEQ==
Subject: [PATCH 16/17] xfs: compute absolute maximum nlevels for each btree
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:18:22 -0700
Message-ID: <163424270288.756780.11162456027952341571.stgit@magnolia>
In-Reply-To: <163424261462.756780.16294781570977242370.stgit@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add code for all five btree types so that we can compute the absolute
maximum possible btree height for each btree type.  This is a setup for
the next patch, which makes every btree type have its own cursor cache.

The functions are exported so that we can have xfs_db report the
absolute maximum btree heights for each btree type, rather than making
everyone run their own ad-hoc computations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    1 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   33 ++++++++++++++++++-
 fs/xfs/libxfs/xfs_alloc_btree.h    |    2 +
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |   31 +++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap_btree.h     |    2 +
 fs/xfs/libxfs/xfs_fs.h             |    2 +
 fs/xfs/libxfs/xfs_ialloc.c         |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   61 ++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    2 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   45 ++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_refcount_btree.h |    2 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   43 +++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 +
 14 files changed, 207 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 2efb4f4539f1..1a5684af8430 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2198,6 +2198,7 @@ xfs_alloc_compute_maxlevels(
 {
 	mp->m_alloc_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
 			(mp->m_sb.sb_agblocks + 1) / 2);
+	ASSERT(mp->m_alloc_maxlevels <= xfs_allocbt_maxlevels_ondisk());
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index c3e262290f6f..d0a7aa4b52a8 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -566,6 +566,17 @@ xfs_allocbt_commit_staged_btree(
 	}
 }
 
+/* Calculate number of records in an alloc btree block. */
+static inline unsigned int
+xfs_allocbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(xfs_alloc_rec_t);
+	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
+}
+
 /*
  * Calculate number of records in an alloc btree block.
  */
@@ -576,10 +587,26 @@ xfs_allocbt_maxrecs(
 	int			leaf)
 {
 	blocklen -= XFS_ALLOC_BLOCK_LEN(mp);
+	return xfs_allocbt_block_maxrecs(blocklen, leaf);
+}
 
-	if (leaf)
-		return blocklen / sizeof(xfs_alloc_rec_t);
-	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
+/* Free space btrees are at their largest when every other block is free. */
+#define XFS_MAX_FREESP_RECORDS	((XFS_MAX_AG_BLOCKS + 1) / 2)
+
+/* Compute the max possible height for free space btrees. */
+unsigned int
+xfs_allocbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = min(XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN,
+		       XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN);
+
+	minrecs[0] = xfs_allocbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_allocbt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_FREESP_RECORDS);
 }
 
 /* Calculate the freespace btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 2f6b816aaf9f..c715bee5ae90 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -60,4 +60,6 @@ extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_allocbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2ae5bf9a74e7..321617e837ef 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -93,6 +93,7 @@ xfs_bmap_compute_maxlevels(
 			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
+	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
 }
 
 unsigned int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b90122de0df0..59d146696a62 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -571,6 +571,17 @@ xfs_bmbt_init_cursor(
 	return cur;
 }
 
+/* Calculate number of records in a block mapping btree block. */
+static inline unsigned int
+xfs_bmbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(xfs_bmbt_rec_t);
+	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
+}
+
 /*
  * Calculate number of records in a bmap btree block.
  */
@@ -581,10 +592,24 @@ xfs_bmbt_maxrecs(
 	int			leaf)
 {
 	blocklen -= XFS_BMBT_BLOCK_LEN(mp);
+	return xfs_bmbt_block_maxrecs(blocklen, leaf);
+}
 
-	if (leaf)
-		return blocklen / sizeof(xfs_bmbt_rec_t);
-	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
+/* Compute the max possible height for block mapping btrees. */
+unsigned int
+xfs_bmbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = min(XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN,
+		       XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN);
+
+	minrecs[0] = xfs_bmbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_bmbt_block_maxrecs(blocklen, false) / 2;
+
+	/* One extra level for the inode root. */
+	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 729e3bc569be..2a1c9e607b52 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -110,4 +110,6 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+unsigned int xfs_bmbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index bde2b4c64dbe..c43877c8a279 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -268,6 +268,8 @@ typedef struct xfs_fsop_resblks {
  */
 #define XFS_MIN_AG_BYTES	(1ULL << 24)	/* 16 MB */
 #define XFS_MAX_AG_BYTES	(1ULL << 40)	/* 1 TB */
+#define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
+#define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
 
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 994ad783d407..f78a600ca73f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2793,6 +2793,7 @@ xfs_ialloc_setup_geometry(
 	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
 	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
 			inodes);
+	ASSERT(igeo->inobt_maxlevels <= xfs_iallocbt_maxlevels_ondisk());
 
 	/*
 	 * Set the maximum inode count for this filesystem, being careful not
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3a5a24648b87..74681e881164 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -526,6 +526,17 @@ xfs_inobt_commit_staged_btree(
 	}
 }
 
+/* Calculate number of records in an inode btree block. */
+static inline unsigned int
+xfs_inobt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(xfs_inobt_rec_t);
+	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
+}
+
 /*
  * Calculate number of records in an inobt btree block.
  */
@@ -536,10 +547,54 @@ xfs_inobt_maxrecs(
 	int			leaf)
 {
 	blocklen -= XFS_INOBT_BLOCK_LEN(mp);
+	return xfs_inobt_block_maxrecs(blocklen, leaf);
+}
 
-	if (leaf)
-		return blocklen / sizeof(xfs_inobt_rec_t);
-	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
+/*
+ * Maximum number of inode btree records per AG.  Pretend that we can fill an
+ * entire AG completely full of inodes except for the AG headers.
+ */
+#define XFS_MAX_INODE_RECORDS \
+	((XFS_MAX_AG_BYTES - (4 * BBSIZE)) / XFS_DINODE_MIN_SIZE) / \
+			XFS_INODES_PER_CHUNK
+
+/* Compute the max possible height for the inode btree. */
+static inline unsigned int
+xfs_inobt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = min(XFS_MIN_BLOCKSIZE - XFS_BTREE_SBLOCK_LEN,
+		       XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN);
+
+	minrecs[0] = xfs_inobt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_inobt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_INODE_RECORDS);
+}
+
+/* Compute the max possible height for the free inode btree. */
+static inline unsigned int
+xfs_finobt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_inobt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_inobt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_INODE_RECORDS);
+}
+
+/* Compute the max possible height for either inode btree. */
+unsigned int
+xfs_iallocbt_maxlevels_ondisk(void)
+{
+	return max(xfs_inobt_maxlevels_ondisk(),
+		   xfs_finobt_maxlevels_ondisk());
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 8a322d402e61..6d3e4a3316d7 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -75,4 +75,6 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_iallocbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 995b0d86ddc0..3bf802fc33bb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -393,29 +393,58 @@ xfs_refcountbt_commit_staged_btree(
 	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_refcountbt_ops);
 }
 
-/*
- * Calculate the number of records in a refcount btree block.
- */
-int
-xfs_refcountbt_maxrecs(
-	int			blocklen,
+/* Calculate number of records in a refcount btree block. */
+static inline unsigned int
+xfs_refcountbt_block_maxrecs(
+	unsigned int		blocklen,
 	bool			leaf)
 {
-	blocklen -= XFS_REFCOUNT_BLOCK_LEN;
-
 	if (leaf)
 		return blocklen / sizeof(struct xfs_refcount_rec);
 	return blocklen / (sizeof(struct xfs_refcount_key) +
 			   sizeof(xfs_refcount_ptr_t));
 }
 
+/*
+ * Calculate the number of records in a refcount btree block.
+ */
+int
+xfs_refcountbt_maxrecs(
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_REFCOUNT_BLOCK_LEN;
+	return xfs_refcountbt_block_maxrecs(blocklen, leaf);
+}
+
+/* Compute the max possible height of the maximally sized refcount btree. */
+unsigned int
+xfs_refcountbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_refcountbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_refcountbt_block_maxrecs(blocklen, false) / 2;
+
+	return xfs_btree_compute_maxlevels(minrecs, XFS_MAX_CRC_AG_BLOCKS);
+}
+
 /* Compute the maximum height of a refcount btree. */
 void
 xfs_refcountbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
+	if (!xfs_has_reflink(mp)) {
+		mp->m_refc_maxlevels = 0;
+		return;
+	}
+
 	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(
 			mp->m_refc_mnr, mp->m_sb.sb_agblocks);
+	ASSERT(mp->m_refc_maxlevels <= xfs_refcountbt_maxlevels_ondisk());
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index bd9ed9e1e41f..d7f7c89cbf35 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -65,4 +65,6 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_refcountbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7388201e48d2..0c96e26daca9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -519,6 +519,18 @@ xfs_rmapbt_commit_staged_btree(
 	xfs_btree_commit_afakeroot(cur, tp, agbp, &xfs_rmapbt_ops);
 }
 
+/* Calculate number of records in a reverse mapping btree block. */
+static inline unsigned int
+xfs_rmapbt_block_maxrecs(
+	unsigned int		blocklen,
+	bool			leaf)
+{
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
+}
+
 /*
  * Calculate number of records in an rmap btree block.
  */
@@ -528,11 +540,33 @@ xfs_rmapbt_maxrecs(
 	int			leaf)
 {
 	blocklen -= XFS_RMAP_BLOCK_LEN;
+	return xfs_rmapbt_block_maxrecs(blocklen, leaf);
+}
 
-	if (leaf)
-		return blocklen / sizeof(struct xfs_rmap_rec);
-	return blocklen /
-		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
+/* Compute the max possible height for reverse mapping btrees. */
+unsigned int
+xfs_rmapbt_maxlevels_ondisk(void)
+{
+	unsigned int		minrecs[2];
+	unsigned int		blocklen;
+
+	blocklen = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
+
+	minrecs[0] = xfs_rmapbt_block_maxrecs(blocklen, true) / 2;
+	minrecs[1] = xfs_rmapbt_block_maxrecs(blocklen, false) / 2;
+
+	/*
+	 * Compute the asymptotic maxlevels for an rmapbt on any reflink fs.
+	 *
+	 * On a reflink filesystem, each AG block can have up to 2^32 (per the
+	 * refcount record format) owners, which means that theoretically we
+	 * could face up to 2^64 rmap records.  However, we're likely to run
+	 * out of blocks in the AG long before that happens, which means that
+	 * we must compute the max height based on what the btree will look
+	 * like if it consumes almost all the blocks in the AG due to maximal
+	 * sharing factor.
+	 */
+	return xfs_btree_space_to_height(minrecs, XFS_MAX_CRC_AG_BLOCKS);
 }
 
 /* Compute the maximum height of an rmap btree. */
@@ -569,6 +603,7 @@ xfs_rmapbt_compute_maxlevels(
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 	}
+	ASSERT(mp->m_rmap_maxlevels <= xfs_rmapbt_maxlevels_ondisk());
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index f2eee6572af4..e9778b62ad55 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -59,4 +59,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
+unsigned int xfs_rmapbt_maxlevels_ondisk(void);
+
 #endif /* __XFS_RMAP_BTREE_H__ */

