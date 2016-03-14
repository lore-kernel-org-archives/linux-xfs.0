Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 631E57CD8
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 16:03:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A1C930405F
	for <xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:03:02 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id GpOcfYxQ4jxHH1Mp (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Mar 2016 14:02:58 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.85 #2 (Red Hat Linux))
	id 1afZdg-0000Gj-KF
	for xfs@oss.sgi.com; Mon, 14 Mar 2016 21:02:56 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 6/7] xfs: implement iomap based buffered write path
Date: Mon, 14 Mar 2016 22:02:49 +0100
Message-Id: <1457989370-6904-7-git-send-email-hch@lst.de>
In-Reply-To: <1457989370-6904-1-git-send-email-hch@lst.de>
References: <1457989370-6904-1-git-send-email-hch@lst.de>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Convert XFS to use the new iomap based multipage write path. This involves
implementing the ->iomap_begin and ->iomap_end methods, and switching the
buffered file write, page_mkwrite and xfs_iozero paths to the new iomap
helpers.

With this change __xfs_get_blocks will never be used for buffered writes,
and the code handling them can be removed.

Based on earlier code from Dave Chinner.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c  | 205 -----------------------------------------------------
 fs/xfs/xfs_file.c  |  71 ++++++++-----------
 fs/xfs/xfs_iomap.c | 121 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.h |   5 +-
 fs/xfs/xfs_iops.c  |   9 +--
 fs/xfs/xfs_trace.h |   3 +
 6 files changed, 163 insertions(+), 251 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 72ee3f2..32aae77 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1412,209 +1412,6 @@ xfs_vm_direct_IO(
 			xfs_get_blocks_direct, endio, NULL, flags);
 }
 
