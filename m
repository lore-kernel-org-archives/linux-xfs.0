Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46015 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933187AbdKCOqL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 3 Nov 2017 10:46:11 -0400
Received: from [94.72.11.11] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1eAdEY-0001vn-M3
        for linux-xfs@vger.kernel.org; Fri, 03 Nov 2017 14:46:11 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/21] xfs: treat idx as a cursor in xfs_bmap_collapse_extents
Date: Fri,  3 Nov 2017 17:45:26 +0300
Message-Id: <20171103144539.2187-9-hch@lst.de>
In-Reply-To: <20171103144539.2187-1-hch@lst.de>
References: <20171103144539.2187-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Stop poking before and after the index and just increment or decrement
it while doing our operations on it to prepare for a new extent list
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f64b6b74daa9..62270b871d06 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5517,7 +5517,7 @@ xfs_bmse_merge(
 	struct xfs_inode		*ip,
 	int				whichfork,
 	xfs_fileoff_t			shift,		/* shift fsb */
-	int				current_ext,	/* idx of gotp */
+	int				*current_ext,	/* idx of gotp */
 	struct xfs_bmbt_irec		*got,		/* extent to shift */
 	struct xfs_bmbt_irec		*left,		/* preceding extent */
 	struct xfs_btree_cur		*cur,
@@ -5572,9 +5572,10 @@ xfs_bmse_merge(
 		return error;
 
 done:
+	xfs_iext_remove(ip, *current_ext, 1, 0);
+	--*current_ext;
 	xfs_iext_update_extent(ip, xfs_bmap_fork_to_state(whichfork),
-			current_ext - 1, &new);
-	xfs_iext_remove(ip, current_ext, 1, 0);
+			*current_ext, &new);
 
 	/* update reverse mapping. rmap functions merge the rmaps for us */
 	error = xfs_rmap_unmap_extent(mp, dfops, ip, whichfork, got);
@@ -5688,16 +5689,10 @@ xfs_bmap_collapse_extents(
 
 		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
 			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
-					current_ext, &got, &prev, cur,
+					&current_ext, &got, &prev, cur,
 					&logflags, dfops);
 			if (error)
 				goto del_cursor;
-
-			/* update got after merge */
-			if (!xfs_iext_get_extent(ifp, current_ext, &got)) {
-				*done = true;
-				goto del_cursor;
-			}
 			goto done;
 		}
 	} else {
@@ -5712,12 +5707,12 @@ xfs_bmap_collapse_extents(
 	if (error)
 		goto del_cursor;
 
+done:
 	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
 		 *done = true;
 		 goto del_cursor;
 	}
 
-done:
 	*next_fsb = got.br_startoff;
 del_cursor:
 	if (cur)
-- 
2.14.2

