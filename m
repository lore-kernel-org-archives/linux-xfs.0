Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98C047E23
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:26:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5C7EC304039
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:58 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id N5z9I6S1nBUX0qtR (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:26:55 -0700 (PDT)
Subject: [PATCH 084/119] xfs: implement CoW for directio writes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:26:50 -0700
Message-ID: <146612681049.12839.2763550972204033113.stgit@birch.djwong.org>
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

For O_DIRECT writes to shared blocks, we have to CoW them just like
we would with buffered writes.  For writes that are not block-aligned,
just bounce them to the page cache.

For block-aligned writes, however, we can do better than that.  Use
the same mechanisms that we employ for buffered CoW to set up a
delalloc reservation, allocate all the blocks at once, issue the
writes against the new blocks and use the same ioend functions to
remap the blocks after the write.  This should be fairly performant.

v2: Turns out that there's no way for xfs_end_io_direct_write to know
if the write completed successfully.  Therefore, do /not/ use the
ioend for dio cow post-processing; instead, move it to xfs_vm_do_dio
where we *can* tell if the write succeeded or not.

v3: Update the file size if we do a directio CoW across EOF.  This
can happen if the last block is shared, the cowextsize hint is set,
and we do a dio write past the end of the file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |  112 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_file.c    |   12 ++++-
 fs/xfs/xfs_reflink.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    5 ++
 4 files changed, 225 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 232039c..31318b3 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -40,6 +40,7 @@
 /* flags for direct write completions */
 #define XFS_DIO_FLAG_UNWRITTEN	(1 << 0)
 #define XFS_DIO_FLAG_APPEND	(1 << 1)
+#define XFS_DIO_FLAG_COW	(1 << 2)
 
 /*
  * structure owned by writepages passed to individual writepage calls
@@ -1130,18 +1131,24 @@ xfs_map_direct(
 	struct inode		*inode,
 	struct buffer_head	*bh_result,
 	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset)
+	xfs_off_t		offset,
+	bool			is_cow)
 {
 	uintptr_t		*flags = (uintptr_t *)&bh_result->b_private;
 	xfs_off_t		size = bh_result->b_size;
 
 	trace_xfs_get_blocks_map_direct(XFS_I(inode), offset, size,
-		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : XFS_IO_OVERWRITE, imap);
+		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : is_cow ? XFS_IO_COW :
+		XFS_IO_OVERWRITE, imap);
 
 	if (ISUNWRITTEN(imap)) {
 		*flags |= XFS_DIO_FLAG_UNWRITTEN;
 		set_buffer_defer_completion(bh_result);
-	} else if (offset + size > i_size_read(inode) || offset + size < 0) {
+	} else if (is_cow) {
+		*flags |= XFS_DIO_FLAG_COW;
+		set_buffer_defer_completion(bh_result);
+	}
+	if (offset + size > i_size_read(inode) || offset + size < 0) {
 		*flags |= XFS_DIO_FLAG_APPEND;
 		set_buffer_defer_completion(bh_result);
 	}
@@ -1187,6 +1194,43 @@ xfs_map_trim_size(
 	bh_result->b_size = mapping_size;
 }
 
+/* Bounce unaligned directio writes to the page cache. */
+static int
+xfs_bounce_unaligned_dio_write(
+	struct xfs_inode	*ip,
+	xfs_fileoff_t		offset_fsb,
+	struct xfs_bmbt_irec	*imap)
+{
+	bool			shared;
+	struct xfs_bmbt_irec	irec;
+	xfs_fileoff_t		delta;
+	int			error;
+
+	irec = *imap;
+	if (offset_fsb > irec.br_startoff) {
+		delta = offset_fsb - irec.br_startoff;
+		irec.br_blockcount -= delta;
+		irec.br_startblock += delta;
+		irec.br_startoff = offset_fsb;
+	}
+	error = xfs_reflink_irec_is_shared(ip, &irec, &shared);
+	if (error)
+		return error;
+	/*
+	 * Are we doing a DIO write to a shared block?  In
+	 * the ideal world we at least would fork full blocks,
+	 * but for now just fall back to buffered mode.  Yuck.
+	 * Use -EREMCHG ("remote address changed") to signal
+	 * this, since in general XFS doesn't do this sort of
+	 * fallback.
+	 */
+	if (shared) {
+		trace_xfs_reflink_bounce_dio_write(ip, imap);
+		return -EREMCHG;
+	}
+	return 0;
+}
+
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1206,6 +1250,8 @@ __xfs_get_blocks(
 	xfs_off_t		offset;
 	ssize_t			size;
 	int			new = 0;
+	bool			is_cow = false;
+	bool			need_alloc = false;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1237,8 +1283,27 @@ __xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, XFS_BMAPI_ENTIRE);
+	if (create && direct)
+		is_cow = xfs_reflink_is_cow_pending(ip, offset);
+	if (is_cow)
+		error = xfs_reflink_find_cow_mapping(ip, offset, &imap,
+						     &need_alloc);
+	else {
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+					&imap, &nimaps, XFS_BMAPI_ENTIRE);
+		/*
+		 * Truncate an overwrite extent if there's a pending CoW
+		 * reservation before the end of this extent.  This forces us
+		 * to come back to writepage to take care of the CoW.
+		 */
+		if (create && direct && nimaps &&
+		    imap.br_startblock != HOLESTARTBLOCK &&
+		    imap.br_startblock != DELAYSTARTBLOCK &&
+		    !ISUNWRITTEN(&imap))
+			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb,
+					&imap);
+	}
+	ASSERT(!need_alloc);
 	if (error)
 		goto out_unlock;
 
