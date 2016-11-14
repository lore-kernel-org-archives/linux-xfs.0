Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48845 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933384AbcKNRNK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2016 12:13:10 -0500
Received: from [83.175.99.196] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.85_2 #1 (Red Hat Linux))
        id 1c6Kof-0005Gm-O9
        for linux-xfs@vger.kernel.org; Mon, 14 Nov 2016 17:13:10 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/14] xfs: use new extent lookup helpers in __xfs_bunmapi
Date: Mon, 14 Nov 2016 18:12:36 +0100
Message-Id: <1479143565-30615-6-git-send-email-hch@lst.de>
In-Reply-To: <1479143565-30615-1-git-send-email-hch@lst.de>
References: <1479143565-30615-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9a8621d..18de89c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5433,8 +5433,6 @@ __xfs_bunmapi(
 {
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
 	xfs_bmbt_irec_t		del;		/* extent being deleted */
-	int			eof;		/* is deleting at eof */
-	xfs_bmbt_rec_host_t	*ep;		/* extent record pointer */
 	int			error;		/* error return value */
 	xfs_extnum_t		extno;		/* extent number in list */
 	xfs_bmbt_irec_t		got;		/* current extent record */
@@ -5444,7 +5442,6 @@ __xfs_bunmapi(
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
 	xfs_mount_t		*mp;		/* mount structure */
-	xfs_bmbt_irec_t		prev;		/* previous extent record */
 	xfs_fileoff_t		start;		/* first file offset deleted */
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
@@ -5483,18 +5480,17 @@ __xfs_bunmapi(
 	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
 	start = bno;
 	bno = start + len - 1;
-	ep = xfs_bmap_search_extents(ip, bno, whichfork, &eof, &lastx, &got,
-		&prev);
 
 	/*
 	 * Check to see if the given block number is past the end of the
 	 * file, back up to the last block if so...
 	 */
-	if (eof) {
-		ep = xfs_iext_get_ext(ifp, --lastx);
-		xfs_bmbt_get_all(ep, &got);
+	if (!xfs_iext_lookup_extent(ip, ifp, bno, &lastx, &got)) {
+		ASSERT(lastx > 0);
+		xfs_iext_get_extent(ifp, --lastx, &got);
 		bno = got.br_startoff + got.br_blockcount - 1;
 	}
+
 	logflags = 0;
 	if (ifp->if_flags & XFS_IFBROOT) {
 		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
@@ -5525,8 +5521,7 @@ __xfs_bunmapi(
 		if (got.br_startoff > bno) {
 			if (--lastx < 0)
 				break;
-			ep = xfs_iext_get_ext(ifp, lastx);
-			xfs_bmbt_get_all(ep, &got);
+			xfs_iext_get_extent(ifp, lastx, &got);
 		}
 		/*
 		 * Is the last block of this extent before the range
@@ -5540,7 +5535,6 @@ __xfs_bunmapi(
 		 * Then deal with the (possibly delayed) allocated space
 		 * we found.
 		 */
-		ASSERT(ep != NULL);
 		del = got;
 		wasdel = isnullstartblock(del.br_startblock);
 		if (got.br_startoff < start) {
@@ -5621,15 +5615,11 @@ __xfs_bunmapi(
 				 */
 				ASSERT(bno >= del.br_blockcount);
 				bno -= del.br_blockcount;
-				if (got.br_startoff > bno) {
-					if (--lastx >= 0) {
-						ep = xfs_iext_get_ext(ifp,
-								      lastx);
-						xfs_bmbt_get_all(ep, &got);
-					}
-				}
+				if (got.br_startoff > bno && --lastx >= 0)
+					xfs_iext_get_extent(ifp, lastx, &got);
 				continue;
 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
+				xfs_bmbt_irec_t		prev;
 				/*
 				 * This one is already unwritten.
 				 * It must have a written left neighbor.
@@ -5637,8 +5627,7 @@ __xfs_bunmapi(
 				 * try again.
 				 */
 				ASSERT(lastx > 0);
-				xfs_bmbt_get_all(xfs_iext_get_ext(ifp,
-						lastx - 1), &prev);
+				xfs_iext_get_extent(ifp, lastx - 1, &prev);
 				ASSERT(prev.br_state == XFS_EXT_NORM);
 				ASSERT(!isnullstartblock(prev.br_startblock));
 				ASSERT(del.br_startblock ==
@@ -5736,13 +5725,9 @@ __xfs_bunmapi(
 		 */
 		if (bno != (xfs_fileoff_t)-1 && bno >= start) {
 			if (lastx >= 0) {
-				ep = xfs_iext_get_ext(ifp, lastx);
-				if (xfs_bmbt_get_startoff(ep) > bno) {
-					if (--lastx >= 0)
-						ep = xfs_iext_get_ext(ifp,
-								      lastx);
-				}
-				xfs_bmbt_get_all(ep, &got);
+				xfs_iext_get_extent(ifp, lastx, &got);
+				if (got.br_startoff > bno && --lastx >= 0)
+					xfs_iext_get_extent(ifp, lastx, &got);
 			}
 			extno++;
 		}
-- 
2.1.4

