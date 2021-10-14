Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AF9C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8016B610D2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhJNUTz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:35352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhJNUTz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F40D61151;
        Thu, 14 Oct 2021 20:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242670;
        bh=H+bbEUsgMxI6FMqNakaLARSZATsi82KgNsGdRkvfukY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=hu5ZdmPTqLF1IdmtPj8CEonHAmvOUvlK6rJuVlvWaPimELH/uRsprbzfmzXpHHSHm
         /GPIAT2yrEIfunulUq9UYZTdIfVyW57vafvy7bQXwtM5cG4jdlpHo35GMirYtc39xc
         fiTKQyQExTxWetGsUhK52kTIy0yzNR+WTLknvi5Iryoy1HWfR+bPF9I6Bfk39Jhe8z
         GOASNteXGfDsivReWZ2Awj3p1Q5ffJLPUrOwG5FINIhNZPhe5c5O0xKn5q4kkJRSWN
         rQCGOjJU+keOFRObZe2umha/H72UK8w/f6P7K/JRPBzpZibjdehK8StULcT53KvYsx
         UCfBDJ6bvoF5w==
Subject: [PATCH 10/17] xfs: dynamically allocate cursors based on maxlevels
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:50 -0700
Message-ID: <163424266996.756780.17231850564754674979.stgit@magnolia>
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

To support future btree code, we need to be able to size btree cursors
dynamically for very large btrees.  Switch the maxlevels computation to
use the precomputed values in the superblock, and create cursors that
can handle a certain height.  For now, we retain the btree cursor cache
that can handle up to 9-level btrees, though a subsequent patch
introduces separate caches for each btree type, where each cache's
objects will be exactly tall enough to handle the specific btree type.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    3 ++-
 fs/xfs/libxfs/xfs_btree.h          |   13 +++++++++++--
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    3 ++-
 fs/xfs/libxfs/xfs_refcount_btree.c |    3 ++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    3 ++-
 fs/xfs/xfs_super.c                 |    4 ++--
 7 files changed, 22 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index c644b11132f6..f14bad21503f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -477,7 +477,7 @@ xfs_allocbt_init_common(
 
 	ASSERT(btnum == XFS_BTNUM_BNO || btnum == XFS_BTNUM_CNT);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum, mp->m_ag_maxlevels);
 	cur->bc_ag.abt.active = false;
 
 	if (btnum == XFS_BTNUM_CNT) {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index a06987e36db5..b90122de0df0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -552,7 +552,8 @@ xfs_bmbt_init_cursor(
 	struct xfs_btree_cur	*cur;
 	ASSERT(whichfork != XFS_COW_FORK);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_BMAP,
+			mp->m_bm_maxlevels[whichfork]);
 	cur->bc_nlevels = be16_to_cpu(ifp->if_broot->bb_level) + 1;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_bmbt_2);
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index ed0b7d5ab3a3..b46cd98309fa 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -94,6 +94,12 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 
 #define	XFS_BTREE_MAXLEVELS	9	/* max of all btrees */
 
+/*
+ * The btree cursor zone hands out cursors that can handle up to this many
+ * levels.  This is the known maximum for all btree types.
+ */
+#define XFS_BTREE_CUR_CACHE_MAXLEVELS	(9)
+
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
@@ -583,15 +589,18 @@ static inline struct xfs_btree_cur *
 xfs_btree_alloc_cursor(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
-	xfs_btnum_t		btnum)
+	xfs_btnum_t		btnum,
+	uint8_t			maxlevels)
 {
 	struct xfs_btree_cur	*cur;
 
+	ASSERT(maxlevels <= XFS_BTREE_CUR_CACHE_MAXLEVELS);
+
 	cur = kmem_cache_zalloc(xfs_btree_cur_zone, GFP_NOFS | __GFP_NOFAIL);
 	cur->bc_tp = tp;
 	cur->bc_mp = mp;
 	cur->bc_btnum = btnum;
-	cur->bc_maxlevels = XFS_BTREE_MAXLEVELS;
+	cur->bc_maxlevels = maxlevels;
 
 	return cur;
 }
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index c8fea6a464d5..3a5a24648b87 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -432,7 +432,8 @@ xfs_inobt_init_common(
 {
 	struct xfs_btree_cur	*cur;
 
-	cur = xfs_btree_alloc_cursor(mp, tp, btnum);
+	cur = xfs_btree_alloc_cursor(mp, tp, btnum,
+			M_IGEO(mp)->inobt_maxlevels);
 	if (btnum == XFS_BTNUM_INO) {
 		cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_ibt_2);
 		cur->bc_ops = &xfs_inobt_ops;
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 48c45e31d897..995b0d86ddc0 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -322,7 +322,8 @@ xfs_refcountbt_init_common(
 
 	ASSERT(pag->pag_agno < mp->m_sb.sb_agcount);
 
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_REFC,
+			mp->m_refc_maxlevels);
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_refcbt_2);
 
 	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index f3c4d0965cc9..1b48b7b3ee30 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -452,7 +452,8 @@ xfs_rmapbt_init_common(
 	struct xfs_btree_cur	*cur;
 
 	/* Overlapping btree; 2 keys per pointer. */
-	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP);
+	cur = xfs_btree_alloc_cursor(mp, tp, XFS_BTNUM_RMAP,
+			mp->m_rmap_maxlevels);
 	cur->bc_flags = XFS_BTREE_CRC_BLOCKS | XFS_BTREE_OVERLAPPING;
 	cur->bc_statoff = XFS_STATS_CALC_INDEX(xs_rmap_2);
 	cur->bc_ops = &xfs_rmapbt_ops;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 30bae0657343..2a535a8bc3c0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1966,8 +1966,8 @@ xfs_init_zones(void)
 		goto out_destroy_log_ticket_zone;
 
 	xfs_btree_cur_zone = kmem_cache_create("xfs_btree_cur",
-				xfs_btree_cur_sizeof(XFS_BTREE_MAXLEVELS),
-					       0, 0, NULL);
+			xfs_btree_cur_sizeof(XFS_BTREE_CUR_CACHE_MAXLEVELS),
+			0, 0, NULL);
 	if (!xfs_btree_cur_zone)
 		goto out_destroy_bmap_free_item_zone;
 

