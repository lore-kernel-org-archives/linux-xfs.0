Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SM3HMe044324 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 17:03:17 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201006282206.o5SM62Hg018201@stout.americas.sgi.com>
Date: Mon, 28 Jun 2010 17:06:02 -0500
Subject: [PATCH 10/15] xfs: kill xfs_dmcore_stub
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

Nobody ever dereferences an XFS mount point's m_dm_ops vector
pointer any more unless the XFS_MOUNT_DMAPI mount flag is set.  So
leverage that to just use a null pointer there in that case, and
drop the whole xfs_dmcore_stub variable.

Change it so that once the m_dm_ops vector has had a chance to be
assigned at mount time, a non-null m_vm_ops pointer is always used
to indicate DMAPI is active on a file system rather than looking at
the mount flag.

Also rearrange the logic in xfs_dmops_get() a bit to avoid
including much of the code in the case DMAPI isn't supported
at build time.

Signed-off-by: Alex Elder <aelder@sgi.com>

---
 fs/xfs/linux-2.6/xfs_file.c |    6 ++----
 fs/xfs/xfs_dmapi.h          |   10 +++++-----
 fs/xfs/xfs_dmops.c          |   37 +++++++++++++++++++++----------------
 3 files changed, 28 insertions(+), 25 deletions(-)

Index: b/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- a/fs/xfs/linux-2.6/xfs_file.c
+++ b/fs/xfs/linux-2.6/xfs_file.c
@@ -674,8 +674,7 @@ start:
 		goto out_unlock_mutex;
 	}
 
-	if (mp->m_flags & XFS_MOUNT_DMAPI && !(ioflags & IO_INVIS) &&
-			!eventsent) {
+	if (mp->m_dm_ops && !(ioflags & IO_INVIS) && !eventsent) {
 		int	dmflags = FILP_DELAY_FLAG(file);
 
 		if (need_i_mutex)
@@ -830,8 +829,7 @@ write_retry:
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	}
 
-	if (ret == -ENOSPC && mp->m_flags & XFS_MOUNT_DMAPI &&
-			!(ioflags & IO_INVIS)) {
+	if (ret == -ENOSPC && mp->m_dm_ops && !(ioflags & IO_INVIS)) {
 		xfs_iunlock(ip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
Index: b/fs/xfs/xfs_dmapi.h
===================================================================
--- a/fs/xfs/xfs_dmapi.h
+++ b/fs/xfs/xfs_dmapi.h
@@ -201,7 +201,7 @@ xfs_dmapi_event_enabled(struct xfs_inode
 #ifdef XFS_DMAPI
     	unsigned int event_mask = 1 << event;
 
-	return ip->i_mount->m_flags & XFS_MOUNT_DMAPI &&
+	return ip->i_mount->m_dm_ops &&
 		(ip->i_mount->m_dmevmask & event_mask ||
 			ip->i_d.di_dmevmask & event_mask);
 #else /* ! XFS_DMAPI */
@@ -235,7 +235,7 @@ xfs_dmapi_send_mmap(
 	struct inode		*inode = vma->vm_file->f_path.dentry->d_inode;
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
 
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+	if (mp->m_dm_ops) {
 		xfs_send_mmap_t	send_mmap = mp->m_dm_ops->xfs_send_mmap;
 
 		return send_mmap(vma, vm_flags);
@@ -319,7 +319,7 @@ xfs_dmapi_send_mount(
 	struct xfs_mount	*mp,
 	char			*path)
 {
-    	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+    	if (mp->m_dm_ops) {
 		xfs_send_mount_t send_mount = mp->m_dm_ops->xfs_send_mount;
 
 		return send_mount(mp, DM_RIGHT_NULL, path, mp->m_fsname);
@@ -333,7 +333,7 @@ static inline void
 xfs_dmapi_send_preunmount(
 	struct xfs_mount	*mp)
 {
-	if (mp->m_flags & XFS_MOUNT_DMAPI)
+	if (mp->m_dm_ops)
 		(void) xfs_dmapi_send_namesp(mp->m_rootip, DM_RIGHT_NULL, NULL,
 					DM_EVENT_PREUNMOUNT,
 					mp->m_rootip, DM_RIGHT_NULL, NULL,
@@ -344,7 +344,7 @@ static inline void
 xfs_dmapi_send_unmount(
 	struct xfs_mount	*mp)
 {
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
+	if (mp->m_dm_ops) {
 		xfs_send_unmount_t send_unmount =
 					mp->m_dm_ops->xfs_send_unmount;
 
Index: b/fs/xfs/xfs_dmops.c
===================================================================
--- a/fs/xfs/xfs_dmops.c
+++ b/fs/xfs/xfs_dmops.c
@@ -28,30 +28,35 @@
 #include "xfs_inode.h"
 #include "xfs_dmapi.h"
 
-
-static struct xfs_dmops xfs_dmcore_stub = {
-	.xfs_send_data		= (xfs_send_data_t)fs_nosys,
-	.xfs_send_mmap		= (xfs_send_mmap_t)fs_noerr,
-	.xfs_send_destroy	= (xfs_send_destroy_t)fs_nosys,
-	.xfs_send_namesp	= (xfs_send_namesp_t)fs_nosys,
-	.xfs_send_mount		= (xfs_send_mount_t)fs_nosys,
-	.xfs_send_unmount	= (xfs_send_unmount_t)fs_noerr,
-};
-
 int
 xfs_dmops_get(struct xfs_mount *mp)
 {
-	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		cmn_err(CE_WARN,
-			"XFS: dmapi support not available in this kernel.");
-		return EINVAL;
+	ASSERT(!mp->m_dm_ops);
+	if (!(mp->m_flags & XFS_MOUNT_DMAPI))
+	    	return 0;
+
+#ifdef	XFS_DMAPI
+	mp->m_dm_ops = symbol_get(xfs_dmcore_xfs);
+	if (!mp->m_dm_ops) {
+		request_module("xfs_dmapi");
+		mp->m_dm_ops = symbol_get(xfs_dmcore_xfs);
 	}
+	if (mp->m_dm_ops)
+		return 0;
+#endif	/* XFS_DMAPI */
 
-	mp->m_dm_ops = &xfs_dmcore_stub;
-	return 0;
+	/* Turn off the flag, since it won't be operative */
+	mp->m_flags &= ~XFS_MOUNT_DMAPI;
+	cmn_err(CE_WARN, "XFS: dmapi support not available in this kernel.");
+
+	return EINVAL;
 }
 
 void
 xfs_dmops_put(struct xfs_mount *mp)
 {
+	if (mp->m_dm_ops) {
+		symbol_put(xfs_dmcore_xfs);
+		mp->m_dm_ops = NULL;
+	}
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
