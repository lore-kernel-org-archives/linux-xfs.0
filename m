Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAABC433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2FDC60EB6
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Oct 2021 23:33:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235640AbhJLXfP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Oct 2021 19:35:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234129AbhJLXfO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 12 Oct 2021 19:35:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A09960E53;
        Tue, 12 Oct 2021 23:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634081592;
        bh=cS2TPX7Hdf+X5nAStlCWZqcdFHUlsDAf70yMWNuhkTU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=C9n0P1XHbnrIGVUNmQSQMldf1l41agFulfHycjxen0vW0RbuPAJRdsvCP2ktMAQPL
         pwFmfXH1B60DYBbC6iqBCfLV+1s0dLYv5Bu/xrcwKycDyc1ZkWO6yx8vY7xhWjmm2V
         gsxju+o63HLwGP0vAkVoSTuiDKF3t7MmBymSRvUKAN4jjTk+lv8PpQDZWM/TKGde8a
         Q2EhngtGDyXpDOC0yvgyiGY+HkjlCapNT+x020uBoLG8+Apg4tmpK1UcmOskIGUsGN
         I0R+ohUhtpTJTPUaATXy/GYWMFEJ8CuNPUFC71C+DhCL1gCsz8pHZWC2nHDX3gBUZf
         zFMmVPbNFjDyw==
Subject: [PATCH 07/15] xfs: refactor btree cursor allocation function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Tue, 12 Oct 2021 16:33:12 -0700
Message-ID: <163408159230.4151249.14190118477095749260.stgit@magnolia>
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

Refactor btree allocation to a common helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 +-----
 fs/xfs/libxfs/xfs_bmap_btree.c     |    6 +-----
 fs/xfs/libxfs/xfs_btree.h          |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    5 +----
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    5 +----
 6 files changed, 21 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 152ed2a202f4..c644b11132f6 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -477,11 +477,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index a43dea8d6a65..a06987e36db5 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -552,12 +552,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
-	cur->bc_btnum = XFS_BTNUM_BMAP;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
 	cur->bc_ops = &xfs_bmbt_ops;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 613f7a303cc6..76509e819d60 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -573,4 +573,20 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
 		union xfs_btree_key *dst_key,
 		const union xfs_btree_key *src_key, int numkeys);
 
+static inline struct xfs_btree_cur *
+xfs_btree_alloc_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_btnum_t		btnum)
+{
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = btnum;
+
+	return cur;
+}
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 10736b89b679..c8fea6a464d5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -432,10 +432,7 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = btnum;
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 3ea589f15b14..48c45e31d897 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -322,10 +322,7 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
-	cur->bc_btnum = XFS_BTNUM_REFC;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d65bf3c6f25e..f3c4d0965cc9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -451,11 +451,8 @@ xfs_rmapbt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
-	cur->bc_tp = tp;
-	cur->bc_mp = mp;
 	/* Overlapping btree; 2 keys per pointer. */
-	cur->bc_btnum = XFS_BTNUM_RMAP;
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;

