Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 21 Feb 2008 20:10:08 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1M4A2qc002032
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:04 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 237D46050C5
	for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:26 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id HVs1y64pHMrCUnab for <xfs@oss.sgi.com>; Thu, 21 Feb 2008 20:10:26 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m1M41iF3006084
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2008 05:01:44 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m1M41ieN006082
	for xfs@oss.sgi.com; Fri, 22 Feb 2008 05:01:44 +0100
Date: Fri, 22 Feb 2008 05:01:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] cleanup vnode use in dmapi calls
Message-ID: <20080222040144.GA5964@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2008-02-16 14:47:01.000000000 +0100
@@ -134,20 +134,18 @@ static inline size_t dm_stat_size(size_t
 int
 xfs_dm_send_data_event(
 	dm_eventtype_t	event,
-	bhv_vnode_t	*vp,
+	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	size_t		length,
 	int		flags,
 	int		*lock_flags)
 {
+	struct inode	*inode = ip->i_vnode;
 	int		error;
-	xfs_inode_t	*ip;
 	uint16_t	dmstate;
-	struct inode	*inode = vn_to_inode(vp);
 
 	/* Returns positive errors to XFS */
 
-	ip = xfs_vtoi(vp);
 	do {
 		dmstate = ip->i_d.di_dmstate;
 		if (lock_flags)
@@ -3081,7 +3079,6 @@ xfs_dm_send_mmap_event(
 	struct vm_area_struct *vma,
 	unsigned int	wantflag)
 {
-	bhv_vnode_t	*vp;
 	xfs_inode_t	*ip;
 	int		error = 0;
 	dm_eventtype_t	max_event = DM_EVENT_READ;
@@ -3093,8 +3090,6 @@ xfs_dm_send_mmap_event(
 		return 0;
 
 	ip = XFS_I(vma->vm_file->f_dentry->d_inode);
-	vp = vn_from_inode(vma->vm_file->f_dentry->d_inode);
-	ASSERT(vp);
 
 	if (!S_ISREG(vma->vm_file->f_dentry->d_inode->i_mode) ||
 	    !(ip->i_mount->m_flags & XFS_MOUNT_DMAPI))
@@ -3147,7 +3142,7 @@ xfs_dm_send_mmap_event(
 	xfs_ilock(ip, iolock);
 	/* If write possible, try a DMAPI write event */
 	if (max_event == DM_EVENT_WRITE && DM_EVENT_ENABLED(ip, max_event)) {
-		error = xfs_dm_send_data_event(max_event, vp, offset,
+		error = xfs_dm_send_data_event(max_event, ip, offset,
 					       evsize, 0, &iolock);
 		goto out_unlock;
 	}
@@ -3156,7 +3151,7 @@ xfs_dm_send_mmap_event(
 	 * was DM_EVENT_WRITE but the WRITE event was not enabled.
 	 */
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_READ)) {
-		error = xfs_dm_send_data_event(DM_EVENT_READ, vp, offset,
+		error = xfs_dm_send_data_event(DM_EVENT_READ, ip, offset,
 					       evsize, 0, &iolock);
 	}
 out_unlock:
@@ -3167,17 +3162,11 @@ out_unlock:
 
 STATIC int
 xfs_dm_send_destroy_event(
-	bhv_vnode_t	*vp,
+	xfs_inode_t	*ip,
 	dm_right_t	vp_right)	/* always DM_RIGHT_NULL */
 {
-	int error;
-
 	/* Returns positive errors to XFS */
-
-	error = dm_send_destroy_event(vn_to_inode(vp), vp_right);
-	error = -error; /* DMAPI returns negative errors */
-
-	return error; /* Return positive error to XFS */
+	return -dm_send_destroy_event(ip->i_vnode, vp_right);
 }
 
 
@@ -3185,9 +3174,9 @@ STATIC int
 xfs_dm_send_namesp_event(
 	dm_eventtype_t	event,
 	struct xfs_mount *mp,
-	bhv_vnode_t	*vp1,
+	xfs_inode_t	*ip1,
 	dm_right_t	vp1_right,
-	bhv_vnode_t	*vp2,
+	xfs_inode_t	*ip2,
 	dm_right_t	vp2_right,
 	char		*name1,
 	char		*name2,
@@ -3195,18 +3184,12 @@ xfs_dm_send_namesp_event(
 	int		retcode,
 	int		flags)
 {
-	int error;
-
 	/* Returns positive errors to XFS */
-
-	error = dm_send_namesp_event(event, mp ? mp->m_super : NULL,
-				    vn_to_inode(vp1), vp1_right,
-				    vp2 ? vn_to_inode(vp2) : NULL, vp2_right,
+	return -dm_send_namesp_event(event, mp ? mp->m_super : NULL,
+				    ip1->i_vnode, vp1_right,
+				    ip2 ? ip2->i_vnode : NULL, vp2_right,
 				    name1, name2,
 				    mode, retcode, flags);
-	error = -error; /* DMAPI returns negative errors */
-
-	return error; /* Return positive error to XFS */
 }
 
 STATIC int
@@ -3225,13 +3208,13 @@ xfs_dm_send_mount_event(
 STATIC void
 xfs_dm_send_unmount_event(
 	struct xfs_mount *mp,
-	bhv_vnode_t	*vp,		/* NULL if unmount successful */
+	xfs_inode_t	*ip,		/* NULL if unmount successful */
 	dm_right_t	vfsp_right,
 	mode_t		mode,
 	int		retcode,	/* errno, if unmount failed */
 	int		flags)
 {
-	dm_send_unmount_event(mp->m_super, vp ? vn_to_inode(vp) : NULL,
+	dm_send_unmount_event(mp->m_super, ip ? ip->i_vnode : NULL,
 			      vfsp_right, mode, retcode, flags);
 }
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2008-02-16 14:46:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_file.c	2008-02-16 14:47:01.000000000 +0100
@@ -470,16 +470,11 @@ xfs_file_open_exec(
 	struct inode	*inode)
 {
 	struct xfs_mount *mp = XFS_M(inode->i_sb);
+	struct xfs_inode *ip = XFS_I(inode);
 
-	if (unlikely(mp->m_flags & XFS_MOUNT_DMAPI)) {
-		if (DM_EVENT_ENABLED(XFS_I(inode), DM_EVENT_READ)) {
-			bhv_vnode_t *vp = vn_from_inode(inode);
-
-			return -XFS_SEND_DATA(mp, DM_EVENT_READ,
-						vp, 0, 0, 0, NULL);
-		}
-	}
-
+	if (unlikely(mp->m_flags & XFS_MOUNT_DMAPI) &&
+	             DM_EVENT_ENABLED(ip, DM_EVENT_READ))
+		return -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, 0, 0, 0, NULL);
 	return 0;
 }
 #endif /* HAVE_FOP_OPEN_EXEC */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2008-02-16 14:47:01.000000000 +0100
@@ -231,7 +231,7 @@ xfs_read(
 		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
 		int iolock = XFS_IOLOCK_SHARED;
 
-		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *offset, size,
+		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, ip, *offset, size,
 					dmflags, &iolock);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -276,7 +276,6 @@ xfs_splice_read(
 	int			flags,
 	int			ioflags)
 {
-	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	ssize_t			ret;
 
@@ -290,7 +289,7 @@ xfs_splice_read(
 		int iolock = XFS_IOLOCK_SHARED;
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *ppos, count,
+		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, *ppos, count,
 					FILP_DELAY_FLAG(infilp), &iolock);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -317,7 +316,6 @@ xfs_splice_write(
 	int			flags,
 	int			ioflags)
 {
-	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	ssize_t			ret;
 	struct inode		*inode = outfilp->f_mapping->host;
@@ -333,7 +331,7 @@ xfs_splice_write(
 		int iolock = XFS_IOLOCK_EXCL;
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, vp, *ppos, count,
+		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, *ppos, count,
 					FILP_DELAY_FLAG(outfilp), &iolock);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
@@ -631,7 +629,7 @@ start:
 			dmflags |= DM_FLAGS_IMUX;
 
 		xfs_iunlock(xip, XFS_ILOCK_EXCL);
-		error = XFS_SEND_DATA(xip->i_mount, DM_EVENT_WRITE, vp,
+		error = XFS_SEND_DATA(xip->i_mount, DM_EVENT_WRITE, xip,
 				      pos, count, dmflags, &iolock);
 		if (error) {
 			goto out_unlock_internal;
@@ -778,8 +776,8 @@ retry:
 		xfs_iunlock(xip, iolock);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
-		error = XFS_SEND_NAMESP(xip->i_mount, DM_EVENT_NOSPACE, vp,
-				DM_RIGHT_NULL, vp, DM_RIGHT_NULL, NULL, NULL,
+		error = XFS_SEND_NAMESP(xip->i_mount, DM_EVENT_NOSPACE, xip,
+				DM_RIGHT_NULL, xip, DM_RIGHT_NULL, NULL, NULL,
 				0, 0, 0); /* Delay flag intentionally  unused */
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2008-02-16 14:46:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2008-02-16 14:47:01.000000000 +0100
@@ -5811,7 +5811,7 @@ xfs_getbmap(
 	if ((interface & BMV_IF_NO_DMAPI_READ) == 0 &&
 	    DM_EVENT_ENABLED(ip, DM_EVENT_READ) &&
 	    whichfork == XFS_DATA_FORK) {
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, 0, 0, 0, NULL);
+		error = XFS_SEND_DATA(mp, DM_EVENT_READ, ip, 0, 0, 0, NULL);
 		if (error)
 			return XFS_ERROR(error);
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2008-02-16 14:47:01.000000000 +0100
@@ -66,17 +66,17 @@ struct xfs_mru_cache;
  * Prototypes and functions for the Data Migration subsystem.
  */
 
-typedef int	(*xfs_send_data_t)(int, bhv_vnode_t *,
+typedef int	(*xfs_send_data_t)(int, struct xfs_inode *,
 			xfs_off_t, size_t, int, int *);
 typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
-typedef int	(*xfs_send_destroy_t)(bhv_vnode_t *, dm_right_t);
+typedef int	(*xfs_send_destroy_t)(struct xfs_inode *, dm_right_t);
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct xfs_mount *,
-			bhv_vnode_t *,
-			dm_right_t, bhv_vnode_t *, dm_right_t,
+			struct xfs_inode *, dm_right_t,
+			struct xfs_inode *, dm_right_t,
 			char *, char *, mode_t, int, int);
 typedef int	(*xfs_send_mount_t)(struct xfs_mount *, dm_right_t,
 			char *, char *);
-typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, bhv_vnode_t *,
+typedef void	(*xfs_send_unmount_t)(struct xfs_mount *, struct xfs_inode *,
 			dm_right_t, mode_t, int, int);
 
 typedef struct xfs_dmops {
@@ -88,20 +88,20 @@ typedef struct xfs_dmops {
 	xfs_send_unmount_t	xfs_send_unmount;
 } xfs_dmops_t;
 
-#define XFS_SEND_DATA(mp, ev,vp,off,len,fl,lock) \
-	(*(mp)->m_dm_ops->xfs_send_data)(ev,vp,off,len,fl,lock)
+#define XFS_SEND_DATA(mp, ev,ip,off,len,fl,lock) \
+	(*(mp)->m_dm_ops->xfs_send_data)(ev,ip,off,len,fl,lock)
 #define XFS_SEND_MMAP(mp, vma,fl) \
 	(*(mp)->m_dm_ops->xfs_send_mmap)(vma,fl)
-#define XFS_SEND_DESTROY(mp, vp,right) \
-	(*(mp)->m_dm_ops->xfs_send_destroy)(vp,right)
+#define XFS_SEND_DESTROY(mp, ip,right) \
+	(*(mp)->m_dm_ops->xfs_send_destroy)(ip,right)
 #define XFS_SEND_NAMESP(mp, ev,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(ev,NULL,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 #define XFS_SEND_PREUNMOUNT(mp,b1,r1,b2,r2,n1,n2,mode,rval,fl) \
 	(*(mp)->m_dm_ops->xfs_send_namesp)(DM_EVENT_PREUNMOUNT,mp,b1,r1,b2,r2,n1,n2,mode,rval,fl)
 #define XFS_SEND_MOUNT(mp,right,path,name) \
 	(*(mp)->m_dm_ops->xfs_send_mount)(mp,right,path,name)
-#define XFS_SEND_UNMOUNT(mp, vp,right,mode,rval,fl) \
-	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,vp,right,mode,rval,fl)
+#define XFS_SEND_UNMOUNT(mp, ip,right,mode,rval,fl) \
+	(*(mp)->m_dm_ops->xfs_send_unmount)(mp,ip,right,mode,rval,fl)
 
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2008-02-16 14:46:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2008-02-16 14:47:01.000000000 +0100
@@ -262,8 +262,8 @@ xfs_rename(
 	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
 	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
-					src_dir_vp, DM_RIGHT_NULL,
-					target_dir_vp, DM_RIGHT_NULL,
+					src_dp, DM_RIGHT_NULL,
+					target_dp, DM_RIGHT_NULL,
 					src_name, target_name,
 					0, 0, 0);
 		if (error) {
@@ -595,8 +595,8 @@ std_return:
 	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_POSTRENAME) ||
 	    DM_EVENT_ENABLED(target_dp, DM_EVENT_POSTRENAME)) {
 		(void) XFS_SEND_NAMESP (mp, DM_EVENT_POSTRENAME,
-					src_dir_vp, DM_RIGHT_NULL,
-					target_dir_vp, DM_RIGHT_NULL,
+					src_dp, DM_RIGHT_NULL,
+					target_dp, DM_RIGHT_NULL,
 					src_name, target_name,
 					0, error, 0);
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-02-16 14:46:54.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-02-16 14:47:01.000000000 +0100
@@ -567,7 +567,7 @@ xfs_unmount(
 #ifdef HAVE_DMAPI
 	if (mp->m_flags & XFS_MOUNT_DMAPI) {
 		error = XFS_SEND_PREUNMOUNT(mp,
-				rvp, DM_RIGHT_NULL, rvp, DM_RIGHT_NULL,
+				rip, DM_RIGHT_NULL, rip, DM_RIGHT_NULL,
 				NULL, NULL, 0, 0,
 				(mp->m_dmevmask & (1<<DM_EVENT_PREUNMOUNT))?
 					0:DM_FLAGS_UNWANTED);
@@ -618,7 +618,7 @@ out:
 		/* Note: mp structure must still exist for
 		 * XFS_SEND_UNMOUNT() call.
 		 */
-		XFS_SEND_UNMOUNT(mp, error == 0 ? rvp : NULL,
+		XFS_SEND_UNMOUNT(mp, error == 0 ? rip : NULL,
 			DM_RIGHT_NULL, 0, error, unmount_event_flags);
 	}
 	if (xfs_unmountfs_needed) {
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-02-16 14:46:57.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-02-16 14:47:01.000000000 +0100
@@ -326,7 +326,7 @@ xfs_setattr(
 		if (DM_EVENT_ENABLED(ip, DM_EVENT_TRUNCATE) &&
 		    !(flags & ATTR_DMI)) {
 			int dmflags = AT_DELAY_FLAG(flags) | DM_SEM_FLAG_WR;
-			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, vp,
+			code = XFS_SEND_DATA(mp, DM_EVENT_TRUNCATE, ip,
 				vap->va_size, 0, dmflags, NULL);
 			if (code) {
 				lock_flags = 0;
@@ -876,7 +876,7 @@ xfs_setattr(
 
 	if (DM_EVENT_ENABLED(ip, DM_EVENT_ATTRIBUTE) &&
 	    !(flags & ATTR_DMI)) {
-		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, vp, DM_RIGHT_NULL,
+		(void) XFS_SEND_NAMESP(mp, DM_EVENT_ATTRIBUTE, ip, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL, NULL, NULL,
 					0, 0, AT_DELAY_FLAG(flags));
 	}
@@ -1581,9 +1581,8 @@ xfs_inactive(
 
 	mp = ip->i_mount;
 
-	if (ip->i_d.di_nlink == 0 && DM_EVENT_ENABLED(ip, DM_EVENT_DESTROY)) {
-		(void) XFS_SEND_DESTROY(mp, vp, DM_RIGHT_NULL);
-	}
+	if (ip->i_d.di_nlink == 0 && DM_EVENT_ENABLED(ip, DM_EVENT_DESTROY))
+		XFS_SEND_DESTROY(mp, ip, DM_RIGHT_NULL);
 
 	error = 0;
 
@@ -1815,7 +1814,7 @@ xfs_create(
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
-				dir_vp, DM_RIGHT_NULL, NULL,
+				dp, DM_RIGHT_NULL, NULL,
 				DM_RIGHT_NULL, name, NULL,
 				mode, 0, 0);
 
@@ -1971,8 +1970,8 @@ std_return:
 	if ((*vpp || (error != 0 && dm_event_sent != 0)) &&
 	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
-			dir_vp, DM_RIGHT_NULL,
-			*vpp ? vp:NULL,
+			dp, DM_RIGHT_NULL,
+			*vpp ? ip : NULL,
 			DM_RIGHT_NULL, name, NULL,
 			mode, error, 0);
 	}
@@ -2267,7 +2266,6 @@ xfs_remove(
 	xfs_inode_t             *dp,
 	bhv_vname_t		*dentry)
 {
-	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*name = VNAME(dentry);
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_inode_t             *ip;
@@ -2295,7 +2293,7 @@ xfs_remove(
 	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dir_vp,
+		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
 					name, NULL, dm_di_mode, 0, 0);
 		if (error)
@@ -2457,7 +2455,7 @@ xfs_remove(
  std_return:
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
-				dir_vp, DM_RIGHT_NULL,
+				dp, DM_RIGHT_NULL,
 				NULL, DM_RIGHT_NULL,
 				name, NULL, dm_di_mode, error, 0);
 	}
@@ -2516,8 +2514,8 @@ xfs_link(
 
 	if (DM_EVENT_ENABLED(tdp, DM_EVENT_LINK)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_LINK,
-					target_dir_vp, DM_RIGHT_NULL,
-					src_vp, DM_RIGHT_NULL,
+					tdp, DM_RIGHT_NULL,
+					sip, DM_RIGHT_NULL,
 					target_name, NULL, 0, 0, 0);
 		if (error)
 			return error;
@@ -2627,8 +2625,8 @@ xfs_link(
 std_return:
 	if (DM_EVENT_ENABLED(sip, DM_EVENT_POSTLINK)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTLINK,
-				target_dir_vp, DM_RIGHT_NULL,
-				src_vp, DM_RIGHT_NULL,
+				tdp, DM_RIGHT_NULL,
+				sip, DM_RIGHT_NULL,
 				target_name, NULL, 0, error, 0);
 	}
 	return error;
@@ -2677,7 +2675,7 @@ xfs_mkdir(
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_CREATE,
-					dir_vp, DM_RIGHT_NULL, NULL,
+					dp, DM_RIGHT_NULL, NULL,
 					DM_RIGHT_NULL, dir_name, NULL,
 					mode, 0, 0);
 		if (error)
@@ -2835,8 +2833,8 @@ std_return:
 	if ((created || (error != 0 && dm_event_sent != 0)) &&
 	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
-					dir_vp, DM_RIGHT_NULL,
-					created ? XFS_ITOV(cdp):NULL,
+					dp, DM_RIGHT_NULL,
+					created ? cdp : NULL,
 					DM_RIGHT_NULL,
 					dir_name, NULL,
 					mode, error, 0);
@@ -2891,7 +2889,7 @@ xfs_rmdir(
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_REMOVE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_REMOVE,
-					dir_vp, DM_RIGHT_NULL,
+					dp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
 					name, NULL, dm_di_mode, 0, 0);
 		if (error)
@@ -3075,7 +3073,7 @@ xfs_rmdir(
  std_return:
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTREMOVE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTREMOVE,
-					dir_vp, DM_RIGHT_NULL,
+					dp, DM_RIGHT_NULL,
 					NULL, DM_RIGHT_NULL,
 					name, NULL, dm_di_mode,
 					error, 0);
@@ -3172,7 +3170,7 @@ xfs_symlink(
 	}
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_SYMLINK)) {
-		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dir_vp,
+		error = XFS_SEND_NAMESP(mp, DM_EVENT_SYMLINK, dp,
 					DM_RIGHT_NULL, NULL, DM_RIGHT_NULL,
 					link_name, target_path, 0, 0, 0);
 		if (error)
@@ -3376,8 +3374,8 @@ xfs_symlink(
 std_return:
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTSYMLINK)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
-					dir_vp, DM_RIGHT_NULL,
-					error ? NULL : XFS_ITOV(ip),
+					dp, DM_RIGHT_NULL,
+					error ? NULL : ip,
 					DM_RIGHT_NULL, link_name, target_path,
 					0, error, 0);
 	}
@@ -3735,9 +3733,8 @@ xfs_alloc_file_space(
 		end_dmi_offset = offset+len;
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, XFS_ITOV(ip),
-			offset, end_dmi_offset - offset,
-			0, NULL);
+		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip, offset,
+				      end_dmi_offset - offset, 0, NULL);
 		if (error)
 			return error;
 	}
@@ -3846,8 +3843,8 @@ dmapi_enospc_check:
 	if (error == ENOSPC && (attr_flags & ATTR_DMI) == 0 &&
 	    DM_EVENT_ENABLED(ip, DM_EVENT_NOSPACE)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_NOSPACE,
-				XFS_ITOV(ip), DM_RIGHT_NULL,
-				XFS_ITOV(ip), DM_RIGHT_NULL,
+				ip, DM_RIGHT_NULL,
+				ip, DM_RIGHT_NULL,
 				NULL, NULL, 0, 0, 0); /* Delay flag intentionally unused */
 		if (error == 0)
 			goto retry;	/* Maybe DMAPI app. has made space */
@@ -3992,7 +3989,7 @@ xfs_free_file_space(
 	    DM_EVENT_ENABLED(ip, DM_EVENT_WRITE)) {
 		if (end_dmi_offset > ip->i_size)
 			end_dmi_offset = ip->i_size;
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, vp,
+		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, ip,
 				offset, end_dmi_offset - offset,
 				AT_DELAY_FLAG(attr_flags), NULL);
 		if (error)
