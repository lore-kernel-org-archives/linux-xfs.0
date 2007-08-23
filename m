Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:40:15 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJe94p005335
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:40:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJe7A5008761
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:40:07 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJe7up008759
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:40:07 +0200
Date: Thu, 23 Aug 2007 21:40:07 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 15/17] kill the vfs_flags member in struct bhv_vfs
Message-ID: <20070823194006.GP8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

All flags are added to xfs_mount's m_flag instead.  Note that the 32bit
inode flag was duplicated in both of them, but only cleared in the
mount when it was not nessecary due to the filesystem beeing small enough.
Thus this patch introduces a slight behavior change in that the 32bit
inodes option is only present in the /proc/<pid>/mounts output if
actually nessecary but not if it was on the command line but isn't
actually in effect.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:57:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:57:56.000000000 +0200
@@ -3199,7 +3199,7 @@ xfs_dm_send_mmap_event(
 	ASSERT(vp);
 
 	if (!S_ISREG(vma->vm_file->f_dentry->d_inode->i_mode) ||
-	    !(XFS_MTOVFS(ip->i_mount)->vfs_flag & VFS_DMI))
+	    !(ip->i_mount->m_flags & XFS_MOUNT_DMAPI))
 		return 0;
 
 	/* If they specifically asked for 'read', then give it to them.
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 14:44:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2007-08-23 14:57:56.000000000 +0200
@@ -234,10 +234,10 @@ xfs_vm_nopage(
 	int			*type)
 {
 	struct inode	*inode = area->vm_file->f_path.dentry->d_inode;
-	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
+	struct xfs_mount *mp = XFS_M(inode->i_sb);
 
-	ASSERT_ALWAYS(vfsp->vfs_flag & VFS_DMI);
-	if (XFS_SEND_MMAP(XFS_VFSTOM(vfsp), area, 0))
+	ASSERT_ALWAYS(mp->m_flags & XFS_MOUNT_DMAPI);
+	if (XFS_SEND_MMAP(mp, area, 0))
 		return NULL;
 	return filemap_nopage(area, address, type);
 }
@@ -282,7 +282,7 @@ xfs_file_mmap(
 	vma->vm_ops = &xfs_file_vm_ops;
 
 #ifdef HAVE_DMAPI
-	if (vfs_from_sb(filp->f_path.dentry->d_inode->i_sb)->vfs_flag & VFS_DMI)
+	if (XFS_M(filp->f_path.dentry->d_inode->i_sb)->m_flags & XFS_MOUNT_DMAPI)
 		vma->vm_ops = &xfs_dmapi_file_vm_ops;
 #endif /* HAVE_DMAPI */
 
@@ -340,13 +340,13 @@ xfs_vm_mprotect(
 	unsigned int	newflags)
 {
 	struct inode	*inode = vma->vm_file->f_path.dentry->d_inode;
-	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
+	struct xfs_mount *mp = XFS_M(inode->i_sb);
 	int		error = 0;
 
-	if (vfsp->vfs_flag & VFS_DMI) {
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		if ((vma->vm_flags & VM_MAYSHARE) &&
 		    (newflags & VM_WRITE) && !(vma->vm_flags & VM_WRITE))
-			error = XFS_SEND_MMAP(XFS_VFSTOM(vfsp), vma, VM_WRITE);
+			error = XFS_SEND_MMAP(mp, vma, VM_WRITE);
 	}
 	return error;
 }
