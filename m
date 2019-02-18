Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:45288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfBRJSt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Feb 2019 04:18:49 -0500
Received: from [88.128.83.71] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvf4b-0002rt-2p
        for linux-xfs@vger.kernel.org; Mon, 18 Feb 2019 09:18:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/8] xfs: make COW fork unwritten extent conversions more robust
Date: Mon, 18 Feb 2019 10:18:25 +0100
Message-Id: <20190218091827.12619-7-hch@lst.de>
In-Reply-To: <20190218091827.12619-1-hch@lst.de>
References: <20190218091827.12619-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

If we have racing buffered and direct I/O COW fork extents under
writeback can have been moved to the data fork by the time we call
xfs_reflink_convert_cow from xfs_submit_ioend.  This would be mostly
harmless as the block numbers don't change by this move, except for
the fact that xfs_bmapi_write will crash or trigger asserts when
not finding existing extents, even despite trying to paper over this
with the XFS_BMAPI_CONVERT_ONLY flag.

Instead of special casing non-transaction conversions in the already
way too complicated xfs_bmapi_write just add a new helper for the much
simpler non-transactional COW fork case, which simplify ignores not
found extents.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c |  9 ++----
 fs/xfs/libxfs/xfs_bmap.h |  8 +++---
 fs/xfs/xfs_reflink.c     | 61 +++++++++++++++++++++++++---------------
 3 files changed, 45 insertions(+), 33 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 4cf83475f0d0..114b4da9add6 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -2031,7 +2031,7 @@ xfs_bmap_add_extent_delay_real(
 /*
  * Convert an unwritten allocation to a real allocation or vice versa.
  */
-STATIC int				/* error */
+int					/* error */
 xfs_bmap_add_extent_unwritten_real(
 	struct xfs_trans	*tp,
 	xfs_inode_t		*ip,	/* incore inode pointer */
@@ -4276,9 +4276,7 @@ xfs_bmapi_write(
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
-	ASSERT(tp != NULL ||
-	       (flags & (XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK)) ==
-			(XFS_BMAPI_CONVERT | XFS_BMAPI_COWFORK));
+	ASSERT(tp != NULL);
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
@@ -4352,8 +4350,7 @@ xfs_bmapi_write(
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
-		if ((need_alloc || wasdelay) &&
-		    !(flags & XFS_BMAPI_CONVERT_ONLY)) {
+		if (need_alloc || wasdelay) {
 			bma.eof = eof;
 			bma.conv = !!(flags & XFS_BMAPI_CONVERT);
 			bma.wasdel = wasdelay;
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 78b190b6e908..8f597f9abdbe 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -95,9 +95,6 @@ struct xfs_extent_free_item
 /* Map something in the CoW fork. */
 #define XFS_BMAPI_COWFORK	0x200
 
-/* Only convert unwritten extents, don't allocate new blocks */
-#define XFS_BMAPI_CONVERT_ONLY	0x800
-
 /* Skip online discard of freed extents */
 #define XFS_BMAPI_NODISCARD	0x1000
 
@@ -114,7 +111,6 @@ struct xfs_extent_free_item
 	{ XFS_BMAPI_ZERO,	"ZERO" }, \
 	{ XFS_BMAPI_REMAP,	"REMAP" }, \
 	{ XFS_BMAPI_COWFORK,	"COWFORK" }, \
-	{ XFS_BMAPI_CONVERT_ONLY, "CONVERT_ONLY" }, \
 	{ XFS_BMAPI_NODISCARD,	"NODISCARD" }, \
 	{ XFS_BMAPI_NORMAP,	"NORMAP" }
 
@@ -226,6 +222,10 @@ int	xfs_bmapi_reserve_delalloc(struct xfs_inode *ip, int whichfork,
 int	xfs_bmapi_convert_delalloc(struct xfs_inode *ip, int whichfork,
 		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap,
 		unsigned int *seq);
+int	xfs_bmap_add_extent_unwritten_real(struct xfs_trans *tp,
+		struct xfs_inode *ip, int whichfork,
+		struct xfs_iext_cursor *icur, struct xfs_btree_cur **curp,
+		struct xfs_bmbt_irec *new, int *logflagsp);
 
 static inline void
 xfs_bmap_add_free(
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9ef1f79cb3ae..f84b37fa4f17 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -234,26 +234,42 @@ xfs_reflink_trim_around_shared(
 	}
 }
 
-/* Convert part of an unwritten CoW extent to a real one. */
-STATIC int
-xfs_reflink_convert_cow_extent(
-	struct xfs_inode		*ip,
-	struct xfs_bmbt_irec		*imap,
-	xfs_fileoff_t			offset_fsb,
-	xfs_filblks_t			count_fsb)
+static int
+xfs_reflink_convert_cow_locked(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	xfs_filblks_t		count_fsb)
 {
-	int				nimaps = 1;
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	got;
+	struct xfs_btree_cur	*dummy_cur = NULL;
+	int			dummy_logflags;
+	int			error;
 
-	if (imap->br_state == XFS_EXT_NORM)
+	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
 		return 0;
 
-	xfs_trim_extent(imap, offset_fsb, count_fsb);
-	trace_xfs_reflink_convert_cow(ip, imap);
-	if (imap->br_blockcount == 0)
-		return 0;
-	return xfs_bmapi_write(NULL, ip, imap->br_startoff, imap->br_blockcount,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT, 0, imap,
-			&nimaps);
+	do {
+		if (got.br_startoff >= offset_fsb + count_fsb)
+			break;
+		if (got.br_state == XFS_EXT_NORM)
+			continue;
+		if (WARN_ON_ONCE(isnullstartblock(got.br_startblock)))
+			return -EIO;
+
+		xfs_trim_extent(&got, offset_fsb, count_fsb);
+		if (!got.br_blockcount)
+			continue;
+
+		got.br_state = XFS_EXT_NORM;
+		error = xfs_bmap_add_extent_unwritten_real(NULL, ip,
+				XFS_COW_FORK, &icur, &dummy_cur, &got,
+				&dummy_logflags);
+		if (error)
+			return error;
+	} while (xfs_iext_next_extent(ip->i_cowfp, &icur, &got));
+
+	return error;
 }
 
 /* Convert all of the unwritten CoW extents in a file's range to real ones. */
@@ -267,15 +283,12 @@ xfs_reflink_convert_cow(
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + count);
 	xfs_filblks_t		count_fsb = end_fsb - offset_fsb;
-	struct xfs_bmbt_irec	imap;
-	int			nimaps = 1, error = 0;
+	int			error;
 
 	ASSERT(count != 0);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_bmapi_write(NULL, ip, offset_fsb, count_fsb,
-			XFS_BMAPI_COWFORK | XFS_BMAPI_CONVERT |
-			XFS_BMAPI_CONVERT_ONLY, 0, &imap, &nimaps);
+	error = xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
@@ -405,14 +418,16 @@ xfs_reflink_allocate_cow(
 	if (nimaps == 0)
 		return -ENOSPC;
 convert:
+	xfs_trim_extent(imap, offset_fsb, count_fsb);
 	/*
 	 * COW fork extents are supposed to remain unwritten until we're ready
 	 * to initiate a disk write.  For direct I/O we are going to write the
 	 * data and need the conversion, but for buffered writes we're done.
 	 */
-	if (!(iomap_flags & IOMAP_DIRECT))
+	if (!(iomap_flags & IOMAP_DIRECT) || imap->br_state == XFS_EXT_NORM)
 		return 0;
-	return xfs_reflink_convert_cow_extent(ip, imap, offset_fsb, count_fsb);
+	trace_xfs_reflink_convert_cow(ip, imap);
+	return xfs_reflink_convert_cow_locked(ip, offset_fsb, count_fsb);
 
 out_unreserve:
 	xfs_trans_unreserve_quota_nblks(tp, ip, (long)resblks, 0,
-- 
2.20.1
