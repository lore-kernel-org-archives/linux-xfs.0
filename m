Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:37428 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S934191AbeGCRXV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 3 Jul 2018 13:23:21 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E76DD8182D38
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D28FC1117629
        for <linux-xfs@vger.kernel.org>; Tue,  3 Jul 2018 17:23:20 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 13/25] xfs: remove bmap insert/collapse firstblock param
Date: Tue,  3 Jul 2018 13:23:07 -0400
Message-Id: <20180703172319.24509-14-bfoster@redhat.com>
In-Reply-To: <20180703172319.24509-1-bfoster@redhat.com>
References: <20180703172319.24509-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The only callers pass ->t_firstblock.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 10 ++++------
 fs/xfs/libxfs/xfs_bmap.h |  4 ++--
 fs/xfs/xfs_bmap_util.c   |  4 ++--
 3 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 967d12f9e415..c9023c08a78d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5654,8 +5654,7 @@ xfs_bmap_collapse_extents(
 	struct xfs_inode	*ip,
 	xfs_fileoff_t		*next_fsb,
 	xfs_fileoff_t		offset_shift_fsb,
-	bool			*done,
-	xfs_fsblock_t		*firstblock)
+	bool			*done)
 {
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -5688,7 +5687,7 @@ xfs_bmap_collapse_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
@@ -5775,8 +5774,7 @@ xfs_bmap_insert_extents(
 	xfs_fileoff_t		*next_fsb,
 	xfs_fileoff_t		offset_shift_fsb,
 	bool			*done,
-	xfs_fileoff_t		stop_fsb,
-	xfs_fsblock_t		*firstblock)
+	xfs_fileoff_t		stop_fsb)
 {
 	int			whichfork = XFS_DATA_FORK;
 	struct xfs_mount	*mp = ip->i_mount;
@@ -5809,7 +5807,7 @@ xfs_bmap_insert_extents(
 
 	if (ifp->if_flags & XFS_IFBROOT) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
-		cur->bc_private.b.firstblock = *firstblock;
+		cur->bc_private.b.firstblock = tp->t_firstblock;
 		cur->bc_private.b.flags = 0;
 	}
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 14e21dcc3044..fa839679ecb6 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -220,12 +220,12 @@ void	xfs_bmap_del_extent_cow(struct xfs_inode *ip,
 uint	xfs_default_attroffset(struct xfs_inode *ip);
 int	xfs_bmap_collapse_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
-		bool *done, xfs_fsblock_t *firstblock);
+		bool *done);
 int	xfs_bmap_can_insert_extents(struct xfs_inode *ip, xfs_fileoff_t off,
 		xfs_fileoff_t shift);
 int	xfs_bmap_insert_extents(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_fileoff_t *next_fsb, xfs_fileoff_t offset_shift_fsb,
-		bool *done, xfs_fileoff_t stop_fsb, xfs_fsblock_t *firstblock);
+		bool *done, xfs_fileoff_t stop_fsb);
 int	xfs_bmap_split_extent(struct xfs_inode *ip, xfs_fileoff_t split_offset);
 int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t off, xfs_filblks_t len, xfs_filblks_t prealloc,
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3675babb5202..6d2baf51fec9 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1342,7 +1342,7 @@ xfs_collapse_file_space(
 
 		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 		error = xfs_bmap_collapse_extents(tp, ip, &next_fsb, shift_fsb,
-				&done, &tp->t_firstblock);
+				&done);
 		if (error)
 			goto out_bmap_cancel;
 
@@ -1420,7 +1420,7 @@ xfs_insert_file_space(
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 		xfs_defer_init(tp, &dfops, &tp->t_firstblock);
 		error = xfs_bmap_insert_extents(tp, ip, &next_fsb, shift_fsb,
-				&done, stop_fsb, &tp->t_firstblock);
+				&done, stop_fsb);
 		if (error)
 			goto out_bmap_cancel;
 
-- 
2.17.1

