Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51464 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935018AbcKMTHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 13 Nov 2016 14:07:51 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] xfs: use iomap_dio_rw
Date: Sun, 13 Nov 2016 20:07:34 +0100
Message-Id: <1479064054-10474-6-git-send-email-hch@lst.de>
In-Reply-To: <1479064054-10474-1-git-send-email-hch@lst.de>
References: <1479064054-10474-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Straight switch over to using iomap for direct I/O - we already have the
non-COW dio path in write_begin for DAX and files with extent size hints,
so nothing to add there.  The COW path is ported over from the old
get_blocks version and a bit of a mess, but I have some work in progress
to make it look more like the buffered I/O COW path.

This gets rid of xfs_get_blocks_direct and the last caller of
xfs_get_blocks with the create flag set, so all that code can be removed.

Last but not least I've removed a comment in xfs_filemap_fault that
refers to xfs_get_blocks entirely instead of updating it - while the
reference is correct, the whole DAX fault path looks different than
the non-DAX one, so it seems rather pointless.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c         |   2 +-
 fs/xfs/xfs_aops.c  | 291 ++---------------------------------------------------
 fs/xfs/xfs_aops.h  |   6 --
 fs/xfs/xfs_file.c  | 149 +++++++++++----------------
 fs/xfs/xfs_iomap.c |  53 ++++++++--
 5 files changed, 114 insertions(+), 387 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index a6d64c5..0ac3e8e 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -591,7 +591,7 @@ EXPORT_SYMBOL_GPL(iomap_fiemap);
  * iomap.h:
  */
 #define IOMAP_DIO_WRITE		(1 << 30)
