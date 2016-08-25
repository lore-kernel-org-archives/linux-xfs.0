Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6715C7DCD
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:36:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C1C8FAC001
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:07 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vZPPOLNMoc2hVDAN (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:36:03 -0700 (PDT)
Subject: [PATCH 37/71] xfs: allocate delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:35:59 -0700
Message-ID: <147216815895.867.10851568007441923678.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Modify the writepage handler to find and convert pending delalloc
extents to real allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   58 ++++++++++++++++++++++++---
 fs/xfs/xfs_aops.h    |    4 +-
 fs/xfs/xfs_reflink.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    5 ++
 4 files changed, 165 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4821176..f0f83d4 100644
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
@@ -320,10 +321,15 @@ xfs_map_blocks(
 	int			error = 0;
 	int			bmapi_flags = XFS_BMAPI_ENTIRE;
 	int			nimaps = 1;
+	int			whichfork;
+	bool			need_alloc;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	whichfork = (type == XFS_IO_COW ? XFS_COW_FORK : XFS_DATA_FORK);
+	need_alloc = (type == XFS_IO_DELALLOC);
+
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
@@ -336,16 +342,29 @@ xfs_map_blocks(
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				imap, &nimaps, bmapi_flags);
+
+	if (type == XFS_IO_COW)
+		error = xfs_reflink_find_cow_mapping(ip, offset, imap,
+						     &need_alloc);
+	else {
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				       imap, &nimaps, bmapi_flags);
+		/*
+		 * Truncate an overwrite extent if there's a pending CoW
+		 * reservation before the end of this extent.  This forces us
+		 * to come back to writepage to take care of the CoW.
+		 */
+		if (nimaps && type == XFS_IO_OVERWRITE)
+			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb, imap);
+	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
 	if (error)
 		return error;
 
-	if (type == XFS_IO_DELALLOC &&
+	if (need_alloc &&
 	    (!nimaps || isnullstartblock(imap->br_startblock))) {
-		error = xfs_iomap_write_allocate(ip, XFS_DATA_FORK, offset,
+		error = xfs_iomap_write_allocate(ip, whichfork, offset,
 				imap);
 		if (!error)
 			trace_xfs_map_blocks_alloc(ip, offset, count, type,
@@ -634,7 +653,8 @@ xfs_check_page_type(
 			if (type == XFS_IO_DELALLOC)
 				return true;
 		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
-			if (type == XFS_IO_OVERWRITE)
+			if (type == XFS_IO_OVERWRITE ||
+			    type == XFS_IO_COW)
 				return true;
 		}
 
@@ -646,6 +666,26 @@ xfs_check_page_type(
 	return false;
 }
 
+/*
+ * Figure out if CoW is pending at this offset.
+ */
+static bool
+xfs_is_cow_io(
+	struct xfs_inode	*ip,
+	xfs_off_t		offset)
+{
+	bool			is_cow;
+
+	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
+		return false;
+
+	xfs_ilock(ip, XFS_ILOCK_SHARED);
+	is_cow = xfs_reflink_is_cow_pending(ip, offset);
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+
+	return is_cow;
+}
+
 STATIC void
 xfs_vm_invalidatepage(
 	struct page		*page,
@@ -754,6 +794,7 @@ xfs_writepage_map(
 	int			error = 0;
 	int			count = 0;
 	int			uptodate = 1;
+	unsigned int		new_type;
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
@@ -785,8 +826,11 @@ xfs_writepage_map(
 				wpc->imap_valid = false;
 			}
 		} else if (buffer_uptodate(bh)) {
-			if (wpc->io_type != XFS_IO_OVERWRITE) {
-				wpc->io_type = XFS_IO_OVERWRITE;
+			new_type = xfs_is_cow_io(XFS_I(inode), offset) ?
+					XFS_IO_COW : XFS_IO_OVERWRITE;
+
+			if (wpc->io_type != new_type) {
+				wpc->io_type = new_type;
 				wpc->imap_valid = false;
 			}
 		} else {
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index bf2d9a1..5460db1 100644
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
index eea0120..48c8a6e 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -296,3 +296,109 @@ xfs_reflink_reserve_cow_range(
 		trace_xfs_reflink_reserve_cow_range_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/*
+ * Determine if there's a CoW reservation at a byte offset of an inode.
+ */
+bool
+xfs_reflink_is_cow_pending(
+	struct xfs_inode		*ip,
+	xfs_off_t			offset)
+{
+	struct xfs_ifork		*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec		irec;
+	xfs_fileoff_t			bno;
+	xfs_extnum_t			idx;
+
+	if (!xfs_is_reflink_inode(ip))
+		return false;
+
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
+	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
+
+	if (!gotp)
+		return false;
+
+	xfs_bmbt_get_all(gotp, &irec);
+	if (bno >= irec.br_startoff + irec.br_blockcount ||
+	    bno < irec.br_startoff)
+		return false;
+	return true;
+}
+
+/*
+ * Find the CoW reservation (and whether or not it needs block allocation)
+ * for a given byte offset of a file.
+ */
+int
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
+	/* Find the extent in the CoW fork. */
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	bno = XFS_B_TO_FSBT(ip->i_mount, offset);
+	gotp = xfs_iext_bno_to_ext(ifp, bno, &idx);
+	xfs_bmbt_get_all(gotp, &irec);
+
+	trace_xfs_reflink_find_cow_mapping(ip, offset, 1, XFS_IO_OVERWRITE,
+			&irec);
+
+	/* If it's still delalloc, we must allocate later. */
+	*imap = irec;
+	*need_alloc = !!(isnullstartblock(irec.br_startblock));
+
+	return 0;
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
index a724cb8..5dd0ff9 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -25,5 +25,10 @@ extern int xfs_reflink_find_shared(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_extlen_t *flen, bool find_maximal);
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip,
 		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb);
+extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);
+extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
+		struct xfs_bmbt_irec *imap, bool *need_alloc);
+extern int xfs_reflink_trim_irec_to_next_cow(struct xfs_inode *ip,
+		xfs_fileoff_t offset_fsb, struct xfs_bmbt_irec *imap);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
