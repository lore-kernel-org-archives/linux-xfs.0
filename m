Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48929 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750803AbcI3DJU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:09:20 -0400
Subject: [PATCH 33/63] xfs: allocate delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:09:14 -0700
Message-ID: <147520495446.29434.12909093243905325797.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Modify the writepage handler to find and convert pending delalloc
extents to real allocations.  Furthermore, when we're doing non-cow
writes to a part of a file that already has a CoW reservation (the
cowextsz hint that we set up in a subsequent patch facilitates this),
promote the write to copy-on-write so that the entire extent can get
written out as a single extent on disk, thereby reducing post-CoW
fragmentation.

Christoph moved the CoW support code in _map_blocks to a separate helper
function, refactored other functions, and reduced the number of CoW fork
lookups, so I merged those changes here to reduce churn.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c    |  106 ++++++++++++++++++++++++++++++++++++++++----------
 fs/xfs/xfs_aops.h    |    4 +-
 fs/xfs/xfs_reflink.c |   86 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    4 ++
 4 files changed, 178 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 007a520..7b1e9de 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -31,6 +31,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
+#include "xfs_reflink.h"
 #include <linux/gfp.h>
 #include <linux/mpage.h>
 #include <linux/pagevec.h>
@@ -341,6 +342,7 @@ xfs_map_blocks(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	ASSERT(type != XFS_IO_COW);
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
@@ -355,6 +357,13 @@ xfs_map_blocks(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
 				imap, &nimaps, bmapi_flags);
+	/*
+	 * Truncate an overwrite extent if there's a pending CoW
+	 * reservation before the end of this extent.  This forces us
+	 * to come back to writepage to take care of the CoW.
+	 */
+	if (nimaps && type == XFS_IO_OVERWRITE)
+		xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
@@ -365,8 +374,7 @@ xfs_map_blocks(
 		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
 				imap);
 		if (!error)
-			trace_xfs_map_blocks_alloc(ip, offset, count, type,
-					imap);
+			trace_xfs_map_blocks_alloc(ip, offset, count, type, imap);
 		return error;
 	}
 
@@ -645,13 +653,16 @@ xfs_check_page_type(
 	bh = head = page_buffers(page);
 	do {
 		if (buffer_unwritten(bh)) {
-			if (type == XFS_IO_UNWRITTEN)
+			if (type == XFS_IO_UNWRITTEN ||
+			    type == XFS_IO_COW)
 				return true;
 		} else if (buffer_delay(bh)) {
-			if (type == XFS_IO_DELALLOC)
+			if (type == XFS_IO_DELALLOC ||
+			    type == XFS_IO_COW)
 				return true;
 		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
-			if (type == XFS_IO_OVERWRITE)
+			if (type == XFS_IO_OVERWRITE ||
+			    type == XFS_IO_COW)
 				return true;
 		}
 
@@ -739,6 +750,56 @@ xfs_aops_discard_page(
 	return;
 }
 
+static int
+xfs_map_cow(
+	struct xfs_writepage_ctx *wpc,
+	struct inode		*inode,
+	loff_t			offset,
+	unsigned int		*new_type)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_bmbt_irec	imap;
+	bool			is_cow = false, need_alloc = false;
+	int			error;
+
+	/*
+	 * If we already have a valid COW mapping keep using it.
+	 */
+	if (wpc->io_type == XFS_IO_COW) {
+		wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap, offset);
+		if (wpc->imap_valid) {
+			*new_type = XFS_IO_COW;
+			return 0;
+		}
+	}
+
+	/*
+	 * Else we need to check if there is a COW mapping at this offset.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap, &need_alloc);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	if (!is_cow)
+		return 0;
+
+	/*
+	 * And if the COW mapping has a delayed extent here we need to
+	 * allocate real space for it now.
+	 */
+	if (need_alloc) {
+		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK, offset,
+				&imap);
+		if (error)
+			return error;
+	}
+
+	wpc->io_type = *new_type = XFS_IO_COW;
+	wpc->imap_valid = true;
+	wpc->imap = imap;
+	return 0;
+}
+
 /*
  * We implement an immediate ioend submission policy here to avoid needing to
  * chain multiple ioends and hence nest mempool allocations which can violate
@@ -771,6 +832,7 @@ xfs_writepage_map(
 	int			error = 0;
 	int			count = 0;
 	int			uptodate = 1;
+	unsigned int		new_type;
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
@@ -791,22 +853,13 @@ xfs_writepage_map(
 			continue;
 		}
 
-		if (buffer_unwritten(bh)) {
-			if (wpc->io_type != XFS_IO_UNWRITTEN) {
-				wpc->io_type = XFS_IO_UNWRITTEN;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_delay(bh)) {
-			if (wpc->io_type != XFS_IO_DELALLOC) {
-				wpc->io_type = XFS_IO_DELALLOC;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_uptodate(bh)) {
-			if (wpc->io_type != XFS_IO_OVERWRITE) {
-				wpc->io_type = XFS_IO_OVERWRITE;
-				wpc->imap_valid = false;
-			}
-		} else {
+		if (buffer_unwritten(bh))
+			new_type = XFS_IO_UNWRITTEN;
+		else if (buffer_delay(bh))
+			new_type = XFS_IO_DELALLOC;
+		else if (buffer_uptodate(bh))
+			new_type = XFS_IO_OVERWRITE;
+		else {
 			if (PageUptodate(page))
 				ASSERT(buffer_mapped(bh));
 			/*
@@ -819,6 +872,17 @@ xfs_writepage_map(
 			continue;
 		}
 
+		if (xfs_is_reflink_inode(XFS_I(inode))) {
+			error = xfs_map_cow(wpc, inode, offset, &new_type);
+			if (error)
+				goto out;
+		}
+
+		if (wpc->io_type != new_type) {
+			wpc->io_type = new_type;
+			wpc->imap_valid = false;
+		}
+
 		if (wpc->imap_valid)
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
 							 offset);
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 1950e3b..b3c6634 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -28,13 +28,15 @@ enum {
 	XFS_IO_DELALLOC,	/* covers delalloc region */
 	XFS_IO_UNWRITTEN,	/* covers allocated but uninitialized data */
 	XFS_IO_OVERWRITE,	/* covers already allocated extent */
