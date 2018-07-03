Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:54064 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934222AbeGCRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0F7F544D00
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:21 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE1801117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/25] xfs: use ->t_firstblock in bmap extent split
Date: Tue,  3 Jul 2018 13:23:08 -0400
Message-Id: <20180703172319.24509-15-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Also remove the unnecessary xfs_bmap_split_extent_at() parameter.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c9023c08a78d..43157e5ff46b 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5880,8 +5880,7 @@ STATIC int
 xfs_bmap_split_extent_at(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
-	xfs_fileoff_t		split_fsb,
-	xfs_fsblock_t		*firstfsb)
+	xfs_fileoff_t		split_fsb)
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
@@ -5930,7 +5929,7 @@ xfs_bmap_split_extent_at(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = *firstfsb;
+		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
@@ -5974,8 +5973,8 @@ xfs_bmap_split_extent_at(
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, &cur, 0,
-				&tmp_logflags, whichfork);
+		error = xfs_bmap_extents_to_btree(tp, ip, &tp->t_firstblock,
+				&cur, 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
 
@@ -5999,20 +5998,18 @@ xfs_bmap_split_extent(
 	struct xfs_mount        *mp = ip->i_mount;
 	struct xfs_trans        *tp;
 	struct xfs_defer_ops    dfops;
-	xfs_fsblock_t           firstfsb;
 	int                     error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write,
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
-	xfs_defer_init(tp, &dfops, &firstfsb);
+	xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
-					 &firstfsb);
+	error = xfs_bmap_split_extent_at(tp, ip, split_fsb);
 	if (error)
 		goto out;
 
-- 
2.17.1

