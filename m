Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56668 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728729AbfAaHzs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 02:55:48 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/11] xfs: split XFS_BMAPI_DELALLOC handling from xfs_bmapi_write
Date: Thu, 31 Jan 2019 08:55:20 +0100
Message-Id: <20190131075524.4769-8-hch@lst.de>
In-Reply-To: <20190131075524.4769-1-hch@lst.de>
References: <20190131075524.4769-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Brian Foster <bfoster@redhat.com>

Delalloc conversion has traditionally been part of our function to
allocate blocks on disk (first xfs_bmapi, then xfs_bmapi_write), but
delalloc conversion is a little special as we really do not want
to allocate blocks over holes, for which we don't have reservations.

Split the delalloc conversions into a separate helper to keep the
code simple and structured.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 104 +++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap.h |   4 --
 2 files changed, 57 insertions(+), 51 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d75f45d9b7d1..818cd018d510 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4327,22 +4327,6 @@ xfs_bmapi_write(
 	bma.datatype = 0;
 	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
 
-	/*
-	 * The delalloc flag means the caller wants to allocate the entire
-	 * delalloc extent backing bno where bno may not necessarily match the
-	 * startoff. Now that we've looked up the extent, reset the range to
-	 * map based on the extent in the file. If we're in a hole, this may be
-	 * an error so don't adjust anything.
-	 */
-	if ((flags & XFS_BMAPI_DELALLOC) &&
-	    !eof && bno >= bma.got.br_startoff) {
-		bno = bma.got.br_startoff;
-		len = bma.got.br_blockcount;
-#ifdef DEBUG
-		orig_bno = bno;
-		orig_len = len;
-#endif
-	}
 	n = 0;
 	end = bno + len;
 	obno = bno;
@@ -4359,26 +4343,7 @@ xfs_bmapi_write(
 			ASSERT(!((flags & XFS_BMAPI_CONVERT) &&
 			         (flags & XFS_BMAPI_COWFORK)));
 
-			if (flags & XFS_BMAPI_DELALLOC) {
-				/*
-				 * For the COW fork we can reasonably get a
-				 * request for converting an extent that races
-				 * with other threads already having converted
-				 * part of it, as there converting COW to
-				 * regular blocks is not protected using the
-				 * IOLOCK.
-				 */
-				ASSERT(flags & XFS_BMAPI_COWFORK);
-				if (!(flags & XFS_BMAPI_COWFORK)) {
-					error = -EIO;
-					goto error0;
-				}
-
-				if (eof || bno >= end)
-					break;
-			} else {
-				need_alloc = true;
-			}
+			need_alloc = true;
 		} else if (isnullstartblock(bma.got.br_startblock)) {
 			wasdelay = true;
 		}
@@ -4487,21 +4452,66 @@ xfs_bmapi_convert_delalloc(
 	xfs_fileoff_t		offset_fsb,
 	struct xfs_bmbt_irec	*imap)
 {
-	int			flags = XFS_BMAPI_DELALLOC, nimaps = 1, error;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
+	struct xfs_bmalloca	bma = { NULL };
+	int			error;
 
-	if (whichfork == XFS_COW_FORK)
-		flags |= XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
+	    bma.got.br_startoff > offset_fsb) {
+		/*
+		 * No extent found in the range we are trying to convert.  This
+		 * should only happen for the COW fork, where another thread
+		 * might have moved the extent to the data fork in the meantime.
+		 */
+		WARN_ON_ONCE(whichfork != XFS_COW_FORK);
+		return -EAGAIN;
+	}
 
 	/*
-	 * The DELALLOC flag always allocates the entire extent; pass a dummy
-	 * length of 1.
+	 * If we find a real extent here we raced with another thread converting
+	 * the extent.  Just return the real extent at this offset.
 	 */
-	flags |= XFS_BMAPI_DELALLOC;
-	error = xfs_bmapi_write(tp, ip, offset_fsb, 1, flags,
-			XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK),
-			imap, &nimaps);
-	if (!error && !nimaps)
-		error = -EFSCORRUPTED;
+	if (!isnullstartblock(bma.got.br_startblock)) {
+		*imap = bma.got;
+		return 0;
+	}
+
+	bma.tp = tp;
+	bma.ip = ip;
+	bma.wasdel = true;
+	bma.offset = bma.got.br_startoff;
+	bma.length = bma.got.br_blockcount;
+	bma.total = XFS_EXTENTADD_SPACE_RES(ip->i_mount, XFS_DATA_FORK);
+	bma.minleft = xfs_bmapi_minleft(tp, ip, whichfork);
+	if (whichfork == XFS_COW_FORK)
+		bma.flags = XFS_BMAPI_COWFORK | XFS_BMAPI_PREALLOC;
+
+	if (!xfs_iext_peek_prev_extent(ifp, &bma.icur, &bma.prev))
+		bma.prev.br_startoff = NULLFILEOFF;
+
+	error = xfs_bmapi_allocate(&bma);
+	if (error)
+		goto out_finish;
+	if (WARN_ON_ONCE(bma.blkno == NULLFSBLOCK)) {
+		error = -ENOSPC;
+		goto out_finish;
+	}
+
+	ASSERT(!isnullstartblock(bma.got.br_startblock));
+	ASSERT(bma.got.br_startblock || XFS_IS_REALTIME_INODE(ip));
+	*imap = bma.got;
+
+	if (whichfork == XFS_COW_FORK) {
+		error = xfs_refcount_alloc_cow_extent(tp, bma.blkno,
+				bma.length);
+		if (error)
+			goto out_finish;
+	}
+
+	error = xfs_bmap_btree_to_extents(tp, ip, bma.cur, &bma.logflags,
+			whichfork);
+out_finish:
+	xfs_bmapi_finish(&bma, whichfork, error);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index c385987251cd..5bdfa8001f07 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -95,9 +95,6 @@ struct xfs_extent_free_item
 /* Map something in the CoW fork. */
 #define XFS_BMAPI_COWFORK	0x200
 
-/* Only convert delalloc space, don't allocate entirely new extents */
-#define XFS_BMAPI_DELALLOC	0x400
-
 /* Only convert unwritten extents, don't allocate new blocks */
 #define XFS_BMAPI_CONVERT_ONLY	0x800
 
@@ -117,7 +114,6 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
-	{ XFS_BMAPI_DELALLOC,	"DELALLOC" }, \
 	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" }
-- 
2.20.1
