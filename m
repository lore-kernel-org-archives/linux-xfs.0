Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFkVd072076 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:46 -0600
Message-Id: <20111119181544.434721480@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/9] [PATCH 5/9] xfs: avoid direct I/O write vs buffered I/O
	race
References: <20111119181336.964593075@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0005-xfs-avoid-direct-I-O-write-vs-buffered-I-O-race.patch
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
To: stable@vger.kernel.org
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com

Currently a buffered reader or writer can add pages to the pagecache
while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
this by re-checking mapping->nrpages after we got the iolock, and if
nessecary upgrade the lock to exclusive mode.  To simplify this a bit
only take the ilock inside of xfs_file_aio_write_checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 93cc02d..b679198 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -669,6 +669,7 @@ xfs_file_aio_write_checks(
 	xfs_fsize_t		new_size;
 	int			error = 0;
 
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
@@ -760,14 +761,24 @@ xfs_file_dio_aio_write(
 		*iolock = XFS_IOLOCK_EXCL;
 	else
 		*iolock = XFS_IOLOCK_SHARED;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
 		return ret;
 
+	/*
+	 * Recheck if there are cached pages that need invalidate after we got
+	 * the iolock to protect against other threads adding new pages while
+	 * we were waiting for the iolock.
+	 */
+	if (mapping->nrpages && *iolock == XFS_IOLOCK_SHARED) {
+		xfs_rw_iunlock(ip, *iolock);
+		*iolock = XFS_IOLOCK_EXCL;
+		xfs_rw_ilock(ip, *iolock);
+	}
+
 	if (mapping->nrpages) {
-		WARN_ON(*iolock != XFS_IOLOCK_EXCL);
 		ret = -xfs_flushinval_pages(ip, (pos & PAGE_CACHE_MASK), -1,
 							FI_REMAPF_LOCKED);
 		if (ret)
@@ -812,7 +823,7 @@ xfs_file_buffered_aio_write(
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
