Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77DB9C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 581DA60ED4
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhJLXfx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235840AbhJLXfx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20D3F60E53;
        Tue, 12 Oct 2021 23:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081631;
        bh=4Wl4/fCtaZrK5Qwat+yF9Twq5uE5Y/LpB4ai0x+lyTc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QPUlY9Fm6gMtBdsmK+YLaKbcSShKblQ7CfMxlA1jcSLywz0cZtQDrk/qG8p8JTGDO
         XjNoEP6qddlfckoPb1rTylXg6JdhDfXJVNtShK2mm9SiC5u7XJbvg94mp8lRn0ocCE
         wx4fSS87/HgG0mAgfzbx1mOlg1brcXWJgOXtkc2w3zDWkDDsP62hVNRgWsYpPBuGap
         uwBiDdnaEOB+RZku6AWBL0iRNRXQ8+PRHuxjVLE7O42fXaA55bCwDoyLmgp0w52DV+
         KOHNEv623YNBtI1qA4UT5zOhSaiphmemriB1gD+uv4WH0CqjhSbScJKC3EMn9r9O0M
         OUznjokJEH7+g==
Subject: [PATCH 14/15] xfs: compute absolute maximum nlevels for each btree
 type
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:50 -0700
Message-ID: <163408163084.4151249.13133029541413030318.stgit@magnolia>
In-Reply-To: <163408155346.4151249.8364703447365270670.stgit@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 +++++++++++
 fs/xfs/libxfs/xfs_alloc_btree.h    |    2 ++
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_bmap_btree.c     |   14 ++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h     |    2 ++
 fs/xfs/libxfs/xfs_btree.c          |   41 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h          |    3 +++
 fs/xfs/libxfs/xfs_fs.h             |    2 ++
 fs/xfs/libxfs/xfs_ialloc.c         |    1 +
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   19 +++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.h   |    2 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |   20 ++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |    2 ++
 fs/xfs/libxfs/xfs_rmap_btree.c     |   27 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h     |    2 ++
 16 files changed, 152 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 55c5adc9b54e..7145416a230c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2198,6 +2198,7 @@ xfs_alloc_compute_maxlevels(
 {
 	mp->m_ag_maxlevels = xfs_btree_compute_maxlevels(mp->m_alloc_mnr,
 			(mp->m_sb.sb_agblocks + 1) / 2);
+	ASSERT(mp->m_ag_maxlevels <= xfs_allocbt_absolute_maxlevels());
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index f14bad21503f..61f6d266b822 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -582,6 +582,19 @@ xfs_allocbt_maxrecs(
 	return blocklen / (sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
 }
 
+/* Compute the max possible height of the maximally sized free space btree. */
+unsigned int
+xfs_allocbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_alloc_rec_t),
+			sizeof(xfs_alloc_key_t) + sizeof(xfs_alloc_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs,
+			(XFS_MAX_AG_BLOCKS + 1) / 2);
+}
+
 /* Calculate the freespace btree size for some records. */
 xfs_extlen_t
 xfs_allocbt_calc_size(
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.h b/fs/xfs/libxfs/xfs_alloc_btree.h
index 2f6b816aaf9f..c47d0e285435 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.h
+++ b/fs/xfs/libxfs/xfs_alloc_btree.h
@@ -60,4 +60,6 @@ extern xfs_extlen_t xfs_allocbt_calc_size(struct xfs_mount *mp,
 void xfs_allocbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_allocbt_absolute_maxlevels(void);
+
 #endif	/* __XFS_ALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2ae5bf9a74e7..7e70df8d1a9b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -93,6 +93,7 @@ xfs_bmap_compute_maxlevels(
 			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
 	}
 	mp->m_bm_maxlevels[whichfork] = level;
+	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_absolute_maxlevels());
 }
 
 unsigned int
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index b90122de0df0..7001aff639d2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -587,6 +587,20 @@ xfs_bmbt_maxrecs(
 	return blocklen / (sizeof(xfs_bmbt_key_t) + sizeof(xfs_bmbt_ptr_t));
 }
 
+/* Compute the max possible height of the maximally sized bmap btree. */
+unsigned int
+xfs_bmbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, XFS_BTREE_LONG_PTRS,
+			sizeof(struct xfs_bmbt_rec),
+			sizeof(struct xfs_bmbt_key) +
+				sizeof(xfs_bmbt_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs, MAXEXTNUM) + 1;
+}
+
 /*
  * Calculate number of records in a bmap btree inode root.
  */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 729e3bc569be..e9218e92526b 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -110,4 +110,6 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
 
+unsigned int xfs_bmbt_absolute_maxlevels(void);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b95c817ad90d..bea1bdf9b8b9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4964,3 +4964,44 @@ xfs_btree_has_more_records(
 	else
 		return block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK);
 }
