Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36734 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933771AbeFONC1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 09:02:27 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/24] xfs: simplify xfs_bmap_punch_delalloc_range
Date: Fri, 15 Jun 2018 15:01:49 +0200
Message-Id: <20180615130209.1970-5-hch@lst.de>
In-Reply-To: <20180615130209.1970-1-hch@lst.de>
References: <20180615130209.1970-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Instead of using xfs_bmapi_read to find delalloc extents and then punch
them out using xfs_bunmapi, opencode the loop to iterate over the extents
and call xfs_bmap_del_extent_delay directly.  This both simplifies the
code and reduces the number of extent tree lookups required.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_util.c | 85 ++++++++++++++++--------------------------
 1 file changed, 32 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 06badcbadeb4..0070b877ed94 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -695,12 +695,10 @@ xfs_getbmap(
 }
 
 /*
- * dead simple method of punching delalyed allocation blocks from a range in
- * the inode. Walks a block at a time so will be slow, but is only executed in
- * rare error cases so the overhead is not critical. This will always punch out
- * both the start and end blocks, even if the ranges only partially overlap
- * them, so it is up to the caller to ensure that partial blocks are not
- * passed in.
+ * Dead simple method of punching delalyed allocation blocks from a range in
+ * the inode.  This will always punch out both the start and end blocks, even
+ * if the ranges only partially overlap them, so it is up to the caller to
+ * ensure that partial blocks are not passed in.
  */
 int
 xfs_bmap_punch_delalloc_range(
@@ -708,63 +706,44 @@ xfs_bmap_punch_delalloc_range(
 	xfs_fileoff_t		start_fsb,
 	xfs_fileoff_t		length)
 {
-	xfs_fileoff_t		remaining = length;
+	struct xfs_ifork	*ifp = &ip->i_df;
+	xfs_fileoff_t		end_fsb = start_fsb + length;
+	struct xfs_bmbt_irec	got, del;
+	struct xfs_iext_cursor	icur;
 	int			error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	do {
-		int		done;
-		xfs_bmbt_irec_t	imap;
-		int		nimaps = 1;
-		xfs_fsblock_t	firstblock;
-		struct xfs_defer_ops dfops;
+	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			return error;
+	}
 
-		/*
-		 * Map the range first and check that it is a delalloc extent
-		 * before trying to unmap the range. Otherwise we will be
-		 * trying to remove a real extent (which requires a
-		 * transaction) or a hole, which is probably a bad idea...
-		 */
-		error = xfs_bmapi_read(ip, start_fsb, 1, &imap, &nimaps,
-				       XFS_BMAPI_ENTIRE);
+	if (!xfs_iext_lookup_extent_before(ip, ifp, &end_fsb, &icur, &got))
+		return 0;
 
-		if (error) {
-			/* something screwed, just bail */
-			if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-				xfs_alert(ip->i_mount,
-			"Failed delalloc mapping lookup ino %lld fsb %lld.",
-						ip->i_ino, start_fsb);
-			}
-			break;
-		}
-		if (!nimaps) {
-			/* nothing there */
-			goto next_block;
-		}
-		if (imap.br_startblock != DELAYSTARTBLOCK) {
-			/* been converted, ignore */
-			goto next_block;
-		}
-		WARN_ON(imap.br_blockcount == 0);
+	while (got.br_startoff + got.br_blockcount > start_fsb) {
+		del = got;
+		xfs_trim_extent(&del, start_fsb, length);
 
 		/*
-		 * Note: while we initialise the firstblock/dfops pair, they
-		 * should never be used because blocks should never be
-		 * allocated or freed for a delalloc extent and hence we need
-		 * don't cancel or finish them after the xfs_bunmapi() call.
+		 * A delete can push the cursor forward. Step back to the
+		 * previous extent on non-delalloc or extents outside the
+		 * target range.
 		 */
-		xfs_defer_init(&dfops, &firstblock);
-		error = xfs_bunmapi(NULL, ip, start_fsb, 1, 0, 1, &firstblock,
-					&dfops, &done);
-		if (error)
-			break;
+		if (!del.br_blockcount ||
+		    !isnullstartblock(del.br_startblock)) {
+			if (!xfs_iext_prev_extent(ifp, &icur, &got))
+				break;
+			continue;
+		}
 
-		ASSERT(!xfs_defer_has_unfinished_work(&dfops));
-next_block:
-		start_fsb++;
-		remaining--;
-	} while(remaining > 0);
+		error = xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur,
+						  &got, &del);
+		if (error || !xfs_iext_get_extent(ifp, &icur, &got))
+			break;
+	}
 
 	return error;
 }
-- 
2.17.1

