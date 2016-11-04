Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53102 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936176AbcKDQV2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Nov 2016 12:21:28 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: use iomap_dio_rw
Date: Fri,  4 Nov 2016 10:21:19 -0600
Message-Id: <1478276479-10749-6-git-send-email-hch@lst.de>
In-Reply-To: <1478276479-10749-1-git-send-email-hch@lst.de>
References: <1478276479-10749-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: axboe@fb.com, kent.overstreet@gmail.com, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org

Straight switch over to using iomap for direct I/O - we already have the
non-COW dio path in write_begin for DAX and files with extent size hints,
so nothing to add there.  The COW path is ported over from the old
get_blocks version and a bit of a mess, but I have some work in progress
to make it look more like the buffered I/O COW path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 198 ++---------------------------------------------------
 fs/xfs/xfs_aops.h  |   2 -
 fs/xfs/xfs_file.c  | 139 ++++++++++++++++---------------------
 fs/xfs/xfs_iomap.c |  53 +++++++++++---
 4 files changed, 108 insertions(+), 284 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 12d09f7..574be65 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -37,11 +37,6 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
-/* flags for direct write completions */
-#define XFS_DIO_FLAG_UNWRITTEN	(1 << 0)
-#define XFS_DIO_FLAG_APPEND	(1 << 1)
-#define XFS_DIO_FLAG_COW	(1 << 2)
-
 /*
  * structure owned by writepages passed to individual writepage calls
  */
