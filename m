Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:35215 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751248AbdIOOy1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2017 10:54:27 -0400
Received: from [8.25.222.2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.87 #1 (Red Hat Linux))
        id 1dss0h-0003Hs-E0
        for linux-xfs@vger.kernel.org; Fri, 15 Sep 2017 14:54:27 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/18] xfs: rename bno to end in __xfs_bunmapi
Date: Fri, 15 Sep 2017 07:54:12 -0700
Message-Id: <20170915145426.26194-5-hch@lst.de>
In-Reply-To: <20170915145426.26194-1-hch@lst.de>
References: <20170915145426.26194-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Rename the bno variable that's used as the end of the range in
__xfs_bunmapi to end, which better describes it.  Additionally change
the start variable which takes the initial value of bno to be the
function parameter itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 49 ++++++++++++++++++++++++------------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ef30b52c32af..15650bb7d881 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5410,7 +5410,7 @@ int						/* error */
 __xfs_bunmapi(
 	xfs_trans_t		*tp,		/* transaction pointer */
 	struct xfs_inode	*ip,		/* incore inode */
-	xfs_fileoff_t		bno,		/* starting offset to unmap */
+	xfs_fileoff_t		start,		/* first file offset deleted */
 	xfs_filblks_t		*rlen,		/* i/o: amount remaining */
 	int			flags,		/* misc flags */
 	xfs_extnum_t		nexts,		/* number of extents max */
@@ -5429,7 +5429,6 @@ __xfs_bunmapi(
 	int			logflags;	/* transaction logging flags */
 	xfs_extlen_t		mod;		/* rt extent offset */
 	xfs_mount_t		*mp;		/* mount structure */
-	xfs_fileoff_t		start;		/* first file offset deleted */
 	int			tmp_logflags;	/* partial logging flags */
 	int			wasdel;		/* was a delayed alloc extent */
 	int			whichfork;	/* data or attribute fork */
@@ -5437,8 +5436,9 @@ __xfs_bunmapi(
 	xfs_filblks_t		len = *rlen;	/* length to unmap in file */
 	xfs_fileoff_t		max_len;
 	xfs_agnumber_t		prev_agno = NULLAGNUMBER, agno;
+	xfs_fileoff_t		end;
 
-	trace_xfs_bunmap(ip, bno, len, flags, _RET_IP_);
+	trace_xfs_bunmap(ip, start, len, flags, _RET_IP_);
 
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
@@ -5477,17 +5477,16 @@ __xfs_bunmapi(
 	}
 	XFS_STATS_INC(mp, xs_blk_unmap);
 	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
-	start = bno;
-	bno = start + len - 1;
+	end = start + len - 1;
 
 	/*
 	 * Check to see if the given block number is past the end of the
 	 * file, back up to the last block if so...
 	 */
-	if (!xfs_iext_lookup_extent(ip, ifp, bno, &lastx, &got)) {
+	if (!xfs_iext_lookup_extent(ip, ifp, end, &lastx, &got)) {
 		ASSERT(lastx > 0);
 		xfs_iext_get_extent(ifp, --lastx, &got);
-		bno = got.br_startoff + got.br_blockcount - 1;
+		end = got.br_startoff + got.br_blockcount - 1;
 	}
 
 	logflags = 0;
@@ -5511,13 +5510,13 @@ __xfs_bunmapi(
 	}
 
 	extno = 0;
-	while (bno != (xfs_fileoff_t)-1 && bno >= start && lastx >= 0 &&
+	while (end != (xfs_fileoff_t)-1 && end >= start && lastx >= 0 &&
 	       (nexts == 0 || extno < nexts) && max_len > 0) {
 		/*
-		 * Is the found extent after a hole in which bno lives?
+		 * Is the found extent after a hole in which end lives?
 		 * Just back up to the previous extent, if so.
 		 */
-		if (got.br_startoff > bno) {
+		if (got.br_startoff > end) {
 			if (--lastx < 0)
 				break;
 			xfs_iext_get_extent(ifp, lastx, &got);
@@ -5526,9 +5525,9 @@ __xfs_bunmapi(
 		 * Is the last block of this extent before the range
 		 * we're supposed to delete?  If so, we're done.
 		 */
-		bno = XFS_FILEOFF_MIN(bno,
+		end = XFS_FILEOFF_MIN(end,
 			got.br_startoff + got.br_blockcount - 1);
-		if (bno < start)
+		if (end < start)
 			break;
 		/*
 		 * Then deal with the (possibly delayed) allocated space
@@ -5553,8 +5552,8 @@ __xfs_bunmapi(
 			if (!wasdel)
 				del.br_startblock += start - got.br_startoff;
 		}
-		if (del.br_startoff + del.br_blockcount > bno + 1)
-			del.br_blockcount = bno + 1 - del.br_startoff;
+		if (del.br_startoff + del.br_blockcount > end + 1)
+			del.br_blockcount = end + 1 - del.br_startoff;
 
 		/* How much can we safely unmap? */
 		if (max_len < del.br_blockcount) {
@@ -5580,10 +5579,10 @@ __xfs_bunmapi(
 				 * This piece is unwritten, or we're not
 				 * using unwritten extents.  Skip over it.
 				 */
-				ASSERT(bno >= mod);
-				bno -= mod > del.br_blockcount ?
+				ASSERT(end >= mod);
+				end -= mod > del.br_blockcount ?
 					del.br_blockcount : mod;
-				if (bno < got.br_startoff) {
+				if (end < got.br_startoff) {
 					if (--lastx >= 0)
 						xfs_iext_get_extent(ifp, lastx,
 								&got);
@@ -5632,9 +5631,9 @@ __xfs_bunmapi(
 				 * Can't make it unwritten.  There isn't
 				 * a full extent here so just skip it.
 				 */
-				ASSERT(bno >= del.br_blockcount);
-				bno -= del.br_blockcount;
-				if (got.br_startoff > bno && --lastx >= 0)
+				ASSERT(end >= del.br_blockcount);
+				end -= del.br_blockcount;
+				if (got.br_startoff > end && --lastx >= 0)
 					xfs_iext_get_extent(ifp, lastx, &got);
 				continue;
 			} else if (del.br_state == XFS_EXT_UNWRITTEN) {
@@ -5737,24 +5736,24 @@ __xfs_bunmapi(
 			xfs_mod_fdblocks(mp, (int64_t)del.br_blockcount, false);
 
 		max_len -= del.br_blockcount;
-		bno = del.br_startoff - 1;
+		end = del.br_startoff - 1;
 nodelete:
 		/*
 		 * If not done go on to the next (previous) record.
 		 */
-		if (bno != (xfs_fileoff_t)-1 && bno >= start) {
+		if (end != (xfs_fileoff_t)-1 && end >= start) {
 			if (lastx >= 0) {
 				xfs_iext_get_extent(ifp, lastx, &got);
-				if (got.br_startoff > bno && --lastx >= 0)
+				if (got.br_startoff > end && --lastx >= 0)
 					xfs_iext_get_extent(ifp, lastx, &got);
 			}
 			extno++;
 		}
 	}
-	if (bno == (xfs_fileoff_t)-1 || bno < start || lastx < 0)
+	if (end == (xfs_fileoff_t)-1 || end < start || lastx < 0)
 		*rlen = 0;
 	else
-		*rlen = bno - start + 1;
+		*rlen = end - start + 1;
 
 	/*
 	 * Convert to a btree if necessary.
-- 
2.14.1

