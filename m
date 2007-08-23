Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:36 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJdS4p004404
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:32 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJdQA5008670
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:26 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJdQ1Q008668
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:26 +0200
Date: Thu, 23 Aug 2007 21:39:26 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/17 remove dependency of the dmapi module on behaviors.
Message-ID: <20070823193926.GK8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Mount options are now parsed by the main XFS module and rejected if dmapi
support is not available, and there is a new dm operation to send the
mount event.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 19:06:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 19:06:36.000000000 +0200
@@ -3073,7 +3073,6 @@ static fsys_function_vector_t	xfs_fsys_v
 
 int
 xfs_dm_get_fsys_vector(
-	bhv_desc_t	*bdp,
 	caddr_t		addr)
 {
 	static	int		initialized = 0;
@@ -3316,6 +3315,20 @@ xfs_dm_send_namesp_event(
 	return error; /* Return positive error to XFS */
 }
 
+STATIC int
+xfs_dm_send_mount_event(
+	struct xfs_mount	*mp,
+	dm_right_t		root_right,
+	char			*mtpt,
+	char			*fsname)
+{
+	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
+
+	return dm_send_mount_event(vfsp->vfs_super, root_right,
+			NULL, DM_RIGHT_NULL,
+			mp->m_rootip ? XFS_ITOV(mp->m_rootip) : NULL,
+			DM_RIGHT_NULL, mtpt, fsname);
+}
 
 STATIC void
 xfs_dm_send_unmount_event(
@@ -3341,5 +3354,25 @@ xfs_dmops_t	xfs_dmcore_xfs = {
 	.xfs_send_mmap		= xfs_dm_send_mmap_event,
 	.xfs_send_destroy	= xfs_dm_send_destroy_event,
 	.xfs_send_namesp	= xfs_dm_send_namesp_event,
+	.xfs_send_mount		= xfs_dm_send_mount_event,
 	.xfs_send_unmount	= xfs_dm_send_unmount_event,
 };
+EXPORT_SYMBOL(xfs_dmcore_xfs);
+
+static int __init
+xfs_dm_init(void)
+{
+	printk(KERN_INFO "SGI XFS Data Management API subsystem\n");
+
+	dmapi_register(&xfs_fs_type, &xfs_dmapiops);
+	return 0;
+}
+
+static void __exit
+xfs_dm_exit(void)
+{
+	dmapi_unregister(&xfs_fs_type);
+}
+
+module_init(xfs_dm_init);
+module_exit(xfs_dm_exit);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.h	2007-08-23 16:57:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.h	2007-08-23 19:06:36.000000000 +0200
@@ -18,9 +18,8 @@
 #ifndef __XFS_DM_H__
 #define __XFS_DM_H__
 
-extern int xfs_dm_get_fsys_vector(bhv_desc_t *, caddr_t);
+extern int xfs_dm_get_fsys_vector(caddr_t);
 
-extern xfs_dmops_t xfs_dmcore_xfs;
 extern struct file_system_type xfs_fs_type;
 extern struct filesystem_dmapi_operations xfs_dmapiops;
 
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_bhv.c	2007-08-23 19:06:32.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,179 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_inum.h"
-#include "xfs_clnt.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_alloc.h"
-#include "xfs_dmapi.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_alloc_btree.h"
-#include "xfs_ialloc_btree.h"
-#include "xfs_dir2_sf.h"
-#include "xfs_attr_sf.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_btree.h"
-#include "xfs_ialloc.h"
-#include "xfs_itable.h"
-#include "xfs_bmap.h"
-#include "xfs_rw.h"
-#include "xfs_acl.h"
-#include "xfs_attr.h"
-#include "xfs_inode_item.h"
-#include <dmapi.h>
-#include <dmapi_kern.h>
-#include "xfs_dm.h"
-
-/*
- * DMAPI behavior module routines
- */
-
-STATIC int
-xfs_dm_mount(
-	struct bhv_desc		*bhv,
-	struct xfs_mount_args	*args,
-	struct cred		*cr)
-{
-	bhv_vnode_t		*rootvp;
-	struct bhv_vfs		*vfsp = bhvtovfs(bhv);
-	int			error = 0;
-
-	/* Returns positive errors to XFS */
-
-	error = bhv_next_vfs_mount(BHV_NEXT(bhv), args, cr);
-	if (error)
-		return error;
-	if (!(args->flags & XFSMNT_DMAPI))
-		return 0;
-	error = bhv_vfs_root(vfsp, &rootvp);
-	if (error)
-		return error;
-
-
-	vfsp->vfs_flag |= VFS_DMI;
-	error = dm_send_mount_event(vfsp->vfs_super,
-			DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
-			vn_to_inode(rootvp),
-			DM_RIGHT_NULL, args->mtpt, args->fsname);
-
-	VN_RELE(rootvp);
-	if (error)
-		error = -error; /* DMAPI returns negative errs */
-	return error;
-}
-
-#define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
-#define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
-#define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
-
-STATIC int
-xfs_dm_parseargs(
-	struct bhv_desc		*bhv,
-	char			*options,
-	struct xfs_mount_args	*args,
-	int			update)
-{
-	size_t			length;
-	char			*local_options = options;
-	char			*this_char;
-	int			error;
-
-	/* Returns positive errors to XFS */
-
-	while ((this_char = strsep(&local_options, ",")) != NULL) {
-		length = strlen(this_char);
-		if (local_options)
-			length++;
-
-		if (!strcmp(this_char, MNTOPT_DMAPI)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else if (!strcmp(this_char, MNTOPT_DMI)) {
-			args->flags |= XFSMNT_DMAPI;
-		} else {
-			if (local_options)
-				*(local_options-1) = ',';
-			continue;
-		}
-
-		while (length--)
-			*this_char++ = ',';
-	}
-
-	error = bhv_next_vfs_parseargs(BHV_NEXT(bhv), options, args, update);
-	if (!error && (args->flags & XFSMNT_DMAPI) && (*args->mtpt == '\0')) {
-		printk("XFS: %s option needs the mount point option as well\n",
-			MNTOPT_DMAPI);
-		error = EINVAL;
-	}
-	if (!error && !update && !(args->flags & XFSMNT_DMAPI))
-		bhv_remove_vfsops(bhvtovfs(bhv), VFS_POSITION_DM);
-	return error;
-}
-
-STATIC int
-xfs_dm_showargs(
-	struct bhv_desc		*bhv,
-	struct seq_file		*m)
-{
-	if (bhvtovfs(bhv)->vfs_flag & VFS_DMI)
-		seq_puts(m, "," MNTOPT_DMAPI);
-	return bhv_next_vfs_showargs(BHV_NEXT(bhv), m);
-}
-
-struct bhv_module_vfsops xfs_dmops = { {
-	BHV_IDENTITY_INIT(VFS_BHV_DM, VFS_POSITION_DM),
-	.vfs_mount		= xfs_dm_mount,
-	.vfs_parseargs		= xfs_dm_parseargs,
-	.vfs_showargs		= xfs_dm_showargs,
-	.vfs_dmapiops		= xfs_dm_get_fsys_vector, },
-};
-
-static int __init
-xfs_dm_init(void)
-{
-	static char	message[] __initdata =
-		KERN_INFO "SGI XFS Data Management API subsystem\n";
-
-	printk(message);
-	vfs_bhv_set_custom(&xfs_dmops, &xfs_dmcore_xfs);
-	bhv_module_init(XFS_DMOPS, THIS_MODULE, &xfs_dmops);
-	dmapi_register(&xfs_fs_type, &xfs_dmapiops);
-	return 0;
-}
-
-static void __exit
-xfs_dm_exit(void)
-{
-	dmapi_unregister(&xfs_fs_type);
-	bhv_module_exit(XFS_DMOPS);
-	vfs_bhv_clr_custom(&xfs_dmops);
-}
-
-module_init(xfs_dm_init);
-module_exit(xfs_dm_exit);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 19:03:03.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-23 19:06:36.000000000 +0200
@@ -112,7 +112,7 @@ xfs_dm_get_dmapiops(
 	struct super_block	*sb,
 	void			*addr)
 {
-	return -bhv_vfs_dmapiops(vfs_from_sb(sb), (caddr_t)addr);
+	return -xfs_dm_get_fsys_vector(addr);
 }
 
 STATIC void
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 18:58:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 19:06:36.000000000 +0200
@@ -199,7 +199,6 @@ EXPORT_SYMBOL(vfs_root);
 EXPORT_SYMBOL(vfs_statvfs);
 EXPORT_SYMBOL(vfs_sync);
 EXPORT_SYMBOL(vfs_vget);
-EXPORT_SYMBOL(vfs_dmapiops);
 EXPORT_SYMBOL(vfs_quotactl);
 EXPORT_SYMBOL(vfs_get_inode);
 EXPORT_SYMBOL(vfs_init_vnode);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 19:06:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 19:06:36.000000000 +0200
@@ -156,19 +156,6 @@ vfs_vget(
 }
 
 int
-vfs_dmapiops(
-	struct bhv_desc		*bdp,
-	caddr_t			addr)
-{
-	struct bhv_desc		*next = bdp;
-
-	ASSERT(next);
-	while (! (bhvtovfsops(next))->vfs_dmapiops)
-		next = BHV_NEXT(next);
-	return ((*bhvtovfsops(next)->vfs_dmapiops)(next, addr));
-}
-
-int
 vfs_quotactl(
 	struct bhv_desc		*bdp,
 	int			cmd,
@@ -404,7 +391,6 @@ bhv_remove_all_vfsops(
 	struct xfs_mount	*mp;
 
 	bhv_remove_vfsops(vfsp, VFS_POSITION_QM);
-	bhv_remove_vfsops(vfsp, VFS_POSITION_DM);
 	bhv_remove_vfsops(vfsp, VFS_POSITION_IO);
 	if (!freebase)
 		return;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 19:06:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 19:06:36.000000000 +0200
@@ -66,14 +66,12 @@ typedef struct bhv_vfs {
 typedef enum {
 	VFS_BHV_UNKNOWN,	/* not specified */
 	VFS_BHV_XFS,		/* xfs */
-	VFS_BHV_DM,		/* data migration */
 	VFS_BHV_QM,		/* quota manager */
 	VFS_BHV_IO,		/* IO path */
 	VFS_BHV_END		/* housekeeping end-of-range */
 } bhv_vfs_type_t;
 
 #define VFS_POSITION_XFS	(BHV_POSITION_BASE)
-#define VFS_POSITION_DM		(VFS_POSITION_BASE+10)
 #define VFS_POSITION_QM		(VFS_POSITION_BASE+20)
 #define VFS_POSITION_IO		(VFS_POSITION_BASE+30)
 
@@ -129,7 +127,6 @@ typedef int	(*vfs_statvfs_t)(bhv_desc_t 
 				struct inode *);
 typedef int	(*vfs_sync_t)(bhv_desc_t *, int, struct cred *);
 typedef int	(*vfs_vget_t)(bhv_desc_t *, struct inode **, struct fid *);
-typedef int	(*vfs_dmapiops_t)(bhv_desc_t *, caddr_t);
 typedef int	(*vfs_quotactl_t)(bhv_desc_t *, int, int, caddr_t);
 typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
 				struct inode *, struct xfs_inode *, int);
@@ -148,7 +145,6 @@ typedef struct bhv_vfsops {
 	vfs_statvfs_t		vfs_statvfs;	/* file system statistics */
 	vfs_sync_t		vfs_sync;	/* flush files */
 	vfs_vget_t		vfs_vget;	/* get vnode from fid */
-	vfs_dmapiops_t		vfs_dmapiops;	/* data migration */
 	vfs_quotactl_t		vfs_quotactl;	/* disk quota */
 	vfs_get_inode_t		vfs_get_inode;	/* bhv specific iget */
 	vfs_init_vnode_t	vfs_init_vnode;	/* initialize a new vnode */
@@ -169,7 +165,6 @@ typedef struct bhv_vfsops {
 #define bhv_vfs_statvfs(v, sp,vp)	vfs_statvfs(VFSHEAD(v), sp,vp)
 #define bhv_vfs_sync(v, flag,cr)	vfs_sync(VFSHEAD(v), flag,cr)
 #define bhv_vfs_vget(v, vpp,fidp)	vfs_vget(VFSHEAD(v), vpp,fidp)
-#define bhv_vfs_dmapiops(v, p)		vfs_dmapiops(VFSHEAD(v), p)
 #define bhv_vfs_quotactl(v, c,id,p)	vfs_quotactl(VFSHEAD(v), c,id,p)
 #define bhv_vfs_get_inode(v, ino, fl)	vfs_get_inode(VFSHEAD(v), ino,fl)
 #define bhv_vfs_init_vnode(v, vp,b,ul)	vfs_init_vnode(VFSHEAD(v), vp,b,ul)
@@ -188,7 +183,6 @@ typedef struct bhv_vfsops {
 #define bhv_next_vfs_statvfs(b, sp,vp)		vfs_statvfs(b, sp,vp)
 #define bhv_next_vfs_sync(b, flag,cr)		vfs_sync(b, flag,cr)
 #define bhv_next_vfs_vget(b, vpp,fidp)		vfs_vget(b, vpp,fidp)
-#define bhv_next_vfs_dmapiops(b, p)		vfs_dmapiops(b, p)
 #define bhv_next_vfs_quotactl(b, c,id,p)	vfs_quotactl(b, c,id,p)
 #define bhv_next_vfs_get_inode(b, ino,fl)	vfs_get_inode(b, ino,fl)
 #define bhv_next_vfs_init_vnode(b, vp,b2,ul)	vfs_init_vnode(b, vp,b2,ul)
@@ -204,7 +198,6 @@ extern int vfs_root(bhv_desc_t *, struct
 extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct inode *);
 extern int vfs_sync(bhv_desc_t *, int, struct cred *);
 extern int vfs_vget(bhv_desc_t *, struct inode **, struct fid *);
-extern int vfs_dmapiops(bhv_desc_t *, caddr_t);
 extern int vfs_quotactl(bhv_desc_t *, int, int, caddr_t);
 extern struct inode *vfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
 extern void vfs_init_vnode(bhv_desc_t *, struct inode *, struct xfs_inode *, int);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 19:06:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 19:07:10.000000000 +0200
@@ -326,6 +326,8 @@ xfs_start_flags(
 	if (ap->flags2 & XFSMNT2_FILESTREAMS)
 		mp->m_flags |= XFS_MOUNT_FILESTREAMS;
 
+	if (ap->flags & XFSMNT_DMAPI)
+		vfs->vfs_flag |= VFS_DMI;
 	return 0;
 }
 
@@ -430,11 +432,13 @@ xfs_mount(
 	ddev = vfsp->vfs_super->s_bdev;
 	logdev = rtdev = NULL;
 
+	error = xfs_dmops_get(mp, args);
+	if (error)
+		return error;
+
 	/*
 	 * Setup xfs_mount function vectors from available behaviors
 	 */
-	p = vfs_bhv_lookup(vfsp, VFS_POSITION_DM);
-	mp->m_dm_ops = p ? *(xfs_dmops_t *) vfs_bhv_custom(p) : xfs_dmcore_stub;
 	p = vfs_bhv_lookup(vfsp, VFS_POSITION_QM);
 	mp->m_qm_ops = p ? *(xfs_qmops_t *) vfs_bhv_custom(p) : xfs_qmcore_stub;
 	p = vfs_bhv_lookup(vfsp, VFS_POSITION_IO);
@@ -537,6 +541,8 @@ xfs_mount(
 	if (error)
 		goto error2;
 
+	XFS_SEND_MOUNT(mp, DM_RIGHT_NULL, args->mtpt, args->fsname);
+
 	return 0;
 
 error2:
@@ -550,6 +556,7 @@ error1:
 		xfs_binval(mp->m_rtdev_targp);
 error0:
 	xfs_unmountfs_close(mp, credp);
+	xfs_dmops_put(mp);
 	return error;
 }
 
@@ -640,6 +647,7 @@ out:
 		 * and free the super block buffer & mount structures.
 		 */
 		xfs_unmountfs(mp, credp);
+		xfs_dmops_put(mp);
 		kmem_free(mp, sizeof(xfs_mount_t));
 	}
 
@@ -1688,6 +1696,9 @@ xfs_vget(
 #define MNTOPT_ATTR2	"attr2"		/* do use attr2 attribute format */
 #define MNTOPT_NOATTR2	"noattr2"	/* do not use attr2 attribute format */
 #define MNTOPT_FILESTREAM  "filestreams" /* use filestreams allocator */
+#define MNTOPT_DMAPI	"dmapi"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_XDSM	"xdsm"		/* DMI enabled (DMAPI / XDSM) */
+#define MNTOPT_DMI	"dmi"		/* DMI enabled (DMAPI / XDSM) */
 
 STATIC unsigned long
 suffix_strtoul(char *s, char **endp, unsigned int base)
@@ -1867,6 +1878,12 @@ xfs_parseargs(
 			args->flags &= ~XFSMNT_ATTR2;
 		} else if (!strcmp(this_char, MNTOPT_FILESTREAM)) {
 			args->flags2 |= XFSMNT2_FILESTREAMS;
+		} else if (!strcmp(this_char, MNTOPT_DMAPI)) {
+			args->flags |= XFSMNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_XDSM)) {
+			args->flags |= XFSMNT_DMAPI;
+		} else if (!strcmp(this_char, MNTOPT_DMI)) {
+			args->flags |= XFSMNT_DMAPI;
 		} else if (!strcmp(this_char, "ihashsize")) {
 			cmn_err(CE_WARN,
 	"XFS: ihashsize no longer used, option is deprecated.");
@@ -1898,6 +1915,12 @@ xfs_parseargs(
 		return EINVAL;
 	}
 
+	if ((args->flags & XFSMNT_DMAPI) && *args->mtpt == '\0') {
+		printk("XFS: %s option needs the mount point option as well\n",
+			MNTOPT_DMAPI);
+		return EINVAL;
+	}
+
 	if ((dsunit && !dswidth) || (!dsunit && dswidth)) {
 		cmn_err(CE_WARN,
 			"XFS: sunit and swidth must be specified together");
@@ -1991,6 +2014,9 @@ xfs_showargs(
 	if (vfsp->vfs_flag & VFS_GRPID)
 		seq_printf(m, "," MNTOPT_GRPID);
 
+	if (vfsp->vfs_flag & VFS_DMI)
+		seq_puts(m, "," MNTOPT_DMAPI);
+
 	return 0;
 }
 
@@ -2021,7 +2047,6 @@ bhv_vfsops_t xfs_vfsops = {
 	.vfs_statvfs		= xfs_statvfs,
 	.vfs_sync		= xfs_sync,
 	.vfs_vget		= xfs_vget,
-	.vfs_dmapiops		= (vfs_dmapiops_t)fs_nosys,
 	.vfs_quotactl		= (vfs_quotactl_t)fs_nosys,
 	.vfs_get_inode		= xfs_get_inode,
 	.vfs_init_vnode		= xfs_initialize_vnode,
Index: linux-2.6-xfs/fs/xfs/dmapi/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/Makefile-linux-2.6	2007-08-23 16:57:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/Makefile-linux-2.6	2007-08-23 19:06:36.000000000 +0200
@@ -25,6 +25,5 @@ endif
 
 obj-$(CONFIG_XFS_DMAPI)		+= xfs_dmapi.o
 
-xfs_dmapi-y			+= xfs_dm_bhv.o \
-				   xfs_dm_fsops.o \
+xfs_dmapi-y			+= xfs_dm_fsops.o \
 				   xfs_dm.o
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-23 19:06:32.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-23 19:06:36.000000000 +0200
@@ -85,6 +85,8 @@ typedef int	(*xfs_send_namesp_t)(dm_even
 			bhv_vnode_t *,
 			dm_right_t, bhv_vnode_t *, dm_right_t,
 			char *, char *, mode_t, int, int);
+typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
+			char *, char *);
 typedef void	(*xfs_send_unmount_t)(struct bhv_vfs *, bhv_vnode_t *,
 			dm_right_t, mode_t, int, int);
 
@@ -93,21 +95,24 @@ typedef struct xfs_dmops {
 	xfs_send_mmap_t		xfs_send_mmap;
 	xfs_send_destroy_t	xfs_send_destroy;
 	xfs_send_namesp_t	xfs_send_namesp;
+	xfs_send_mount_t	xfs_send_mount;
 	xfs_send_unmount_t	xfs_send_unmount;
 } xfs_dmops_t;
 
 #define XFS_SEND_DATA(mp, ev,vp,off,len,fl,lock) \
-	(*(mp)->m_dm_ops.xfs_send_data)(ev,vp,off,len,fl,lock)
+	(*(mp)->m_dm_ops->xfs_send_data)(ev,vp,off,len,fl,lock)
 #define XFS_SEND_MMAP(mp, vma,fl) \
-	(*(mp)->m_dm_ops.xfs_send_mmap)(vma,fl)
+	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
 #define XFS_SEND_DESTROY(mp, vp,right) \
-	(*(mp)->m_dm_ops.xfs_send_destroy)(vp,right)
+	(*(mp)->m_dm_ops->xfs_send_destroy)(vp,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops.xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
+	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 #define XFS_SEND_PREUNMOUNT(mp, vfs,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops.xfs_send_namesp)(DM_EVENT_PREUNMOUNT,vfs,b1,r1,b2,r2,n1,n2,mode,rval,fl)
+	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,vfs,b1,r1,b2,r2,n1,n2,mode,rval,fl)
+#define XFS_SEND_MOUNT(mp,right,path,name) \
+	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
 #define XFS_SEND_UNMOUNT(mp, vfsp,vp,right,mode,rval,fl) \
-	(*(mp)->m_dm_ops.xfs_send_unmount)(vfsp,vp,right,mode,rval,fl)
+	(*(mp)->m_dm_ops->xfs_send_unmount)(vfsp,vp,right,mode,rval,fl)
 
 
 /*
@@ -407,7 +412,7 @@ typedef struct xfs_mount {
 	uint			m_chsize;	/* size of next field */
 	struct xfs_chash	*m_chash;	/* fs private inode per-cluster
 						 * hash table */
-	struct xfs_dmops	m_dm_ops;	/* vector of DMI ops */
+	struct xfs_dmops	*m_dm_ops;	/* vector of DMI ops */
 	struct xfs_qmops	m_qm_ops;	/* vector of XQM ops */
 	struct xfs_ioops	m_io_ops;	/* vector of I/O ops */
 	atomic_t		m_active_trans;	/* number trans frozen */
@@ -642,7 +647,10 @@ extern void	xfs_sb_from_disk(struct xfs_
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
 
-extern struct xfs_dmops xfs_dmcore_stub;
+extern int	xfs_dmops_get(struct xfs_mount *, struct xfs_mount_args *);
+extern void	xfs_dmops_put(struct xfs_mount *);
+
+extern struct xfs_dmops xfs_dmcore_xfs;
 extern struct xfs_qmops xfs_qmcore_stub;
 extern struct xfs_ioops xfs_iocore_xfs;
 
Index: linux-2.6-xfs/fs/xfs/xfs_dmapi.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dmapi.h	2007-08-23 16:57:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dmapi.h	2007-08-23 19:06:36.000000000 +0200
@@ -168,7 +168,4 @@ typedef enum {
 			DM_FLAGS_NDELAY : 0)
 #define AT_DELAY_FLAG(f) ((f&ATTR_NONBLOCK) ? DM_FLAGS_NDELAY : 0)
 
-
-extern struct bhv_module_vfsops xfs_dmops;
-
 #endif  /* __XFS_DMAPI_H__ */
Index: linux-2.6-xfs/fs/xfs/xfs_dmops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dmops.c	2007-08-23 16:57:13.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dmops.c	2007-08-23 19:06:36.000000000 +0200
@@ -19,18 +19,51 @@
 #include "xfs_fs.h"
 #include "xfs_types.h"
 #include "xfs_log.h"
-#include "xfs_inum.h"
 #include "xfs_trans.h"
 #include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
 #include "xfs_dmapi.h"
+#include "xfs_inum.h"
+#include "xfs_ag.h"
 #include "xfs_mount.h"
+#include "xfs_clnt.h"
+
 
-xfs_dmops_t	xfs_dmcore_stub = {
+static struct xfs_dmops xfs_dmcore_stub = {
 	.xfs_send_data		= (xfs_send_data_t)fs_nosys,
 	.xfs_send_mmap		= (xfs_send_mmap_t)fs_noerr,
 	.xfs_send_destroy	= (xfs_send_destroy_t)fs_nosys,
 	.xfs_send_namesp	= (xfs_send_namesp_t)fs_nosys,
-	.xfs_send_unmount	= (xfs_send_unmount_t)fs_noval,
+	.xfs_send_mount		= (xfs_send_mount_t)fs_nosys,
+	.xfs_send_unmount	= (xfs_send_unmount_t)fs_noerr,
 };
+
+int
+xfs_dmops_get(struct xfs_mount *mp, struct xfs_mount_args *args)
+{
+	if (args->flags & XFSMNT_DMAPI) {
+		struct xfs_dmops *ops;
+
+		ops = symbol_get(xfs_dmcore_xfs);
+		if (!ops) {
+			request_module("xfs_dmapi");
+			ops = symbol_get(xfs_dmcore_xfs);
+		}
+
+		if (!ops) {
+			cmn_err(CE_WARN, "XFS: no dmapi support available.");
+			return EINVAL;
+		}
+		mp->m_dm_ops = ops;
+	} else {
+		mp->m_dm_ops = &xfs_dmcore_stub;
+	}
+
+	return 0;
+}
+
+void
+xfs_dmops_put(struct xfs_mount *mp)
+{
+	if (mp->m_dm_ops != &xfs_dmcore_stub)
+		symbol_put(xfs_dmcore_xfs);
+}
