Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 10 Nov 2006 20:26:39 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kAB4QUaG023465
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 20:26:31 -0800
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AA9E4DE9EF
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 20:25:43 -0800 (PST)
Received: from [10.0.0.4] (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 3F7B618CF23E6
	for <xfs@oss.sgi.com>; Fri, 10 Nov 2006 21:52:19 -0600 (CST)
Message-ID: <455548F2.4060500@sandeen.net>
Date: Fri, 10 Nov 2006 21:52:18 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] remove unused xflags parameter from sync routines
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

xfs_syncsub & xfs_sync_inodes have an xflags parameter which
is never used.

-Eric

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

 quota/xfs_qm_syscalls.c |    2 +-
 xfs_mount.h             |    4 ++--
 xfs_vfsops.c            |   18 +++++-------------
 3 files changed, 8 insertions(+), 16 deletions(-)


Index: xfs-linux-allpatches/quota/xfs_qm_syscalls.c
===================================================================
--- xfs-linux-allpatches.orig/quota/xfs_qm_syscalls.c
+++ xfs-linux-allpatches/quota/xfs_qm_syscalls.c
@@ -134,7 +134,7 @@ xfs_qm_quotactl(
 		break;
 
 	case Q_XQUOTASYNC:
-		return (xfs_sync_inodes(mp, SYNC_DELWRI, 0, NULL));
+		return (xfs_sync_inodes(mp, SYNC_DELWRI, NULL));
 
 	default:
 		break;
Index: xfs-linux-allpatches/xfs_mount.h
===================================================================
--- xfs-linux-allpatches.orig/xfs_mount.h
+++ xfs-linux-allpatches/xfs_mount.h
@@ -587,8 +587,8 @@ extern struct xfs_buf *xfs_getsb(xfs_mou
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern void	xfs_do_force_shutdown(bhv_desc_t *, int, char *, int);
-extern int	xfs_syncsub(xfs_mount_t *, int, int, int *);
-extern int	xfs_sync_inodes(xfs_mount_t *, int, int, int *);
+extern int	xfs_syncsub(xfs_mount_t *, int, int *);
+extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern xfs_agnumber_t	xfs_initialize_perag(struct bhv_vfs *, xfs_mount_t *,
 						xfs_agnumber_t);
 extern void	xfs_xlatesb(void *, struct xfs_sb *, int, __int64_t);
Index: xfs-linux-allpatches/xfs_vfsops.c
===================================================================
--- xfs-linux-allpatches.orig/xfs_vfsops.c
+++ xfs-linux-allpatches/xfs_vfsops.c
@@ -640,7 +640,7 @@ xfs_quiesce_fs(
 	 * we can write the unmount record.
 	 */
 	do {
-		xfs_syncsub(mp, SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT, 0, NULL);
+		xfs_syncsub(mp, SYNC_REMOUNT|SYNC_ATTR|SYNC_WAIT, NULL);
 		pincount = xfs_flush_buftarg(mp->m_ddev_targp, 1);
 		if (!pincount) {
 			delay(50);
@@ -886,24 +886,20 @@ xfs_sync(
 	if (unlikely(flags == SYNC_QUIESCE))
 		return xfs_quiesce_fs(mp);
 	else
-		return xfs_syncsub(mp, flags, 0, NULL);
+		return xfs_syncsub(mp, flags, NULL);
 }
 
 /*
  * xfs sync routine for internal use
  *
  * This routine supports all of the flags defined for the generic vfs_sync
- * interface as explained above under xfs_sync.  In the interests of not
- * changing interfaces within the 6.5 family, additional internally-
- * required functions are specified within a separate xflags parameter,
- * only available by calling this routine.
+ * interface as explained above under xfs_sync.
  *
  */
 int
 xfs_sync_inodes(
 	xfs_mount_t	*mp,
 	int		flags,
-	int             xflags,
 	int             *bypassed)
 {
 	xfs_inode_t	*ip = NULL;
@@ -1412,17 +1408,13 @@ xfs_sync_inodes(
  * xfs sync routine for internal use
  *
  * This routine supports all of the flags defined for the generic vfs_sync
- * interface as explained above under xfs_sync.  In the interests of not
- * changing interfaces within the 6.5 family, additional internally-
- * required functions are specified within a separate xflags parameter,
- * only available by calling this routine.
+ * interface as explained above under xfs_sync.
  *
  */
 int
 xfs_syncsub(
 	xfs_mount_t	*mp,
 	int		flags,
-	int             xflags,
 	int             *bypassed)
 {
 	int		error = 0;
@@ -1444,7 +1436,7 @@ xfs_syncsub(
 		if (flags & SYNC_BDFLUSH)
 			xfs_finish_reclaim_all(mp, 1);
 		else
-			error = xfs_sync_inodes(mp, flags, xflags, bypassed);
+			error = xfs_sync_inodes(mp, flags, bypassed);
 	}
 
 	/*
