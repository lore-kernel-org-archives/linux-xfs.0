Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B54BC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 467D861108
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243764AbhIXB3B (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:29:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:57192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243765AbhIXB3B (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A70C610CB;
        Fri, 24 Sep 2021 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446849;
        bh=ObmkZLUE1vSdPMoM3oimAYhRNYYLKzHHHNeaCTqlPFI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nhP7CajsrE+2TCuq27OOKXvDFFUD+lUGcd9vMA5YrW9fEyFuH3kDHJitiuT1gkj2u
         7kbplF/5HOu3TaXP/LgsP1sM/aWTw6O7PXFsWlNpawghONxbrCpR1M8Z+zpBHmDeHi
         dgHMjn6v7uL4PiqPhooQXMGc4n87jRNqv3+QPErQuFL/+VLMKyRtw8twfbn+2Q98TH
         urYKnrxlgd056NmIIGT6SP+mMHIRjcVxV2AWGOoxAjPMraD3Qm7DBWiLjBTa7dLX3E
         m4A6lAjOJJfUUJGZE6RaHe0KvjlXU9DThXoKz+/4pmBaB4oWy05bdfzwCQErpKGv1d
         q8m7XN7D+HoeQ==
Subject: [PATCH 14/15] xfs: compute the maximum height of the rmap btree when
 reflink enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:28 -0700
Message-ID: <163244684882.2701302.3628052545730568423.stgit@magnolia>
In-Reply-To: <163244677169.2701302.12882919857957905332.stgit@magnolia>
References: <163244677169.2701302.12882919857957905332.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
enough to handle the maximally tall rmap btree when all blocks are in
use and maximally shared, let's compute the maximum height assuming the
rmapbt consumes as many blocks as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c       |   34 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h       |    2 ++
 fs/xfs/libxfs/xfs_rmap_btree.c  |   40 ++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap_btree.h  |    2 +-
 fs/xfs/libxfs/xfs_trans_resv.c  |   12 ++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    7 +++++++
 fs/xfs/xfs_mount.c              |    2 +-
 7 files changed, 78 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a222f5de2a09..64b47e81f6f3 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4534,6 +4534,40 @@ xfs_btree_compute_maxlevels(
 	return level;
 }
 
+/*
+ * Compute the maximum height of a btree that is allowed to consume up to the
+ * given number of blocks.
+ */
+unsigned int
+xfs_btree_compute_maxlevels_size(
+	unsigned long long	max_btblocks,
+	unsigned int		leaf_mnr)
+{
+	unsigned long long	leaf_blocks = leaf_mnr;
+	unsigned long long	blocks_left;
+	unsigned int		maxlevels;
+
+	if (max_btblocks < 1)
+		return 0;
+
+	/*
+	 * The loop increments maxlevels as long as there would be enough
+	 * blocks left in the reservation to handle each node block at the
+	 * current level pointing to the minimum possible number of leaf blocks
+	 * at the next level down.  We start the loop assuming a single-level
+	 * btree consuming one block.
+	 */
+	maxlevels = 1;
+	blocks_left = max_btblocks - 1;
+	while (leaf_blocks < blocks_left) {
+		maxlevels++;
+		blocks_left -= leaf_blocks;
+		leaf_blocks *= leaf_mnr;
+	}
+
+	return maxlevels;
+}
+
 /*
  * Query a regular btree for all records overlapping a given interval.
  * Start with a LE lookup of the key of low_rec and return all records
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 1f269bc49714..b848571f999b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -484,6 +484,8 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
+unsigned int xfs_btree_compute_maxlevels_size(unsigned long long max_btblocks,
+		unsigned int leaf_mnr);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f3c4d0965cc9..85caeb14e4db 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -535,30 +535,32 @@ xfs_rmapbt_maxrecs(
 }
 
 /* Compute the maximum height of an rmap btree. */
-void
+unsigned int
 xfs_rmapbt_compute_maxlevels(
-	struct xfs_mount		*mp)
+	struct xfs_mount	*mp)
 {
+	if (!xfs_has_reflink(mp)) {
+		/*
+		 * If there's no block sharing, compute the maximum rmapbt
+		 * height assuming one rmap record per AG block.
+		 */
+		return xfs_btree_compute_maxlevels(mp->m_rmap_mnr,
+				mp->m_sb.sb_agblocks);
+	}
+
 	/*
-	 * On a non-reflink filesystem, the maximum number of rmap
-	 * records is the number of blocks in the AG, hence the max
-	 * rmapbt height is log_$maxrecs($agblocks).  However, with
-	 * reflink each AG block can have up to 2^32 (per the refcount
-	 * record format) owners, which means that theoretically we
-	 * could face up to 2^64 rmap records.
+	 * Compute the asymptotic maxlevels for an rmapbt on a reflink fs.
 	 *
-	 * That effectively means that the max rmapbt height must be
-	 * XFS_BTREE_MAXLEVELS.  "Fortunately" we'll run out of AG
-	 * blocks to feed the rmapbt long before the rmapbt reaches
-	 * maximum height.  The reflink code uses ag_resv_critical to
-	 * disallow reflinking when less than 10% of the per-AG metadata
-	 * block reservation since the fallback is a regular file copy.
+	 * On a reflink filesystem, each AG block can have up to 2^32 (per the
+	 * refcount record format) owners, which means that theoretically we
+	 * could face up to 2^64 rmap records.  However, we're likely to run
+	 * out of blocks in the AG long before that happens, which means that
+	 * we must compute the max height based on what the btree will look
+	 * like if it consumes almost all the blocks in the AG due to maximal
+	 * sharing factor.
 	 */
-	if (xfs_has_reflink(mp))
-		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
-	else
-		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
-				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+	return xfs_btree_compute_maxlevels_size(mp->m_sb.sb_agblocks,
+			mp->m_rmap_mnr[1]);
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index f2eee6572af4..5aaecf755abd 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -49,7 +49,7 @@ struct xfs_btree_cur *xfs_rmapbt_stage_cursor(struct xfs_mount *mp,
 void xfs_rmapbt_commit_staged_btree(struct xfs_btree_cur *cur,
 		struct xfs_trans *tp, struct xfs_buf *agbp);
 int xfs_rmapbt_maxrecs(int blocklen, int leaf);
-extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
+unsigned int xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 extern xfs_extlen_t xfs_rmapbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa2559..679f10e08f31 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -814,6 +814,15 @@ xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+
+	/*
+	 * In the early days of rmap+reflink, we hardcoded the rmap maxlevels
+	 * to 9 even if the AG size was smaller.
+	 */
+	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
+		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
+
 	/*
 	 * The following transactions are logged in physical format and
 	 * require a permanent reservation on space.
@@ -916,4 +925,7 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
+
+	/* Put everything back the way it was.  This goes at the end. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index 50332be34388..440c9c390b86 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -17,6 +17,13 @@
 /* Adding one rmap could split every level up to the top of the tree. */
 #define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
 
+/*
+ * Note that we historically set m_rmap_maxlevels to 9 when reflink was
+ * enabled, so we must preserve this behavior to avoid changing the transaction
+ * space reservations.
+ */
+#define XFS_OLD_REFLINK_RMAP_MAXLEVELS	(9)
+
 /* Blocks we might need to add "b" rmaps to a tree. */
 #define XFS_NRMAPADD_SPACE_RES(mp, b)\
 	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 06dac09eddbd..e600a0b781c8 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -635,7 +635,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_mount_setup_inode_geom(mp);
-	xfs_rmapbt_compute_maxlevels(mp);
+	mp->m_rmap_maxlevels = xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
 
 	/*