@@ -1175,45 +1170,6 @@ xfs_vm_releasepage(
 }
 
 /*
- * When we map a DIO buffer, we may need to pass flags to
- * xfs_end_io_direct_write to tell it what kind of write IO we are doing.
- *
- * Note that for DIO, an IO to the highest supported file block offset (i.e.
- * 2^63 - 1FSB bytes) will result in the offset + count overflowing a signed 64
- * bit variable. Hence if we see this overflow, we have to assume that the IO is
- * extending the file size. We won't know for sure until IO completion is run
- * and the actual max write offset is communicated to the IO completion
- * routine.
- */
-static void
-xfs_map_direct(
-	struct inode		*inode,
-	struct buffer_head	*bh_result,
-	struct xfs_bmbt_irec	*imap,
-	xfs_off_t		offset,
-	bool			is_cow)
-{
-	uintptr_t		*flags = (uintptr_t *)&bh_result->b_private;
-	xfs_off_t		size = bh_result->b_size;
-
-	trace_xfs_get_blocks_map_direct(XFS_I(inode), offset, size,
-		ISUNWRITTEN(imap) ? XFS_IO_UNWRITTEN : is_cow ? XFS_IO_COW :
-		XFS_IO_OVERWRITE, imap);
-
-	if (ISUNWRITTEN(imap)) {
-		*flags |= XFS_DIO_FLAG_UNWRITTEN;
-		set_buffer_defer_completion(bh_result);
-	} else if (is_cow) {
-		*flags |= XFS_DIO_FLAG_COW;
-		set_buffer_defer_completion(bh_result);
-	}
-	if (offset + size > i_size_read(inode) || offset + size < 0) {
-		*flags |= XFS_DIO_FLAG_APPEND;
-		set_buffer_defer_completion(bh_result);
-	}
-}
-
-/*
  * If this is O_DIRECT or the mpage code calling tell them how large the mapping
  * is, so that we can avoid repeated get_blocks calls.
  *
@@ -1253,44 +1209,6 @@ xfs_map_trim_size(
 	bh_result->b_size = mapping_size;
 }
 
-/* Bounce unaligned directio writes to the page cache. */
-static int
-xfs_bounce_unaligned_dio_write(
-	struct xfs_inode	*ip,
-	xfs_fileoff_t		offset_fsb,
-	struct xfs_bmbt_irec	*imap)
-{
-	struct xfs_bmbt_irec	irec;
-	xfs_fileoff_t		delta;
-	bool			shared;
-	bool			x;
-	int			error;
-
-	irec = *imap;
-	if (offset_fsb > irec.br_startoff) {
-		delta = offset_fsb - irec.br_startoff;
-		irec.br_blockcount -= delta;
-		irec.br_startblock += delta;
-		irec.br_startoff = offset_fsb;
-	}
-	error = xfs_reflink_trim_around_shared(ip, &irec, &shared, &x);
-	if (error)
-		return error;
-
-	/*
-	 * We're here because we're trying to do a directio write to a
-	 * region that isn't aligned to a filesystem block.  If any part
-	 * of the extent is shared, fall back to buffered mode to handle
-	 * the RMW.  This is done by returning -EREMCHG ("remote addr
-	 * changed"), which is caught further up the call stack.
-	 */
-	if (shared) {
-		trace_xfs_reflink_bounce_dio_write(ip, imap);
-		return -EREMCHG;
-	}
-	return 0;
-}
-
 STATIC int
 __xfs_get_blocks(
 	struct inode		*inode,
@@ -1310,10 +1228,9 @@ __xfs_get_blocks(
 	xfs_off_t		offset;
 	ssize_t			size;
 	int			new = 0;
-	bool			is_cow = false;
-	bool			need_alloc = false;
 
 	BUG_ON(create && !direct);
+	BUG_ON(create && xfs_is_reflink_inode(ip));
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1337,26 +1254,8 @@ __xfs_get_blocks(
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + size);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 
-	if (create && direct && xfs_is_reflink_inode(ip))
-		is_cow = xfs_reflink_find_cow_mapping(ip, offset, &imap,
-					&need_alloc);
-	if (!is_cow) {
-		error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
-					&imap, &nimaps, XFS_BMAPI_ENTIRE);
-		/*
-		 * Truncate an overwrite extent if there's a pending CoW
-		 * reservation before the end of this extent.  This
-		 * forces us to come back to get_blocks to take care of
-		 * the CoW.
-		 */
-		if (create && direct && nimaps &&
-		    imap.br_startblock != HOLESTARTBLOCK &&
-		    imap.br_startblock != DELAYSTARTBLOCK &&
-		    !ISUNWRITTEN(&imap))
-			xfs_reflink_trim_irec_to_next_cow(ip, offset_fsb,
-					&imap);
-	}
-	ASSERT(!need_alloc);
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb,
+				&imap, &nimaps, XFS_BMAPI_ENTIRE);
 	if (error)
 		goto out_unlock;
 
