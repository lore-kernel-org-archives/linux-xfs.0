Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51044 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751656AbdJSHAs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 03:00:48 -0400
Received: from 212095007233.public.telering.at ([212.95.7.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1e54ox-0005zM-Ku
        for linux-xfs@vger.kernel.org; Thu, 19 Oct 2017 07:00:48 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/15] xfs: don't rely on extent indices in xfs_bmap_insert_extents
Date: Thu, 19 Oct 2017 08:59:41 +0200
Message-Id: <20171019065942.18813-15-hch@lst.de>
In-Reply-To: <20171019065942.18813-1-hch@lst.de>
References: <20171019065942.18813-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Rewrite xfs_bmap_insert_extents so that we don't rely on extent indices
except for iterating over them.  Not being able to iterate to the previous
extent or finding the extent that stop_fsb is in are sufficient exit
conditions, and we don't need to do any extent count games given that:

  a) we already flushed all delalloc extents past our start offset
     before doing the operation
  b) xfs_iext_count() includes delalloc extents anyway

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 47 +++++++++--------------------------------------
 1 file changed, 9 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4c89fdacda90..9b638cc49f5c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5726,10 +5726,8 @@ xfs_bmap_insert_extents(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur	*cur = NULL;
-	struct xfs_bmbt_irec	got, next, s;
+	struct xfs_bmbt_irec	got, next;
 	xfs_extnum_t		current_ext;
-	xfs_extnum_t		total_extents;
-	xfs_extnum_t		stop_extent;
 	xfs_fileoff_t		new_startoff;
 	int			error = 0;
 	int			logflags = 0;
@@ -5760,37 +5758,14 @@ xfs_bmap_insert_extents(
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
-	 * In case of first right shift, we need to initialize next_fsb
-	 */
 	if (*next_fsb == NULLFSBLOCK) {
-		current_ext = total_extents - 1;
-		xfs_iext_get_extent(ifp, current_ext, &got);
-		if (stop_fsb > got.br_startoff) {
+		current_ext = xfs_iext_count(ifp) - 1;
+		if (!xfs_iext_get_extent(ifp, current_ext, &got) ||
+		    stop_fsb > got.br_startoff) {
 			*done = true;
 			goto del_cursor;
 		}
-		*next_fsb = got.br_startoff;
 	} else {
-		/*
-		 * Look up the extent index for the fsb where we start shifting. We can
-		 * henceforth iterate with current_ext as extent list changes are locked
-		 * out via ilock.
-		 *
-		 * If next_fsb lies in a hole beyond which there are no extents we are
-		 * done.
-		 */
 		if (!xfs_iext_lookup_extent(ip, ifp, *next_fsb, &current_ext,
 				&got)) {
 			*done = true;
@@ -5799,18 +5774,13 @@ xfs_bmap_insert_extents(
 	}
 	XFS_WANT_CORRUPTED_RETURN(mp, !isnullstartblock(got.br_startblock));
 
-	/* Lookup the extent index at which we have to stop */
-	xfs_iext_lookup_extent(ip, ifp, stop_fsb, &stop_extent, &s);
-	/* Make stop_extent exclusive of shift range */
-	stop_extent--;
-	if (current_ext <= stop_extent) {
+	if (stop_fsb >= got.br_startoff + got.br_blockcount) {
 		error = -EIO;
 		goto del_cursor;
 	}
 
 	new_startoff = got.br_startoff + offset_shift_fsb;
-	if (current_ext < total_extents - 1) {
-		xfs_iext_get_extent(ifp, current_ext + 1, &next);
+	if (xfs_iext_get_extent(ifp, current_ext + 1, &next)) {
 		if (new_startoff + got.br_blockcount > next.br_startoff) {
 			error = -EINVAL;
 			goto del_cursor;
@@ -5830,11 +5800,12 @@ xfs_bmap_insert_extents(
 			cur, &logflags, dfops, new_startoff);
 	if (error)
 		goto del_cursor;
-	if (--current_ext == stop_extent) {
+
+	if (!xfs_iext_get_extent(ifp, --current_ext, &got) ||
+	    stop_fsb >= got.br_startoff + got.br_blockcount) {
 		*done = true;
 		goto del_cursor;
 	}
-	xfs_iext_get_extent(ifp, current_ext, &got);
 
 	*next_fsb = got.br_startoff;
 del_cursor:
-- 
2.14.1

