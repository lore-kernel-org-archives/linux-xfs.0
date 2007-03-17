Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 16 Mar 2007 18:39:22 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2H1dE6p030266
	for <xfs@oss.sgi.com>; Fri, 16 Mar 2007 18:39:15 -0700
Date: Sat, 17 Mar 2007 01:10:03 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/18] xfs: kill struct fid/fid_t namespace pollution
Message-ID: <20070317011003.GB24947@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nfs@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

XFS currently defines various fid types internally, including an
fid_t which I will introduce kernel wide in the next patch.

This patch kills the fid_t and xfs_fid2_t types inside xfs and uses
xfs_fid_t consistantly.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_export.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_export.c	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_export.c	2007-03-13 18:21:55.000000000 +0100
@@ -48,8 +48,8 @@ xfs_fs_decode_fh(
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
@@ -141,7 +141,7 @@ xfs_fs_get_dentry(
 	bhv_vfs_t		*vfsp = vfs_from_sb(sb);
 	int			error;
 
-	error = bhv_vfs_vget(vfsp, &vp, (fid_t *)data);
+	error = bhv_vfs_vget(vfsp, &vp, data);
 	if (error || vp == NULL)
 		return ERR_PTR(-ESTALE) ;
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vfs.c	2007-03-13 18:21:55.000000000 +0100
@@ -145,7 +145,7 @@ int
 vfs_vget(
 	struct bhv_desc		*bdp,
 	struct bhv_vnode	**vpp,
-	struct fid		*fidp)
+	struct xfs_fid		*fidp)
 {
 	struct bhv_desc		*next = bdp;
 
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vfs.h	2007-03-13 18:21:55.000000000 +0100
@@ -24,10 +24,10 @@
 struct bhv_vfs;
 struct bhv_vnode;
 
-struct fid;
 struct cred;
 struct seq_file;
 struct super_block;
+struct xfs_fid;
 struct xfs_mount_args;
 
 typedef struct kstatfs	bhv_statvfs_t;
@@ -112,7 +112,8 @@ typedef int	(*vfs_root_t)(bhv_desc_t *, 
 typedef int	(*vfs_statvfs_t)(bhv_desc_t *, bhv_statvfs_t *,
 				struct bhv_vnode *);
 typedef int	(*vfs_sync_t)(bhv_desc_t *, int, struct cred *);
-typedef int	(*vfs_vget_t)(bhv_desc_t *, struct bhv_vnode **, struct fid *);
+typedef int	(*vfs_vget_t)(bhv_desc_t *, struct bhv_vnode **,
+				struct xfs_fid *);
 typedef int	(*vfs_dmapiops_t)(bhv_desc_t *, caddr_t);
 typedef int	(*vfs_quotactl_t)(bhv_desc_t *, int, int, caddr_t);
 typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
@@ -183,7 +184,7 @@ extern int vfs_mntupdate(bhv_desc_t *, i
 extern int vfs_root(bhv_desc_t *, struct bhv_vnode **);
 extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct bhv_vnode *);
 extern int vfs_sync(bhv_desc_t *, int, struct cred *);
-extern int vfs_vget(bhv_desc_t *, struct bhv_vnode **, struct fid *);
+extern int vfs_vget(bhv_desc_t *, struct bhv_vnode **, struct xfs_fid *);
 extern int vfs_dmapiops(bhv_desc_t *, caddr_t);
 extern int vfs_quotactl(bhv_desc_t *, int, int, caddr_t);
 extern void vfs_init_vnode(bhv_desc_t *, struct bhv_vnode *, bhv_desc_t *, int);
Index: linux-2.6/fs/xfs/xfs_fs.h
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_fs.h	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_fs.h	2007-03-13 18:21:55.000000000 +0100
@@ -387,30 +387,13 @@ typedef struct xfs_fsop_attrmulti_handle
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
@@ -420,9 +403,9 @@ typedef struct xfs_handle {
 } xfs_handle_t;
 #define ha_fsid ha_u._ha_fsid
 
-#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.xfs_fid_pad	 \
+#define XFS_HSIZE(handle)	(((char *) &(handle).ha_fid.fid_pad	 \
 				 - (char *) &(handle))			  \
-				 + (handle).ha_fid.xfs_fid_len)
+				 + (handle).ha_fid.fid_len)
 
 /*
  * Flags for going down operation
Index: linux-2.6/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vfsops.c	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_vfsops.c	2007-03-13 18:21:55.000000000 +0100
@@ -1565,10 +1565,9 @@ STATIC int
 xfs_vget(
 	bhv_desc_t	*bdp,
 	bhv_vnode_t	**vpp,
-	fid_t		*fidp)
+	xfs_fid_t	*xfid)
 {
 	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
-	xfs_fid_t	*xfid = (struct xfs_fid *)fidp;
 	xfs_inode_t	*ip;
 	int		error;
 	xfs_ino_t	ino;
@@ -1578,11 +1577,11 @@ xfs_vget(
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
Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2007-03-13 18:21:55.000000000 +0100
@@ -3577,28 +3577,18 @@ std_return:
 	goto std_return;
 }
 
-
-/*
- * xfs_fid2
- *
- * A fid routine that takes a pointer to a previously allocated
- * fid structure (like xfs_fast_fid) but uses a 64 bit inode number.
- */
 STATIC int
 xfs_fid2(
 	bhv_desc_t	*bdp,
-	fid_t		*fidp)
+	xfs_fid_t	*xfid)
 {
 	xfs_inode_t	*ip;
-	xfs_fid2_t	*xfid;
 
 	vn_trace_entry(BHV_TO_VNODE(bdp), __FUNCTION__,
 				       (inst_t *)__return_address);
-	ASSERT(sizeof(fid_t) >= sizeof(xfs_fid2_t));
 
-	xfid = (xfs_fid2_t *)fidp;
 	ip = XFS_BHVTOI(bdp);
-	xfid->fid_len = sizeof(xfs_fid2_t) - sizeof(xfid->fid_len);
+	xfid->fid_len = sizeof(xfs_fid_t) - sizeof(xfid->fid_len);
 	xfid->fid_pad = 0;
 	/*
 	 * use memcpy because the inode is a long long and there's no
Index: linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_vnode.h	2007-03-13 18:21:55.000000000 +0100
@@ -176,7 +176,7 @@ typedef int	(*vop_readlink_t)(bhv_desc_t
 typedef int	(*vop_fsync_t)(bhv_desc_t *, int, struct cred *,
 				xfs_off_t, xfs_off_t);
 typedef int	(*vop_inactive_t)(bhv_desc_t *, struct cred *);
-typedef int	(*vop_fid2_t)(bhv_desc_t *, struct fid *);
+typedef int	(*vop_fid2_t)(bhv_desc_t *, struct xfs_fid *);
 typedef int	(*vop_release_t)(bhv_desc_t *);
 typedef int	(*vop_rwlock_t)(bhv_desc_t *, bhv_vrwlock_t);
 typedef void	(*vop_rwunlock_t)(bhv_desc_t *, bhv_vrwlock_t);
Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2007-03-13 18:21:13.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2007-03-13 18:21:55.000000000 +0100
@@ -150,11 +150,11 @@ xfs_find_handle(
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
 
@@ -220,10 +220,10 @@ xfs_vget_fsop_handlereq(
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
 
@@ -231,9 +231,9 @@ xfs_vget_fsop_handlereq(
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
Index: linux-2.6/fs/xfs/linux-2.6/xfs_export.h
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_export.h	2007-03-13 18:23:42.000000000 +0100
+++ linux-2.6/fs/xfs/linux-2.6/xfs_export.h	2007-03-13 18:23:59.000000000 +0100
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
