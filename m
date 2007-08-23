Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:54 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJdk4p004768
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:51 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdiA5008703
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:44 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJditj008701
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:44 +0200
Date: Thu, 23 Aug 2007 21:39:44 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/17] decontaminate vfs operations from behavior details
Message-ID: <20070823193944.GM8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

All vfs ops now take struct xfs_mount pointers and the behaviour
related glue is split out into methods of it's own.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-08-13 18:07:59.000000000 +0200
@@ -78,6 +78,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_trans_item.o \
 				   xfs_utils.o \
 				   xfs_vfsops.o \
+				   xfs_vfsops_bhv.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:07:59.000000000 +0200
@@ -202,7 +202,7 @@ xfs_revalidate_inode(
 
 void
 xfs_initialize_vnode(
-	bhv_desc_t		*bdp,
+	struct xfs_mount	*mp,
 	bhv_vnode_t		*vp,
 	struct xfs_inode	*ip,
 	int			unlock)
@@ -222,7 +222,7 @@ xfs_initialize_vnode(
 	 * finish our work.
 	 */
 	if (ip->i_d.di_mode != 0 && unlock && (inode->i_state & I_NEW)) {
-		xfs_revalidate_inode(XFS_BHVTOM(bdp), vp, ip);
+		xfs_revalidate_inode(mp, vp, ip);
 		xfs_set_inodeops(inode);
 
 		xfs_iflags_clear(ip, XFS_INEW);
@@ -234,11 +234,11 @@ xfs_initialize_vnode(
 
 struct inode *
 xfs_get_inode(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	xfs_ino_t	ino,
 	int		flags)
 {
-	return iget_locked(bhvtovfs(bdp)->vfs_super, ino);
+	return iget_locked(XFS_MTOVFS(mp)->vfs_super, ino);
 }
 
 int
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2007-08-13 18:07:59.000000000 +0200
@@ -76,9 +76,6 @@ struct block_device;
 
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
-extern struct inode *xfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
-extern void xfs_initialize_vnode(bhv_desc_t *, bhv_vnode_t *, struct xfs_inode *, int);
-
 extern void xfs_flush_inode(struct xfs_inode *);
 extern void xfs_flush_device(struct xfs_inode *);
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-13 18:07:59.000000000 +0200
@@ -650,7 +650,6 @@ extern struct xfs_buf *xfs_getsb(xfs_mou
 extern int	xfs_readsb(xfs_mount_t *, int);
 extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
-extern void	xfs_do_force_shutdown(bhv_desc_t *, int, char *, int);
 extern int	xfs_syncsub(xfs_mount_t *, int, int *);
 extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
 extern xfs_agnumber_t	xfs_initialize_perag(struct bhv_vfs *, xfs_mount_t *,
Index: linux-2.6-xfs/fs/xfs/xfs_rw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rw.c	2007-08-13 17:59:06.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rw.c	2007-08-13 18:07:59.000000000 +0200
@@ -178,18 +178,15 @@ xfs_write_sync_logforce(
  * the shop, make sure that absolutely nothing persistent happens to
  * this filesystem after this point.
  */
-
 void
 xfs_do_force_shutdown(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	int		flags,
 	char		*fname,
 	int		lnnum)
 {
 	int		logerror;
-	xfs_mount_t	*mp;
 
-	mp = XFS_BHVTOM(bdp);
 	logerror = flags & SHUTDOWN_LOG_IO_ERROR;
 
 	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-13 18:07:59.000000000 +0200
@@ -55,10 +55,9 @@
 #include "xfs_filestream.h"
 #include "xfs_fsops.h"
 #include "xfs_vnodeops.h"
+#include "xfs_vfsops.h"
 
 
-STATIC int	xfs_sync(bhv_desc_t *, int, cred_t *);
-
 int
 xfs_init(void)
 {
@@ -433,15 +432,14 @@ xfs_finish_flags(
  * they are present.  The data subvolume has already been opened by
  * get_sb_bdev() and is stored in vfsp->vfs_super->s_bdev.
  */
-STATIC int
+int
 xfs_mount(
-	struct bhv_desc		*bhvp,
+	struct xfs_mount	*mp,
 	struct xfs_mount_args	*args,
 	cred_t			*credp)
 {
-	struct bhv_vfs		*vfsp = bhvtovfs(bhvp);
+	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
 	struct bhv_desc		*p;
-	struct xfs_mount	*mp = XFS_BHVTOM(bhvp);
 	struct block_device	*ddev, *logdev, *rtdev;
 	int			flags = 0, error;
 
@@ -578,14 +576,13 @@ error0:
 	return error;
 }
 
-STATIC int
+int
 xfs_unmount(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	int		flags,
 	cred_t		*credp)
 {
-	bhv_vfs_t	*vfsp = bhvtovfs(bdp);
-	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
+	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 	xfs_inode_t	*rip;
 	bhv_vnode_t	*rvp;
 	int		unmount_event_wanted = 0;
@@ -640,8 +637,7 @@ xfs_unmount(
 	 * referenced vnodes as well.
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
-		error = xfs_sync(&mp->m_bhv,
-			 (SYNC_WAIT | SYNC_CLOSE), credp);
+		error = xfs_sync(mp, SYNC_WAIT | SYNC_CLOSE);
 		ASSERT(error != EFSCORRUPTED);
 	}
 	xfs_unmountfs_needed = 1;
@@ -725,14 +721,13 @@ xfs_attr_quiesce(
 	xfs_unmountfs_writesb(mp);
 }
 
-STATIC int
+int
 xfs_mntupdate(
-	bhv_desc_t			*bdp,
+	struct xfs_mount		*mp,
 	int				*flags,
 	struct xfs_mount_args		*args)
 {
-	bhv_vfs_t	*vfsp = bhvtovfs(bdp);
-	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
+	struct bhv_vfs			*vfsp = XFS_MTOVFS(mp);
 
 	if (!(*flags & MS_RDONLY)) {			/* rw/ro -> rw */
 		if (vfsp->vfs_flag & VFS_RDONLY)
@@ -842,14 +837,14 @@ fscorrupt_out2:
  * vpp  -- address of the caller's vnode pointer which should be
  *         set to the desired fs root vnode
  */
-STATIC int
+int
 xfs_root(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	bhv_vnode_t	**vpp)
 {
 	bhv_vnode_t	*vp;
 
-	vp = XFS_ITOV((XFS_BHVTOM(bdp))->m_rootip);
+	vp = XFS_ITOV(mp->m_rootip);
 	VN_HOLD(vp);
 	*vpp = vp;
 	return 0;
@@ -862,19 +857,17 @@ xfs_root(
  * the superblock lock in the mount structure to ensure a consistent
  * snapshot of the counters returned.
  */
-STATIC int
+int
 xfs_statvfs(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	bhv_statvfs_t	*statp,
 	bhv_vnode_t	*vp)
 {
 	__uint64_t	fakeinos;
 	xfs_extlen_t	lsize;
-	xfs_mount_t	*mp;
 	xfs_sb_t	*sbp;
 	unsigned long	s;
 
-	mp = XFS_BHVTOM(bdp);
 	sbp = &(mp->m_sb);
 
 	statp->f_type = XFS_SB_MAGIC;
@@ -953,14 +946,11 @@ xfs_statvfs(
  *		       filesystem.
  *
  */
-/*ARGSUSED*/
-STATIC int
+int
 xfs_sync(
-	bhv_desc_t	*bdp,
-	int		flags,
-	cred_t		*credp)
+	xfs_mount_t	*mp,
+	int		flags)
 {
-	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 	int		error;
 
 	/*
@@ -1647,13 +1637,12 @@ xfs_syncsub(
 /*
  * xfs_vget - called by DMAPI and NFSD to get vnode from file handle
  */
-STATIC int
+int
 xfs_vget(
-	bhv_desc_t	*bdp,
+	xfs_mount_t	*mp,
 	bhv_vnode_t	**vpp,
 	fid_t		*fidp)
 {
-	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
 	xfs_fid_t	*xfid = (struct xfs_fid *)fidp;
 	xfs_inode_t	*ip;
 	int		error;
@@ -1770,14 +1759,14 @@ suffix_strtoul(char *s, char **endp, uns
 	return simple_strtoul((const char *)s, endp, base) << shift_left_factor;
 }
 
-STATIC int
+int
 xfs_parseargs(
-	struct bhv_desc		*bhv,
+	struct xfs_mount	*mp,
 	char			*options,
 	struct xfs_mount_args	*args,
 	int			update)
 {
-	bhv_vfs_t		*vfsp = bhvtovfs(bhv);
+	bhv_vfs_t		*vfsp = XFS_MTOVFS(mp);
 	char			*this_char, *value, *eov;
 	int			dsunit, dswidth, vol_dsunit, vol_dswidth;
 	int			iosize;
@@ -2028,9 +2017,9 @@ done:
 	return 0;
 }
 
-STATIC int
+int
 xfs_showargs(
-	struct bhv_desc		*bhv,
+	struct xfs_mount	*mp,
 	struct seq_file		*m)
 {
 	static struct proc_xfs_info {
@@ -2048,7 +2037,6 @@ xfs_showargs(
 		{ 0, NULL }
 	};
 	struct proc_xfs_info	*xfs_infop;
-	struct xfs_mount	*mp = XFS_BHVTOM(bhv);
 	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
 
 	for (xfs_infop = xfs_info; xfs_infop->flag; xfs_infop++) {
@@ -2121,30 +2109,10 @@ xfs_showargs(
  * need to take care of themetadata. Once that's done write a dummy
  * record to dirty the log in case of a crash while frozen.
  */
-STATIC void
+void
 xfs_freeze(
-	bhv_desc_t	*bdp)
+	xfs_mount_t	*mp)
 {
-	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
-
 	xfs_attr_quiesce(mp);
 	xfs_fs_log_dummy(mp);
 }
-
-
-bhv_vfsops_t xfs_vfsops = {
-	BHV_IDENTITY_INIT(VFS_BHV_XFS,VFS_POSITION_XFS),
-	.vfs_parseargs		= xfs_parseargs,
-	.vfs_showargs		= xfs_showargs,
-	.vfs_mount		= xfs_mount,
-	.vfs_unmount		= xfs_unmount,
-	.vfs_mntupdate		= xfs_mntupdate,
-	.vfs_root		= xfs_root,
-	.vfs_statvfs		= xfs_statvfs,
-	.vfs_sync		= xfs_sync,
-	.vfs_vget		= xfs_vget,
-	.vfs_get_inode		= xfs_get_inode,
-	.vfs_init_vnode		= xfs_initialize_vnode,
-	.vfs_force_shutdown	= xfs_do_force_shutdown,
-	.vfs_freeze		= xfs_freeze,
-};
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-08-13 18:07:59.000000000 +0200
@@ -0,0 +1,31 @@
+#ifndef _XFS_VFSOPS_H
+#define _XFS_VFSOPS_H 1
+
+struct cred;
+struct fid;
+struct inode;
+struct kstatfs;
+struct xfs_mount;
+struct xfs_mount_args;
+
+int xfs_mount(struct xfs_mount *mp, struct xfs_mount_args *args,
+		struct cred *credp);
+int xfs_unmount(struct xfs_mount *mp, int flags, struct cred *credp);
+int xfs_mntupdate(struct xfs_mount *mp, int *flags,
+		struct xfs_mount_args *args);
+int xfs_root(struct xfs_mount *mp, bhv_vnode_t **vpp);
+int xfs_statvfs(struct xfs_mount *mp, struct kstatfs *statp,
+		bhv_vnode_t *vp);
+int xfs_sync(struct xfs_mount *mp, int flags);
+int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct fid *fidp);
+int xfs_parseargs(struct xfs_mount *mp, char *options,
+		struct xfs_mount_args *args, int update);
+int xfs_showargs(struct xfs_mount *mp, struct seq_file *m);
+void xfs_freeze(struct xfs_mount *mp);
+void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
+		int lnnum);
+struct inode *xfs_get_inode(struct xfs_mount *mp, xfs_ino_t ino, int flags);
+void xfs_initialize_vnode(struct xfs_mount *mp, bhv_vnode_t *vp,
+		struct xfs_inode *ip, int unlock);
+
+#endif /* _XFS_VFSOPS_H */
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops_bhv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops_bhv.c	2007-08-13 18:07:59.000000000 +0200
@@ -0,0 +1,143 @@
+
+#include "xfs_linux.h"
+#include "xfs_vfsops.h"
+
+#include "xfs_dmapi.h"
+#include "xfs_sb.h"
+#include "xfs_log.h"
+#include "xfs_trans.h"
+#include "xfs_mount.h"
+
+
+STATIC int
+xfs_bhv_mount(
+	struct bhv_desc		*bhvp,
+	struct xfs_mount_args	*args,
+	cred_t			*credp)
+{
+	return xfs_mount(XFS_BHVTOM(bhvp), args, credp);
+}
+
+STATIC int
+xfs_bhv_unmount(
+	bhv_desc_t	*bdp,
+	int		flags,
+	cred_t		*credp)
+{
+	return xfs_unmount(XFS_BHVTOM(bdp), flags, credp);
+}
+
+STATIC int
+xfs_bhv_mntupdate(
+	bhv_desc_t			*bdp,
+	int				*flags,
+	struct xfs_mount_args		*args)
+{
+	return xfs_mntupdate(XFS_BHVTOM(bdp), flags, args);
+}
+
+STATIC int
+xfs_bhv_root(
+	bhv_desc_t	*bdp,
+	bhv_vnode_t	**vpp)
+{
+	return xfs_root(XFS_BHVTOM(bdp), vpp);
+}
+
+STATIC int
+xfs_bhv_statvfs(
+	bhv_desc_t	*bdp,
+	bhv_statvfs_t	*statp,
+	bhv_vnode_t	*vp)
+{
+	return xfs_statvfs(XFS_BHVTOM(bdp), statp, vp);
+}
+
+STATIC int
+xfs_bhv_sync(
+	bhv_desc_t	*bdp,
+	int		flags,
+	cred_t		*credp)
+{
+	return xfs_sync(XFS_BHVTOM(bdp), flags);
+}
+
+STATIC int
+xfs_bhv_vget(
+	bhv_desc_t	*bdp,
+	bhv_vnode_t	**vpp,
+	fid_t		*fidp)
+{
+	return xfs_vget(XFS_BHVTOM(bdp), vpp, fidp);
+}
+
+STATIC int
+xfs_bhv_parseargs(
+	struct bhv_desc		*bhv,
+	char			*options,
+	struct xfs_mount_args	*args,
+	int			update)
+{
+	return xfs_parseargs(XFS_BHVTOM(bhv), options, args, update);
+}
+
+STATIC int
+xfs_bhv_showargs(
+	struct bhv_desc		*bhv,
+	struct seq_file		*m)
+{
+	return xfs_showargs(XFS_BHVTOM(bhv), m);
+}
+
+STATIC void
+xfs_bhv_freeze(
+	bhv_desc_t	*bdp)
+{
+	return xfs_freeze(XFS_BHVTOM(bdp));
+}
+
+STATIC void
+xfs_bhv_force_shutdown(
+	bhv_desc_t	*bdp,
+	int		flags,
+	char		*fname,
+	int		lnnum)
+{
+	return xfs_do_force_shutdown(XFS_BHVTOM(bdp), flags, fname, lnnum);
+}
+
+STATIC struct inode *
+xfs_bhv_get_inode(
+	bhv_desc_t	*bdp,
+	xfs_ino_t	ino,
+	int		flags)
+{
+	return xfs_get_inode(XFS_BHVTOM(bdp), ino, flags);
+}
+
+STATIC void
+xfs_bhv_initialize_vnode(
+	bhv_desc_t		*bdp,
+	bhv_vnode_t		*vp,
+	struct xfs_inode	*ip,
+	int			unlock)
+{
+	return xfs_initialize_vnode(XFS_BHVTOM(bdp), vp, ip, unlock);
+}
+
+bhv_vfsops_t xfs_vfsops = {
+	BHV_IDENTITY_INIT(VFS_BHV_XFS,VFS_POSITION_XFS),
+	.vfs_parseargs		= xfs_bhv_parseargs,
+	.vfs_showargs		= xfs_bhv_showargs,
+	.vfs_mount		= xfs_bhv_mount,
+	.vfs_unmount		= xfs_bhv_unmount,
+	.vfs_mntupdate		= xfs_bhv_mntupdate,
+	.vfs_root		= xfs_bhv_root,
+	.vfs_statvfs		= xfs_bhv_statvfs,
+	.vfs_sync		= xfs_bhv_sync,
+	.vfs_vget		= xfs_bhv_vget,
+	.vfs_get_inode		= xfs_bhv_get_inode,
+	.vfs_init_vnode		= xfs_bhv_initialize_vnode,
+	.vfs_force_shutdown	= xfs_bhv_force_shutdown,
+	.vfs_freeze		= xfs_bhv_freeze,
+};
