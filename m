Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:40:04 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJdt4p005008
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:57 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdpA5008723
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:51 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJdp6O008721
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:51 +0200
Date: Thu, 23 Aug 2007 21:39:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/17] call common xfs vnode-level helpers directly and remove vnode operations
Message-ID: <20070823193951.GN8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Also remove the now dead behavior code.

Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-08-13 18:08:02.000000000 +0200
@@ -39,7 +39,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_alloc_btree.o \
 				   xfs_attr.o \
 				   xfs_attr_leaf.o \
-				   xfs_behavior.o \
 				   xfs_bit.o \
 				   xfs_bmap.o \
 				   xfs_bmap_btree.o \
@@ -78,7 +77,6 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_trans_item.o \
 				   xfs_utils.o \
 				   xfs_vfsops.o \
-				   xfs_vfsops_bhv.o \
 				   xfs_vnodeops.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-13 18:07:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-13 18:08:02.000000000 +0200
@@ -45,6 +45,7 @@
 #include "xfs_attr.h"
 #include "xfs_inode_item.h"
 #include "xfs_vnodeops.h"
+#include "xfs_vfsops.h"
 #include <dmapi.h>
 #include <dmapi_kern.h>
 #include "xfs_dm.h"
@@ -64,7 +65,7 @@ xfs_dm_fh_to_inode(
 	dm_fid_t		*dmfid)
 {
 	bhv_vnode_t	*vp = NULL;
-	bhv_vfs_t	*vfsp = vfs_from_sb(sb);
+	xfs_mount_t	*mp = XFS_M(sb);
 	int		error;
 	fid_t		fid;
 
@@ -73,10 +74,10 @@ xfs_dm_fh_to_inode(
 	*ip = NULL;
 	memcpy(&fid, dmfid, sizeof(*dmfid));
 	if (fid.fid_len) {	/* file object handle */
-		error = bhv_vfs_vget(vfsp, &vp, &fid);
+		error = xfs_vget(mp, &vp, &fid);
 	}
 	else {			/* filesystem handle */
-		error = bhv_vfs_root(vfsp, &vp);
+		error = xfs_root(mp, &vp);
 	}
 	if (vp && (error == 0))
 		*ip = vn_to_inode(vp);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2007-08-13 18:08:02.000000000 +0200
@@ -28,6 +28,7 @@
 #include "xfs_vnodeops.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_inode.h"
+#include "xfs_vfsops.h"
 
 static struct dentry dotdot = { .d_name.name = "..", .d_name.len = 2, };
 
@@ -143,10 +144,9 @@ xfs_fs_get_dentry(
 	bhv_vnode_t		*vp;
 	struct inode		*inode;
 	struct dentry		*result;
-	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
 	int			error;
 
-	error = bhv_vfs_vget(vfsp, &vp, (fid_t *)data);
+	error = xfs_vget(XFS_M(sb), &vp, (fid_t *)data);
 	if (error || vp == NULL)
 		return ERR_PTR(-ESTALE) ;
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-13 18:08:02.000000000 +0200
@@ -65,6 +65,7 @@
 #include "xfs_iomap.h"
 #include "xfs_filestream.h"
 #include "xfs_vnodeops.h"
+#include "xfs_vfsops.h"
 #include "support/ktrace.h"
 
 
@@ -140,17 +141,6 @@ EXPORT_SYMBOL(xfs_get_buftarg_list);
 
 EXPORT_SYMBOL(assfail);
 EXPORT_SYMBOL(cmn_err);
-EXPORT_SYMBOL(bhv_base);
-EXPORT_SYMBOL(bhv_get_vfsops);
-EXPORT_SYMBOL(bhv_head_destroy);
-EXPORT_SYMBOL(bhv_insert);
-EXPORT_SYMBOL(bhv_insert_initial);
-EXPORT_SYMBOL(bhv_lookup_range);
-EXPORT_SYMBOL(bhv_module_init);
-EXPORT_SYMBOL(bhv_module_exit);
-EXPORT_SYMBOL(bhv_remove_vfsops);
-EXPORT_SYMBOL(bhv_remove_all_vfsops);
-EXPORT_SYMBOL(bhv_remove_not_first);
 EXPORT_SYMBOL(xfs_flush_pages);
 EXPORT_SYMBOL(xfs_flushinval_pages);
 EXPORT_SYMBOL(xfs_tosspages);
@@ -190,18 +180,6 @@ EXPORT_SYMBOL(uuid_getnodeuniq);
 EXPORT_SYMBOL(uuid_hash64);
 EXPORT_SYMBOL(uuid_is_nil);
 EXPORT_SYMBOL(uuid_table_remove);
-EXPORT_SYMBOL(vfs_mount);
-EXPORT_SYMBOL(vfs_parseargs);
-EXPORT_SYMBOL(vfs_showargs);
-EXPORT_SYMBOL(vfs_unmount);
-EXPORT_SYMBOL(vfs_mntupdate);
-EXPORT_SYMBOL(vfs_root);
-EXPORT_SYMBOL(vfs_statvfs);
-EXPORT_SYMBOL(vfs_sync);
-EXPORT_SYMBOL(vfs_vget);
-EXPORT_SYMBOL(vfs_get_inode);
-EXPORT_SYMBOL(vfs_init_vnode);
-EXPORT_SYMBOL(vfs_force_shutdown);
 EXPORT_SYMBOL(vfs_from_sb);
 EXPORT_SYMBOL(vn_hold);
 EXPORT_SYMBOL(vn_initialize);
@@ -330,7 +308,6 @@ EXPORT_SYMBOL(xfs_trans_unlocked_item);
 EXPORT_SYMBOL(xfs_truncate_file);
 EXPORT_SYMBOL(xfs_unmount_flush);
 EXPORT_SYMBOL(xfs_unmountfs_writesb);
-EXPORT_SYMBOL(xfs_vfsops);
 EXPORT_SYMBOL(xfs_write_clear_setuid);
 EXPORT_SYMBOL(xfs_dinode_from_disk);
 EXPORT_SYMBOL(xfs_sb_from_disk);
@@ -338,3 +315,7 @@ EXPORT_SYMBOL(xfs_zero_eof);
 EXPORT_SYMBOL(xlog_recover_process_iunlinks);
 EXPORT_SYMBOL(xfs_ichgtime_fast);
 EXPORT_SYMBOL(xfs_free_eofblocks);
+
+EXPORT_SYMBOL(xfs_do_force_shutdown);
+EXPORT_SYMBOL(xfs_vget);
+EXPORT_SYMBOL(xfs_root);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2007-08-13 18:04:24.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_linux.h	2007-08-13 18:08:02.000000000 +0200
@@ -83,7 +83,6 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include <xfs_behavior.h>
 #include <xfs_vfs.h>
 #include <xfs_cred.h>
 #include <xfs_vnode.h>
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-13 18:07:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-13 18:08:02.000000000 +0200
@@ -18,7 +18,6 @@
 #ifndef __XFS_LRW_H__
 #define __XFS_LRW_H__
 
-struct bhv_desc;
 struct xfs_mount;
 struct xfs_iocore;
 struct xfs_inode;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:08:02.000000000 +0200
@@ -47,6 +47,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_vnodeops.h"
+#include "xfs_vfsops.h"
 #include "xfs_version.h"
 
 #include <linux/namei.h>
@@ -204,8 +205,7 @@ void
 xfs_initialize_vnode(
 	struct xfs_mount	*mp,
 	bhv_vnode_t		*vp,
-	struct xfs_inode	*ip,
-	int			unlock)
+	struct xfs_inode	*ip)
 {
 	struct inode		*inode = vn_to_inode(vp);
 
@@ -221,7 +221,7 @@ xfs_initialize_vnode(
 	 * second time once the inode is properly set up, and then we can
 	 * finish our work.
 	 */
-	if (ip->i_d.di_mode != 0 && unlock && (inode->i_state & I_NEW)) {
+	if (ip->i_d.di_mode != 0 && (inode->i_state & I_NEW)) {
 		xfs_revalidate_inode(mp, vp, ip);
 		xfs_set_inodeops(inode);
 
@@ -232,15 +232,6 @@ xfs_initialize_vnode(
 	}
 }
 
-struct inode *
-xfs_get_inode(
-	xfs_mount_t	*mp,
-	xfs_ino_t	ino,
-	int		flags)
-{
-	return iget_locked(XFS_MTOVFS(mp)->vfs_super, ino);
-}
-
 int
 xfs_blkdev_get(
 	xfs_mount_t		*mp,
@@ -542,9 +533,8 @@ vfs_sync_worker(
 	int		error;
 
 	if (!(vfsp->vfs_flag & VFS_RDONLY))
-		error = bhv_vfs_sync(vfsp, SYNC_FSDATA | SYNC_BDFLUSH | \
-					SYNC_ATTR | SYNC_REFCACHE | SYNC_SUPER,
-					NULL);
+		error = xfs_sync(XFS_VFSTOM(vfsp), SYNC_FSDATA | SYNC_BDFLUSH | \
+					SYNC_ATTR | SYNC_REFCACHE | SYNC_SUPER);
 	vfsp->vfs_sync_seq++;
 	wake_up(&vfsp->vfs_wait_single_sync_task);
 }
@@ -620,11 +610,12 @@ xfs_fs_put_super(
 	struct super_block	*sb)
 {
 	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
+	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
 
 	xfs_fs_stop_syncd(vfsp);
-	bhv_vfs_sync(vfsp, SYNC_ATTR | SYNC_DELWRI, NULL);
-	error = bhv_vfs_unmount(vfsp, 0, NULL);
+	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
+	error = xfs_unmount(mp, 0, NULL);
 	if (error) {
 		printk("XFS: unmount got error=%d\n", error);
 		printk("%s: vfs=0x%p left dangling!\n", __FUNCTION__, vfsp);
@@ -638,7 +629,7 @@ xfs_fs_write_super(
 	struct super_block	*sb)
 {
 	if (!(sb->s_flags & MS_RDONLY))
-		bhv_vfs_sync(vfs_from_sb(sb), SYNC_FSDATA, NULL);
+		xfs_sync(XFS_M(sb), SYNC_FSDATA);
 	sb->s_dirt = 0;
 }
 
@@ -648,6 +639,7 @@ xfs_fs_sync_super(
 	int			wait)
 {
 	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
+	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
 	int			flags;
 
@@ -664,7 +656,7 @@ xfs_fs_sync_super(
 	} else
 		flags = SYNC_FSDATA | (wait ? SYNC_WAIT : 0);
 
-	error = bhv_vfs_sync(vfsp, flags, NULL);
+	error = xfs_sync(mp, flags);
 	sb->s_dirt = 0;
 
 	if (unlikely(laptop_mode)) {
@@ -694,7 +686,7 @@ xfs_fs_statfs(
 	struct dentry		*dentry,
 	struct kstatfs		*statp)
 {
-	return -bhv_vfs_statvfs(vfs_from_sb(dentry->d_sb), statp,
+	return -xfs_statvfs(XFS_M(dentry->d_sb), statp,
 				vn_from_inode(dentry->d_inode));
 }
 
@@ -704,13 +696,13 @@ xfs_fs_remount(
 	int			*flags,
 	char			*options)
 {
-	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
+	struct xfs_mount	*mp = XFS_M(sb);
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, 0);
 	int			error;
 
-	error = bhv_vfs_parseargs(vfsp, options, args, 1);
+	error = xfs_parseargs(mp, options, args, 1);
 	if (!error)
-		error = bhv_vfs_mntupdate(vfsp, flags, args);
+		error = xfs_mntupdate(mp, flags, args);
 	kmem_free(args, sizeof(*args));
 	return -error;
 }
@@ -719,7 +711,7 @@ STATIC void
 xfs_fs_lockfs(
 	struct super_block	*sb)
 {
-	bhv_vfs_freeze(vfs_from_sb(sb));
+	xfs_freeze(XFS_M(sb));
 }
 
 STATIC int
@@ -727,7 +719,7 @@ xfs_fs_show_options(
 	struct seq_file		*m,
 	struct vfsmount		*mnt)
 {
-	return -bhv_vfs_showargs(vfs_from_sb(mnt->mnt_sb), m);
+	return -xfs_showargs(XFS_M(mnt->mnt_sb), m);
 }
 
 STATIC int
@@ -789,30 +781,29 @@ xfs_fs_fill_super(
 {
 	struct inode		*rootvp;
 	struct bhv_vfs		*vfsp = vfs_allocate(sb);
+	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
 	struct kstatfs		statvfs;
 	int			error;
 
-	bhv_insert_all_vfsops(vfsp);
+	mp = xfs_mount_init();
+	mp->m_vfsp = vfsp;
+	vfsp->vfs_mount = mp;
 
-	error = bhv_vfs_parseargs(vfsp, (char *)data, args, 0);
-	if (error) {
-		bhv_remove_all_vfsops(vfsp, 1);
+	error = xfs_parseargs(mp, (char *)data, args, 0);
+	if (error)
 		goto fail_vfsop;
-	}
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_export_op = &xfs_export_operations;
 	sb->s_qcop = &xfs_quotactl_operations;
 	sb->s_op = &xfs_super_operations;
 
-	error = bhv_vfs_mount(vfsp, args, NULL);
-	if (error) {
-		bhv_remove_all_vfsops(vfsp, 1);
+	error = xfs_mount(mp, args, NULL);
+	if (error)
 		goto fail_vfsop;
-	}
 
-	error = bhv_vfs_statvfs(vfsp, &statvfs, NULL);
+	error = xfs_statvfs(mp, &statvfs, NULL);
 	if (error)
 		goto fail_unmount;
 
@@ -824,7 +815,7 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = bhv_vfs_root(vfsp, &rootvp);
+	error = xfs_root(mp, &rootvp);
 	if (error)
 		goto fail_unmount;
 
@@ -854,7 +845,7 @@ fail_vnrele:
 	}
 
 fail_unmount:
-	bhv_vfs_unmount(vfsp, 0, NULL);
+	xfs_unmount(mp, 0, NULL);
 
 fail_vfsop:
 	vfs_deallocate(vfsp);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:08:02.000000000 +0200
@@ -30,186 +30,6 @@
 #include "xfs_mount.h"
 #include "xfs_quota.h"
 
-int
-vfs_mount(
-	struct bhv_desc		*bdp,
-	struct xfs_mount_args	*args,
-	struct cred		*cr)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_mount)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_mount)(next, args, cr));
-}
-
-int
-vfs_parseargs(
-	struct bhv_desc		*bdp,
-	char			*s,
-	struct xfs_mount_args	*args,
-	int			f)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_parseargs)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_parseargs)(next, s, args, f));
-}
-
-int
-vfs_showargs(
-	struct bhv_desc		*bdp,
-	struct seq_file		*m)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_showargs)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_showargs)(next, m));
-}
-
-int
-vfs_unmount(
-	struct bhv_desc		*bdp,
-	int			fl,
-	struct cred		*cr)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_unmount)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_unmount)(next, fl, cr));
-}
-
-int
-vfs_mntupdate(
-	struct bhv_desc		*bdp,
-	int			*fl,
-	struct xfs_mount_args	*args)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_mntupdate)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_mntupdate)(next, fl, args));
-}
-
-int
-vfs_root(
-	struct bhv_desc		*bdp,
-	bhv_vnode_t		**vpp)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_root)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_root)(next, vpp));
-}
-
-int
-vfs_statvfs(
-	struct bhv_desc		*bdp,
-	bhv_statvfs_t		*statp,
-	bhv_vnode_t		*vp)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_statvfs)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_statvfs)(next, statp, vp));
-}
-
-int
-vfs_sync(
-	struct bhv_desc		*bdp,
-	int			fl,
-	struct cred		*cr)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_sync)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_sync)(next, fl, cr));
-}
-
-int
-vfs_vget(
-	struct bhv_desc		*bdp,
-	bhv_vnode_t		**vpp,
-	struct fid		*fidp)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_vget)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_vget)(next, vpp, fidp));
-}
-
-struct inode *
-vfs_get_inode(
-	struct bhv_desc		*bdp,
-	xfs_ino_t		ino,
-	int			fl)
-{
-	struct bhv_desc		*next = bdp;
-
-	while (! (bhvtovfsops(next))->vfs_get_inode)
-		next = BHV_NEXTNULL(next);
-	return ((*bhvtovfsops(next)->vfs_get_inode)(next, ino, fl));
-}
-
-void
-vfs_init_vnode(
-	struct bhv_desc		*bdp,
-	bhv_vnode_t		*vp,
-	struct xfs_inode	*ip,
-	int			unlock)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_init_vnode)
-		next = BHV_NEXT(next);
-	((*bhvtovfsops(next)->vfs_init_vnode)(next, vp, ip, unlock));
-}
-
-void
-vfs_force_shutdown(
-	struct bhv_desc		*bdp,
-	int			fl,
-	char			*file,
-	int			line)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_force_shutdown)
-		next = BHV_NEXT(next);
-	((*bhvtovfsops(next)->vfs_force_shutdown)(next, fl, file, line));
-}
-
-void
-vfs_freeze(
-	struct bhv_desc		*bdp)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_freeze)
-		next = BHV_NEXT(next);
-	((*bhvtovfsops(next)->vfs_freeze)(next));
-}
-
 bhv_vfs_t *
 vfs_allocate(
 	struct super_block	*sb)
