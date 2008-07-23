Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 14:46:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NLkffq026083
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:46:41 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8067231CA2A
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:50 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id o24hD1DR3JI0XLF3 for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:50 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NLlfNg010789
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:47:41 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NLlfO6010787
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 23:47:41 +0200
Date: Wed, 23 Jul 2008 23:47:41 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] remove some easy bhv_vnode_t instances
Message-ID: <20080723214741.GB10655@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

In various places we can just move a VFS_I call into the argument list
of called functions/macros instead of having a local bhv_vnode_t.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/xfs_dfrag.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_dfrag.c	2008-07-23 22:25:42.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_dfrag.c	2008-07-23 22:26:16.000000000 +0200
@@ -130,7 +130,6 @@ xfs_swap_extents(
 	xfs_mount_t	*mp;
 	xfs_trans_t	*tp;
 	xfs_bstat_t	*sbp = &sxp->sx_stat;
-	bhv_vnode_t	*vp, *tvp;
 	xfs_ifork_t	*tempifp, *ifp, *tifp;
 	int		ilf_fields, tilf_fields;
 	static uint	lock_flags = XFS_ILOCK_EXCL | XFS_IOLOCK_EXCL;
@@ -149,8 +148,6 @@ xfs_swap_extents(
 	}
 
 	sbp = &sxp->sx_stat;
-	vp = VFS_I(ip);
-	tvp = VFS_I(tip);
 
 	xfs_lock_two_inodes(ip, tip, lock_flags);
 	locked = 1;
@@ -174,7 +171,7 @@ xfs_swap_extents(
 		goto error0;
 	}
 
-	if (VN_CACHED(tvp) != 0) {
+	if (VN_CACHED(VFS_I(tip)) != 0) {
 		xfs_inval_cached_trace(tip, 0, -1, 0, -1);
 		error = xfs_flushinval_pages(tip, 0, -1,
 				FI_REMAPF_LOCKED);
@@ -183,7 +180,7 @@ xfs_swap_extents(
 	}
 
 	/* Verify O_DIRECT for ftmp */
-	if (VN_CACHED(tvp) != 0) {
+	if (VN_CACHED(VFS_I(tip)) != 0) {
 		error = XFS_ERROR(EINVAL);
 		goto error0;
 	}
@@ -227,7 +224,7 @@ xfs_swap_extents(
 	 * vop_read (or write in the case of autogrow) they block on the iolock
 	 * until we have switched the extents.
 	 */
-	if (VN_MAPPED(vp)) {
+	if (VN_MAPPED(VFS_I(ip))) {
 		error = XFS_ERROR(EBUSY);
 		goto error0;
 	}
Index: linux-2.6-xfs/fs/xfs/xfs_inode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.c	2008-07-23 22:22:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.c	2008-07-23 22:29:36.000000000 +0200
@@ -1397,7 +1397,6 @@ xfs_itruncate_start(
 	xfs_fsize_t	last_byte;
 	xfs_off_t	toss_start;
 	xfs_mount_t	*mp;
-	bhv_vnode_t	*vp;
 	int		error = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
@@ -1406,7 +1405,6 @@ xfs_itruncate_start(
 	       (flags == XFS_ITRUNC_MAYBE));
 
 	mp = ip->i_mount;
-	vp = VFS_I(ip);
 
 	/* wait for the completion of any pending DIOs */
 	if (new_size < ip->i_size)
@@ -1455,7 +1453,7 @@ xfs_itruncate_start(
 
 #ifdef DEBUG
 	if (new_size == 0) {
-		ASSERT(VN_CACHED(vp) == 0);
+		ASSERT(VN_CACHED(VFS_I(ip)) == 0);
 	}
 #endif
 	return error;
@@ -3421,7 +3419,6 @@ xfs_iflush_all(
 	xfs_mount_t	*mp)
 {
 	xfs_inode_t	*ip;
-	bhv_vnode_t	*vp;
 
  again:
 	XFS_MOUNT_ILOCK(mp);
@@ -3436,14 +3433,13 @@ xfs_iflush_all(
 			continue;
 		}
 
-		vp = VFS_I(ip);
-		if (!vp) {
+		if (!VFS_I(ip)) {
 			XFS_MOUNT_IUNLOCK(mp);
 			xfs_finish_reclaim(ip, 0, XFS_IFLUSH_ASYNC);
 			goto again;
 		}
 
-		ASSERT(vn_count(vp) == 0);
+		ASSERT(vn_count(VFS_I(ip)) == 0);
 
 		ip = ip->i_mnext;
 	} while (ip != mp->m_inodes);
Index: linux-2.6-xfs/fs/xfs/xfs_itable.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_itable.c	2008-07-23 22:26:29.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_itable.c	2008-07-23 22:26:45.000000000 +0200
@@ -59,7 +59,6 @@ xfs_bulkstat_one_iget(
 {
 	xfs_icdinode_t	*dic;	/* dinode core info pointer */
 	xfs_inode_t	*ip;		/* incore inode pointer */
-	bhv_vnode_t	*vp;
 	int		error;
 
 	error = xfs_iget(mp, NULL, ino,
@@ -72,7 +71,6 @@ xfs_bulkstat_one_iget(
 	ASSERT(ip != NULL);
 	ASSERT(ip->i_blkno != (xfs_daddr_t)0);
 
-	vp = VFS_I(ip);
 	dic = &ip->i_d;
 
 	/* xfs_iget returns the following without needing
@@ -85,7 +83,7 @@ xfs_bulkstat_one_iget(
 	buf->bs_uid = dic->di_uid;
 	buf->bs_gid = dic->di_gid;
 	buf->bs_size = dic->di_size;
-	vn_atime_to_bstime(vp, &buf->bs_atime);
+	vn_atime_to_bstime(VFS_I(ip), &buf->bs_atime);
 	buf->bs_mtime.tv_sec = dic->di_mtime.t_sec;
 	buf->bs_mtime.tv_nsec = dic->di_mtime.t_nsec;
 	buf->bs_ctime.tv_sec = dic->di_ctime.t_sec;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-23 22:23:16.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-23 22:33:43.000000000 +0200
@@ -1160,7 +1160,6 @@ int
 xfs_release(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = VFS_I(ip);
 	xfs_mount_t	*mp = ip->i_mount;
 	int		error;
 
@@ -1195,13 +1194,13 @@ xfs_release(
 		 * be exposed to that problem.
 		 */
 		truncated = xfs_iflags_test_and_clear(ip, XFS_ITRUNCATED);
-		if (truncated && VN_DIRTY(vp) && ip->i_delayed_blks > 0)
+		if (truncated && VN_DIRTY(VFS_I(ip)) && ip->i_delayed_blks > 0)
 			xfs_flush_pages(ip, 0, -1, XFS_B_ASYNC, FI_NONE);
 	}
 
 	if (ip->i_d.di_nlink != 0) {
 		if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
-		     ((ip->i_size > 0) || (VN_CACHED(vp) > 0 ||
+		     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
 		       ip->i_delayed_blks > 0)) &&
 		     (ip->i_df.if_flags & XFS_IFEXTENTS))  &&
 		    (!(ip->i_d.di_flags &
@@ -1227,7 +1226,6 @@ int
 xfs_inactive(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = VFS_I(ip);
 	xfs_bmap_free_t	free_list;
 	xfs_fsblock_t	first_block;
 	int		committed;
@@ -1242,7 +1240,7 @@ xfs_inactive(
 	 * If the inode is already free, then there can be nothing
 	 * to clean up here.
 	 */
-	if (ip->i_d.di_mode == 0 || VN_BAD(vp)) {
+	if (ip->i_d.di_mode == 0 || VN_BAD(VFS_I(ip))) {
 		ASSERT(ip->i_df.if_real_bytes == 0);
 		ASSERT(ip->i_df.if_broot_bytes == 0);
 		return VN_INACTIVE_CACHE;
@@ -1272,7 +1270,7 @@ xfs_inactive(
 
 	if (ip->i_d.di_nlink != 0) {
 		if ((((ip->i_d.di_mode & S_IFMT) == S_IFREG) &&
-                     ((ip->i_size > 0) || (VN_CACHED(vp) > 0 ||
+                     ((ip->i_size > 0) || (VN_CACHED(VFS_I(ip)) > 0 ||
                        ip->i_delayed_blks > 0)) &&
 		      (ip->i_df.if_flags & XFS_IFEXTENTS) &&
 		     (!(ip->i_d.di_flags &
@@ -2793,14 +2791,13 @@ int
 xfs_reclaim(
 	xfs_inode_t	*ip)
 {
-	bhv_vnode_t	*vp = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
-	ASSERT(!VN_MAPPED(vp));
+	ASSERT(!VN_MAPPED(VFS_I(ip)));
 
 	/* bad inode, get out here ASAP */
-	if (VN_BAD(vp)) {
+	if (VN_BAD(VFS_I(ip))) {
 		xfs_ireclaim(ip);
 		return 0;
 	}
@@ -2837,7 +2834,7 @@ xfs_reclaim(
 		XFS_MOUNT_ILOCK(mp);
 		spin_lock(&ip->i_flags_lock);
 		__xfs_iflags_set(ip, XFS_IRECLAIMABLE);
-		vp->i_private = NULL;
+		VFS_I(ip)->i_private = NULL;
 		ip->i_vnode = NULL;
 		spin_unlock(&ip->i_flags_lock);
 		list_add_tail(&ip->i_reclaim, &mp->m_del_inodes);
@@ -3241,7 +3238,6 @@ xfs_free_file_space(
 	xfs_off_t		len,
 	int			attr_flags)
 {
-	bhv_vnode_t		*vp;
 	int			committed;
 	int			done;
 	xfs_off_t		end_dmi_offset;
@@ -3261,7 +3257,6 @@ xfs_free_file_space(
 	xfs_trans_t		*tp;
 	int			need_iolock = 1;
 
-	vp = VFS_I(ip);
 	mp = ip->i_mount;
 
 	xfs_itrace_entry(ip);
@@ -3298,7 +3293,7 @@ xfs_free_file_space(
 	rounding = max_t(uint, 1 << mp->m_sb.sb_blocklog, PAGE_CACHE_SIZE);
 	ioffset = offset & ~(rounding - 1);
 
-	if (VN_CACHED(vp) != 0) {
+	if (VN_CACHED(VFS_I(ip)) != 0) {
 		xfs_inval_cached_trace(ip, ioffset, -1, ioffset, -1);
 		error = xfs_flushinval_pages(ip, ioffset, -1, FI_REMAPF_LOCKED);
 		if (error)
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-07-23 22:28:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-07-23 22:33:43.000000000 +0200
@@ -127,7 +127,6 @@ xfs_unmount_flush(
 	xfs_inode_t	*rip = mp->m_rootip;
 	xfs_inode_t	*rbmip;
 	xfs_inode_t	*rsumip = NULL;
-	bhv_vnode_t	*rvp = VFS_I(rip);
 	int		error;
 
 	xfs_ilock(rip, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
@@ -166,7 +165,7 @@ xfs_unmount_flush(
 	if (error == EFSCORRUPTED)
 		goto fscorrupt_out2;
 
-	if (vn_count(rvp) != 1 && !relocation) {
+	if (vn_count(VFS_I(rip)) != 1 && !relocation) {
 		xfs_iunlock(rip, XFS_ILOCK_EXCL);
 		return XFS_ERROR(EBUSY);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 22:33:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 22:33:54.000000000 +0200
@@ -922,12 +922,7 @@ STATIC struct inode *
 xfs_fs_alloc_inode(
 	struct super_block	*sb)
 {
-	bhv_vnode_t		*vp;
-
-	vp = kmem_zone_alloc(xfs_vnode_zone, KM_SLEEP);
-	if (unlikely(!vp))
-		return NULL;
-	return vp;
+	return kmem_zone_alloc(xfs_vnode_zone, KM_SLEEP);
 }
 
 STATIC void
