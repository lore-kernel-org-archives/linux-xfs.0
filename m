Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3irS145552 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3BB80FCE495
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	jjVGFoF3j15gqagO for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:42 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHq-0003AX-FP
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:42 +0000
Message-Id: <20111028100342.421362977@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 38/45] xfs: explicitly empty the AIL on unmount
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-explicitly-empty-ail-on-umount
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
To: xfs@oss.sgi.com

Just like during a freeze we can make sure all metadata has been written back
on unmount by synchronously emptying the AIL.  Unlike during freeze we still
keep a synchronous inode reclaim pass to make sure we relclaim all clean
inodes as well.

After this the last caller of xfs_unmountfs_writesb is gone and it can be
removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_mount.c |   56 +++++++++++------------------------------------------
 fs/xfs/xfs_mount.h |    1 
 2 files changed, 12 insertions(+), 45 deletions(-)

Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-10-27 22:40:10.132675928 +0200
+++ xfs/fs/xfs/xfs_mount.c	2011-10-27 22:40:13.126174145 +0200
@@ -22,6 +22,7 @@
 #include "xfs_log.h"
 #include "xfs_inum.h"
 #include "xfs_trans.h"
+#include "xfs_trans_priv.h"
 #include "xfs_sb.h"
 #include "xfs_ag.h"
 #include "xfs_dir2.h"
@@ -1544,15 +1545,15 @@ xfs_unmountfs(
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
 	/*
-	 * Do a delwri reclaim pass first so that as many dirty inodes are
-	 * queued up for IO as possible. Then flush the buffers before making
-	 * a synchronous path to catch all the remaining inodes are reclaimed.
-	 * This makes the reclaim process as quick as possible by avoiding
-	 * synchronous writeout and blocking on inodes already in the delwri
-	 * state as much as possible.
+	 * Flush all pending changes from the AIL.
+	 */
+	xfs_ail_push_all_sync(mp->m_ail);
+
+	/*
+	 * And reclaim all inodes.  At this point there should be no dirty
+	 * inode, and none should be pinned or locked, but use synchronous
+	 * reclaim just to be sure.
 	 */
-	xfs_reclaim_inodes(mp, 0);
-	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	xfs_qm_unmount(mp);
@@ -1588,15 +1589,12 @@ xfs_unmountfs(
 	if (error)
 		xfs_warn(mp, "Unable to update superblock counters. "
 				"Freespace may not be correct on next mount.");
-	xfs_unmountfs_writesb(mp);
 
 	/*
-	 * Make sure all buffers have been flushed and completed before
-	 * unmounting the log.
+	 * At this point we might have modified the superblock again and thus
+	 * added an item to the AIL, thus flush it again.
 	 */
-	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
-	if (error)
-		xfs_warn(mp, "%d busy buffers during unmount.", error);
+	xfs_ail_push_all_sync(mp->m_ail);
 	xfs_wait_buftarg(mp->m_ddev_targp);
 
 	xfs_log_unmount_write(mp);
@@ -1657,36 +1655,6 @@ xfs_log_sbcount(xfs_mount_t *mp)
 	return error;
 }
 
-int
-xfs_unmountfs_writesb(xfs_mount_t *mp)
-{
-	xfs_buf_t	*sbp;
-	int		error = 0;
-
-	/*
-	 * skip superblock write if fs is read-only, or
-	 * if we are doing a forced umount.
-	 */
-	if (!((mp->m_flags & XFS_MOUNT_RDONLY) ||
-		XFS_FORCED_SHUTDOWN(mp))) {
-
-		sbp = xfs_getsb(mp, 0);
-
-		XFS_BUF_UNDONE(sbp);
-		XFS_BUF_UNREAD(sbp);
-		xfs_buf_delwri_dequeue(sbp);
-		XFS_BUF_WRITE(sbp);
-		XFS_BUF_UNASYNC(sbp);
-		ASSERT(sbp->b_target == mp->m_ddev_targp);
-		xfsbdstrat(mp, sbp);
-		error = xfs_buf_iowait(sbp);
-		if (error)
-			xfs_buf_ioerror_alert(sbp, __func__);
-		xfs_buf_relse(sbp);
-	}
-	return error;
-}
-
 /*
  * xfs_mod_sb() can be used to copy arbitrary changes to the
  * in-core superblock into the superblock buffer to be logged.
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2011-10-27 22:39:57.502188861 +0200
+++ xfs/fs/xfs/xfs_mount.h	2011-10-27 22:40:13.130172675 +0200
@@ -379,7 +379,6 @@ extern __uint64_t xfs_default_resblks(xf
 extern int	xfs_mountfs(xfs_mount_t *mp);
 
 extern void	xfs_unmountfs(xfs_mount_t *);
-extern int	xfs_unmountfs_writesb(xfs_mount_t *);
 extern int	xfs_mod_incore_sb(xfs_mount_t *, xfs_sb_field_t, int64_t, int);
 extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
 			uint, int);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