-/*
- * Punch out the delalloc blocks we have already allocated.
- *
- * Don't bother with xfs_setattr given that nothing can have made it to disk yet
- * as the page is still locked at this point.
- */
-STATIC void
-xfs_vm_kill_delalloc_range(
-	struct inode		*inode,
-	loff_t			start,
-	loff_t			end)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	xfs_fileoff_t		start_fsb;
-	xfs_fileoff_t		end_fsb;
-	int			error;
-
-	start_fsb = XFS_B_TO_FSB(ip->i_mount, start);
-	end_fsb = XFS_B_TO_FSB(ip->i_mount, end);
-	if (end_fsb <= start_fsb)
-		return;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
-						end_fsb - start_fsb);
-	if (error) {
-		/* something screwed, just bail */
-		if (!XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-			xfs_alert(ip->i_mount,
-		"xfs_vm_write_failed: unable to clean up ino %lld",
-					ip->i_ino);
-		}
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-}
-
-STATIC void
-xfs_vm_write_failed(
-	struct inode		*inode,
-	struct page		*page,
-	loff_t			pos,
-	unsigned		len)
-{
-	loff_t			block_offset;
-	loff_t			block_start;
-	loff_t			block_end;
-	loff_t			from = pos & (PAGE_CACHE_SIZE - 1);
-	loff_t			to = from + len;
-	struct buffer_head	*bh, *head;
-
-	/*
-	 * The request pos offset might be 32 or 64 bit, this is all fine
-	 * on 64-bit platform.  However, for 64-bit pos request on 32-bit
-	 * platform, the high 32-bit will be masked off if we evaluate the
-	 * block_offset via (pos & PAGE_MASK) because the PAGE_MASK is
-	 * 0xfffff000 as an unsigned long, hence the result is incorrect
-	 * which could cause the following ASSERT failed in most cases.
-	 * In order to avoid this, we can evaluate the block_offset of the
-	 * start of the page by using shifts rather than masks the mismatch
-	 * problem.
-	 */
-	block_offset = (pos >> PAGE_CACHE_SHIFT) << PAGE_CACHE_SHIFT;
-
-	ASSERT(block_offset + from == pos);
-
-	head = page_buffers(page);
-	block_start = 0;
-	for (bh = head; bh != head || !block_start;
-	     bh = bh->b_this_page, block_start = block_end,
-				   block_offset += bh->b_size) {
-		block_end = block_start + bh->b_size;
-
-		/* skip buffers before the write */
-		if (block_end <= from)
-			continue;
-
-		/* if the buffer is after the write, we're done */
-		if (block_start >= to)
-			break;
-
-		/*
-		 * Process delalloc and unwritten buffers beyond EOF. We can
-		 * encounter unwritten buffers in the event that a file has
-		 * post-EOF unwritten extents and an extending write happens to
-		 * fail (e.g., an unaligned write that also involves a delalloc
-		 * to the same page).
-		 */
-		if (!buffer_delay(bh) && !buffer_unwritten(bh))
-			continue;
-
-		if (!buffer_new(bh) && block_offset < i_size_read(inode))
-			continue;
-
-		if (buffer_delay(bh))
-			xfs_vm_kill_delalloc_range(inode, block_offset,
-						   block_offset + bh->b_size);
-
-		/*
-		 * This buffer does not contain data anymore. make sure anyone
-		 * who finds it knows that for certain.
-		 */
-		clear_buffer_delay(bh);
-		clear_buffer_uptodate(bh);
-		clear_buffer_mapped(bh);
-		clear_buffer_new(bh);
-		clear_buffer_dirty(bh);
-		clear_buffer_unwritten(bh);
-	}
-
-}
-
-/*
- * This used to call block_write_begin(), but it unlocks and releases the page
- * on error, and we need that page to be able to punch stale delalloc blocks out
- * on failure. hence we copy-n-waste it here and call xfs_vm_write_failed() at
- * the appropriate point.
- */
-STATIC int
-xfs_vm_write_begin(
-	struct file		*file,
-	struct address_space	*mapping,
-	loff_t			pos,
-	unsigned		len,
-	unsigned		flags,
-	struct page		**pagep,
-	void			**fsdata)
-{
-	pgoff_t			index = pos >> PAGE_CACHE_SHIFT;
-	struct page		*page;
-	int			status;
-
-	ASSERT(len <= PAGE_CACHE_SIZE);
-
-	page = grab_cache_page_write_begin(mapping, index, flags);
-	if (!page)
-		return -ENOMEM;
-
-	status = __block_write_begin(page, pos, len, xfs_get_blocks);
-	if (unlikely(status)) {
-		struct inode	*inode = mapping->host;
-		size_t		isize = i_size_read(inode);
-
-		xfs_vm_write_failed(inode, page, pos, len);
-		unlock_page(page);
-
-		/*
-		 * If the write is beyond EOF, we only want to kill blocks
-		 * allocated in this write, not blocks that were previously
-		 * written successfully.
-		 */
-		if (pos + len > isize) {
-			ssize_t start = max_t(ssize_t, pos, isize);
-
-			truncate_pagecache_range(inode, start, pos + len);
-		}
-
-		page_cache_release(page);
-		page = NULL;
-	}
-
-	*pagep = page;
-	return status;
-}
-
-/*
- * On failure, we only need to kill delalloc blocks beyond EOF in the range of
- * this specific write because they will never be written. Previous writes
- * beyond EOF where block allocation succeeded do not need to be trashed, so
- * only new blocks from this write should be trashed. For blocks within
- * EOF, generic_write_end() zeros them so they are safe to leave alone and be
- * written with all the other valid data.
- */
-STATIC int
-xfs_vm_write_end(
-	struct file		*file,
-	struct address_space	*mapping,
-	loff_t			pos,
-	unsigned		len,
-	unsigned		copied,
-	struct page		*page,
-	void			*fsdata)
-{
-	int			ret;
-
-	ASSERT(len <= PAGE_CACHE_SIZE);
-
-	ret = generic_write_end(file, mapping, pos, len, copied, page, fsdata);
-	if (unlikely(ret < len)) {
-		struct inode	*inode = mapping->host;
-		size_t		isize = i_size_read(inode);
-		loff_t		to = pos + len;
-
-		if (to > isize) {
-			/* only kill blocks in this write beyond EOF */
-			if (pos > isize)
-				isize = pos;
-			xfs_vm_kill_delalloc_range(inode, isize, to);
-			truncate_pagecache_range(inode, isize, to);
-		}
-	}
-	return ret;
-}
-
 STATIC sector_t
 xfs_vm_bmap(
 	struct address_space	*mapping,
@@ -1726,8 +1523,6 @@ const struct address_space_operations xfs_address_space_operations = {
 	.set_page_dirty		= xfs_vm_set_page_dirty,
 	.releasepage		= xfs_vm_releasepage,
 	.invalidatepage		= xfs_vm_invalidatepage,
-	.write_begin		= xfs_vm_write_begin,
-	.write_end		= xfs_vm_write_end,
 	.bmap			= xfs_vm_bmap,
 	.direct_IO		= xfs_vm_direct_IO,
 	.migratepage		= buffer_migrate_page,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ac0fd32..f2cb984 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -37,6 +37,7 @@
 #include "xfs_log.h"
 #include "xfs_icache.h"
 #include "xfs_pnfs.h"
+#include "xfs_iomap.h"
 
 #include <linux/dcache.h>
 #include <linux/falloc.h>
@@ -79,57 +80,27 @@ xfs_rw_ilock_demote(
 		inode_unlock(VFS_I(ip));
 }
 
-/*
- * xfs_iozero clears the specified range supplied via the page cache (except in
- * the DAX case). Writes through the page cache will allocate blocks over holes,
- * though the callers usually map the holes first and avoid them. If a block is
- * not completely zeroed, then it will be read from disk before being partially
- * zeroed.
- *
- * In the DAX case, we can just directly write to the underlying pages. This
- * will not allocate blocks, but will avoid holes and unwritten extents and so
- * not do unnecessary work.
- */
-int
-xfs_iozero(
-	struct xfs_inode	*ip,	/* inode			*/
-	loff_t			pos,	/* offset in file		*/
-	size_t			count)	/* size of data to zero		*/
+static int
+xfs_dax_zero_range(
+	struct inode		*inode,
+	loff_t			pos,
+	size_t			count)
 {
-	struct page		*page;
-	struct address_space	*mapping;
 	int			status = 0;
 
-
-	mapping = VFS_I(ip)->i_mapping;
 	do {
 		unsigned offset, bytes;
-		void *fsdata;
 
 		offset = (pos & (PAGE_CACHE_SIZE -1)); /* Within page */
 		bytes = PAGE_CACHE_SIZE - offset;
 		if (bytes > count)
 			bytes = count;
 
-		if (IS_DAX(VFS_I(ip))) {
-			status = dax_zero_page_range(VFS_I(ip), pos, bytes,
-						     xfs_get_blocks_direct);
-			if (status)
-				break;
-		} else {
-			status = pagecache_write_begin(NULL, mapping, pos, bytes,
-						AOP_FLAG_UNINTERRUPTIBLE,
-						&page, &fsdata);
-			if (status)
-				break;
-
-			zero_user(page, offset, bytes);
+		status = dax_zero_page_range(inode, pos, bytes,
+					     xfs_get_blocks_direct);
+		if (status)
+			break;
 
-			status = pagecache_write_end(NULL, mapping, pos, bytes,
-						bytes, page, fsdata);
-			WARN_ON(status <= 0); /* can't return less than zero! */
-			status = 0;
-		}
 		pos += bytes;
 		count -= bytes;
 	} while (count);
@@ -137,6 +108,24 @@ xfs_iozero(
 	return status;
 }
 
+/*
+ * Clear the specified ranges to zero through either the pagecache or DAX.
+ * Holes and unwritten extents will be left as-is as they already are zeroed.
+ */
+int
+xfs_iozero(
+	struct xfs_inode	*ip,
+	loff_t			pos,
+	size_t			count)
+{
+	struct inode		*inode = VFS_I(ip);
+
+	if (IS_DAX(VFS_I(ip)))
+		return xfs_dax_zero_range(inode, pos, count);
+	else
+		return iomap_zero_range(inode, pos, count, NULL, &xfs_iomap_ops);
+}
+
 int
 xfs_update_prealloc_flags(
 	struct xfs_inode	*ip,
@@ -844,7 +833,7 @@ xfs_file_buffered_aio_write(
 write_retry:
 	trace_xfs_file_buffered_write(ip, iov_iter_count(from),
 				      iocb->ki_pos, 0);
-	ret = generic_perform_write(file, from, iocb->ki_pos);
+	ret = iomap_file_buffered_write(iocb, from, &xfs_iomap_ops);
 	if (likely(ret >= 0))
 		iocb->ki_pos += ret;
 
@@ -1560,7 +1549,7 @@ xfs_filemap_page_mkwrite(
 	if (IS_DAX(inode)) {
 		ret = __dax_mkwrite(vma, vmf, xfs_get_blocks_dax_fault, NULL);
 	} else {
-		ret = block_page_mkwrite(vma, vmf, xfs_get_blocks);
+		ret = iomap_page_mkwrite(vma, vmf, &xfs_iomap_ops);
 		ret = block_page_mkwrite_return(ret);
 	}
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index cc53430..68e8907 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -986,3 +986,124 @@ xfs_bmbt_to_iomap(
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev = xfs_find_bdev_for_inode(ip);
 }
+
+static inline bool imap_needs_alloc(struct xfs_bmbt_irec *imap, int nimaps)
+{
+	return !nimaps ||
+		imap->br_startblock == HOLESTARTBLOCK ||
+		imap->br_startblock == DELAYSTARTBLOCK;
+}
+
+static int
+xfs_file_iomap_begin(
+	struct inode		*inode,
+	loff_t			offset,
+	ssize_t			count,
+	unsigned		flags,
+	struct iomap		*iomap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_bmbt_irec	imap;
+	xfs_fileoff_t		offset_fsb, end_fsb;
+	int			nimaps = 1, error = 0;
+
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return -EIO;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	ASSERT(offset <= mp->m_super->s_maxbytes);
+	if ((xfs_fsize_t)offset + count > mp->m_super->s_maxbytes)
+		count = mp->m_super->s_maxbytes - offset;
+	offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	end_fsb = XFS_B_TO_FSB(mp, offset + count);
+
+	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
+			       &nimaps, XFS_BMAPI_ENTIRE);
+	if (error) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		return error;
+	}
+
+	if ((flags & IOMAP_ALLOCATE) && imap_needs_alloc(&imap, nimaps)) {
+		if (xfs_get_extsz_hint(ip)) {
+			/*
+			 * xfs_iomap_write_direct() expects the shared lock. It
+			 * is unlocked on return.
+			 */
+			xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
+			error = xfs_iomap_write_direct(ip, offset, count, &imap,
+					nimaps);
+		} else {
+			error = xfs_iomap_write_delay(ip, offset, count, &imap);
+			xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		}
+
+		trace_xfs_iomap_alloc(ip, offset, count, 0, &imap);
+	} else if (nimaps) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		trace_xfs_iomap_found(ip, offset, count, 0, &imap);
+	} else {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		trace_xfs_iomap_not_found(ip, offset, count, 0, &imap);
+		iomap->blkno = IOMAP_NULL_BLOCK;
+		iomap->type = IOMAP_HOLE;
+		iomap->offset = offset;
+		iomap->length = count;
+
+		return 0;
+	}
+
+	if (!error)
+		xfs_bmbt_to_iomap(ip, iomap, &imap);
+	return error;
+}
+
+static int
+xfs_file_iomap_end(
+	struct inode		*inode,
+	loff_t			offset,
+	ssize_t			count,
+	ssize_t			written,
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
+	start_fsb = XFS_B_TO_FSB(mp, offset + written);
+	end_fsb = XFS_B_TO_FSB(mp, offset + count - written);
+
+	/*
+	 * Trim back delalloc blocks if we didn't manage to write the whole
+	 * range reserved.
+	 *
+	 * We don't need to care about racing delalloc as we hold i_mutex
+	 * across the reserve/allocate/unreserve calls. If there are delalloc
+	 * blocks in the range, they are ours.
+	 */
+	if (start_fsb < end_fsb) {
+		xfs_ilock(ip, XFS_ILOCK_EXCL);
+		error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
+					       end_fsb - start_fsb);
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+		if (error && !XFS_FORCED_SHUTDOWN(mp)) {
+			xfs_alert(mp, "%s: unable to clean up ino %lld",
+				__func__, ip->i_ino);
+		}
+	}
+
+	return error;
+}
+
+struct iomap_ops xfs_iomap_ops = {
+	.iomap_begin		= xfs_file_iomap_begin,
+	.iomap_end		= xfs_file_iomap_end,
+};
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 718f07c..e066d04 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -18,7 +18,8 @@
 #ifndef __XFS_IOMAP_H__
 #define __XFS_IOMAP_H__
 
-struct iomap;
+#include <linux/iomap.h>
+
 struct xfs_inode;
 struct xfs_bmbt_irec;
 
@@ -33,4 +34,6 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t);
 void xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
 		struct xfs_bmbt_irec *);
 
