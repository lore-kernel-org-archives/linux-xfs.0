Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:46:00 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBjt02021652
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:45:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7818190FD02
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:03 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id b9TbsnNIPqEHwOQB for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:47:03 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/3] XFS: Avoid directly referencing the VFS inode V2
Date: Mon, 21 Jul 2008 21:46:57 +1000
Message-Id: <1216640819-19924-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1216640819-19924-1-git-send-email-david@fromorbit.com>
References: <1216640819-19924-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: Dave Chinner <david@fromorbit.com>

In several places we directly convert from the XFS inode
to the linux (VFS) inode by a simple deference of ip->i_vnode.
We should not do this - a helper function should be used to
extract the VFS inode from the XFS inode.

Introduce the function VFS_I() to extract the VFS inode
from the XFS inode. The name was chosen to match XFS_I() which
is used to extract the XFS inode from the VFS inode.

Version 2:
o don't use vn_to_inode() and inode_to_vn() functions as they
  are not needed

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/linux-2.6/xfs_export.c  |    6 +++---
 fs/xfs/linux-2.6/xfs_fs_subr.c |    6 +++---
 fs/xfs/linux-2.6/xfs_iops.c    |   14 +++++++-------
 fs/xfs/linux-2.6/xfs_iops.h    |    6 ------
 fs/xfs/linux-2.6/xfs_lrw.c     |    2 +-
 fs/xfs/linux-2.6/xfs_super.c   |    4 ++--
 fs/xfs/xfs_iget.c              |    7 ++++---
 fs/xfs/xfs_inode.h             |   22 +++++++++++++++++++---
 fs/xfs/xfs_utils.c             |    4 ++--
 9 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_export.c b/fs/xfs/linux-2.6/xfs_export.c
index 987fe84..d3880b7 100644
--- a/fs/xfs/linux-2.6/xfs_export.c
+++ b/fs/xfs/linux-2.6/xfs_export.c
@@ -139,7 +139,7 @@ xfs_nfs_get_inode(
 	}
 
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
-	return ip->i_vnode;
+	return VFS_I(ip);
 }
 
 STATIC struct dentry *
