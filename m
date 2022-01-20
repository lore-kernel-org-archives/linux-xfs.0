Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24506C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345404AbiATA0G (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344725AbiATA0G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:26:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B02C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:26:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79EF9B81A7D
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E82CC004E1;
        Thu, 20 Jan 2022 00:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638363;
        bh=/gU8t09UxQvuZcS9k09oxlEZINT5PZ+5vHqvCcKMzmo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OJR7Bs3qWeazyKheXJzEErX1XwiEg58vOgO6SihNI1QrioSklRSi0KpdIJFeD8vnD
         IzM025r1VAS/7WVU7s9zm8h39XsWNi+6VkSk6h2BJkRHPwWPur3j95XscPpM9ofxkz
         51Lo3HguvAWJWAe9OxilYlxQCNiYGIFfEHWfycxqWDy23LF2M2klx54E3qPAc9pdZW
         c2jpjjpGFwsZtwamE+CeE1nOjQxoFPoBjrVla+mcKoDKaZ3HQT88y6NK8OYGrgGv4Q
         QHRezis/+ed6E06Rxb/qj8RJYX98irEkcz6m4E/t0ZgXzsM7UY4EKFhWqJ2n4cEIZU
         L46H8U7tJwsNg==
Subject: [PATCH 31/48] xfs: compute absolute maximum nlevels for each btree
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:26:02 -0800
Message-ID: <164263836283.865554.12835070575139510285.stgit@magnolia>
In-Reply-To: <164263819185.865554.6000499997543946756.stgit@magnolia>
References: <164263819185.865554.6000499997543946756.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 0ed5f7356daee74244b02e100b3cc043e886e686

Add code for all five btree types so that we can compute the absolute
maximum possible btree height for each btree type.  This is a setup for
the next patch, which makes every btree type have its own cursor cache.

The functions are exported so that we can have xfs_db report the
absolute maximum btree heights for each btree type, rather than making
everyone run their own ad-hoc computations.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_alloc.c          |    1 +
 libxfs/xfs_alloc_btree.c    |   33 +++++++++++++++++++++--
 libxfs/xfs_alloc_btree.h    |    2 +
 libxfs/xfs_bmap.c           |    1 +
 libxfs/xfs_bmap_btree.c     |   31 ++++++++++++++++++++--
 libxfs/xfs_bmap_btree.h     |    2 +
 libxfs/xfs_fs.h             |    2 +
 libxfs/xfs_ialloc.c         |    1 +
 libxfs/xfs_ialloc_btree.c   |   61 +++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_ialloc_btree.h   |    2 +
 libxfs/xfs_refcount_btree.c |   45 ++++++++++++++++++++++++++------
 libxfs/xfs_refcount_btree.h |    2 +
 libxfs/xfs_rmap_btree.c     |   43 +++++++++++++++++++++++++++---
 libxfs/xfs_rmap_btree.h     |    2 +
 14 files changed, 207 insertions(+), 21 deletions(-)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index e20d8fb7..7d304160 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2194,6 +2194,7 @@ xfs_alloc_compute_maxlevels(
 {
 	mp->m_alloc_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
 			(mp->m_sb.sb_agblocks + 1) / 2);
+	ASSERT(mp->m_alloc_maxlevels <= xfs_allocbt_maxlevels_ondisk());
 }
 
 /*
diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index d752500b..6de3af37 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -564,6 +564,17 @@ xfs_allocbt_commit_staged_btree(
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
@@ -574,10 +585,26 @@ xfs_allocbt_maxrecs(
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
diff --git a/libxfs/xfs_alloc_btree.h b/libxfs/xfs_alloc_btree.h
index 2f6b816a..c715bee5 100644
--- a/libxfs/xfs_alloc_btree.h
+++ b/libxfs/xfs_alloc_btree.h
@@ -60,4 +60,6 @@ extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_allocbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 3b8b1b61..bc8a2033 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -86,6 +86,7 @@ xfs_bmap_compute_maxlevels(
 			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
+	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());
 }
 
 unsigned int
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 9e2263ed..85faea1d 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -569,6 +569,17 @@ xfs_bmbt_init_cursor(
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
@@ -579,10 +590,24 @@ xfs_bmbt_maxrecs(
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
diff --git a/libxfs/xfs_bmap_btree.h b/libxfs/xfs_bmap_btree.h
index 729e3bc5..2a1c9e60 100644
--- a/libxfs/xfs_bmap_btree.h
+++ b/libxfs/xfs_bmap_btree.h
@@ -110,4 +110,6 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+unsigned int xfs_bmbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index bde2b4c6..c43877c8 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -268,6 +268,8 @@ typedef struct xfs_fsop_resblks {
  */
 #define XFS_MIN_AG_BYTES	(1ULL << 24)	/* 16 MB */
 #define XFS_MAX_AG_BYTES	(1ULL << 40)	/* 1 TB */
+#define XFS_MAX_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_BLOCKSIZE)
+#define XFS_MAX_CRC_AG_BLOCKS	(XFS_MAX_AG_BYTES / XFS_MIN_CRC_BLOCKSIZE)
 
 /* keep the maximum size under 2^31 by a small amount */
 #define XFS_MAX_LOG_BYTES \
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 3b96e828..b18ddc4e 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -2788,6 +2788,7 @@ xfs_ialloc_setup_geometry(
 	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
 	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
 			inodes);
+	ASSERT(igeo->inobt_maxlevels <= xfs_iallocbt_maxlevels_ondisk());
 
 	/*
 	 * Set the maximum inode count for this filesystem, being careful not
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index be0918b7..30b1abe9 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -525,6 +525,17 @@ xfs_inobt_commit_staged_btree(
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
@@ -535,10 +546,54 @@ xfs_inobt_maxrecs(
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
diff --git a/libxfs/xfs_ialloc_btree.h b/libxfs/xfs_ialloc_btree.h
index 8a322d40..6d3e4a33 100644
--- a/libxfs/xfs_ialloc_btree.h
+++ b/libxfs/xfs_ialloc_btree.h
@@ -75,4 +75,6 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_iallocbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 6a716924..1d7b2d7c 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -392,29 +392,58 @@ xfs_refcountbt_commit_staged_btree(
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
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
index bd9ed9e1..d7f7c89c 100644
--- a/libxfs/xfs_refcount_btree.h
+++ b/libxfs/xfs_refcount_btree.h
@@ -65,4 +65,6 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_refcountbt_maxlevels_ondisk(void);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index eeaa1e28..eb3ef409 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -517,6 +517,18 @@ xfs_rmapbt_commit_staged_btree(
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
@@ -526,11 +538,33 @@ xfs_rmapbt_maxrecs(
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
@@ -567,6 +601,7 @@ xfs_rmapbt_compute_maxlevels(
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 	}
+	ASSERT(mp->m_rmap_maxlevels <= xfs_rmapbt_maxlevels_ondisk());
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index f2eee657..e9778b62 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -59,4 +59,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
+unsigned int xfs_rmapbt_maxlevels_ondisk(void);
+
 #endif /* __XFS_RMAP_BTREE_H__ */

