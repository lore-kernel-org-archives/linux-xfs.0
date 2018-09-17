Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41326 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbeIRCX3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Sep 2018 22:23:29 -0400
Received: from 089144198037.atnat0007.highway.a1.net ([89.144.198.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1g20XM-0005zu-Dj
        for linux-xfs@vger.kernel.org; Mon, 17 Sep 2018 20:54:28 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/10] xfs: use a separate iomap_ops for delalloc writes
Date: Mon, 17 Sep 2018 22:53:54 +0200
Message-Id: <20180917205354.15401-11-hch@lst.de>
In-Reply-To: <20180917205354.15401-1-hch@lst.de>
References: <20180917205354.15401-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Introduce a new xfs_delalloc_iomap_ops instance that is passed to
iomap_apply when we are doing delayed allocations.  This keeps the code
more neatly separated for future work.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_util.c |   3 +-
 fs/xfs/xfs_file.c      |   6 +-
 fs/xfs/xfs_iomap.c     | 177 ++++++++++++++++++++---------------------
 fs/xfs/xfs_iomap.h     |   1 +
 fs/xfs/xfs_iops.c      |   4 +-
 fs/xfs/xfs_reflink.c   |   2 +-
 6 files changed, 95 insertions(+), 98 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 3f9d4d2777e4..414dbc31139c 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -1165,7 +1165,8 @@ xfs_free_file_space(
 		return 0;
 	if (offset + len > XFS_ISIZE(ip))
 		len = XFS_ISIZE(ip) - offset;
-	error = iomap_zero_range(VFS_I(ip), offset, len, NULL, &xfs_iomap_ops);
+	error = iomap_zero_range(VFS_I(ip), offset, len, NULL,
+			&xfs_delalloc_iomap_ops);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 61a5ad2600e8..fa8fbc84eec8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -355,7 +355,7 @@ xfs_file_aio_write_checks(
 	
 		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
-				NULL, &xfs_iomap_ops);
+				NULL, &xfs_delalloc_iomap_ops);
 		if (error)
 			return error;
 	} else
