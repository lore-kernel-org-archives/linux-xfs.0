Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM2RSb044202 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:02:27 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282205.o5SM5CKp018150@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:05:12 -0500
Subject: [PATCH 05/15] xfs: rewrite DMAPI mount macros as functions
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Re-implement XFS_SEND_PREUNMOUNT(), XFS_SEND_MOUNT(), XFS_SEND_UNMOUNT,
using real (static inline) functions.

In XFS_SEND_MOUNT(), DM_RIGHT_NULL is is the only value passed for
"right", so eliminate the argument and hard-code that value instead.
Similarly, the "name" is always just the filesystem name recorded in
the mount structure, so just use that.

Also in XFS_SEND_MOUNT(), there was previously no check for whether
XFS_MOUNT_DMAPI is enabled on the file system before dereferencing
the m_dm_ops field.  Add it, in preparation for eventually allowing
that field to be null when DMAPI is not active.  As before, if it's
not enabled, the event function will return ENOSYS.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_super.c |   11 +++++--
 fs/xfs/xfs_dmapi.h           |   60 ++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 21 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1206,7 +1206,7 @@ xfs_fs_put_super(
 		xfs_sync_attr(mp, 0);
 	}
 
-	XFS_SEND_PREUNMOUNT(mp);
+	xfs_dmapi_send_preunmount(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
@@ -1217,7 +1217,7 @@ xfs_fs_put_super(
 
 	XFS_bflush(mp->m_ddev_targp);
 
-	XFS_SEND_UNMOUNT(mp);
+	xfs_dmapi_send_unmount(mp);
 
 	xfs_unmountfs(mp);
 	xfs_freesb(mp);
@@ -1607,7 +1607,12 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_filestream_unmount;
 
-	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, mtpt, mp->m_fsname);
+	/* XXX
+	 * This can return an error--at least ENOMEM and possibly
+	 * others.  If that happens, we should probably disable
+	 * DMAPI on the file system or something.
+	 */
+	(void) xfs_dmapi_send_mount(mp, mtpt);
 
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -217,23 +217,47 @@ xfs_dmapi_event_enabled(struct xfs_inode
 	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_MOUNT(mp,right,path,name) \
-	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_PREUNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT, mp, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			(mp)->m_rootip, DM_RIGHT_NULL, \
-			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
-#define XFS_SEND_UNMOUNT(mp) \
-do { \
-	if (mp->m_flags & XFS_MOUNT_DMAPI) { \
-		(*(mp)->m_dm_ops->xfs_send_unmount)(mp, (mp)->m_rootip, \
-			DM_RIGHT_NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp)); \
-	} \
-} while (0)
+
+static inline int
+xfs_dmapi_send_mount(
+	struct xfs_mount	*mp,
+	char			*path)
+{
+    	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		xfs_send_mount_t send_mount = mp->m_dm_ops->xfs_send_mount;
+
+		return send_mount(mp, DM_RIGHT_NULL, path, mp->m_fsname);
+	}
+
+	return ENOSYS;
+}
+
+
+static inline void
+xfs_dmapi_send_preunmount(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		xfs_send_namesp_t send_namesp = mp->m_dm_ops->xfs_send_namesp;
+
+		(void) send_namesp(DM_EVENT_PREUNMOUNT, mp,
+			mp->m_rootip, DM_RIGHT_NULL,
+			mp->m_rootip, DM_RIGHT_NULL,
+			NULL, NULL, 0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
+	}
+}
+
+static inline void
+xfs_dmapi_send_unmount(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+		xfs_send_unmount_t send_unmount =
+					mp->m_dm_ops->xfs_send_unmount;
+
+		send_unmount(mp, mp->m_rootip, DM_RIGHT_NULL,
+				0, 0, XFS_DMAPI_UNMOUNT_FLAGS(mp));
+	}
+}
 
 #endif  /* __XFS_DMAPI_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