@@ -1408,24 +1307,11 @@ __xfs_get_blocks(
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
 	    (create || !ISUNWRITTEN(&imap))) {
-		if (create && direct && !is_cow) {
-			error = xfs_bounce_unaligned_dio_write(ip, offset_fsb,
-					&imap);
-			if (error)
-				return error;
-		}
-
 		xfs_map_buffer(inode, bh_result, &imap, offset);
 		if (ISUNWRITTEN(&imap))
 			set_buffer_unwritten(bh_result);
-		/* direct IO needs special help */
-		if (create) {
-			if (dax_fault)
-				ASSERT(!ISUNWRITTEN(&imap));
-			else
-				xfs_map_direct(inode, bh_result, &imap, offset,
-						is_cow);
-		}
+		if (create && dax_fault)
+			ASSERT(!ISUNWRITTEN(&imap));
 	}
 
 	/*
@@ -1488,80 +1374,6 @@ xfs_get_blocks_dax_fault(
 	return __xfs_get_blocks(inode, iblock, bh_result, create, true, true);
 }
 
-/*
- * Complete a direct I/O write request.
- *
- * xfs_map_direct passes us some flags in the private data to tell us what to
- * do.  If no flags are set, then the write IO is an overwrite wholly within
- * the existing allocated file size and so there is nothing for us to do.
- *
- * Note that in this case the completion can be called in interrupt context,
- * whereas if we have flags set we will always be called in task context
- * (i.e. from a workqueue).
- */
-int
-xfs_end_io_direct_write(
-	struct kiocb		*iocb,
-	loff_t			offset,
-	ssize_t			size,
-	void			*private)
-{
-	struct inode		*inode = file_inode(iocb->ki_filp);
-	struct xfs_inode	*ip = XFS_I(inode);
-	uintptr_t		flags = (uintptr_t)private;
-	int			error = 0;
-
-	trace_xfs_end_io_direct_write(ip, offset, size);
-
-	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
-		return -EIO;
-
-	if (size <= 0)
-		return size;
-
-	/*
-	 * The flags tell us whether we are doing unwritten extent conversions
-	 * or an append transaction that updates the on-disk file size. These
-	 * cases are the only cases where we should *potentially* be needing
-	 * to update the VFS inode size.
-	 */
-	if (flags == 0) {
-		ASSERT(offset + size <= i_size_read(inode));
-		return 0;
-	}
-
-	/*
-	 * We need to update the in-core inode size here so that we don't end up
-	 * with the on-disk inode size being outside the in-core inode size. We
-	 * have no other method of updating EOF for AIO, so always do it here
-	 * if necessary.
-	 *
-	 * We need to lock the test/set EOF update as we can be racing with
-	 * other IO completions here to update the EOF. Failing to serialise
-	 * here can result in EOF moving backwards and Bad Things Happen when
-	 * that occurs.
-	 */
-	spin_lock(&ip->i_flags_lock);
-	if (offset + size > i_size_read(inode))
-		i_size_write(inode, offset + size);
-	spin_unlock(&ip->i_flags_lock);
-
-	if (flags & XFS_DIO_FLAG_COW)
-		error = xfs_reflink_end_cow(ip, offset, size);
-	if (flags & XFS_DIO_FLAG_UNWRITTEN) {
-		trace_xfs_end_io_direct_write_unwritten(ip, offset, size);
-
-		error = xfs_iomap_write_unwritten(ip, offset, size);
-	}
-	if (flags & XFS_DIO_FLAG_APPEND) {
-		trace_xfs_end_io_direct_write_append(ip, offset, size);
-
-		error = xfs_setfilesize(ip, offset, size);
-	}
-
-	return error;
-}
-
 STATIC ssize_t
 xfs_vm_direct_IO(
 	struct kiocb		*iocb,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index b3c6634..4dad884 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -62,8 +62,6 @@ int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
 int	xfs_get_blocks_dax_fault(struct inode *inode, sector_t offset,
 			         struct buffer_head *map_bh, int create);
 
-int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
-		ssize_t size, void *private);
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8830223..b7c7f01 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -210,62 +210,21 @@ xfs_file_dio_aio_read(
 	struct kiocb		*iocb,
 	struct iov_iter		*to)
 {
-	struct address_space	*mapping = iocb->ki_filp->f_mapping;
-	struct inode		*inode = mapping->host;
-	struct xfs_inode	*ip = XFS_I(inode);
-	loff_t			isize = i_size_read(inode);
+	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
 	size_t			count = iov_iter_count(to);
-	loff_t			end = iocb->ki_pos + count - 1;
-	struct iov_iter		data;
-	struct xfs_buftarg	*target;
-	ssize_t			ret = 0;
+	ssize_t			ret;
 
 	trace_xfs_file_direct_read(ip, count, iocb->ki_pos);
 
 	if (!count)
 		return 0; /* skip atime */
 
-	if (XFS_IS_REALTIME_INODE(ip))
-		target = ip->i_mount->m_rtdev_targp;
-	else
-		target = ip->i_mount->m_ddev_targp;
-
-	/* DIO must be aligned to device logical sector size */
-	if ((iocb->ki_pos | count) & target->bt_logical_sectormask) {
-		if (iocb->ki_pos == isize)
-			return 0;
-		return -EINVAL;
-	}
-
 	file_accessed(iocb->ki_filp);
 
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
-	if (mapping->nrpages) {
-		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
-		if (ret)
-			goto out_unlock;
-
-		/*
-		 * Invalidate whole pages. This can return an error if we fail
-		 * to invalidate a page, but this should never happen on XFS.
-		 * Warn if it does fail.
-		 */
-		ret = invalidate_inode_pages2_range(mapping,
-				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-		ret = 0;
-	}
-
-	data = *to;
-	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
-			xfs_get_blocks_direct, NULL, NULL, 0);
-	if (ret >= 0) {
-		iocb->ki_pos += ret;
-		iov_iter_advance(to, ret);
-	}
-
-out_unlock:
+	ret = iomap_dio_rw(iocb, to, &xfs_iomap_ops, NULL);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
+
 	return ret;
 }
 
