Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 25 Jul 2006 17:16:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k6Q0GFDW008882
	for <xfs@oss.sgi.com>; Tue, 25 Jul 2006 17:16:29 -0700
Received: from wobbly.melbourne.sgi.com (wobbly.melbourne.sgi.com [134.14.55.135]) by larry.melbourne.sgi.com (950413.SGI.8.6.12/950213.SGI.AUTOCF) via ESMTP id KAA14704 for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 10:15:40 +1000
Received: from wobbly.melbourne.sgi.com (localhost [127.0.0.1])
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6Q0Fcgw2134166
	for <xfs@oss.sgi.com>; Wed, 26 Jul 2006 10:15:39 +1000 (EST)
Received: (from nathans@localhost)
	by wobbly.melbourne.sgi.com (SGI-8.12.5/8.12.5/Submit) id k6Q0FbS92140290
	for xfs@oss.sgi.com; Wed, 26 Jul 2006 10:15:37 +1000 (EST)
Date: Wed, 26 Jul 2006 10:15:37 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: block bogus bulkstat messages, last stage
Message-ID: <20060726101537.H2118045@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

Earlier changes removed most of the bogus verbosity from fsstress
runs with debug kernels, when bulkstat is asked to report on non-
inode data in its stat'ing.  This resolves the one remaining case
which is the bulkstat_one vs a xfs_dilocate warning, by passing a
flag down into dilocate indicating we may be looking up garbage,
and not to spam the console in that situation.

cheers.

-- 
Nathan


Index: xfs-linux/xfs_ialloc.c
===================================================================
--- xfs-linux.orig/xfs_ialloc.c	2006-06-15 11:40:12.439501000 +1000
+++ xfs-linux/xfs_ialloc.c	2006-06-15 11:42:31.948219750 +1000
@@ -1196,6 +1196,7 @@ xfs_dilocate(
 					"(0x%llx)",
 					ino, XFS_AGINO_TO_INO(mp, agno, agino));
 		}
+		xfs_stack_trace();
 #endif /* DEBUG */
 		return XFS_ERROR(EINVAL);
 	}
Index: xfs-linux/xfs_inode.h
===================================================================
--- xfs-linux.orig/xfs_inode.h	2006-06-15 11:39:27.000000000 +1000
+++ xfs-linux/xfs_inode.h	2006-06-15 11:42:31.956220250 +1000
@@ -389,11 +389,14 @@ typedef struct xfs_inode {
 	(((vfsp)->vfs_flag & VFS_GRPID) || ((pip)->i_d.di_mode & S_ISGID))
 
 /*
- * xfs_iget.c prototypes.
+ * Flags for xfs_iget()
  */
+#define XFS_IGET_CREATE		0x1
+#define XFS_IGET_BULKSTAT	0x2
 
-#define IGET_CREATE	1
-
+/*
+ * xfs_iget.c prototypes.
+ */
 void		xfs_ihash_init(struct xfs_mount *);
 void		xfs_ihash_free(struct xfs_mount *);
 void		xfs_chash_init(struct xfs_mount *);
@@ -425,7 +428,7 @@ int		xfs_itobp(struct xfs_mount *, struc
 			  xfs_inode_t *, xfs_dinode_t **, struct xfs_buf **,
 			  xfs_daddr_t, uint);
 int		xfs_iread(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
-			  xfs_inode_t **, xfs_daddr_t);
+			  xfs_inode_t **, xfs_daddr_t, uint);
 int		xfs_iread_extents(struct xfs_trans *, xfs_inode_t *, int);
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
 			   xfs_nlink_t, xfs_dev_t, struct cred *, xfs_prid_t,
