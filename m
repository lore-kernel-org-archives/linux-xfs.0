Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23Jnlsc031692 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 13:49:47 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 37FB51C1430E
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 11:49:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0XuRUgjhEMabAiKG for
	<xfs@oss.sgi.com>; Tue, 03 Mar 2009 11:49:20 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Leabh-0003dz-AH
	for xfs@oss.sgi.com; Tue, 03 Mar 2009 19:48:49 +0000
Message-Id: <20090303194849.153376000@bombadil.infradead.org>
Date: Tue, 03 Mar 2009 14:48:37 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: only issues a cache flush on unmount if barriers are
	enabled
References: <20090303194834.264998000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-fix-barrier-warning
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

Currently we unconditionally issue a flush from xfs_free_buftarg, but         
since 2.6.29-rc1 this gives a warning in the style of 

	end_request: I/O error, dev vdb, sector 0

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-03-03 15:50:22.367860467 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-03-03 18:10:52.385007793 +0100
@@ -34,6 +34,12 @@
 #include <linux/backing-dev.h>
 #include <linux/freezer.h>
 
+#include "xfs_sb.h"
+#include "xfs_inum.h"
+#include "xfs_ag.h"
+#include "xfs_dmapi.h"
+#include "xfs_mount.h"
+
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
 STATIC int xfsbufd_wakeup(int, gfp_t);
@@ -1435,10 +1441,12 @@ xfs_unregister_buftarg(
 
 void
 xfs_free_buftarg(
-	xfs_buftarg_t		*btp)
+	struct xfs_mount	*mp,
+	struct xfs_buftarg	*btp)
 {
 	xfs_flush_buftarg(btp, 1);
-	xfs_blkdev_issue_flush(btp);
+	if (mp->m_flags & XFS_MOUNT_BARRIER)
+		xfs_blkdev_issue_flush(btp);
 	xfs_free_bufhash(btp);
 	iput(btp->bt_mapping->host);
 
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-03-03 15:50:22.376883054 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-03-03 18:10:52.386007991 +0100
@@ -413,7 +413,7 @@ static inline int XFS_bwrite(xfs_buf_t *
  *	Handling of buftargs.
  */
 extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
-extern void xfs_free_buftarg(xfs_buftarg_t *);
+extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
 extern void xfs_wait_buftarg(xfs_buftarg_t *);
 extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
 extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-03-03 15:50:22.190853363 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-03-03 18:10:52.387004137 +0100
@@ -733,15 +733,15 @@ xfs_close_devices(
 {
 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
 		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
-		xfs_free_buftarg(mp->m_logdev_targp);
+		xfs_free_buftarg(mp, mp->m_logdev_targp);
 		xfs_blkdev_put(logdev);
 	}
 	if (mp->m_rtdev_targp) {
 		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
-		xfs_free_buftarg(mp->m_rtdev_targp);
+		xfs_free_buftarg(mp, mp->m_rtdev_targp);
 		xfs_blkdev_put(rtdev);
 	}
-	xfs_free_buftarg(mp->m_ddev_targp);
+	xfs_free_buftarg(mp, mp->m_ddev_targp);
 }
 
 /*
@@ -810,9 +810,9 @@ xfs_open_devices(
 
  out_free_rtdev_targ:
 	if (mp->m_rtdev_targp)
-		xfs_free_buftarg(mp->m_rtdev_targp);
+		xfs_free_buftarg(mp, mp->m_rtdev_targp);
  out_free_ddev_targ:
-	xfs_free_buftarg(mp->m_ddev_targp);
+	xfs_free_buftarg(mp, mp->m_ddev_targp);
  out_close_rtdev:
 	if (rtdev)
 		xfs_blkdev_put(rtdev);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
