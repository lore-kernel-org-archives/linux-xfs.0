Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41988 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757570AbcJQMNQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Oct 2016 08:13:16 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: don't take the IOLOCK exclusive for direct I/O page invalidation
Date: Mon, 17 Oct 2016 14:13:12 +0200
Message-Id: <1476706392-2264-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org

XFS historically took the iolock exclusive when invalidating pages
before direct I/O operations to protect against writeback starvations.

But this writeback starvation issues has been fixed a long time ago
in the core writeback code, and all other file systems manage to do
without the exclusive lock.  Convert XFS over to avoid the exclusive
lock in this case, and also move to range invalidations like done
by the other file systems.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 98 +++++++++++++++++--------------------------------------
 1 file changed, 30 insertions(+), 68 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index cd37573..6f04036 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -249,6 +249,7 @@ xfs_file_dio_aio_read(
 	struct xfs_inode	*ip = XFS_I(inode);
 	loff_t			isize = i_size_read(inode);
 	size_t			count = iov_iter_count(to);
+	loff_t			end = iocb->ki_pos + count - 1;
 	struct iov_iter		data;
 	struct xfs_buftarg	*target;
 	ssize_t			ret = 0;
@@ -272,49 +273,21 @@ xfs_file_dio_aio_read(
 
 	file_accessed(iocb->ki_filp);
 
-	/*
-	 * Locking is a bit tricky here. If we take an exclusive lock for direct
-	 * IO, we effectively serialise all new concurrent read IO to this file
-	 * and block it behind IO that is currently in progress because IO in
-	 * progress holds the IO lock shared. We only need to hold the lock
-	 * exclusive to blow away the page cache, so only take lock exclusively
-	 * if the page cache needs invalidation. This allows the normal direct
-	 * IO case of no page cache pages to proceeed concurrently without
-	 * serialisation.
-	 */
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
 	if (mapping->nrpages) {
-		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
-		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
+		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
+		if (ret)
+			goto out_unlock;
 
 		/*
-		 * The generic dio code only flushes the range of the particular
-		 * I/O. Because we take an exclusive lock here, this whole
-		 * sequence is considerably more expensive for us. This has a
-		 * noticeable performance impact for any file with cached pages,
-		 * even when outside of the range of the particular I/O.
-		 *
-		 * Hence, amortize the cost of the lock against a full file
-		 * flush and reduce the chances of repeated iolock cycles going
-		 * forward.
+		 * Invalidate whole pages. This can return an error if we fail
+		 * to invalidate a page, but this should never happen on XFS.
+		 * Warn if it does fail.
 		 */
-		if (mapping->nrpages) {
-			ret = filemap_write_and_wait(mapping);
-			if (ret) {
-				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
-				return ret;
-			}
-
-			/*
-			 * Invalidate whole pages. This can return an error if
-			 * we fail to invalidate a page, but this should never
-			 * happen on XFS. Warn if it does fail.
-			 */
-			ret = invalidate_inode_pages2(mapping);
-			WARN_ON_ONCE(ret);
-			ret = 0;
-		}
-		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
+		ret = invalidate_inode_pages2_range(mapping,
+				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
+		WARN_ON_ONCE(ret);
+		ret = 0;
 	}
 
 	data = *to;
@@ -324,8 +297,9 @@ xfs_file_dio_aio_read(
 		iocb->ki_pos += ret;
 		iov_iter_advance(to, ret);
 	}
-	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 
+out_unlock:
+	xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 	return ret;
 }
 
@@ -570,61 +544,49 @@ xfs_file_dio_aio_write(
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
 		return -EINVAL;
 
-	/* "unaligned" here means not aligned to a filesystem block */
-	if ((iocb->ki_pos & mp->m_blockmask) ||
-	    ((iocb->ki_pos + count) & mp->m_blockmask))
-		unaligned_io = 1;
-
 	/*
-	 * We don't need to take an exclusive lock unless there page cache needs
-	 * to be invalidated or unaligned IO is being executed. We don't need to
-	 * consider the EOF extension case here because
-	 * xfs_file_aio_write_checks() will relock the inode as necessary for
-	 * EOF zeroing cases and fill out the new inode size as appropriate.
+	 * Don't take the exclusive iolock here unless the I/O is unaligned to
+	 * the file system block size.  We don't need to consider the EOF
+	 * extension case here because xfs_file_aio_write_checks() will relock
+	 * the inode as necessary for EOF zeroing cases and fill out the new
+	 * inode size as appropriate.
 	 */
-	if (unaligned_io || mapping->nrpages)
+	if ((iocb->ki_pos & mp->m_blockmask) ||
+	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
+		unaligned_io = 1;
 		iolock = XFS_IOLOCK_EXCL;
-	else
+	} else {
 		iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, iolock);
-
-	/*
-	 * Recheck if there are cached pages that need invalidate after we got
-	 * the iolock to protect against other threads adding new pages while
-	 * we were waiting for the iolock.
-	 */
-	if (mapping->nrpages && iolock == XFS_IOLOCK_SHARED) {
-		xfs_rw_iunlock(ip, iolock);
-		iolock = XFS_IOLOCK_EXCL;
-		xfs_rw_ilock(ip, iolock);
 	}
 
+	xfs_rw_ilock(ip, iolock);
+
 	ret = xfs_file_aio_write_checks(iocb, from, &iolock);
 	if (ret)
 		goto out;
 	count = iov_iter_count(from);
 	end = iocb->ki_pos + count - 1;
 
-	/*
-	 * See xfs_file_dio_aio_read() for why we do a full-file flush here.
-	 */
 	if (mapping->nrpages) {
-		ret = filemap_write_and_wait(VFS_I(ip)->i_mapping);
+		ret = filemap_write_and_wait_range(mapping, iocb->ki_pos, end);
 		if (ret)
 			goto out;
+
 		/*
 		 * Invalidate whole pages. This can return an error if we fail
 		 * to invalidate a page, but this should never happen on XFS.
 		 * Warn if it does fail.
 		 */
-		ret = invalidate_inode_pages2(VFS_I(ip)->i_mapping);
+		ret = invalidate_inode_pages2_range(mapping,
+				iocb->ki_pos >> PAGE_SHIFT, end >> PAGE_SHIFT);
 		WARN_ON_ONCE(ret);
 		ret = 0;
 	}
 
 	/*
 	 * If we are doing unaligned IO, wait for all other IO to drain,
-	 * otherwise demote the lock if we had to flush cached pages
+	 * otherwise demote the lock if we had to take the exclusive lock
+	 * for other reaosons in xfs_file_aio_write_checks.
 	 */
 	if (unaligned_io)
 		inode_dio_wait(inode);
-- 
2.1.4

