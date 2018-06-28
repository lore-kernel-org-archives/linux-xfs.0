Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:42028 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935590AbeF1Qgi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jun 2018 12:36:38 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A3180DC3E
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E344111CA17
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jun 2018 16:36:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 08/24] xfs: use ->t_dfops in extent split tx and remove param
Date: Thu, 28 Jun 2018 12:36:20 -0400
Message-Id: <20180628163636.52564-9-bfoster@redhat.com>
In-Reply-To: <20180628163636.52564-1-bfoster@redhat.com>
References: <20180628163636.52564-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Attach the local dfops to ->t_dfops of the extent split transaction.
Since this is the only caller of xfs_bmap_split_extent_at(), remove
the dfops parameter as well.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c4b81fee2dee..dbd07b0adfa3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5921,8 +5921,7 @@ xfs_bmap_split_extent_at(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		split_fsb,
-	xfs_fsblock_t		*firstfsb,
-	struct xfs_defer_ops	*dfops)
+	xfs_fsblock_t		*firstfsb)
 {
 	int				whichfork = XFS_DATA_FORK;
 	struct xfs_btree_cur		*cur = NULL;
@@ -5972,7 +5971,7 @@ xfs_bmap_split_extent_at(
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_private.b.firstblock = *firstfsb;
-		cur->bc_private.b.dfops = dfops;
+		cur->bc_private.b.dfops = tp->t_dfops;
 		cur->bc_private.b.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
 		if (error)
@@ -6016,7 +6015,7 @@ xfs_bmap_split_extent_at(
 		int tmp_logflags; /* partial log flag return val */
 
 		ASSERT(cur == NULL);
-		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, dfops,
+		error = xfs_bmap_extents_to_btree(tp, ip, firstfsb, tp->t_dfops,
 				&cur, 0, &tmp_logflags, whichfork);
 		logflags |= tmp_logflags;
 	}
@@ -6048,14 +6047,14 @@ xfs_bmap_split_extent(
 			XFS_DIOSTRAT_SPACE_RES(mp, 0), 0, 0, &tp);
 	if (error)
 		return error;
+	xfs_defer_init(&dfops, &firstfsb);
+	tp->t_dfops = &dfops;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	xfs_defer_init(&dfops, &firstfsb);
-
 	error = xfs_bmap_split_extent_at(tp, ip, split_fsb,
-			&firstfsb, &dfops);
+					 &firstfsb);
 	if (error)
 		goto out;
 
-- 
2.17.1