@@ -465,6 +424,58 @@ xfs_file_aio_write_checks(
 	return 0;
 }
 
+static int
+xfs_dio_write_end_io(
+	struct kiocb		*iocb,
+	ssize_t			size,
+	unsigned		flags)
+{
+	struct inode		*inode = file_inode(iocb->ki_filp);
+	struct xfs_inode	*ip = XFS_I(inode);
+	loff_t			offset = iocb->ki_pos;
+	bool			update_size = false;
+	int			error = 0;
+
+	trace_xfs_end_io_direct_write(ip, offset, size);
+
+	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
+		return -EIO;
+
+	if (size <= 0)
+		return size;
+
+	/*
+	 * We need to update the in-core inode size here so that we don't end up
+	 * with the on-disk inode size being outside the in-core inode size. We
+	 * have no other method of updating EOF for AIO, so always do it here
+	 * if necessary.
+	 *
+	 * We need to lock the test/set EOF update as we can be racing with
+	 * other IO completions here to update the EOF. Failing to serialise
+	 * here can result in EOF moving backwards and Bad Things Happen when
+	 * that occurs.
+	 */
+	spin_lock(&ip->i_flags_lock);
+	if (offset + size > i_size_read(inode)) {
+		i_size_write(inode, offset + size);
+		update_size = true;
+	}
+	spin_unlock(&ip->i_flags_lock);
+
+	if (flags & IOMAP_DIO_COW) {
+		error = xfs_reflink_end_cow(ip, offset, size);
+		if (error)
+			return error;
+	}
+
+	if (flags & IOMAP_DIO_UNWRITTEN)
+		error = xfs_iomap_write_unwritten(ip, offset, size);
+	else if (update_size)
+		error = xfs_setfilesize(ip, offset, size);
+
+	return error;
+}
+
 /*
  * xfs_file_dio_aio_write - handle direct IO writes
  *
@@ -504,9 +515,7 @@ xfs_file_dio_aio_write(
 	int			unaligned_io = 0;
 	int			iolock;
 	size_t			count = iov_iter_count(from);
-	loff_t			end;
-	struct iov_iter		data;
-	struct xfs_buftarg	*target = XFS_IS_REALTIME_INODE(ip) ?
+	struct xfs_buftarg      *target = XFS_IS_REALTIME_INODE(ip) ?
 					mp->m_rtdev_targp : mp->m_ddev_targp;
 
 	/* DIO must be aligned to device logical sector size */
