Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:40:30 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJeN4p005674
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:40:26 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJeKA5008802
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:40:21 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJeKpt008800
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:40:20 +0200
Date: Thu, 23 Aug 2007 21:40:20 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 17/17] kill struct bhv_vfs
Message-ID: <20070823194020.GR8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


Now that struct bhv_vfs doesn't have any members left we can kill it
and go directly from the super_block to the xfs_mount everywhere.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fsops.c	2007-08-23 14:39:44.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fsops.c	2007-08-23 14:59:51.000000000 +0200
@@ -174,7 +174,7 @@ xfs_growfs_data_private(
 		memset(&mp->m_perag[oagcount], 0,
 			(nagcount - oagcount) * sizeof(xfs_perag_t));
 		mp->m_flags |= XFS_MOUNT_32BITINODES;
-		nagimax = xfs_initialize_perag(XFS_MTOVFS(mp), mp, nagcount);
+		nagimax = xfs_initialize_perag(mp, nagcount);
 		up_write(&mp->m_peraglock);
 	}
 	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
@@ -626,8 +626,7 @@ xfs_fs_goingdown(
 {
 	switch (inflags) {
 	case XFS_FSOP_GOING_FLAGS_DEFAULT: {
-		struct bhv_vfs *vfsp = XFS_MTOVFS(mp);
-		struct super_block *sb = freeze_bdev(vfsp->vfs_super->s_bdev);
+		struct super_block *sb = freeze_bdev(mp->m_super->s_bdev);
 
 		if (sb && !IS_ERR(sb)) {
 			xfs_force_shutdown(mp, SHUTDOWN_FORCE_UMOUNT);
Index: linux-2.6-xfs/fs/xfs/xfs_iocore.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iocore.c	2007-08-23 02:29:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iocore.c	2007-08-23 14:59:51.000000000 +0200
@@ -57,11 +57,11 @@ xfs_size_fn(
 
 STATIC int
 xfs_ioinit(
-	struct bhv_vfs		*vfsp,
+	struct xfs_mount	*mp,
 	struct xfs_mount_args	*mntargs,
 	int			flags)
 {
-	return xfs_mountfs(vfsp, XFS_VFSTOM(vfsp), flags);
+	return xfs_mountfs(mp, flags);
 }
 
 xfs_ioops_t	xfs_iocore_xfs = {
Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c	2007-08-23 14:57:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.c	2007-08-23 14:59:51.000000000 +0200
@@ -330,7 +330,6 @@ xfs_mount_validate_sb(
 
 xfs_agnumber_t
 xfs_initialize_perag(
-	bhv_vfs_t	*vfs,
 	xfs_mount_t	*mp,
 	xfs_agnumber_t	agcount)
 {
@@ -742,7 +741,6 @@ xfs_initialize_perag_data(xfs_mount_t *m
  */
 int
 xfs_mountfs(
-	bhv_vfs_t	*vfsp,
 	xfs_mount_t	*mp,
 	int		mfsi_flags)
 {
@@ -1019,7 +1017,7 @@ xfs_mountfs(
 	mp->m_perag =
 		kmem_zalloc(sbp->sb_agcount * sizeof(xfs_perag_t), KM_SLEEP);
 
-	mp->m_maxagi = xfs_initialize_perag(vfsp, mp, sbp->sb_agcount);
+	mp->m_maxagi = xfs_initialize_perag(mp, sbp->sb_agcount);
 
 	/*
 	 * log's mount-time initialization. Perform 1st part recovery if needed
@@ -1186,7 +1184,6 @@ xfs_mountfs(
 int
 xfs_unmountfs(xfs_mount_t *mp, struct cred *cr)
 {
-	struct bhv_vfs	*vfsp = XFS_MTOVFS(mp);
 	__uint64_t	resblks;
 
 	/*
@@ -1252,7 +1249,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 #if defined(DEBUG) || defined(INDUCE_IO_ERROR)
 	xfs_errortag_clearall(mp, 0);
 #endif
-	XFS_IODONE(vfsp);
+	XFS_IODONE(mp);
 	xfs_mount_free(mp);
 	return 0;
 }
@@ -1280,9 +1277,7 @@ xfs_unmountfs_wait(xfs_mount_t *mp)
 int
 xfs_fs_writable(xfs_mount_t *mp)
 {
-	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
-
-	return !(vfs_test_for_freeze(vfsp) || XFS_FORCED_SHUTDOWN(mp) ||
+	return !(xfs_test_for_freeze(mp) || XFS_FORCED_SHUTDOWN(mp) ||
 		(mp->m_flags & XFS_MOUNT_RDONLY));
 }
 
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-23 14:59:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-23 14:59:51.000000000 +0200
@@ -54,7 +54,6 @@ typedef struct xfs_trans_reservations {
 #else
 struct cred;
 struct log;
-struct bhv_vfs;
 struct xfs_mount_args;
 struct xfs_inode;
 struct xfs_iocore;
@@ -79,13 +78,13 @@ typedef int	(*xfs_send_data_t)(int, bhv_
 			xfs_off_t, size_t, int, bhv_vrwlock_t *);
 typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
 typedef int	(*xfs_send_destroy_t)(bhv_vnode_t *, dm_right_t);
-typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct bhv_vfs *,
+typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
 			bhv_vnode_t *,
 			dm_right_t, bhv_vnode_t *, dm_right_t,
 			char *, char *, mode_t, int, int);
 typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
 			char *, char *);
-typedef void	(*xfs_send_unmount_t)(struct bhv_vfs *, bhv_vnode_t *,
+typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, bhv_vnode_t *,
 			dm_right_t, mode_t, int, int);
 
 typedef struct xfs_dmops {
@@ -105,12 +104,12 @@ typedef struct xfs_dmops {
 	(*(mp)->m_dm_ops->xfs_send_destroy)(vp,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
-#define XFS_SEND_PREUNMOUNT(mp, vfs,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,vfs,b1,r1,b2,r2,n1,n2,mode,rval,fl)
+#define XFS_SEND_PREUNMOUNT(mp,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
+	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,mp,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 #define XFS_SEND_MOUNT(mp,right,path,name) \
 	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_UNMOUNT(mp, vfsp,vp,right,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_unmount)(vfsp,vp,right,mode,rval,fl)
+#define XFS_SEND_UNMOUNT(mp, vp,right,mode,rval,fl) \
+	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,vp,right,mode,rval,fl)
 
 
 /*
@@ -202,7 +201,7 @@ typedef struct xfs_qmops {
  * Prototypes and functions for I/O core modularization.
  */
 
-typedef int		(*xfs_ioinit_t)(struct bhv_vfs *,
+typedef int		(*xfs_ioinit_t)(struct xfs_mount *,
 				struct xfs_mount_args *, int);
 typedef int		(*xfs_bmapi_t)(struct xfs_trans *, void *,
 				xfs_fileoff_t, xfs_filblks_t, int,
@@ -232,7 +231,7 @@ typedef void		(*xfs_lock_demote_t)(void 
 typedef int		(*xfs_lock_nowait_t)(void *, uint);
 typedef void		(*xfs_unlk_t)(void *, unsigned int);
 typedef xfs_fsize_t	(*xfs_size_t)(void *);
-typedef xfs_fsize_t	(*xfs_iodone_t)(struct bhv_vfs *);
+typedef xfs_fsize_t	(*xfs_iodone_t)(struct xfs_mount *);
 typedef int		(*xfs_swap_extents_t)(void *, void *,
 				struct xfs_swapext*);
 
@@ -255,8 +254,8 @@ typedef struct xfs_ioops {
 	xfs_swap_extents_t		xfs_swap_extents_func;
 } xfs_ioops_t;
 
-#define XFS_IOINIT(vfsp, args, flags) \
-	(*(mp)->m_io_ops.xfs_ioinit)(vfsp, args, flags)
+#define XFS_IOINIT(mp, args, flags) \
+	(*(mp)->m_io_ops.xfs_ioinit)(mp, args, flags)
 #define XFS_BMAPI(mp, trans,io,bno,len,f,first,tot,mval,nmap,flist,delta) \
 	(*(mp)->m_io_ops.xfs_bmapi_func) \
 		(trans,(io)->io_obj,bno,len,f,first,tot,mval,nmap,flist,delta)
@@ -290,8 +289,8 @@ typedef struct xfs_ioops {
 	(*(mp)->m_io_ops.xfs_ilock_demote)((io)->io_obj, mode)
 #define XFS_SIZE(mp, io) \
 	(*(mp)->m_io_ops.xfs_size_func)((io)->io_obj)
-#define XFS_IODONE(vfsp) \
-	(*(mp)->m_io_ops.xfs_iodone)(vfsp)
+#define XFS_IODONE(mp) \
+	(*(mp)->m_io_ops.xfs_iodone)(mp)
 #define XFS_SWAP_EXTENTS(mp, io, tio, sxp) \
 	(*(mp)->m_io_ops.xfs_swap_extents_func) \
 		((io)->io_obj, (tio)->io_obj, sxp)
@@ -328,7 +327,7 @@ extern void	xfs_icsb_sync_counters_flags
 #endif
 
 typedef struct xfs_mount {
-	struct bhv_vfs		*m_vfsp;
+	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
 	AIL_LOCK_T		m_ail_lock;	/* fs AIL mutex */
 	xfs_ail_entry_t		m_ail;		/* fs active log item list */
@@ -548,21 +547,6 @@ void xfs_do_force_shutdown(struct xfs_mo
 /*	XFS_MFSI_CONVERT_SUNIT	*/
 #define XFS_MFSI_QUIET		0x40	/* Be silent if mount errors found */
 
-/*
- * Macros for getting from mount to vfs and back.
- */
-#define	XFS_MTOVFS(mp)		xfs_mtovfs(mp)
-static inline struct bhv_vfs *xfs_mtovfs(xfs_mount_t *mp)
-{
-	return mp->m_vfsp;
-}
-
-#define XFS_VFSTOM(vfs) xfs_vfstom(vfs)
-static inline xfs_mount_t *xfs_vfstom(bhv_vfs_t *vfs)
-{
-	return vfs->vfs_mount;
-}
-
 #define XFS_DADDR_TO_AGNO(mp,d)         xfs_daddr_to_agno(mp,d)
 static inline xfs_agnumber_t
 xfs_daddr_to_agno(struct xfs_mount *mp, xfs_daddr_t d)
@@ -633,7 +617,7 @@ extern xfs_mount_t *xfs_mount_init(void)
 extern void	xfs_mod_sb(xfs_trans_t *, __int64_t);
 extern int	xfs_log_sbcount(xfs_mount_t *, uint);
 extern void	xfs_mount_free(xfs_mount_t *mp);
-extern int	xfs_mountfs(struct bhv_vfs *, xfs_mount_t *mp, int);
+extern int	xfs_mountfs(xfs_mount_t *mp, int);
 extern void	xfs_mountfs_check_barriers(xfs_mount_t *mp);
 
 extern int	xfs_unmountfs(xfs_mount_t *, struct cred *);
@@ -651,8 +635,7 @@ extern void	xfs_freesb(xfs_mount_t *);
 extern int	xfs_fs_writable(xfs_mount_t *);
 extern int	xfs_syncsub(xfs_mount_t *, int, int *);
 extern int	xfs_sync_inodes(xfs_mount_t *, int, int *);
-extern xfs_agnumber_t	xfs_initialize_perag(struct bhv_vfs *, xfs_mount_t *,
-						xfs_agnumber_t);
+extern xfs_agnumber_t	xfs_initialize_perag(xfs_mount_t *, xfs_agnumber_t);
 extern void	xfs_sb_from_disk(struct xfs_sb *, struct xfs_dsb *);
 extern void	xfs_sb_to_disk(struct xfs_dsb *, struct xfs_sb *, __int64_t);
 extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-23 14:58:23.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-23 14:59:51.000000000 +0200
@@ -211,7 +211,6 @@ xfs_cleanup(void)
  */
 STATIC int
 xfs_start_flags(
-	struct bhv_vfs		*vfs,
 	struct xfs_mount_args	*ap,
 	struct xfs_mount	*mp)
 {
@@ -336,7 +335,6 @@ xfs_start_flags(
  */
 STATIC int
 xfs_finish_flags(
-	struct bhv_vfs		*vfs,
 	struct xfs_mount_args	*ap,
 	struct xfs_mount	*mp)
 {
@@ -438,11 +436,10 @@ xfs_mount(
 	struct xfs_mount_args	*args,
 	cred_t			*credp)
 {
-	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
 	struct block_device	*ddev, *logdev, *rtdev;
 	int			flags = 0, error;
 
-	ddev = vfsp->vfs_super->s_bdev;
+	ddev = mp->m_super->s_bdev;
 	logdev = rtdev = NULL;
 
 	error = xfs_dmops_get(mp, args);
@@ -510,13 +507,13 @@ xfs_mount(
 	/*
 	 * Setup flags based on mount(2) options and then the superblock
 	 */
-	error = xfs_start_flags(vfsp, args, mp);
+	error = xfs_start_flags(args, mp);
 	if (error)
 		goto error1;
 	error = xfs_readsb(mp, flags);
 	if (error)
 		goto error1;
-	error = xfs_finish_flags(vfsp, args, mp);
+	error = xfs_finish_flags(args, mp);
 	if (error)
 		goto error2;
 
@@ -547,7 +544,7 @@ xfs_mount(
 	if ((error = xfs_filestream_mount(mp)))
 		goto error2;
 
-	error = XFS_IOINIT(vfsp, args, flags);
+	error = XFS_IOINIT(mp, args, flags);
 	if (error)
 		goto error2;
 
@@ -577,7 +574,6 @@ xfs_unmount(
 	int		flags,
 	cred_t		*credp)
 {
-	bhv_vfs_t	*vfsp = XFS_MTOVFS(mp);
 	xfs_inode_t	*rip;
 	bhv_vnode_t	*rvp;
 	int		unmount_event_wanted = 0;
@@ -590,7 +586,7 @@ xfs_unmount(
 
 #ifdef HAVE_DMAPI
 	if (mp->m_flags & XFS_MOUNT_DMAPI) {
-		error = XFS_SEND_PREUNMOUNT(mp, vfsp,
+		error = XFS_SEND_PREUNMOUNT(mp,
 				rvp, DM_RIGHT_NULL, rvp, DM_RIGHT_NULL,
 				NULL, NULL, 0, 0,
 				(mp->m_dmevmask & (1<<DM_EVENT_PREUNMOUNT))?
@@ -647,7 +643,7 @@ out:
 		/* Note: mp structure must still exist for
 		 * XFS_SEND_UNMOUNT() call.
 		 */
-		XFS_SEND_UNMOUNT(mp, vfsp, error == 0 ? rvp : NULL,
+		XFS_SEND_UNMOUNT(mp, error == 0 ? rvp : NULL,
 			DM_RIGHT_NULL, 0, error, unmount_event_flags);
 	}
 	if (xfs_unmountfs_needed) {
Index: linux-2.6-xfs/fs/xfs/xfsidbg.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfsidbg.c	2007-08-23 14:57:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfsidbg.c	2007-08-23 14:59:51.000000000 +0200
@@ -1784,40 +1784,6 @@ static int	kdbm_vnode(
 	return 0;
 }
 
-static void
-print_vfs(bhv_vfs_t *vfs, unsigned long addr)
-{
-	kdb_printf("vfsp at 0x%lx", addr);
-	kdb_printf(" vfs_super 0x%p", vfs->vfs_super);
-}
-
-static int	kdbm_vfs(
-	int	argc,
-	const char **argv)
-{
-	unsigned long addr;
-	int nextarg = 1;
-	long offset = 0;
-	int diag;
-	bhv_vfs_t vfs;
-
-	if (argc != 1)
-		return KDB_ARGCOUNT;
-
-	diag = kdbgetaddrarg(argc, argv, &nextarg, &addr, &offset, NULL);
-
-	if (diag)
-		return diag;
-
-	if ((diag = kdb_getarea(vfs, addr)))
-		return diag;
-
-	print_vfs(&vfs, addr);
-
-	return 0;
-}
-
-
 #ifdef	XFS_VNODE_TRACE
 /*
  * Print a vnode trace entry.
@@ -2427,7 +2393,6 @@ struct xif {
 static struct xif xfsidbg_funcs[] = {
   {  "vn",	kdbm_vn,	"<vnode>", "Dump inode/vnode/trace"},
   {  "vnode",	kdbm_vnode,	"<vnode>", "Dump vnode"},
-  {  "vfs",	kdbm_vfs,	"<vfs>", "Dump vfs"},
 #ifdef XFS_VNODE_TRACE
   {  "vntrace",	kdbm_vntrace,	"<vntrace>", "Dump vnode Trace"},
   {  "vntraceaddr",	kdbm_vntraceaddr, "<vntrace>",
@@ -6503,8 +6468,8 @@ xfsidbg_xmount(xfs_mount_t *mp)
 	};
 
 	kdb_printf("xfs_mount at 0x%p\n", mp);
-	kdb_printf("vfsp 0x%p tid 0x%x ail_lock 0x%p &ail 0x%p\n",
-		XFS_MTOVFS(mp), mp->m_tid, &mp->m_ail_lock, &mp->m_ail);
+	kdb_printf("tid 0x%x ail_lock 0x%p &ail 0x%p\n",
+		mp->m_tid, &mp->m_ail_lock, &mp->m_ail);
 	kdb_printf("ail_gen 0x%x &sb 0x%p\n",
 		mp->m_ail_gen, &mp->m_sb);
 	kdb_printf("sb_lock 0x%p sb_bp 0x%p dev 0x%x logdev 0x%x rtdev 0x%x\n",
Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-08-23 14:59:51.000000000 +0200
@@ -97,7 +97,6 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   xfs_iops.o \
 				   xfs_lrw.o \
 				   xfs_super.o \
-				   xfs_vfs.o \
 				   xfs_vnode.o \
 				   xfs_ksyms.o) 
 
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:57:56.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:59:51.000000000 +0200
@@ -3290,7 +3290,7 @@ xfs_dm_send_destroy_event(
 STATIC int
 xfs_dm_send_namesp_event(
 	dm_eventtype_t	event,
-	bhv_vfs_t	*vfsp,		/* used by PREUNMOUNT */
+	struct xfs_mount *mp,
 	bhv_vnode_t	*vp1,
 	dm_right_t	vp1_right,
 	bhv_vnode_t	*vp2,
@@ -3305,7 +3305,7 @@ xfs_dm_send_namesp_event(
 
 	/* Returns positive errors to XFS */
 
-	error = dm_send_namesp_event(event, vfsp ? vfsp->vfs_super: NULL,
+	error = dm_send_namesp_event(event, mp ? mp->m_super : NULL,
 				    vn_to_inode(vp1), vp1_right,
 				    vp2 ? vn_to_inode(vp2) : NULL, vp2_right,
 				    name1, name2,
@@ -3322,9 +3322,7 @@ xfs_dm_send_mount_event(
 	char			*mtpt,
 	char			*fsname)
 {
-	struct bhv_vfs		*vfsp = XFS_MTOVFS(mp);
-
-	return dm_send_mount_event(vfsp->vfs_super, root_right,
+	return dm_send_mount_event(mp->m_super, root_right,
 			NULL, DM_RIGHT_NULL,
 			mp->m_rootip ? XFS_ITOV(mp->m_rootip) : NULL,
 			DM_RIGHT_NULL, mtpt, fsname);
@@ -3332,14 +3330,14 @@ xfs_dm_send_mount_event(
 
 STATIC void
 xfs_dm_send_unmount_event(
-	bhv_vfs_t	*vfsp,
+	struct xfs_mount *mp,
 	bhv_vnode_t	*vp,		/* NULL if unmount successful */
 	dm_right_t	vfsp_right,
 	mode_t		mode,
 	int		retcode,	/* errno, if unmount failed */
 	int		flags)
 {
-	dm_send_unmount_event(vfsp->vfs_super, vp ? vn_to_inode(vp) : NULL,
+	dm_send_unmount_event(mp->m_super, vp ? vn_to_inode(vp) : NULL,
 			      vfsp_right, mode, retcode, flags);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:59:51.000000000 +0200
@@ -180,7 +180,6 @@ EXPORT_SYMBOL(uuid_getnodeuniq);
 EXPORT_SYMBOL(uuid_hash64);
 EXPORT_SYMBOL(uuid_is_nil);
 EXPORT_SYMBOL(uuid_table_remove);
-EXPORT_SYMBOL(vfs_from_sb);
 EXPORT_SYMBOL(vn_hold);
 EXPORT_SYMBOL(vn_initialize);
 EXPORT_SYMBOL(vn_revalidate);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 14:44:55.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 14:59:51.000000000 +0200
@@ -678,7 +678,7 @@ xfs_write(
 	io = &xip->i_iocore;
 	mp = io->io_mount;
 
-	vfs_wait_for_freeze(XFS_MTOVFS(mp), SB_FREEZE_WRITE);
+	xfs_wait_for_freeze(mp, SB_FREEZE_WRITE);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:59:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-23 14:59:51.000000000 +0200
@@ -509,7 +509,7 @@ xfs_flush_device_work(
 	void		*arg)
 {
 	struct inode	*inode = arg;
-	sync_blockdev(mp->m_vfsp->vfs_super->s_bdev);
+	sync_blockdev(mp->m_super->s_bdev);
 	iput(inode);
 }
 
@@ -590,7 +590,6 @@ STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)
 {
-	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
 	struct xfs_mount	*mp = XFS_M(sb);
 	int			error;
 
@@ -598,12 +597,8 @@ xfs_fs_put_super(
 
 	xfs_sync(mp, SYNC_ATTR | SYNC_DELWRI);
 	error = xfs_unmount(mp, 0, NULL);
-	if (error) {
+	if (error)
 		printk("XFS: unmount got error=%d\n", error);
-		printk("%s: vfs=0x%p left dangling!\n", __FUNCTION__, vfsp);
-	} else {
-		vfs_deallocate(vfsp);
-	}
 }
 
 STATIC void
@@ -761,7 +756,6 @@ xfs_fs_fill_super(
 	int			silent)
 {
 	struct inode		*rootvp;
-	struct bhv_vfs		*vfsp = vfs_allocate(sb);
 	struct xfs_mount	*mp = NULL;
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
 	struct kstatfs		statvfs;
@@ -773,8 +767,8 @@ xfs_fs_fill_super(
 	spin_lock_init(&mp->m_sync_lock);
 	init_waitqueue_head(&mp->m_wait_single_sync_task);
 
-	mp->m_vfsp = vfsp;
-	vfsp->vfs_mount = mp;
+	mp->m_super = sb;
+	sb->s_fs_info = mp;
 
 	if (sb->s_flags & MS_RDONLY)
 		mp->m_flags |= XFS_MOUNT_RDONLY;
@@ -844,7 +838,6 @@ fail_unmount:
 	xfs_unmount(mp, 0, NULL);
 
 fail_vfsop:
-	vfs_deallocate(vfsp);
 	kmem_free(args, sizeof(*args));
 	return -error;
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.h	2007-08-23 14:59:51.000000000 +0200
@@ -89,7 +89,6 @@ extern void xfs_blkdev_issue_flush(struc
 
 extern struct export_operations xfs_export_operations;
 
-#define XFS_M(sb) \
-	XFS_VFSTOM(vfs_from_sb(sb))
+#define XFS_M(sb)		((struct xfs_mount *)((sb)->s_fs_info))
 
 #endif	/* __XFS_SUPER_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-23 14:59:49.000000000 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,59 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
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
-#include "xfs_inum.h"
-#include "xfs_log.h"
-#include "xfs_clnt.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_dir2.h"
-#include "xfs_imap.h"
-#include "xfs_alloc.h"
-#include "xfs_dmapi.h"
-#include "xfs_mount.h"
-#include "xfs_quota.h"
-
-bhv_vfs_t *
-vfs_allocate(
-	struct super_block	*sb)
-{
-	struct bhv_vfs		*vfsp;
-
-	vfsp = kmem_zalloc(sizeof(bhv_vfs_t), KM_SLEEP);
-
-	vfsp->vfs_super = sb;
-	sb->s_fs_info = vfsp;
-
-	return vfsp;
-}
-
-bhv_vfs_t *
-vfs_from_sb(
-	struct super_block	*sb)
-{
-	return (bhv_vfs_t *)sb->s_fs_info;
-}
-
-void
-vfs_deallocate(
-	struct bhv_vfs		*vfsp)
-{
-	kmem_free(vfsp, sizeof(bhv_vfs_t));
-}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:59:49.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-23 14:59:51.000000000 +0200
@@ -21,7 +21,6 @@
 #include <linux/vfs.h>
 #include "xfs_fs.h"
 
-struct bhv_vfs;
 struct inode;
 
 struct fid;
@@ -41,11 +40,6 @@ typedef struct bhv_vfs_sync_work {
 	void			(*w_syncer)(struct xfs_mount *, void *);
 } bhv_vfs_sync_work_t;
 
-typedef struct bhv_vfs {
-	struct xfs_mount	*vfs_mount;
-	struct super_block	*vfs_super;	/* generic superblock pointer */
-} bhv_vfs_t;
-
 #define SYNC_ATTR		0x0001	/* sync attributes */
 #define SYNC_CLOSE		0x0002	/* close file system down */
 #define SYNC_DELWRI		0x0004	/* look at delayed writes */
@@ -78,11 +72,7 @@ typedef struct bhv_vfs {
 #define SHUTDOWN_REMOTE_REQ	0x0010	/* shutdown came from remote cell */
 #define SHUTDOWN_DEVICE_REQ	0x0020	/* failed all paths to the device */
 
-#define vfs_test_for_freeze(vfs)	((vfs)->vfs_super->s_frozen)
-#define vfs_wait_for_freeze(vfs,l)	vfs_check_frozen((vfs)->vfs_super, (l))
-
-extern bhv_vfs_t *vfs_allocate(struct super_block *);
-extern bhv_vfs_t *vfs_from_sb(struct super_block *);
-extern void vfs_deallocate(bhv_vfs_t *);
+#define xfs_test_for_freeze(mp)		((mp)->m_super->s_frozen)
+#define xfs_wait_for_freeze(mp,l)	vfs_check_frozen((mp)->m_super, (l))
 
 #endif	/* __XFS_VFS_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:54:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-23 14:59:51.000000000 +0200
@@ -19,7 +19,6 @@
 #define __XFS_VNODE_H__
 
 struct file;
-struct bhv_vfs;
 struct bhv_vattr;
 struct xfs_iomap;
 struct attrlist_cursor_kern;
Index: linux-2.6-xfs/fs/xfs/xfs_iget.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_iget.c	2007-08-23 14:57:45.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_iget.c	2007-08-23 14:59:51.000000000 +0200
@@ -379,7 +379,7 @@ xfs_iget(
 	XFS_STATS_INC(xs_ig_attempts);
 
 retry:
-	inode = iget_locked(XFS_MTOVFS(mp)->vfs_super, ino);
+	inode = iget_locked(mp->m_super, ino);
 	if (inode) {
 		xfs_inode_t	*ip;
 
Index: linux-2.6-xfs/fs/xfs/xfs_trans.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_trans.c	2007-08-23 14:39:41.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_trans.c	2007-08-23 14:59:51.000000000 +0200
@@ -234,7 +234,7 @@ xfs_trans_alloc(
 	xfs_mount_t	*mp,
 	uint		type)
 {
-	vfs_wait_for_freeze(XFS_MTOVFS(mp), SB_FREEZE_TRANS);
+	xfs_wait_for_freeze(mp, SB_FREEZE_TRANS);
 	return _xfs_trans_alloc(mp, type);
 }
 
@@ -628,7 +628,7 @@ xfs_trans_apply_sb_deltas(
 				  offsetof(xfs_dsb_t, sb_frextents) +
 				  sizeof(sbp->sb_frextents) - 1);
 
-	XFS_MTOVFS(tp->t_mountp)->vfs_super->s_dirt = 1;
+	tp->t_mountp->m_super->s_dirt = 1;
 }
 
 /*
