Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CCDC433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8400D61214
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Sep 2021 01:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243740AbhIXB2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 21:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243758AbhIXB2o (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 23 Sep 2021 21:28:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A970461211;
        Fri, 24 Sep 2021 01:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632446832;
        bh=wKxrWdRUHROHcDVaVbZyqhtXNYAP471PX4FmYC23Hpc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=slmKO1NYhwotHOv3YeYTMhQt6HRCC94EzYmGpPJgeVuqnZJDcFxmb/VOZJak2qcl5
         EtDwo+viOlQuGzv/WvQ4pBbMrTrgaUvDHfF0A+LhcqOXTQFJk+rcMALqEE0tqzhGNQ
         cRwXtoAVHgP1lGIjC+EM6b0Z3jRcn+2qsVIwU3G0XER1ts0xe+JLP1rmNfZuTS698g
         qs9kp/SueUIOIZna2ClYB4RQlsc/kbhnNNkhp8jW+DON9kAzabVTNjg9nfWOF755CU
         iQMFGx+VtDPBuCJEn/pTVS+BuBlVGTg7YkxnN6FPL9X4vo3/YeD+NHBUBt3VM3zyQE
         r+YHcRlK3Vrug==
Subject: [PATCH 11/15] xfs: encode the max btree height in the cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@oracle.com, chandanrlinux@gmail.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Thu, 23 Sep 2021 18:27:12 -0700
Message-ID: <163244683240.2701302.16015151458314514191.stgit@magnolia>
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

Encode the maximum btree height in the cursor, since we're soon going to
allow smaller cursors for AG btrees and larger cursors for file btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index 36df4b9da2ee..0c86209a54df 100644
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
@@ -4945,6 +4945,7 @@ xfs_btree_alloc_cursor(
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
 	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 328dd9c50c59..3b396edd1a4f 100644
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

