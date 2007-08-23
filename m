Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:37:57 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJbp4p002841
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:37:54 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJboA5008491
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:37:50 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJboLG008489
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:37:50 +0200
Date: Thu, 23 Aug 2007 21:37:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/17] kill v_vfsp member from struct bhv_vnode
Message-ID: <20070823193750.GD8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

We can easily get at the vfsp through the super_block but it will soon
be gone anyway.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 19:00:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 19:03:03.000000000 +0200
@@ -236,10 +236,10 @@ xfs_vm_nopage(
 	int			*type)
 {
 	struct inode	*inode = area->vm_file->f_path.dentry->d_inode;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
 
-	ASSERT_ALWAYS(vp->v_vfsp->vfs_flag & VFS_DMI);
-	if (XFS_SEND_MMAP(XFS_VFSTOM(vp->v_vfsp), area, 0))
+	ASSERT_ALWAYS(vfsp->vfs_flag & VFS_DMI);
+	if (XFS_SEND_MMAP(XFS_VFSTOM(vfsp), area, 0))
 		return NULL;
 	return filemap_nopage(area, address, type);
 }
@@ -285,7 +285,7 @@ xfs_file_mmap(
 	vma->vm_ops = &xfs_file_vm_ops;
 
 #ifdef HAVE_DMAPI
-	if (vn_from_inode(filp->f_path.dentry->d_inode)->v_vfsp->vfs_flag & VFS_DMI)
+	if (vfs_from_sb(filp->f_path.dentry->d_inode->i_sb)->vfs_flag & VFS_DMI)
 		vma->vm_ops = &xfs_dmapi_file_vm_ops;
 #endif /* HAVE_DMAPI */
 
@@ -344,16 +344,14 @@ xfs_vm_mprotect(
 	struct vm_area_struct *vma,
 	unsigned int	newflags)
 {
-	bhv_vnode_t	*vp = vn_from_inode(vma->vm_file->f_path.dentry->d_inode);
+	struct inode	*inode = vma->vm_file->f_path.dentry->d_inode;
+	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
 	int		error = 0;
 
-	if (vp->v_vfsp->vfs_flag & VFS_DMI) {
+	if (vfsp->vfs_flag & VFS_DMI) {
 		if ((vma->vm_flags & VM_MAYSHARE) &&
-		    (newflags & VM_WRITE) && !(vma->vm_flags & VM_WRITE)) {
-			xfs_mount_t	*mp = XFS_VFSTOM(vp->v_vfsp);
-
-			error = XFS_SEND_MMAP(mp, vma, VM_WRITE);
-		    }
+		    (newflags & VM_WRITE) && !(vma->vm_flags & VM_WRITE))
+			error = XFS_SEND_MMAP(XFS_VFSTOM(vfsp), vma, VM_WRITE);
 	}
 	return error;
 }
@@ -370,18 +368,17 @@ STATIC int
 xfs_file_open_exec(
 	struct inode	*inode)
 {
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
 
-	if (unlikely(vp->v_vfsp->vfs_flag & VFS_DMI)) {
-		xfs_mount_t	*mp = XFS_VFSTOM(vp->v_vfsp);
-		xfs_inode_t	*ip = xfs_vtoi(vp);
-
-		if (!ip)
-			return -EINVAL;
-		if (DM_EVENT_ENABLED(ip, DM_EVENT_READ))
-			return -XFS_SEND_DATA(mp, DM_EVENT_READ, vp,
-					       0, 0, 0, NULL);
+	if (unlikely(vfsp->vfs_flag & VFS_DMI)) {
+		if (DM_EVENT_ENABLED(XFS_I(inode), DM_EVENT_READ)) {
+			bhv_vnode_t *vp = vn_from_inode(inode);
+
+			return -XFS_SEND_DATA(XFS_VFSTOM(vfsp), DM_EVENT_READ,
+						vp, 0, 0, 0, NULL);
+		}
 	}
+
 	return 0;
 }
 #endif /* HAVE_FOP_OPEN_EXEC */
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2007-08-23 19:03:03.000000000 +0200
@@ -372,6 +372,7 @@ xfs_acl_allow_set(
 	bhv_vnode_t	*vp,
 	int		kind)
 {
+	xfs_inode_t	*ip = xfs_vtoi(vp);
 	bhv_vattr_t	va;
 	int		error;
 
@@ -379,10 +380,10 @@ xfs_acl_allow_set(
 		return EPERM;
 	if (kind == _ACL_TYPE_DEFAULT && !VN_ISDIR(vp))
 		return ENOTDIR;
-	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
+	if (vp->v_inode.i_sb->s_flags & MS_RDONLY)
 		return EROFS;
 	va.va_mask = XFS_AT_UID;
-	error = xfs_getattr(xfs_vtoi(vp), &va, 0);
+	error = xfs_getattr(ip, &va, 0);
 	if (error)
 		return error;
 	if (va.va_uid != current->fsuid && !capable(CAP_FOWNER))
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-23 19:03:03.000000000 +0200
@@ -1154,7 +1154,7 @@ xfs_ialloc(
 	if ((prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
 		xfs_bump_ino_vers2(tp, ip);
 
-	if (pip && XFS_INHERIT_GID(pip, vp->v_vfsp)) {
+	if (pip && XFS_INHERIT_GID(pip, XFS_MTOVFS(pip->i_mount))) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((pip->i_d.di_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR) {
 			ip->i_d.di_mode |= S_ISGID;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 19:03:03.000000000 +0200
@@ -230,7 +230,7 @@ xfs_setattr(
 
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
-	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
+	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
 		return XFS_ERROR(EROFS);
 
 	/*
@@ -1512,7 +1512,7 @@ xfs_release(
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
+	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
 		return 0;
 
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
@@ -1618,7 +1618,7 @@ xfs_inactive(
 	error = 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
+	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
 		goto out;
 
 	if (ip->i_d.di_nlink != 0) {
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 19:03:03.000000000 +0200
@@ -1804,8 +1804,7 @@ static void	printvnode(bhv_vnode_t *vp, 
 	kdb_printf("   v_trace 0x%p\n", vp->v_trace);
 #endif	/* XFS_VNODE_TRACE */
 
-	kdb_printf("   v_vfsp 0x%p v_number 0x%llx\n",
-		vp->v_vfsp, (unsigned long long)vp->v_number);
+	kdb_printf("   v_number 0x%llx\n", (unsigned long long)vp->v_number);
 }
 
 static int	kdbm_vnode(
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 19:06:12.000000000 +0200
@@ -1452,7 +1452,7 @@ xfs_dm_get_bulkall_rvp(
 	int		nelems;
 	u_int		statstruct_sz;
 	dm_attrloc_t	loc;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	xfs_mount_t	*mp = XFS_I(inode)->i_mount;
 	dm_attrname_t	attrname;
 	dm_bulkstat_one_t dmb;
 
@@ -1501,8 +1501,8 @@ xfs_dm_get_bulkall_rvp(
 	 */
 
 	dmb.laststruct = NULL;
-	memcpy(&dmb.fsid, vp->v_vfsp->vfs_altfsid, sizeof(dm_fsid_t));
-	error = xfs_bulkstat(xfs_vfstom(vp->v_vfsp), (xfs_ino_t *)&loc, &nelems,
+	memcpy(&dmb.fsid, XFS_MTOVFS(mp)->vfs_altfsid, sizeof(dm_fsid_t));
+	error = xfs_bulkstat(mp, (xfs_ino_t *)&loc, &nelems,
 			     xfs_dm_bulkall_one, (void*)&dmb, statstruct_sz,
 			     bufp, BULKSTAT_FG_INLINE, &done);
 	if (error)
@@ -1566,7 +1566,7 @@ xfs_dm_get_bulkattr_rvp(
 	int		nelems;
 	u_int		statstruct_sz;
 	dm_attrloc_t	loc;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	xfs_mount_t	*mp = XFS_I(inode)->i_mount;
 	dm_bulkstat_one_t dmb;
 
 	/* Returns negative errors to DMAPI */
@@ -1597,8 +1597,8 @@ xfs_dm_get_bulkattr_rvp(
 	}
 
 	dmb.laststruct = NULL;
-	memcpy(&dmb.fsid, vp->v_vfsp->vfs_altfsid, sizeof(dm_fsid_t));
-	error = xfs_bulkstat(xfs_vfstom(vp->v_vfsp), (xfs_ino_t *)&loc, &nelems,
+	memcpy(&dmb.fsid, XFS_MTOVFS(mp)->vfs_altfsid, sizeof(dm_fsid_t));
+	error = xfs_bulkstat(mp, (xfs_ino_t *)&loc, &nelems,
 				xfs_dm_bulkattr_one, (void*)&dmb,
 				statstruct_sz, bufp, BULKSTAT_FG_INLINE, &done);
 	if (error)
@@ -1925,9 +1925,8 @@ xfs_dm_get_dirattrs_rvp(
 	size_t		__user *rlenp,
 	int		*rvp)
 {
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-       xfs_inode_t	*dp = xfs_vtoi(vp);
-       xfs_mount_t	*mp = xfs_vfstom(vp->v_vfsp);
+	xfs_inode_t	*dp = XFS_I(inode);
+	xfs_mount_t	*mp = dp->i_mount;
 	dm_readdir_cb_t	*cb;
 	dm_attrloc_t	loc;
 	int		error;
@@ -3198,11 +3197,12 @@ xfs_dm_send_mmap_event(
 	if (!vma->vm_file)
 		return 0;
 
+	ip = XFS_I(vma->vm_file->f_dentry->d_inode);
 	vp = vn_from_inode(vma->vm_file->f_dentry->d_inode);
 	ASSERT(vp);
 
 	if (!S_ISREG(vma->vm_file->f_dentry->d_inode->i_mode) ||
-	    !(vp->v_vfsp->vfs_flag & VFS_DMI))
+	    !(XFS_MTOVFS(ip->i_mount)->vfs_flag & VFS_DMI))
 		return 0;
 
 	/* If they specifically asked for 'read', then give it to them.
@@ -3220,8 +3220,6 @@ xfs_dm_send_mmap_event(
 		return -EACCES;
 	}
 
-	ip = xfs_vtoi(vp);
-
 	/* Figure out how much of the file is being requested by the user. */
 	offset = 0; /* beginning of file, for now */
 	length = 0; /* whole file, for now */
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 19:03:03.000000000 +0200
@@ -89,20 +89,21 @@ xfs_dm_inode_to_fh(
 	dm_fid_t		*dmfid,
 	dm_fsid_t		*dmfsid)
 {
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-	int		error;
-	fid_t		fid;
+	xfs_inode_t		*ip = XFS_I(inode);
+	bhv_vfs_t		*vfsp = XFS_MTOVFS(ip->i_mount);
+	int			error;
+	fid_t			fid;
 
 	/* Returns negative errors to DMAPI */
 
-	if (vp->v_vfsp->vfs_altfsid == NULL)
+	if (vfsp->vfs_altfsid == NULL)
 		return -EINVAL;
-	error = xfs_fid2(XFS_I(inode), &fid);
+	error = xfs_fid2(ip, &fid);
 	if (error)
 		return -error; /* Return negative error to DMAPI */
 
 	memcpy(dmfid, &fid, sizeof(*dmfid));
-	memcpy(dmfsid, vp->v_vfsp->vfs_altfsid, sizeof(*dmfsid));
+	memcpy(dmfsid, vfsp->vfs_altfsid, sizeof(*dmfsid));
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 19:03:03.000000000 +0200
@@ -138,7 +138,8 @@ xfs_find_handle(
 	vp = vn_from_inode(inode);
 
 	/* now we can grab the fsid */
-	memcpy(&handle.ha_fsid, vp->v_vfsp->vfs_altfsid, sizeof(xfs_fsid_t));
+	memcpy(&handle.ha_fsid, XFS_MTOVFS(XFS_I(inode)->i_mount)->vfs_altfsid,
+			sizeof(xfs_fsid_t));
 	hsize = sizeof(xfs_fsid_t);
 
 	if (cmd != XFS_IOC_PATH_TO_FSHANDLE) {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 19:03:03.000000000 +0200
@@ -678,7 +678,7 @@ xfs_write(
 	io = &xip->i_iocore;
 	mp = io->io_mount;
 
-	vfs_wait_for_freeze(vp->v_vfsp, SB_FREEZE_WRITE);
+	vfs_wait_for_freeze(XFS_MTOVFS(mp), SB_FREEZE_WRITE);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 19:03:03.000000000 +0200
@@ -210,7 +210,6 @@ xfs_initialize_vnode(
 	struct inode		*inode = vn_to_inode(vp);
 
 	if (!ip->i_vnode) {
-		vp->v_vfsp = bhvtovfs(bdp);
 		ip->i_vnode = vp;
 		inode->i_private = ip;
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-23 19:03:03.000000000 +0200
@@ -69,8 +69,10 @@ vn_ioerror(
 	char		*f,
 	int		l)
 {
+	bhv_vfs_t	*vfsp = vfs_from_sb(vp->v_inode.i_sb);
+
 	if (unlikely(error == -ENODEV))
-		bhv_vfs_force_shutdown(vp->v_vfsp, SHUTDOWN_DEVICE_REQ, f, l);
+		bhv_vfs_force_shutdown(vfsp, SHUTDOWN_DEVICE_REQ, f, l);
 }
 
 bhv_vnode_t *
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 19:03:03.000000000 +0200
@@ -35,11 +35,10 @@ typedef enum bhv_vflags {
 
 /*
  * MP locking protocols:
- *	v_flag, v_vfsp				VN_LOCK/VN_UNLOCK
+ *	v_flag, 				VN_LOCK/VN_UNLOCK
  */
 typedef struct bhv_vnode {
 	bhv_vflags_t	v_flag;			/* vnode flags (see above) */
-	bhv_vfs_t	*v_vfsp;		/* ptr to containing VFS */
 	bhv_vnumber_t	v_number;		/* in-core vnode number */
 	spinlock_t	v_lock;			/* VN_LOCK/VN_UNLOCK */
 	atomic_t	v_iocount;		/* outstanding I/O count */