+	XFS_IO_COW,		/* covers copy-on-write extent */
 };
 
 #define XFS_IO_TYPES \
 	{ XFS_IO_INVALID,		"invalid" }, \
 	{ XFS_IO_DELALLOC,		"delalloc" }, \
 	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
-	{ XFS_IO_OVERWRITE,		"overwrite" }
+	{ XFS_IO_OVERWRITE,		"overwrite" }, \
+	{ XFS_IO_COW,			"CoW" }
 
 /*
  * Structure for buffered I/O completions.
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 05a7fe6..e8c7c85 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -314,3 +314,89 @@ xfs_reflink_reserve_cow_range(
 
 	return error;
 }
+
+/*
+ * Find the CoW reservation (and whether or not it needs block allocation)
+ * for a given byte offset of a file.
+ */
+bool
+xfs_reflink_find_cow_mapping(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset,
+	struct xfs_bmbt_irec		*imap,
+	bool				*need_alloc)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	xfs_fileoff_t			bno;
+	xfs_extnum_t			idx;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL | XFS_ILOCK_SHARED));
+
+	if (!xfs_is_reflink_inode(ip))
+		return false;
+
+	/* Find the extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
+	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
+	if (!gotp)
+		return false;
+
+	xfs_bmbt_get_all(gotp, &irec);
+	if (bno >= irec.br_startoff + irec.br_blockcount ||
+	    bno < irec.br_startoff)
+		return false;
+
+	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
+			&irec);
+
+	/* If it's still delalloc, we must allocate later. */
+	*imap = irec;
+	*need_alloc = !!(isnullstartblock(irec.br_startblock));
+
+	return true;
+}
+
+/*
+ * Trim an extent to end at the next CoW reservation past offset_fsb.
+ */
+int
+xfs_reflink_trim_irec_to_next_cow(
+	struct xfs_inode		*ip,
+	xfs_fileoff_t			offset_fsb,
+	struct xfs_bmbt_irec		*imap)
+{
+	struct xfs_bmbt_irec		irec;
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	xfs_extnum_t			idx;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	/* Find the extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	gotp = xfs_iext_bno_to_ext(ifp, offset_fsb, &idx);
+	if (!gotp)
+		return 0;
+	xfs_bmbt_get_all(gotp, &irec);
+
+	/* This is the extent before; try sliding up one. */
+	if (irec.br_startoff < offset_fsb) {
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			return 0;
+		gotp = xfs_iext_get_ext(ifp, idx);
+		xfs_bmbt_get_all(gotp, &irec);
+	}
+
+	if (irec.br_startoff >= imap->br_startoff + imap->br_blockcount)
+		return 0;
+
+	imap->br_blockcount = irec.br_startoff - imap->br_startoff;
+	trace_xfs_reflink_trim_irec(ip, imap);
+
+	return 0;
+}
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index f824f87..11408c0 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -28,5 +28,9 @@ extern int xfs_reflink_trim_around_shared(struct xfs_inode *ip,
 
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
 		xfs_off_t offset, xfs_off_t count);
+extern bool xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
+		struct xfs_bmbt_irec *imap, bool *need_alloc);
+extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
 #endif /* __XFS_REFLINK_H */

