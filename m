Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:50992 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756041AbeEaSIT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 May 2018 14:08:19 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/21] xfs: move locking into xfs_bmap_punch_delalloc_range
Date: Thu, 31 May 2018 20:07:43 +0200
Message-Id: <20180531180759.21631-6-hch@lst.de>
In-Reply-To: <20180531180759.21631-1-hch@lst.de>
References: <20180531180759.21631-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Both callers want the same looking, so do it only once.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_aops.c      | 2 --
 fs/xfs/xfs_bmap_util.c | 9 +++++----
 fs/xfs/xfs_iomap.c     | 3 ---
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f2333e351e07..5dd09e83c81c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -761,10 +761,8 @@ xfs_aops_discard_page(
 		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
 			page, ip->i_ino, offset);
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 			PAGE_SIZE / i_blocksize(inode));
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error && !XFS_FORCED_SHUTDOWN(mp))
 		xfs_alert(mp, "page discard unable to remove delalloc mapping.");
 out_invalidate:
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 0070b877ed94..6690a038892d 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -712,16 +712,15 @@ xfs_bmap_punch_delalloc_range(
 	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
 		if (error)
-			return error;
+			goto out_unlock;
 	}
 
 	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
-		return 0;
+		goto out_unlock;
 
 	while (got.br_startoff + got.br_blockcount > start_fsb) {
 		del = got;
@@ -745,6 +744,8 @@ xfs_bmap_punch_delalloc_range(
 			break;
 	}
 
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index da6d1995e460..f949f0dd7382 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1203,11 +1203,8 @@ xfs_file_iomap_end_delalloc(
 		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
 					 XFS_FSB_TO_B(mp, end_fsb) - 1);
 
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 					       end_fsb - start_fsb);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
 			xfs_alert(mp, "%s: unable to clean up ino %lld",
 				__func__, ip->i_ino);
-- 
2.17.0