-#define IOMAP_DIO_DIRTY	(1 << 31)
+#define IOMAP_DIO_DIRTY		(1 << 31)
 
 struct iomap_dio {
 	struct kiocb		*iocb;
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 2b350d0..db431b7 100644
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
@@ -1253,51 +1209,12 @@ xfs_map_trim_size(
 	bh_result->b_size = mapping_size;
 }
 
-/* Bounce unaligned directio writes to the page cache. */
 static int
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
-STATIC int
-__xfs_get_blocks(
+xfs_get_blocks(
 	struct inode		*inode,
 	sector_t		iblock,
 	struct buffer_head	*bh_result,
-	int			create,
-	bool			direct)
+	int			create)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1308,11 +1225,8 @@ __xfs_get_blocks(
 	int			nimaps = 1;
 	xfs_off_t		offset;
 	ssize_t			size;
-	int			new = 0;
-	bool			is_cow = false;
-	bool			need_alloc = false;
 
-	BUG_ON(create && !direct);
+	BUG_ON(create);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -1321,7 +1235,7 @@ __xfs_get_blocks(
 	ASSERT(bh_result->b_size >= (1 << inode->i_blkbits));
 	size = bh_result->b_size;
 
-	if (!create && offset >= i_size_read(inode))
+	if (offset >= i_size_read(inode))
 		return 0;
 
 	/*
@@ -1336,72 +1250,12 @@ __xfs_get_blocks(
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
 
-	/*
-	 * The only time we can ever safely find delalloc blocks on direct I/O
-	 * is a dio write to post-eof speculative preallocation. All other
-	 * scenarios are indicative of a problem or misuse (such as mixing
-	 * direct and mapped I/O).
-	 *
-	 * The file may be unmapped by the time we get here so we cannot
-	 * reliably fail the I/O based on mapping. Instead, fail the I/O if this
-	 * is a read or a write within eof. Otherwise, carry on but warn as a
-	 * precuation if the file happens to be mapped.
-	 */
-	if (direct && imap.br_startblock == DELAYSTARTBLOCK) {
-		if (!create || offset < i_size_read(VFS_I(ip))) {
-			WARN_ON_ONCE(1);
-			error = -EIO;
-			goto out_unlock;
-		}
-		WARN_ON_ONCE(mapping_mapped(VFS_I(ip)->i_mapping));
-	}
-
-	/* for DAX, we convert unwritten extents directly */
-	if (create &&
-	    (!nimaps ||
-	     (imap.br_startblock == HOLESTARTBLOCK ||
-	      imap.br_startblock == DELAYSTARTBLOCK) ||
-	     (IS_DAX(inode) && ISUNWRITTEN(&imap)))) {
-		/*
-		 * xfs_iomap_write_direct() expects the shared lock. It
-		 * is unlocked on return.
-		 */
-		if (lockmode == XFS_ILOCK_EXCL)
-			xfs_ilock_demote(ip, lockmode);
-
-		error = xfs_iomap_write_direct(ip, offset, size,
-					       &imap, nimaps);
-		if (error)
-			return error;
-		new = 1;
-
-		trace_xfs_get_blocks_alloc(ip, offset, size,
-				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
-						   : XFS_IO_DELALLOC, &imap);
-	} else if (nimaps) {
+	if (nimaps) {
 		trace_xfs_get_blocks_found(ip, offset, size,
 				ISUNWRITTEN(&imap) ? XFS_IO_UNWRITTEN
 						   : XFS_IO_OVERWRITE, &imap);
@@ -1411,12 +1265,6 @@ __xfs_get_blocks(
 		goto out_unlock;
 	}
 
-	if (IS_DAX(inode) && create) {
-		ASSERT(!ISUNWRITTEN(&imap));
-		/* zeroing is not needed at a higher layer */
-		new = 0;
-	}
-
 	/* trim mapping down to size requested */
 	xfs_map_trim_size(inode, iblock, bh_result, &imap, offset, size);
 
@@ -1426,43 +1274,14 @@ __xfs_get_blocks(
 	 */
 	if (imap.br_startblock != HOLESTARTBLOCK &&
 	    imap.br_startblock != DELAYSTARTBLOCK &&
-	    (create || !ISUNWRITTEN(&imap))) {
-		if (create && direct && !is_cow) {
-			error = xfs_bounce_unaligned_dio_write(ip, offset_fsb,
-					&imap);
-			if (error)
-				return error;
-		}
-
+	    !ISUNWRITTEN(&imap))
 		xfs_map_buffer(inode, bh_result, &imap, offset);
-		if (ISUNWRITTEN(&imap))
-			set_buffer_unwritten(bh_result);
-		/* direct IO needs special help */
-		if (create)
-			xfs_map_direct(inode, bh_result, &imap, offset, is_cow);
-	}
 
 	/*
 	 * If this is a realtime file, data may be on a different device.
 	 * to that pointed to from the buffer_head b_bdev currently.
 	 */
 	bh_result->b_bdev = xfs_find_bdev_for_inode(inode);
-
-	/*
-	 * If we previously allocated a block out beyond eof and we are now
-	 * coming back to use it then we will need to flag it as new even if it
-	 * has a disk address.
-	 *
-	 * With sub-block writes into unwritten extents we also need to mark
-	 * the buffer as new so that the unwritten parts of the buffer gets
-	 * correctly zeroed.
-	 */
-	if (create &&
-	    ((!buffer_mapped(bh_result) && !buffer_uptodate(bh_result)) ||
-	     (offset >= i_size_read(inode)) ||
-	     (new || ISUNWRITTEN(&imap))))
-		set_buffer_new(bh_result);
-
 	return 0;
 
 out_unlock:
@@ -1470,100 +1289,6 @@ __xfs_get_blocks(
 	return error;
 }
 
-int
-xfs_get_blocks(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, false);
-}
-
-int
-xfs_get_blocks_direct(
-	struct inode		*inode,
-	sector_t		iblock,
-	struct buffer_head	*bh_result,
-	int			create)
-{
-	return __xfs_get_blocks(inode, iblock, bh_result, create, true);
-}
-
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
index 34dc00d..cc174ec 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -55,12 +55,6 @@ struct xfs_ioend {
 
 extern const struct address_space_operations xfs_address_space_operations;
 
-int	xfs_get_blocks(struct inode *inode, sector_t offset,
-		       struct buffer_head *map_bh, int create);
-int	xfs_get_blocks_direct(struct inode *inode, sector_t offset,
-			      struct buffer_head *map_bh, int create);
-int	xfs_end_io_direct_write(struct kiocb *iocb, loff_t offset,
-		ssize_t size, void *private);
 int	xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 
 extern void xfs_count_page_state(struct page *, int *, int *);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d054b73..f5effa6 100644
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
 
@@ -1468,15 +1445,9 @@ xfs_filemap_fault(
 		return xfs_filemap_page_mkwrite(vma, vmf);
 
 	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	if (IS_DAX(inode)) {
-		/*
-		 * we do not want to trigger unwritten extent conversion on read
-		 * faults - that is unnecessary overhead and would also require
-		 * changes to xfs_get_blocks_direct() to map unwritten extent
-		 * ioend for conversion on read-only mappings.
-		 */
+	if (IS_DAX(inode))
 		ret = dax_iomap_fault(vma, vmf, &xfs_iomap_ops);
-	} else
+	else
 		ret = filemap_fault(vma, vmf);
 	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
 
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

