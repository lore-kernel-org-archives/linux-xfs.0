Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 12:39:16 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l7NJd74p003969
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 12:39:09 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l7NJd5A5008625
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 21:39:05 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l7NJd5u7008623
	for xfs@oss.sgi.com; Thu, 23 Aug 2007 21:39:05 +0200
Date: Thu, 23 Aug 2007 21:39:05 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/17] kill struct bhv_vnode
Message-ID: <20070823193905.GI8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Now that struct bhv_vnode is empty we can just kill it.  Retain bhv_vattr_t
as a typedef for struct inode for the time beeing until all the fallout is
cleaned up.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm_bhv.c	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm_bhv.c	2007-08-13 18:07:43.000000000 +0200
@@ -58,7 +58,7 @@ xfs_dm_mount(
 	struct xfs_mount_args	*args,
 	struct cred		*cr)
 {
-	struct bhv_vnode	*rootvp;
+	bhv_vnode_t		*rootvp;
 	struct bhv_vfs		*vfsp = bhvtovfs(bhv);
 	int			error = 0;
 
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_bhv.c	2007-08-13 17:59:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_bhv.c	2007-08-13 18:07:43.000000000 +0200
@@ -188,7 +188,7 @@ STATIC int
 xfs_qm_statvfs(
 	struct bhv_desc		*bhv,
 	bhv_statvfs_t		*statp,
-	struct bhv_vnode	*vnode)
+	bhv_vnode_t		*vnode)
 {
 	xfs_mount_t		*mp;
 	xfs_inode_t		*ip;
Index: linux-2.6-xfs/fs/xfs/xfs_acl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.h	2007-08-13 17:59:08.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.h	2007-08-13 18:07:43.000000000 +0200
@@ -50,7 +50,6 @@ typedef struct xfs_acl {
 #ifdef CONFIG_XFS_POSIX_ACL
 
 struct vattr;
-struct bhv_vnode;
 struct xfs_inode;
 
 extern struct kmem_zone *xfs_acl_zone;
@@ -58,14 +57,14 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
-extern int xfs_acl_inherit(struct bhv_vnode *, struct bhv_vattr *, xfs_acl_t *);
+extern int xfs_acl_inherit(bhv_vnode_t *, struct bhv_vattr *, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
-extern int xfs_acl_vtoacl(struct bhv_vnode *, xfs_acl_t *, xfs_acl_t *);
-extern int xfs_acl_vhasacl_access(struct bhv_vnode *);
-extern int xfs_acl_vhasacl_default(struct bhv_vnode *);
-extern int xfs_acl_vset(struct bhv_vnode *, void *, size_t, int);
-extern int xfs_acl_vget(struct bhv_vnode *, void *, size_t, int);
-extern int xfs_acl_vremove(struct bhv_vnode *, int);
+extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
+extern int xfs_acl_vhasacl_access(bhv_vnode_t *);
+extern int xfs_acl_vhasacl_default(bhv_vnode_t *);
+extern int xfs_acl_vset(bhv_vnode_t *, void *, size_t, int);
+extern int xfs_acl_vget(bhv_vnode_t *, void *, size_t, int);
+extern int xfs_acl_vremove(bhv_vnode_t *, int);
 
 #define _ACL_TYPE_ACCESS	1
 #define _ACL_TYPE_DEFAULT	2
Index: linux-2.6-xfs/fs/xfs/xfs_attr.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_attr.h	2007-08-13 18:07:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_attr.h	2007-08-13 18:07:43.000000000 +0200
@@ -36,14 +36,13 @@
  *========================================================================*/
 
 struct cred;
-struct bhv_vnode;
 struct xfs_attr_list_context;
 
-typedef int (*attrset_t)(struct bhv_vnode *, char *, void *, size_t, int);
-typedef int (*attrget_t)(struct bhv_vnode *, char *, void *, size_t, int);
-typedef int (*attrremove_t)(struct bhv_vnode *, char *, int);
-typedef int (*attrexists_t)(struct bhv_vnode *);
-typedef int (*attrcapable_t)(struct bhv_vnode *, struct cred *);
+typedef int (*attrset_t)(bhv_vnode_t *, char *, void *, size_t, int);
+typedef int (*attrget_t)(bhv_vnode_t *, char *, void *, size_t, int);
+typedef int (*attrremove_t)(bhv_vnode_t *, char *, int);
+typedef int (*attrexists_t)(bhv_vnode_t *);
+typedef int (*attrcapable_t)(bhv_vnode_t *, struct cred *);
 
 typedef struct attrnames {
 	char *		attr_name;
@@ -64,7 +63,7 @@ extern struct attrnames attr_trusted;
 extern struct attrnames *attr_namespaces[ATTR_NAMECOUNT];
 
 extern attrnames_t *attr_lookup_namespace(char *, attrnames_t **, int);
-extern int attr_generic_list(struct bhv_vnode *, void *, size_t, int, ssize_t *);
+extern int attr_generic_list(bhv_vnode_t *, void *, size_t, int, ssize_t *);
 
 #define ATTR_DONTFOLLOW	0x0001	/* -- unused, from IRIX -- */
 #define ATTR_ROOT	0x0002	/* use attrs in root (trusted) namespace */
Index: linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:07:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/dmapi/xfs_dm.c	2007-08-13 18:07:43.000000000 +0200
@@ -474,7 +474,7 @@ xfs_ip_to_stat(
 	buf->dt_uid = dic->di_uid;
 	buf->dt_gid = dic->di_gid;
 	buf->dt_size = XFS_ISIZE(ip);
-	buf->dt_dev = new_encode_dev(vp->v_inode.i_sb->s_dev);
+	buf->dt_dev = new_encode_dev(vp->i_sb->s_dev);
 	vn_atime_to_time_t(vp, &buf->dt_atime);
 	buf->dt_mtime = dic->di_mtime.t_sec;
 	buf->dt_ctime = dic->di_ctime.t_sec;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2007-08-13 18:07:36.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_iops.c	2007-08-13 18:07:43.000000000 +0200
@@ -65,9 +65,8 @@ xfs_synchronize_atime(
 
 	vp = XFS_ITOV_NULL(ip);
 	if (vp) {
-		struct inode *inode = &vp->v_inode;
-		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
-		ip->i_d.di_atime.t_nsec = (__int32_t)inode->i_atime.tv_nsec;
+		ip->i_d.di_atime.t_sec = (__int32_t)vp->i_atime.tv_sec;
+		ip->i_d.di_atime.t_nsec = (__int32_t)vp->i_atime.tv_nsec;
 	}
 }
 
@@ -327,7 +326,7 @@ xfs_vn_mknod(
 		if (!error) {
 			error = _ACL_INHERIT(vp, &vattr, default_acl);
 			if (!error)
-				xfs_iflags_set(XFS_I(&vp->v_inode), XFS_IMODIFIED);
+				xfs_iflags_set(XFS_I(vp), XFS_IMODIFIED);
 			else
 				xfs_cleanup_inode(dir, vp, dentry, mode);
 		}
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-13 18:07:33.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_lrw.h	2007-08-13 18:07:43.000000000 +0200
@@ -19,7 +19,6 @@
 #define __XFS_LRW_H__
 
 struct bhv_desc;
-struct bhv_vnode;
 struct xfs_mount;
 struct xfs_iocore;
 struct xfs_inode;
@@ -75,7 +74,7 @@ extern int xfsbdstrat(struct xfs_mount *
 extern int xfs_bdstrat_cb(struct xfs_buf *);
 extern int xfs_dev_is_read_only(struct xfs_mount *, char *);
 
-extern int xfs_zero_eof(struct bhv_vnode *, struct xfs_iocore *, xfs_off_t,
+extern int xfs_zero_eof(struct inode *, struct xfs_iocore *, xfs_off_t,
 				xfs_fsize_t);
 
 #endif	/* __XFS_LRW_H__ */
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:07:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2007-08-13 18:07:43.000000000 +0200
@@ -787,7 +787,7 @@ xfs_fs_fill_super(
 	void			*data,
 	int			silent)
 {
-	struct bhv_vnode	*rootvp;
+	struct inode		*rootvp;
 	struct bhv_vfs		*vfsp = vfs_allocate(sb);
 	struct xfs_mount_args	*args = xfs_args_allocate(sb, silent);
 	struct kstatfs		statvfs;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.c	2007-08-13 18:07:48.000000000 +0200
@@ -103,7 +103,7 @@ vfs_mntupdate(
 int
 vfs_root(
 	struct bhv_desc		*bdp,
-	struct bhv_vnode	**vpp)
+	bhv_vnode_t		**vpp)
 {
 	struct bhv_desc		*next = bdp;
 
@@ -117,7 +117,7 @@ int
 vfs_statvfs(
 	struct bhv_desc		*bdp,
 	bhv_statvfs_t		*statp,
-	struct bhv_vnode	*vp)
+	bhv_vnode_t		*vp)
 {
 	struct bhv_desc		*next = bdp;
 
@@ -144,7 +144,7 @@ vfs_sync(
 int
 vfs_vget(
 	struct bhv_desc		*bdp,
-	struct bhv_vnode	**vpp,
+	bhv_vnode_t		**vpp,
 	struct fid		*fidp)
 {
 	struct bhv_desc		*next = bdp;
@@ -199,7 +199,7 @@ vfs_get_inode(
 void
 vfs_init_vnode(
 	struct bhv_desc		*bdp,
-	struct bhv_vnode	*vp,
+	bhv_vnode_t		*vp,
 	struct xfs_inode	*ip,
 	int			unlock)
 {
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vfs.h	2007-08-13 18:07:43.000000000 +0200
@@ -22,7 +22,7 @@
 #include "xfs_fs.h"
 
 struct bhv_vfs;
-struct bhv_vnode;
+struct inode;
 
 struct fid;
 struct cred;
@@ -124,15 +124,15 @@ typedef	int	(*vfs_showargs_t)(bhv_desc_t
 typedef int	(*vfs_unmount_t)(bhv_desc_t *, int, struct cred *);
 typedef int	(*vfs_mntupdate_t)(bhv_desc_t *, int *,
 				struct xfs_mount_args *);
-typedef int	(*vfs_root_t)(bhv_desc_t *, struct bhv_vnode **);
+typedef int	(*vfs_root_t)(bhv_desc_t *, struct inode **);
 typedef int	(*vfs_statvfs_t)(bhv_desc_t *, bhv_statvfs_t *,
-				struct bhv_vnode *);
+				struct inode *);
 typedef int	(*vfs_sync_t)(bhv_desc_t *, int, struct cred *);
-typedef int	(*vfs_vget_t)(bhv_desc_t *, struct bhv_vnode **, struct fid *);
+typedef int	(*vfs_vget_t)(bhv_desc_t *, struct inode **, struct fid *);
 typedef int	(*vfs_dmapiops_t)(bhv_desc_t *, caddr_t);
 typedef int	(*vfs_quotactl_t)(bhv_desc_t *, int, int, caddr_t);
 typedef void	(*vfs_init_vnode_t)(bhv_desc_t *,
-				struct bhv_vnode *, struct xfs_inode *, int);
+				struct inode *, struct xfs_inode *, int);
 typedef void	(*vfs_force_shutdown_t)(bhv_desc_t *, int, char *, int);
 typedef void	(*vfs_freeze_t)(bhv_desc_t *);
 typedef	struct inode * (*vfs_get_inode_t)(bhv_desc_t *, xfs_ino_t, int);
@@ -200,14 +200,14 @@ extern int vfs_parseargs(bhv_desc_t *, c
 extern int vfs_showargs(bhv_desc_t *, struct seq_file *);
 extern int vfs_unmount(bhv_desc_t *, int, struct cred *);
 extern int vfs_mntupdate(bhv_desc_t *, int *, struct xfs_mount_args *);
-extern int vfs_root(bhv_desc_t *, struct bhv_vnode **);
-extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct bhv_vnode *);
+extern int vfs_root(bhv_desc_t *, struct inode **);
+extern int vfs_statvfs(bhv_desc_t *, bhv_statvfs_t *, struct inode *);
 extern int vfs_sync(bhv_desc_t *, int, struct cred *);
-extern int vfs_vget(bhv_desc_t *, struct bhv_vnode **, struct fid *);
+extern int vfs_vget(bhv_desc_t *, struct inode **, struct fid *);
 extern int vfs_dmapiops(bhv_desc_t *, caddr_t);
 extern int vfs_quotactl(bhv_desc_t *, int, int, caddr_t);
 extern struct inode *vfs_get_inode(bhv_desc_t *, xfs_ino_t, int);
-extern void vfs_init_vnode(bhv_desc_t *, struct bhv_vnode *, struct xfs_inode *, int);
+extern void vfs_init_vnode(bhv_desc_t *, struct inode *, struct xfs_inode *, int);
 extern void vfs_force_shutdown(bhv_desc_t *, int, char *, int);
 extern void vfs_freeze(bhv_desc_t *);
 
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-13 18:07:39.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2007-08-13 18:07:43.000000000 +0200
@@ -26,28 +26,24 @@ struct attrlist_cursor_kern;
 
 typedef struct dentry	bhv_vname_t;
 typedef __u64		bhv_vnumber_t;
+typedef struct inode	bhv_vnode_t;
 
-typedef struct bhv_vnode {
-	struct inode	v_inode;		/* Linux inode */
-	/* inode MUST be last */
-} bhv_vnode_t;
-
-#define VN_ISLNK(vp)	S_ISLNK((vp)->v_inode.i_mode)
-#define VN_ISREG(vp)	S_ISREG((vp)->v_inode.i_mode)
-#define VN_ISDIR(vp)	S_ISDIR((vp)->v_inode.i_mode)
-#define VN_ISCHR(vp)	S_ISCHR((vp)->v_inode.i_mode)
-#define VN_ISBLK(vp)	S_ISBLK((vp)->v_inode.i_mode)
+#define VN_ISLNK(vp)	S_ISLNK((vp)->i_mode)
+#define VN_ISREG(vp)	S_ISREG((vp)->i_mode)
+#define VN_ISDIR(vp)	S_ISDIR((vp)->i_mode)
+#define VN_ISCHR(vp)	S_ISCHR((vp)->i_mode)
+#define VN_ISBLK(vp)	S_ISBLK((vp)->i_mode)
 
 /*
  * Vnode to Linux inode mapping.
  */
-static inline struct bhv_vnode *vn_from_inode(struct inode *inode)
+static inline bhv_vnode_t *vn_from_inode(struct inode *inode)
 {
-	return container_of(inode, bhv_vnode_t, v_inode);
+	return inode;
 }
-static inline struct inode *vn_to_inode(struct bhv_vnode *vnode)
+static inline struct inode *vn_to_inode(bhv_vnode_t *vnode)
 {
-	return &vnode->v_inode;
+	return vnode;
 }
 
 /*
@@ -193,9 +189,9 @@ typedef struct bhv_vattr {
 
 extern void	vn_init(void);
 extern bhv_vnode_t	*vn_initialize(struct inode *);
-extern int	vn_revalidate(struct bhv_vnode *);
-extern int	__vn_revalidate(struct bhv_vnode *, bhv_vattr_t *);
-extern void	vn_revalidate_core(struct bhv_vnode *, bhv_vattr_t *);
+extern int	vn_revalidate(bhv_vnode_t *);
+extern int	__vn_revalidate(bhv_vnode_t *, bhv_vattr_t *);
+extern void	vn_revalidate_core(bhv_vnode_t *, bhv_vattr_t *);
 
 /*
  * Yeah, these don't take vnode anymore at all, all this should be
@@ -205,7 +201,7 @@ extern void	vn_iowait(struct xfs_inode *
 extern void	vn_iowake(struct xfs_inode *ip);
 extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
-static inline int vn_count(struct bhv_vnode *vp)
+static inline int vn_count(bhv_vnode_t *vp)
 {
 	return atomic_read(&vn_to_inode(vp)->i_count);
 }
@@ -213,7 +209,7 @@ static inline int vn_count(struct bhv_vn
 /*
  * Vnode reference counting functions (and macros for compatibility).
  */
-extern bhv_vnode_t	*vn_hold(struct bhv_vnode *);
+extern bhv_vnode_t	*vn_hold(bhv_vnode_t *);
 
 #if defined(XFS_VNODE_TRACE)
 #define VN_HOLD(vp)		\
@@ -227,7 +223,7 @@ extern bhv_vnode_t	*vn_hold(struct bhv_v
 #define VN_RELE(vp)		(iput(vn_to_inode(vp)))
 #endif
 
-static inline struct bhv_vnode *vn_grab(struct bhv_vnode *vp)
+static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
 {
 	struct inode *inode = igrab(vn_to_inode(vp));
 	return inode ? vn_from_inode(inode) : NULL;
@@ -243,12 +239,12 @@ static inline struct bhv_vnode *vn_grab(
 /*
  * Dealing with bad inodes
  */
-static inline void vn_mark_bad(struct bhv_vnode *vp)
+static inline void vn_mark_bad(bhv_vnode_t *vp)
 {
 	make_bad_inode(vn_to_inode(vp));
 }
 
-static inline int VN_BAD(struct bhv_vnode *vp)
+static inline int VN_BAD(bhv_vnode_t *vp)
 {
 	return is_bad_inode(vn_to_inode(vp));
 }
@@ -258,18 +254,18 @@ static inline int VN_BAD(struct bhv_vnod
  */
 static inline void vn_atime_to_bstime(bhv_vnode_t *vp, xfs_bstime_t *bs_atime)
 {
-	bs_atime->tv_sec = vp->v_inode.i_atime.tv_sec;
-	bs_atime->tv_nsec = vp->v_inode.i_atime.tv_nsec;
+	bs_atime->tv_sec = vp->i_atime.tv_sec;
+	bs_atime->tv_nsec = vp->i_atime.tv_nsec;
 }
 
 static inline void vn_atime_to_timespec(bhv_vnode_t *vp, struct timespec *ts)
 {
-	*ts = vp->v_inode.i_atime;
+	*ts = vp->i_atime;
 }
 
 static inline void vn_atime_to_time_t(bhv_vnode_t *vp, time_t *tt)
 {
-	*tt = vp->v_inode.i_atime.tv_sec;
+	*tt = vp->i_atime.tv_sec;
 }
 
 /*
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2007-08-13 18:07:35.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2007-08-13 18:07:43.000000000 +0200
@@ -376,11 +376,11 @@ xfs_acl_allow_set(
 	bhv_vattr_t	va;
 	int		error;
 
-	if (vp->v_inode.i_flags & (S_IMMUTABLE|S_APPEND))
+	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
 		return EPERM;
 	if (kind == _ACL_TYPE_DEFAULT && !VN_ISDIR(vp))
 		return ENOTDIR;
-	if (vp->v_inode.i_sb->s_flags & MS_RDONLY)
+	if (vp->i_sb->s_flags & MS_RDONLY)
 		return EROFS;
 	va.va_mask = XFS_AT_UID;
 	error = xfs_getattr(ip, &va, 0);
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2007-08-13 18:07:37.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2007-08-13 18:07:43.000000000 +0200
@@ -106,7 +106,6 @@ typedef struct xfs_ifork {
 
 #ifdef __KERNEL__
 struct bhv_desc;
-struct bhv_vnode;
 struct cred;
 struct ktrace;
 struct xfs_buf;
@@ -257,7 +256,7 @@ typedef struct xfs_inode {
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
-	struct bhv_vnode	*i_vnode;	/* vnode backpointer */
+	bhv_vnode_t		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
@@ -497,7 +496,7 @@ void		xfs_ihash_init(struct xfs_mount *)
 void		xfs_ihash_free(struct xfs_mount *);
 xfs_inode_t	*xfs_inode_incore(struct xfs_mount *, xfs_ino_t,
 				  struct xfs_trans *);
-void            xfs_inode_lock_init(xfs_inode_t *, struct bhv_vnode *);
+void            xfs_inode_lock_init(xfs_inode_t *, bhv_vnode_t *);
 int		xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 			 uint, uint, xfs_inode_t **, xfs_daddr_t);
 void		xfs_iput(xfs_inode_t *, uint);
Index: linux-2.6-xfs/fs/xfs/xfs_mount.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_mount.h	2007-08-13 18:07:34.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_mount.h	2007-08-13 18:07:43.000000000 +0200
@@ -55,7 +55,6 @@ typedef struct xfs_trans_reservations {
 struct cred;
 struct log;
 struct bhv_vfs;
-struct bhv_vnode;
 struct xfs_mount_args;
 struct xfs_inode;
 struct xfs_iocore;
@@ -78,15 +77,15 @@ extern struct bhv_vfsops xfs_vfsops;
  * Prototypes and functions for the Data Migration subsystem.
  */
 
-typedef int	(*xfs_send_data_t)(int, struct bhv_vnode *,
+typedef int	(*xfs_send_data_t)(int, bhv_vnode_t *,
 			xfs_off_t, size_t, int, bhv_vrwlock_t *);
 typedef int	(*xfs_send_mmap_t)(struct vm_area_struct *, uint);
-typedef int	(*xfs_send_destroy_t)(struct bhv_vnode *, dm_right_t);
+typedef int	(*xfs_send_destroy_t)(bhv_vnode_t *, dm_right_t);
 typedef int	(*xfs_send_namesp_t)(dm_eventtype_t, struct bhv_vfs *,
-			struct bhv_vnode *,
-			dm_right_t, struct bhv_vnode *, dm_right_t,
+			bhv_vnode_t *,
+			dm_right_t, bhv_vnode_t *, dm_right_t,
 			char *, char *, mode_t, int, int);
-typedef void	(*xfs_send_unmount_t)(struct bhv_vfs *, struct bhv_vnode *,
+typedef void	(*xfs_send_unmount_t)(struct bhv_vfs *, bhv_vnode_t *,
 			dm_right_t, mode_t, int, int);
 
 typedef struct xfs_dmops {