@@ -633,7 +633,7 @@ xfs_file_buffered_aio_write(
 	current->backing_dev_info = inode_to_bdi(inode);
 
 	trace_xfs_file_buffered_write(ip, iov_iter_count(from), iocb->ki_pos);
-	ret = iomap_file_buffered_write(iocb, from, &xfs_iomap_ops);
+	ret = iomap_file_buffered_write(iocb, from, &xfs_delalloc_iomap_ops);
 	if (likely(ret >= 0))
 		iocb->ki_pos += ret;
 
@@ -1077,7 +1077,7 @@ __xfs_filemap_fault(
 			ret = dax_finish_sync_fault(vmf, pe_size, pfn);
 	} else {
 		if (write_fault)
-			ret = iomap_page_mkwrite(vmf, &xfs_iomap_ops);
+			ret = iomap_page_mkwrite(vmf, &xfs_delalloc_iomap_ops);
 		else
 			ret = filemap_fault(vmf);
 	}
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9079196bbc35..1bfc40ce581a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -512,8 +512,16 @@ xfs_iomap_prealloc_size(
 	return alloc_blocks;
 }
 
+static int xfs_file_iomap_begin(struct inode *inode, loff_t offset,
+		loff_t length, unsigned flags, struct iomap *iomap);
+
+/*
+ * Start writing to a file, allocating blocks using delayed allocations if
+ * needed.  Note that in case of doing COW overwrites the iomap needs to return
+ * the address of the existing data.
+ */
 static int
-xfs_file_iomap_begin_delay(
+xfs_delalloc_iomap_begin(
 	struct inode		*inode,
 	loff_t			offset,
 	loff_t			count,
@@ -532,7 +540,12 @@ xfs_file_iomap_begin_delay(
 	struct xfs_iext_cursor	icur;
 	xfs_fsblock_t		prealloc_blocks = 0;
 
-	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	/*
+	 * We currently don't support the RT subvolume special cases in the
+	 * delalloc path, so revert to real allocations.
+	 */
+	if (XFS_IS_REALTIME_INODE(ip))
+		return xfs_file_iomap_begin(inode, offset, count, flags, iomap);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
@@ -658,6 +671,73 @@ xfs_file_iomap_begin_delay(
 	return error;
 }
 
+static int
+xfs_delalloc_iomap_end(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			length,
+	ssize_t			written,
+	unsigned		flags,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		start_fsb;
+	xfs_fileoff_t		end_fsb;
+	int			error = 0;
+
+	if (iomap->type != IOMAP_DELALLOC)
+		return 0;
+
+	/*
+	 * Behave as if the write failed if drop writes is enabled. Set the NEW
+	 * flag to force delalloc cleanup.
+	 */
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
+		iomap->flags |= IOMAP_F_NEW;
+		written = 0;
+	}
+
+	/*
+	 * start_fsb refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	else
+		start_fsb = XFS_B_TO_FSB(mp, offset + written);
+	end_fsb = XFS_B_TO_FSB(mp, offset + length);
+
+	/*
+	 * Trim delalloc blocks if they were allocated by this write and we
+	 * didn't manage to write the whole range.
+	 *
+	 * We don't need to care about racing delalloc as we hold i_mutex
+	 * across the reserve/allocate/unreserve calls. If there are delalloc
+	 * blocks in the range, they are ours.
+	 */
+	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
+		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
+					 XFS_FSB_TO_B(mp, end_fsb) - 1);
+
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+					       end_fsb - start_fsb);
+		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
+			xfs_alert(mp, "%s: unable to clean up ino %lld",
+				__func__, ip->i_ino);
+			return error;
+		}
+	}
+
+	return 0;
+}
+
+const struct iomap_ops xfs_delalloc_iomap_ops = {
+	.iomap_begin		= xfs_delalloc_iomap_begin,
+	.iomap_end		= xfs_delalloc_iomap_end,
+};
+
 /*
  * Pass in a delayed allocate extent, convert it to real extents;
  * return to the caller the extent we create which maps on top of
@@ -1028,16 +1108,13 @@ xfs_file_iomap_begin(
 	bool			shared = false;
 	unsigned		lockmode;
 
+	ASSERT(!(flags & (IOMAP_WRITE | IOMAP_ZERO)) ||
+		(flags & IOMAP_DIRECT) || IS_DAX(inode));
+	ASSERT(!(flags & IOMAP_ZERO) || XFS_IS_REALTIME_INODE(ip));
+
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if ((flags & (IOMAP_WRITE | IOMAP_ZERO)) && !(flags & IOMAP_DIRECT) &&
-			!IS_DAX(inode) && !XFS_IS_REALTIME_INODE(ip)) {
-		/* Reserve delalloc blocks for regular writeback. */
-		return xfs_file_iomap_begin_delay(inode, offset, length, flags,
-				iomap);
-	}
-
 	/*
 	 * Lock the inode in the manner required for the specified operation and
 	 * check for as many conditions that would result in blocking as
@@ -1070,15 +1147,6 @@ xfs_file_iomap_begin(
 	if (!(flags & (IOMAP_WRITE | IOMAP_ZERO)))
 		goto out_found;
 
-	/*
-	 * Don't need to allocate over holes when doing zeroing operations,
-	 * unless we need to COW and have an existing extent.
-	 */
-	if ((flags & IOMAP_ZERO) &&
-	    (!xfs_is_reflink_inode(ip) ||
-	     !needs_cow_for_zeroing(&imap, nimaps)))
-		goto out_found;
-
 	/*
 	 * Break shared extents if necessary. Checks for non-blocking IO have
 	 * been done up front, so we don't need to do them here.
@@ -1148,81 +1216,8 @@ xfs_file_iomap_begin(
 	return error;
 }
 
-static int
-xfs_file_iomap_end_delalloc(
-	struct xfs_inode	*ip,
-	loff_t			offset,
-	loff_t			length,
-	ssize_t			written,
-	struct iomap		*iomap)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		start_fsb;
-	xfs_fileoff_t		end_fsb;
-	int			error = 0;
-
-	/*
-	 * Behave as if the write failed if drop writes is enabled. Set the NEW
-	 * flag to force delalloc cleanup.
-	 */
-	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_DROP_WRITES)) {
-		iomap->flags |= IOMAP_F_NEW;
-		written = 0;
-	}
-
-	/*
-	 * start_fsb refers to the first unused block after a short write. If
-	 * nothing was written, round offset down to point at the first block in
-	 * the range.
-	 */
-	if (unlikely(!written))
-		start_fsb = XFS_B_TO_FSBT(mp, offset);
-	else
-		start_fsb = XFS_B_TO_FSB(mp, offset + written);
-	end_fsb = XFS_B_TO_FSB(mp, offset + length);
-
-	/*
-	 * Trim delalloc blocks if they were allocated by this write and we
-	 * didn't manage to write the whole range.
-	 *
-	 * We don't need to care about racing delalloc as we hold i_mutex
-	 * across the reserve/allocate/unreserve calls. If there are delalloc
-	 * blocks in the range, they are ours.
-	 */
-	if ((iomap->flags & IOMAP_F_NEW) && start_fsb < end_fsb) {
-		truncate_pagecache_range(VFS_I(ip), XFS_FSB_TO_B(mp, start_fsb),
-					 XFS_FSB_TO_B(mp, end_fsb) - 1);
-
-		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-					       end_fsb - start_fsb);
-		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
-			xfs_alert(mp, "%s: unable to clean up ino %lld",
-				__func__, ip->i_ino);
-			return error;
-		}
-	}
-
-	return 0;
-}
-
-static int
-xfs_file_iomap_end(
-	struct inode		*inode,
-	loff_t			offset,
-	loff_t			length,
-	ssize_t			written,
-	unsigned		flags,
-	struct iomap		*iomap)
-{
-	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
-		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
-				length, written, iomap);
-	return 0;
-}
-
 const struct iomap_ops xfs_iomap_ops = {
 	.iomap_begin		= xfs_file_iomap_begin,
-	.iomap_end		= xfs_file_iomap_end,
 };
 
 static int
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index c6170548831b..fe4cde2c30c9 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -42,6 +42,7 @@ xfs_aligned_fsb_count(
 }
 
 extern const struct iomap_ops xfs_iomap_ops;
+extern const struct iomap_ops xfs_delalloc_iomap_ops;
 extern const struct iomap_ops xfs_xattr_iomap_ops;
 
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c3e74f9128e8..fb8035e3ba0b 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -865,10 +865,10 @@ xfs_setattr_size(
 	if (newsize > oldsize) {
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
 		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
-				&did_zeroing, &xfs_iomap_ops);
+				&did_zeroing, &xfs_delalloc_iomap_ops);
 	} else {
 		error = iomap_truncate_page(inode, newsize, &did_zeroing,
-				&xfs_iomap_ops);
+				&xfs_delalloc_iomap_ops);
 	}
 
 	if (error)
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index e0111d31140b..ac94ace45424 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1393,7 +1393,7 @@ xfs_reflink_dirty_extents(
 			if (fpos + flen > isize)
 				flen = isize - fpos;
 			error = iomap_file_dirty(VFS_I(ip), fpos, flen,
-					&xfs_iomap_ops);
+					&xfs_delalloc_iomap_ops);
 			xfs_ilock(ip, XFS_ILOCK_EXCL);
 			if (error)
 				goto out;
-- 
2.18.0
