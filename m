Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F256C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbiATAZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345328AbiATAZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:25:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD430C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:25:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 741DCB81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E4DC004E1;
        Thu, 20 Jan 2022 00:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638319;
        bh=HpaQ+N6zmlazrfbtQbqYh7s/WecuMB4cO78CjO9T4P0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lvWzb3TX8CykXTlDBPFGsfNhb/Bjj7aXM1ZBK25NLh2lEKyzvf/1uxcTSmp0nDAnG
         7GKPKPlo4q8uabupMbVig5/s0KXD5nBcOEtTxTen275ff1ab704JYeJ6ssjUgBs37T
         Q5d2d9R8noreG/3R2UjP+fNv/zS4fcoOp9/gQ6r5QBzqO8CT0FQYarF8SBuU1CtkrP
         2/sHxCBz+9IqjB2aWfEpKuUnJh5iQnQbl9HqIJVKunhw1PVQ7HD6d+yjZv2+IjrS8A
         vX3T7JVPnzV4YDIs1lMe/74EMUGKUKcmBAkSfVC/sE6cB5nMpNJ5iGhdZMYFbJZnf0
         S4nync4yaL2KQ==
Subject: [PATCH 23/48] xfs: compute the maximum height of the rmap btree when
 reflink enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:25:18 -0800
Message-ID: <164263831887.865554.15211463222474360893.stgit@magnolia>
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

Source kernel commit: 9ec691205e7d4a11190519df6561a168ae6af3a4

Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
enough to handle the maximally tall rmap btree when all blocks are in
use and maximally shared, let's compute the maximum height assuming the
rmapbt consumes as many blocks as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_btree.c       |   33 +++++++++++++++++++++++++++++++++
 libxfs/xfs_btree.h       |    2 ++
 libxfs/xfs_rmap_btree.c  |   45 +++++++++++++++++++++++++++------------------
 libxfs/xfs_trans_resv.c  |   16 ++++++++++++++++
 libxfs/xfs_trans_space.h |    7 +++++++
 5 files changed, 85 insertions(+), 18 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5ada6cc4..e541b061 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4554,6 +4554,39 @@ xfs_btree_calc_size(
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 3bd69fe4..e488bfcc 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -491,6 +491,8 @@ unsigned int xfs_btree_compute_maxlevels(const unsigned int *limits,
 		unsigned long long records);
 unsigned long long xfs_btree_calc_size(const unsigned int *limits,
 		unsigned long long records);
+unsigned int xfs_btree_space_to_height(const unsigned int *limits,
+		unsigned long long blocks);
 
 /*
  * Return codes for the query range iterator function are 0 to continue
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 4c281b71..eeaa1e28 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -538,26 +538,35 @@ void
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
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 68daefd4..61a0a1ac 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -813,6 +813,19 @@ xfs_trans_resv_calc(
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
@@ -915,4 +928,7 @@ xfs_trans_resv_calc(
 	resp->tr_clearagi.tr_logres = xfs_calc_clear_agi_bucket_reservation(mp);
 	resp->tr_growrtzero.tr_logres = xfs_calc_growrtzero_reservation(mp);
 	resp->tr_growrtfree.tr_logres = xfs_calc_growrtfree_reservation(mp);
+
+	/* Put everything back the way it was.  This goes at the end. */
+	mp->m_rmap_maxlevels = rmap_maxlevels;
 }
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index bd04cb83..87b31c69 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
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

