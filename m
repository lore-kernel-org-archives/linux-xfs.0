Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB1NRxIA033818 for <xfs@oss.sgi.com>; Thu, 1 Dec 2011 17:27:59 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 2/6] xfs: avoid direct I/O write vs buffered I/O race
Date: Thu,  1 Dec 2011 17:27:40 -0600
Message-Id: <1322782064-1723-3-git-send-email-bpm@sgi.com>
In-Reply-To: <1322782064-1723-1-git-send-email-bpm@sgi.com>
References: <1322782064-1723-1-git-send-email-bpm@sgi.com>
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
To: stable@vger.kernel.org, greg@kroah.com
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

commit c58cb165bd44de8aaee9755a144136ae743be116 upstream.

Currently a buffered reader or writer can add pages to the pagecache
while we are waiting for the iolock in xfs_file_dio_aio_write.  Prevent
this by re-checking mapping->nrpages after we got the iolock, and if
nessecary upgrade the lock to exclusive mode.  To simplify this a bit
only take the ilock inside of xfs_file_aio_write_checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_file.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 8fd4a07..b7e75c6 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -677,6 +677,7 @@ xfs_file_aio_write_checks(
 	xfs_fsize_t		new_size;
 	int			error = 0;
 
+	xfs_rw_ilock(ip, XFS_ILOCK_EXCL);
 	error = generic_write_checks(file, pos, count, S_ISBLK(inode->i_mode));
 	if (error) {
 		xfs_rw_iunlock(ip, XFS_ILOCK_EXCL | *iolock);
@@ -768,14 +769,24 @@ xfs_file_dio_aio_write(
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
@@ -820,7 +831,7 @@ xfs_file_buffered_aio_write(
 	size_t			count = ocount;
 
 	*iolock = XFS_IOLOCK_EXCL;
-	xfs_rw_ilock(ip, XFS_ILOCK_EXCL | *iolock);
+	xfs_rw_ilock(ip, *iolock);
 
 	ret = xfs_file_aio_write_checks(file, &pos, &count, iolock);
 	if (ret)
-- 
1.7.8.rc4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
