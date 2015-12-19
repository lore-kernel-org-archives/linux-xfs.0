Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7184280E0
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:02:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63337304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:53 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id iRZYlVmFPdNhSNUw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:02:51 -0800 (PST)
Subject: [PATCH 57/76] xfs: allocate delayed extents in CoW fork
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:02:48 -0800
Message-ID: <20151219090248.12713.32309.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Modify the writepage handler to find and convert pending delalloc
extents to real allocations.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   63 +++++++++++++++++++++++++++++++++++---------
 fs/xfs/xfs_aops.h    |   10 +++++++
 fs/xfs/xfs_reflink.c |   72 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    3 ++
 4 files changed, 135 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 13629d2..7179b25 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -285,7 +285,8 @@ xfs_map_blocks(
 	loff_t			offset,
 	struct xfs_bmbt_irec	*imap,
 	int			type,
-	int			nonblocking)
+	int			nonblocking,
+	bool			is_cow)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -294,10 +295,15 @@ xfs_map_blocks(
 	int			error = 0;
 	int			bmapi_flags = XFS_BMAPI_ENTIRE;
 	int			nimaps = 1;
+	int			whichfork;
+	bool			need_alloc;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	whichfork = (is_cow ? XFS_COW_FORK : XFS_DATA_FORK);
+	need_alloc = (type == XFS_IO_DELALLOC);
+
 	if (type == XFS_IO_UNWRITTEN)
 		bmapi_flags |= XFS_BMAPI_IGSTATE;
 
@@ -315,16 +321,21 @@ xfs_map_blocks(
 		count = mp->m_super->s_maxbytes - offset;
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + count);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				imap, &nimaps, bmapi_flags);
+
+	if (is_cow)
+		error = xfs_reflink_find_cow_mapping(ip, offset, imap,
+						     &need_alloc);
+	else
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				       imap, &nimaps, bmapi_flags);
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
@@ -575,7 +586,8 @@ xfs_add_to_ioend(
 	xfs_off_t		offset,
 	unsigned int		type,
 	xfs_ioend_t		**result,
-	int			need_ioend)
+	int			need_ioend,
+	bool			is_cow)
 {
 	xfs_ioend_t		*ioend = *result;
 
@@ -593,6 +605,8 @@ xfs_add_to_ioend(
 		ioend->io_buffer_tail->b_private = bh;
 		ioend->io_buffer_tail = bh;
 	}
+	if (is_cow)
+		ioend->io_flags |= XFS_IOEND_COW;
 
 	bh->b_private = NULL;
 	ioend->io_size += bh->b_size;
@@ -703,6 +717,8 @@ xfs_convert_page(
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
  	xfs_off_t		offset = page_offset(page);
+	bool			is_cow;
+	struct xfs_inode	*ip = XFS_I(inode);
 
 	if (page->index != tindex)
 		goto fail;
@@ -786,6 +802,15 @@ xfs_convert_page(
 			else
 				type = XFS_IO_OVERWRITE;
 
+			/* Figure out if CoW is pending for the other pages. */
+			is_cow = false;
+			if (type == XFS_IO_OVERWRITE &&
+			    xfs_sb_version_hasreflink(&ip->i_mount->m_sb)) {
+				xfs_ilock(ip, XFS_ILOCK_SHARED);
+				is_cow = xfs_reflink_is_cow_pending(ip, offset);
+				xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			}
+
 			/*
 			 * imap should always be valid because of the above
 			 * partial page end_offset check on the imap.
@@ -793,10 +818,10 @@ xfs_convert_page(
 			ASSERT(xfs_imap_valid(inode, imap, offset));
 
 			lock_buffer(bh);
-			if (type != XFS_IO_OVERWRITE)
+			if (type != XFS_IO_OVERWRITE || is_cow)
 				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
+					 ioendp, done, is_cow);
 
 			page_dirty--;
 			count++;
@@ -959,6 +984,8 @@ xfs_vm_writepage(
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			nonblocking = 0;
+	struct xfs_inode	*ip = XFS_I(inode);
+	bool			was_cow, is_cow;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -1057,6 +1084,7 @@ xfs_vm_writepage(
 	bh = head = page_buffers(page);
 	offset = page_offset(page);
 	type = XFS_IO_OVERWRITE;
+	was_cow = false;
 
 	if (wbc->sync_mode == WB_SYNC_NONE)
 		nonblocking = 1;
@@ -1069,6 +1097,7 @@ xfs_vm_writepage(
 		if (!buffer_uptodate(bh))
 			uptodate = 0;
 
+		is_cow = false;
 		/*
 		 * set_page_dirty dirties all buffers in a page, independent
 		 * of their state.  The dirty state however is entirely
@@ -1091,7 +1120,15 @@ xfs_vm_writepage(
 				imap_valid = 0;
 			}
 		} else if (buffer_uptodate(bh)) {
-			if (type != XFS_IO_OVERWRITE) {
+			if (xfs_sb_version_hasreflink(&ip->i_mount->m_sb)) {
+				xfs_ilock(ip, XFS_ILOCK_SHARED);
+				is_cow = xfs_reflink_is_cow_pending(ip,
+						offset);
+				xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			}
+
+			if (type != XFS_IO_OVERWRITE ||
+			    is_cow != was_cow) {
 				type = XFS_IO_OVERWRITE;
 				imap_valid = 0;
 			}
@@ -1121,23 +1158,23 @@ xfs_vm_writepage(
 			 */
 			new_ioend = 1;
 			err = xfs_map_blocks(inode, offset, &imap, type,
-					     nonblocking);
+					     nonblocking, is_cow);
 			if (err)
 				goto error;
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 		}
 		if (imap_valid) {
 			lock_buffer(bh);
-			if (type != XFS_IO_OVERWRITE)
+			if (type != XFS_IO_OVERWRITE || is_cow)
 				xfs_map_at_offset(inode, bh, &imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type, &ioend,
-					 new_ioend);
+					 new_ioend, is_cow);
 			count++;
 		}
 
 		if (!iohead)
 			iohead = ioend;