@@ -217,7 +37,6 @@ vfs_allocate(
 	struct bhv_vfs		*vfsp;
 
 	vfsp = kmem_zalloc(sizeof(bhv_vfs_t), KM_SLEEP);
-	bhv_head_init(VFS_BHVHEAD(vfsp), "vfs");
 	INIT_LIST_HEAD(&vfsp->vfs_sync_list);
 	spin_lock_init(&vfsp->vfs_sync_lock);
 	init_waitqueue_head(&vfsp->vfs_wait_single_sync_task);
@@ -242,180 +61,5 @@ void
 vfs_deallocate(
 	struct bhv_vfs		*vfsp)
 {
-	bhv_head_destroy(VFS_BHVHEAD(vfsp));
 	kmem_free(vfsp, sizeof(bhv_vfs_t));
 }
-
-void
-vfs_insertbhv(
-	struct bhv_vfs		*vfsp,
-	struct bhv_desc		*bdp,
-	struct bhv_vfsops	*vfsops,
-	void			*mount)
-{
-	bhv_desc_init(bdp, mount, vfsp, vfsops);
-	bhv_insert_initial(&vfsp->vfs_bh, bdp);
-}
-
-/*
- * Implementation for behaviours-as-modules
- */
-
-typedef struct bhv_module_list {
-	struct list_head	bm_list;
-	struct module *		bm_module;
-	const char *		bm_name;
-	void *			bm_ops;
-} bhv_module_list_t;
-
-static DEFINE_SPINLOCK(bhv_lock);
-static struct list_head bhv_list = LIST_HEAD_INIT(bhv_list);
-
-void
-bhv_module_init(
-	const char		*name,
-	struct module		*module,
-	const void		*ops)
-{
-	bhv_module_list_t	*bm, *entry, *n;
-
-	bm = kmem_alloc(sizeof(struct bhv_module_list), KM_SLEEP);
-	INIT_LIST_HEAD(&bm->bm_list);
-	bm->bm_module = module;
-	bm->bm_name = name;
-	bm->bm_ops = (void *)ops;
-
-	spin_lock(&bhv_lock);
-	list_for_each_entry_safe(entry, n, &bhv_list, bm_list)
-		BUG_ON(strcmp(entry->bm_name, name) == 0);
-	list_add(&bm->bm_list, &bhv_list);
-	spin_unlock(&bhv_lock);
-}
-
-void
-bhv_module_exit(
-	const char		*name)
-{
-	bhv_module_list_t	*entry, *n;
-
-	spin_lock(&bhv_lock);
-	list_for_each_entry_safe(entry, n, &bhv_list, bm_list)
-		if (strcmp(entry->bm_name, name) == 0)
-			list_del(&entry->bm_list);
-	spin_unlock(&bhv_lock);
-}
-
-STATIC void *
-bhv_insert_module(
-	const char		*name,
-	const char		*modname)
-{
-	bhv_module_list_t	*entry, *n;
-	void			*ops = NULL;
-
-	spin_lock(&bhv_lock);
-	list_for_each_entry_safe(entry, n, &bhv_list, bm_list)
-		if (strcmp(entry->bm_name, name) == 0 &&
-		    try_module_get(entry->bm_module))
-			ops = entry->bm_ops;
-	spin_unlock(&bhv_lock);
-	return ops;
-}
-
-STATIC void
-bhv_remove_module(
-	const char		*name)
-{
-	bhv_module_list_t	*entry, *n;
-
-	spin_lock(&bhv_lock);
-	list_for_each_entry_safe(entry, n, &bhv_list, bm_list)
-		if (strcmp(entry->bm_name, name) == 0)
-		    module_put(entry->bm_module);
-	spin_unlock(&bhv_lock);
-}
-
-STATIC void *
-bhv_lookup_module(
-	const char		*name,
-	const char		*module)
-{
-	void			*ops;
-
-	ops = bhv_insert_module(name, module);
-	if (!ops && module) {
-		request_module("%s", module);
-		ops = bhv_insert_module(name, module);
-	}
-	return ops;
-}
-
-void
-bhv_remove_vfsops(
-	struct bhv_vfs		*vfsp,
-	int			pos)
-{
-	struct bhv_desc		*bhv;
-
-	bhv = bhv_lookup_range(&vfsp->vfs_bh, pos, pos);
-	if (bhv) {
-		struct bhv_module	*bm;
-
-		bm = (bhv_module_t *) BHV_PDATA(bhv);
-		bhv_remove(&vfsp->vfs_bh, bhv);
-		bhv_remove_module(bm->bm_name);
-		kmem_free(bhv, sizeof(*bhv));
-	}
-}
-
-void
-bhv_remove_all_vfsops(
-	struct bhv_vfs		*vfsp,
-	int			freebase)
-{
-	struct xfs_mount	*mp;
-
-	bhv_remove_vfsops(vfsp, VFS_POSITION_QM);
-	bhv_remove_vfsops(vfsp, VFS_POSITION_IO);
-	if (!freebase)
-		return;
-	mp = XFS_VFSTOM(vfsp);
-	VFS_REMOVEBHV(vfsp, &mp->m_bhv);
-	xfs_mount_free(mp, 0);
-	kmem_free(mp, sizeof(xfs_mount_t));
-}
-
-void
-bhv_get_vfsops(
-	struct bhv_vfs		*vfsp,
-	const char		*name,
-	const char		*module)
-{
-	struct bhv_vfsops	*ops;
-
-	ops = (struct bhv_vfsops *) bhv_lookup_module(name, module);
-	if (ops) {
-		struct bhv_module	*bm;
-
-		bm = kmem_alloc(sizeof(struct bhv_module), KM_SLEEP);
-		bm->bm_name = name;
-		bhv_desc_init(&bm->bm_desc, bm, vfsp, ops);
-		bhv_insert(&vfsp->vfs_bh, &bm->bm_desc);
-	}
-}
-
-void
-bhv_insert_all_vfsops(
-	struct bhv_vfs		*vfsp)
-{
-	struct xfs_mount	*mp;
-
-	mp = xfs_mount_init();
-	vfs_insertbhv(vfsp, &mp->m_bhv, &xfs_vfsops, mp);
-	bhv_get_vfsops(vfsp, XFS_DMOPS,
-		xfs_probe_dmapi ? XFS_DM_MODULE : NULL);
-	bhv_get_vfsops(vfsp, XFS_QMOPS,
-		xfs_probe_quota ? XFS_QM_MODULE : NULL);
-	bhv_get_vfsops(vfsp, XFS_IOOPS,
-		xfs_probe_ioops ? XFS_IO_MODULE : NULL);
-}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:07:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:08:02.000000000 +0200
@@ -29,6 +29,7 @@ struct cred;
 struct seq_file;
 struct super_block;
 struct xfs_inode;
+struct xfs_mount;
 struct xfs_mount_args;
 
 typedef struct kstatfs	bhv_statvfs_t;
@@ -41,10 +42,10 @@ typedef struct bhv_vfs_sync_work {
 } bhv_vfs_sync_work_t;
 
 typedef struct bhv_vfs {
+	struct xfs_mount	*vfs_mount;
 	u_int			vfs_flag;	/* flags */
 	xfs_fsid_t		vfs_fsid;	/* file system ID */
 	xfs_fsid_t		*vfs_altfsid;	/* An ID fixed for life of FS */
-	bhv_head_t		vfs_bh;		/* head of vfs behavior chain */
 	struct super_block	*vfs_super;	/* generic superblock pointer */
 	struct task_struct	*vfs_sync_task;	/* generalised sync thread */
 	bhv_vfs_sync_work_t	vfs_sync_work;	/* work item for VFS_SYNC */
@@ -54,27 +55,6 @@ typedef struct bhv_vfs {
 	wait_queue_head_t	vfs_wait_single_sync_task;
 } bhv_vfs_t;
 
-#define bhvtovfs(bdp)		( (struct bhv_vfs *)BHV_VOBJ(bdp) )
-#define bhvtovfsops(bdp)	( (struct bhv_vfsops *)BHV_OPS(bdp) )
-#define VFS_BHVHEAD(vfs)	( &(vfs)->vfs_bh )
-#define VFS_REMOVEBHV(vfs, bdp)	( bhv_remove(VFS_BHVHEAD(vfs), bdp) )
-
-#define VFS_POSITION_BASE	BHV_POSITION_BASE	/* chain bottom */
-#define VFS_POSITION_TOP	BHV_POSITION_TOP	/* chain top */
-#define VFS_POSITION_INVALID	BHV_POSITION_INVALID	/* invalid pos. num */
-
-typedef enum {
-	VFS_BHV_UNKNOWN,	/* not specified */
-	VFS_BHV_XFS,		/* xfs */
-	VFS_BHV_QM,		/* quota manager */
-	VFS_BHV_IO,		/* IO path */
-	VFS_BHV_END		/* housekeeping end-of-range */
-} bhv_vfs_type_t;
-
-#define VFS_POSITION_XFS	(BHV_POSITION_BASE)
-#define VFS_POSITION_QM		(VFS_POSITION_BASE+20)
-#define VFS_POSITION_IO		(VFS_POSITION_BASE+30)
-
 #define VFS_RDONLY		0x0001	/* read-only vfs */
 #define VFS_GRPID		0x0002	/* group-ID assigned from directory */
 #define VFS_DMI			0x0004	/* filesystem has the DMI enabled */
@@ -114,127 +94,11 @@ typedef enum {
 #define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
 #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
-typedef int	(*vfs_mount_t)(bhv_desc_t *,
-				struct xfs_mount_args *, struct cred *);
-typedef int	(*vfs_parseargs_t)(bhv_desc_t *, char *,
-				struct xfs_mount_args *, int);
-typedef	int	(*vfs_showargs_t)(bhv_desc_t *, struct seq_file *);
-typedef int	(*vfs_unmount_t)(bhv_desc_t *, int, struct cred *);
-typedef int	(*vfs_mntupdate_t)(bhv_desc_t *, int *,
-				struct xfs_mount_args *);
-typedef int	(*vfs_root_t)(bhv_desc_t *, struct inode **);
-typedef int	(*vfs_statvfs_t)(bhv_desc_t *, bhv_statvfs_t *,
-				struct inode *);
-typedef int	(*vfs_sync_t)(bhv_desc_t *, int, struct cred *);
-typedef int	(*vfs_vget_t)(bhv_desc_t *, struct inode **, struct fid *);
-typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
-				struct inode *, struct xfs_inode *, int);
-typedef void	(*vfs_force_shutdown_t)(bhv_desc_t *, int, char *, int);
-typedef void	(*vfs_freeze_t)(bhv_desc_t *);
-typedef	struct inode * (*vfs_get_inode_t)(bhv_desc_t *, xfs_ino_t, int);
-
-typedef struct bhv_vfsops {
-	bhv_position_t		vf_position;	/* behavior chain position */
-	vfs_mount_t		vfs_mount;	/* mount file system */
-	vfs_parseargs_t		vfs_parseargs;	/* parse mount options */
-	vfs_showargs_t		vfs_showargs;	/* unparse mount options */
-	vfs_unmount_t		vfs_unmount;	/* unmount file system */
-	vfs_mntupdate_t		vfs_mntupdate;	/* update file system options */
-	vfs_root_t		vfs_root;	/* get root vnode */
-	vfs_statvfs_t		vfs_statvfs;	/* file system statistics */
-	vfs_sync_t		vfs_sync;	/* flush files */
-	vfs_vget_t		vfs_vget;	/* get vnode from fid */
-	vfs_get_inode_t		vfs_get_inode;	/* bhv specific iget */
-	vfs_init_vnode_t	vfs_init_vnode;	/* initialize a new vnode */
-	vfs_force_shutdown_t	vfs_force_shutdown;	/* crash and burn */
-	vfs_freeze_t		vfs_freeze;	/* freeze fs for snapshot */
-} bhv_vfsops_t;
-
-/*
- * Virtual filesystem operations, operating from head bhv.
- */
-#define VFSHEAD(v)			((v)->vfs_bh.bh_first)
-#define bhv_vfs_mount(v, ma,cr)		vfs_mount(VFSHEAD(v), ma,cr)
-#define bhv_vfs_parseargs(v, o,ma,f)	vfs_parseargs(VFSHEAD(v), o,ma,f)
-#define bhv_vfs_showargs(v, m)		vfs_showargs(VFSHEAD(v), m)
-#define bhv_vfs_unmount(v, f,cr)	vfs_unmount(VFSHEAD(v), f,cr)
-#define bhv_vfs_mntupdate(v, fl,args)	vfs_mntupdate(VFSHEAD(v), fl,args)
-#define bhv_vfs_root(v, vpp)		vfs_root(VFSHEAD(v), vpp)
-#define bhv_vfs_statvfs(v, sp,vp)	vfs_statvfs(VFSHEAD(v), sp,vp)
-#define bhv_vfs_sync(v, flag,cr)	vfs_sync(VFSHEAD(v), flag,cr)
-#define bhv_vfs_vget(v, vpp,fidp)	vfs_vget(VFSHEAD(v), vpp,fidp)
-#define bhv_vfs_get_inode(v, ino, fl)	vfs_get_inode(VFSHEAD(v), ino,fl)
-#define bhv_vfs_init_vnode(v, vp,b,ul)	vfs_init_vnode(VFSHEAD(v), vp,b,ul)
-#define bhv_vfs_force_shutdown(v,u,f,l)	vfs_force_shutdown(VFSHEAD(v), u,f,l)
-#define bhv_vfs_freeze(v)		vfs_freeze(VFSHEAD(v))
-
-/*
- * Virtual filesystem operations, operating from next bhv.
- */
-#define bhv_next_vfs_mount(b, ma,cr)		vfs_mount(b, ma,cr)
-#define bhv_next_vfs_parseargs(b, o,ma,f)	vfs_parseargs(b, o,ma,f)
-#define bhv_next_vfs_showargs(b, m)		vfs_showargs(b, m)
-#define bhv_next_vfs_unmount(b, f,cr)		vfs_unmount(b, f,cr)
-#define bhv_next_vfs_mntupdate(b, fl,args)	vfs_mntupdate(b, fl, args)
-#define bhv_next_vfs_root(b, vpp)		vfs_root(b, vpp)
-#define bhv_next_vfs_statvfs(b, sp,vp)		vfs_statvfs(b, sp,vp)
-#define bhv_next_vfs_sync(b, flag,cr)		vfs_sync(b, flag,cr)
-#define bhv_next_vfs_vget(b, vpp,fidp)		vfs_vget(b, vpp,fidp)
-#define bhv_next_vfs_get_inode(b, ino,fl)	vfs_get_inode(b, ino,fl)
-#define bhv_next_vfs_init_vnode(b, vp,b2,ul)	vfs_init_vnode(b, vp,b2,ul)
-#define bhv_next_force_shutdown(b, fl,f,l)	vfs_force_shutdown(b, fl,f,l)
-#define bhv_next_vfs_freeze(b)			vfs_freeze(b)
-
-extern int vfs_mount(bhv_desc_t *, struct xfs_mount_args *, struct cred *);
-extern int vfs_parseargs(bhv_desc_t *, char *, struct xfs_mount_args *, int);
-extern int vfs_showargs(bhv_desc_t *, struct seq_file *);
-extern int vfs_unmount(bhv_desc_t *, int, struct cred *);
-extern int vfs_mntupdate(bhv_desc_t *, int *, struct xfs_mount_args *);
-extern int vfs_root(bhv_desc_t *, struct inode **);
-extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct inode *);
-extern int vfs_sync(bhv_desc_t *, int, struct cred *);
-extern int vfs_vget(bhv_desc_t *, struct inode **, struct fid *);
-extern struct inode *vfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
-extern void vfs_init_vnode(bhv_desc_t *, struct inode *, struct xfs_inode *, int);
-extern void vfs_force_shutdown(bhv_desc_t *, int, char *, int);
-extern void vfs_freeze(bhv_desc_t *);
-
 #define vfs_test_for_freeze(vfs)	((vfs)->vfs_super->s_frozen)
 #define vfs_wait_for_freeze(vfs,l)	vfs_check_frozen((vfs)->vfs_super, (l))
 
-#define XFS_DMOPS		"xfs_dm_operations"	/* Data Migration */
-#define XFS_QMOPS		"xfs_qm_operations"	/* Quota Manager  */
-#define XFS_IOOPS		"xfs_io_operations"	/* I/O subsystem  */
-#define XFS_DM_MODULE		"xfs_dmapi"
-#define XFS_QM_MODULE		"xfs_quota"
-#define XFS_IO_MODULE		"xfs_ioops"
-
-typedef struct bhv_module_vfsops {
-	struct bhv_vfsops	bhv_common;
-	void *			bhv_custom;
-} bhv_module_vfsops_t;
-
-typedef struct bhv_module {
-	bhv_desc_t		bm_desc;
-	const char *		bm_name;
-	bhv_module_vfsops_t *	bm_ops;
-} bhv_module_t;
-
-#define vfs_bhv_lookup(v, id)	(bhv_lookup_range(&(v)->vfs_bh, (id), (id)))
-#define vfs_bhv_custom(b)	(((bhv_module_vfsops_t*)BHV_OPS(b))->bhv_custom)
-#define vfs_bhv_set_custom(b,o)	((b)->bhv_custom = (void *)(o))
-#define vfs_bhv_clr_custom(b)	((b)->bhv_custom = NULL)
-
 extern bhv_vfs_t *vfs_allocate(struct super_block *);
 extern bhv_vfs_t *vfs_from_sb(struct super_block *);
 extern void vfs_deallocate(bhv_vfs_t *);
-extern void vfs_insertbhv(bhv_vfs_t *, bhv_desc_t *, bhv_vfsops_t *, void *);
-
-extern void bhv_module_init(const char *, struct module *, const void *);
-extern void bhv_module_exit(const char *);
-extern void bhv_get_vfsops(struct bhv_vfs *, const char *, const char *);
-extern void bhv_insert_all_vfsops(struct bhv_vfs *);
-extern void bhv_remove_all_vfsops(struct bhv_vfs *, int);
-extern void bhv_remove_vfsops(struct bhv_vfs *, int);
 
 #endif	/* __XFS_VFS_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-13 18:07:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2007-08-13 18:08:02.000000000 +0200
@@ -76,10 +76,8 @@ vn_ioerror(
 	char		*f,
 	int		l)
 {
-	bhv_vfs_t	*vfsp = XFS_MTOVFS(ip->i_mount);
-
 	if (unlikely(error == -ENODEV))
-		bhv_vfs_force_shutdown(vfsp, SHUTDOWN_DEVICE_REQ, f, l);
+		xfs_do_force_shutdown(ip->i_mount, SHUTDOWN_DEVICE_REQ, f, l);
 }
 
 bhv_vnode_t *
Index: linux-2.6-xfs/fs/xfs/xfs_behavior.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_behavior.c	2007-08-13 17:59:06.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,183 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include "xfs.h"
-
-/*
- * Source file used to associate/disassociate behaviors with virtualized
- * objects.  See xfs_behavior.h for more information about behaviors, etc.
- *
- * The implementation is split between functions in this file and macros
- * in xfs_behavior.h.
- */
-
-/*
- * Insert a new behavior descriptor into a behavior chain.
- *
- * The behavior chain is ordered based on the 'position' number which
- * lives in the first field of the ops vector (higher numbers first).
- *
- * Attempts to insert duplicate ops result in an EINVAL return code.
- * Otherwise, return 0 to indicate success.
- */
-int
-bhv_insert(bhv_head_t *bhp, bhv_desc_t *bdp)
-{
-	bhv_desc_t	*curdesc, *prev;
-	int		position;
-
-	/*
-	 * Validate the position value of the new behavior.
-	 */
-	position = BHV_POSITION(bdp);
-	ASSERT(position >= BHV_POSITION_BASE && position <= BHV_POSITION_TOP);
-
-	/*
-	 * Find location to insert behavior.  Check for duplicates.
-	 */
-	prev = NULL;
-	for (curdesc = bhp->bh_first;
-	     curdesc != NULL;
-	     curdesc = curdesc->bd_next) {
-
-		/* Check for duplication. */
-		if (curdesc->bd_ops == bdp->bd_ops) {
-			ASSERT(0);
-			return EINVAL;
-		}
-
-		/* Find correct position */
-		if (position >= BHV_POSITION(curdesc)) {
-			ASSERT(position != BHV_POSITION(curdesc));
-			break;		/* found it */
-		}
-
-		prev = curdesc;
-	}
-
-	if (prev == NULL) {
-		/* insert at front of chain */
-		bdp->bd_next = bhp->bh_first;
-		bhp->bh_first = bdp;
-	} else {
-		/* insert after prev */
-		bdp->bd_next = prev->bd_next;
-		prev->bd_next = bdp;
-	}
-
-	return 0;
-}
-
-/*
- * Remove a behavior descriptor from a position in a behavior chain;
- * the position is guaranteed not to be the first position.
- * Should only be called by the bhv_remove() macro.
- */
-void
-bhv_remove_not_first(bhv_head_t *bhp, bhv_desc_t *bdp)
-{
-	bhv_desc_t	*curdesc, *prev;
-
-	ASSERT(bhp->bh_first != NULL);
-	ASSERT(bhp->bh_first->bd_next != NULL);
-
-	prev = bhp->bh_first;
-	for (curdesc = bhp->bh_first->bd_next;
-	     curdesc != NULL;
-	     curdesc = curdesc->bd_next) {
-
-		if (curdesc == bdp)
-			break;		/* found it */
-		prev = curdesc;
-	}
-
-	ASSERT(curdesc == bdp);
-	prev->bd_next = bdp->bd_next;	/* remove from after prev */
-}
-
-/*
- * Looks for the first behavior within a specified range of positions.
- * Return the associated behavior descriptor.  Or NULL, if none found.
- */
-bhv_desc_t *
-bhv_lookup_range(bhv_head_t *bhp, int low, int high)
-{
-	bhv_desc_t	*curdesc;
-
-	for (curdesc = bhp->bh_first;
-	     curdesc != NULL;
-	     curdesc = curdesc->bd_next) {
-
-		int	position = BHV_POSITION(curdesc);
-
-		if (position <= high) {
-			if (position >= low)
-				return curdesc;
-			return NULL;
-		}
-	}
-
-	return NULL;
-}
-
-/*
- * Return the base behavior in the chain, or NULL if the chain
- * is empty.
- *
- * The caller has not read locked the behavior chain, so acquire the
- * lock before traversing the chain.
- */
-bhv_desc_t *
-bhv_base(bhv_head_t *bhp)
-{
-	bhv_desc_t	*curdesc;
-
-	for (curdesc = bhp->bh_first;
-	     curdesc != NULL;
-	     curdesc = curdesc->bd_next) {
-
-		if (curdesc->bd_next == NULL) {
-			return curdesc;
-		}
-	}
-
-	return NULL;
-}
-
-void
-bhv_head_init(
-	bhv_head_t *bhp,
-	char *name)
-{
-	bhp->bh_first = NULL;
-}
-
-void
-bhv_insert_initial(
-	bhv_head_t *bhp,
-	bhv_desc_t *bdp)
-{
-	ASSERT(bhp->bh_first == NULL);
-	(bhp)->bh_first = bdp;
-}
-
-void
-bhv_head_destroy(
-	bhv_head_t *bhp)
-{
-	ASSERT(bhp->bh_first == NULL);
-}
Index: linux-2.6-xfs/fs/xfs/xfs_behavior.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_behavior.h	2007-08-13 17:59:06.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,188 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_BEHAVIOR_H__
-#define __XFS_BEHAVIOR_H__
-
-/*
- * Header file used to associate behaviors with virtualized objects.
- *
- * A virtualized object is an internal, virtualized representation of
- * OS entities such as persistent files, processes, or sockets.  Examples
- * of virtualized objects include vnodes, vprocs, and vsockets.  Often
- * a virtualized object is referred to simply as an "object."
- *
- * A behavior is essentially an implementation layer associated with
- * an object.  Multiple behaviors for an object are chained together,
- * the order of chaining determining the order of invocation.  Each
- * behavior of a given object implements the same set of interfaces
- * (e.g., the VOP interfaces).
- *
- * Behaviors may be dynamically inserted into an object's behavior chain,
- * such that the addition is transparent to consumers that already have
- * references to the object.  Typically, a given behavior will be inserted
- * at a particular location in the behavior chain.  Insertion of new
- * behaviors is synchronized with operations-in-progress (oip's) so that
- * the oip's always see a consistent view of the chain.
- *
- * The term "interposition" is used to refer to the act of inserting
- * a behavior such that it interposes on (i.e., is inserted in front
- * of) a particular other behavior.  A key example of this is when a
- * system implementing distributed single system image wishes to
- * interpose a distribution layer (providing distributed coherency)
- * in front of an object that is otherwise only accessed locally.
- *
- * Note that the traditional vnode/inode combination is simply a virtualized
- * object that has exactly one associated behavior.
- *
- * Behavior synchronization is logic which is necessary under certain
- * circumstances that there is no conflict between ongoing operations
- * traversing the behavior chain and those dynamically modifying the
- * behavior chain.  Because behavior synchronization adds extra overhead
- * to virtual operation invocation, we want to restrict, as much as
- * we can, the requirement for this extra code, to those situations
- * in which it is truly necessary.
- *
- * Behavior synchronization is needed whenever there's at least one class
- * of object in the system for which:
- * 1) multiple behaviors for a given object are supported,
- * -- AND --
- * 2a) insertion of a new behavior can happen dynamically at any time during
- *     the life of an active object,
- *	-- AND --
- *	3a) insertion of a new behavior needs to synchronize with existing
- *	    ops-in-progress.
- *	-- OR --
- *	3b) multiple different behaviors can be dynamically inserted at
- *	    any time during the life of an active object
- *	-- OR --
- *	3c) removal of a behavior can occur at any time during the life of
- *	    an active object.
- * -- OR --
- * 2b) removal of a behavior can occur at any time during the life of an
- *     active object
- *
- */
-
-struct bhv_head_lock;
-
-/*
- * Behavior head.  Head of the chain of behaviors.
- * Contained within each virtualized object data structure.
- */
-typedef struct bhv_head {
-	struct bhv_desc *bh_first;	/* first behavior in chain */
-	struct bhv_head_lock *bh_lockp;	/* pointer to lock info struct */
-} bhv_head_t;
-
-/*
- * Behavior descriptor.	 Descriptor associated with each behavior.
- * Contained within the behavior's private data structure.
- */
-typedef struct bhv_desc {
-	void		*bd_pdata;	/* private data for this behavior */
-	void		*bd_vobj;	/* virtual object associated with */
-	void		*bd_ops;	/* ops for this behavior */
-	struct bhv_desc *bd_next;	/* next behavior in chain */
-} bhv_desc_t;
-
-/*
- * Behavior identity field.  A behavior's identity determines the position
- * where it lives within a behavior chain, and it's always the first field
- * of the behavior's ops vector. The optional id field further identifies the
- * subsystem responsible for the behavior.
- */
-typedef struct bhv_identity {
-	__u16	bi_id;		/* owning subsystem id */
-	__u16	bi_position;	/* position in chain */
-} bhv_identity_t;
-
-typedef bhv_identity_t bhv_position_t;
-
-#define BHV_IDENTITY_INIT(id,pos)	{id, pos}
-#define BHV_IDENTITY_INIT_POSITION(pos) BHV_IDENTITY_INIT(0, pos)
-
-/*
- * Define boundaries of position values.
- */
-#define BHV_POSITION_INVALID	0	/* invalid position number */
-#define BHV_POSITION_BASE	1	/* base (last) implementation layer */
-#define BHV_POSITION_TOP	63	/* top (first) implementation layer */
-
-/*
- * Plumbing macros.
- */
-#define BHV_HEAD_FIRST(bhp)	(ASSERT((bhp)->bh_first), (bhp)->bh_first)
-#define BHV_NEXT(bdp)		(ASSERT((bdp)->bd_next), (bdp)->bd_next)
-#define BHV_NEXTNULL(bdp)	((bdp)->bd_next)
-#define BHV_VOBJ(bdp)		(ASSERT((bdp)->bd_vobj), (bdp)->bd_vobj)
-#define BHV_VOBJNULL(bdp)	((bdp)->bd_vobj)
-#define BHV_PDATA(bdp)		(bdp)->bd_pdata
-#define BHV_OPS(bdp)		(bdp)->bd_ops
-#define BHV_IDENTITY(bdp)	((bhv_identity_t *)(bdp)->bd_ops)
-#define BHV_POSITION(bdp)	(BHV_IDENTITY(bdp)->bi_position)
-
-extern void bhv_head_init(bhv_head_t *, char *);
-extern void bhv_head_destroy(bhv_head_t *);
-extern int  bhv_insert(bhv_head_t *, bhv_desc_t *);
-extern void bhv_insert_initial(bhv_head_t *, bhv_desc_t *);
-
-/*
- * Initialize a new behavior descriptor.
- * Arguments:
- *   bdp - pointer to behavior descriptor
- *   pdata - pointer to behavior's private data
- *   vobj - pointer to associated virtual object
- *   ops - pointer to ops for this behavior
- */
-#define bhv_desc_init(bdp, pdata, vobj, ops)		\
- {							\
-	(bdp)->bd_pdata = pdata;			\
-	(bdp)->bd_vobj = vobj;				\
-	(bdp)->bd_ops = ops;				\
-	(bdp)->bd_next = NULL;				\
- }
-
-/*
- * Remove a behavior descriptor from a behavior chain.
- */
-#define bhv_remove(bhp, bdp)				\
- {							\
-	if ((bhp)->bh_first == (bdp)) {			\
-		/*					\
-		* Remove from front of chain.		\
-		* Atomic wrt oip's.			\
-		*/					\
-	       (bhp)->bh_first = (bdp)->bd_next;	\
-	} else {					\
-	       /* remove from non-front of chain */	\
-	       bhv_remove_not_first(bhp, bdp);		\
-	}						\
-	(bdp)->bd_vobj = NULL;				\
- }
-
-/*
- * Behavior module prototypes.
- */
-extern void		bhv_remove_not_first(bhv_head_t *bhp, bhv_desc_t *bdp);
-extern bhv_desc_t *	bhv_lookup_range(bhv_head_t *bhp, int low, int high);
-extern bhv_desc_t *	bhv_base(bhv_head_t *bhp);
-
-/* No bhv locking on Linux */
-#define bhv_base_unlocked	bhv_base
-
-#endif /* __XFS_BEHAVIOR_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-13 18:07:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-13 18:08:02.000000000 +0200
@@ -353,8 +353,7 @@ finish_inode:
 	 * If we have a real type for an on-disk inode, we can set ops(&unlock)
 	 * now.	 If it's a new inode being created, xfs_ialloc will handle it.
 	 */
-	bhv_vfs_init_vnode(XFS_MTOVFS(mp), vp, ip, 1);
-
+	xfs_initialize_vnode(mp, vp, ip);
 	return 0;
 }
 
