Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1FBmxKY172836 for <xfs@oss.sgi.com>; Wed, 15 Feb 2012 05:48:59 -0600
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Date: Wed, 15 Feb 2012 17:26:20 +0530
Message-Id: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com
Cc: Nam-Jae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>

Whenever there is a mount/unmount failure - there is a chance of calling the
callbacks functions once - transaction ail mount pointer is destroyed. So, it results
in NULL pointer exception followed by hang. So, before unmount of the log - flush all
the pending buffers.

Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/xfs/xfs_log.c   |   10 ++++++++++
 fs/xfs/xfs_mount.c |    9 ---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e2cc356..b924a5b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -739,6 +739,16 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 void
 xfs_log_unmount(xfs_mount_t *mp)
 {
+	int error = 0;
+	/*
+	 * Make sure all buffers have been flushed and completed before
+	 * unmounting the log.
+	 */
+	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
+	if (error)
+		cmn_err(CE_WARN, "%d busy buffers during log unmount.", error);
+	xfs_wait_buftarg(mp->m_ddev_targp);
+	
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
 }
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d06afbc..3bd2246 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1519,15 +1519,6 @@ xfs_unmountfs(
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
 
-	/*
-	 * Make sure all buffers have been flushed and completed before
-	 * unmounting the log.
-	 */
-	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-	if (error)
-		xfs_warn(mp, "%d busy buffers during unmount.", error);
-	xfs_wait_buftarg(mp->m_ddev_targp);
-
 	xfs_log_unmount_write(mp);
 	xfs_log_unmount(mp);
 	xfs_uuid_unmount(mp);
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