+extern struct iomap_ops xfs_iomap_ops;
+
 #endif /* __XFS_IOMAP_H__*/
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 1aab9f6..cbd8fab 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -38,6 +38,7 @@
 #include "xfs_dir2.h"
 #include "xfs_trans_space.h"
 #include "xfs_pnfs.h"
+#include "xfs_iomap.h"
 
 #include <linux/capability.h>
 #include <linux/xattr.h>
@@ -811,8 +812,8 @@ xfs_setattr_size(
 			error = dax_truncate_page(inode, newsize,
 					xfs_get_blocks_direct);
 		} else {
-			error = block_truncate_page(inode->i_mapping, newsize,
-					xfs_get_blocks);
+			error = iomap_truncate_page(inode, newsize,
+					&did_zeroing, &xfs_iomap_ops);
 		}
 	}
 
@@ -827,8 +828,8 @@ xfs_setattr_size(
 	 * problem. Note that this includes any block zeroing we did above;
 	 * otherwise those blocks may not be zeroed after a crash.
 	 */
-	if (newsize > ip->i_d.di_size &&
-	    (oldsize != ip->i_d.di_size || did_zeroing)) {
+	if (did_zeroing ||
+	    (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
 						      ip->i_d.di_size, newsize);
 		if (error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8d5842..1bf3840 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1297,6 +1297,9 @@ DEFINE_IOMAP_EVENT(xfs_map_blocks_alloc);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_found);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_alloc);
 DEFINE_IOMAP_EVENT(xfs_get_blocks_map_direct);
+DEFINE_IOMAP_EVENT(xfs_iomap_alloc);
+DEFINE_IOMAP_EVENT(xfs_iomap_found);
+DEFINE_IOMAP_EVENT(xfs_iomap_not_found);
 
 DECLARE_EVENT_CLASS(xfs_simple_io_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_off_t offset, ssize_t count),
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
