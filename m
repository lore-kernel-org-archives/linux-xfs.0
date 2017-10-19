Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:47827 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdJSHAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:44 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54ot-0005wj-K3
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:44 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/15] xfs: don't rely on extent indices in xfs_bmap_collapse_extents
Date: Thu, 19 Oct 2017 08:59:40 +0200
Message-Id: <20171019065942.18813-14-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Rewrite xfs_bmap_collapse_extents so that we don't rely on extent indices
except for iterating over them.  Not being able to iterate to the next
extent is a sufficient exit condition, and we don't need to do any extent
count games given that:

  a) we already flushed all delalloc extents past our start offset
     before doing the operation
  b) xfs_iext_count() includes delalloc extents anyway

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 54 +++++++++++-------------------------------------
 1 file changed, 12 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 2de9458903b6..4c89fdacda90 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5626,8 +5626,6 @@ xfs_bmap_collapse_extents(
 	struct xfs_btree_cur	*cur = NULL;
 	struct xfs_bmbt_irec	got, prev;
 	xfs_extnum_t		current_ext;
-	xfs_extnum_t		total_extents;
-	xfs_extnum_t		stop_extent;
 	xfs_fileoff_t		new_startoff;
 	int			error = 0;
 	int			logflags = 0;
@@ -5658,52 +5656,31 @@ xfs_bmap_collapse_extents(
 		cur->bc_private.b.flags = 0;
 	}
 
-	/*
-	 * There may be delalloc extents in the data fork before the range we
-	 * are collapsing out, so we cannot use the count of real extents here.
-	 * Instead we have to calculate it from the incore fork.
-	 */
-	total_extents = xfs_iext_count(ifp);
-	if (total_extents == 0) {
-		*done = true;
-		goto del_cursor;
-	}
-
-	/*
-	 * Look up the extent index for the fsb where we start shifting. We can
-	 * henceforth iterate with current_ext as extent list changes are locked
-	 * out via ilock.
-	 *
-	 * If next_fsb lies in a hole beyond which there are no extents we are
-	 * done.
-	 */
 	if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext, &got)) {
 		*done = true;
 		goto del_cursor;
 	}
 	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
 
-	stop_extent = total_extents;
-	if (current_ext >= stop_extent) {
-		error = -EIO;
-		goto del_cursor;
-	}
-
 	new_startoff = got.br_startoff - offset_shift_fsb;
-	if (current_ext) {
-		xfs_iext_get_extent(ifp, current_ext - 1, &prev);
+	if (xfs_iext_get_extent(ifp, current_ext - 1, &prev)) {
 		if (new_startoff < prev.br_startoff + prev.br_blockcount) {
 			error = -EINVAL;
 			goto del_cursor;
 		}
 
-		/* check whether to merge the extent or shift it down */
 		if (xfs_bmse_can_merge(&prev, &got, offset_shift_fsb)) {
 			error = xfs_bmse_merge(ip, whichfork, offset_shift_fsb,
 					current_ext, &got, &prev, cur,
 					&logflags, dfops);
 			if (error)
 				goto del_cursor;
+
+			/* update got after merge */
+			if (!xfs_iext_get_extent(ifp, current_ext, &got)) {
+				*done = true;
+				goto del_cursor;
+			}
 			goto done;
 		}
 	} else {
@@ -5717,20 +5694,13 @@ xfs_bmap_collapse_extents(
 			cur, &logflags, dfops, new_startoff);
 	if (error)
 		goto del_cursor;
-	current_ext++;
-done:
-	/*
-	 * If there was an extent merge during the shift, the extent
-	 * count can change. Update the total and grade the next record.
-	 */
-	total_extents = xfs_iext_count(ifp);
-	stop_extent = total_extents;
-	if (current_ext == stop_extent) {
-		*done = true;
-		goto del_cursor;
+
+	if (!xfs_iext_get_extent(ifp, ++current_ext, &got)) {
+		 *done = true;
+		 goto del_cursor;
 	}
-	xfs_iext_get_extent(ifp, current_ext, &got);
 
+done:
 	*next_fsb = got.br_startoff;
 del_cursor:
 	if (cur)
-- 
2.14.1