@@ -219,9 +219,9 @@ xfs_fs_get_parent(
 	if (unlikely(error))
 		return ERR_PTR(-error);
 
-	parent = d_alloc_anon(cip->i_vnode);
+	parent = d_alloc_anon(VFS_I(cip));
 	if (unlikely(!parent)) {
-		iput(cip->i_vnode);
+		iput(VFS_I(cip));
 		return ERR_PTR(-ENOMEM);
 	}
 	return parent;
diff --git a/fs/xfs/linux-2.6/xfs_fs_subr.c b/fs/xfs/linux-2.6/xfs_fs_subr.c
index 1eefe61..36caa6d 100644
--- a/fs/xfs/linux-2.6/xfs_fs_subr.c
+++ b/fs/xfs/linux-2.6/xfs_fs_subr.c
@@ -31,7 +31,7 @@ xfs_tosspages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	struct address_space *mapping = ip->i_vnode->i_mapping;
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
 
 	if (mapping->nrpages)
 		truncate_inode_pages(mapping, first);
@@ -44,7 +44,7 @@ xfs_flushinval_pages(
 	xfs_off_t	last,
 	int		fiopt)
 {
-	struct address_space *mapping = ip->i_vnode->i_mapping;
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
 	int		ret = 0;
 
 	if (mapping->nrpages) {
@@ -64,7 +64,7 @@ xfs_flush_pages(
 	uint64_t	flags,
 	int		fiopt)
 {
-	struct address_space *mapping = ip->i_vnode->i_mapping;
+	struct address_space *mapping = VFS_I(ip)->i_mapping;
 	int		ret = 0;
 	int		ret2;
 
diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
index f3267fc..5825ab4 100644
--- a/fs/xfs/linux-2.6/xfs_iops.c
+++ b/fs/xfs/linux-2.6/xfs_iops.c
@@ -62,7 +62,7 @@ void
 xfs_synchronize_atime(
 	xfs_inode_t	*ip)
 {
-	struct inode	*inode = ip->i_vnode;
+	struct inode	*inode = VFS_I(ip);
 
 	if (inode) {
 		ip->i_d.di_atime.t_sec = (__int32_t)inode->i_atime.tv_sec;
@@ -79,7 +79,7 @@ void
 xfs_mark_inode_dirty_sync(
 	xfs_inode_t	*ip)
 {
-	struct inode	*inode = ip->i_vnode;
+	struct inode	*inode = VFS_I(ip);
 
 	if (inode)
 		mark_inode_dirty_sync(inode);
@@ -299,7 +299,7 @@ xfs_vn_mknod(
 	if (unlikely(error))
 		goto out_free_acl;
 
-	inode = ip->i_vnode;
+	inode = VFS_I(ip);
 
 	error = xfs_init_security(inode, dir);
 	if (unlikely(error))
@@ -366,7 +366,7 @@ xfs_vn_lookup(
 		return NULL;
 	}
 
-	return d_splice_alias(cip->i_vnode, dentry);
+	return d_splice_alias(VFS_I(cip), dentry);
 }
 
 STATIC struct dentry *
@@ -399,12 +399,12 @@ xfs_vn_ci_lookup(
 
 	/* if exact match, just splice and exit */
 	if (!ci_name.name)
-		return d_splice_alias(ip->i_vnode, dentry);
+		return d_splice_alias(VFS_I(ip), dentry);
 
 	/* else case-insensitive match... */
 	dname.name = ci_name.name;
 	dname.len = ci_name.len;
-	dentry = d_add_ci(ip->i_vnode, dentry, &dname);
+	dentry = d_add_ci(VFS_I(ip), dentry, &dname);
 	kmem_free(ci_name.name);
 	return dentry;
 }
@@ -478,7 +478,7 @@ xfs_vn_symlink(
 	if (unlikely(error))
 		goto out;
 
-	inode = cip->i_vnode;
+	inode = VFS_I(cip);
 
 	error = xfs_init_security(inode, dir);
 	if (unlikely(error))
diff --git a/fs/xfs/linux-2.6/xfs_iops.h b/fs/xfs/linux-2.6/xfs_iops.h
index d97ba93..fdda404 100644
--- a/fs/xfs/linux-2.6/xfs_iops.h
+++ b/fs/xfs/linux-2.6/xfs_iops.h
@@ -33,10 +33,4 @@ struct xfs_inode;
 extern void xfs_ichgtime(struct xfs_inode *, int);
 extern void xfs_ichgtime_fast(struct xfs_inode *, struct inode *, int);
 
-#define xfs_vtoi(vp) \
-	((struct xfs_inode *)vn_to_inode(vp)->i_private)
-
-#define XFS_I(inode) \
-	((struct xfs_inode *)(inode)->i_private)
-
 #endif /* __XFS_IOPS_H__ */
diff --git a/fs/xfs/linux-2.6/xfs_lrw.c b/fs/xfs/linux-2.6/xfs_lrw.c
index 5e3b575..d00c155 100644
--- a/fs/xfs/linux-2.6/xfs_lrw.c
+++ b/fs/xfs/linux-2.6/xfs_lrw.c
@@ -137,7 +137,7 @@ xfs_iozero(
 	struct address_space	*mapping;
 	int			status;
 
-	mapping = ip->i_vnode->i_mapping;
+	mapping = VFS_I(ip)->i_mapping;
 	do {
 		unsigned offset, bytes;
 		void *fsdata;
diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 6d9c8c7..a507762 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1107,7 +1107,7 @@ void
 xfs_flush_inode(
 	xfs_inode_t	*ip)
 {
-	struct inode	*inode = ip->i_vnode;
+	struct inode	*inode = VFS_I(ip);
 
 	igrab(inode);
 	xfs_syncd_queue_work(ip->i_mount, inode, xfs_flush_inode_work);
@@ -1826,7 +1826,7 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	root = igrab(mp->m_rootip->i_vnode);
+	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
 		goto fail_unmount;
diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index f16ca6c..81047be 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -392,10 +392,11 @@ xfs_iput(xfs_inode_t	*ip,
  * Special iput for brand-new inodes that are still locked
  */
 void
-xfs_iput_new(xfs_inode_t	*ip,
-	     uint		lock_flags)
+xfs_iput_new(
+	xfs_inode_t	*ip,
+	uint		lock_flags)
 {
-	struct inode	*inode = ip->i_vnode;
+	struct inode	*inode = VFS_I(ip);
 
 	xfs_itrace_entry(ip);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index c440b1d..acb87d7 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -255,6 +255,25 @@ typedef struct xfs_inode {
 #define XFS_ISIZE(ip)	(((ip)->i_d.di_mode & S_IFMT) == S_IFREG) ? \
 				(ip)->i_size : (ip)->i_d.di_size;
 
+/* Convert from vfs inode to xfs inode */
+static inline struct xfs_inode *XFS_I(struct inode *inode)
+{
+	return (struct xfs_inode *)inode->i_private;
+}
+
+static inline struct xfs_inode *xfs_vtoi(bhv_vnode_t *vp)
+{
+	return XFS_I((struct inode *)vp);
+}
+
+/* convert from xfs inode to vfs inode */
+static inline struct inode *VFS_I(struct xfs_inode *ip)
+{
+	return (struct inode *)ip->i_vnode;
+}
+#define	XFS_ITOV(ip)		VFS_I(ip)
+#define	XFS_ITOV_NULL(ip)	VFS_I(ip)
+
 /*
  * i_flags helper functions
  */
@@ -431,9 +450,6 @@ xfs_iflags_test_and_clear(xfs_inode_t *ip, unsigned short flags)
 #define	XFS_ITRUNC_DEFINITE	0x1
 #define	XFS_ITRUNC_MAYBE	0x2
 
-#define	XFS_ITOV(ip)		((ip)->i_vnode)
-#define	XFS_ITOV_NULL(ip)	((ip)->i_vnode)
-
 /*
  * For multiple groups support: if S_ISGID bit is set in the parent
  * directory, group of new file is set to that of the parent, and
diff --git a/fs/xfs/xfs_utils.c b/fs/xfs/xfs_utils.c
index 98e5f11..35d4d41 100644
--- a/fs/xfs/xfs_utils.c
+++ b/fs/xfs/xfs_utils.c
@@ -237,7 +237,7 @@ xfs_droplink(
 
 	ASSERT (ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink--;
-	drop_nlink(ip->i_vnode);
+	drop_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	error = 0;
@@ -301,7 +301,7 @@ xfs_bumplink(
 
 	ASSERT(ip->i_d.di_nlink > 0);
 	ip->i_d.di_nlink++;
-	inc_nlink(ip->i_vnode);
+	inc_nlink(VFS_I(ip));
 	if ((ip->i_d.di_version == XFS_DINODE_VERSION_1) &&
 	    (ip->i_d.di_nlink > XFS_MAXLINK_1)) {
 		/*
-- 
1.5.6
