Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C92E58107
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:03:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC0C2304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:11 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id dX92zb37yL6W5lQ3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:03:09 -0800 (PST)
Subject: [PATCH 60/76] xfs: implement CoW for directio writes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:03:07 -0800
Message-ID: <20151219090307.12713.60312.stgit@birch.djwong.org>
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

For O_DIRECT writes to shared blocks, we have to CoW them just like
we would with buffered writes.  For writes that are not block-aligned,
just bounce them to the page cache.

For block-aligned writes, however, we can do better than that.  Use
the same mechanisms that we employ for buffered CoW to set up a
delalloc reservation, allocate all the blocks at once, issue the
writes against the new blocks and use the same ioend functions to
remap the blocks after the write.  This should be fairly performant.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_aops.c    |   63 +++++++++++++++++++++++++---
 fs/xfs/xfs_file.c    |   12 ++++-
 fs/xfs/xfs_reflink.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_reflink.h |    5 ++
 4 files changed, 186 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 8101d6a..4b77d07 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1339,7 +1339,8 @@ xfs_map_direct(
 	struct buffer_head	*bh_result,
 	struct xfs_bmbt_irec	*imap,
 	xfs_off_t		offset,
-	bool			dax_fault)
+	bool			dax_fault,
+	bool			is_cow)
 {
 	struct xfs_ioend	*ioend;
 	xfs_off_t		size = bh_result->b_size;
@@ -1368,20 +1369,23 @@ xfs_map_direct(
 
 		if (type == XFS_IO_UNWRITTEN && type != ioend->io_type)
 			ioend->io_type = XFS_IO_UNWRITTEN;
+		if (is_cow)
+			ioend->io_flags |= XFS_IOEND_COW;
 
 		trace_xfs_gbmap_direct_update(XFS_I(inode), ioend->io_offset,
 					      ioend->io_size, ioend->io_type,
 					      imap);
-	} else if (type == XFS_IO_UNWRITTEN ||
+	} else if (type == XFS_IO_UNWRITTEN || is_cow ||
 		   offset + size > i_size_read(inode) ||
 		   offset + size < 0) {
 		ioend = xfs_alloc_ioend(inode, type);
 		ioend->io_offset = offset;
 		ioend->io_size = size;
+		if (is_cow)
+			ioend->io_flags |= XFS_IOEND_COW;
 
 		bh_result->b_private = ioend;
 		set_buffer_defer_completion(bh_result);
-
 		trace_xfs_gbmap_direct_new(XFS_I(inode), offset, size, type,
 					   imap);
 	} else {
@@ -1449,6 +1453,8 @@ __xfs_get_blocks(
 	xfs_off_t		offset;
 	ssize_t			size;
 	int			new = 0;
+	bool			is_cow = false;
+	bool			need_alloc = false;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1480,8 +1486,15 @@ __xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-				&imap, &nimaps, XFS_BMAPI_ENTIRE);
+	if (create && direct)
+		is_cow = xfs_reflink_is_cow_pending(ip, offset);
+	if (is_cow)
+		error = xfs_reflink_find_cow_mapping(ip, offset, &imap,
+						     &need_alloc);
+	else
+		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+					&imap, &nimaps, XFS_BMAPI_ENTIRE);
+	ASSERT(!need_alloc);
 	if (error)
 		goto out_unlock;
 
@@ -1553,13 +1566,33 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
+		if (create && direct && !is_cow) {
+			bool shared;
+
+			error = xfs_reflink_irec_is_shared(ip, &imap, &shared);
+			if (error)
+				return error;
+			/*
+			 * Are we doing a DIO write to a shared block?  In
+			 * the ideal world we at least would fork full blocks,
+			 * but for now just fall back to buffered mode.  Yuck.
+			 * Use -EREMCHG ("remote address changed") to signal
+			 * this, since in general XFS doesn't do this sort of
+			 * fallback.
+			 */
+			if (shared) {
+				trace_xfs_reflink_bounce_dio_write(ip, &imap);
+				return -EREMCHG;
+			}
+		}
+
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
 		/* direct IO needs special help */
 		if (create && direct)
 			xfs_map_direct(inode, bh_result, &imap, offset,
-				       dax_fault);
+				       dax_fault, is_cow);
 	}
 
 	/*
@@ -1738,6 +1771,24 @@ xfs_vm_do_dio(
 	int			flags)
 {
 	struct block_device	*bdev;
+	loff_t			end;
+	loff_t			block_mask;
+	int			error;
+
+	/* If this is a block-aligned directio CoW, remap immediately. */
+	end = offset + iov_iter_count(iter);
+	block_mask = (1 << inode->i_blkbits) - 1;
+	if (xfs_is_reflink_inode(XFS_I(inode)) && iov_iter_rw(iter) == WRITE &&
+	    !(offset & block_mask) && !(end & block_mask)) {
+		error = xfs_reflink_reserve_cow_range(XFS_I(inode), offset,
+				iov_iter_count(iter));
+		if (error)
+			return error;
+		error = xfs_reflink_allocate_cow_range(XFS_I(inode), offset,
+				iov_iter_count(iter));
+		if (error)
+			return error;
+	}
 
 	if (IS_DAX(inode))
 		return dax_do_io(iocb, inode, iter, offset,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 0fbcb38..31b002e 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -892,10 +892,18 @@ xfs_file_write_iter(
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
 		ssize_t err;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9c1c262..8594bc4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -134,6 +134,56 @@ xfs_trim_extent(
 	}
 }
 
+/**
+ * xfs_reflink_irec_is_shared() -- Are any of the blocks in this mapping
+ *				   shared?
+ *
+ * @ip: XFS inode object
+ * @irec: the fileoff:fsblock mapping that we might fork
+ * @shared: set to true if the mapping is shared.
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
 STATIC int
 xfs_reflink_reserve_cow_extent(
@@ -251,6 +301,70 @@ xfs_reflink_reserve_cow_range(
 }
 
 /**
+ * xfs_reflink_allocate_cow_range() -- Allocate blocks to satisfy a copy on
+ *				       write operation.
+ * @ip: XFS inode.
+ * @pos: file offset to start CoWing.
+ * @len: number of bytes to CoW.
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
+/**
  * xfs_reflink_is_cow_pending() -- Determine if CoW is pending for a given
  *				   file and offset.
  *
diff --git a/fs/xfs/xfs_reflink.h b/fs/xfs/xfs_reflink.h
index 8ec1ebb..d356c00 100644
--- a/fs/xfs/xfs_reflink.h
+++ b/fs/xfs/xfs_reflink.h
@@ -18,8 +18,13 @@
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
