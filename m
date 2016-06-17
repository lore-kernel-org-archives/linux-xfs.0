Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F061D7E18
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:26:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 65375AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:39 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 08vh6BcAuyC4dGaq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:36 -0700 (PDT)
Subject: [PATCH 081/119] xfs: allocate delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:26:30 -0700
Message-ID: <146612679068.12839.13248247674043879834.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Modify the writepage handler to find and convert pending delalloc
extents to real allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   57 ++++++++++++++++++++++++---
 fs/xfs/xfs_aops.h    |    4 +-
 fs/xfs/xfs_reflink.c |  106 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    5 ++
 4 files changed, 164 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 50c4bf11..802d432 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -312,10 +312,15 @@ xfs_map_blocks(
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
 
@@ -328,16 +333,29 @@ xfs_map_blocks(
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
@@ -625,7 +643,8 @@ xfs_check_page_type(
 			if (type == XFS_IO_DELALLOC)
 				return true;
 		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
-			if (type == XFS_IO_OVERWRITE)
+			if (type == XFS_IO_OVERWRITE ||
+			    type == XFS_IO_COW)
 				return true;
 		}
 
@@ -637,6 +656,26 @@ xfs_check_page_type(
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
@@ -745,6 +784,7 @@ xfs_writepage_map(
 	int			error = 0;
 	int			count = 0;
 	int			uptodate = 1;
+	unsigned int		new_type;
 
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
@@ -776,8 +816,11 @@ xfs_writepage_map(
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
index 814aab7..ee64d57 100644
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
index 112d86b..f0a9e42 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -270,3 +270,109 @@ xfs_reflink_reserve_cow_range(
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
index 7b0a215..a2a23f5 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -22,5 +22,10 @@
 
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip, xfs_off_t pos,
 		xfs_off_t len);
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
