Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E40C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 782C461151
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhJNUUR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUUR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30179610D2;
        Thu, 14 Oct 2021 20:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242692;
        bh=24HF74xsfgWUi94ym0y6eQnu418+AKuXHYzETsVLpMs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bdN7xFNFcDS2JwL6s0MOTWmFcEDEiekqhcOsK4z0hXvGPeWGscQ4QxxBYhQJ+Kf7H
         No7Q4VInpOfK/ezaO8oX1gT0579Psn1nndkJ6IK5mN/Us/GGVtuO18uz7f6UI1gY8S
         d3ndunlb6hekVBXc+t38zaBWW2PcMg/X0BmdouNqSL4ihX3SiNyNMTTJsJkYFcAiZ6
         JEQvRPrnU/CsMr7ww9CPWLx+AJiemIkTsPGUWtFTKKEHzV1TSUfwuJ+LqBtK+Lv1hA
         Dm6j28MJXKGUODHcWIx9iSyFjDBhtd/VNC3Ww4j7nf9PuSZ8scg+MOUE4xQZicFYok
         WD0i2vE4uZ1bw==
Subject: [PATCH 14/17] xfs: compute the maximum height of the rmap btree when
 reflink enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:18:11 -0700
Message-ID: <163424269189.756780.15045314476103501683.stgit@magnolia>
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

Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
enough to handle the maximally tall rmap btree when all blocks are in
use and maximally shared, let's compute the maximum height assuming the
rmapbt consumes as many blocks as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c       |   33 +++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h       |    2 ++
 fs/xfs/libxfs/xfs_rmap_btree.c  |   45 +++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_trans_resv.c  |   16 ++++++++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    7 ++++++
 5 files changed, 85 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4d95a3bb05cd..43e646f3956c 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4553,6 +4553,39 @@ xfs_btree_calc_size(
 	return blocks;
 }
 
+/*
+ * Given a number of available blocks for the btree to consume with records and
+ * pointers, calculate the height of the tree needed to index all the records
+ * that space can hold based on the number of pointers each interior node
+ * holds.
+ *
+ * We start by assuming a single level tree consumes a single block, then track
+ * the number of blocks each node level consumes until we no longer have space
+ * to store the next node level. At this point, we are indexing all the leaf
+ * blocks in the space, and there's no more free space to split the tree any
+ * further. That's our maximum btree height.
+ */
+unsigned int
+xfs_btree_space_to_height(
+	const unsigned int	*limits,
+	unsigned long long	leaf_blocks)
+{
+	unsigned long long	node_blocks = limits[1];
+	unsigned long long	blocks_left = leaf_blocks - 1;
+	unsigned int		height = 1;
+
+	if (leaf_blocks < 1)
+		return 0;
+
+	while (node_blocks < blocks_left) {
+		blocks_left -= node_blocks;
+		node_blocks *= limits[1];
+		height++;
+	}
+
+	return height;
+}
+
 /*
  * Query a regular btree for all records overlapping a given interval.
  * Start with a LE lookup of the key of low_rec and return all records
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3bd69fe425a7..e488bfcc1fc0 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -491,6 +491,8 @@ unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
 		unsigned long long records);
 unsigned long long xfs_btree_calc_size(const unsigned int *limits,
 		unsigned long long records);
+unsigned int xfs_btree_space_to_height(const unsigned int *limits,
+		unsigned long long blocks);
 
 /*
  * Return codes for the query range iterator function are 0 to continue
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 1b48b7b3ee30..7388201e48d2 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -540,26 +540,35 @@ void
 xfs_rmapbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
-	/*
-	 * On a non-reflink filesystem, the maximum number of rmap
-	 * records is the number of blocks in the AG, hence the max
-	 * rmapbt height is log_$maxrecs($agblocks).  However, with
-	 * reflink each AG block can have up to 2^32 (per the refcount
-	 * record format) owners, which means that theoretically we
-	 * could face up to 2^64 rmap records.
-	 *
-	 * That effectively means that the max rmapbt height must be
-	 * XFS_BTREE_MAXLEVELS.  "Fortunately" we'll run out of AG
-	 * blocks to feed the rmapbt long before the rmapbt reaches
-	 * maximum height.  The reflink code uses ag_resv_critical to
-	 * disallow reflinking when less than 10% of the per-AG metadata
-	 * block reservation since the fallback is a regular file copy.
-	 */
-	if (xfs_has_reflink(mp))
-		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
-	else
+	if (!xfs_has_rmapbt(mp)) {
+		mp->m_rmap_maxlevels = 0;
+		return;
+	}
+
+	if (xfs_has_reflink(mp)) {
+		/*
+		 * Compute the asymptotic maxlevels for an rmap btree on a
+		 * filesystem that supports reflink.
+		 *
+		 * On a reflink filesystem, each AG block can have up to 2^32
+		 * (per the refcount record format) owners, which means that
+		 * theoretically we could face up to 2^64 rmap records.
+		 * However, we're likely to run out of blocks in the AG long
+		 * before that happens, which means that we must compute the
+		 * max height based on what the btree will look like if it
+		 * consumes almost all the blocks in the AG due to maximal
+		 * sharing factor.
+		 */
+		mp->m_rmap_maxlevels = xfs_btree_space_to_height(mp->m_rmap_mnr,
+				mp->m_sb.sb_agblocks);
+	} else {
+		/*
+		 * If there's no block sharing, compute the maximum rmapbt
+		 * height assuming one rmap record per AG block.
+		 */
 		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
 				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+	}
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index c879e7754ee6..6f83d9b306ee 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -814,6 +814,19 @@ xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+
+	/*
+	 * In the early days of rmap+reflink, we always set the rmap maxlevels
+	 * to 9 even if the AG was small enough that it would never grow to
+	 * that height.  Transaction reservation sizes influence the minimum
+	 * log size calculation, which influences the size of the log that mkfs
+	 * creates.  Use the old value here to ensure that newly formatted
+	 * small filesystems will mount on older kernels.
+	 */
+	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
+		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
+
 	/*
 	 * The following transactions are logged in physical format and
 	 * require a permanent reservation on space.
@@ -916,4 +929,7 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
+
+	/* Put everything back the way it was.  This goes at the end. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
diff --git a/fs/xfs/libxfs/xfs_trans_space.h b/fs/xfs/libxfs/xfs_trans_space.h
index bd04cb836419..87b31c69a773 100644
--- a/fs/xfs/libxfs/xfs_trans_space.h
+++ b/fs/xfs/libxfs/xfs_trans_space.h
@@ -17,6 +17,13 @@
 /* Adding one rmap could split every level up to the top of the tree. */
 #define XFS_RMAPADD_SPACE_RES(mp) ((mp)->m_rmap_maxlevels)
 
+/*
+ * Note that we historically set m_rmap_maxlevels to 9 when reflink is enabled,
+ * so we must preserve this behavior to avoid changing the transaction space
+ * reservations and minimum log size calculations for existing filesystems.
+ */
+#define XFS_OLD_REFLINK_RMAP_MAXLEVELS		9
+
 /* Blocks we might need to add "b" rmaps to a tree. */
 #define XFS_NRMAPADD_SPACE_RES(mp, b)\
 	(((b + XFS_MAX_CONTIG_RMAPS_PER_BLOCK(mp) - 1) / \

