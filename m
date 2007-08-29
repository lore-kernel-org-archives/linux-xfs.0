Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 29 Aug 2007 06:46:17 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7TDkD4p028794
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 06:46:15 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7TDkCA5000726
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 29 Aug 2007 15:46:12 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7TDkC6D000724
	for xfs@oss.sgi.com; Wed, 29 Aug 2007 15:46:12 +0200
Date: Wed, 29 Aug 2007 15:46:12 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup fid types mess
Message-ID: <20070829134612.GA504@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Currently XFs has three different fid types: struct fid, struct xfs_fid
and struct xfs_fid2 with hte latter two beeing identicaly and the first
one beeing the same size but an unstructured array with the same size.

This patch consolidates all this to alway uuse struct xfs_fid.

This patch is required for an upcoming patch series from me that revamps
the nfs exporting code and introduces a Linux-wide struct fid.


Note: the patch is ontop of Eric's inode/vnode tracing cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.c	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.c	2007-08-29 15:37:09.000000000 +0200
@@ -54,8 +54,8 @@ xfs_fs_decode_fh(
 		struct dentry	*de),
 	void			*context)
 {
-	xfs_fid2_t		ifid;
-	xfs_fid2_t		pfid;
+	xfs_fid_t		ifid;
+	xfs_fid_t		pfid;
 	void			*parent = NULL;
 	int			is64 = 0;
 	__u32			*p = fh;
@@ -144,7 +144,7 @@ xfs_fs_get_dentry(
 	struct dentry		*result;
 	int			error;
 
-	error = xfs_vget(XFS_M(sb), &vp, (fid_t *)data);
+	error = xfs_vget(XFS_M(sb), &vp, data);
 	if (error || vp == NULL)
 		return ERR_PTR(-ESTALE) ;
 
Index: linux-2.6-xfs/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_fs.h	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_fs.h	2007-08-29 15:37:09.000000000 +0200
@@ -389,30 +389,13 @@ typedef struct xfs_fsop_attrmulti_handle
  */
 typedef struct { __u32 val[2]; } xfs_fsid_t; /* file system id type */
 
-
-#ifndef HAVE_FID
-#define MAXFIDSZ	46
-
-typedef struct fid {
-	__u16		fid_len;		/* length of data in bytes */
-	unsigned char	fid_data[MAXFIDSZ];	/* data (fid_len worth)  */
-} fid_t;
-#endif
-
 typedef struct xfs_fid {
-	__u16	xfs_fid_len;		/* length of remainder	*/
-	__u16	xfs_fid_pad;
-	__u32	xfs_fid_gen;		/* generation number	*/
-	__u64	xfs_fid_ino;		/* 64 bits inode number */
+	__u16	fid_len;		/* length of remainder	*/
+	__u16	fid_pad;
+	__u32	fid_gen;		/* generation number	*/
+	__u64	fid_ino;		/* 64 bits inode number */
 } xfs_fid_t;
 
-typedef struct xfs_fid2 {
-	__u16	fid_len;	/* length of remainder */
-	__u16	fid_pad;	/* padding, must be zero */
-	__u32	fid_gen;	/* generation number */
-	__u64	fid_ino;	/* inode number */
-} xfs_fid2_t;
-
 typedef struct xfs_handle {
 	union {
 		__s64	    align;	/* force alignment of ha_fid	 */
@@ -422,9 +405,9 @@ typedef struct xfs_handle {
 } xfs_handle_t;
 #define ha_fsid ha_u._ha_fsid
 
-#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.xfs_fid_pad	 \
+#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.fid_pad	 \
 				 - (char *) &(handle))			  \
-				 + (handle).ha_fid.xfs_fid_len)
+				 + (handle).ha_fid.fid_len)
 
 /*
  * Flags for going down operation
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2007-08-29 15:37:09.000000000 +0200
@@ -1635,9 +1635,8 @@ int
 xfs_vget(
 	xfs_mount_t	*mp,
 	bhv_vnode_t	**vpp,
-	fid_t		*fidp)
+	xfs_fid_t	*xfid)
 {
-	xfs_fid_t	*xfid = (struct xfs_fid *)fidp;
 	xfs_inode_t	*ip;
 	int		error;
 	xfs_ino_t	ino;
@@ -1647,11 +1646,11 @@ xfs_vget(
 	 * Invalid.  Since handles can be created in user space and passed in
 	 * via gethandle(), this is not cause for a panic.
 	 */
-	if (xfid->xfs_fid_len != sizeof(*xfid) - sizeof(xfid->xfs_fid_len))
+	if (xfid->fid_len != sizeof(*xfid) - sizeof(xfid->fid_len))
 		return XFS_ERROR(EINVAL);
 
-	ino  = xfid->xfs_fid_ino;
-	igen = xfid->xfs_fid_gen;
+	ino  = xfid->fid_ino;
+	igen = xfid->fid_gen;
 
 	/*
 	 * NFS can sometimes send requests for ino 0.  Fail them gracefully.
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2007-08-29 15:36:47.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2007-08-29 15:37:48.000000000 +0200
@@ -3470,23 +3470,14 @@ std_return:
 }
 
 
-/*
- * xfs_fid2
- *
- * A fid routine that takes a pointer to a previously allocated
- * fid structure (like xfs_fast_fid) but uses a 64 bit inode number.
- */
 int
 xfs_fid2(
 	xfs_inode_t	*ip,
-	fid_t		*fidp)
+	xfs_fid_t	*xfid)
 {
-	xfs_fid2_t	*xfid = (xfs_fid2_t *)fidp;
-
 	xfs_itrace_entry(ip);
-	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
-	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
+	xfid->fid_len = sizeof(xfs_fid_t) - sizeof(xfid->fid_len);
 	xfid->fid_pad = 0;
 	/*
 	 * use memcpy because the inode is a long long and there's no
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-29 15:36:46.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2007-08-29 15:37:09.000000000 +0200
@@ -152,11 +152,11 @@ xfs_find_handle(
 		lock_mode = xfs_ilock_map_shared(ip);
 
 		/* fill in fid section of handle from inode */
-		handle.ha_fid.xfs_fid_len = sizeof(xfs_fid_t) -
-					    sizeof(handle.ha_fid.xfs_fid_len);
-		handle.ha_fid.xfs_fid_pad = 0;
-		handle.ha_fid.xfs_fid_gen = ip->i_d.di_gen;
-		handle.ha_fid.xfs_fid_ino = ip->i_ino;
+		handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+					sizeof(handle.ha_fid.fid_len);
+		handle.ha_fid.fid_pad = 0;
+		handle.ha_fid.fid_gen = ip->i_d.di_gen;
+		handle.ha_fid.fid_ino = ip->i_ino;
 
 		xfs_iunlock_map_shared(ip, lock_mode);
 
@@ -222,10 +222,10 @@ xfs_vget_fsop_handlereq(
 	if (hlen < sizeof(*handlep))
 		memset(((char *)handlep) + hlen, 0, sizeof(*handlep) - hlen);
 	if (hlen > sizeof(handlep->ha_fsid)) {
-		if (handlep->ha_fid.xfs_fid_len !=
-				(hlen - sizeof(handlep->ha_fsid)
-					- sizeof(handlep->ha_fid.xfs_fid_len))
-		    || handlep->ha_fid.xfs_fid_pad)
+		if (handlep->ha_fid.fid_len !=
+		    (hlen - sizeof(handlep->ha_fsid) -
+		            sizeof(handlep->ha_fid.fid_len)) ||
+		    handlep->ha_fid.fid_pad)
 			return XFS_ERROR(EINVAL);
 	}
 
@@ -233,9 +233,9 @@ xfs_vget_fsop_handlereq(
 	 * Crack the handle, obtain the inode # & generation #
 	 */
 	xfid = (struct xfs_fid *)&handlep->ha_fid;
-	if (xfid->xfs_fid_len == sizeof(*xfid) - sizeof(xfid->xfs_fid_len)) {
-		ino  = xfid->xfs_fid_ino;
-		igen = xfid->xfs_fid_gen;
+	if (xfid->fid_len == sizeof(*xfid) - sizeof(xfid->fid_len)) {
+		ino  = xfid->fid_ino;
+		igen = xfid->fid_gen;
 	} else {
 		return XFS_ERROR(EINVAL);
 	}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_export.h	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_export.h	2007-08-29 15:37:09.000000000 +0200
@@ -71,13 +71,13 @@ xfs_fileid_length(int hasparent, int is6
 
 /*
  * Decode encoded inode information (either for the inode itself
- * or the parent) into an xfs_fid2_t structure.  Advances and
+ * or the parent) into an xfs_fid_t structure.  Advances and
  * returns the new data pointer
  */
 static inline __u32 *
-xfs_fileid_decode_fid2(__u32 *p, xfs_fid2_t *fid, int is64)
+xfs_fileid_decode_fid2(__u32 *p, xfs_fid_t *fid, int is64)
 {
-	fid->fid_len = sizeof(xfs_fid2_t) - sizeof(fid->fid_len);
+	fid->fid_len = sizeof(xfs_fid_t) - sizeof(fid->fid_len);
 	fid->fid_pad = 0;
 	fid->fid_ino = *p++;
 #if XFS_BIG_INUMS
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-29 15:37:09.000000000 +0200
@@ -647,11 +647,11 @@ dm_dip_to_handle(
 	dm_handle_t	*handlep)
 {
 	dm_fid_t	fid;
-	xfs_fid2_t	*xfid;
+	struct xfs_fid	*xfid;
 	int		hsize;
 
-	xfid = (xfs_fid2_t *)&fid;
-	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
+	xfid = (struct xfs_fid *)&fid;
+	xfid->fid_len = sizeof(struct xfs_fid) - sizeof(xfid->fid_len);
 	xfid->fid_pad = 0;
 	xfid->fid_ino = ino;
         xfid->fid_gen = be32_to_cpu(dip->di_core.di_gen);
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_fsops.c	2007-08-29 15:37:09.000000000 +0200
@@ -67,14 +67,14 @@ xfs_dm_fh_to_inode(
 	bhv_vnode_t	*vp = NULL;
 	xfs_mount_t	*mp = XFS_M(sb);
 	int		error;
-	fid_t		fid;
+	struct xfs_fid	xfid;
 
 	/* Returns negative errors to DMAPI */
 
 	*ip = NULL;
-	memcpy(&fid, dmfid, sizeof(*dmfid));
-	if (fid.fid_len) {	/* file object handle */
-		error = xfs_vget(mp, &vp, &fid);
+	memcpy(&xfid, dmfid, sizeof(*dmfid));
+	if (xfid.fid_len) {	/* file object handle */
+		error = xfs_vget(mp, &vp, &xfid);
 	}
 	else {			/* filesystem handle */
 		error = xfs_root(mp, &vp);
@@ -92,17 +92,17 @@ xfs_dm_inode_to_fh(
 {
 	xfs_inode_t		*ip = XFS_I(inode);
 	int			error;
-	fid_t			fid;
+	struct xfs_fid		xfid;
 
 	/* Returns negative errors to DMAPI */
 
 	if (ip->i_mount->m_fixedfsid == NULL)
 		return -EINVAL;
-	error = xfs_fid2(ip, &fid);
+	error = xfs_fid2(ip, &xfid);
 	if (error)
 		return -error; /* Return negative error to DMAPI */
 
-	memcpy(dmfid, &fid, sizeof(*dmfid));
+	memcpy(dmfid, &xfid, sizeof(*dmfid));
 	memcpy(dmfsid, ip->i_mount->m_fixedfsid, sizeof(*dmfsid));
 	return 0;
 }
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.h	2007-08-29 15:36:21.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.h	2007-08-29 15:37:09.000000000 +0200
@@ -2,7 +2,7 @@
 #define _XFS_VFSOPS_H 1
 
 struct cred;
-struct fid;
+struct xfs_fid;
 struct inode;
 struct kstatfs;
 struct xfs_mount;
@@ -17,7 +17,7 @@ int xfs_root(struct xfs_mount *mp, bhv_v
 int xfs_statvfs(struct xfs_mount *mp, struct kstatfs *statp,
 		bhv_vnode_t *vp);
 int xfs_sync(struct xfs_mount *mp, int flags);
-int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct fid *fidp);
+int xfs_vget(struct xfs_mount *mp, bhv_vnode_t **vpp, struct xfs_fid *xfid);
 int xfs_parseargs(struct xfs_mount *mp, char *options,
 		struct xfs_mount_args *args, int update);
 int xfs_showargs(struct xfs_mount *mp, struct seq_file *m);
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.h	2007-08-29 15:36:20.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.h	2007-08-29 15:37:09.000000000 +0200
@@ -39,7 +39,7 @@ int xfs_readdir(struct xfs_inode	*dp, vo
 int xfs_symlink(struct xfs_inode *dp, bhv_vname_t *dentry,
 		struct bhv_vattr *vap, char *target_path,
 		bhv_vnode_t **vpp, struct cred *credp);
-int xfs_fid2(struct xfs_inode *ip, fid_t	*fidp);
+int xfs_fid2(struct xfs_inode *ip, struct xfs_fid *xfid);
 int xfs_rwlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 void xfs_rwunlock(struct xfs_inode *ip, bhv_vrwlock_t locktype);
 int xfs_inode_flush(struct xfs_inode *ip, int flags);
