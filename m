Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1D16C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 98534610D2
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 20:17:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbhJNUTp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:35232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229912AbhJNUTo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 16:19:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE2561108;
        Thu, 14 Oct 2021 20:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634242659;
        bh=ShKjU/15lsqv2hDyQF47q+Vs95x6acyARYtYSHLWLAo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WmsXAgeH61zAE0QRV+QyTZ+xFQ6bYeGRJDdVtZqe8T9rRM/VxT4tCwb/u0E5CI0DW
         f8D4FdOGSweIOMSS+h7KCW+/GdhMXp6uTUfbF1w2e69CB+KyFRXdc1dz6+6ujMEf6u
         +bDyx7spkHkD3+JtIk8u4bMFoBc6jbC3D6Ha/PBLOdkyEZOe6rIIn8V9QNP9e77NZx
         8nyjZizOxjnUgB1rjaGZ2K9IhP0lISnKBfYQKXqKEkg8foRjnV+h8LI2KKGWpuxDLT
         Xrb9INsQrC8NzJz/pzMKQUQtfP9jMXarQId3UYSrWcOsr7NWFXt4NuvCBP6dgnzC62
         KREdpZgRreEYw==
Subject: [PATCH 08/17] xfs: refactor btree cursor allocation function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        chandan.babu@oracle.com, hch@lst.de
Date:   Thu, 14 Oct 2021 13:17:39 -0700
Message-ID: <163424265899.756780.18387240829988701889.stgit@magnolia>
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

Refactor btree allocation to a common helper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index eaffd8223ce6..8e78ede87b16 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -578,4 +578,20 @@ void xfs_btree_copy_keys(struct xfs_btree_cur *cur,
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

