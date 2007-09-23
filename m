Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Sep 2007 04:43:42 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8NBhbQ3023157
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 04:43:38 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l8NBhdA5009689
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 23 Sep 2007 13:43:39 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l8NBhd39009687
	for xfs@oss.sgi.com; Sun, 23 Sep 2007 13:43:39 +0200
Date: Sun, 23 Sep 2007 13:43:39 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup vnode useage in xfs_dm.c
Message-ID: <20070923114339.GB9585@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Avoid passing around the vnode in xfs_dm.c but pass the xfs_inode /
Linux inode / struct address_space as apropinquate.

p.s. is there a chance we can kill all that 2.4 / early 2.6 compat code
in dmapi one day?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-09-19 18:51:01.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-09-19 18:53:41.000000000 +0200
@@ -217,25 +217,35 @@ xfs_dm_send_data_event(
  *
  */
 
+
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 STATIC int
 prohibited_mr_events(
-	bhv_vnode_t	*vp)
+	struct address_space *mapping)
 {
-	struct address_space *mapping = vn_to_inode(vp)->i_mapping;
 	int prohibited = (1 << DM_EVENT_READ);
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,0)
-	struct vm_area_struct *vma = NULL;
-#endif
 
-	if (!VN_MAPPED(vp))
+	if (!mapping_mapped(mapping))
 		return 0;
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
 	spin_lock(&mapping->i_mmap_lock);
 	if (mapping_writably_mapped(mapping))
 		prohibited |= (1 << DM_EVENT_WRITE);
 	spin_unlock(&mapping->i_mmap_lock);
+
+	return prohibited;
+}
 #else
