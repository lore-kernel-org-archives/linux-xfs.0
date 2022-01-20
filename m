Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259F6C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiATAYz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240515AbiATAYz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:24:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A3AEC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12B1DB81911
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1361C004E1;
        Thu, 20 Jan 2022 00:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638291;
        bh=2TCNpExBva2JGev8dxDo/kR6gr+TIhLd95Kw5tZUD20=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JK6E2Obfx5shUMlqzn7DzWVXAYUWezI1xMqeDbdY2raY9iKMxFm+z5vMEP4JYtYiQ
         I1vGdzOLQ9zxZk9KwvN+ybpfRoZDMWubq3DMA1pjzJXA+X2LHRLxjqY+xEo8MkvHUd
         Z1fOuC/qfSC3/hO3aUUgCaz8qTyYKHaIA7Zd91XY+TsgEVmYeK2Bdt2T8htL+PF7B1
         AaH971X6tqSWd4V0v2XlfrGmItQ4XtgsLgis1M0becO1MautHampq//ePqVMSV7icC
         WIM50xvqWMO0dXqqJyFmitI+9OBN+t0LY9MH9FaUdV5EuZF3Hxj9dq965ZLWl2nX4t
         qn/sM0JsB+mOQ==
Subject: [PATCH 18/48] xfs: encode the max btree height in the cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:24:51 -0800
Message-ID: <164263829136.865554.15536525914271312006.stgit@magnolia>
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

Source kernel commit: c0643f6fdd6d3c448142ed1492a9a6b6505f9afb

Encode the maximum btree height in the cursor, since we're soon going to
allow smaller cursors for AG btrees and larger cursors for file btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c          |    2 +-
 libxfs/xfs_btree.c         |    4 ++--
 libxfs/xfs_btree.h         |    2 ++
 libxfs/xfs_btree_staging.c |   10 +++++-----
 4 files changed, 10 insertions(+), 8 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index fa8d6880..3b8b1b61 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -232,7 +232,7 @@ xfs_bmap_get_bp(
 	if (!cur)
 		return NULL;
 
-	for (i = 0; i < XFS_BTREE_MAXLEVELS; i++) {
+	for (i = 0; i < cur->bc_maxlevels; i++) {
 		if (!cur->bc_levels[i].bp)
 			break;
 		if (xfs_buf_daddr(cur->bc_levels[i].bp) == bno)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2e144dc2..6a049c64 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2934,7 +2934,7 @@ xfs_btree_new_iroot(
 	be16_add_cpu(&block->bb_level, 1);
 	xfs_btree_set_numrecs(block, 1);
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	cur->bc_levels[level + 1].ptr = 1;
 
 	kp = xfs_btree_key_addr(cur, 1, block);
@@ -3098,7 +3098,7 @@ xfs_btree_new_root(
 	xfs_btree_setbuf(cur, cur->bc_nlevels, nbp);
 	cur->bc_levels[cur->bc_nlevels].ptr = nptr;
 	cur->bc_nlevels++;
-	ASSERT(cur->bc_nlevels <= XFS_BTREE_MAXLEVELS);
+	ASSERT(cur->bc_nlevels <= cur->bc_maxlevels);
 	*stat = 1;
 	return 0;
 error0:
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 8e78ede8..ed0b7d5a 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -238,6 +238,7 @@ struct xfs_btree_cur
 	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
 	uint8_t			bc_nlevels; /* number of levels in the tree */
+	uint8_t			bc_maxlevels; /* maximum levels for this btree type */
 	int			bc_statoff; /* offset of btree stats array */
 
 	/*
@@ -590,6 +591,7 @@ xfs_btree_alloc_cursor(
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
+	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
 
 	return cur;
 }
diff --git a/libxfs/xfs_btree_staging.c b/libxfs/xfs_btree_staging.c
index aa3d49cf..a6a90791 100644
--- a/libxfs/xfs_btree_staging.c
+++ b/libxfs/xfs_btree_staging.c
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

