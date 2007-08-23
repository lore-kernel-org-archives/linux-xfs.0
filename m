Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:37:16 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJb84p002540
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:37:11 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJb4A5008432
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:37:04 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJb4NB008430
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:37:04 +0200
Date: Thu, 23 Aug 2007 21:37:04 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/17] decontaminate vnode operations from behavior details
Message-ID: <20070823193704.GB8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

All vnode ops now take struct xfs_inode pointers and the behaviour
related glue is split out into methods of it's own.  This required
fixing xfs_create/mkdir/symlink to not mess with the inode pointer
but rather use a separate boolean for error handling.  Thanks to
Dave Chinner for that fix.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-23 14:41:01.000000000 +0200
@@ -52,15 +52,13 @@
 #include "xfs_trans_space.h"
 #include "xfs_log_priv.h"
 #include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
 
-STATIC int
+int
 xfs_open(
-	bhv_desc_t	*bdp,
-	cred_t		*credp)
+	xfs_inode_t	*ip)
 {
 	int		mode;
-	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
-	xfs_inode_t	*ip = XFS_BHVTOI(bdp);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return XFS_ERROR(EIO);
@@ -69,7 +67,7 @@ xfs_open(
 	 * If it's a directory with any blocks, read-ahead block 0
 	 * as we're almost certain to have the next operation be a read there.
 	 */
-	if (VN_ISDIR(vp) && ip->i_d.di_nextents > 0) {
+	if (S_ISDIR(ip->i_d.di_mode) && ip->i_d.di_nextents > 0) {
 		mode = xfs_ilock_map_shared(ip);
 		if (ip->i_d.di_nextents > 0)
 			(void)xfs_da_reada_buf(NULL, ip, 0, XFS_DATA_FORK);
@@ -81,23 +79,17 @@ xfs_open(
 /*
  * xfs_getattr
  */
-STATIC int
+int
 xfs_getattr(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	bhv_vattr_t	*vap,
-	int		flags,
-	cred_t		*credp)
+	int		flags)
 {
-	xfs_inode_t	*ip;
-	xfs_mount_t	*mp;
-	bhv_vnode_t	*vp;
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	xfs_mount_t	*mp = ip->i_mount;
 
-	vp  = BHV_TO_VNODE(bdp);
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -215,14 +207,14 @@ xfs_getattr(
  */
 int
 xfs_setattr(
-	bhv_desc_t		*bdp,
+	xfs_inode_t		*ip,
 	bhv_vattr_t		*vap,
 	int			flags,
 	cred_t			*credp)
 {
-	xfs_inode_t		*ip;
+	bhv_vnode_t		*vp = XFS_ITOV(ip);
+	xfs_mount_t		*mp = ip->i_mount;
 	xfs_trans_t		*tp;
-	xfs_mount_t		*mp;
 	int			mask;
 	int			code;
 	uint			lock_flags;
@@ -230,14 +222,12 @@ xfs_setattr(
 	uid_t			uid=0, iuid=0;
 	gid_t			gid=0, igid=0;
 	int			timeflags = 0;
-	bhv_vnode_t		*vp;
 	xfs_prid_t		projid=0, iprojid=0;
 	int			mandlock_before, mandlock_after;
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
 	int			file_owner;
 	int			need_iolock = 1;
 
-	vp = BHV_TO_VNODE(bdp);
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
 	if (vp->v_vfsp->vfs_flag & VFS_RDONLY)
@@ -251,9 +241,6 @@ xfs_setattr(
 		return XFS_ERROR(EINVAL);
 	}
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -924,19 +911,16 @@ xfs_setattr(
  * xfs_access
  * Null conversion from vnode mode bits to inode mode bits, as in efs.
  */
-STATIC int
+int
 xfs_access(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	int		mode,
 	cred_t		*credp)
 {
-	xfs_inode_t	*ip;
 	int		error;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp), __FUNCTION__,
-					       (inst_t *)__return_address);
+	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
-	ip = XFS_BHVTOI(bdp);
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 	error = xfs_iaccess(ip, mode, credp);
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -998,16 +982,11 @@ xfs_readlink_bmap(
 	return error;
 }
 
-/*
- * xfs_readlink
- *
- */
-STATIC int
+int
 xfs_readlink(
-	bhv_desc_t	*bdp,
+	xfs_inode_t     *ip,
 	char		*link)
 {
-	xfs_inode_t     *ip = XFS_BHVTOI(bdp);
 	xfs_mount_t	*mp = ip->i_mount;
 	int		pathlen;
 	int		error = 0;
@@ -1047,23 +1026,18 @@ xfs_readlink(
  * be held while flushing the data, so acquire after we're done
  * with that.
  */
-STATIC int
+int
 xfs_fsync(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	int		flag,
-	cred_t		*credp,
 	xfs_off_t	start,
 	xfs_off_t	stop)
 {
-	xfs_inode_t	*ip;
 	xfs_trans_t	*tp;
 	int		error;
 	int		log_flushed = 0, changed = 1;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp),
-			__FUNCTION__, (inst_t *)__return_address);
-
-	ip = XFS_BHVTOI(bdp);
+	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
 	ASSERT(start >= 0 && stop >= -1);
 
@@ -1530,19 +1504,14 @@ xfs_inactive_attrs(
 	return 0;
 }
 
-STATIC int
+int
 xfs_release(
-	bhv_desc_t	*bdp)
+	xfs_inode_t	*ip)
 {
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
-	xfs_mount_t	*mp;
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
 
-	vp = BHV_TO_VNODE(bdp);
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-
 	if (!VN_ISREG(vp) || (ip->i_d.di_mode == 0))
 		return 0;
 
@@ -1608,13 +1577,11 @@ xfs_release(
  * now be truncated.  Also, we clear all of the read-ahead state
  * kept for the inode here since the file is now closed.
  */
-STATIC int
+int
 xfs_inactive(
-	bhv_desc_t	*bdp,
-	cred_t		*credp)
+	xfs_inode_t	*ip)
 {
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
 	xfs_bmap_free_t	free_list;
 	xfs_fsblock_t	first_block;
 	int		committed;
@@ -1623,11 +1590,8 @@ xfs_inactive(
 	int		error;
 	int		truncate;
 
-	vp = BHV_TO_VNODE(bdp);
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
-	ip = XFS_BHVTOI(bdp);
-
 	/*
 	 * If the inode is already free, then there can be nothing
 	 * to clean up here.
@@ -1828,34 +1792,24 @@ xfs_inactive(
 }
 
 
-/*
- * xfs_lookup
- */
-STATIC int
+int
 xfs_lookup(
-	bhv_desc_t		*dir_bdp,
+	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
-	bhv_vnode_t		**vpp,
-	int			flags,
-	bhv_vnode_t		*rdir,
-	cred_t			*credp)
+	bhv_vnode_t		**vpp)
 {
-	xfs_inode_t		*dp, *ip;
+	xfs_inode_t		*ip;
 	xfs_ino_t		e_inum;
 	int			error;
 	uint			lock_mode;
-	bhv_vnode_t		*dir_vp;
-
-	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
 
-	dp = XFS_BHVTOI(dir_bdp);
+	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
 
 	lock_mode = xfs_ilock_map_shared(dp);
-	error = xfs_dir_lookup_int(dir_bdp, lock_mode, dentry, &e_inum, &ip);
+	error = xfs_dir_lookup_int(dp, lock_mode, dentry, &e_inum, &ip);
 	if (!error) {
 		*vpp = XFS_ITOV(ip);
 		ITRACE(ip);
@@ -1864,29 +1818,25 @@ xfs_lookup(
 	return error;
 }
 
-
-/*
- * xfs_create (create a new file).
- */
-STATIC int
+int
 xfs_create(
-	bhv_desc_t		*dir_bdp,
+	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
 	bhv_vattr_t		*vap,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
 	char			*name = VNAME(dentry);
-	bhv_vnode_t		*dir_vp;
-	xfs_inode_t		*dp, *ip;
+	xfs_mount_t	        *mp = dp->i_mount;
+	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
+	xfs_inode_t		*ip;
 	bhv_vnode_t	        *vp = NULL;
 	xfs_trans_t		*tp;
-	xfs_mount_t	        *mp;
 	xfs_dev_t		rdev;
 	int                     error;
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
-	boolean_t		dp_joined_to_trans;
+	boolean_t		unlock_dp_on_error = B_FALSE;
 	int			dm_event_sent = 0;
 	uint			cancel_flags;
 	int			committed;
@@ -1897,12 +1847,8 @@ xfs_create(
 	int			namelen;
 
 	ASSERT(!*vpp);
-	dir_vp = BHV_TO_VNODE(dir_bdp);
 	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
 
-	dp = XFS_BHVTOI(dir_bdp);
-	mp = dp->i_mount;
-
 	dm_di_mode = vap->va_mode;
 	namelen = VNAMELEN(dentry);
 
@@ -1940,7 +1886,6 @@ xfs_create(
 		goto std_return;
 
 	ip = NULL;
-	dp_joined_to_trans = B_FALSE;
 
 	tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE);
 	cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
@@ -1960,11 +1905,11 @@ xfs_create(
 	}
 	if (error) {
 		cancel_flags = 0;
-		dp = NULL;
 		goto error_return;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	unlock_dp_on_error = B_TRUE;
 
 	XFS_BMAP_INIT(&free_list, &first_block);
 
@@ -1998,15 +1943,15 @@ xfs_create(
 	ASSERT(ismrlocked (&ip->i_lock, MR_UPDATE));
 
 	/*
-	 * Now we join the directory inode to the transaction.
-	 * We do not do it earlier because xfs_dir_ialloc
-	 * might commit the previous transaction (and release
-	 * all the locks).
+	 * Now we join the directory inode to the transaction.  We do not do it
+	 * earlier because xfs_dir_ialloc might commit the previous transaction
+	 * (and release all the locks).  An error from here on will result in
+	 * the transaction cancel unlocking dp so don't do it explicitly in the
+	 * error path.
 	 */
-
 	VN_HOLD(dir_vp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	dp_joined_to_trans = B_TRUE;
+	unlock_dp_on_error = B_FALSE;
 
 	error = xfs_dir_createname(tp, dp, name, namelen, ip->i_ino,
 					&first_block, &free_list, resblks ?
@@ -2072,7 +2017,7 @@ xfs_create(
 
 std_return:
 	if ((*vpp || (error != 0 && dm_event_sent != 0)) &&
-	    DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTCREATE)) {
+	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
 			dir_vp, DM_RIGHT_NULL,
 			*vpp ? vp:NULL,
@@ -2089,11 +2034,12 @@ std_return:
 	if (tp != NULL)
 		xfs_trans_cancel(tp, cancel_flags);
 
-	if (!dp_joined_to_trans && (dp != NULL))
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
+	if (unlock_dp_on_error)
+		xfs_iunlock(dp, XFS_ILOCK_EXCL);
+
 	goto std_return;
 
  abort_rele:
@@ -2364,22 +2310,16 @@ int remove_which_error_return = 0;
 #define	REMOVE_DEBUG_TRACE(x)
 #endif	/* ! DEBUG */
 
-
-/*
- * xfs_remove
- *
- */
-STATIC int
+int
 xfs_remove(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
+	xfs_inode_t             *dp,
+	bhv_vname_t		*dentry)
 {
-	bhv_vnode_t		*dir_vp;
+	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*name = VNAME(dentry);
-	xfs_inode_t             *dp, *ip;
+	xfs_mount_t		*mp = dp->i_mount;
+	xfs_inode_t             *ip;
 	xfs_trans_t             *tp = NULL;
-	xfs_mount_t		*mp;
 	int                     error = 0;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
@@ -2390,12 +2330,8 @@ xfs_remove(
 	uint			resblks;
 	int			namelen;
 
-	dir_vp = BHV_TO_VNODE(dir_bdp);
 	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
 
-	dp = XFS_BHVTOI(dir_bdp);
-	mp = dp->i_mount;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -2620,42 +2556,32 @@ xfs_remove(
 	goto std_return;
 }
 
-
-/*
- * xfs_link
- *
- */
-STATIC int
+int
 xfs_link(
-	bhv_desc_t		*target_dir_bdp,
+	xfs_inode_t		*tdp,
 	bhv_vnode_t		*src_vp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
+	bhv_vname_t		*dentry)
 {
-	xfs_inode_t		*tdp, *sip;
+	bhv_vnode_t		*target_dir_vp = XFS_ITOV(tdp);
+	xfs_mount_t		*mp = tdp->i_mount;
+	xfs_inode_t		*sip = xfs_vtoi(src_vp);
 	xfs_trans_t		*tp;
-	xfs_mount_t		*mp;
 	xfs_inode_t		*ips[2];
 	int			error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
 	int			committed;
-	bhv_vnode_t		*target_dir_vp;
 	int			resblks;
 	char			*target_name = VNAME(dentry);
 	int			target_namelen;
 
-	target_dir_vp = BHV_TO_VNODE(target_dir_bdp);
 	vn_trace_entry(target_dir_vp, __FUNCTION__, (inst_t *)__return_address);
 	vn_trace_entry(src_vp, __FUNCTION__, (inst_t *)__return_address);
 
 	target_namelen = VNAMELEN(dentry);
 	ASSERT(!VN_ISDIR(src_vp));
 
-	sip = xfs_vtoi(src_vp);
-	tdp = XFS_BHVTOI(target_dir_bdp);
-	mp = tdp->i_mount;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -2788,50 +2714,38 @@ std_return:
 }
 
 
-/*
- * xfs_mkdir
- *
- */
-STATIC int
+int
 xfs_mkdir(
-	bhv_desc_t		*dir_bdp,
+	xfs_inode_t             *dp,
 	bhv_vname_t		*dentry,
 	bhv_vattr_t		*vap,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
+	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*dir_name = VNAME(dentry);
-	xfs_inode_t             *dp;
+	int			dir_namelen = VNAMELEN(dentry);
+	xfs_mount_t		*mp = dp->i_mount;
 	xfs_inode_t		*cdp;	/* inode of created dir */
 	bhv_vnode_t		*cvp;	/* vnode of created dir */
 	xfs_trans_t		*tp;
-	xfs_mount_t		*mp;
 	int			cancel_flags;
 	int			error;
 	int			committed;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
-	bhv_vnode_t		*dir_vp;
-	boolean_t		dp_joined_to_trans;
+	boolean_t		unlock_dp_on_error = B_FALSE;
 	boolean_t		created = B_FALSE;
 	int			dm_event_sent = 0;
 	xfs_prid_t		prid;
 	struct xfs_dquot	*udqp, *gdqp;
 	uint			resblks;
 	int			dm_di_mode;
-	int			dir_namelen;
-
-	dir_vp = BHV_TO_VNODE(dir_bdp);
-	dp = XFS_BHVTOI(dir_bdp);
-	mp = dp->i_mount;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
-	dir_namelen = VNAMELEN(dentry);
-
 	tp = NULL;
-	dp_joined_to_trans = B_FALSE;
 	dm_di_mode = vap->va_mode;
 
 	if (DM_EVENT_ENABLED(dp, DM_EVENT_CREATE)) {
@@ -2879,11 +2793,11 @@ xfs_mkdir(
 	}
 	if (error) {
 		cancel_flags = 0;
-		dp = NULL;
 		goto error_return;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	unlock_dp_on_error = B_TRUE;
 
 	/*
 	 * Check for directory link count overflow.
@@ -2920,11 +2834,13 @@ xfs_mkdir(
 	 * Now we add the directory inode to the transaction.
 	 * We waited until now since xfs_dir_ialloc might start
 	 * a new transaction.  Had we joined the transaction
-	 * earlier, the locks might have gotten released.
+	 * earlier, the locks might have gotten released. An error
+	 * from here on will result in the transaction cancel
+	 * unlocking dp so don't do it explicitly in the error path.
 	 */
 	VN_HOLD(dir_vp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	dp_joined_to_trans = B_TRUE;
+	unlock_dp_on_error = B_FALSE;
 
 	XFS_BMAP_INIT(&free_list, &first_block);
 
@@ -2992,7 +2908,7 @@ xfs_mkdir(
 
 std_return:
 	if ((created || (error != 0 && dm_event_sent != 0)) &&
-	    DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTCREATE)) {
+	    DM_EVENT_ENABLED(dp, DM_EVENT_POSTCREATE)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTCREATE,
 					dir_vp, DM_RIGHT_NULL,
 					created ? XFS_ITOV(cdp):NULL,
@@ -3012,49 +2928,36 @@ std_return:
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
-	if (!dp_joined_to_trans && (dp != NULL)) {
+	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	}
 
 	goto std_return;
 }
 
-
-/*
- * xfs_rmdir
- *
- */
-STATIC int
+int
 xfs_rmdir(
-	bhv_desc_t		*dir_bdp,
-	bhv_vname_t		*dentry,
-	cred_t			*credp)
+	xfs_inode_t             *dp,
+	bhv_vname_t		*dentry)
 {
+	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
 	char			*name = VNAME(dentry);
-	xfs_inode_t             *dp;
-	xfs_inode_t             *cdp;   /* child directory */
+	int			namelen = VNAMELEN(dentry);
+	xfs_mount_t		*mp = dp->i_mount;
+  	xfs_inode_t             *cdp;   /* child directory */
 	xfs_trans_t             *tp;
-	xfs_mount_t		*mp;
 	int                     error;
 	xfs_bmap_free_t         free_list;
 	xfs_fsblock_t           first_block;
 	int			cancel_flags;
 	int			committed;
-	bhv_vnode_t		*dir_vp;
 	int			dm_di_mode = S_IFDIR;
 	int			last_cdp_link;
-	int			namelen;
 	uint			resblks;
 
-	dir_vp = BHV_TO_VNODE(dir_bdp);
-	dp = XFS_BHVTOI(dir_bdp);
-	mp = dp->i_mount;
-
 	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
 
-	if (XFS_FORCED_SHUTDOWN(XFS_BHVTOI(dir_bdp)->i_mount))
+	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
-	namelen = VNAMELEN(dentry);
 
 	if (!xfs_get_dir_entry(dentry, &cdp)) {
 	        dm_di_mode = cdp->i_d.di_mode;
@@ -3269,25 +3172,24 @@ xfs_rmdir(
 	goto std_return;
 }
 
-STATIC int
+int
 xfs_symlink(
-	bhv_desc_t		*dir_bdp,
+	xfs_inode_t		*dp,
 	bhv_vname_t		*dentry,
 	bhv_vattr_t		*vap,
 	char			*target_path,
 	bhv_vnode_t		**vpp,
 	cred_t			*credp)
 {
+	bhv_vnode_t		*dir_vp = XFS_ITOV(dp);
+	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t		*tp;
-	xfs_mount_t		*mp;
-	xfs_inode_t		*dp;
 	xfs_inode_t		*ip;
 	int			error;
 	int			pathlen;
 	xfs_bmap_free_t		free_list;
 	xfs_fsblock_t		first_block;
-	boolean_t		dp_joined_to_trans;
-	bhv_vnode_t		*dir_vp;
+	boolean_t		unlock_dp_on_error = B_FALSE;
 	uint			cancel_flags;
 	int			committed;
 	xfs_fileoff_t		first_fsb;
@@ -3306,16 +3208,12 @@ xfs_symlink(
 	int			link_namelen;
 
 	*vpp = NULL;
-	dir_vp = BHV_TO_VNODE(dir_bdp);
-	dp = XFS_BHVTOI(dir_bdp);
-	dp_joined_to_trans = B_FALSE;
 	error = 0;
 	ip = NULL;
 	tp = NULL;
 
 	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
 
-	mp = dp->i_mount;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -3401,11 +3299,11 @@ xfs_symlink(
 	}
 	if (error) {
 		cancel_flags = 0;
-		dp = NULL;
 		goto error_return;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
+	unlock_dp_on_error = B_TRUE;
 
 	/*
 	 * Check whether the directory allows new symlinks or not.
@@ -3446,9 +3344,14 @@ xfs_symlink(
 	}
 	ITRACE(ip);
 
+	/*
+	 * An error after we've joined dp to the transaction will result in the
+	 * transaction cancel unlocking dp so don't do it explicitly in the
+	 * error path.
+	 */
 	VN_HOLD(dir_vp);
 	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
-	dp_joined_to_trans = B_TRUE;
+	unlock_dp_on_error = B_FALSE;
 
 	/*
 	 * Also attach the dquot(s) to it, if applicable.
@@ -3554,7 +3457,7 @@ xfs_symlink(
 	/* Fall through to std_return with error = 0 or errno from
 	 * xfs_trans_commit	*/
 std_return:
-	if (DM_EVENT_ENABLED(XFS_BHVTOI(dir_bdp), DM_EVENT_POSTSYMLINK)) {
+	if (DM_EVENT_ENABLED(dp, DM_EVENT_POSTSYMLINK)) {
 		(void) XFS_SEND_NAMESP(mp, DM_EVENT_POSTSYMLINK,
 					dir_vp, DM_RIGHT_NULL,
 					error ? NULL : XFS_ITOV(ip),
@@ -3581,9 +3484,8 @@ std_return:
 	XFS_QM_DQRELE(mp, udqp);
 	XFS_QM_DQRELE(mp, gdqp);
 
-	if (!dp_joined_to_trans && (dp != NULL)) {
+	if (unlock_dp_on_error)
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	}
 
 	goto std_return;
 }
@@ -3595,20 +3497,16 @@ std_return:
  * A fid routine that takes a pointer to a previously allocated
  * fid structure (like xfs_fast_fid) but uses a 64 bit inode number.
  */
-STATIC int
+int
 xfs_fid2(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	fid_t		*fidp)
 {
-	xfs_inode_t	*ip;
-	xfs_fid2_t	*xfid;
+	xfs_fid2_t	*xfid = (xfs_fid2_t *)fidp;
 
-	vn_trace_entry(BHV_TO_VNODE(bdp), __FUNCTION__,
-				       (inst_t *)__return_address);
+	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
-	xfid = (xfs_fid2_t *)fidp;
-	ip = XFS_BHVTOI(bdp);
 	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
 	xfid->fid_pad = 0;
 	/*
@@ -3622,21 +3520,13 @@ xfs_fid2(
 }
 
 
-/*
- * xfs_rwlock
- */
 int
 xfs_rwlock(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	bhv_vrwlock_t	locktype)
 {
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
-
-	vp = BHV_TO_VNODE(bdp);
-	if (VN_ISDIR(vp))
+	if (S_ISDIR(ip->i_d.di_mode))
 		return 1;
-	ip = XFS_BHVTOI(bdp);
 	if (locktype == VRWLOCK_WRITE) {
 		xfs_ilock(ip, XFS_IOLOCK_EXCL);
 	} else if (locktype == VRWLOCK_TRY_READ) {
@@ -3653,21 +3543,13 @@ xfs_rwlock(
 }
 
 
-/*
- * xfs_rwunlock
- */
 void
 xfs_rwunlock(
-	bhv_desc_t	*bdp,
+	xfs_inode_t     *ip,
 	bhv_vrwlock_t	locktype)
 {
-	xfs_inode_t     *ip;
-	bhv_vnode_t	*vp;
-
-	vp = BHV_TO_VNODE(bdp);
-	if (VN_ISDIR(vp))
-		return;
-	ip = XFS_BHVTOI(bdp);
+ 	if (S_ISDIR(ip->i_d.di_mode))
+  		return;
 	if (locktype == VRWLOCK_WRITE) {
 		/*
 		 * In the write case, we may have added a new entry to
@@ -3685,20 +3567,16 @@ xfs_rwunlock(
 	return;
 }
 
-STATIC int
+
+int
 xfs_inode_flush(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	int		flags)
 {
-	xfs_inode_t	*ip;
-	xfs_mount_t	*mp;
-	xfs_inode_log_item_t *iip;
+	xfs_mount_t	*mp = ip->i_mount;
+	xfs_inode_log_item_t *iip = ip->i_itemp;
 	int		error = 0;
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-	iip = ip->i_itemp;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -3766,24 +3644,20 @@ xfs_inode_flush(
 	return error;
 }
 
+
 int
-xfs_set_dmattrs (
-	bhv_desc_t	*bdp,
+xfs_set_dmattrs(
+	xfs_inode_t     *ip,
 	u_int		evmask,
-	u_int16_t	state,
-	cred_t		*credp)
+	u_int16_t	state)
 {
-	xfs_inode_t     *ip;
+	xfs_mount_t	*mp = ip->i_mount;
 	xfs_trans_t	*tp;
-	xfs_mount_t	*mp;
 	int		error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return XFS_ERROR(EPERM);
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
 
@@ -3806,15 +3680,11 @@ xfs_set_dmattrs (
 	return error;
 }
 
-STATIC int
+int
 xfs_reclaim(
-	bhv_desc_t	*bdp)
+	xfs_inode_t	*ip)
 {
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
-
-	vp = BHV_TO_VNODE(bdp);
-	ip = XFS_BHVTOI(bdp);
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
 
 	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
 
@@ -4491,35 +4361,29 @@ xfs_free_file_space(
  */
 int
 xfs_change_file_space(
-	bhv_desc_t	*bdp,
+	xfs_inode_t	*ip,
 	int		cmd,
 	xfs_flock64_t	*bf,
 	xfs_off_t	offset,
 	cred_t		*credp,
 	int		attr_flags)
 {
+	xfs_mount_t	*mp = ip->i_mount;
 	int		clrprealloc;
 	int		error;
 	xfs_fsize_t	fsize;
-	xfs_inode_t	*ip;
-	xfs_mount_t	*mp;
 	int		setprealloc;
 	xfs_off_t	startoffset;
 	xfs_off_t	llen;
 	xfs_trans_t	*tp;
 	bhv_vattr_t	va;
-	bhv_vnode_t	*vp;
 
-	vp = BHV_TO_VNODE(bdp);
-	vn_trace_entry(vp, __FUNCTION__, (inst_t *)__return_address);
-
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
+	vn_trace_entry(XFS_ITOV(ip), __FUNCTION__, (inst_t *)__return_address);
 
 	/*
 	 * must be a regular file and have write permission
 	 */
-	if (!VN_ISREG(vp))
+	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -4601,7 +4465,7 @@ xfs_change_file_space(
 		va.va_mask = XFS_AT_SIZE;
 		va.va_size = startoffset;
 
-		error = xfs_setattr(bdp, &va, attr_flags, credp);
+		error = xfs_setattr(ip, &va, attr_flags, credp);
 
 		if (error)
 			return error;
@@ -4660,49 +4524,3 @@ xfs_change_file_space(
 
 	return error;
 }
-
-bhv_vnodeops_t xfs_vnodeops = {
-	BHV_IDENTITY_INIT(VN_BHV_XFS,VNODE_POSITION_XFS),
-	.vop_open		= xfs_open,
-	.vop_read		= xfs_read,
-#ifdef HAVE_SENDFILE
-	.vop_sendfile		= xfs_sendfile,
-#endif
-#ifdef HAVE_SPLICE
-	.vop_splice_read	= xfs_splice_read,
-	.vop_splice_write	= xfs_splice_write,
-#endif
-	.vop_write		= xfs_write,
-	.vop_ioctl		= xfs_ioctl,
-	.vop_getattr		= xfs_getattr,
-	.vop_setattr		= xfs_setattr,
-	.vop_access		= xfs_access,
-	.vop_lookup		= xfs_lookup,
-	.vop_create		= xfs_create,
-	.vop_remove		= xfs_remove,
-	.vop_link		= xfs_link,
-	.vop_rename		= xfs_rename,
-	.vop_mkdir		= xfs_mkdir,
-	.vop_rmdir		= xfs_rmdir,
-	.vop_readdir		= xfs_readdir,
-	.vop_symlink		= xfs_symlink,
-	.vop_readlink		= xfs_readlink,
-	.vop_fsync		= xfs_fsync,
-	.vop_inactive		= xfs_inactive,
-	.vop_fid2		= xfs_fid2,
-	.vop_rwlock		= xfs_rwlock,
-	.vop_rwunlock		= xfs_rwunlock,
-	.vop_bmap		= xfs_bmap,
-	.vop_reclaim		= xfs_reclaim,
-	.vop_attr_get		= xfs_attr_get,
-	.vop_attr_set		= xfs_attr_set,
-	.vop_attr_remove	= xfs_attr_remove,
-	.vop_attr_list		= xfs_attr_list,
-	.vop_link_removed	= (vop_link_removed_t)fs_noval,
-	.vop_vnode_change	= (vop_vnode_change_t)fs_noval,
-	.vop_tosspages		= fs_tosspages,
-	.vop_flushinval_pages	= fs_flushinval_pages,
-	.vop_flush_pages	= fs_flush_pages,
-	.vop_release		= xfs_release,
-	.vop_iflush		= xfs_inode_flush,
-};
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-23 14:41:01.000000000 +0200
@@ -47,6 +47,7 @@
 #include "xfs_utils.h"
 #include "xfs_dfrag.h"
 #include "xfs_fsops.h"
+#include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
 #include <linux/dcache.h>
@@ -436,7 +437,6 @@ xfs_fssetdm_by_handle(
 	struct fsdmidata	fsd;
 	xfs_fsop_setdm_handlereq_t dmhreq;
 	struct inode		*inode;
-	bhv_desc_t		*bdp;
 	bhv_vnode_t		*vp;
 
 	if (!capable(CAP_MKNOD))
@@ -458,8 +458,8 @@ xfs_fssetdm_by_handle(
 		return -XFS_ERROR(EFAULT);
 	}
 
-	bdp = bhv_base_unlocked(VN_BHV_HEAD(vp));
-	error = xfs_set_dmattrs(bdp, fsd.fsd_dmevmask, fsd.fsd_dmstate, NULL);
+	error = xfs_set_dmattrs(xfs_vtoi(vp),
+			fsd.fsd_dmevmask, fsd.fsd_dmstate);
 
 	VN_RELE(vp);
 	if (error)
@@ -676,7 +676,7 @@ xfs_attrmulti_by_handle(
 
 STATIC int
 xfs_ioc_space(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	struct inode		*inode,
 	struct file		*filp,
 	int			flags,
@@ -709,37 +709,31 @@ xfs_ioc_xattr(
 
 STATIC int
 xfs_ioc_getbmap(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	int			flags,
 	unsigned int		cmd,
 	void			__user *arg);
 
 STATIC int
 xfs_ioc_getbmapx(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	void			__user *arg);
 
 int
 xfs_ioctl(
-	bhv_desc_t		*bdp,
-	struct inode		*inode,
+	xfs_inode_t		*ip,
 	struct file		*filp,
 	int			ioflags,
 	unsigned int		cmd,
 	void			__user *arg)
 {
+	struct inode		*inode = filp->f_path.dentry->d_inode;
+	bhv_vnode_t		*vp = vn_from_inode(inode);
+	xfs_mount_t		*mp = ip->i_mount;
 	int			error;
-	bhv_vnode_t		*vp;
-	xfs_inode_t		*ip;
-	xfs_mount_t		*mp;
-
-	vp = vn_from_inode(inode);
 
 	vn_trace_entry(vp, "xfs_ioctl", (inst_t *)__return_address);
 
-	ip = XFS_BHVTOI(bdp);
-	mp = ip->i_mount;
-
 	switch (cmd) {
 
 	case XFS_IOC_ALLOCSP:
@@ -758,7 +752,7 @@ xfs_ioctl(
 		    !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
-		return xfs_ioc_space(bdp, inode, filp, ioflags, cmd, arg);
+		return xfs_ioc_space(ip, inode, filp, ioflags, cmd, arg);
 
 	case XFS_IOC_DIOINFO: {
 		struct dioattr	da;
@@ -801,17 +795,17 @@ xfs_ioctl(
 		if (copy_from_user(&dmi, arg, sizeof(dmi)))
 			return -XFS_ERROR(EFAULT);
 
-		error = xfs_set_dmattrs(bdp, dmi.fsd_dmevmask, dmi.fsd_dmstate,
-							NULL);
+		error = xfs_set_dmattrs(ip, dmi.fsd_dmevmask,
+				dmi.fsd_dmstate);
 		return -error;
 	}
 
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
-		return xfs_ioc_getbmap(bdp, ioflags, cmd, arg);
+		return xfs_ioc_getbmap(ip, ioflags, cmd, arg);
 
 	case XFS_IOC_GETBMAPX:
-		return xfs_ioc_getbmapx(bdp, arg);
+		return xfs_ioc_getbmapx(ip, arg);
 
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
@@ -981,7 +975,7 @@ xfs_ioctl(
 
 STATIC int
 xfs_ioc_space(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	struct inode		*inode,
 	struct file		*filp,
 	int			ioflags,
@@ -1009,7 +1003,7 @@ xfs_ioc_space(
 	if (ioflags & IO_INVIS)
 		attr_flags |= ATTR_DMI;
 
-	error = xfs_change_file_space(bdp, cmd, &bf, filp->f_pos,
+	error = xfs_change_file_space(ip, cmd, &bf, filp->f_pos,
 					      NULL, attr_flags);
 	return -error;
 }
@@ -1295,7 +1289,7 @@ xfs_ioc_xattr(
 
 STATIC int
 xfs_ioc_getbmap(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	int			ioflags,
 	unsigned int		cmd,
 	void			__user *arg)
@@ -1314,7 +1308,7 @@ xfs_ioc_getbmap(
 	if (ioflags & IO_INVIS)
 		iflags |= BMV_IF_NO_DMAPI_READ;
 
-	error = xfs_getbmap(bdp, &bm, (struct getbmap __user *)arg+1, iflags);
+	error = xfs_getbmap(ip, &bm, (struct getbmap __user *)arg+1, iflags);
 	if (error)
 		return -error;
 
@@ -1325,7 +1319,7 @@ xfs_ioc_getbmap(
 
 STATIC int
 xfs_ioc_getbmapx(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*ip,
 	void			__user *arg)
 {
 	struct getbmapx		bmx;
@@ -1352,7 +1346,7 @@ xfs_ioc_getbmapx(
 
 	iflags |= BMV_IF_EXTENDED;
 
-	error = xfs_getbmap(bdp, &bm, (struct getbmapx __user *)arg+1, iflags);
+	error = xfs_getbmap(ip, &bm, (struct getbmapx __user *)arg+1, iflags);
 	if (error)
 		return -error;
 
Index: linux-2.6-xfs/fs/xfs/xfs_rename.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rename.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rename.c	2007-08-23 14:41:01.000000000 +0200
@@ -129,8 +129,7 @@ xfs_lock_for_rename(
 		lock_mode = xfs_ilock_map_shared(dp2);
 	}
 
-	error = xfs_dir_lookup_int(XFS_ITOBHV(dp2), lock_mode,
-				   vname2, &inum2, &ip2);
+	error = xfs_dir_lookup_int(dp2, lock_mode, vname2, &inum2, &ip2);
 	if (error == ENOENT) {		/* target does not need to exist. */
 		inum2 = 0;
 	} else if (error) {
@@ -222,15 +221,15 @@ xfs_lock_for_rename(
  */
 int
 xfs_rename(
-	bhv_desc_t	*src_dir_bdp,
+	xfs_inode_t	*src_dp,
 	bhv_vname_t	*src_vname,
 	bhv_vnode_t	*target_dir_vp,
-	bhv_vname_t	*target_vname,
-	cred_t		*credp)
+	bhv_vname_t	*target_vname)
 {
+	bhv_vnode_t	*src_dir_vp = XFS_ITOV(src_dp);
 	xfs_trans_t	*tp;
-	xfs_inode_t	*src_dp, *target_dp, *src_ip, *target_ip;
-	xfs_mount_t	*mp;
+	xfs_inode_t	*target_dp, *src_ip, *target_ip;
+	xfs_mount_t	*mp = src_dp->i_mount;
 	int		new_parent;		/* moving to a new dir */
 	int		src_is_directory;	/* src_name is a directory */
 	int		error;
@@ -240,7 +239,6 @@ xfs_rename(
 	int		committed;
 	xfs_inode_t	*inodes[4];
 	int		target_ip_dropped = 0;	/* dropped target_ip link? */
-	bhv_vnode_t	*src_dir_vp;
 	int		spaceres;
 	int		target_link_zero = 0;
 	int		num_inodes;
@@ -249,7 +247,6 @@ xfs_rename(
 	int		src_namelen = VNAMELEN(src_vname);
 	int		target_namelen = VNAMELEN(target_vname);
 
-	src_dir_vp = BHV_TO_VNODE(src_dir_bdp);
 	vn_trace_entry(src_dir_vp, "xfs_rename", (inst_t *)__return_address);
 	vn_trace_entry(target_dir_vp, "xfs_rename", (inst_t *)__return_address);
 
@@ -262,9 +259,6 @@ xfs_rename(
 		return XFS_ERROR(EXDEV);
 	}
 
-	src_dp = XFS_BHVTOI(src_dir_bdp);
-	mp = src_dp->i_mount;
-
 	if (DM_EVENT_ENABLED(src_dp, DM_EVENT_RENAME) ||
 	    DM_EVENT_ENABLED(target_dp, DM_EVENT_RENAME)) {
 		error = XFS_SEND_NAMESP(mp, DM_EVENT_RENAME,
Index: linux-2.6-xfs/fs/xfs/xfs_rw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_rw.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_rw.h	2007-08-23 14:41:01.000000000 +0200
@@ -90,14 +90,6 @@ extern void xfs_ioerror_alert(char *func
 /*
  * Prototypes for functions in xfs_vnodeops.c.
  */
-extern int xfs_rwlock(bhv_desc_t *bdp, bhv_vrwlock_t write_lock);
-extern void xfs_rwunlock(bhv_desc_t *bdp, bhv_vrwlock_t write_lock);
-extern int xfs_setattr(bhv_desc_t *, bhv_vattr_t *vap, int flags,
-			cred_t *credp);
-extern int xfs_change_file_space(bhv_desc_t *bdp, int cmd, xfs_flock64_t *bf,
-			xfs_off_t offset, cred_t *credp, int flags);
-extern int xfs_set_dmattrs(bhv_desc_t *bdp, u_int evmask, u_int16_t state,
-			cred_t *credp);
 extern int xfs_free_eofblocks(struct xfs_mount *mp, struct xfs_inode *ip,
 			int flags);
 
Index: linux-2.6-xfs/fs/xfs/xfs_utils.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.c	2007-08-23 14:41:01.000000000 +0200
@@ -65,20 +65,15 @@ xfs_get_dir_entry(
 
 int
 xfs_dir_lookup_int(
-	bhv_desc_t	*dir_bdp,
+	xfs_inode_t	*dp,
 	uint		lock_mode,
 	bhv_vname_t	*dentry,
 	xfs_ino_t	*inum,
 	xfs_inode_t	**ipp)
 {
-	bhv_vnode_t	*dir_vp;
-	xfs_inode_t	*dp;
 	int		error;
 
-	dir_vp = BHV_TO_VNODE(dir_bdp);
-	vn_trace_entry(dir_vp, __FUNCTION__, (inst_t *)__return_address);
-
-	dp = XFS_BHVTOI(dir_bdp);
+	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
 
 	error = xfs_dir_lookup(NULL, dp, VNAME(dentry), VNAMELEN(dentry), inum);
 	if (!error) {
Index: linux-2.6-xfs/fs/xfs/xfs_utils.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_utils.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_utils.h	2007-08-23 14:41:01.000000000 +0200
@@ -23,10 +23,8 @@
 #define	ITRACE(ip)	vn_trace_ref(XFS_ITOV(ip), __FILE__, __LINE__, \
 				(inst_t *)__return_address)
 
-extern int xfs_rename (bhv_desc_t *, bhv_vname_t *, bhv_vnode_t *,
-			bhv_vname_t *, cred_t *);
 extern int xfs_get_dir_entry (bhv_vname_t *, xfs_inode_t **);
-extern int xfs_dir_lookup_int (bhv_desc_t *, uint, bhv_vname_t *, xfs_ino_t *,
+extern int xfs_dir_lookup_int (xfs_inode_t *, uint, bhv_vname_t *, xfs_ino_t *,
 				xfs_inode_t **);
 extern int xfs_truncate_file (xfs_mount_t *, xfs_inode_t *);
 extern int xfs_dir_ialloc (xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
Index: linux-2.6-xfs/fs/xfs/Makefile-linux-2.6
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/Makefile-linux-2.6	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/Makefile-linux-2.6	2007-08-23 14:41:01.000000000 +0200
@@ -79,6 +79,7 @@ xfs-y				+= xfs_alloc.o \
 				   xfs_utils.o \
 				   xfs_vfsops.o \
 				   xfs_vnodeops.o \
+				   xfs_vnodeops_bhv.o \
 				   xfs_rw.o \
 				   xfs_dmops.o \
 				   xfs_qmops.o
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2007-08-23 14:41:01.000000000 +0200
@@ -0,0 +1,86 @@
+#ifndef _XFS_VNODEOPS_H
+#define _XFS_VNODEOPS_H 1
+
+struct attrlist_cursor_kern;
+struct bhv_vattr;
+struct cred;
+struct file;
+struct inode;
+struct iovec;
+struct kiocb;
+struct pipe_inode_info;
+struct uio;
+struct xfs_inode;
+struct xfs_iomap;
+
+
+int xfs_open(struct xfs_inode *ip);
+int xfs_getattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags);
+int xfs_setattr(struct xfs_inode *ip, struct bhv_vattr *vap, int flags,
+		struct cred *credp);
+int xfs_access(struct xfs_inode *ip, int mode, struct cred *credp);
+int xfs_readlink(struct xfs_inode *ip, char *link);
+int xfs_fsync(struct xfs_inode *ip, int flag, xfs_off_t start,
+		xfs_off_t stop);
+int xfs_release(struct xfs_inode *ip);
+int xfs_inactive(struct xfs_inode *ip);
+int xfs_lookup(struct xfs_inode *dp, bhv_vname_t *dentry,
+		bhv_vnode_t **vpp);
+int xfs_create(struct xfs_inode *dp, bhv_vname_t *dentry,
+		struct bhv_vattr *vap, bhv_vnode_t **vpp, struct cred *credp);
+int xfs_remove(struct xfs_inode *dp, bhv_vname_t	*dentry);
+int xfs_link(struct xfs_inode *tdp, bhv_vnode_t *src_vp,
+		bhv_vname_t *dentry);
+int xfs_mkdir(struct xfs_inode *dp, bhv_vname_t *dentry,
+		struct bhv_vattr *vap, bhv_vnode_t **vpp, struct cred *credp);
+int xfs_rmdir(struct xfs_inode *dp, bhv_vname_t *dentry);
+int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
+		       xfs_off_t *offset, filldir_t filldir);
+int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
+		struct bhv_vattr *vap, char *target_path,
+		bhv_vnode_t **vpp, struct cred *credp);
+int xfs_fid2(struct xfs_inode *ip, fid_t	*fidp);
+int xfs_rwlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
+void xfs_rwunlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
+int xfs_inode_flush(struct xfs_inode *ip, int flags);
+int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
+int xfs_reclaim(struct xfs_inode *ip);
+int xfs_change_file_space(struct xfs_inode *ip, int cmd,
+		xfs_flock64_t *bf, xfs_off_t offset,
+		struct cred *credp, int	attr_flags);
+int xfs_rename(struct xfs_inode *src_dp, bhv_vname_t *src_vname,
+		bhv_vnode_t *target_dir_vp, bhv_vname_t *target_vname);
+int xfs_attr_get(struct xfs_inode *ip, const char *name, char *value,
+		int *valuelenp, int flags, cred_t *cred);
+int xfs_attr_set(struct xfs_inode *dp, const char *name, char *value,
+		int valuelen, int flags);
+int xfs_attr_remove(struct xfs_inode *dp, const char *name, int flags);
+int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
+		int flags, struct attrlist_cursor_kern *cursor);
+int xfs_ioctl(struct xfs_inode *ip, struct file *filp,
+		int ioflags, unsigned int cmd, void __user *arg);
+ssize_t xfs_read(struct xfs_inode *ip, struct kiocb *iocb,
+		const struct iovec *iovp, unsigned int segs,
+		loff_t *offset, int ioflags);
+ssize_t xfs_sendfile(struct xfs_inode *ip, struct file *filp,
+		loff_t *offset, int ioflags, size_t count,
+		read_actor_t actor, void *target);
+ssize_t xfs_splice_read(struct xfs_inode *ip, struct file *infilp,
+		loff_t *ppos, struct pipe_inode_info *pipe, size_t count,
+		int flags, int ioflags);
+ssize_t xfs_splice_write(struct xfs_inode *ip,
+		struct pipe_inode_info *pipe, struct file *outfilp,
+		loff_t *ppos, size_t count, int flags, int ioflags);
+ssize_t xfs_write(struct xfs_inode *xip, struct kiocb *iocb,
+		const struct iovec *iovp, unsigned int nsegs,
+		loff_t *offset, int ioflags);
+int xfs_bmap(struct xfs_inode *ip, xfs_off_t offset, ssize_t count,
+		int flags, struct xfs_iomap *iomapp, int *niomaps);
+void xfs_tosspages(struct xfs_inode *inode, xfs_off_t first,
+		xfs_off_t last, int fiopt);
+int xfs_flushinval_pages(struct xfs_inode *ip, xfs_off_t first,
+		xfs_off_t last, int fiopt);
+int xfs_flush_pages(struct xfs_inode *ip, xfs_off_t first,
+		xfs_off_t last, uint64_t flags, int fiopt);
+
+#endif /* _XFS_VNODEOPS_H */
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops_bhv.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops_bhv.c	2007-08-23 14:41:01.000000000 +0200
@@ -0,0 +1,438 @@
+
+#include "xfs_linux.h"
+#include "xfs_vnodeops.h"
+
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+
+STATIC int
+xfs_bhv_open(
+	bhv_desc_t	*bdp,
+	cred_t		*credp)
+{
+	return xfs_open(XFS_BHVTOI(bdp));
+}
+
+STATIC int
+xfs_bhv_getattr(
+	bhv_desc_t	*bdp,
+	bhv_vattr_t	*vap,
+	int		flags,
+	cred_t		*credp)
+{
+	return xfs_getattr(XFS_BHVTOI(bdp), vap, flags);
+}
+
+int
+xfs_bhv_setattr(
+	bhv_desc_t		*bdp,
+	bhv_vattr_t		*vap,
+	int			flags,
+	cred_t			*credp)
+{
+	return xfs_setattr(XFS_BHVTOI(bdp), vap, flags, credp);
+}
+
+STATIC int
+xfs_bhv_access(
+	bhv_desc_t	*bdp,
+	int		mode,
+	cred_t		*credp)
+{
+	return xfs_access(XFS_BHVTOI(bdp), mode, credp);
+}
+
+STATIC int
+xfs_bhv_readlink(
+	bhv_desc_t	*bdp,
+	char		*link)
+{
+	return xfs_readlink(XFS_BHVTOI(bdp), link);
+}
+
+STATIC int
+xfs_bhv_fsync(
+	bhv_desc_t	*bdp,
+	int		flag,
+	cred_t		*credp,
+	xfs_off_t	start,
+	xfs_off_t	stop)
+{
+	return xfs_fsync(XFS_BHVTOI(bdp), flag, start, stop);
+}
+
+STATIC int
+xfs_bhv_release(
+	bhv_desc_t	*bdp)
+{
+	return xfs_release(XFS_BHVTOI(bdp));
+}
+
+STATIC int
+xfs_bhv_inactive(
+	bhv_desc_t	*bdp,
+	cred_t		*credp)
+{
+	return xfs_inactive(XFS_BHVTOI(bdp));
+}
+
+STATIC int
+xfs_bhv_lookup(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	bhv_vnode_t		**vpp,
+	int			flags,
+	bhv_vnode_t		*rdir,
+	cred_t			*credp)
+{
+	return xfs_lookup(XFS_BHVTOI(dir_bdp), dentry, vpp);
+}
+
+STATIC int
+xfs_bhv_create(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	bhv_vattr_t		*vap,
+	bhv_vnode_t		**vpp,
+	cred_t			*credp)
+{
+	return xfs_create(XFS_BHVTOI(dir_bdp), dentry, vap, vpp, credp);
+}
+
+STATIC int
+xfs_bhv_remove(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	cred_t			*credp)
+{
+	return xfs_remove(XFS_BHVTOI(dir_bdp), dentry);
+}
+
+STATIC int
+xfs_bhv_link(
+	bhv_desc_t		*target_dir_bdp,
+	bhv_vnode_t		*src_vp,
+	bhv_vname_t		*dentry,
+	cred_t			*credp)
+{
+	return xfs_link(XFS_BHVTOI(target_dir_bdp), src_vp, dentry);
+}
+
+STATIC int
+xfs_bhv_mkdir(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	bhv_vattr_t		*vap,
+	bhv_vnode_t		**vpp,
+	cred_t			*credp)
+{
+	return xfs_mkdir(XFS_BHVTOI(dir_bdp), dentry, vap, vpp, credp);
+}
+
+STATIC int
+xfs_bhv_rmdir(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	cred_t			*credp)
+{
+	return xfs_rmdir(XFS_BHVTOI(dir_bdp), dentry);
+}
+
+STATIC int
+xfs_bhv_readdir(
+	bhv_desc_t	*dir_bdp,
+	void		*dirent,
+	size_t		bufsize,
+	xfs_off_t	*offset,
+	filldir_t	filldir)
+{
+	return xfs_readdir(XFS_BHVTOI(dir_bdp), dirent, bufsize, offset, filldir);
+}
+
+STATIC int
+xfs_bhv_symlink(
+	bhv_desc_t		*dir_bdp,
+	bhv_vname_t		*dentry,
+	bhv_vattr_t		*vap,
+	char			*target_path,
+	bhv_vnode_t		**vpp,
+	cred_t			*credp)
+{
+	return xfs_symlink(XFS_BHVTOI(dir_bdp), dentry, vap, target_path, vpp, credp);
+}
+
+STATIC int
+xfs_bhv_fid2(
+	bhv_desc_t	*bdp,
+	fid_t		*fidp)
+{
+	return xfs_fid2(XFS_BHVTOI(bdp), fidp);
+}
+
+STATIC int
+xfs_bhv_rwlock(
+	bhv_desc_t	*bdp,
+	bhv_vrwlock_t	locktype)
+{
+	return xfs_rwlock(XFS_BHVTOI(bdp), locktype);
+}
+
+STATIC void
+xfs_bhv_rwunlock(
+	bhv_desc_t	*bdp,
+	bhv_vrwlock_t	locktype)
+{
+	xfs_rwunlock(XFS_BHVTOI(bdp), locktype);
+}
+
+STATIC int
+xfs_bhv_inode_flush(
+	bhv_desc_t	*bdp,
+	int		flags)
+{
+	return xfs_inode_flush(XFS_BHVTOI(bdp), flags);
+}
+
+STATIC int
+xfs_bhv_reclaim(
+	bhv_desc_t	*bdp)
+{
+	return xfs_reclaim(XFS_BHVTOI(bdp));
+}
+
+STATIC int
+xfs_bhv_rename(
+	bhv_desc_t	*src_dir_bdp,
+	bhv_vname_t	*src_vname,
+	bhv_vnode_t	*target_dir_vp,
+	bhv_vname_t	*target_vname,
+	cred_t		*credp)
+{
+	return xfs_rename(XFS_BHVTOI(src_dir_bdp), src_vname,
+			target_dir_vp, target_vname);
+}
+
+STATIC int
+xfs_bhv_attr_get(
+	bhv_desc_t	*bdp,
+	const char	*name,
+	char		*value,
+	int		*valuelenp,
+	int		flags,
+	cred_t		*cred)
+{
+	return xfs_attr_get(XFS_BHVTOI(bdp), name, value, valuelenp,
+			flags, cred);
+}
+
+STATIC int
+xfs_bhv_attr_set(
+	bhv_desc_t	*bdp,
+	const char	*name,
+	char		*value,
+	int		valuelen,
+	int		flags,
+	cred_t		*cred)
+{
+	return xfs_attr_set(XFS_BHVTOI(bdp), name, value, valuelen,
+			flags);
+}
+
+STATIC int
+xfs_bhv_attr_remove(
+	bhv_desc_t	*bdp,
+	const char	*name,
+	int		flags,
+	cred_t		*cred)
+{
+	return xfs_attr_remove(XFS_BHVTOI(bdp), name, flags);
+}
+
+STATIC int
+xfs_bhv_attr_list(
+	bhv_desc_t	*bdp,
+	char		*buffer,
+	int		bufsize,
+	int		flags,
+	struct attrlist_cursor_kern *cursor,
+	cred_t		*cred)
+{
+	return xfs_attr_list(XFS_BHVTOI(bdp), buffer, bufsize, flags,
+			cursor);
+}
+
+STATIC int
+xfs_bhv_ioctl(
+	bhv_desc_t		*bdp,
+	struct inode		*inode,
+	struct file		*filp,
+	int			ioflags,
+	unsigned int		cmd,
+	void			__user *arg)
+{
+	return xfs_ioctl(XFS_BHVTOI(bdp), filp, ioflags, cmd, arg);
+}
+
+STATIC ssize_t
+xfs_bhv_read(
+	bhv_desc_t		*bdp,
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned int		segs,
+	loff_t			*offset,
+	int			ioflags,
+	cred_t			*credp)
+{
+	return xfs_read(XFS_BHVTOI(bdp), iocb, iovp, segs,
+			offset, ioflags);
+}
+
+STATIC ssize_t
+xfs_bhv_sendfile(
+	bhv_desc_t		*bdp,
+	struct file		*filp,
+	loff_t			*offset,
+	int			ioflags,
+	size_t			count,
+	read_actor_t		actor,
+	void			*target,
+	cred_t			*credp)
+{
+	return xfs_sendfile(XFS_BHVTOI(bdp), filp, offset, ioflags,
+			count, actor, target);
+}
+
+STATIC ssize_t
+xfs_bhv_splice_read(
+	bhv_desc_t		*bdp,
+	struct file		*infilp,
+	loff_t			*ppos,
+	struct pipe_inode_info	*pipe,
+	size_t			count,
+	int			flags,
+	int			ioflags,
+	cred_t			*credp)
+{
+	return xfs_splice_read(XFS_BHVTOI(bdp), infilp, ppos, pipe,
+			count, flags, ioflags);
+}
+
+STATIC ssize_t
+xfs_bhv_splice_write(
+	bhv_desc_t		*bdp,
+	struct pipe_inode_info	*pipe,
+	struct file		*outfilp,
+	loff_t			*ppos,
+	size_t			count,
+	int			flags,
+	int			ioflags,
+	cred_t			*credp)
+{
+	return xfs_splice_write(XFS_BHVTOI(bdp), pipe, outfilp, ppos,
+			count, flags, ioflags);
+}
+
+STATIC ssize_t
+xfs_bhv_write(
+	bhv_desc_t		*bdp,
+	struct kiocb		*iocb,
+	const struct iovec	*iovp,
+	unsigned int		nsegs,
+	loff_t			*offset,
+	int			ioflags,
+	cred_t			*credp)
+{
+	return xfs_write(XFS_BHVTOI(bdp), iocb, iovp, nsegs, offset,
+			ioflags);
+}
+
+STATIC int
+xfs_bhv_bmap(bhv_desc_t	*bdp,
+	xfs_off_t	offset,
+	ssize_t		count,
+	int		flags,
+	struct xfs_iomap *iomapp,
+	int		*niomaps)
+{
+	return xfs_bmap(XFS_BHVTOI(bdp), offset, count, flags,
+			iomapp, niomaps);
+}
+
+STATIC void
+fs_tosspages(
+	bhv_desc_t	*bdp,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	xfs_tosspages(XFS_BHVTOI(bdp), first, last, fiopt);
+}
+
+STATIC int
+fs_flushinval_pages(
+	bhv_desc_t	*bdp,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	int		fiopt)
+{
+	return xfs_flushinval_pages(XFS_BHVTOI(bdp), first, last,
+			fiopt);
+}
+
+STATIC int
+fs_flush_pages(
+	bhv_desc_t	*bdp,
+	xfs_off_t	first,
+	xfs_off_t	last,
+	uint64_t	flags,
+	int		fiopt)
+{
+	return xfs_flush_pages(XFS_BHVTOI(bdp), first, last, flags,
+			fiopt);
+}
+
+bhv_vnodeops_t xfs_vnodeops = {
+	BHV_IDENTITY_INIT(VN_BHV_XFS,VNODE_POSITION_XFS),
+	.vop_open		= xfs_bhv_open,
+	.vop_read		= xfs_bhv_read,
+#ifdef HAVE_SENDFILE
+	.vop_sendfile		= xfs_bhv_sendfile,
+#endif
+#ifdef HAVE_SPLICE
+	.vop_splice_read	= xfs_bhv_splice_read,
+	.vop_splice_write	= xfs_bhv_splice_write,
+#endif
+	.vop_write		= xfs_bhv_write,
+	.vop_ioctl		= xfs_bhv_ioctl,
+	.vop_getattr		= xfs_bhv_getattr,
+	.vop_setattr		= xfs_bhv_setattr,
+	.vop_access		= xfs_bhv_access,
+	.vop_lookup		= xfs_bhv_lookup,
+	.vop_create		= xfs_bhv_create,
+	.vop_remove		= xfs_bhv_remove,
+	.vop_link		= xfs_bhv_link,
+	.vop_rename		= xfs_bhv_rename,
+	.vop_mkdir		= xfs_bhv_mkdir,
+	.vop_rmdir		= xfs_bhv_rmdir,
+	.vop_readdir		= xfs_bhv_readdir,
+	.vop_symlink		= xfs_bhv_symlink,
+	.vop_readlink		= xfs_bhv_readlink,
+	.vop_fsync		= xfs_bhv_fsync,
+	.vop_inactive		= xfs_bhv_inactive,
+	.vop_fid2		= xfs_bhv_fid2,
+	.vop_rwlock		= xfs_bhv_rwlock,
+	.vop_rwunlock		= xfs_bhv_rwunlock,
+	.vop_bmap		= xfs_bhv_bmap,
+	.vop_reclaim		= xfs_bhv_reclaim,
+	.vop_attr_get		= xfs_bhv_attr_get,
+	.vop_attr_set		= xfs_bhv_attr_set,
+	.vop_attr_remove	= xfs_bhv_attr_remove,
+	.vop_attr_list		= xfs_bhv_attr_list,
+	.vop_link_removed	= (vop_link_removed_t)fs_noval,
+	.vop_vnode_change	= (vop_vnode_change_t)fs_noval,
+	.vop_tosspages		= fs_tosspages,
+	.vop_flushinval_pages	= fs_flushinval_pages,
+	.vop_flush_pages	= fs_flush_pages,
+	.vop_release		= xfs_bhv_release,
+	.vop_iflush		= xfs_bhv_inode_flush,
+};
Index: linux-2.6-xfs/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.c	2007-08-23 14:41:01.000000000 +0200
@@ -156,10 +156,14 @@ xfs_attr_fetch(xfs_inode_t *ip, const ch
 }
 
 int
-xfs_attr_get(bhv_desc_t *bdp, const char *name, char *value, int *valuelenp,
-	     int flags, struct cred *cred)
+xfs_attr_get(
+	xfs_inode_t	*ip,
+	const char	*name,
+	char		*value,
+	int		*valuelenp,
+	int		flags,
+	cred_t		*cred)
 {
-	xfs_inode_t	*ip = XFS_BHVTOI(bdp);
 	int		error, namelen;
 
 	XFS_STATS_INC(xs_attr_get);
@@ -417,10 +421,13 @@ out:
 }
 
 int
-xfs_attr_set(bhv_desc_t *bdp, const char *name, char *value, int valuelen, int flags,
-	     struct cred *cred)
+xfs_attr_set(
+	xfs_inode_t	*dp,
+	const char	*name,
+	char		*value,
+	int		valuelen,
+	int		flags)
 {
-	xfs_inode_t	*dp;
 	int             namelen;
 
 	namelen = strlen(name);
@@ -429,7 +436,6 @@ xfs_attr_set(bhv_desc_t *bdp, const char
 
 	XFS_STATS_INC(xs_attr_set);
 
-	dp = XFS_BHVTOI(bdp);
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
@@ -563,10 +569,12 @@ out:
 }
 
 int
-xfs_attr_remove(bhv_desc_t *bdp, const char *name, int flags, struct cred *cred)
+xfs_attr_remove(
+	xfs_inode_t	*dp,
+	const char	*name,
+	int		flags)
 {
-	xfs_inode_t         *dp;
-	int                 namelen;
+	int		namelen;
 
 	namelen = strlen(name);
 	if (namelen >= MAXNAMELEN)
@@ -574,7 +582,6 @@ xfs_attr_remove(bhv_desc_t *bdp, const c
 
 	XFS_STATS_INC(xs_attr_remove);
 
-	dp = XFS_BHVTOI(bdp);
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return (EIO);
 
@@ -702,11 +709,14 @@ xfs_attr_kern_list_sizes(xfs_attr_list_c
  * success.
  */
 int
-xfs_attr_list(bhv_desc_t *bdp, char *buffer, int bufsize, int flags,
-		      attrlist_cursor_kern_t *cursor, struct cred *cred)
+xfs_attr_list(
+	xfs_inode_t	*dp,
+	char		*buffer,
+	int		bufsize,
+	int		flags,
+	attrlist_cursor_kern_t *cursor)
 {
 	xfs_attr_list_context_t context;
-	xfs_inode_t *dp;
 	int error;
 
 	XFS_STATS_INC(xs_attr_list);
@@ -731,7 +741,7 @@ xfs_attr_list(bhv_desc_t *bdp, char *buf
 	/*
 	 * Initialize the output buffer.
 	 */
-	context.dp = dp = XFS_BHVTOI(bdp);
+	context.dp = dp;
 	context.cursor = cursor;
 	context.count = 0;
 	context.dupcnt = 0;
Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2007-08-23 14:41:01.000000000 +0200
@@ -159,12 +159,8 @@ struct xfs_da_args;
 /*
  * Overall external interface routines.
  */
-int xfs_attr_get(bhv_desc_t *, const char *, char *, int *, int, struct cred *);
-int xfs_attr_set(bhv_desc_t *, const char *, char *, int, int, struct cred *);
 int xfs_attr_set_int(struct xfs_inode *, const char *, int, char *, int, int);
-int xfs_attr_remove(bhv_desc_t *, const char *, int, struct cred *);
 int xfs_attr_remove_int(struct xfs_inode *, const char *, int, int);
-int xfs_attr_list(bhv_desc_t *, char *, int, int, struct attrlist_cursor_kern *, struct cred *);
 int xfs_attr_list_int(struct xfs_attr_list_context *);
 int xfs_attr_inactive(struct xfs_inode *dp);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.h	2007-08-23 14:41:01.000000000 +0200
@@ -26,8 +26,6 @@ extern const struct file_operations xfs_
 extern const struct file_operations xfs_dir_file_operations;
 extern const struct file_operations xfs_invis_file_operations;
 
-extern int xfs_ioctl(struct bhv_desc *, struct inode *, struct file *,
-                        int, unsigned int, void __user *);
 
 struct xfs_inode;
 extern void xfs_ichgtime(struct xfs_inode *, int);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.c	2007-08-23 14:41:01.000000000 +0200
@@ -48,6 +48,7 @@
 #include "xfs_buf_item.h"
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
+#include "xfs_vnodeops.h"
 
 #include <linux/capability.h>
 #include <linux/writeback.h>
@@ -180,27 +181,22 @@ unlock:
 
 ssize_t			/* bytes read, or (-)  error */
 xfs_read(
-	bhv_desc_t		*bdp,
+	xfs_inode_t		*ip,
 	struct kiocb		*iocb,
 	const struct iovec	*iovp,
 	unsigned int		segs,
 	loff_t			*offset,
-	int			ioflags,
-	cred_t			*credp)
+	int			ioflags)
 {
 	struct file		*file = iocb->ki_filp;
 	struct inode		*inode = file->f_mapping->host;
+	bhv_vnode_t		*vp = XFS_ITOV(ip);
+	xfs_mount_t		*mp = ip->i_mount;
 	size_t			size = 0;
 	ssize_t			ret = 0;
 	xfs_fsize_t		n;
-	xfs_inode_t		*ip;
-	xfs_mount_t		*mp;
-	bhv_vnode_t		*vp;
 	unsigned long		seg;
 
-	ip = XFS_BHVTOI(bdp);
-	vp = BHV_TO_VNODE(bdp);
-	mp = ip->i_mount;
 
 	XFS_STATS_INC(xs_read_calls);
 
@@ -249,8 +245,7 @@ xfs_read(
 		bhv_vrwlock_t locktype = VRWLOCK_READ;
 		int dmflags = FILP_DELAY_FLAG(file) | DM_SEM_FLAG_RD(ioflags);
 
-		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ,
-					BHV_TO_VNODE(bdp), *offset, size,
+		ret = -XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *offset, size,
 					dmflags, &locktype);
 		if (ret) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -287,16 +282,15 @@ xfs_read(
 
 ssize_t
 xfs_sendfile(
-	bhv_desc_t		*bdp,
+	xfs_inode_t		*ip,
 	struct file		*filp,
 	loff_t			*offset,
 	int			ioflags,
 	size_t			count,
 	read_actor_t		actor,
-	void			*target,
-	cred_t			*credp)
+	void			*target)
 {
-	xfs_inode_t		*ip = XFS_BHVTOI(bdp);
+	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	ssize_t			ret;
 
@@ -310,8 +304,7 @@ xfs_sendfile(
 		bhv_vrwlock_t locktype = VRWLOCK_READ;
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, BHV_TO_VNODE(bdp),
-				      *offset, count,
+		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *offset, count,
 				      FILP_DELAY_FLAG(filp), &locktype);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -330,16 +323,15 @@ xfs_sendfile(
 
 ssize_t
 xfs_splice_read(
-	bhv_desc_t		*bdp,
+	xfs_inode_t		*ip,
 	struct file		*infilp,
 	loff_t			*ppos,
 	struct pipe_inode_info	*pipe,
 	size_t			count,
 	int			flags,
-	int			ioflags,
-	cred_t			*credp)
+	int			ioflags)
 {
-	xfs_inode_t		*ip = XFS_BHVTOI(bdp);
+	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	ssize_t			ret;
 
@@ -353,8 +345,7 @@ xfs_splice_read(
 		bhv_vrwlock_t locktype = VRWLOCK_READ;
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_READ, BHV_TO_VNODE(bdp),
-					*ppos, count,
+		error = XFS_SEND_DATA(mp, DM_EVENT_READ, vp, *ppos, count,
 					FILP_DELAY_FLAG(infilp), &locktype);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_SHARED);
@@ -373,16 +364,15 @@ xfs_splice_read(
 
 ssize_t
 xfs_splice_write(
-	bhv_desc_t		*bdp,
+	xfs_inode_t		*ip,
 	struct pipe_inode_info	*pipe,
 	struct file		*outfilp,
 	loff_t			*ppos,
 	size_t			count,
 	int			flags,
-	int			ioflags,
-	cred_t			*credp)
+	int			ioflags)
 {
-	xfs_inode_t		*ip = XFS_BHVTOI(bdp);
+	bhv_vnode_t		*vp = XFS_ITOV(ip);
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_iocore_t		*io = &ip->i_iocore;
 	ssize_t			ret;
@@ -399,8 +389,7 @@ xfs_splice_write(
 		bhv_vrwlock_t locktype = VRWLOCK_WRITE;
 		int error;
 
-		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, BHV_TO_VNODE(bdp),
-					*ppos, count,
+		error = XFS_SEND_DATA(mp, DM_EVENT_WRITE, vp, *ppos, count,
 					FILP_DELAY_FLAG(outfilp), &locktype);
 		if (error) {
 			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
@@ -634,24 +623,22 @@ out_lock:
 
 ssize_t				/* bytes written, or (-) error */
 xfs_write(
-	bhv_desc_t		*bdp,
+	struct xfs_inode	*xip,
 	struct kiocb		*iocb,
 	const struct iovec	*iovp,
 	unsigned int		nsegs,
 	loff_t			*offset,
-	int			ioflags,
-	cred_t			*credp)
+	int			ioflags)
 {
 	struct file		*file = iocb->ki_filp;
 	struct address_space	*mapping = file->f_mapping;
 	struct inode		*inode = mapping->host;
+	bhv_vnode_t		*vp = XFS_ITOV(xip);
 	unsigned long		segs = nsegs;
-	xfs_inode_t		*xip;
 	xfs_mount_t		*mp;
 	ssize_t			ret = 0, error = 0;
 	xfs_fsize_t		isize, new_size;
 	xfs_iocore_t		*io;
-	bhv_vnode_t		*vp;
 	unsigned long		seg;
 	int			iolock;
 	int			eventsent = 0;
@@ -662,9 +649,6 @@ xfs_write(
 
 	XFS_STATS_INC(xs_write_calls);
 
-	vp = BHV_TO_VNODE(bdp);
-	xip = XFS_BHVTOI(bdp);
-
 	for (seg = 0; seg < segs; seg++) {
 		const struct iovec *iv = &iovp[seg];
 
@@ -789,7 +773,7 @@ start:
 	 */
 
 	if (pos > xip->i_size) {
-		error = xfs_zero_eof(BHV_TO_VNODE(bdp), io, pos, xip->i_size);
+		error = xfs_zero_eof(vp, io, pos, xip->i_size);
 		if (error) {
 			xfs_iunlock(xip, XFS_ILOCK_EXCL);
 			goto out_unlock_internal;
@@ -874,7 +858,7 @@ retry:
 
 	if (ret == -ENOSPC &&
 	    DM_EVENT_ENABLED(xip, DM_EVENT_NOSPACE) && !(ioflags & IO_INVIS)) {
-		xfs_rwunlock(bdp, locktype);
+		xfs_rwunlock(xip, locktype);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 		error = XFS_SEND_NAMESP(xip->i_mount, DM_EVENT_NOSPACE, vp,
@@ -882,7 +866,7 @@ retry:
 				0, 0, 0); /* Delay flag intentionally  unused */
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_rwlock(bdp, locktype);
+		xfs_rwlock(xip, locktype);
 		if (error)
 			goto out_unlock_internal;
 		pos = xip->i_size;
@@ -913,7 +897,7 @@ retry:
 		if (error)
 			goto out_unlock_internal;
 
-		xfs_rwunlock(bdp, locktype);
+		xfs_rwunlock(xip, locktype);
 		if (need_i_mutex)
 			mutex_unlock(&inode->i_mutex);
 
@@ -922,7 +906,7 @@ retry:
 			error = -ret;
 		if (need_i_mutex)
 			mutex_lock(&inode->i_mutex);
-		xfs_rwlock(bdp, locktype);
+		xfs_rwlock(xip, locktype);
 	}
 
  out_unlock_internal:
@@ -940,7 +924,7 @@ retry:
 			xip->i_d.di_size = xip->i_size;
 		xfs_iunlock(xip, XFS_ILOCK_EXCL);
 	}
-	xfs_rwunlock(bdp, locktype);
+	xfs_rwunlock(xip, locktype);
  out_unlock_mutex:
 	if (need_i_mutex)
 		mutex_unlock(&inode->i_mutex);
@@ -979,14 +963,14 @@ xfs_bdstrat_cb(struct xfs_buf *bp)
 
 
 int
-xfs_bmap(bhv_desc_t	*bdp,
+xfs_bmap(
+	xfs_inode_t	*ip,
 	xfs_off_t	offset,
 	ssize_t		count,
 	int		flags,
 	xfs_iomap_t	*iomapp,
 	int		*niomaps)
 {
-	xfs_inode_t	*ip = XFS_BHVTOI(bdp);
 	xfs_iocore_t	*io = &ip->i_iocore;
 
 	ASSERT((ip->i_d.di_mode & S_IFMT) == S_IFREG);
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.c	2007-08-23 14:41:01.000000000 +0200
@@ -5764,7 +5764,7 @@ xfs_getbmapx_fix_eof_hole(
  */
 int						/* error code */
 xfs_getbmap(
-	bhv_desc_t		*bdp,		/* XFS behavior descriptor*/
+	xfs_inode_t		*ip,
 	struct getbmap		*bmv,		/* user bmap structure */
 	void			__user *ap,	/* pointer to user's array */
 	int			interface)	/* interface flags */
@@ -5773,7 +5773,6 @@ xfs_getbmap(
 	int			error;		/* return value */
 	__int64_t		fixlen;		/* length for -1 case */
 	int			i;		/* extent number */
-	xfs_inode_t		*ip;		/* xfs incore inode pointer */
 	bhv_vnode_t		*vp;		/* corresponding vnode */
 	int			lock;		/* lock state */
 	xfs_bmbt_irec_t		*map;		/* buffer for user's data */
@@ -5791,8 +5790,7 @@ xfs_getbmap(
 	int			bmapi_flags;	/* flags for xfs_bmapi */
 	__int32_t		oflags;		/* getbmapx bmv_oflags field */
 
-	vp = BHV_TO_VNODE(bdp);
-	ip = XFS_BHVTOI(bdp);
+	vp = XFS_ITOV(ip);
 	mp = ip->i_mount;
 
 	whichfork = interface & BMV_IF_ATTRFORK ? XFS_ATTR_FORK : XFS_DATA_FORK;
Index: linux-2.6-xfs/fs/xfs/xfs_bmap.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_bmap.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_bmap.h	2007-08-23 14:41:01.000000000 +0200
@@ -335,7 +335,7 @@ xfs_bunmapi(
  */
 int						/* error code */
 xfs_getbmap(
-	bhv_desc_t		*bdp,		/* XFS behavior descriptor*/
+	xfs_inode_t		*ip,
 	struct getbmap		*bmv,		/* user bmap structure */
 	void			__user *ap,	/* pointer to user's array */
 	int			iflags);	/* interface flags */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-23 14:41:01.000000000 +0200
@@ -71,28 +71,11 @@ extern void xfs_inval_cached_trace(struc
 #define xfs_inval_cached_trace(io, offset, len, first, last)
 #endif
 
-extern int xfs_bmap(struct bhv_desc *, xfs_off_t, ssize_t, int,
-			struct xfs_iomap *, int *);
 extern int xfsbdstrat(struct xfs_mount *, struct xfs_buf *);
 extern int xfs_bdstrat_cb(struct xfs_buf *);
 extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
 
 extern int xfs_zero_eof(struct bhv_vnode *, struct xfs_iocore *, xfs_off_t,
 				xfs_fsize_t);
-extern ssize_t xfs_read(struct bhv_desc *, struct kiocb *,
-				const struct iovec *, unsigned int,
-				loff_t *, int, struct cred *);
-extern ssize_t xfs_write(struct bhv_desc *, struct kiocb *,
-				const struct iovec *, unsigned int,
-				loff_t *, int, struct cred *);
-extern ssize_t xfs_sendfile(struct bhv_desc *, struct file *,
-				loff_t *, int, size_t, read_actor_t,
-				void *, struct cred *);
-extern ssize_t xfs_splice_read(struct bhv_desc *, struct file *, loff_t *,
-				struct pipe_inode_info *, size_t, int, int,
-				struct cred *);
-extern ssize_t xfs_splice_write(struct bhv_desc *, struct pipe_inode_info *,
-				struct file *, loff_t *, size_t, int, int,
-				struct cred *);
 
 #endif	/* __XFS_LRW_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.c	2007-08-23 14:41:01.000000000 +0200
@@ -16,66 +16,80 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
+#include "xfs_vnodeops.h"
+
+/*
+ * The following six includes are needed so that we can include
+ * xfs_inode.h.  What a mess..
+ */
+#include "xfs_bmap_btree.h"
+#include "xfs_inum.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_sf.h"
+#include "xfs_attr_sf.h"
+#include "xfs_dinode.h"
+
+#include "xfs_inode.h"
 
 int  fs_noerr(void) { return 0; }
 int  fs_nosys(void) { return ENOSYS; }
 void fs_noval(void) { return; }
 
 void
-fs_tosspages(
-	bhv_desc_t	*bdp,
+xfs_tosspages(
+	xfs_inode_t	*ip,
 	xfs_off_t	first,
 	xfs_off_t	last,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
-	struct inode	*ip = vn_to_inode(vp);
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	struct inode	*inode = vn_to_inode(vp);
 
 	if (VN_CACHED(vp))
-		truncate_inode_pages(ip->i_mapping, first);
+		truncate_inode_pages(inode->i_mapping, first);
 }
 
 int
-fs_flushinval_pages(
-	bhv_desc_t	*bdp,
+xfs_flushinval_pages(
+	xfs_inode_t	*ip,
 	xfs_off_t	first,
 	xfs_off_t	last,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
-	struct inode	*ip = vn_to_inode(vp);
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	struct inode	*inode = vn_to_inode(vp);
 	int		ret = 0;
 
 	if (VN_CACHED(vp)) {
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
-		ret = filemap_write_and_wait(ip->i_mapping);
+		ret = filemap_write_and_wait(inode->i_mapping);
 		if (!ret)
-			truncate_inode_pages(ip->i_mapping, first);
+			truncate_inode_pages(inode->i_mapping, first);
 	}
 	return ret;
 }
 
 int
-fs_flush_pages(
-	bhv_desc_t	*bdp,
+xfs_flush_pages(
+	xfs_inode_t	*ip,
 	xfs_off_t	first,
 	xfs_off_t	last,
 	uint64_t	flags,
 	int		fiopt)
 {
-	bhv_vnode_t	*vp = BHV_TO_VNODE(bdp);
-	struct inode	*ip = vn_to_inode(vp);
+	bhv_vnode_t	*vp = XFS_ITOV(ip);
+	struct inode	*inode = vn_to_inode(vp);
 	int		ret = 0;
 	int		ret2;
 
 	if (VN_DIRTY(vp)) {
 		if (VN_TRUNC(vp))
 			VUNTRUNCATE(vp);
-		ret = filemap_fdatawrite(ip->i_mapping);
+		ret = filemap_fdatawrite(inode->i_mapping);
 		if (flags & XFS_B_ASYNC)
 			return ret;
-		ret2 = filemap_fdatawait(ip->i_mapping);
+		ret2 = filemap_fdatawait(inode->i_mapping);
 		if (!ret)
 			ret = ret2;
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_fs_subr.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_fs_subr.h	2007-08-23 14:41:01.000000000 +0200
@@ -18,12 +18,8 @@
 #ifndef	__XFS_FS_SUBR_H__
 #define __XFS_FS_SUBR_H__
 
-struct cred;
 extern int  fs_noerr(void);
 extern int  fs_nosys(void);
 extern void fs_noval(void);
-extern void fs_tosspages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-extern int  fs_flushinval_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, int);
-extern int  fs_flush_pages(bhv_desc_t *, xfs_off_t, xfs_off_t, uint64_t, int);
 
 #endif	/* __XFS_FS_SUBR_H__ */
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-23 14:41:01.000000000 +0200
@@ -46,6 +46,7 @@
 #include "xfs_attr.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_inode_item.h"
+#include "xfs_vnodeops.h"
 #include <dmapi.h>
 #include <dmapi_kern.h>
 #include "xfs_dm.h"
@@ -178,22 +179,17 @@ xfs_dm_send_data_event(
 	bhv_vrwlock_t	*locktype)
 {
 	int		error;
-	bhv_desc_t	*bdp;
 	xfs_inode_t	*ip;
 	uint16_t	dmstate;
 	struct inode	*inode = vn_to_inode(vp);
 
 	/* Returns positive errors to XFS */
 
-	bdp = bhv_lookup_range(VN_BHV_HEAD(vp),
-			VNODE_POSITION_XFS, VNODE_POSITION_XFS);
-	ASSERT(bdp);
-
 	ip = xfs_vtoi(vp);
 	do {
 		dmstate = ip->i_iocore.io_dmstate;
 		if (locktype)
-			xfs_rwunlock(bdp, *locktype);
+			xfs_rwunlock(ip, *locktype);
 
 		up_rw_sems(inode, flags);
 
@@ -204,7 +200,7 @@ xfs_dm_send_data_event(
 		down_rw_sems(inode, flags);
 
 		if (locktype)
-			xfs_rwlock(bdp, *locktype);
+			xfs_rwlock(ip, *locktype);
 	} while (!error && (ip->i_iocore.io_dmstate != dmstate));
 
 	return error;
@@ -2506,7 +2502,6 @@ xfs_dm_punch_hole(
 {
 	xfs_flock64_t	bf;
 	int		error = 0;
-	bhv_desc_t	*xbdp;
 	xfs_inode_t	*ip;
 	xfs_mount_t	*mp;
 	dm_size_t	align;
@@ -2529,10 +2524,6 @@ xfs_dm_punch_hole(
 	if (error)
 		return -EBUSY;
 
-	xbdp = bhv_lookup_range(VN_BHV_HEAD(vp),
-			VNODE_POSITION_XFS, VNODE_POSITION_XFS);
-	ASSERT(xbdp);
-
 	ip = xfs_vtoi(vp);
 	mp = ip->i_mount;
 
@@ -2585,7 +2576,7 @@ xfs_dm_punch_hole(
 		off, len, align);
 #endif
 
-	error = xfs_change_file_space(xbdp, XFS_IOC_UNRESVSP, &bf,
+	error = xfs_change_file_space(ip, XFS_IOC_UNRESVSP, &bf,
 				(xfs_off_t)off, sys_cred, ATTR_DMI|ATTR_NOLOCK);
 
 	/*
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-08-23 14:41:01.000000000 +0200
@@ -64,6 +64,7 @@
 #include "xfs_utils.h"
 #include "xfs_iomap.h"
 #include "xfs_filestream.h"
+#include "xfs_vnodeops.h"
 #include "support/ktrace.h"
 
 
@@ -150,9 +151,9 @@ EXPORT_SYMBOL(bhv_module_exit);
 EXPORT_SYMBOL(bhv_remove_vfsops);
 EXPORT_SYMBOL(bhv_remove_all_vfsops);
 EXPORT_SYMBOL(bhv_remove_not_first);
-EXPORT_SYMBOL(fs_flush_pages);
-EXPORT_SYMBOL(fs_flushinval_pages);
-EXPORT_SYMBOL(fs_tosspages);
+EXPORT_SYMBOL(xfs_flush_pages);
+EXPORT_SYMBOL(xfs_flushinval_pages);
+EXPORT_SYMBOL(xfs_tosspages);
 EXPORT_SYMBOL(fs_noval);
 EXPORT_SYMBOL(icmn_err);
 EXPORT_SYMBOL(kmem_alloc);
Index: linux-2.6-xfs/fs/xfs/xfs_dir2.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2.c	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dir2.c	2007-08-23 14:41:01.000000000 +0200
@@ -292,18 +292,16 @@ xfs_dir_removename(
  */
 int
 xfs_readdir(
-	bhv_desc_t	*dir_bdp,
+	xfs_inode_t	*dp,
 	void		*dirent,
 	size_t		bufsize,
 	xfs_off_t	*offset,
 	filldir_t	filldir)
 {
-	xfs_inode_t	*dp = XFS_BHVTOI(dir_bdp);
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
 
-	vn_trace_entry(BHV_TO_VNODE(dir_bdp), __FUNCTION__,
-					       (inst_t *)__return_address);
+	vn_trace_entry(XFS_ITOV(dp), __FUNCTION__, (inst_t *)__return_address);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
Index: linux-2.6-xfs/fs/xfs/xfs_dir2.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dir2.h	2007-08-23 14:40:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dir2.h	2007-08-23 14:41:01.000000000 +0200
@@ -84,8 +84,6 @@ extern int xfs_dir_replace(struct xfs_tr
 extern int xfs_dir_canenter(struct xfs_trans *tp, struct xfs_inode *dp,
 				char *name, int namelen);
 extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
-extern int xfs_readdir(bhv_desc_t *dir_bdp, void *dirent, size_t bufsize,
-		       xfs_off_t *offset, filldir_t filldir);
 
 /*
  * Utility routines for v2 directories.