@@ -363,13 +363,13 @@ STATIC int
 xfs_file_open_exec(
 	struct inode	*inode)
 {
-	bhv_vfs_t	*vfsp = vfs_from_sb(inode->i_sb);
+	struct xfs_mount *mp = XFS_M(inode->i_sb);
 
-	if (unlikely(vfsp->vfs_flag & VFS_DMI)) {
+	if (unlikely(mp->m_flags & XFS_MOUNT_DMAPI)) {
 		if (DM_EVENT_ENABLED(XFS_I(inode), DM_EVENT_READ)) {
 			bhv_vnode_t *vp = vn_from_inode(inode);
 
-			return -XFS_SEND_DATA(XFS_VFSTOM(vfsp), DM_EVENT_READ,
+			return -XFS_SEND_DATA(mp, DM_EVENT_READ,
 						vp, 0, 0, 0, NULL);
 		}
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:57:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:57:56.000000000 +0200
@@ -43,7 +43,6 @@ typedef struct bhv_vfs_sync_work {
 
 typedef struct bhv_vfs {
 	struct xfs_mount	*vfs_mount;
-	u_int			vfs_flag;	/* flags */
 	struct super_block	*vfs_super;	/* generic superblock pointer */
 	struct task_struct	*vfs_sync_task;	/* generalised sync thread */
 	bhv_vfs_sync_work_t	vfs_sync_work;	/* work item for VFS_SYNC */
@@ -53,13 +52,6 @@ typedef struct bhv_vfs {
 	wait_queue_head_t	vfs_wait_single_sync_task;
 } bhv_vfs_t;
 
-#define VFS_RDONLY		0x0001	/* read-only vfs */
-#define VFS_GRPID		0x0002	/* group-ID assigned from directory */
-#define VFS_DMI			0x0004	/* filesystem has the DMI enabled */
-/* ---- VFS_UMOUNT ----		0x0008	-- unneeded, fixed via kthread APIs */
-#define VFS_32BITINODES		0x0010	/* do not use inums above 32 bits */
-#define VFS_END			0x0010	/* max flag */
-
 #define SYNC_ATTR		0x0001	/* sync attributes */
 #define SYNC_CLOSE		0x0002	/* close file system down */
 #define SYNC_DELWRI		0x0004	/* look at delayed writes */
Index: linux-2.6-xfs/fs/xfs/xfs_dmapi.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dmapi.h	2007-08-23 14:54:07.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dmapi.h	2007-08-23 14:57:56.000000000 +0200
@@ -69,7 +69,7 @@ typedef enum {
 /* Defines for determining if an event message should be sent. */
 #ifdef HAVE_DMAPI
 #define	DM_EVENT_ENABLED(ip, event) ( \
-	unlikely (XFS_MTOVFS((ip)->i_mount)->vfs_flag & VFS_DMI) && \
+	unlikely ((ip)->i_mount->m_flags & XFS_MOUNT_DMAPI) && \
 		( ((ip)->i_d.di_dmevmask & (1 << event)) || \
 		  ((ip)->i_mount->m_dmevmask & (1 << event)) ) \
 	)
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-23 14:57:56.000000000 +0200
@@ -442,7 +442,7 @@ typedef struct xfs_mount {
 						   must be synchronous except
 						   for space allocations */
 #define XFS_MOUNT_INO64		(1ULL << 1)
-			     /* (1ULL << 2)	-- currently unused */
+#define XFS_MOUNT_DMAPI		(1ULL << 2)	/* dmapi is enabled */
 #define XFS_MOUNT_WAS_CLEAN	(1ULL << 3)
 #define XFS_MOUNT_FS_SHUTDOWN	(1ULL << 4)	/* atomic stop of all filesystem
 						   operations, typically for
@@ -452,7 +452,7 @@ typedef struct xfs_mount {
 #define XFS_MOUNT_NOALIGN	(1ULL << 7)	/* turn off stripe alignment
 						   allocations */
 #define XFS_MOUNT_ATTR2		(1ULL << 8)	/* allow use of attr2 format */
-			     /*	(1ULL << 9)	-- currently unused */
+#define XFS_MOUNT_GRPID		(1ULL << 9)	/* group-ID assigned from directory */
 #define XFS_MOUNT_NORECOVERY	(1ULL << 10)	/* no recovery - dirty fs */
 #define XFS_MOUNT_SHARED	(1ULL << 11)	/* shared mount */
 #define XFS_MOUNT_DFLT_IOSIZE	(1ULL << 12)	/* set default i/o size */
@@ -460,7 +460,7 @@ typedef struct xfs_mount {
 						/* osyncisdsync is now default*/
 #define XFS_MOUNT_32BITINODES	(1ULL << 14)	/* do not create inodes above
 						 * 32 bits in size */
-			     /* (1ULL << 15)	-- currently unused */
+#define XFS_MOUNT_RDONLY	(1ULL << 15)	/* read-only vfs */
 #define XFS_MOUNT_NOUUID	(1ULL << 16)	/* ignore uuid during mount */
 #define XFS_MOUNT_BARRIER	(1ULL << 17)
 #define XFS_MOUNT_IDELETE	(1ULL << 18)	/* delete empty inode clusters*/
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 14:58:23.000000000 +0200
@@ -307,7 +307,7 @@ xfs_start_flags(
 	 * no recovery flag requires a read-only mount
 	 */
 	if (ap->flags & XFSMNT_NORECOVERY) {
-		if (!(vfs->vfs_flag & VFS_RDONLY)) {
+		if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 			cmn_err(CE_WARN,
 	"XFS: tried to mount a FS read-write without recovery!");
 			return XFS_ERROR(EINVAL);
@@ -326,7 +326,7 @@ xfs_start_flags(
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 
 	if (ap->flags & XFSMNT_DMAPI)
-		vfs->vfs_flag |= VFS_DMI;
+		mp->m_flags |= XFS_MOUNT_DMAPI;
 	return 0;
 }
 
@@ -340,7 +340,7 @@ xfs_finish_flags(
 	struct xfs_mount_args	*ap,
 	struct xfs_mount	*mp)
 {
-	int			ronly = (vfs->vfs_flag & VFS_RDONLY);
+	int			ronly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 	/* Fail a mount where the logbuf is smaller then the log stripe */
 	if (XFS_SB_VERSION_HASLOGV2(&mp->m_sb)) {
@@ -589,7 +589,7 @@ xfs_unmount(
 	rvp = XFS_ITOV(rip);
 
 #ifdef HAVE_DMAPI
-	if (vfsp->vfs_flag & VFS_DMI) {
+	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		error = XFS_SEND_PREUNMOUNT(mp, vfsp,
 				rvp, DM_RIGHT_NULL, rvp, DM_RIGHT_NULL,
 				NULL, NULL, 0, 0,
@@ -723,22 +723,20 @@ xfs_mntupdate(
 	int				*flags,
 	struct xfs_mount_args		*args)
 {
-	struct bhv_vfs			*vfsp = XFS_MTOVFS(mp);
-
 	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
-		if (vfsp->vfs_flag & VFS_RDONLY)
-			vfsp->vfs_flag &= ~VFS_RDONLY;
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
+			mp->m_flags &= ~XFS_MOUNT_RDONLY;
 		if (args->flags & XFSMNT_BARRIER) {
 			mp->m_flags |= XFS_MOUNT_BARRIER;
 			xfs_mountfs_check_barriers(mp);
 		} else {
 			mp->m_flags &= ~XFS_MOUNT_BARRIER;
 		}
-	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
+	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {	/* rw -> ro */
 		xfs_filestream_flush(mp);
 		xfs_sync(mp, SYNC_DATA_QUIESCE);
 		xfs_attr_quiesce(mp);
-		vfsp->vfs_flag |= VFS_RDONLY;
+		mp->m_flags |= XFS_MOUNT_RDONLY;
 	}
 	return 0;
 }
@@ -1049,7 +1047,7 @@ xfs_sync_inodes(
 
 	if (bypassed)
 		*bypassed = 0;
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 	error = 0;
 	last_error = 0;
@@ -1762,7 +1760,6 @@ xfs_parseargs(
 	struct xfs_mount_args	*args,
 	int			update)
 {
-	bhv_vfs_t		*vfsp = XFS_MTOVFS(mp);
 	char			*this_char, *value, *eov;
 	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
 	int			iosize;
@@ -1844,10 +1841,10 @@ xfs_parseargs(
 			args->iosizelog = ffs(iosize) - 1;
 		} else if (!strcmp(this_char, MNTOPT_GRPID) ||
 			   !strcmp(this_char, MNTOPT_BSDGROUPS)) {
-			vfsp->vfs_flag |= VFS_GRPID;
+			mp->m_flags |= XFS_MOUNT_GRPID;
 		} else if (!strcmp(this_char, MNTOPT_NOGRPID) ||
 			   !strcmp(this_char, MNTOPT_SYSVGROUPS)) {
-			vfsp->vfs_flag &= ~VFS_GRPID;
+			mp->m_flags &= ~XFS_MOUNT_GRPID;
 		} else if (!strcmp(this_char, MNTOPT_WSYNC)) {
 			args->flags |= XFSMNT_WSYNC;
 		} else if (!strcmp(this_char, MNTOPT_OSYNCISOSYNC)) {
@@ -1954,7 +1951,7 @@ xfs_parseargs(
 	}
 
 	if (args->flags & XFSMNT_NORECOVERY) {
-		if ((vfsp->vfs_flag & VFS_RDONLY) == 0) {
+		if ((mp->m_flags & XFS_MOUNT_RDONLY) == 0) {
 			cmn_err(CE_WARN,
 				"XFS: no-recovery mounts must be read-only.");
 			return EINVAL;
@@ -2006,8 +2003,6 @@ xfs_parseargs(
 	}
 
 done:
-	if (args->flags & XFSMNT_32BITINODES)
-		vfsp->vfs_flag |= VFS_32BITINODES;
 	if (args->flags2)
 		args->flags |= XFSMNT_FLAGS2;
 	return 0;
@@ -2033,7 +2028,6 @@ xfs_showargs(
 		{ 0, NULL }
 	};
 	struct proc_xfs_info	*xfs_infop;
-	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
 
 	for (xfs_infop = xfs_info; xfs_infop->flag; xfs_infop++) {
 		if (mp->m_flags & xfs_infop->flag)
@@ -2066,9 +2060,9 @@ xfs_showargs(
 	if (!(mp->m_flags & XFS_MOUNT_COMPAT_IOSIZE))
 		seq_printf(m, "," MNTOPT_LARGEIO);
 
-	if (!(vfsp->vfs_flag & VFS_32BITINODES))
+	if (!(mp->m_flags & XFS_MOUNT_32BITINODES))
 		seq_printf(m, "," MNTOPT_64BITINODE);
-	if (vfsp->vfs_flag & VFS_GRPID)
+	if (mp->m_flags & XFS_MOUNT_GRPID)
 		seq_printf(m, "," MNTOPT_GRPID);
 
 	if (mp->m_qflags & XFS_UQUOTA_ACCT) {
@@ -2095,7 +2089,7 @@ xfs_showargs(
 	if (!(mp->m_qflags & XFS_ALL_QUOTA_ACCT))
 		seq_puts(m, "," MNTOPT_NOQUOTA);
 
-	if (vfsp->vfs_flag & VFS_DMI)
+	if (mp->m_flags & XFS_MOUNT_DMAPI)
 		seq_puts(m, "," MNTOPT_DMAPI);
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2007-08-23 14:57:56.000000000 +0200
@@ -102,9 +102,7 @@ xfs_fs_encode_fh(
 	int			len;
 	int			is64 = 0;
 #if XFS_BIG_INUMS
-	bhv_vfs_t		*vfs = vfs_from_sb(inode->i_sb);
-
-	if (!(vfs->vfs_flag & VFS_32BITINODES)) {
+	if (!(XFS_M(inode->i_sb)->m_flags & XFS_MOUNT_32BITINODES)) {
 		/* filesystem may contain 64bit inode numbers */
 		is64 = XFS_FILEID_TYPE_64FLAG;
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:57:56.000000000 +0200
@@ -532,7 +532,7 @@ vfs_sync_worker(
 {
 	int		error;
 
-	if (!(vfsp->vfs_flag & VFS_RDONLY))
+	if (!(XFS_VFSTOM(vfsp)->m_flags & XFS_MOUNT_RDONLY))
 		error = xfs_sync(XFS_VFSTOM(vfsp), SYNC_FSDATA | SYNC_BDFLUSH | \
 					SYNC_ATTR | SYNC_REFCACHE | SYNC_SUPER);
 	vfsp->vfs_sync_seq++;
@@ -790,6 +790,9 @@ xfs_fs_fill_super(
 	mp->m_vfsp = vfsp;
 	vfsp->vfs_mount = mp;
 
+	if (sb->s_flags & MS_RDONLY)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+
 	error = xfs_parseargs(mp, (char *)data, args, 0);
 	if (error)
 		goto fail_vfsop;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 14:57:56.000000000 +0200
@@ -44,9 +44,6 @@ vfs_allocate(
 	vfsp->vfs_super = sb;
 	sb->s_fs_info = vfsp;
 
-	if (sb->s_flags & MS_RDONLY)
-		vfsp->vfs_flag |= VFS_RDONLY;
-
 	return vfsp;
 }
 
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm.c	2007-08-23 14:57:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm.c	2007-08-23 14:57:56.000000000 +0200
@@ -2413,8 +2413,7 @@ xfs_qm_vop_dqalloc(
 	lockflags = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lockflags);
 
-	if ((flags & XFS_QMOPT_INHERIT) &&
-	    XFS_INHERIT_GID(ip, XFS_MTOVFS(mp)))
+	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
 		gid = ip->i_d.di_gid;
 
 	/*
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2007-08-23 14:57:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2007-08-23 14:57:56.000000000 +0200
@@ -86,10 +86,8 @@ xfs_qm_quotactl(
 	int		id,
 	xfs_caddr_t	addr)
 {
-	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 	int		error;
 
-
 	ASSERT(addr != NULL || cmd == Q_XQUOTASYNC);
 
 	/*
@@ -102,7 +100,7 @@ xfs_qm_quotactl(
 		 */
 		if (XFS_IS_QUOTA_ON(mp))
 			return XFS_ERROR(EINVAL);
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		return (xfs_qm_scall_trunc_qfiles(mp,
 			       xfs_qm_import_qtype_flags(*(uint *)addr)));
@@ -118,13 +116,13 @@ xfs_qm_quotactl(
 		 * QUOTAON - enabling quota enforcement.
 		 * Quota accounting must be turned on at mount time.
 		 */
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		return (xfs_qm_scall_quotaon(mp,
 					  xfs_qm_import_flags(*(uint *)addr)));
 
 	case Q_XQUOTAOFF:
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		break;
 
@@ -140,7 +138,7 @@ xfs_qm_quotactl(
 
 	switch (cmd) {
 	case Q_XQUOTAOFF:
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		error = xfs_qm_scall_quotaoff(mp,
 					    xfs_qm_import_flags(*(uint *)addr),
@@ -161,19 +159,19 @@ xfs_qm_quotactl(
 		break;
 
 	case Q_XSETQLIM:
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_USER,
 					     (fs_disk_quota_t *)addr);
 		break;
 	case Q_XSETGQLIM:
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_GROUP,
 					     (fs_disk_quota_t *)addr);
 		break;
 	case Q_XSETPQLIM:
-		if (vfsp->vfs_flag & VFS_RDONLY)
+		if (mp->m_flags & XFS_MOUNT_RDONLY)
 			return XFS_ERROR(EROFS);
 		error = xfs_qm_scall_setqlim(mp, (xfs_dqid_t)id, XFS_DQ_PROJ,
 					     (fs_disk_quota_t *)addr);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-23 14:57:56.000000000 +0200
@@ -1158,7 +1158,7 @@ xfs_ialloc(
 	if ((prid != 0) && (ip->i_d.di_version == XFS_DINODE_VERSION_1))
 		xfs_bump_ino_vers2(tp, ip);
 
-	if (pip && XFS_INHERIT_GID(pip, XFS_MTOVFS(pip->i_mount))) {
+	if (pip && XFS_INHERIT_GID(pip)) {
 		ip->i_d.di_gid = pip->i_d.di_gid;
 		if ((pip->i_d.di_mode & S_ISGID) && (mode & S_IFMT) == S_IFDIR) {
 			ip->i_d.di_mode |= S_ISGID;
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-23 14:54:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-23 14:57:56.000000000 +0200
@@ -480,8 +480,9 @@ xfs_iflags_test(xfs_inode_t *ip, unsigne
  * directory, group of new file is set to that of the parent, and
  * new subdirectory gets S_ISGID bit from parent.
  */
-#define XFS_INHERIT_GID(pip, vfsp)	\
-	(((vfsp)->vfs_flag & VFS_GRPID) || ((pip)->i_d.di_mode & S_ISGID))
+#define XFS_INHERIT_GID(pip)	\
+	(((pip)->i_mount->m_flags & XFS_MOUNT_GRPID) || \
+	 ((pip)->i_d.di_mode & S_ISGID))
 
 /*
  * Flags for xfs_iget()
Index: linux-2.6-xfs/fs/xfs/xfs_log.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_log.c	2007-08-23 14:39:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_log.c	2007-08-23 14:57:56.000000000 +0200
@@ -509,7 +509,7 @@ xfs_log_mount(xfs_mount_t	*mp,
 		cmn_err(CE_NOTE,
 			"!Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will be inconsistent.",
 			mp->m_fsname);
-		ASSERT(XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY);
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
 	mp->m_log = xlog_alloc_log(mp, log_target, blk_offset, num_bblks);
@@ -519,16 +519,15 @@ xfs_log_mount(xfs_mount_t	*mp,
 	 * just worked.
 	 */
 	if (!(mp->m_flags & XFS_MOUNT_NORECOVERY)) {
-		bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
-		int		error, readonly = (vfsp->vfs_flag & VFS_RDONLY);
+		int		error, readonly = (mp->m_flags & XFS_MOUNT_RDONLY);
 
 		if (readonly)
-			vfsp->vfs_flag &= ~VFS_RDONLY;
+			mp->m_flags &= ~XFS_MOUNT_RDONLY;
 
 		error = xlog_recover(mp->m_log);
 
 		if (readonly)
-			vfsp->vfs_flag |= VFS_RDONLY;
+			mp->m_flags |= XFS_MOUNT_RDONLY;
 		if (error) {
 			cmn_err(CE_WARN, "XFS: log mount/recovery failed: error %d", error);
 			xlog_dealloc_log(mp->m_log);
@@ -560,7 +559,7 @@ xfs_log_mount_finish(xfs_mount_t *mp, in
 		error = xlog_recover_finish(mp->m_log, mfsi_flags);
 	else {
 		error = 0;
-		ASSERT(XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY);
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
 
 	return error;
@@ -620,7 +619,7 @@ xfs_log_unmount_write(xfs_mount_t *mp)
 	 * Don't write out unmount record on read-only mounts.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 
 	xfs_log_force(mp, 0, XFS_LOG_FORCE|XFS_LOG_SYNC);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-23 14:57:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-23 14:57:56.000000000 +0200
@@ -348,11 +348,8 @@ xfs_initialize_perag(
 	/* Clear the mount flag if no inode can overflow 32 bits
 	 * on this filesystem, or if specifically requested..
 	 */
-	if ((vfs->vfs_flag & VFS_32BITINODES) && ino > max_inum) {
-		mp->m_flags |= XFS_MOUNT_32BITINODES;
-	} else {
+	if (!((mp->m_flags & XFS_MOUNT_32BITINODES) && ino > max_inum))
 		mp->m_flags &= ~XFS_MOUNT_32BITINODES;
-	}
 
 	/* If we can overflow then setup the ag headers accordingly */
 	if (mp->m_flags & XFS_MOUNT_32BITINODES) {
@@ -1113,7 +1110,7 @@ xfs_mountfs(
 	 * If fs is not mounted readonly, then update the superblock
 	 * unit and width changes.
 	 */
-	if (update_flags && !(vfsp->vfs_flag & VFS_RDONLY))
+	if (update_flags && !(mp->m_flags & XFS_MOUNT_RDONLY))
 		xfs_mount_log_sbunit(mp, update_flags);
 
 	/*
@@ -1286,7 +1283,7 @@ xfs_fs_writable(xfs_mount_t *mp)
 	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 
 	return !(vfs_test_for_freeze(vfsp) || XFS_FORCED_SHUTDOWN(mp) ||
-		(vfsp->vfs_flag & VFS_RDONLY));
+		(mp->m_flags & XFS_MOUNT_RDONLY));
 }
 
 /*
@@ -1364,7 +1361,7 @@ xfs_unmountfs_writesb(xfs_mount_t *mp)
 	 * skip superblock write if fs is read-only, or
 	 * if we are doing a forced umount.
 	 */
-	if (!(XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY ||
+	if (!((mp->m_flags & XFS_MOUNT_RDONLY) ||
 		XFS_FORCED_SHUTDOWN(mp))) {
 
 		sbp = xfs_getsb(mp, 0);
Index: linux-2.6-xfs/fs/xfs/xfs_qmops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_qmops.c	2007-08-23 14:57:38.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_qmops.c	2007-08-23 14:57:56.000000000 +0200
@@ -66,7 +66,7 @@ xfs_mount_reset_sbqflags(xfs_mount_t *mp
 	 * if the fs is readonly, let the incore superblock run
 	 * with quotas off but don't flush the update out to disk
 	 */
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 #ifdef QUOTADEBUG
 	xfs_fs_cmn_err(CE_NOTE, mp, "Writing superblock quota changes");
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 14:54:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 14:57:56.000000000 +0200
@@ -230,7 +230,7 @@ xfs_setattr(
 
 	vn_trace_entry(ip, __FUNCTION__, (inst_t *)__return_address);
 
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return XFS_ERROR(EROFS);
 
 	/*
@@ -1512,7 +1512,7 @@ xfs_release(
 		return 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return 0;
 
 	if (!XFS_FORCED_SHUTDOWN(mp)) {
@@ -1626,7 +1626,7 @@ xfs_inactive(
 	error = 0;
 
 	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (XFS_MTOVFS(mp)->vfs_flag & VFS_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		goto out;
 
 	if (ip->i_d.di_nlink != 0) {
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 14:57:56.000000000 +0200
@@ -1788,7 +1788,6 @@ static void
 print_vfs(bhv_vfs_t *vfs, unsigned long addr)
 {
 	kdb_printf("vfsp at 0x%lx", addr);
-	kdb_printf(" vfs_flag 0x%x\n", vfs->vfs_flag);
 	kdb_printf(" vfs_super 0x%p", vfs->vfs_super);
 }
 
