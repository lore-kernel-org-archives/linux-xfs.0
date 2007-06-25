Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Jun 2007 22:45:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5P5jTdo017156
	for <xfs@oss.sgi.com>; Sun, 24 Jun 2007 22:45:30 -0700
Received: from Liberator.local (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 922C518011EA0
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 00:19:15 -0500 (CDT)
Message-ID: <467F5053.4040108@sandeen.net>
Date: Mon, 25 Jun 2007 00:19:15 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] simplify vnode tracing calls
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Don't think I've sent this one yet... :)

 linux-2.4/xfs_aops.c  |    2 +-
 linux-2.4/xfs_ioctl.c |    2 +-
 linux-2.4/xfs_super.c |    6 +++---
 linux-2.4/xfs_vnode.c |    4 ++--
 linux-2.4/xfs_vnode.h |   11 ++++++-----
 linux-2.6/xfs_aops.c  |    2 +-
 linux-2.6/xfs_ioctl.c |    2 +-
 linux-2.6/xfs_super.c |    6 +++---
 linux-2.6/xfs_vnode.c |    4 ++--
 linux-2.6/xfs_vnode.h |   11 ++++++-----
 xfs_iget.c            |    4 ++--
 xfs_rename.c          |    4 ++--
 xfs_utils.c           |    2 +-
 xfs_vnodeops.c        |   48 ++++++++++++++++++++++--------------------------
 14 files changed, 53 insertions(+), 55 deletions(-)

