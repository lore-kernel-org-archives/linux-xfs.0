Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 14:46:48 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NLkifE026122
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:46:45 -0700
Received: from verein.lst.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D484191E1DD
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:54 -0700 (PDT)
Received: from verein.lst.de (verein.lst.de [213.95.11.210]) by cuda.sgi.com with ESMTP id JkwsUw58lvSDwVpj for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 14:47:54 -0700 (PDT)
Received: from verein.lst.de (localhost [127.0.0.1])
	by verein.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id m6NLljNg010803
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:47:45 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id m6NLljbT010801
	for xfs@oss.sgi.com; Wed, 23 Jul 2008 23:47:45 +0200
Date: Wed, 23 Jul 2008 23:47:45 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] kill bhv_vnode_t
Message-ID: <20080723214745.GC10655@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

All remaining bhv_vnode_t instance are in code that's more or less Linux
specific.  (Well, for xfs_acl.c that could be argued, but that code is
on the removal list, too).  So just do an s/bhv_vnode_t/struct inode/
over the whole tree.  We can clean up variable naming and some useless
helpers later.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 22:33:54.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_super.c	2008-07-23 22:33:58.000000000 +0200
@@ -1818,7 +1818,7 @@ xfs_free_trace_bufs(void)
 STATIC int __init
 xfs_init_zones(void)
 {
-	xfs_vnode_zone = kmem_zone_init_flags(sizeof(bhv_vnode_t), "xfs_vnode",
+	xfs_vnode_zone = kmem_zone_init_flags(sizeof(struct inode), "xfs_vnode",
 					KM_ZONE_HWALIGN | KM_ZONE_RECLAIM |
 					KM_ZONE_SPREAD,
 					xfs_fs_inode_init_once);
Index: linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/quota/xfs_qm_syscalls.c	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/quota/xfs_qm_syscalls.c	2008-07-23 22:33:58.000000000 +0200
@@ -1034,7 +1034,7 @@ xfs_qm_dqrele_all_inodes(
 {
 	xfs_inode_t	*ip, *topino;
 	uint		ireclaims;
-	bhv_vnode_t	*vp;
+	struct inode	*vp;
 	boolean_t	vnode_refd;
 
 	ASSERT(mp->m_quotainfo);
Index: linux-2.6-xfs/fs/xfs/xfs_acl.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.c	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.c	2008-07-23 22:33:58.000000000 +0200
@@ -37,15 +37,15 @@
 #include <linux/capability.h>
 #include <linux/posix_acl_xattr.h>
 
-STATIC int	xfs_acl_setmode(bhv_vnode_t *, xfs_acl_t *, int *);
+STATIC int	xfs_acl_setmode(struct inode *, xfs_acl_t *, int *);
 STATIC void     xfs_acl_filter_mode(mode_t, xfs_acl_t *);
 STATIC void	xfs_acl_get_endian(xfs_acl_t *);
 STATIC int	xfs_acl_access(uid_t, gid_t, xfs_acl_t *, mode_t, cred_t *);
 STATIC int	xfs_acl_invalid(xfs_acl_t *);
 STATIC void	xfs_acl_sync_mode(mode_t, xfs_acl_t *);
-STATIC void	xfs_acl_get_attr(bhv_vnode_t *, xfs_acl_t *, int, int, int *);
-STATIC void	xfs_acl_set_attr(bhv_vnode_t *, xfs_acl_t *, int, int *);
-STATIC int	xfs_acl_allow_set(bhv_vnode_t *, int);
+STATIC void	xfs_acl_get_attr(struct inode *, xfs_acl_t *, int, int, int *);
+STATIC void	xfs_acl_set_attr(struct inode *, xfs_acl_t *, int, int *);
+STATIC int	xfs_acl_allow_set(struct inode *, int);
 
 kmem_zone_t *xfs_acl_zone;
 
@@ -55,7 +55,7 @@ kmem_zone_t *xfs_acl_zone;
  */
 int
 xfs_acl_vhasacl_access(
-	bhv_vnode_t	*vp)
+	struct inode	*vp)
 {
 	int		error;
 
@@ -68,7 +68,7 @@ xfs_acl_vhasacl_access(
  */
 int
 xfs_acl_vhasacl_default(
-	bhv_vnode_t	*vp)
+	struct inode	*vp)
 {
 	int		error;
 
@@ -207,7 +207,7 @@ posix_acl_xfs_to_xattr(
 
 int
 xfs_acl_vget(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	void		*acl,
 	size_t		size,
 	int		kind)
@@ -249,7 +249,7 @@ out:
 
 int
 xfs_acl_vremove(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	int		kind)
 {
 	int		error;
@@ -268,7 +268,7 @@ xfs_acl_vremove(
 
 int
 xfs_acl_vset(
-	bhv_vnode_t		*vp,
+	struct inode		*vp,
 	void			*acl,
 	size_t			size,
 	int			kind)
@@ -357,7 +357,7 @@ xfs_acl_iaccess(
 
 STATIC int
 xfs_acl_allow_set(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	int		kind)
 {
 	if (vp->i_flags & (S_IMMUTABLE|S_APPEND))
@@ -561,7 +561,7 @@ xfs_acl_get_endian(
  */
 STATIC void
 xfs_acl_get_attr(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	xfs_acl_t	*aclp,
 	int		kind,
 	int		flags,
@@ -585,7 +585,7 @@ xfs_acl_get_attr(
  */
 STATIC void
 xfs_acl_set_attr(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	xfs_acl_t	*aclp,
 	int		kind,
 	int		*error)
@@ -619,7 +619,7 @@ xfs_acl_set_attr(
 
 int
 xfs_acl_vtoacl(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	xfs_acl_t	*access_acl,
 	xfs_acl_t	*default_acl)
 {
@@ -651,7 +651,7 @@ xfs_acl_vtoacl(
  */
 int
 xfs_acl_inherit(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	mode_t		mode,
 	xfs_acl_t	*pdaclp)
 {
@@ -710,7 +710,7 @@ out_error:
  */
 STATIC int
 xfs_acl_setmode(
-	bhv_vnode_t	*vp,
+	struct inode	*vp,
 	xfs_acl_t	*acl,
 	int		*basicperms)
 {
Index: linux-2.6-xfs/fs/xfs/xfs_acl.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_acl.h	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_acl.h	2008-07-23 22:33:58.000000000 +0200
@@ -59,14 +59,14 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
-extern int xfs_acl_inherit(bhv_vnode_t *, mode_t mode, xfs_acl_t *);
+extern int xfs_acl_inherit(struct inode *, mode_t mode, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
-extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
-extern int xfs_acl_vhasacl_access(bhv_vnode_t *);
-extern int xfs_acl_vhasacl_default(bhv_vnode_t *);
-extern int xfs_acl_vset(bhv_vnode_t *, void *, size_t, int);
-extern int xfs_acl_vget(bhv_vnode_t *, void *, size_t, int);
-extern int xfs_acl_vremove(bhv_vnode_t *, int);
+extern int xfs_acl_vtoacl(struct inode *, xfs_acl_t *, xfs_acl_t *);
+extern int xfs_acl_vhasacl_access(struct inode *);
+extern int xfs_acl_vhasacl_default(struct inode *);
+extern int xfs_acl_vset(struct inode *, void *, size_t, int);
+extern int xfs_acl_vget(struct inode *, void *, size_t, int);
+extern int xfs_acl_vremove(struct inode *, int);
 
 #define _ACL_PERM_INVALID(perm)	((perm) & ~(ACL_READ|ACL_WRITE|ACL_EXECUTE))
 
Index: linux-2.6-xfs/fs/xfs/xfs_inode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_inode.h	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_inode.h	2008-07-23 22:33:58.000000000 +0200
@@ -204,7 +204,7 @@ typedef struct xfs_inode {
 	struct xfs_inode	*i_mprev;	/* ptr to prev inode */
 	struct xfs_mount	*i_mount;	/* fs mount struct ptr */
 	struct list_head	i_reclaim;	/* reclaim list */
-	bhv_vnode_t		*i_vnode;	/* vnode backpointer */
+	struct inode		*i_vnode;	/* vnode backpointer */
 	struct xfs_dquot	*i_udquot;	/* user dquot */
 	struct xfs_dquot	*i_gdquot;	/* group dquot */
 
Index: linux-2.6-xfs/fs/xfs/xfs_vfsops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vfsops.c	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vfsops.c	2008-07-23 22:35:36.000000000 +0200
@@ -282,7 +282,7 @@ xfs_sync_inodes(
 	int             *bypassed)
 {
 	xfs_inode_t	*ip = NULL;
-	bhv_vnode_t	*vp = NULL;
+	struct inode	*vp = NULL;
 	int		error;
 	int		last_error;
 	uint64_t	fflag;
Index: linux-2.6-xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/xfs_vnodeops.c	2008-07-23 22:33:43.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/xfs_vnodeops.c	2008-07-23 22:33:58.000000000 +0200
@@ -2850,7 +2850,7 @@ xfs_finish_reclaim(
 	int		sync_mode)
 {
 	xfs_perag_t	*pag = xfs_get_perag(ip->i_mount, ip->i_ino);
-	bhv_vnode_t	*vp = VFS_I(ip);
+	struct inode	*vp = VFS_I(ip);
 
 	if (vp && VN_BAD(vp))
 		goto reclaim;
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-23 22:34:05.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.c	2008-07-23 22:34:31.000000000 +0200
@@ -90,7 +90,7 @@ vn_ioerror(
  */
 static inline int xfs_icount(struct xfs_inode *ip)
 {
-	bhv_vnode_t *vp = VFS_I(ip);
+	struct inode *vp = VFS_I(ip);
 
 	if (vp)
 		return vn_count(vp);
Index: linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h
===================================================================
--- linux-2.6-xfs.orig/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 22:34:40.000000000 +0200
+++ linux-2.6-xfs/fs/xfs/linux-2.6/xfs_vnode.h	2008-07-23 22:36:29.000000000 +0200
@@ -22,8 +22,6 @@ struct file;
 struct xfs_iomap;
 struct attrlist_cursor_kern;
 
-typedef struct inode	bhv_vnode_t;
-
 /*
  * Return values for xfs_inactive.  A return value of
  * VN_INACTIVE_NOCACHE implies that the file system behavior
@@ -64,7 +62,7 @@ extern void	vn_iowait(struct xfs_inode *
 extern void	vn_iowake(struct xfs_inode *ip);
 extern void	vn_ioerror(struct xfs_inode *ip, int error, char *f, int l);
 
-static inline int vn_count(bhv_vnode_t *vp)
+static inline int vn_count(struct inode *vp)
 {
 	return atomic_read(&vp->i_count);
 }
@@ -81,7 +79,7 @@ do { \
 	iput(VFS_I(ip)); \
 } while (0)
 
-static inline bhv_vnode_t *vn_grab(bhv_vnode_t *vp)
+static inline struct inode *vn_grab(struct inode *vp)
 {
 	return igrab(vp);
 }
@@ -89,7 +87,7 @@ static inline bhv_vnode_t *vn_grab(bhv_v
 /*
  * Dealing with bad inodes
  */
-static inline int VN_BAD(bhv_vnode_t *vp)
+static inline int VN_BAD(struct inode *vp)
 {
 	return is_bad_inode(vp);
 }
@@ -97,18 +95,18 @@ static inline int VN_BAD(bhv_vnode_t *vp
 /*
  * Extracting atime values in various formats
  */
-static inline void vn_atime_to_bstime(bhv_vnode_t *vp, xfs_bstime_t *bs_atime)
+static inline void vn_atime_to_bstime(struct inode *vp, xfs_bstime_t *bs_atime)
 {
 	bs_atime->tv_sec = vp->i_atime.tv_sec;
 	bs_atime->tv_nsec = vp->i_atime.tv_nsec;
 }
 
-static inline void vn_atime_to_timespec(bhv_vnode_t *vp, struct timespec *ts)
+static inline void vn_atime_to_timespec(struct inode *vp, struct timespec *ts)
 {
 	*ts = vp->i_atime;
 }
 
-static inline void vn_atime_to_time_t(bhv_vnode_t *vp, time_t *tt)
+static inline void vn_atime_to_time_t(struct inode *vp, time_t *tt)
 {
 	*tt = vp->i_atime.tv_sec;
 }
