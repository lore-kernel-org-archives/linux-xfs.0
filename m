Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAEGHgkq193827 for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 10:17:44 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0484914DD44B
	for <xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id o0nJvNzD7vO9fFXG for
	<xfs@oss.sgi.com>; Sat, 14 Nov 2009 08:18:02 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1N9LK6-0004Yn-En
	for xfs@oss.sgi.com; Sat, 14 Nov 2009 16:18:02 +0000
Message-Id: <20091114161802.343652891@bombadil.infradead.org>
Date: Sat, 14 Nov 2009 11:17:24 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/7] xfs: cleanup dmapi macros in the umount path
References: <20091114161717.233372584@bombadil.infradead.org>
Content-Disposition: inline; filename=unmount-dmapi-cleanup
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

Stop the flag saving as we never mangle those in the unmount path, and hide all
the weird arguents to the dmapi code inside the XFS_SEND_PREUNMOUNT /
XFS_SEND_UNMOUNT macros.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-11-12 17:10:19.920254621 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-11-12 17:23:54.929032604 +0100
@@ -1131,8 +1131,6 @@ xfs_fs_put_super(
 	struct super_block	*sb)
 {
 	struct xfs_mount	*mp = XFS_M(sb);
-	struct xfs_inode	*rip = mp->m_rootip;
-	int			unmount_event_flags = 0;
 
 	xfs_syncd_stop(mp);
 
@@ -1148,20 +1146,7 @@ xfs_fs_put_super(
 		xfs_sync_attr(mp, 0);
 	}
 
-#ifdef HAVE_DMAPI
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		unmount_event_flags =
-			(mp->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ?
-				0 : DM_FLAGS_UNWANTED;
-		/*
-		 * Ignore error from dmapi here, first unmount is not allowed
-		 * to fail anyway, and second we wouldn't want to fail a
-		 * unmount because of dmapi.
-		 */
-		XFS_SEND_PREUNMOUNT(mp, rip, DM_RIGHT_NULL, rip, DM_RIGHT_NULL,
-				NULL, NULL, 0, 0, unmount_event_flags);
-	}
-#endif
+	XFS_SEND_PREUNMOUNT(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1172,10 +1157,7 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		XFS_SEND_UNMOUNT(mp, rip, DM_RIGHT_NULL, 0, 0,
-				unmount_event_flags);
-	}
+	XFS_SEND_UNMOUNT(mp);
 
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2009-11-12 17:18:51.369006416 +0100
+++ xfs/fs/xfs/xfs_mount.h	2009-11-12 17:23:01.626024632 +0100
@@ -93,6 +93,9 @@ typedef struct xfs_dmops {
 	xfs_send_unmount_t	xfs_send_unmount;
 } xfs_dmops_t;
 
+#define XFS_DMAPI_UNMOUNT_FLAGS(mp) \
+	(((mp)->m_dmevmask & (1 << DM_EVENT_UNMOUNT)) ? 0 : DM_FLAGS_UNWANTED)
+
 #define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
 	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
 #define XFS_SEND_MMAP(mp, vma,fl) \
@@ -101,12 +104,24 @@ typedef struct xfs_dmops {
 	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_PREUNMOUNT(mp,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,mp,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 #define XFS_SEND_MOUNT(mp,right,path,name) \
 	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_UNMOUNT(mp, ip,right,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,ip,right,mode,rval,fl)
+#define XFS_SEND_PREUNMOUNT(mp) \
+do { \
+	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
+		(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT, mp, \
+			(mp)->m_rootip, DM_RIGHT_NULL, \
+			(mp)->m_rootip, DM_RIGHT_NULL, \
+			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
+	} \
+} while (0)
+#define XFS_SEND_UNMOUNT(mp) \
+do { \
+	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
+		(*(mp)->m_dm_ops->xfs_send_unmount)(mp, (mp)->m_rootip, \
+			DM_RIGHT_NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
+	} \
+} while (0)
 
 
 #ifdef HAVE_PERCPU_SB

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
