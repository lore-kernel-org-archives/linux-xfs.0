Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:40:06 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJe04p005163
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:40:03 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdxA5008740
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:59 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJdxmx008738
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:59 +0200
Date: Thu, 23 Aug 2007 21:39:59 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/17] kill the vfs_fsid and vfs_altfsid members in struct bhv_vfs.
Message-ID: <20070823193959.GO8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

vfs_altfsid was just a pointer to mp->m_fixedfsid so we can trivially
replace it with the latter.  vfs_fsid also was identicaly to m_fixedfsid
through rather obsfucated ways so we can kill it aswell and simply it's
only user.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:07:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:08:05.000000000 +0200
@@ -1501,7 +1501,7 @@ xfs_dm_get_bulkall_rvp(
 	 */
 
 	dmb.laststruct = NULL;
-	memcpy(&dmb.fsid, XFS_MTOVFS(mp)->vfs_altfsid, sizeof(dm_fsid_t));
+	memcpy(&dmb.fsid, mp->m_fixedfsid, sizeof(dm_fsid_t));
 	error = xfs_bulkstat(mp, (xfs_ino_t *)&loc, &nelems,
 			     xfs_dm_bulkall_one, (void*)&dmb, statstruct_sz,
 			     bufp, BULKSTAT_FG_INLINE, &done);
@@ -1597,7 +1597,7 @@ xfs_dm_get_bulkattr_rvp(
 	}
 
 	dmb.laststruct = NULL;
-	memcpy(&dmb.fsid, XFS_MTOVFS(mp)->vfs_altfsid, sizeof(dm_fsid_t));
+	memcpy(&dmb.fsid, mp->m_fixedfsid, sizeof(dm_fsid_t));
 	error = xfs_bulkstat(mp, (xfs_ino_t *)&loc, &nelems,
 				xfs_dm_bulkattr_one, (void*)&dmb,
 				statstruct_sz, bufp, BULKSTAT_FG_INLINE, &done);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-13 18:08:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-13 18:08:05.000000000 +0200
@@ -91,20 +91,19 @@ xfs_dm_inode_to_fh(
 	dm_fsid_t		*dmfsid)
 {
 	xfs_inode_t		*ip = XFS_I(inode);
-	bhv_vfs_t		*vfsp = XFS_MTOVFS(ip->i_mount);
 	int			error;
 	fid_t			fid;
 
 	/* Returns negative errors to DMAPI */
 
-	if (vfsp->vfs_altfsid == NULL)
+	if (ip->i_mount->m_fixedfsid == NULL)
 		return -EINVAL;
 	error = xfs_fid2(ip, &fid);
 	if (error)
 		return -error; /* Return negative error to DMAPI */
 
 	memcpy(dmfid, &fid, sizeof(*dmfid));
-	memcpy(dmfsid, vfsp->vfs_altfsid, sizeof(*dmfsid));
+	memcpy(dmfsid, ip->i_mount->m_fixedfsid, sizeof(*dmfsid));
 	return 0;
 }
 
@@ -121,7 +120,7 @@ xfs_dm_get_fsid(
 	struct super_block	*sb,
 	dm_fsid_t		*fsid)
 {
-	memcpy(fsid, vfs_from_sb(sb)->vfs_altfsid, sizeof(*fsid));
+	memcpy(fsid, XFS_M(sb)->m_fixedfsid, sizeof(*fsid));
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-13 18:07:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-13 18:08:05.000000000 +0200
@@ -138,7 +138,7 @@ xfs_find_handle(
 	vp = vn_from_inode(inode);
 
 	/* now we can grab the fsid */
-	memcpy(&handle.ha_fsid, XFS_MTOVFS(XFS_I(inode)->i_mount)->vfs_altfsid,
+	memcpy(&handle.ha_fsid, XFS_I(inode)->i_mount->m_fixedfsid,
 			sizeof(xfs_fsid_t));
 	hsize = sizeof(xfs_fsid_t);
 
@@ -966,7 +966,7 @@ xfs_ioctl(
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		error = xfs_errortag_clearall(mp);
+		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
 	default:
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:08:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:08:05.000000000 +0200
@@ -44,8 +44,6 @@ typedef struct bhv_vfs_sync_work {
 typedef struct bhv_vfs {
 	struct xfs_mount	*vfs_mount;
 	u_int			vfs_flag;	/* flags */
-	xfs_fsid_t		vfs_fsid;	/* file system ID */
-	xfs_fsid_t		*vfs_altfsid;	/* An ID fixed for life of FS */
 	struct super_block	*vfs_super;	/* generic superblock pointer */
 	struct task_struct	*vfs_sync_task;	/* generalised sync thread */
 	bhv_vfs_sync_work_t	vfs_sync_work;	/* work item for VFS_SYNC */
Index: linux-2.6-xfs/fs/xfs/xfs_error.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.c	2007-08-13 18:04:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_error.c	2007-08-13 18:08:05.000000000 +0200
@@ -133,10 +133,14 @@ xfs_errortag_add(int error_tag, xfs_moun
 }
 
 int
-xfs_errortag_clearall_umount(int64_t fsid, char *fsname, int loud)
+xfs_errortag_clearall(xfs_mount_t *mp, int loud)
 {
-	int i;
+	int64_t fsid;
 	int cleared = 0;
+	int i;
+
+	memcpy(&fsid, mp->m_fixedfsid, sizeof(xfs_fsid_t));
+
 
 	for (i = 0; i < XFS_NUM_INJECT_ERROR; i++) {
 		if ((fsid == 0LL || xfs_etest_fsid[i] == fsid) &&
@@ -155,20 +159,10 @@ xfs_errortag_clearall_umount(int64_t fsi
 	if (loud || cleared)
 		cmn_err(CE_WARN,
 			"Cleared all XFS error tags for filesystem \"%s\"",
-			fsname);
+			mp->m_fsname);
 
 	return 0;
 }
-
-int
-xfs_errortag_clearall(xfs_mount_t *mp)
-{
-	int64_t fsid;
-
-	memcpy(&fsid, mp->m_fixedfsid, sizeof(xfs_fsid_t));
-
-	return xfs_errortag_clearall_umount(fsid, mp->m_fsname, 1);
-}
 #endif /* DEBUG || INDUCE_IO_ERROR */
 
 static void
Index: linux-2.6-xfs/fs/xfs/xfs_error.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_error.h	2007-08-13 17:59:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_error.h	2007-08-13 18:08:05.000000000 +0200
@@ -144,12 +144,11 @@ extern void xfs_error_test_init(void);
 #endif /* __ANSI_CPP__ */
 
 extern int xfs_errortag_add(int error_tag, xfs_mount_t *mp);
-extern int xfs_errortag_clearall(xfs_mount_t *mp);
-extern int xfs_errortag_clearall_umount(int64_t fsid, char *fsname, int loud);
+extern int xfs_errortag_clearall(xfs_mount_t *mp, int loud);
 #else
 #define XFS_TEST_ERROR(expr, mp, tag, rf)	(expr)
 #define xfs_errortag_add(tag, mp)		(ENOSYS)
-#define xfs_errortag_clearall(mp)		(ENOSYS)
+#define xfs_errortag_clearall(mp, loud)		(ENOSYS)
 #endif /* (DEBUG || INDUCE_IO_ERROR) */
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-13 18:08:02.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-13 18:08:05.000000000 +0200
@@ -872,14 +872,11 @@ xfs_mountfs(
 	 */
 	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
 	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
-		__uint64_t	ret64;
 		if (xfs_uuid_mount(mp)) {
 			error = XFS_ERROR(EINVAL);
 			goto error1;
 		}
 		uuid_mounted=1;
-		ret64 = uuid_hash64(&sbp->sb_uuid);
-		memcpy(&vfsp->vfs_fsid, &ret64, sizeof(ret64));
 	}
 
 	/*
@@ -1004,16 +1001,6 @@ xfs_mountfs(
 	 */
 	uuid_getnodeuniq(&sbp->sb_uuid, mp->m_fixedfsid);
 
-	/*
-	 *  The vfs structure needs to have a file system independent
-	 *  way of checking for the invariant file system ID.  Since it
-	 *  can't look at mount structures it has a pointer to the data
-	 *  in the mount structure.
-	 *
-	 *  File systems that don't support user level file handles (i.e.
-	 *  all of them except for XFS) will leave vfs_altfsid as NULL.
-	 */
-	vfsp->vfs_altfsid = (xfs_fsid_t *)mp->m_fixedfsid;
 	mp->m_dmevmask = 0;	/* not persistent; set after each mount */
 
 	xfs_dir_mount(mp);
@@ -1203,9 +1190,6 @@ int
 xfs_unmountfs(xfs_mount_t *mp, struct cred *cr)
 {
 	struct bhv_vfs	*vfsp = XFS_MTOVFS(mp);
-#if defined(DEBUG) || defined(INDUCE_IO_ERROR)
-	int64_t		fsid;
-#endif
 	__uint64_t	resblks;
 
 	/*
@@ -1269,11 +1253,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 		xfs_uuid_unmount(mp);
 
 #if defined(DEBUG) || defined(INDUCE_IO_ERROR)
-	/*
-	 * clear all error tags on this filesystem
-	 */
-	memcpy(&fsid, &vfsp->vfs_fsid, sizeof(int64_t));
-	xfs_errortag_clearall_umount(fsid, mp->m_fsname, 0);
+	xfs_errortag_clearall(mp, 0);
 #endif
 	XFS_IODONE(vfsp);
 	xfs_mount_free(mp);