@@ -380,7 +379,8 @@ xfs_iget(
 	XFS_STATS_INC(xs_ig_attempts);
 
 retry:
-	if ((inode = bhv_vfs_get_inode(XFS_MTOVFS(mp), ino, 0))) {
+	inode = iget_locked(XFS_MTOVFS(mp)->vfs_super, ino);
+	if (inode) {
 		xfs_inode_t	*ip;
 
 		vp = vn_from_inode(inode);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-13 18:07:51.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-13 18:08:02.000000000 +0200
@@ -157,8 +157,7 @@ xfs_mount_init(void)
  */
 void
 xfs_mount_free(
-	xfs_mount_t	*mp,
-	int		remove_bhv)
+	xfs_mount_t	*mp)
 {
 	if (mp->m_perag) {
 		int	agno;
@@ -186,13 +185,6 @@ xfs_mount_free(
 	if (mp->m_logname != NULL)
 		kmem_free(mp->m_logname, strlen(mp->m_logname) + 1);
 
-	if (remove_bhv) {
-		struct bhv_vfs	*vfsp = XFS_MTOVFS(mp);
-
-		bhv_remove_all_vfsops(vfsp, 0);
-		VFS_REMOVEBHV(vfsp, &mp->m_bhv);
-	}
-
 	xfs_icsb_destroy_counters(mp);
 }
 
@@ -1284,7 +1276,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 	xfs_errortag_clearall_umount(fsid, mp->m_fsname, 0);
 #endif
 	XFS_IODONE(vfsp);
-	xfs_mount_free(mp, 1);
+	xfs_mount_free(mp);
 	return 0;
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-13 18:08:02.000000000 +0200
@@ -64,8 +64,6 @@ struct xfs_extdelta;
 struct xfs_swapext;
 struct xfs_mru_cache;
 
-extern struct bhv_vfsops xfs_vfsops;
-
 #define	AIL_LOCK_T		lock_t
 #define	AIL_LOCKINIT(x,y)	spinlock_init(x,y)
 #define	AIL_LOCK_DESTROY(x)	spinlock_destroy(x)
@@ -330,7 +328,7 @@ extern void	xfs_icsb_sync_counters_flags
 #endif
 
 typedef struct xfs_mount {
-	bhv_desc_t		m_bhv;		/* vfs xfs behavior */
+	struct bhv_vfs		*m_vfsp;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	AIL_LOCK_T		m_ail_lock;	/* fs AIL mutex */
 	xfs_ail_entry_t		m_ail;		/* fs active log item list */
@@ -527,8 +525,10 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 #define XFS_LAST_UNMOUNT_WAS_CLEAN(mp)	\
 				((mp)->m_flags & XFS_MOUNT_WAS_CLEAN)
 #define XFS_FORCED_SHUTDOWN(mp)	((mp)->m_flags & XFS_MOUNT_FS_SHUTDOWN)
+void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
+		int lnnum);
 #define xfs_force_shutdown(m,f)	\
-	bhv_vfs_force_shutdown((XFS_MTOVFS(m)), f, __FILE__, __LINE__)
+	xfs_do_force_shutdown(m, f, __FILE__, __LINE__)
 
 /*
  * Flags for xfs_mountfs
@@ -548,20 +548,13 @@ xfs_preferred_iosize(xfs_mount_t *mp)
 #define	XFS_MTOVFS(mp)		xfs_mtovfs(mp)
 static inline struct bhv_vfs *xfs_mtovfs(xfs_mount_t *mp)
 {
-	return bhvtovfs(&mp->m_bhv);
-}
-
-#define	XFS_BHVTOM(bdp)	xfs_bhvtom(bdp)
-static inline xfs_mount_t *xfs_bhvtom(bhv_desc_t *bdp)
-{
-	return (xfs_mount_t *)BHV_PDATA(bdp);
+	return mp->m_vfsp;
 }
 
 #define XFS_VFSTOM(vfs) xfs_vfstom(vfs)
 static inline xfs_mount_t *xfs_vfstom(bhv_vfs_t *vfs)
 {
-	return XFS_BHVTOM(bhv_lookup_range(VFS_BHVHEAD(vfs),
-				VFS_POSITION_XFS, VFS_POSITION_XFS));
+	return vfs->vfs_mount;
 }
 
 #define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
@@ -633,7 +626,7 @@ typedef struct xfs_mod_sb {
 extern xfs_mount_t *xfs_mount_init(void);
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
-extern void	xfs_mount_free(xfs_mount_t *mp, int remove_bhv);
+extern void	xfs_mount_free(xfs_mount_t *mp);
 extern int	xfs_mountfs(struct bhv_vfs *, xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-13 18:08:02.000000000 +0200
@@ -439,7 +439,6 @@ xfs_mount(
 	cred_t			*credp)
 {
 	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
-	struct bhv_desc		*p;
 	struct block_device	*ddev, *logdev, *rtdev;
 	int			flags = 0, error;
 
@@ -453,11 +452,7 @@ xfs_mount(
 	if (error)
 		return error;
 
-	/*
-	 * Setup xfs_mount function vectors from available behaviors
-	 */
-	p = vfs_bhv_lookup(vfsp, VFS_POSITION_IO);
-	mp->m_io_ops = p ? *(xfs_ioops_t *) vfs_bhv_custom(p) : xfs_iocore_xfs;
+	mp->m_io_ops = xfs_iocore_xfs;
 
 	if (args->flags & XFSMNT_QUIET)
 		flags |= XFS_MFSI_QUIET;
@@ -740,7 +735,7 @@ xfs_mntupdate(
 		}
 	} else if (!(vfsp->vfs_flag & VFS_RDONLY)) {	/* rw -> ro */
 		xfs_filestream_flush(mp);
-		bhv_vfs_sync(vfsp, SYNC_DATA_QUIESCE, NULL);
+		xfs_sync(mp, SYNC_DATA_QUIESCE);
 		xfs_attr_quiesce(mp);
 		vfsp->vfs_flag |= VFS_RDONLY;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-08-13 18:08:02.000000000 +0200
@@ -24,8 +24,5 @@ int xfs_showargs(struct xfs_mount *mp, s
 void xfs_freeze(struct xfs_mount *mp);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
-struct inode *xfs_get_inode(struct xfs_mount *mp, xfs_ino_t ino, int flags);
-void xfs_initialize_vnode(struct xfs_mount *mp, bhv_vnode_t *vp,
-		struct xfs_inode *ip, int unlock);
 
 #endif /* _XFS_VFSOPS_H */
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops_bhv.c	2007-08-13 18:07:59.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,143 +0,0 @@
-
-#include "xfs_linux.h"
-#include "xfs_vfsops.h"
-
-#include "xfs_dmapi.h"
-#include "xfs_sb.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_mount.h"
-
-
-STATIC int
-xfs_bhv_mount(
-	struct bhv_desc		*bhvp,
-	struct xfs_mount_args	*args,
-	cred_t			*credp)
-{
-	return xfs_mount(XFS_BHVTOM(bhvp), args, credp);
-}
-
-STATIC int
-xfs_bhv_unmount(
-	bhv_desc_t	*bdp,
-	int		flags,
-	cred_t		*credp)
-{
-	return xfs_unmount(XFS_BHVTOM(bdp), flags, credp);
-}
-
-STATIC int
-xfs_bhv_mntupdate(
-	bhv_desc_t			*bdp,
-	int				*flags,
-	struct xfs_mount_args		*args)
-{
-	return xfs_mntupdate(XFS_BHVTOM(bdp), flags, args);
-}
-
-STATIC int
-xfs_bhv_root(
-	bhv_desc_t	*bdp,
-	bhv_vnode_t	**vpp)
-{
-	return xfs_root(XFS_BHVTOM(bdp), vpp);
-}
-
-STATIC int
-xfs_bhv_statvfs(
-	bhv_desc_t	*bdp,
-	bhv_statvfs_t	*statp,
-	bhv_vnode_t	*vp)
-{
-	return xfs_statvfs(XFS_BHVTOM(bdp), statp, vp);
-}
-
-STATIC int
-xfs_bhv_sync(
-	bhv_desc_t	*bdp,
-	int		flags,
-	cred_t		*credp)
-{
-	return xfs_sync(XFS_BHVTOM(bdp), flags);
-}
-
-STATIC int
-xfs_bhv_vget(
-	bhv_desc_t	*bdp,
-	bhv_vnode_t	**vpp,
-	fid_t		*fidp)
-{
-	return xfs_vget(XFS_BHVTOM(bdp), vpp, fidp);
-}
-
-STATIC int
-xfs_bhv_parseargs(
-	struct bhv_desc		*bhv,
-	char			*options,
-	struct xfs_mount_args	*args,
-	int			update)
-{
-	return xfs_parseargs(XFS_BHVTOM(bhv), options, args, update);
-}
-
-STATIC int
-xfs_bhv_showargs(
-	struct bhv_desc		*bhv,
-	struct seq_file		*m)
-{
-	return xfs_showargs(XFS_BHVTOM(bhv), m);
-}
-
-STATIC void
-xfs_bhv_freeze(
-	bhv_desc_t	*bdp)
-{
-	return xfs_freeze(XFS_BHVTOM(bdp));
-}
-
-STATIC void
-xfs_bhv_force_shutdown(
-	bhv_desc_t	*bdp,
-	int		flags,
-	char		*fname,
-	int		lnnum)
-{
-	return xfs_do_force_shutdown(XFS_BHVTOM(bdp), flags, fname, lnnum);
-}
-
-STATIC struct inode *
-xfs_bhv_get_inode(
-	bhv_desc_t	*bdp,
-	xfs_ino_t	ino,
-	int		flags)
-{
-	return xfs_get_inode(XFS_BHVTOM(bdp), ino, flags);
-}
-
-STATIC void
-xfs_bhv_initialize_vnode(
-	bhv_desc_t		*bdp,
-	bhv_vnode_t		*vp,
-	struct xfs_inode	*ip,
-	int			unlock)
-{
-	return xfs_initialize_vnode(XFS_BHVTOM(bdp), vp, ip, unlock);
-}
-
-bhv_vfsops_t xfs_vfsops = {
-	BHV_IDENTITY_INIT(VFS_BHV_XFS,VFS_POSITION_XFS),
-	.vfs_parseargs		= xfs_bhv_parseargs,
-	.vfs_showargs		= xfs_bhv_showargs,
-	.vfs_mount		= xfs_bhv_mount,
-	.vfs_unmount		= xfs_bhv_unmount,
-	.vfs_mntupdate		= xfs_bhv_mntupdate,
-	.vfs_root		= xfs_bhv_root,
-	.vfs_statvfs		= xfs_bhv_statvfs,
-	.vfs_sync		= xfs_bhv_sync,
-	.vfs_vget		= xfs_bhv_vget,
-	.vfs_get_inode		= xfs_bhv_get_inode,
-	.vfs_init_vnode		= xfs_bhv_initialize_vnode,
-	.vfs_force_shutdown	= xfs_bhv_force_shutdown,
-	.vfs_freeze		= xfs_bhv_freeze,
-};
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-13 18:07:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-13 18:08:02.000000000 +0200
@@ -1752,31 +1752,6 @@ printflags(register uint64_t flags,
 }
 
 
-static void printbhv(bhv_desc_t *bdp)
-{
-	int maxbhv = 20; /* if you get 20 bhvs you're in trouble already */
-	kdb_symtab_t	 symtab;
-
-	if (bdp == NULL) {
-		kdb_printf("NULL bhv\n");
-		return;
-	}
-
-	kdb_printf("bhv at 0x%p\n", bdp);
-	while (bdp && maxbhv--) {
-		if (kdbnearsym((unsigned long)bdp->bd_ops, &symtab))
-			kdb_printf("  ops %s", symtab.sym_name);
-		else
-			kdb_printf("  ops %s/0x%p", "???", (void *)bdp->bd_ops);
-
-		kdb_printf(" vobj 0x%p pdata 0x%p next 0x%p\n",
-			   bdp->bd_vobj, bdp->bd_pdata, bdp->bd_next);
-
-		bdp = bdp->bd_next;
-	}
-}
-
-
 static void	printvnode(bhv_vnode_t *vp, unsigned long addr)
 {
 	kdb_printf("vnode: 0x%lx\n", addr);
@@ -1815,34 +1790,6 @@ print_vfs(bhv_vfs_t *vfs, unsigned long 
 	kdb_printf("vfsp at 0x%lx", addr);
 	kdb_printf(" vfs_flag 0x%x\n", vfs->vfs_flag);
 	kdb_printf(" vfs_super 0x%p", vfs->vfs_super);
-	kdb_printf(" vfs_bh 0x%p\n", &vfs->vfs_bh);
-
-	printbhv(VFSHEAD(vfs));
-}
-
-static int	kdbm_bhv(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-	bhv_desc_t	*bh;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-
-	if (diag)
-		return diag;
-
-	bh = (bhv_desc_t *)addr;
-
-	printbhv(bh);
-
-	return 0;
 }
 
 static int	kdbm_vfs(
@@ -2479,7 +2426,6 @@ struct xif {
 };
 
 static struct xif xfsidbg_funcs[] = {
-  {  "bhv",	kdbm_bhv,	"<bhv>", "Dump bhv chain"},
   {  "vn",	kdbm_vn,	"<vnode>", "Dump inode/vnode/trace"},
   {  "vnode",	kdbm_vnode,	"<vnode>", "Dump vnode"},
   {  "vfs",	kdbm_vfs,	"<vfs>", "Dump vfs"},
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2007-08-13 18:07:59.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2007-08-13 18:08:02.000000000 +0200
@@ -76,6 +76,9 @@ struct block_device;
 
 extern __uint64_t xfs_max_file_offset(unsigned int);
 
+extern void xfs_initialize_vnode(struct xfs_mount *mp, bhv_vnode_t *vp,
+		struct xfs_inode *ip);
+
 extern void xfs_flush_inode(struct xfs_inode *);
 extern void xfs_flush_device(struct xfs_inode *);
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2007-08-13 18:07:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2007-08-13 18:08:02.000000000 +0200
@@ -1272,7 +1272,7 @@ xfs_ialloc(
 	xfs_trans_log_inode(tp, ip, flags);
 
 	/* now that we have an i_mode we can setup inode ops and unlock */
-	bhv_vfs_init_vnode(XFS_MTOVFS(tp->t_mountp), vp, ip, 1);
+	xfs_initialize_vnode(tp->t_mountp, vp, ip);
 
 	*ipp = ip;
 	return 0;