-
+		was_cow = is_cow;
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
 	if (uptodate && bh == head)
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index f6ffc9a..ac59548 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -34,6 +34,8 @@ enum {
 	{ XFS_IO_UNWRITTEN,		"unwritten" }, \
 	{ XFS_IO_OVERWRITE,		"overwrite" }
 
+#define XFS_IOEND_COW		(1)
+
 /*
  * xfs_ioend struct manages large extent writes for XFS.
  * It can manage several multi-page bio's at once.
@@ -50,8 +52,16 @@ typedef struct xfs_ioend {
 	xfs_off_t		io_offset;	/* offset in the file */
 	struct work_struct	io_work;	/* xfsdatad work queue */
 	struct xfs_trans	*io_append_trans;/* xact. for size update */
+	unsigned long		io_flags;	/* status flags */
 } xfs_ioend_t;
 
+static inline bool
+xfs_ioend_is_cow(
+	struct xfs_ioend	*ioend)
+{
+	return ioend->io_flags & XFS_IOEND_COW;
+}
+
 extern const struct address_space_operations xfs_address_space_operations;
 
 int	xfs_get_blocks(struct inode *inode, sector_t offset,
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index fdc538e..65d4c2d 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -249,3 +249,75 @@ xfs_reflink_reserve_cow_range(
 		trace_xfs_reflink_reserve_cow_range_error(ip, error, _RET_IP_);
 	return error;
 }
+
+/**
+ * xfs_reflink_is_cow_pending() -- Determine if CoW is pending for a given
+ *				   file and offset.
+ *
+ * @ip: XFS inode object.
+ * @offset: The file offset, in bytes.
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
+/**
+ * xfs_reflink_find_cow_mapping() -- Find the mapping for a CoW block.
+ *
+ * @ip: The XFS inode object.
+ * @offset: The file offset, in bytes.
+ * @imap: The mapping we're going to use for this block.
+ * @nimaps: Number of mappings we're returning.
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
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 41afdbe..1018ac9 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,5 +20,8 @@
 
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip, xfs_off_t pos,
 		xfs_off_t len);
+extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);
+extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
+		struct xfs_bmbt_irec *imap, bool *need_alloc);
 
 #endif /* __XFS_REFLINK_H */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