@@ -1310,6 +1375,13 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
+		if (create && direct && !is_cow) {
+			error = xfs_bounce_unaligned_dio_write(ip, offset_fsb,
+					&imap);
+			if (error)
+				return error;
+		}
+
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
@@ -1318,7 +1390,8 @@ __xfs_get_blocks(
 			if (dax_fault)
 				ASSERT(!ISUNWRITTEN(&imap));
 			else
-				xfs_map_direct(inode, bh_result, &imap, offset);
+				xfs_map_direct(inode, bh_result, &imap, offset,
+						is_cow);
 		}
 	}
 
@@ -1452,7 +1525,11 @@ xfs_end_io_direct_write(
 		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
 
 		error = xfs_iomap_write_unwritten(ip, offset, size);
-	} else if (flags & XFS_DIO_FLAG_APPEND) {
+	}
+	if (flags & XFS_DIO_FLAG_COW) {
+		error = xfs_reflink_end_cow(ip, offset, size);
+	}
+	if (flags & XFS_DIO_FLAG_APPEND) {
 		struct xfs_trans *tp;
 
 		trace_xfs_end_io_direct_write_append(ip, offset, size);
@@ -1475,6 +1552,27 @@ xfs_vm_direct_IO(
 	dio_iodone_t		*endio = NULL;
 	int			flags = 0;
 	struct block_device	*bdev;
+	loff_t			end;
+	loff_t			block_mask;
+	bool			dio_cow = false;
+	int			error;
+
+	/* If this is a block-aligned directio CoW, remap immediately. */
+	end = iocb->ki_pos + iov_iter_count(iter);
+	block_mask = (1 << inode->i_blkbits) - 1;
+	if (iov_iter_rw(iter) == WRITE &&
+	    xfs_is_reflink_inode(XFS_I(inode)) &&
+	    !((iocb->ki_pos | end) & block_mask)) {
+		dio_cow = true;
+		error = xfs_reflink_reserve_cow_range(XFS_I(inode),
+				iocb->ki_pos, iov_iter_count(iter));
+		if (error)
+			return error;
+		error = xfs_reflink_allocate_cow_range(XFS_I(inode),
+				iocb->ki_pos, iov_iter_count(iter));
+		if (error)
+			return error;
+	}
 
 	if (iov_iter_rw(iter) == WRITE) {
 		endio = xfs_end_io_direct_write;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 148d0b3..b979f01 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -896,10 +896,18 @@ xfs_file_write_iter(
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -EIO;
 
-	if ((iocb->ki_flags & IOCB_DIRECT) || IS_DAX(inode))
+	/*
+	 * Allow DIO to fall back to buffered *only* in the case that we're
+	 * doing a reflink CoW.
+	 */
+	if ((iocb->ki_flags & IOCB_DIRECT) || IS_DAX(inode)) {
 		ret = xfs_file_dio_aio_write(iocb, from);
-	else
+		if (ret == -EREMCHG)
+			goto buffered;
+	} else {
+buffered:
 		ret = xfs_file_buffered_aio_write(iocb, from);
+	}
 
 	if (ret > 0) {
 		XFS_STATS_ADD(ip->i_mount, xs_write_bytes, ret);
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 59c8e86..113f333 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -146,6 +146,51 @@ xfs_trim_extent(
 	}
 }
 
+/*
+ * Determine if any of the blocks in this mapping are shared.
+ */
+int
+xfs_reflink_irec_is_shared(
+	struct xfs_inode	*ip,
+	struct xfs_bmbt_irec	*irec,
+	bool			*shared)
+{
+	xfs_agnumber_t		agno;
+	xfs_agblock_t		agbno;
+	xfs_extlen_t		aglen;
+	xfs_agblock_t		fbno;
+	xfs_extlen_t		flen;
+	int			error = 0;
+
+	/* Holes, unwritten, and delalloc extents cannot be shared */
+	if (!xfs_is_reflink_inode(ip) ||
+	    ISUNWRITTEN(irec) ||
+	    irec->br_startblock == HOLESTARTBLOCK ||
+	    irec->br_startblock == DELAYSTARTBLOCK) {
+		*shared = false;
+		return 0;
+	}
+
+	trace_xfs_reflink_irec_is_shared(ip, irec);
+
+	agno = XFS_FSB_TO_AGNO(ip->i_mount, irec->br_startblock);
+	agbno = XFS_FSB_TO_AGBNO(ip->i_mount, irec->br_startblock);
+	aglen = irec->br_blockcount;
+
+	/* Are there any shared blocks here? */
+	error = xfs_refcount_find_shared(ip->i_mount, agno, agbno,
+			aglen, &fbno, &flen, false);
+	if (error)
+		return error;
+	if (flen == 0) {
+		*shared = false;
+		return 0;
+	}
+
+	*shared = true;
+	return 0;
+}
+
 /* Find the shared ranges under an irec, and set up delalloc extents. */
 static int
 xfs_reflink_reserve_cow_extent(
@@ -273,6 +318,66 @@ xfs_reflink_reserve_cow_range(
 }
 
 /*
+ * Allocate blocks to all CoW reservations within a byte range of a file.
+ */
+int
+xfs_reflink_allocate_cow_range(
+	struct xfs_inode	*ip,
+	xfs_off_t		pos,
+	xfs_off_t		len)
+{
+	struct xfs_ifork	*ifp;
+	struct xfs_bmbt_rec_host	*gotp;
+	struct xfs_bmbt_irec	imap;
+	int			error = 0;
+	xfs_fileoff_t		start_lblk;
+	xfs_fileoff_t		end_lblk;
+	xfs_extnum_t		idx;
+
+	if (!xfs_is_reflink_inode(ip))
+		return 0;
+
+	trace_xfs_reflink_allocate_cow_range(ip, len, pos, 0);
+
+	start_lblk = XFS_B_TO_FSBT(ip->i_mount, pos);
+	end_lblk = XFS_B_TO_FSB(ip->i_mount, pos + len);
+	ifp = XFS_IFORK_PTR(ip, XFS_COW_FORK);
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	gotp = xfs_iext_bno_to_ext(ifp, start_lblk, &idx);
+	while (gotp) {
+		xfs_bmbt_get_all(gotp, &imap);
+
+		if (imap.br_startoff >= end_lblk)
+			break;
+		if (!isnullstartblock(imap.br_startblock))
+			goto advloop;
+		xfs_trim_extent(&imap, start_lblk, end_lblk - start_lblk);
+		trace_xfs_reflink_allocate_cow_extent(ip, &imap);
+
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		error = xfs_iomap_write_allocate(ip, XFS_COW_FORK,
+				XFS_FSB_TO_B(ip->i_mount, imap.br_startoff +
+						imap.br_blockcount - 1), &imap);
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		if (error)
+			break;
+advloop:
+		/* Roll on... */
+		idx++;
+		if (idx >= ifp->if_bytes / sizeof(xfs_bmbt_rec_t))
+			break;
+		gotp = xfs_iext_get_ext(ifp, idx);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	if (error)
+		trace_xfs_reflink_allocate_cow_range_error(ip, error, _RET_IP_);
+	return error;
+}
+
+/*
  * Determine if there's a CoW reservation at a byte offset of an inode.
  */
 bool
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 27ae6c0..fb128dd 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -20,8 +20,13 @@
 #ifndef __XFS_REFLINK_H
 #define __XFS_REFLINK_H 1
 
+extern int xfs_reflink_irec_is_shared(struct xfs_inode *ip,
+		struct xfs_bmbt_irec *imap, bool *shared);
+
 extern int xfs_reflink_reserve_cow_range(struct xfs_inode *ip, xfs_off_t pos,
 		xfs_off_t len);
+extern int xfs_reflink_allocate_cow_range(struct xfs_inode *ip, xfs_off_t pos,
+		xfs_off_t len);
 extern bool xfs_reflink_is_cow_pending(struct xfs_inode *ip, xfs_off_t offset);
 extern int xfs_reflink_find_cow_mapping(struct xfs_inode *ip, xfs_off_t offset,
 		struct xfs_bmbt_irec *imap, bool *need_alloc);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
