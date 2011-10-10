Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrT1w189861 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2C09016BAEC7
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 10:00:39 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	dMINdEESvpuiSFsq for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 10:00:39 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6W-0008Ht-8u
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:28 +0000
Message-Id: <20111010165328.240744351@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:52 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/11] xfs: remove XFS_bflush
References: <20111010165242.656850411@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_bflush
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-07 10:29:09.453018618 -0400
+++ xfs/fs/xfs/xfs_buf.h	2011-10-07 10:29:10.925017534 -0400
@@ -294,6 +294,4 @@ extern int xfs_flush_buftarg(xfs_buftarg
 #define xfs_getsize_buftarg(buftarg)	block_size((buftarg)->bt_bdev)
 #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
 
-#define XFS_bflush(buftarg)		xfs_flush_buftarg(buftarg, 1)
-
 #endif	/* __XFS_BUF_H__ */
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-10-07 10:25:55.480875753 -0400
+++ xfs/fs/xfs/xfs_log_recover.c	2011-10-07 10:29:10.929019399 -0400
@@ -3654,7 +3654,7 @@ xlog_do_recover(
 		return error;
 	}
 
-	XFS_bflush(log->l_mp->m_ddev_targp);
+	xfs_flush_buftarg(log->l_mp->m_ddev_targp, 1);
 
 	/*
 	 * If IO errors happened during recovery, bail out.
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-10-07 10:25:59.917017490 -0400
+++ xfs/fs/xfs/xfs_mount.c	2011-10-07 10:29:10.933016765 -0400
@@ -1481,7 +1481,7 @@ xfs_unmountfs(
 	 * state as much as possible.
 	 */
 	xfs_reclaim_inodes(mp, 0);
-	XFS_bflush(mp->m_ddev_targp);
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	xfs_qm_unmount(mp);
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-07 10:20:36.768517710 -0400
+++ xfs/fs/xfs/xfs_qm.c	2011-10-07 10:29:10.933016765 -0400
@@ -1681,7 +1681,7 @@ xfs_qm_quotacheck(
 	 * quotacheck'd stamp on the superblock. So, here we do a synchronous
 	 * flush.
 	 */
-	XFS_bflush(mp->m_ddev_targp);
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	/*
 	 * If one type of quotas is off, then it will lose its
Index: xfs/fs/xfs/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/xfs_super.c	2011-10-07 10:20:36.780519685 -0400
+++ xfs/fs/xfs/xfs_super.c	2011-10-07 10:29:10.941016441 -0400
@@ -1015,7 +1015,7 @@ xfs_fs_put_super(
 	 */
 	xfs_filestream_unmount(mp);
 
-	XFS_bflush(mp->m_ddev_targp);
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
@@ -1439,7 +1439,7 @@ xfs_fs_fill_super(
 	 */
 	xfs_filestream_unmount(mp);
 
-	XFS_bflush(mp->m_ddev_targp);
+	xfs_flush_buftarg(mp->m_ddev_targp, 1);
 
 	xfs_unmountfs(mp);
 	goto out_free_sb;
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-07 10:20:36.796516946 -0400
+++ xfs/fs/xfs/xfs_sync.c	2011-10-07 10:29:10.949016598 -0400
@@ -377,7 +377,7 @@ xfs_quiesce_data(
 
 	/* flush data-only devices */
 	if (mp->m_rtdev_targp)
-		XFS_bflush(mp->m_rtdev_targp);
+		xfs_flush_buftarg(mp->m_rtdev_targp, 1);
 
 	return error ? error : error2;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
