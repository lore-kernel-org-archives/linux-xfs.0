Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25531C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 034A460F92
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbhJLXfh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235541AbhJLXfg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0CC860F3A;
        Tue, 12 Oct 2021 23:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081614;
        bh=4F2oy9Mc/dhi8H9PEv2juPDUCg/nsJo6mvhzvtgoxs4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C6U8J1Ps+Cwi+eO+hE9975IVh1WWfPCAj+RU6mgOkX8qTNffnIP5VLj8yGXIfyLEz
         NgAy8iTGWKPc0ojZgT4JvD5VE/R2B1T7ljxETlMulaGkczSwMd1WL+8mnjS0yKo3yy
         QkRn/gdTazOyV5pERAczIRV/eUDHzSiJA09glKuTRFafl6ugXl4qz2vGdrtbfhV7SD
         If7qUhgMUdW7Q3CWbTfWdRDo00dhXOcme4XPDcSvpTO2Rs4qDobYVhmbIKoj/0fDMf
         aX5CAo9EtZmDBNvgw0RF6/1ma5PTnOLlBXDh+Bu4xVv2VeBUTM3vmAvYugd6DTszHQ
         BzySU1etXIFSQ==
Subject: [PATCH 11/15] xfs: compute the maximum height of the rmap btree when
 reflink enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:34 -0700
Message-ID: <163408161434.4151249.874557928540897102.stgit@magnolia>
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

Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
enough to handle the maximally tall rmap btree when all blocks are in
use and maximally shared, let's compute the maximum height assuming the
rmapbt consumes as many blocks as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c       |   34 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h       |    2 +
 fs/xfs/libxfs/xfs_rmap_btree.c  |   55 ++++++++++++++++++++++++---------------
 fs/xfs/libxfs/xfs_trans_resv.c  |   13 +++++++++
 fs/xfs/libxfs/xfs_trans_space.h |    7 +++++
 5 files changed, 90 insertions(+), 21 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 6ced8f028d47..201b81d54622 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4531,6 +4531,40 @@ xfs_btree_compute_maxlevels(
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
index b8761a2fc24b..fccb374a8399 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -483,6 +483,8 @@ xfs_failaddr_t xfs_btree_lblock_verify(struct xfs_buf *bp,
 		unsigned int max_recs);
 
 uint xfs_btree_compute_maxlevels(uint *limits, unsigned long len);
+unsigned int xfs_btree_compute_maxlevels_size(unsigned long long max_btblocks,
+		unsigned int leaf_mnr);
 unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 1b48b7b3ee30..b1b55a6e7d25 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -538,28 +538,41 @@ xfs_rmapbt_maxrecs(
 /* Compute the maximum height of an rmap btree. */
 void
 xfs_rmapbt_compute_maxlevels(
-	struct xfs_mount		*mp)
+	struct xfs_mount	*mp)
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
-		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(
-				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+	unsigned int		val;
+
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
+		val = xfs_btree_compute_maxlevels_size(mp->m_sb.sb_agblocks,
+				mp->m_rmap_mnr[1]);
+	} else {
+		/*
+		 * If there's no block sharing, compute the maximum rmapbt
+		 * height assuming one rmap record per AG block.
+		 */
+		val = xfs_btree_compute_maxlevels(mp->m_rmap_mnr,
+				mp->m_sb.sb_agblocks);
+	}
+
+	mp->m_rmap_maxlevels = val;
 }
 
 /* Calculate the refcount btree size for some records. */
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 5e300daa2559..97bd17d84a23 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -814,6 +814,16 @@ xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
 	struct xfs_trans_resv	*resp)
 {
+	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
+
+	/*
+	 * In the early days of rmap+reflink, we always set the rmap maxlevels
+	 * to 9 even if the AG was small enough that it would never grow to
+	 * that height.
+	 */
+	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
+		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
+
 	/*
 	 * The following transactions are logged in physical format and
 	 * require a permanent reservation on space.
@@ -916,4 +926,7 @@ xfs_trans_resv_calc(
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

