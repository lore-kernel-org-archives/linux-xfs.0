Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2REcShA093912 for <xfs@oss.sgi.com>; Tue, 27 Mar 2012 09:38:29 -0500
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	Sa6az2UWt2LppIuv (version=TLSv1 cipher=AES256-SHA bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 27 Mar 2012 07:38:27 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1SCXXW-0004KN-R6
	for xfs@oss.sgi.com; Tue, 27 Mar 2012 14:38:26 +0000
Message-Id: <20120327143826.792184421@bombadil.infradead.org>
Date: Tue, 27 Mar 2012 10:34:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/5] xfs: push the ilock into xfs_zero_eof
References: <20120327143445.196524266@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-push-ilock-into-xfs_zero_eof
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Instead of calling xfs_zero_eof with the ilock held only take it internally
for the minimall required critical section around xfs_bmapi_read.  This
also requires changing the calling convention for xfs_zero_last_block
slightly.  The actual zeroing operation is still serialized by the iolock,
which must be taken exclusively over the call to xfs_zero_eof.

We could in fact use a shared lock for the xfs_bmapi_read calls as long as
the extent list has been read in, but given that we already hold the iolock
exclusively there is little reason to micro optimize this further.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_file.c |  161 ++++++++++++++++++++----------------------------------
 fs/xfs/xfs_iops.c |    2 
 2 files changed, 62 insertions(+), 101 deletions(-)

Index: xfs/fs/xfs/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/xfs_file.c	2012-03-27 08:04:56.098971158 +0200
+++ xfs/fs/xfs/xfs_file.c	2012-03-27 08:14:13.005954136 +0200
@@ -396,114 +396,96 @@ xfs_file_splice_write(
 }
 
 /*
- * This routine is called to handle zeroing any space in the last
- * block of the file that is beyond the EOF.  We do this since the
- * size is being increased without writing anything to that block
- * and we don't want anyone to read the garbage on the disk.
+ * This routine is called to handle zeroing any space in the last block of the
+ * file that is beyond the EOF.  We do this since the size is being increased
+ * without writing anything to that block and we don't want to read the
+ * garbage on the disk.
  */
 STATIC int				/* error (positive) */
 xfs_zero_last_block(
-	xfs_inode_t	*ip,
-	xfs_fsize_t	offset,
-	xfs_fsize_t	isize)
+	struct xfs_inode	*ip,
+	xfs_fsize_t		offset,
+	xfs_fsize_t		isize)
 {
-	xfs_fileoff_t	last_fsb;
-	xfs_mount_t	*mp = ip->i_mount;
-	int		nimaps;
-	int		zero_offset;
-	int		zero_len;
-	int		error = 0;
-	xfs_bmbt_irec_t	imap;
-
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	zero_offset = XFS_B_FSB_OFFSET(mp, isize);
-	if (zero_offset == 0) {
-		/*
-		 * There are no extra bytes in the last block on disk to
-		 * zero, so return.
-		 */
-		return 0;
-	}
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		last_fsb = XFS_B_TO_FSBT(mp, isize);
+	int			zero_offset = XFS_B_FSB_OFFSET(mp, isize);
+	int			zero_len;
+	int			nimaps = 1;
+	int			error = 0;
+	struct xfs_bmbt_irec	imap;
 
-	last_fsb = XFS_B_TO_FSBT(mp, isize);
-	nimaps = 1;
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	error = xfs_bmapi_read(ip, last_fsb, 1, &imap, &nimaps, 0);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	if (error)
 		return error;
+
 	ASSERT(nimaps > 0);
+
 	/*
 	 * If the block underlying isize is just a hole, then there
 	 * is nothing to zero.
 	 */
-	if (imap.br_startblock == HOLESTARTBLOCK) {
+	if (imap.br_startblock == HOLESTARTBLOCK)
 		return 0;
-	}
-	/*
-	 * Zero the part of the last block beyond the EOF, and write it
-	 * out sync.  We need to drop the ilock while we do this so we
-	 * don't deadlock when the buffer cache calls back to us.
-	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	zero_len = mp->m_sb.sb_blocksize - zero_offset;
 	if (isize + zero_len > offset)
 		zero_len = offset - isize;
-	error = xfs_iozero(ip, isize, zero_len);
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	ASSERT(error >= 0);
-	return error;
+	return xfs_iozero(ip, isize, zero_len);
 }
 
 /*
- * Zero any on disk space between the current EOF and the new,
- * larger EOF.  This handles the normal case of zeroing the remainder
- * of the last block in the file and the unusual case of zeroing blocks
- * out beyond the size of the file.  This second case only happens
- * with fixed size extents and when the system crashes before the inode
- * size was updated but after blocks were allocated.  If fill is set,
- * then any holes in the range are filled and zeroed.  If not, the holes
- * are left alone as holes.
+ * Zero any on disk space between the current EOF and the new, larger EOF.
+ *
+ * This handles the normal case of zeroing the remainder of the last block in
+ * the file and the unusual case of zeroing blocks out beyond the size of the
+ * file.  This second case only happens with fixed size extents and when the
+ * system crashes before the inode size was updated but after blocks were
+ * allocated.
+ *
+ * Expects the iolock to be held exclusive, and will take the ilock internally.
  */
-
 int					/* error (positive) */
 xfs_zero_eof(
-	xfs_inode_t	*ip,
-	xfs_off_t	offset,		/* starting I/O offset */
-	xfs_fsize_t	isize)		/* current inode size */
+	struct xfs_inode	*ip,
+	xfs_off_t		offset,		/* starting I/O offset */
+	xfs_fsize_t		isize)		/* current inode size */
 {
-	xfs_mount_t	*mp = ip->i_mount;
-	xfs_fileoff_t	start_zero_fsb;
-	xfs_fileoff_t	end_zero_fsb;
-	xfs_fileoff_t	zero_count_fsb;
-	xfs_fileoff_t	last_fsb;
-	xfs_fileoff_t	zero_off;
-	xfs_fsize_t	zero_len;
-	int		nimaps;
-	int		error = 0;
-	xfs_bmbt_irec_t	imap;
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		start_zero_fsb;
+	xfs_fileoff_t		end_zero_fsb;
+	xfs_fileoff_t		zero_count_fsb;
+	xfs_fileoff_t		last_fsb;
+	xfs_fileoff_t		zero_off;
+	xfs_fsize_t		zero_len;
+	int			nimaps;
+	int			error = 0;
+	struct xfs_bmbt_irec	imap;
 
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
 	ASSERT(offset > isize);
 
 	/*
 	 * First handle zeroing the block on which isize resides.
+	 *
 	 * We only zero a part of that block so it is handled specially.
 	 */
-	error = xfs_zero_last_block(ip, offset, isize);
-	if (error) {
-		ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
-		return error;
+	if (XFS_B_FSB_OFFSET(mp, isize) != 0) {
+		error = xfs_zero_last_block(ip, offset, isize);
+		if (error)
+			return error;
 	}
 
 	/*
-	 * Calculate the range between the new size and the old
-	 * where blocks needing to be zeroed may exist.  To get the
-	 * block where the last byte in the file currently resides,
-	 * we need to subtract one from the size and truncate back
-	 * to a block boundary.  We subtract 1 in case the size is
-	 * exactly on a block boundary.
+	 * Calculate the range between the new size and the old where blocks
+	 * needing to be zeroed may exist.
+	 *
+	 * To get the block where the last byte in the file currently resides,
+	 * we need to subtract one from the size and truncate back to a block
+	 * boundary.  We subtract 1 in case the size is exactly on a block
+	 * boundary.
 	 */
 	last_fsb = isize ? XFS_B_TO_FSBT(mp, isize - 1) : (xfs_fileoff_t)-1;
 	start_zero_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)isize);