Simplify vnode tracing calls by embedding function name & return addr
in the calling macro.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Index: linux/fs/xfs/linux-2.4/xfs_aops.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_aops.c
+++ linux/fs/xfs/linux-2.4/xfs_aops.c
@@ -964,7 +964,7 @@ xfs_vm_bmap(
 	struct inode		*inode = (struct inode *)mapping->host;
 	bhv_vnode_t		*vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	bhv_vop_rwlock(vp, VRWLOCK_READ);
 	bhv_vop_flush_pages(vp, (xfs_off_t)0, -1, 0, FI_REMAPF);
Index: linux/fs/xfs/linux-2.4/xfs_ioctl.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_ioctl.c
+++ linux/fs/xfs/linux-2.4/xfs_ioctl.c
@@ -702,7 +702,7 @@ xfs_ioctl(
 
 	vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, "xfs_ioctl", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
Index: linux/fs/xfs/linux-2.4/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_super.c
+++ linux/fs/xfs/linux-2.4/xfs_super.c
@@ -374,7 +374,7 @@ xfs_fs_write_inode(
 	int			error, flags = FLUSH_INODE;
 
 	if (vp) {
-		vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+		VN_TRACE_ENTRY(vp);
 		if (sync)
 			flags |= FLUSH_SYNC;
 		error = bhv_vop_iflush(vp, flags);
@@ -389,7 +389,7 @@ xfs_fs_clear_inode(
 {
 	bhv_vnode_t		*vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
@@ -948,7 +948,7 @@ xfs_fs_read_super(
 		goto fail_vnrele;
 	if (xfs_fs_start_syncd(vfsp))
 		goto fail_vnrele;
-	vn_trace_exit(rootvp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_EXIT(rootvp);
 
 	kmem_free(args, sizeof(*args));
 	return sb;
Index: linux/fs/xfs/linux-2.4/xfs_vnode.c
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_vnode.c
+++ linux/fs/xfs/linux-2.4/xfs_vnode.c
@@ -65,7 +65,7 @@ vn_initialize(
 	vp->v_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
 #endif	/* XFS_VNODE_TRACE */
 
-	vn_trace_exit(vp, "vn_initialize", (inst_t *)__return_address);
+	VN_TRACE_EXIT(vp);
 	return vp;
 }
 
@@ -118,7 +118,7 @@ vn_revalidate(
 	bhv_vattr_t	va;
 	int		error;
 
-	vn_trace_entry(vp, "vn_revalidate", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 	ASSERT(VNHEAD(vp) != NULL);
 
 	va.va_mask = XFS_AT_STAT|XFS_AT_XFLAGS;
Index: linux/fs/xfs/linux-2.4/xfs_vnode.h
===================================================================
--- linux.orig/fs/xfs/linux-2.4/xfs_vnode.h
+++ linux/fs/xfs/linux-2.4/xfs_vnode.h
@@ -572,15 +572,16 @@ extern void vn_trace_hold(struct bhv_vno
 extern void vn_trace_ref(struct bhv_vnode *, char *, int, inst_t *);
 extern void vn_trace_rele(struct bhv_vnode *, char *, int, inst_t *);
 
-#define	VN_TRACE(vp)		\
-	vn_trace_ref(vp, __FILE__, __LINE__, (inst_t *)__return_address)
+#define VN_TRACE_ENTRY(vp)	\
+	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address)
+#define VN_TRACE_EXIT(vp)	\
+	vn_trace_exit(vp, __FUNCTION__, (inst_t *)__return_address)
 #else
-#define	vn_trace_entry(a,b,c)
-#define	vn_trace_exit(a,b,c)
+#define	VN_TRACE_ENTRY(a)
+#define	VN_TRACE_EXIT(a)
 #define	vn_trace_hold(a,b,c,d)
 #define	vn_trace_ref(a,b,c,d)
 #define	vn_trace_rele(a,b,c,d)
-#define	VN_TRACE(vp)
 #endif
 
 #endif	/* __XFS_VNODE_H__ */
Index: linux/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_aops.c
+++ linux/fs/xfs/linux-2.6/xfs_aops.c
@@ -1529,7 +1529,7 @@ xfs_vm_bmap(
 	struct inode		*inode = (struct inode *)mapping->host;
 	bhv_vnode_t		*vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 	bhv_vop_rwlock(vp, VRWLOCK_READ);
 	bhv_vop_flush_pages(vp, (xfs_off_t)0, -1, 0, FI_REMAPF);
 	bhv_vop_rwunlock(vp, VRWLOCK_READ);
Index: linux/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_ioctl.c
+++ linux/fs/xfs/linux-2.6/xfs_ioctl.c
@@ -708,7 +708,7 @@ xfs_ioctl(
 
 	vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, "xfs_ioctl", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
Index: linux/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_super.c
+++ linux/fs/xfs/linux-2.6/xfs_super.c
@@ -415,7 +415,7 @@ xfs_fs_write_inode(
 	int			error = 0, flags = FLUSH_INODE;
 
 	if (vp) {
-		vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+		VN_TRACE_ENTRY(vp);
 		if (sync)
 			flags |= FLUSH_SYNC;
 		error = bhv_vop_iflush(vp, flags);
@@ -431,7 +431,7 @@ xfs_fs_clear_inode(
 {
 	bhv_vnode_t		*vp = vn_from_inode(inode);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
@@ -844,7 +844,7 @@ xfs_fs_fill_super(
 	}
 	if ((error = xfs_fs_start_syncd(vfsp)))
 		goto fail_vnrele;
-	vn_trace_exit(rootvp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_EXIT(rootvp);
 
 	kmem_free(args, sizeof(*args));
 	return 0;
Index: linux/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_vnode.c
+++ linux/fs/xfs/linux-2.6/xfs_vnode.c
@@ -99,7 +99,7 @@ vn_initialize(
 	vp->v_trace = ktrace_alloc(VNODE_TRACE_SIZE, KM_SLEEP);
 #endif	/* XFS_VNODE_TRACE */
 
-	vn_trace_exit(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_EXIT(vp);
 	return vp;
 }
 
@@ -150,7 +150,7 @@ __vn_revalidate(
 {
 	int		error;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 	vattr->va_mask = XFS_AT_STAT | XFS_AT_XFLAGS;
 	error = bhv_vop_getattr(vp, vattr, 0, NULL);
 	if (likely(!error)) {
Index: linux/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux.orig/fs/xfs/linux-2.6/xfs_vnode.h
+++ linux/fs/xfs/linux-2.6/xfs_vnode.h
@@ -587,15 +587,16 @@ extern void vn_trace_hold(struct bhv_vno
 extern void vn_trace_ref(struct bhv_vnode *, char *, int, inst_t *);
 extern void vn_trace_rele(struct bhv_vnode *, char *, int, inst_t *);
 
-#define	VN_TRACE(vp)		\
-	vn_trace_ref(vp, __FILE__, __LINE__, (inst_t *)__return_address)
+#define VN_TRACE_ENTRY(vp)	\
+	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address)
+#define VN_TRACE_EXIT(vp)	\
+	vn_trace_exit(vp, __FUNCTION__, (inst_t *)__return_address)
 #else
-#define	vn_trace_entry(a,b,c)
-#define	vn_trace_exit(a,b,c)
+#define	VN_TRACE_ENTRY(a)
+#define	VN_TRACE_EXIT(a)
 #define	vn_trace_hold(a,b,c,d)
 #define	vn_trace_ref(a,b,c,d)
 #define	vn_trace_rele(a,b,c,d)
-#define	VN_TRACE(vp)
 #endif
 
 #endif	/* __XFS_VNODE_H__ */
Index: linux/fs/xfs/xfs_iget.c
===================================================================
--- linux.orig/fs/xfs/xfs_iget.c
+++ linux/fs/xfs/xfs_iget.c
@@ -629,7 +629,7 @@ xfs_iput(xfs_inode_t	*ip,
 {
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
-	vn_trace_entry(vp, "xfs_iput", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 	xfs_iunlock(ip, lock_flags);
 	VN_RELE(vp);
 }
@@ -644,7 +644,7 @@ xfs_iput_new(xfs_inode_t	*ip,
 	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	struct inode	*inode = vn_to_inode(vp);
 
-	vn_trace_entry(vp, "xfs_iput_new", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	if ((ip->i_d.di_mode == 0)) {
 		ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));
Index: linux/fs/xfs/xfs_rename.c
===================================================================
--- linux.orig/fs/xfs/xfs_rename.c
+++ linux/fs/xfs/xfs_rename.c
@@ -249,8 +249,8 @@ xfs_rename(
 	int		target_namelen = VNAMELEN(target_vname);
 
 	src_dir_vp = BHV_TO_VNODE(src_dir_bdp);
-	vn_trace_entry(src_dir_vp, "xfs_rename", (inst_t *)__return_address);
-	vn_trace_entry(target_dir_vp, "xfs_rename", (inst_t *)__return_address);
+	VN_TRACE_ENTRY(src_dir_vp);
+	VN_TRACE_ENTRY(target_dir_vp);
 
 	/*
 	 * Find the XFS behavior descriptor for the target directory
Index: linux/fs/xfs/xfs_utils.c
===================================================================
--- linux.orig/fs/xfs/xfs_utils.c
+++ linux/fs/xfs/xfs_utils.c
@@ -76,7 +76,7 @@ xfs_dir_lookup_int(
 	int		error;
 
 	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	dp = XFS_BHVTOI(dir_bdp);
 
Index: linux/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux.orig/fs/xfs/xfs_vnodeops.c
+++ linux/fs/xfs/xfs_vnodeops.c
@@ -92,7 +92,7 @@ xfs_getattr(
 	bhv_vnode_t	*vp;
 
 	vp  = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
@@ -237,7 +237,7 @@ xfs_setattr(
 	int			need_iolock = 1;
 
 	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
 		return XFS_ERROR(EROFS);
@@ -907,8 +907,7 @@ xfs_access(
 	xfs_inode_t	*ip;
 	int		error;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp), __FUNCTION__,
-					       (inst_t *)__return_address);
+	VN_TRACE_ENTRY(BHV_TO_VNODE(bdp));
 
 	ip = XFS_BHVTOI(bdp);
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -951,7 +950,7 @@ xfs_readlink(
 	xfs_buf_t	*bp;
 
 	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
@@ -1046,8 +1045,7 @@ xfs_fsync(
 	int		error;
 	int		log_flushed = 0, changed = 1;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp),
-			__FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(BHV_TO_VNODE(bdp));
 
 	ip = XFS_BHVTOI(bdp);
 
@@ -1601,7 +1599,7 @@ xfs_inactive(
 	int		truncate;
 
 	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 
@@ -1825,7 +1823,7 @@ xfs_lookup(
 	bhv_vnode_t		*dir_vp;
 
 	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	dp = XFS_BHVTOI(dir_bdp);
 
@@ -1876,7 +1874,7 @@ xfs_create(
 
 	ASSERT(!*vpp);
 	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	dp = XFS_BHVTOI(dir_bdp);
 	mp = dp->i_mount;
@@ -2370,7 +2368,7 @@ xfs_remove(
 	int			namelen;
 
 	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	dp = XFS_BHVTOI(dir_bdp);
 	mp = dp->i_mount;
@@ -2416,7 +2414,7 @@ xfs_remove(
 
 	dm_di_mode = ip->i_d.di_mode;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(XFS_ITOV(ip));
 
 	ITRACE(ip);
 
@@ -2541,7 +2539,7 @@ xfs_remove(
 	 */
 	xfs_refcache_purge_ip(ip);
 
-	vn_trace_exit(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_EXIT(XFS_ITOV(ip));
 
 	/*
 	 * Let interposed file systems know about removed links.
@@ -2618,8 +2616,8 @@ xfs_link(
 	int			target_namelen;
 
 	target_dir_vp = BHV_TO_VNODE(target_dir_bdp);
-	vn_trace_entry(target_dir_vp, __FUNCTION__, (inst_t *)__return_address);
-	vn_trace_entry(src_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(target_dir_vp);
+	VN_TRACE_ENTRY(src_vp);
 
 	target_namelen = VNAMELEN(dentry);
 	ASSERT(!VN_ISDIR(src_vp));
@@ -2818,7 +2816,7 @@ xfs_mkdir(
 
 	/* Return through std_return after this point. */
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	mp = dp->i_mount;
 	udqp = gdqp = NULL;
@@ -3023,7 +3021,7 @@ xfs_rmdir(
 	dp = XFS_BHVTOI(dir_bdp);
 	mp = dp->i_mount;
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	if (XFS_FORCED_SHUTDOWN(XFS_BHVTOI(dir_bdp)->i_mount))
 		return XFS_ERROR(EIO);
@@ -3259,8 +3257,7 @@ xfs_readdir(
 	int		error = 0;
 	uint		lock_mode;
 
-	vn_trace_entry(BHV_TO_VNODE(dir_bdp), __FUNCTION__,
-					       (inst_t *)__return_address);
+	VN_TRACE_ENTRY(BHV_TO_VNODE(dir_bdp));
 	dp = XFS_BHVTOI(dir_bdp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
@@ -3317,7 +3314,7 @@ xfs_symlink(
 	ip = NULL;
 	tp = NULL;
 
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(dir_vp);
 
 	mp = dp->i_mount;
 
@@ -3608,8 +3605,7 @@ xfs_fid2(
 	xfs_inode_t	*ip;
 	xfs_fid2_t	*xfid;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp), __FUNCTION__,
-				       (inst_t *)__return_address);
+	VN_TRACE_ENTRY(BHV_TO_VNODE(bdp));
 	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
 	xfid = (xfs_fid2_t *)fidp;
@@ -3821,7 +3817,7 @@ xfs_reclaim(
 	vp = BHV_TO_VNODE(bdp);
 	ip = XFS_BHVTOI(bdp);
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ASSERT(!VN_MAPPED(vp));
 
@@ -4037,7 +4033,7 @@ xfs_alloc_file_space(
 	int			committed;
 	int			error;
 
-	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(XFS_ITOV(ip));
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -4308,7 +4304,7 @@ xfs_free_file_space(
 	vp = XFS_ITOV(ip);
 	mp = ip->i_mount;
 
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	if ((error = XFS_QM_DQATTACH(mp, ip, 0)))
 		return error;
@@ -4514,7 +4510,7 @@ xfs_change_file_space(
 	bhv_vnode_t	*vp;
 
 	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
+	VN_TRACE_ENTRY(vp);
 
 	ip = XFS_BHVTOI(bdp);
 	mp = ip->i_mount;