@@ -534,23 +543,6 @@ xfs_file_dio_aio_write(
 	if (ret)
 		goto out;
 	count = iov_iter_count(from);
-	end = iocb->ki_pos + count - 1;
-
-	if (mapping->nrpages) {
-		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
-		if (ret)
-			goto out;
-
-		/*
-		 * Invalidate whole pages. This can return an error if we fail
-		 * to invalidate a page, but this should never happen on XFS.
-		 * Warn if it does fail.
-		 */
-		ret = invalidate_inode_pages2_range(mapping,
-				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
-		WARN_ON_ONCE(ret);
-		ret = 0;
-	}
 
 	/*
 	 * If we are doing unaligned IO, wait for all other IO to drain,
@@ -573,22 +565,7 @@ xfs_file_dio_aio_write(
 			goto out;
 	}
 
-	data = *from;
-	ret = __blockdev_direct_IO(iocb, inode, target->bt_bdev, &data,
-			xfs_get_blocks_direct, xfs_end_io_direct_write,
-			NULL, DIO_ASYNC_EXTEND);
-
-	/* see generic_file_direct_write() for why this is necessary */
-	if (mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping,
-					      iocb->ki_pos >> PAGE_SHIFT,
-					      end >> PAGE_SHIFT);
-	}
-
-	if (ret > 0) {
-		iocb->ki_pos += ret;
-		iov_iter_advance(from, ret);
-	}
+	ret = iomap_dio_rw(iocb, from, &xfs_iomap_ops, xfs_dio_write_end_io);
 out:
 	xfs_iunlock(ip, iolock);
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 436e109..9444170 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -960,6 +960,19 @@ static inline bool imap_needs_alloc(struct inode *inode,
 		(IS_DAX(inode) && ISUNWRITTEN(imap));
 }
 
+static inline bool need_excl_ilock(struct xfs_inode *ip, unsigned flags)
+{
+	/*
+	 * COW writes will allocate delalloc space, so we need to make sure
+	 * to take the lock exclusively here.
+	 */
+	if (xfs_is_reflink_inode(ip) && (flags & (IOMAP_WRITE | IOMAP_ZERO)))
+		return true;
+	if ((flags & IOMAP_DIRECT) && (flags & IOMAP_WRITE))
+		return true;
+	return false;
+}
+
 static int
 xfs_file_iomap_begin(
 	struct inode		*inode,
@@ -979,18 +992,14 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if ((flags & IOMAP_WRITE) && !IS_DAX(inode) &&
-		   !xfs_get_extsz_hint(ip)) {
+	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
+			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
 		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
 				iomap);
 	}
 
-	/*
-	 * COW writes will allocate delalloc space, so we need to make sure
-	 * to take the lock exclusively here.
-	 */
-	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
+	if (need_excl_ilock(ip, flags)) {
 		lockmode = XFS_ILOCK_EXCL;
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 	} else {
@@ -1003,17 +1012,44 @@ xfs_file_iomap_begin(
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
+	if (xfs_is_reflink_inode(ip) &&
+	    (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT)) {
+		bool need_alloc = false;
+
+		shared = xfs_reflink_find_cow_mapping(ip, offset, &imap,
+					&need_alloc);
+		if (shared) {
+			xfs_iunlock(ip, lockmode);
+			goto alloc_done;
+		}
+		ASSERT(!need_alloc);
+	}
+
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
 	if (error)
 		goto out_unlock;
 
-	if (flags & IOMAP_REPORT) {
+	if ((flags & IOMAP_REPORT) ||
+	    (xfs_is_reflink_inode(ip) &&
+	     (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))) {
 		/* Trim the mapping to the nearest shared extent boundary. */
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared,
 				&trimmed);
 		if (error)
 			goto out_unlock;
+
+		/*
+		 * We're here because we're trying to do a directio write to a
+		 * region that isn't aligned to a filesystem block.  If the
+		 * extent is shared, fall back to buffered mode to handle the
+		 * RMW.
+		 */
+		if (!(flags & IOMAP_REPORT) && shared) {
+			trace_xfs_reflink_bounce_dio_write(ip, &imap);
+			error = -EREMCHG;
+			goto out_unlock;
+		}
 	}
 
 	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && xfs_is_reflink_inode(ip)) {
@@ -1048,6 +1084,7 @@ xfs_file_iomap_begin(
 		if (error)
 			return error;
 
+alloc_done:
 		iomap->flags = IOMAP_F_NEW;
 		trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
 	} else {
-- 
2.1.4

