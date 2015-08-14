Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1E43D7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 11:25:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8ACF5AC003
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 09:25:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id uPJaSVXWvdHCmUMo (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 09:25:29 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 6C2A48E682
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 16:25:28 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-174.bos.redhat.com [10.18.41.174])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t7EGPSuR026691
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 12:25:28 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: flush entire file on dio read/write to cached file
Date: Fri, 14 Aug 2015 12:25:26 -0400
Message-Id: <1439569526-40423-1-git-send-email-bfoster@redhat.com>
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

Filesystems are responsible to manage file coherency between the page
cache and direct I/O. The generic dio code flushes dirty pages over the
range of a dio to ensure that the dio read or a future buffered read
returns the correct data. XFS has generally followed this pattern,
though traditionally has flushed and invalidated the range from the
start of the I/O all the way to the end of the file. This changed after
the following commit:

	7d4ea3ce xfs: use ranged writeback and invalidation for direct IO

... as the full file flush was no longer necessary to deal with the
strange post-eof delalloc issues that were since fixed. Unfortunately,
we have since received complaints about performance degradation due to
the increased exclusive iolock cycles (which locks out parallel dio
submission) that occur when a file has cached pages. This does not occur
on filesystems that use the generic code as it also does not incorporate
locking.

The exclusive iolock is acquired any time the inode mapping has cached
pages, regardless of whether they reside in the range of the I/O or not.
If not, the flush/inval calls do no work and the lock was cycled for no
reason.

Under consideration of the cost of the exclusive iolock, update the dio
read and write handlers to flush and invalidate the entire mapping when
cached pages exist. In most cases, this increases the cost of the
initial flush sequence but eliminates the need for further lock cycles
and flushes so long as the workload does not actively mix direct and
buffered I/O. This also more closely matches historical behavior and
performance characteristics that users have come to expect.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_file.c | 51 +++++++++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index db4acc1..de2c237 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -317,24 +317,33 @@ xfs_file_read_iter(
 		return -EIO;
 
 	/*
-	 * Locking is a bit tricky here. If we take an exclusive lock
-	 * for direct IO, we effectively serialise all new concurrent
-	 * read IO to this file and block it behind IO that is currently in
-	 * progress because IO in progress holds the IO lock shared. We only
-	 * need to hold the lock exclusive to blow away the page cache, so
-	 * only take lock exclusively if the page cache needs invalidation.
-	 * This allows the normal direct IO case of no page cache pages to
-	 * proceeed concurrently without serialisation.
+	 * Locking is a bit tricky here. If we take an exclusive lock for direct
+	 * IO, we effectively serialise all new concurrent read IO to this file
+	 * and block it behind IO that is currently in progress because IO in
+	 * progress holds the IO lock shared. We only need to hold the lock
+	 * exclusive to blow away the page cache, so only take lock exclusively
+	 * if the page cache needs invalidation. This allows the normal direct
+	 * IO case of no page cache pages to proceeed concurrently without
+	 * serialisation.
 	 */
 	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
 	if ((ioflags & XFS_IO_ISDIRECT) && inode->i_mapping->nrpages) {
 		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
+		/*
+		 * The generic dio code only flushes the range of the particular
+		 * I/O. Because we take an exclusive lock here, this whole
+		 * sequence is considerably more expensive for us. This has a
+		 * noticeable performance impact for any file with cached pages,
+		 * even when outside of the range of the particular I/O.
+		 *
+		 * Hence, amortize the cost of the lock against a full file
+		 * flush and reduce the chances of repeated iolock cycles going
+		 * forward.
+		 */
 		if (inode->i_mapping->nrpages) {
-			ret = filemap_write_and_wait_range(
-							VFS_I(ip)->i_mapping,
-							pos, pos + size - 1);
+			ret = filemap_write_and_wait(VFS_I(ip)->i_mapping);
 			if (ret) {
 				xfs_rw_iunlock(ip, XFS_IOLOCK_EXCL);
 				return ret;
@@ -345,9 +354,7 @@ xfs_file_read_iter(
 			 * we fail to invalidate a page, but this should never
 			 * happen on XFS. Warn if it does fail.
 			 */
-			ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-					pos >> PAGE_CACHE_SHIFT,
-					(pos + size - 1) >> PAGE_CACHE_SHIFT);
+			ret = invalidate_inode_pages2(VFS_I(ip)->i_mapping);
 			WARN_ON_ONCE(ret);
 			ret = 0;
 		}
@@ -733,19 +740,19 @@ xfs_file_dio_aio_write(
 	pos = iocb->ki_pos;
 	end = pos + count - 1;
 
+	/*
+	 * See xfs_file_read_iter() for why we do a full-file flush here.
+	 */
 	if (mapping->nrpages) {
-		ret = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						   pos, end);
+		ret = filemap_write_and_wait(VFS_I(ip)->i_mapping);
 		if (ret)
 			goto out;
 		/*
-		 * Invalidate whole pages. This can return an error if
-		 * we fail to invalidate a page, but this should never
-		 * happen on XFS. Warn if it does fail.
+		 * Invalidate whole pages. This can return an error if we fail
+		 * to invalidate a page, but this should never happen on XFS.
+		 * Warn if it does fail.
 		 */
-		ret = invalidate_inode_pages2_range(VFS_I(ip)->i_mapping,
-					pos >> PAGE_CACHE_SHIFT,
-					end >> PAGE_CACHE_SHIFT);
+		ret = invalidate_inode_pages2(VFS_I(ip)->i_mapping);
 		WARN_ON_ONCE(ret);
 		ret = 0;
 	}
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
