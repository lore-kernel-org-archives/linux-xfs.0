Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 14 Dec 2007 12:25:18 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBEKP8QA032214
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:25:10 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DB62113A87A
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:25:18 -0800 (PST)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id g1lqOmXOd5brmBak for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 12:25:18 -0800 (PST)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id lBEKPBF3023508
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Dec 2007 21:25:11 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id lBEKPBPT023504
	for xfs@oss.sgi.com; Fri, 14 Dec 2007 21:25:11 +0100
Date: Fri, 14 Dec 2007 21:25:11 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/2] cleanup fix handling
Message-ID: <20071214202511.GA23248@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Cleanup various fid related bits:

 - merge xfs_fid2 into it's only caller xfs_dm_inode_to_fh.
 - remove xfs_vget and opencode it in the two callers, simplifying
   both of them by avoiding the awkward calling convetion.
 - assign directly to the dm_fid_t members in various places in the
   dmapi code instead of casting them to xfs_fid_t first (which
   is identical to dm_fid_t)


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-12-13 19:14:47.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-12-13 20:10:04.000000000 +0100
@@ -586,14 +586,12 @@ dm_dip_to_handle(
 	dm_handle_t	*handlep)
 {
 	dm_fid_t	fid;
-	struct xfs_fid	*xfid;
 	int		hsize;
 
-	xfid = (struct xfs_fid *)&fid;
-	xfid->fid_len = sizeof(struct xfs_fid) - sizeof(xfid->fid_len);
-	xfid->fid_pad = 0;
-	xfid->fid_ino = ino;
-        xfid->fid_gen = be32_to_cpu(dip->di_core.di_gen);
+	fid.dm_fid_len = sizeof(struct dm_fid) - sizeof(fid.dm_fid_len);
+	fid.dm_fid_pad = 0;
+	fid.dm_fid_ino = ino;
+	fid.dm_fid_gen = be32_to_cpu(dip->di_core.di_gen);
 
 	memcpy(&handlep->ha_fsid, fsid, sizeof(*fsid));
 	memcpy(&handlep->ha_fid, &fid, fid.dm_fid_len + sizeof(fid.dm_fid_len));
@@ -3273,27 +3271,49 @@ xfs_dm_get_invis_ops(
 STATIC int
 xfs_dm_fh_to_inode(
 	struct super_block	*sb,
-	struct inode		**ip,
+	struct inode		**inode,
 	dm_fid_t		*dmfid)
 {
-	bhv_vnode_t	*vp = NULL;
-	xfs_mount_t	*mp = XFS_M(sb);
-	int		error;
-	struct xfs_fid	xfid;
+	xfs_mount_t		*mp = XFS_M(sb);
+	xfs_inode_t		*ip;
+	xfs_ino_t		ino;
+	unsigned int		igen;
+	int			error;
 
-	/* Returns negative errors to DMAPI */
+	*inode = NULL;
 
-	*ip = NULL;
-	memcpy(&xfid, dmfid, sizeof(*dmfid));
-	if (xfid.fid_len) {	/* file object handle */
-		error = xfs_vget(mp, &vp, &xfid);
+	if (!dmfid->dm_fid_len) {
+		/* filesystem handle */
+		*inode = igrab(mp->m_rootip->i_vnode);
+		if (!*inode)
+			return -ENOENT;
+		return 0;
 	}
-	else {			/* filesystem handle */
-		error = xfs_root(mp, &vp);
+
+	if (dmfid->dm_fid_len != sizeof(*dmfid) - sizeof(dmfid->dm_fid_len))
+		return -EINVAL;
+
+	ino  = dmfid->dm_fid_ino;
+	igen = dmfid->dm_fid_gen;
+
+	/* fail requests for ino 0 gracefully. */
+	if (ino == 0)
+		return -ESTALE;
+
+	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
+	if (error)
+		return -error;
+	if (!ip)
+		return -EIO;
+
+	if (!ip->i_d.di_mode || ip->i_d.di_gen != igen) {
+		xfs_iput_new(ip, XFS_ILOCK_SHARED);
+		return -ENOENT;
 	}
-	if (vp && (error == 0))
-		*ip = vn_to_inode(vp);
-	return -error; /* Return negative error to DMAPI */
+
+	*inode = ip->i_vnode;
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return 0;
 }
 
 STATIC int
@@ -3303,18 +3323,21 @@ xfs_dm_inode_to_fh(
 	dm_fsid_t		*dmfsid)
 {
 	xfs_inode_t		*ip = XFS_I(inode);
-	int			error;
-	struct xfs_fid		xfid;
 
 	/* Returns negative errors to DMAPI */
 
 	if (ip->i_mount->m_fixedfsid == NULL)
 		return -EINVAL;
-	error = xfs_fid2(ip, &xfid);
-	if (error)
-		return -error; /* Return negative error to DMAPI */
 
-	memcpy(dmfid, &xfid, sizeof(*dmfid));
+	dmfid->dm_fid_len = sizeof(dm_fid_t) - sizeof(dmfid->dm_fid_len);
+	dmfid->dm_fid_pad = 0;
+	/*
+	 * use memcpy because the inode is a long long and there's no
+	 * assurance that dmfid->dm_fid_ino is properly aligned.
+	 */
+	memcpy(&dmfid->dm_fid_ino, &ip->i_ino, sizeof(dmfid->dm_fid_ino));
+	dmfid->dm_fid_gen = ip->i_d.di_gen;
+
 	memcpy(dmfsid, ip->i_mount->m_fixedfsid, sizeof(*dmfsid));
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2007-12-13 19:14:47.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2007-12-13 19:18:49.000000000 +0100
@@ -118,20 +118,29 @@ xfs_nfs_get_inode(
 	u64			ino,
 	u32			generation)
  {
-	xfs_fid_t		xfid;
-	bhv_vnode_t		*vp;
+ 	xfs_mount_t		*mp = XFS_M(sb);
+	xfs_inode_t		*ip;
 	int			error;
 
-	xfid.fid_len = sizeof(xfs_fid_t) - sizeof(xfid.fid_len);
-	xfid.fid_pad = 0;
-	xfid.fid_ino = ino;
-	xfid.fid_gen = generation;
+	/*
+	 * NFS can sometimes send requests for ino 0.  Fail them gracefully.
+	 */
+	if (ino == 0)
+		return ERR_PTR(-ESTALE);
 
-	error = xfs_vget(XFS_M(sb), &vp, &xfid);
+	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
 	if (error)
 		return ERR_PTR(-error);
+	if (!ip)
+		return ERR_PTR(-EIO);
 
-	return vp ? vn_to_inode(vp) : NULL;
+	if (!ip->i_d.di_mode || ip->i_d.di_gen != generation) {
+		xfs_iput_new(ip, XFS_ILOCK_SHARED);
+		return ERR_PTR(-ENOENT);
+	}
+
+	xfs_iunlock(ip, XFS_ILOCK_SHARED);
+	return ip->i_vnode;
 }
 
 STATIC struct dentry *
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-13 19:19:52.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ksyms.c	2007-12-13 19:22:10.000000000 +0100
@@ -267,7 +267,6 @@ EXPORT_SYMBOL(xfs_read_buf);
 EXPORT_SYMBOL(xfs_rwlock);
 EXPORT_SYMBOL(xfs_rwunlock);
 EXPORT_SYMBOL(xfs_setattr);
-EXPORT_SYMBOL(xfs_fid2);
 EXPORT_SYMBOL(xfs_attr_get);
 EXPORT_SYMBOL(xfs_attr_set);
 EXPORT_SYMBOL(xfs_fsync);
@@ -310,5 +309,4 @@ EXPORT_SYMBOL(xfs_ichgtime_fast);
 EXPORT_SYMBOL(xfs_free_eofblocks);
 
 EXPORT_SYMBOL(xfs_do_force_shutdown);
-EXPORT_SYMBOL(xfs_vget);
 EXPORT_SYMBOL(xfs_root);
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-12-13 19:14:47.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-12-13 19:19:37.000000000 +0100
@@ -1408,56 +1408,3 @@ xfs_syncsub(
 
 	return XFS_ERROR(last_error);
 }
-
-/*
- * xfs_vget - called by DMAPI and NFSD to get vnode from file handle
- */
-int
-xfs_vget(
-	xfs_mount_t	*mp,
-	bhv_vnode_t	**vpp,
-	xfs_fid_t	*xfid)
-{
-	xfs_inode_t	*ip;
-	int		error;
-	xfs_ino_t	ino;
-	unsigned int	igen;
-
-	/*
-	 * Invalid.  Since handles can be created in user space and passed in
-	 * via gethandle(), this is not cause for a panic.
-	 */
-	if (xfid->fid_len != sizeof(*xfid) - sizeof(xfid->fid_len))
-		return XFS_ERROR(EINVAL);
-
-	ino  = xfid->fid_ino;
-	igen = xfid->fid_gen;
-
-	/*
-	 * NFS can sometimes send requests for ino 0.  Fail them gracefully.
-	 */
-	if (ino == 0)
-		return XFS_ERROR(ESTALE);
-
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, 0);
-	if (error) {
-		*vpp = NULL;
-		return error;
-	}
-
-	if (ip == NULL) {
-		*vpp = NULL;
-		return XFS_ERROR(EIO);
-	}
-
-	if (ip->i_d.di_mode == 0 || ip->i_d.di_gen != igen) {
-		xfs_iput_new(ip, XFS_ILOCK_SHARED);
-		*vpp = NULL;
-		return XFS_ERROR(ENOENT);
-	}
-
-	*vpp = XFS_ITOV(ip);
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return 0;
-}
-
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-12-13 19:19:40.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-12-13 19:19:45.000000000 +0100
@@ -15,7 +15,6 @@ int xfs_mntupdate(struct xfs_mount *mp, 
 		struct xfs_mount_args *args);
 int xfs_root(struct xfs_mount *mp, bhv_vnode_t **vpp);
 int xfs_sync(struct xfs_mount *mp, int flags);
-int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct xfs_fid *xfid);
 void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 		int lnnum);
 void xfs_attr_quiesce(struct xfs_mount *mp);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-12-13 19:20:41.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-12-13 19:20:53.000000000 +0100
@@ -3457,27 +3457,6 @@ std_return:
 	goto std_return;
 }
 
-
-int
-xfs_fid2(
-	xfs_inode_t	*ip,
-	xfs_fid_t	*xfid)
-{
-	xfs_itrace_entry(ip);
-
-	xfid->fid_len = sizeof(xfs_fid_t) - sizeof(xfid->fid_len);
-	xfid->fid_pad = 0;
-	/*
-	 * use memcpy because the inode is a long long and there's no
-	 * assurance that xfid->fid_ino is properly aligned.
-	 */
-	memcpy(&xfid->fid_ino, &ip->i_ino, sizeof(xfid->fid_ino));
-	xfid->fid_gen = ip->i_d.di_gen;
-
-	return 0;
-}
-
-
 int
 xfs_rwlock(
 	xfs_inode_t	*ip,
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2007-12-13 19:20:04.000000000 +0100
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2007-12-13 19:22:04.000000000 +0100
@@ -39,7 +39,6 @@ int xfs_readdir(struct xfs_inode	*dp, vo
 int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
 		char *target_path, mode_t mode, bhv_vnode_t **vpp,
 		struct cred *credp);
-int xfs_fid2(struct xfs_inode *ip, struct xfs_fid *xfid);
 int xfs_rwlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 void xfs_rwunlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
