Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAJIFl3Z072101 for <xfs@oss.sgi.com>; Sat, 19 Nov 2011 12:15:48 -0600
Message-Id: <20111119181544.111984285@bombadil.infradead.org>
Date: Sat, 19 Nov 2011 13:13:40 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/9] [PATCH 4/9] xfs: dont serialise direct IO reads on page
	cache
References: <20111119181336.964593075@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0004-xfs-don-t-serialise-direct-IO-reads-on-page-cache-ch.patch
	checks
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
Cc: Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

There is no need to grab the i_mutex of the IO lock in exclusive
mode if we don't need to invalidate the page cache. Taking these
locks on every direct IO effective serialises them as taking the IO
lock in exclusive mode has to wait for all shared holders to drop
the lock. That only happens when IO is complete, so effective it
prevents dispatch of concurrent direct IO reads to the same inode.

Fix this by taking the IO lock shared to check the page cache state,
and only then drop it and take the IO lock exclusively if there is
work to be done. Hence for the normal direct IO case, no exclusive
locking will occur.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Joern Engel <joern@logfs.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_file.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
index 7f782af2..93cc02d 100644
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -309,7 +309,19 @@ xfs_file_aio_read(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	if (unlikely(ioflags & IO_ISDIRECT)) {
+	/*
+	 * Locking is a bit tricky here. If we take an exclusive lock
+	 * for direct IO, we effectively serialise all new concurrent
+	 * read IO to this file and block it behind IO that is currently in
+	 * progress because IO in progress holds the IO lock shared. We only
+	 * need to hold the lock exclusive to blow away the page cache, so
+	 * only take lock exclusively if the page cache needs invalidation.
+	 * This allows the normal direct IO case of no page cache pages to
+	 * proceeed concurrently without serialisation.
+	 */
+	xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	if ((ioflags & IO_ISDIRECT) && inode->i_mapping->nrpages) {
+		xfs_rw_iunlock(ip, XFS_IOLOCK_SHARED);
 		xfs_rw_ilock(ip, XFS_IOLOCK_EXCL);
 
 		if (inode->i_mapping->nrpages) {
@@ -322,8 +334,7 @@ xfs_file_aio_read(
 			}
 		}
 		xfs_rw_ilock_demote(ip, XFS_IOLOCK_EXCL);
-	} else
-		xfs_rw_ilock(ip, XFS_IOLOCK_SHARED);
+	}
 
 	trace_xfs_file_read(ip, size, iocb->ki_pos, ioflags);
 
-- 
1.7.7


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