+STATIC int
+prohibited_mr_events(
+	struct address_space *mapping)
+{
+	int prohibited = (1 << DM_EVENT_READ);
+	struct vm_area_struct *vma = NULL;
+
+	if (!VN_MAPPED(inode_to_vn(mapping->host)))
+		return 0;
+
 	spin_lock(&mapping->i_shared_lock);
 	for (vma = mapping->i_mmap_shared; vma; vma = vma->vm_next_share) {
 		if (vma->vm_flags & VM_WRITE) {
@@ -250,16 +260,16 @@ prohibited_mr_events(
 		}
 	}
 	spin_unlock(&mapping->i_shared_lock);
-#endif
 
 	return prohibited;
 }
+#endif
 
 
 #ifdef	DEBUG_RIGHTS
 STATIC int
 xfs_vp_to_hexhandle(
-	bhv_vnode_t	*vp,
+	struct inode	*inode,
 	u_int		type,
 	char		*buffer)
 {
@@ -269,7 +279,11 @@ xfs_vp_to_hexhandle(
 	int		error;
 	int		i;
 
-	if ((error = dm_vp_to_handle(vp, &handle)))
+	/*
+	 * XXX: dm_vp_to_handle doesn't exist.
+	 * 	Looks like this debug code is rather dead.
+	 */
+	if ((error = dm_vp_to_handle(inode, &handle)))
 		return(error);
 
 	if (type == DM_FSYS_OBJ) {	/* a filesystem handle */
@@ -465,7 +479,6 @@ xfs_ip_to_stat(
 	dm_stat_t		*buf)
 {
 	xfs_icdinode_t		*dic = &ip->i_d;
-	bhv_vnode_t		*vp = XFS_ITOV(ip);
 
 	buf->dt_ino = ino;
 	buf->dt_nlink = dic->di_nlink;
@@ -474,8 +487,8 @@ xfs_ip_to_stat(
 	buf->dt_uid = dic->di_uid;
 	buf->dt_gid = dic->di_gid;
 	buf->dt_size = XFS_ISIZE(ip);
-	buf->dt_dev = new_encode_dev(vp->i_sb->s_dev);
-	vn_atime_to_time_t(vp, &buf->dt_atime);
+	buf->dt_dev = XFS_TO_HOST_DEVT(mp);
+	vn_atime_to_time_t(XFS_ITOV(ip), &buf->dt_atime);
 	buf->dt_mtime = dic->di_mtime.t_sec;
 	buf->dt_ctime = dic->di_ctime.t_sec;
 	buf->dt_xfs_xflags = xfs_ip2dmflags(ip);
@@ -554,7 +567,6 @@ xfs_dm_bulkall_iget_one(
 	char		*attr_name,
 	caddr_t		attr_buf)
 {
-	bhv_vnode_t	*vp;
 	xfs_inode_t	*ip;
 	dm_handle_t	handle;
 	u_int		xstat_sz = *xstat_szp;
@@ -569,10 +581,9 @@ xfs_dm_bulkall_iget_one(
 		xfs_iput_new(ip, XFS_ILOCK_SHARED);
 		return ENOENT;
 	}
-	vp = XFS_ITOV(ip);
 
 	xfs_ip_to_stat(mp, ino, ip, &xbuf->dx_statinfo);
-	dm_ip_to_handle(vn_to_inode(vp), &handle);
+	dm_ip_to_handle(ip->i_vnode, &handle);
 	xfs_dm_handle_to_xstat(xbuf, xstat_sz, &handle, sizeof(handle));
 
 	/* Drop ILOCK_SHARED for call to xfs_attr_get */
@@ -581,7 +592,7 @@ xfs_dm_bulkall_iget_one(
 	memset(&xbuf->dx_attrdata, 0, sizeof(dm_vardata_t));
 	error = xfs_attr_get(ip, attr_name, attr_buf,
 				 &value_len, ATTR_ROOT, sys_cred);
-	VN_RELE(vp);
+	iput(ip->i_vnode);
 
 	DM_EA_XLATE_ERR(error);
 	if (error && (error != ENOATTR)) {
@@ -837,7 +848,7 @@ xfs_dm_bulkattr_iget_one(
 	}
 
 	xfs_ip_to_stat(mp, ino, ip, sbuf);
-	dm_ip_to_handle(vn_to_inode(XFS_ITOV(ip)), &handle);
+	dm_ip_to_handle(ip->i_vnode, &handle);
 	xfs_dm_handle_to_stat(sbuf, stat_sz, &handle, sizeof(handle));
 
 	xfs_iput(ip, XFS_ILOCK_SHARED);
@@ -925,7 +936,7 @@ xfs_dm_bulkattr_one(
 	return error;
 }
 
-/* xfs_dm_f_get_eventlist - return the dm_eventset_t mask for inode vp. */
+/* xfs_dm_f_get_eventlist - return the dm_eventset_t mask for inode ip. */
 
 STATIC int
 xfs_dm_f_get_eventlist(
@@ -969,7 +980,6 @@ xfs_dm_f_get_eventlist(
 
 STATIC int
 xfs_dm_f_set_eventlist(
-	bhv_vnode_t	*vp,
 	xfs_inode_t	*ip,
 	dm_right_t	right,
 	dm_eventset_t	*eventsetp,	/* in kernel space! */
@@ -990,7 +1000,7 @@ xfs_dm_f_set_eventlist(
 		return(EINVAL);
 	max_mask = (1 << maxevent) - 1;
 
-	if (VN_ISDIR(vp)) {
+	if (S_ISDIR(ip->i_d.di_mode)) {
 		valid_events = DM_XFS_VALID_DIRECTORY_EVENTS;
 	} else {	/* file or symlink */
 		valid_events = DM_XFS_VALID_FILE_EVENTS;
@@ -1019,7 +1029,7 @@ xfs_dm_f_set_eventlist(
 	ip->i_d.di_dmevmask = (eventset & max_mask) | (ip->i_d.di_dmevmask & ~max_mask);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	VN_HOLD(vp);
+	igrab(ip->i_vnode);
 	xfs_trans_commit(tp, 0);
 
 	return(0);
@@ -1146,7 +1156,7 @@ xfs_dm_direct_ok(
 
 STATIC int
 xfs_dm_rdwr(
-	bhv_vnode_t	*vp,
+	struct inode	*inode,
 	uint		fflag,
 	mode_t		fmode,
 	dm_off_t	off,
@@ -1154,13 +1164,12 @@ xfs_dm_rdwr(
 	void		__user *bufp,
 	int		*rvp)
 {
+	xfs_inode_t	*ip = XFS_I(inode);
 	int		error;
 	int		oflags;
 	ssize_t		xfer;
 	struct file	*file;
-	struct inode	*inode = vn_to_inode(vp);
 	struct dentry	*dentry;
-	xfs_inode_t	*ip;
 
 	if ((off < 0) || (off > i_size_read(inode)) || !S_ISREG(inode->i_mode))
 		return EINVAL;
@@ -1178,7 +1187,6 @@ xfs_dm_rdwr(
 	 */
 
 	oflags |= O_LARGEFILE | O_NONBLOCK | O_NOATIME;
-	ip = xfs_vtoi(vp);
 	if (xfs_dm_direct_ok(ip, off, len, bufp))
 		oflags |= O_DIRECT;
 
@@ -1255,9 +1263,8 @@ xfs_dm_downgrade_right(
 {
 #ifdef	DEBUG_RIGHTS
 	char		buffer[sizeof(dm_handle_t) * 2 + 1];
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	if (!xfs_vp_to_hexhandle(vp, type, buffer)) {
+	if (!xfs_vp_to_hexhandle(inode, type, buffer)) {
 		printf("dm_downgrade_right: old %d new %d type %d handle %s\n",
 			right, DM_RIGHT_SHARED, type, buffer);
 	} else {
@@ -1288,13 +1295,12 @@ xfs_dm_get_allocinfo_rvp(
 	u_int		__user *nelemp,
 	int		*rvp)
 {
-	xfs_inode_t	*ip;		/* xfs incore inode pointer */
+	xfs_inode_t	*ip = XFS_I(inode);
 	xfs_mount_t	*mp;		/* file system mount point */
 	xfs_fileoff_t	fsb_offset;
 	xfs_filblks_t	fsb_length;
 	dm_off_t	startoff;
 	int		elem;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	xfs_bmbt_irec_t *bmp = NULL;
 	u_int		bmpcnt = 50;
 	u_int		bmpsz = sizeof(xfs_bmbt_irec_t) * bmpcnt;
@@ -1311,7 +1317,6 @@ xfs_dm_get_allocinfo_rvp(
 	if (copy_from_user( &startoff, offp, sizeof(startoff)))
 		return(-EFAULT);
 
-	ip = xfs_vtoi(vp);
 	mp = ip->i_mount;
 	ASSERT(mp);
 
@@ -1819,15 +1824,13 @@ xfs_dm_get_dioinfo(
 {
 	dm_dioinfo_t	dio;
 	xfs_mount_t	*mp;
-	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
+	xfs_inode_t	*ip = XFS_I(inode);
 
 	/* Returns negative errors to DMAPI */
 
 	if (right < DM_RIGHT_SHARED)
 		return(-EACCES);
 
-	ip = xfs_vtoi(vp);
 	mp = ip->i_mount;
 
 	dio.d_miniosz = dio.d_mem = MIN_DIO_SIZE(mp);
@@ -2079,8 +2082,7 @@ xfs_dm_get_eventlist(
 	u_int 		*nelemp)
 {
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-	xfs_inode_t	*ip = xfs_vtoi(vp);
+	xfs_inode_t	*ip = XFS_I(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2104,9 +2106,8 @@ xfs_dm_get_fileattr(
 	dm_stat_t	__user *statp)
 {
 	dm_stat_t	stat;
-	xfs_inode_t	*ip;
+	xfs_inode_t	*ip = XFS_I(inode);
 	xfs_mount_t	*mp;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2115,7 +2116,6 @@ xfs_dm_get_fileattr(
 
 	/* Find the mount point. */
 
-	ip = xfs_vtoi(vp);
 	mp = ip->i_mount;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -2144,16 +2144,14 @@ xfs_dm_get_region(
 {
 	dm_eventset_t	evmask;
 	dm_region_t	region;
-	xfs_inode_t	*ip;
+	xfs_inode_t	*ip = XFS_I(inode);
 	u_int		elem;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
 	if (right < DM_RIGHT_SHARED)
 		return(-EACCES);
 
-	ip = xfs_vtoi(vp);
 	evmask = ip->i_d.di_dmevmask;	/* read the mask "atomically" */
 
 	/* Get the file's current managed region flags out of the
@@ -2340,9 +2338,9 @@ xfs_dm_getall_inherit(
 
 /* Initialize location pointer for subsequent dm_get_dirattrs,
    dm_get_bulkattr, and dm_get_bulkall calls.  The same initialization must
-   work for vnode-based routines (dm_get_dirattrs) and filesystem-based
+   work for inode-based routines (dm_get_dirattrs) and filesystem-based
    routines (dm_get_bulkattr and dm_get_bulkall).  Filesystem-based functions
-   call this routine using the filesystem's root vnode.
+   call this routine using the filesystem's root inode.
 */
 
 /* ARGSUSED */
@@ -2444,12 +2442,11 @@ xfs_dm_probe_hole(
 {
 	dm_off_t	roff;
 	dm_size_t	rlen;
-	xfs_inode_t	*ip;
+	xfs_inode_t	*ip = XFS_I(inode);
 	xfs_mount_t	*mp;
 	uint		lock_flags;
 	xfs_fsize_t	realsize;
 	dm_size_t	align;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	int		error;
 
 	/* Returns negative errors to DMAPI */
@@ -2457,7 +2454,6 @@ xfs_dm_probe_hole(
 	if (right < DM_RIGHT_SHARED)
 		return -EACCES;
 
-	ip = xfs_vtoi(vp);
 	if ((ip->i_d.di_mode & S_IFMT) != S_IFREG)
 		return -EINVAL;
 
@@ -2497,11 +2493,10 @@ xfs_dm_punch_hole(
 {
 	xfs_flock64_t	bf;
 	int		error = 0;
-	xfs_inode_t	*ip;
+	xfs_inode_t	*ip = XFS_I(inode);
 	xfs_mount_t	*mp;
 	dm_size_t	align;
 	xfs_fsize_t	realsize;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 	dm_off_t	roff;
 	dm_size_t	rlen;
 
@@ -2519,7 +2514,6 @@ xfs_dm_punch_hole(
 	if (error)
 		return -EBUSY;
 
-	ip = xfs_vtoi(vp);
 	mp = ip->i_mount;
 
 	down_rw_sems(inode, DM_SEM_FLAG_WR);
@@ -2617,14 +2611,12 @@ xfs_dm_read_invis_rvp(
 	void		__user *bufp,
 	int		*rvp)
 {
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-
 	/* Returns negative errors to DMAPI */
 
 	if (right < DM_RIGHT_SHARED)
 		return(-EACCES);
 
-	return(-xfs_dm_rdwr(vp, 0, FMODE_READ, off, len, bufp, rvp));
+	return(-xfs_dm_rdwr(inode, 0, FMODE_READ, off, len, bufp, rvp));
 }
 
 
@@ -2637,9 +2629,8 @@ xfs_dm_release_right(
 {
 #ifdef	DEBUG_RIGHTS
 	char		buffer[sizeof(dm_handle_t) * 2 + 1];
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	if (!xfs_vp_to_hexhandle(vp, type, buffer)) {
+	if (!xfs_vp_to_hexhandle(inode, type, buffer)) {
 		printf("dm_release_right: old %d type %d handle %s\n",
 			right, type, buffer);
 	} else {
@@ -2692,9 +2683,8 @@ xfs_dm_request_right(
 {
 #ifdef	DEBUG_RIGHTS
 	char		buffer[sizeof(dm_handle_t) * 2 + 1];
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	if (!xfs_vp_to_hexhandle(vp, type, buffer)) {
+	if (!xfs_vp_to_hexhandle(inode, type, buffer)) {
 		printf("dm_request_right: old %d new %d type %d flags 0x%x "
 			"handle %s\n", right, newright, type, flags, buffer);
 	} else {
@@ -2759,15 +2749,14 @@ xfs_dm_set_eventlist(
 	u_int		maxevent)
 {
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
-	xfs_inode_t	*ip = xfs_vtoi(vp);
+	xfs_inode_t	*ip = XFS_I(inode);
 
 	/* Returns negative errors to DMAPI */
 
 	if (type == DM_FSYS_OBJ) {
 		error = xfs_dm_fs_set_eventlist(ip->i_mount, right, eventsetp, maxevent);
 	} else {
-		error = xfs_dm_f_set_eventlist(vp, ip, right, eventsetp, maxevent);
+		error = xfs_dm_f_set_eventlist(ip, right, eventsetp, maxevent);
 	}
 	return(-error); /* Return negative error to DMAPI */
 }
@@ -2787,7 +2776,6 @@ xfs_dm_set_fileattr(
 	dm_fileattr_t	stat;
 	bhv_vattr_t	vat;
 	int		error;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2844,7 +2832,7 @@ xfs_dm_set_fileattr(
 
 	error = xfs_setattr(XFS_I(inode), &vat, ATTR_DMI, NULL);
 	if (!error)
-		vn_revalidate(vp);	/* update Linux inode flags */
+		vn_revalidate(vn_from_inode(inode));	/* update Linux inode flags */
 	return(-error); /* Return negative error to DMAPI */
 }
 
@@ -2869,7 +2857,7 @@ xfs_dm_set_region(
 	dm_region_t	__user *regbufp,
 	dm_boolean_t	__user *exactflagp)
 {
-	xfs_inode_t	*ip;
+	xfs_inode_t	*ip = XFS_I(inode);
 	xfs_trans_t	*tp;
 	xfs_mount_t	*mp;
 	dm_region_t	region;
@@ -2877,7 +2865,6 @@ xfs_dm_set_region(
 	dm_eventset_t	mr_mask;
 	int		error;
 	u_int		exactflag;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -2917,9 +2904,7 @@ xfs_dm_set_region(
 	   bits, add in the new ones, and update the file's mask.
 	*/
 
-	ip = xfs_vtoi(vp);
-
-	if (new_mask & prohibited_mr_events(vp)) {
+	if (new_mask & prohibited_mr_events(inode->i_mapping)) {
 		/* If the change is simply to remove the READ
 		 * bit, then that's always okay.  Otherwise, it's busy.
 		 */
@@ -2943,7 +2928,7 @@ xfs_dm_set_region(
 	ip->i_d.di_dmevmask = (ip->i_d.di_dmevmask & ~mr_mask) | new_mask;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	VN_HOLD(vp);
+	igrab(inode);
 	xfs_trans_commit(tp, 0);
 
 	/* Return the proper value for *exactflagp depending upon whether or not
@@ -3020,9 +3005,8 @@ xfs_dm_upgrade_right(
 {
 #ifdef	DEBUG_RIGHTS
 	char		buffer[sizeof(dm_handle_t) * 2 + 1];
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
-	if (!xfs_vp_to_hexhandle(vp, type, buffer)) {
+	if (!xfs_vp_to_hexhandle(inode, type, buffer)) {
 		printf("dm_upgrade_right: old %d new %d type %d handle %s\n",
 			right, DM_RIGHT_EXCL, type, buffer);
 	} else {
@@ -3045,7 +3029,6 @@ xfs_dm_write_invis_rvp(
 	int		*rvp)
 {
 	int		fflag = 0;
-	bhv_vnode_t	*vp = vn_from_inode(inode);
 
 	/* Returns negative errors to DMAPI */
 
@@ -3054,7 +3037,7 @@ xfs_dm_write_invis_rvp(
 
 	if (flags & DM_WRITE_SYNC)
 		fflag |= O_SYNC;
-	return(-xfs_dm_rdwr(vp, fflag, FMODE_WRITE, off, len, bufp, rvp));
+	return(-xfs_dm_rdwr(inode, fflag, FMODE_WRITE, off, len, bufp, rvp));
 }
 
 