@@ -521,23 +503,18 @@ xfs_zero_eof(
 	while (start_zero_fsb <= end_zero_fsb) {
 		nimaps = 1;
 		zero_count_fsb = end_zero_fsb - start_zero_fsb + 1;
+
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_bmapi_read(ip, start_zero_fsb, zero_count_fsb,
 					  &imap, &nimaps, 0);
-		if (error) {
-			ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_IOLOCK_EXCL));
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		if (error)
 			return error;
-		}
+
 		ASSERT(nimaps > 0);
 
 		if (imap.br_state == XFS_EXT_UNWRITTEN ||
 		    imap.br_startblock == HOLESTARTBLOCK) {
-			/*
-			 * This loop handles initializing pages that were
-			 * partially initialized by the code below this
-			 * loop. It basically zeroes the part of the page
-			 * that sits on a hole and sets the page as P_HOLE
-			 * and calls remapf if it is a mapped file.
-			 */
 			start_zero_fsb = imap.br_startoff + imap.br_blockcount;
 			ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
 			continue;
@@ -545,11 +522,7 @@ xfs_zero_eof(
 
 		/*
 		 * There are blocks we need to zero.
-		 * Drop the inode lock while we're doing the I/O.
-		 * We'll still have the iolock to protect us.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 		zero_off = XFS_FSB_TO_B(mp, start_zero_fsb);
 		zero_len = XFS_FSB_TO_B(mp, imap.br_blockcount);
 
@@ -557,22 +530,14 @@ xfs_zero_eof(
 			zero_len = offset - zero_off;
 
 		error = xfs_iozero(ip, zero_off, zero_len);
-		if (error) {
-			goto out_lock;
-		}
+		if (error)
+			return error;
 
 		start_zero_fsb = imap.br_startoff + imap.br_blockcount;
 		ASSERT(start_zero_fsb <= (end_zero_fsb + 1));
-
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 	}
 
 	return 0;
-
-out_lock:
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	ASSERT(error >= 0);
-	return error;
 }
 
 /*
@@ -612,9 +577,7 @@ restart:
 			xfs_rw_ilock(ip, *iolock);
 			goto restart;
 		}
-		xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 		error = -xfs_zero_eof(ip, *pos, i_size_read(inode));
-		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			return error;
 	}
Index: xfs/fs/xfs/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_iops.c	2012-03-27 08:05:08.098906150 +0200
+++ xfs/fs/xfs/xfs_iops.c	2012-03-27 08:05:08.438904309 +0200
@@ -764,9 +764,7 @@ xfs_setattr_size(
 		 * before the inode is joined to the transaction to modify
 		 * i_size.
 		 */
-		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		error = xfs_zero_eof(ip, newsize, oldsize);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
 			goto out_unlock;
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
