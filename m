Return-Path: <xfs-bounces@oss.sgi.com>
Received: from nfs10.americas.sgi.com (nfs10.americas.sgi.com [128.162.245.67])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAUHwtqp208177 for <xfs@oss.sgi.com>; Wed, 30 Nov 2011 11:58:55 -0600
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 4/6] xfs: fix buffer flushing during unmount
Date: Wed, 30 Nov 2011 12:10:58 -0600
Message-Id: <1322676660-22945-5-git-send-email-bpm@sgi.com>
In-Reply-To: <1322676660-22945-1-git-send-email-bpm@sgi.com>
References: <20111128214018.GB1650@kroah.com>
	<1322676660-22945-1-git-send-email-bpm@sgi.com>
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
To: greg@kroah.com, stable@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, bpm@sgi.com, Alex Elder <aelder@sgi.com>, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

From: Christoph Hellwig <hch@infradead.org>

commit 87c7bec7fc3377b3873eb3a0f4b603981ea16ebb upstream.

The code to flush buffers in the umount code is a bit iffy: we first
flush all delwri buffers out, but then might be able to queue up a
new one when logging the sb counts.  On a normal shutdown that one
would get flushed out when doing the synchronous superblock write in
xfs_unmountfs_writesb, but we skip that one if the filesystem has
been shut down.

Fix this by moving the delwri list flushing until just before unmounting
the log, and while we're at it also remove the superflous delwri list
and buffer lru flusing for the rt and log device that can never have
cached or delwri buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Tested-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/xfs_buf.h   |    1 -
 fs/xfs/xfs_mount.c |   29 ++++++++++-------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 620972b..8e8b06b 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -320,7 +320,6 @@ extern struct list_head *xfs_get_buftarg_list(void);
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-#define xfs_binval(buftarg)		xfs_flush_buftarg(buftarg, 1)
 #define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
 
 #endif	/* __XFS_BUF_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 0081657..d4d5775 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -44,9 +44,6 @@
 #include "xfs_trace.h"
 
 
-STATIC void	xfs_unmountfs_wait(xfs_mount_t *);
-
-
 #ifdef HAVE_PERCPU_SB
 STATIC void	xfs_icsb_balance_counter(xfs_mount_t *, xfs_sb_field_t,
 						int);
@@ -1496,11 +1493,6 @@ xfs_unmountfs(
 	 */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	xfs_binval(mp->m_ddev_targp);
-	if (mp->m_rtdev_targp) {
-		xfs_binval(mp->m_rtdev_targp);
-	}
-
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
@@ -1526,7 +1518,16 @@ xfs_unmountfs(
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
-	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
+
+	/*
+	 * Make sure all buffers have been flushed and completed before
+	 * unmounting the log.
+	 */
+	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+	if (error)
+		xfs_warn(mp, "%d busy buffers during unmount.", error);
+	xfs_wait_buftarg(mp->m_ddev_targp);
+
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
@@ -1537,16 +1538,6 @@ xfs_unmountfs(
 	xfs_free_perag(mp);
 }
 
-STATIC void
-xfs_unmountfs_wait(xfs_mount_t *mp)
-{
-	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		xfs_wait_buftarg(mp->m_logdev_targp);
-	if (mp->m_rtdev_targp)
-		xfs_wait_buftarg(mp->m_rtdev_targp);
-	xfs_wait_buftarg(mp->m_ddev_targp);
-}
-
 int
 xfs_fs_writable(xfs_mount_t *mp)
 {
-- 
1.7.8.rc0.46.g5ae0f

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
