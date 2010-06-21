Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XSc0113458 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 01F7B1454F6C
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 7YfI0urB2Er9srbF for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUC-0007dj-HD
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:08 +0000
Message-Id: <20100621083608.395665984@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 12/12] xfs: split xfs_itrace_entry
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-split-itrace
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Replace the xfs_itrace_entry catchall with specific trace points.  For
most simple callers we now use the simple inode class, which used to
be the iget class, but add more details tracing for namespace events,
which now includes the name of the directory entries manipulated.

Remove the xfs_inactive trace point, which is a duplicate of the clear_inode
one, and the xfs_change_file_space trace point, which is immediately
followed by the more specific alloc/free space trace points.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_acl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_acl.c	2010-06-21 09:31:42.750254231 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_acl.c	2010-06-21 09:38:38.800255768 +0200
@@ -225,7 +225,7 @@ xfs_check_acl(struct inode *inode, int m
 	struct posix_acl *acl;
 	int error = -EAGAIN;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_check_acl(ip);
 
 	/*
 	 * If there is no attribute fork no ACL exists on this inode and
Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-21 09:38:38.667254022 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-06-21 09:38:38.802285241 +0200
@@ -1513,7 +1513,7 @@ xfs_vm_bmap(
 	struct inode		*inode = (struct inode *)mapping->host;
 	struct xfs_inode	*ip = XFS_I(inode);
 
-	xfs_itrace_entry(XFS_I(inode));
+	trace_xfs_vm_bmap(XFS_I(inode));
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	xfs_flush_pages(ip, (xfs_off_t)0, -1, 0, FI_REMAPF);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-06-21 09:31:42.765253742 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-06-21 09:38:38.807317438 +0200
@@ -100,7 +100,7 @@ xfs_file_fsync(
 	int			error = 0;
 	int			log_flushed = 0;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_file_fsync(ip);
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount))
 		return -XFS_ERROR(EIO);
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2010-06-21 09:31:42.775254720 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl.c	2010-06-21 09:38:38.810292505 +0200
@@ -899,7 +899,7 @@ xfs_ioctl_setattr(
 	struct xfs_dquot	*olddquot = NULL;
 	int			code;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_ioctl_setattr(ip);
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return XFS_ERROR(EROFS);
@@ -1282,7 +1282,7 @@ xfs_file_ioctl(
 	if (filp->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_file_ioctl(ip);
 
 	switch (cmd) {
 	case XFS_IOC_ALLOCSP:
Index: xfs/fs/xfs/linux-2.6/xfs_ioctl32.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-06-21 09:31:47.810003149 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_ioctl32.c	2010-06-21 09:38:38.815255279 +0200
@@ -540,7 +540,7 @@ xfs_file_compat_ioctl(
 	if (filp->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_file_compat_ioctl(ip);
 
 	switch (cmd) {
 	/* No size or alignment issues on any arch */
Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-06-21 09:31:42.790254790 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-06-21 09:38:38.820255558 +0200
@@ -488,7 +488,7 @@ xfs_vn_getattr(
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_getattr(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-06-21 09:38:38.683275324 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-06-21 09:38:38.827255768 +0200
@@ -907,7 +907,7 @@ xfs_fs_destroy_inode(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 
-	xfs_itrace_entry(ip);
+	trace_xfs_destroy_inode(ip);
 
 	XFS_STATS_INC(vn_reclaim);
 
@@ -1040,7 +1040,7 @@ xfs_fs_write_inode(
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error = EAGAIN;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_write_inode(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1107,7 +1107,8 @@ xfs_fs_clear_inode(
 {
 	xfs_inode_t		*ip = XFS_I(inode);
 
-	xfs_itrace_entry(ip);
+	trace_xfs_clear_inode(ip);
+
 	XFS_STATS_INC(vn_rele);
 	XFS_STATS_INC(vn_remove);
 	XFS_STATS_DEC(vn_active);
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-06-21 09:38:38.711253323 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-06-21 09:38:38.834282797 +0200
@@ -536,7 +536,7 @@ DEFINE_LOCK_EVENT(xfs_ilock_nowait);
 DEFINE_LOCK_EVENT(xfs_ilock_demote);
 DEFINE_LOCK_EVENT(xfs_iunlock);
 
-DECLARE_EVENT_CLASS(xfs_iget_class,
+DECLARE_EVENT_CLASS(xfs_inode_class,
 	TP_PROTO(struct xfs_inode *ip),
 	TP_ARGS(ip),
 	TP_STRUCT__entry(
@@ -552,17 +552,36 @@ DECLARE_EVENT_CLASS(xfs_iget_class,
 		  __entry->ino)
 )
 
-#define DEFINE_IGET_EVENT(name) \
-DEFINE_EVENT(xfs_iget_class, name, \
+#define DEFINE_INODE_EVENT(name) \
+DEFINE_EVENT(xfs_inode_class, name, \
 	TP_PROTO(struct xfs_inode *ip), \
 	TP_ARGS(ip))
-DEFINE_IGET_EVENT(xfs_iget_skip);
-DEFINE_IGET_EVENT(xfs_iget_reclaim);
-DEFINE_IGET_EVENT(xfs_iget_reclaim_fail);
-DEFINE_IGET_EVENT(xfs_iget_hit);
-DEFINE_IGET_EVENT(xfs_iget_miss);
+DEFINE_INODE_EVENT(xfs_iget_skip);
+DEFINE_INODE_EVENT(xfs_iget_reclaim);
+DEFINE_INODE_EVENT(xfs_iget_reclaim_fail);
+DEFINE_INODE_EVENT(xfs_iget_hit);
+DEFINE_INODE_EVENT(xfs_iget_miss);
+
+DEFINE_INODE_EVENT(xfs_getattr);
+DEFINE_INODE_EVENT(xfs_setattr);
+DEFINE_INODE_EVENT(xfs_readlink);
+DEFINE_INODE_EVENT(xfs_alloc_file_space);
+DEFINE_INODE_EVENT(xfs_free_file_space);
+DEFINE_INODE_EVENT(xfs_readdir);
+DEFINE_INODE_EVENT(xfs_check_acl);
+DEFINE_INODE_EVENT(xfs_vm_bmap);
+DEFINE_INODE_EVENT(xfs_file_ioctl);
+DEFINE_INODE_EVENT(xfs_file_compat_ioctl);
+DEFINE_INODE_EVENT(xfs_ioctl_setattr);
+DEFINE_INODE_EVENT(xfs_file_fsync);
+DEFINE_INODE_EVENT(xfs_destroy_inode);
+DEFINE_INODE_EVENT(xfs_write_inode);
+DEFINE_INODE_EVENT(xfs_clear_inode);
 
-DECLARE_EVENT_CLASS(xfs_inode_class,
+DEFINE_INODE_EVENT(xfs_dquot_dqalloc);
+DEFINE_INODE_EVENT(xfs_dquot_dqdetach);
+
+DECLARE_EVENT_CLASS(xfs_iref_class,
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip),
 	TP_ARGS(ip, caller_ip),
 	TP_STRUCT__entry(
@@ -587,20 +606,71 @@ DECLARE_EVENT_CLASS(xfs_inode_class,
 		  (char *)__entry->caller_ip)
 )
 
-#define DEFINE_INODE_EVENT(name) \
-DEFINE_EVENT(xfs_inode_class, name, \
+#define DEFINE_IREF_EVENT(name) \
+DEFINE_EVENT(xfs_iref_class, name, \
 	TP_PROTO(struct xfs_inode *ip, unsigned long caller_ip), \
 	TP_ARGS(ip, caller_ip))
-DEFINE_INODE_EVENT(xfs_ihold);
-DEFINE_INODE_EVENT(xfs_irele);
-DEFINE_INODE_EVENT(xfs_inode_pin);
-DEFINE_INODE_EVENT(xfs_inode_unpin);
-DEFINE_INODE_EVENT(xfs_inode_unpin_nowait);
-
-/* the old xfs_itrace_entry tracer - to be replaced by s.th. in the VFS */
-DEFINE_INODE_EVENT(xfs_inode);
-#define xfs_itrace_entry(ip)    \
-	trace_xfs_inode(ip, _THIS_IP_)
+DEFINE_IREF_EVENT(xfs_ihold);
+DEFINE_IREF_EVENT(xfs_irele);
+DEFINE_IREF_EVENT(xfs_inode_pin);
+DEFINE_IREF_EVENT(xfs_inode_unpin);
+DEFINE_IREF_EVENT(xfs_inode_unpin_nowait);
+
+DECLARE_EVENT_CLASS(xfs_namespace_class,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name),
+	TP_ARGS(dp, name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dp_ino)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(dp)->i_sb->s_dev;
+		__entry->dp_ino = dp->i_ino;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d dp ino 0x%llx name %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dp_ino,
+		  __get_str(name))
+)
+
+#define DEFINE_NAMESPACE_EVENT(name) \
+DEFINE_EVENT(xfs_namespace_class, name, \
+	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name), \
+	TP_ARGS(dp, name))
+DEFINE_NAMESPACE_EVENT(xfs_remove);
+DEFINE_NAMESPACE_EVENT(xfs_link);
+DEFINE_NAMESPACE_EVENT(xfs_lookup);
+DEFINE_NAMESPACE_EVENT(xfs_create);
+DEFINE_NAMESPACE_EVENT(xfs_symlink);
+
+TRACE_EVENT(xfs_rename,
+	TP_PROTO(struct xfs_inode *src_dp, struct xfs_inode *target_dp,
+		 struct xfs_name *src_name, struct xfs_name *target_name),
+	TP_ARGS(src_dp, target_dp, src_name, target_name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, src_dp_ino)
+		__field(xfs_ino_t, target_dp_ino)
+		__dynamic_array(char, src_name, src_name->len)
+		__dynamic_array(char, target_name, target_name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = VFS_I(src_dp)->i_sb->s_dev;
+		__entry->src_dp_ino = src_dp->i_ino;
+		__entry->target_dp_ino = target_dp->i_ino;
+		memcpy(__get_str(src_name), src_name->name, src_name->len);
+		memcpy(__get_str(target_name), target_name->name, target_name->len);
+	),
+	TP_printk("dev %d:%d src dp ino 0x%llx target dp ino 0x%llx"
+		  " src name %s target name %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->src_dp_ino,
+		  __entry->target_dp_ino,
+		  __get_str(src_name),
+		  __get_str(target_name))
+)
 
 DECLARE_EVENT_CLASS(xfs_dquot_class,
 	TP_PROTO(struct xfs_dquot *dqp),
@@ -680,9 +750,6 @@ DEFINE_DQUOT_EVENT(xfs_dqrele);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
 DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
-/* not really iget events, but we re-use the format */
-DEFINE_IGET_EVENT(xfs_dquot_dqalloc);
-DEFINE_IGET_EVENT(xfs_dquot_dqdetach);
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,
 	TP_PROTO(struct log *log, struct xlog_ticket *tic),
Index: xfs/fs/xfs/xfs_dir2.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dir2.c	2010-06-21 09:31:42.811254930 +0200
+++ xfs/fs/xfs/xfs_dir2.c	2010-06-21 09:38:38.840032692 +0200
@@ -380,7 +380,7 @@ xfs_readdir(
 	int		rval;		/* return value */
 	int		v;		/* type-checking value */
 
-	xfs_itrace_entry(dp);
+	trace_xfs_readdir(dp);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-06-21 09:31:47.890255838 +0200
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-06-21 09:38:38.848255488 +0200
@@ -68,7 +68,7 @@ xfs_setattr(
 	struct xfs_dquot	*udqp, *gdqp, *olddquot1, *olddquot2;
 	int			need_iolock = 1;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_setattr(ip);
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return XFS_ERROR(EROFS);
@@ -533,7 +533,7 @@ xfs_readlink(
 	int		pathlen;
 	int		error = 0;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_readlink(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1005,8 +1005,6 @@ xfs_inactive(
 	int		error;
 	int		truncate;
 
-	xfs_itrace_entry(ip);
-
 	/*
 	 * If the inode is already free, then there can be nothing
 	 * to clean up here.
@@ -1221,7 +1219,7 @@ xfs_lookup(
 	int			error;
 	uint			lock_mode;
 
-	xfs_itrace_entry(dp);
+	trace_xfs_lookup(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
 		return XFS_ERROR(EIO);
@@ -1273,7 +1271,7 @@ xfs_create(
 	uint			log_res;
 	uint			log_count;
 
-	xfs_itrace_entry(dp);
+	trace_xfs_create(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1670,8 +1668,7 @@ xfs_remove(
 	uint			resblks;
 	uint			log_count;
 
-	xfs_itrace_entry(dp);
-	xfs_itrace_entry(ip);
+	trace_xfs_remove(dp, name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -1832,8 +1829,7 @@ xfs_link(
 	int			committed;
 	int			resblks;
 
-	xfs_itrace_entry(tdp);
-	xfs_itrace_entry(sip);
+	trace_xfs_link(tdp, target_name);
 
 	ASSERT(!S_ISDIR(sip->i_d.di_mode));
 
@@ -1966,7 +1962,7 @@ xfs_symlink(
 	ip = NULL;
 	tp = NULL;
 
-	xfs_itrace_entry(dp);
+	trace_xfs_symlink(dp, link_name);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2256,7 +2252,7 @@ xfs_alloc_file_space(
 	int			committed;
 	int			error;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_alloc_file_space(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return XFS_ERROR(EIO);
@@ -2517,7 +2513,7 @@ xfs_free_file_space(
 
 	mp = ip->i_mount;
 
-	xfs_itrace_entry(ip);
+	trace_xfs_free_file_space(ip);
 
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
@@ -2707,8 +2703,6 @@ xfs_change_file_space(
 	xfs_trans_t	*tp;
 	struct iattr	iattr;
 
-	xfs_itrace_entry(ip);
-
 	if (!S_ISREG(ip->i_d.di_mode))
 		return XFS_ERROR(EINVAL);
 
Index: xfs/fs/xfs/xfs_rename.c
===================================================================
--- xfs.orig/fs/xfs/xfs_rename.c	2010-06-21 09:31:42.833254441 +0200
+++ xfs/fs/xfs/xfs_rename.c	2010-06-21 09:38:38.853285101 +0200
@@ -113,8 +113,7 @@ xfs_rename(
 	int		spaceres;
 	int		num_inodes;
 
-	xfs_itrace_entry(src_dp);
-	xfs_itrace_entry(target_dp);
+	trace_xfs_rename(src_dp, target_dp, src_name, target_name);
 
 	new_parent = (src_dp != target_dp);
 	src_is_directory = ((src_ip->i_d.di_mode & S_IFMT) == S_IFDIR);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