+
+/*
+ * Compute absolute minrecs for leaf and node btree blocks.  Callers should set
+ * BTREE_LONG_PTRS and BTREE_OVERLAPPING as they would for regular cursors.
+ * Set BTREE_CRC_BLOCKS if the btree type is supported /only/ on V5 or newer
+ * filesystems.
+ */
+void
+xfs_btree_absolute_minrecs(
+	unsigned int		*minrecs,
+	unsigned int		bc_flags,
+	unsigned int		leaf_recbytes,
+	unsigned int		node_recbytes)
+{
+	unsigned int		min_recbytes;
+
+	/*
+	 * If this btree type is supported on V4, we use the smaller V4 min
+	 * block size along with the V4 header size.  If the btree type is only
+	 * supported on V5, use the (twice as large) V5 min block size along
+	 * with the V5 header size.
+	 */
+	if (!(bc_flags & XFS_BTREE_CRC_BLOCKS)) {
+		if (bc_flags & XFS_BTREE_LONG_PTRS)
+			min_recbytes = XFS_MIN_BLOCKSIZE -
+							XFS_BTREE_LBLOCK_LEN;
+		else
+			min_recbytes = XFS_MIN_BLOCKSIZE -
+							XFS_BTREE_SBLOCK_LEN;
+	} else if (bc_flags & XFS_BTREE_LONG_PTRS) {
+		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_LBLOCK_CRC_LEN;
+	} else {
+		min_recbytes = XFS_MIN_CRC_BLOCKSIZE - XFS_BTREE_SBLOCK_CRC_LEN;
+	}
+
+	if (bc_flags & XFS_BTREE_OVERLAPPING)
+		node_recbytes <<= 1;
+
+	minrecs[0] = min_recbytes / (2 * leaf_recbytes);
+	minrecs[1] = min_recbytes / (2 * node_recbytes);
+}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 20a2828c11ef..acb202839afd 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -601,4 +601,7 @@ xfs_btree_alloc_cursor(
 	return cur;
 }
 
+void xfs_btree_absolute_minrecs(unsigned int *minrecs, unsigned int bc_flags,
+		unsigned int leaf_recbytes, unsigned int node_recbytes);
+
 #endif	/* __XFS_BTREE_H__ */
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
index 994ad783d407..017aebdda42f 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2793,6 +2793,7 @@ xfs_ialloc_setup_geometry(
 	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
 	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
 			inodes);
+	ASSERT(igeo->inobt_maxlevels <= xfs_inobt_absolute_maxlevels());
 
 	/*
 	 * Set the maximum inode count for this filesystem, being careful not
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 3a5a24648b87..2e3dd1d798bd 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -542,6 +542,25 @@ xfs_inobt_maxrecs(
 	return blocklen / (sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
 }
 
+/* Compute the max possible height of the maximally sized inode btree. */
+unsigned int
+xfs_inobt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+	unsigned long long	max_ag_inodes;
+
+	/*
+	 * For the absolute maximum, pretend that we can fill an entire AG
+	 * completely full of inodes except for the AG headers.
+	 */
+	max_ag_inodes = (XFS_MAX_AG_BYTES - (4 * BBSIZE)) / XFS_DINODE_MIN_SIZE;
+
+	xfs_btree_absolute_minrecs(minrecs, 0, sizeof(xfs_inobt_rec_t),
+			sizeof(xfs_inobt_key_t) + sizeof(xfs_inobt_ptr_t));
+
+	return xfs_btree_compute_maxlevels(minrecs, max_ag_inodes);
+}
+
 /*
  * Convert the inode record holemask to an inode allocation bitmap. The inode
  * allocation bitmap is inode granularity and specifies whether an inode is
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.h b/fs/xfs/libxfs/xfs_ialloc_btree.h
index 8a322d402e61..1f09530bf856 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.h
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.h
@@ -75,4 +75,6 @@ int xfs_inobt_cur(struct xfs_mount *mp, struct xfs_trans *tp,
 void xfs_inobt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_inobt_absolute_maxlevels(void);
+
 #endif	/* __XFS_IALLOC_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 995b0d86ddc0..bacd1b442b09 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -409,13 +409,33 @@ xfs_refcountbt_maxrecs(
 			   sizeof(xfs_refcount_ptr_t));
 }
 
+/* Compute the max possible height of the maximally sized refcount btree. */
+unsigned int
+xfs_refcountbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs, XFS_BTREE_CRC_BLOCKS,
+			sizeof(struct xfs_refcount_rec),
+			sizeof(struct xfs_refcount_key) +
+						sizeof(xfs_refcount_ptr_t));
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
+	ASSERT(mp->m_refc_maxlevels <= xfs_refcountbt_absolute_maxlevels());
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
index bd9ed9e1e41f..2625b08f50a8 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.h
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -65,4 +65,6 @@ extern int xfs_refcountbt_calc_reserves(struct xfs_mount *mp,
 void xfs_refcountbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 
+unsigned int xfs_refcountbt_absolute_maxlevels(void);
+
 #endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b1b55a6e7d25..860627b5ec08 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -535,6 +535,32 @@ xfs_rmapbt_maxrecs(
 		(2 * sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
 }
 
+/* Compute the max possible height of the maximally sized rmap btree. */
+unsigned int
+xfs_rmapbt_absolute_maxlevels(void)
+{
+	unsigned int		minrecs[2];
+
+	xfs_btree_absolute_minrecs(minrecs,
+			XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING,
+			sizeof(struct xfs_rmap_rec),
+			sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
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
+	return xfs_btree_compute_maxlevels_size(XFS_MAX_CRC_AG_BLOCKS,
+			minrecs[1]);
+}
+
 /* Compute the maximum height of an rmap btree. */
 void
 xfs_rmapbt_compute_maxlevels(
@@ -573,6 +599,7 @@ xfs_rmapbt_compute_maxlevels(
 	}
 
 	mp->m_rmap_maxlevels = val;
+	ASSERT(mp->m_rmap_maxlevels <= xfs_rmapbt_absolute_maxlevels());
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index f2eee6572af4..84fe74de923f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -59,4 +59,6 @@ extern xfs_extlen_t xfs_rmapbt_max_size(struct xfs_mount *mp,
 extern int xfs_rmapbt_calc_reserves(struct xfs_mount *mp, struct xfs_trans *tp,
 		struct xfs_perag *pag, xfs_extlen_t *ask, xfs_extlen_t *used);
 
+unsigned int xfs_rmapbt_absolute_maxlevels(void);
+
 #endif /* __XFS_RMAP_BTREE_H__ */

