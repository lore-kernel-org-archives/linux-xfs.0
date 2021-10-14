Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 759A0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C96D610D2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbhJNUTu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUTu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0DD361156;
        Thu, 14 Oct 2021 20:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242664;
        bh=Mutjej5hD5L8PNMFsnCGrEssbTAFK71XV7jc731s0R4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cg88s0roy8BGZUi1hWUtanpHVVSCz4CUkZqeML2Bxj+o90DJSpwjJImPjzF5GtkwS
         U+sKzswgeB/K0gAiYQ5Os2ZfXeWM32qTWtCLA9t/eIi39WzFlQ9FrxSGhcALu5n5K7
         QSBZq+BZ3Ey1PvSJFOKPb/a9f+6O4r9PChcHAAOZ4JrEHh2MQ5rTTDeVYubS1xfL7+
         +t212lASAZ7dh9xxb2qLkrYSubOG7CYYgcKt4m9tD1yhIVQcfmDZhFqH0tPyc6jzAp
         1xvG9bFBqIEHiiIEpcc7w2bPR6EHdqUeQGEq7I0BRiqJ2Gj5BmqcYZyilSXnseZHeA
         iUmgiibX2iCSQ==
Subject: [PATCH 09/17] xfs: encode the max btree height in the cursor
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:44 -0700
Message-ID: <163424266448.756780.13527962920227704176.stgit@magnolia>
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

Encode the maximum btree height in the cursor, since we're soon going to
allow smaller cursors for AG btrees and larger cursors for file btrees.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c          |    2 +-
 fs/xfs/libxfs/xfs_btree.c         |    4 ++--
 fs/xfs/libxfs/xfs_btree.h         |    2 ++
 fs/xfs/libxfs/xfs_btree_staging.c |   10 +++++-----
 4 files changed, 10 insertions(+), 8 deletions(-)


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
index 25dfab81025f..6ced8f028d47 100644
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8e78ede87b16..ed0b7d5ab3a3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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

