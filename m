Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B760DC433F5
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 979256113A
	for <linux-xfs@archiver.kernel.org>; Sat, 18 Sep 2021 01:30:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234786AbhIRBb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Sep 2021 21:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234515AbhIRBb1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 Sep 2021 21:31:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3BDA6112E;
        Sat, 18 Sep 2021 01:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631928605;
        bh=1Su6Y3wVdkndP0RCdgw2dB+4wUDdCS9/JLiGewn21Dk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZnrvPQqsQuSsJd3Zop5igI5whOUziteVsuYVAgXJ/UCYAxFQAH7XwkpjrHpbRmjky
         s0qOvletHfr8Zghh9ohiysuXxYz8QwS/H5IaiSXWDdwf8aq3Qv4VCMOtPzQ+k5PHg5
         IFnEcqxe2zJE5LT+MntXLWBiiP/budjLfeWqxjXOL4087jjSEfg86t56kVC+vANnLo
         HwBNOyBj5G4l6uTSvM89Dw19Cr39RR06H0qGRjoaJjWAC1HPZ4RfsaCK188h9EeLXz
         l0EzDErKpBHUpZrHOWI7AcQSruNH5UFWOE/ZwN51EC0B8Tzs2zDDGtMv1P7q6FQv0s
         N4uhXYDrtq4Gg==
Subject: [PATCH 10/14] xfs: encode the max btree height in the cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 17 Sep 2021 18:30:04 -0700
Message-ID: <163192860467.416199.3157992669504614921.stgit@magnolia>
In-Reply-To: <163192854958.416199.3396890438240296942.stgit@magnolia>
References: <163192854958.416199.3396890438240296942.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Encode the maximum btree height in the cursor, since we're soon going to
allow smaller cursors for AG btrees and larger cursors for file btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c          |    2 +-
 fs/xfs/libxfs/xfs_btree.c         |    5 +++--
 fs/xfs/libxfs/xfs_btree.h         |    3 ++-
 fs/xfs/libxfs/xfs_btree_staging.c |   10 +++++-----
 4 files changed, 11 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 644b956301b6..2ae5bf9a74e7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -239,7 +239,7 @@ xfs_bmap_get_bp(
 	if (!cur)
 		return NULL;
 
-	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
+	for (i = 0; i < cur->bc_maxlevels; i++) {
 		if (!cur->bc_levels[i].bp)
 			break;
 		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 70785004414e..2486ba22c01d 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2933,7 +2933,7 @@ xfs_btree_new_iroot(
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	cur->bc_levels[level + 1].ptr = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3097,7 +3097,7 @@ xfs_btree_new_root(
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	*stat = 1;
 	return 0;
 error0:
@@ -4941,6 +4941,7 @@ xfs_btree_alloc_cursor(
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6540c4957c36..6075918efa0c 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -235,9 +235,10 @@ struct xfs_btree_cur
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
 	uint			bc_flags; /* btree features - below */
-	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
+	uint8_t		bc_maxlevels;	/* maximum levels for this btree type */
 	uint8_t		bc_nlevels;	/* number of levels in the tree */
 	uint8_t		bc_blocklog;	/* log2(blocksize) of btree blocks */
+	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
 	int		bc_statoff;	/* offset of btre stats array */
 
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index cc56efc2b90a..dd75e208b543 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -657,12 +657,12 @@ xfs_btree_bload_compute_geometry(
 	 * checking levels 0 and 1 here, so set bc_nlevels such that the btree
 	 * code doesn't interpret either as the root level.
 	 */
-	cur->bc_nlevels = XFS_BTREE_MAXLEVELS - 1;
+	cur->bc_nlevels = cur->bc_maxlevels - 1;
 	xfs_btree_bload_ensure_slack(cur, &bbl->leaf_slack, 0);
 	xfs_btree_bload_ensure_slack(cur, &bbl->node_slack, 1);
 
 	bbl->nr_records = nr_this_level = nr_records;
-	for (cur->bc_nlevels = 1; cur->bc_nlevels <= XFS_BTREE_MAXLEVELS;) {
+	for (cur->bc_nlevels = 1; cur->bc_nlevels <= cur->bc_maxlevels;) {
 		uint64_t	level_blocks;
 		uint64_t	dontcare64;
 		unsigned int	level = cur->bc_nlevels - 1;
@@ -703,7 +703,7 @@ xfs_btree_bload_compute_geometry(
 			 * block-based btree level.
 			 */
 			cur->bc_nlevels++;
-			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 			xfs_btree_bload_level_geometry(cur, bbl, level,
 					nr_this_level, &avg_per_block,
 					&level_blocks, &dontcare64);
@@ -719,14 +719,14 @@ xfs_btree_bload_compute_geometry(
 
 			/* Otherwise, we need another level of btree. */
 			cur->bc_nlevels++;
-			ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+			ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 		}
 
 		nr_blocks += level_blocks;
 		nr_this_level = level_blocks;
 	}
 
-	if (cur->bc_nlevels > XFS_BTREE_MAXLEVELS)
+	if (cur->bc_nlevels > cur->bc_maxlevels)
 		return -EOVERFLOW;
 
 	bbl->btree_height = cur->bc_nlevels;