Index: xfs-linux/xfs_itable.c
===================================================================
--- xfs-linux.orig/xfs_itable.c	2006-06-15 11:40:53.982097250 +1000
+++ xfs-linux/xfs_itable.c	2006-06-15 11:42:31.972221250 +1000
@@ -52,7 +52,8 @@ xfs_bulkstat_one_iget(
 	bhv_vnode_t	*vp;
 	int		error;
 
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, bno);
+	error = xfs_iget(mp, NULL, ino,
+			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error) {
 		*stat = BULKSTAT_RV_NOTHING;
 		return error;
Index: xfs-linux/xfs_inode.c
===================================================================
--- xfs-linux.orig/xfs_inode.c	2006-06-15 11:39:27.000000000 +1000
+++ xfs-linux/xfs_inode.c	2006-06-15 11:42:32.004223250 +1000
@@ -851,7 +851,8 @@ xfs_iread(
 	xfs_trans_t	*tp,
 	xfs_ino_t	ino,
 	xfs_inode_t	**ipp,
-	xfs_daddr_t	bno)
+	xfs_daddr_t	bno,
+	uint		imap_flags)
 {
 	xfs_buf_t	*bp;
 	xfs_dinode_t	*dip;
@@ -871,7 +872,7 @@ xfs_iread(
 	 * return NULL as well.  Set i_blkno to 0 so that xfs_itobp() will
 	 * know that this is a new incore inode.
 	 */
-	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, 0);
+	error = xfs_itobp(mp, tp, ip, &dip, &bp, bno, imap_flags);
 	if (error) {
 		kmem_zone_free(xfs_inode_zone, ip);
 		return error;
@@ -1110,7 +1111,7 @@ xfs_ialloc(
 	 * to prevent others from looking at until we're done.
 	 */
 	error = xfs_trans_iget(tp->t_mountp, tp, ino,
-			IGET_CREATE, XFS_ILOCK_EXCL, &ip);
+				XFS_IGET_CREATE, XFS_ILOCK_EXCL, &ip);
 	if (error != 0) {
 		return error;
 	}
Index: xfs-linux/xfs_iget.c
===================================================================
--- xfs-linux.orig/xfs_iget.c	2006-06-15 11:40:48.181734750 +1000
+++ xfs-linux/xfs_iget.c	2006-06-15 11:42:32.112230000 +1000
@@ -290,11 +290,11 @@ again:
 
 finish_inode:
 			if (ip->i_d.di_mode == 0) {
-				if (!(flags & IGET_CREATE))
+				if (!(flags & XFS_IGET_CREATE))
 					return ENOENT;
 				xfs_iocore_inode_reinit(ip);
 			}
-	
+
 			if (lock_flags != 0)
 				xfs_ilock(ip, lock_flags);
 
@@ -320,21 +320,20 @@ finish_inode:
 	 * Read the disk inode attributes into a new inode structure and get
 	 * a new vnode for it. This should also initialize i_ino and i_mount.
 	 */
-	error = xfs_iread(mp, tp, ino, &ip, bno);
-	if (error) {
+	error = xfs_iread(mp, tp, ino, &ip, bno,
+			  (flags & XFS_IGET_BULKSTAT) ? XFS_IMAP_BULKSTAT : 0);
+	if (error)
 		return error;
-	}
 
 	vn_trace_exit(vp, "xfs_iget.alloc", (inst_t *)__return_address);
 
 	xfs_inode_lock_init(ip, vp);
 	xfs_iocore_inode_init(ip);
 
-	if (lock_flags != 0) {
+	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
-	}
-		
-	if ((ip->i_d.di_mode == 0) && !(flags & IGET_CREATE)) {
+
+	if ((ip->i_d.di_mode == 0) && !(flags & XFS_IGET_CREATE)) {
 		xfs_idestroy(ip);
 		return ENOENT;
 	}
Index: xfs-linux/dmapi/xfs_dm.c
===================================================================
--- xfs-linux.orig/dmapi/xfs_dm.c	2006-06-15 11:40:53.950095250 +1000
+++ xfs-linux/dmapi/xfs_dm.c	2006-06-15 11:42:32.136231500 +1000
@@ -549,7 +549,8 @@ xfs_dm_bulkall_iget_one(
 	int		value_len = *value_lenp;
 	int		error;
 
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, bno);
+	error = xfs_iget(mp, NULL, ino,
+			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error)
 		return error;
 	if (ip->i_d.di_mode == 0) {
@@ -815,7 +816,8 @@ xfs_dm_bulkattr_iget_one(
 	dm_handle_t	handle;
 	int		error;
 
-	error = xfs_iget(mp, NULL, ino, 0, XFS_ILOCK_SHARED, &ip, bno);
+	error = xfs_iget(mp, NULL, ino,
+			 XFS_IGET_BULKSTAT, XFS_ILOCK_SHARED, &ip, bno);
 	if (error)
 		return error;
 	if (ip->i_d.di_mode == 0) {
