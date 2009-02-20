Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8r17Y164767 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B72881383A3
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id ltNWyVpAXKKeoWey for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7U-0003zs-PL
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:28 +0000
Message-Id: <20090220085228.602565000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:08 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/7] xfs: cleanup log unmount handling
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-log-unmount
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

Kill the current xfs_log_unmount wrapper and opencode the two function
calls in the only caller.  Rename the current xfs_log_unmount_dealloc to
xfs_log_unmount as it undoes xfs_log_mount and the new name makes that
more clear.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2009-02-10 19:18:54.177068965 +0100
+++ xfs/fs/xfs/xfs_log.c	2009-02-10 19:21:28.338068613 +0100
@@ -635,19 +635,6 @@ xfs_log_mount_finish(xfs_mount_t *mp)
 }
 
 /*
- * Unmount processing for the log.
- */
-int
-xfs_log_unmount(xfs_mount_t *mp)
-{
-	int		error;
-
-	error = xfs_log_unmount_write(mp);
-	xfs_log_unmount_dealloc(mp);
-	return error;
-}
-
-/*
  * Final log writes as part of unmount.
  *
  * Mark the filesystem clean as unmount happens.  Note that during relocation
@@ -797,7 +784,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
  * and deallocate the log as the aild references the log.
  */
 void
-xfs_log_unmount_dealloc(xfs_mount_t *mp)
+xfs_log_unmount(xfs_mount_t *mp)
 {
 	xfs_trans_ail_destroy(mp);
 	xlog_dealloc_log(mp->m_log);
Index: xfs/fs/xfs/xfs_log.h
===================================================================
--- xfs.orig/fs/xfs/xfs_log.h	2009-02-10 11:10:41.813069852 +0100
+++ xfs/fs/xfs/xfs_log.h	2009-02-10 19:21:28.338068613 +0100
@@ -170,9 +170,8 @@ int	  xfs_log_write(struct xfs_mount *mp
 			int		 nentries,
 			xfs_log_ticket_t ticket,
 			xfs_lsn_t	 *start_lsn);
-int	  xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_unmount_write(struct xfs_mount *mp);
-void      xfs_log_unmount_dealloc(struct xfs_mount *mp);
+void      xfs_log_unmount(struct xfs_mount *mp);
 int	  xfs_log_force_umount(struct xfs_mount *mp, int logerror);
 int	  xfs_log_need_covered(struct xfs_mount *mp);
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2009-02-10 19:16:19.537069383 +0100
+++ xfs/fs/xfs/xfs_mount.c	2009-02-10 19:21:28.339069370 +0100
@@ -1194,7 +1194,7 @@ xfs_mountfs(
  out_rele_rip:
 	IRELE(rip);
  out_log_dealloc:
-	xfs_log_unmount_dealloc(mp);
+	xfs_log_unmount(mp);
  out_free_perag:
 	xfs_free_perag(mp);
  out_remove_uuid:
@@ -1280,7 +1280,8 @@ xfs_unmountfs(
 				"Freespace may not be correct on next mount.");
 	xfs_unmountfs_writesb(mp);
 	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
-	xfs_log_unmount(mp);			/* Done! No more fs ops. */
+	xfs_log_unmount_write(mp);
+	xfs_log_unmount(mp);
 
 	if ((mp->m_flags & XFS_MOUNT_NOUUID) == 0)
 		uuid_table_remove(&mp->m_sb.sb_uuid);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
