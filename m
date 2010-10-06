Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o96IeOlM110191 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 13:40:24 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6EC3812EDC69
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 11:55:13 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id Pcegb3jFe8ZvOuCy for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 11:55:13 -0700 (PDT)
Received: from hch by canuck.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1P3Yve-0001Al-QW
	for xfs@oss.sgi.com; Wed, 06 Oct 2010 18:41:26 +0000
Message-Id: <20101006184126.663057623@localhost.localdomain>
Date: Wed, 06 Oct 2010 14:41:17 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/7] xfs: remove xfs_cred.h
References: <20101006184111.634126439@localhost.localdomain>
Content-Disposition: inline; filename=xfs-remove-cred.h
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

We're not actually passing around credentials inside XFS for a while now,
so remove all xfs_cred.h with it's cred_t typedef and all instances of it.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_iops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_iops.c	2010-09-29 07:59:30.447011230 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_iops.c	2010-09-29 08:00:00.169265875 +0900
@@ -189,7 +189,7 @@ xfs_vn_mknod(
 	}
 
 	xfs_dentry_to_name(&name, dentry);
-	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip, NULL);
+	error = xfs_create(XFS_I(dir), &name, mode, rdev, &ip);
 	if (unlikely(error))
 		goto out_free_acl;
 
@@ -362,7 +362,7 @@ xfs_vn_symlink(
 		(irix_symlink_mode ? 0777 & ~current_umask() : S_IRWXUGO);
 	xfs_dentry_to_name(&name, dentry);
 
-	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip, NULL);
+	error = xfs_symlink(XFS_I(dir), &name, symname, mode, &cip);
 	if (unlikely(error))
 		goto out;
 
Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-09-29 08:00:19.626003339 +0900
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-09-29 08:04:14.272255746 +0900
@@ -1256,8 +1256,7 @@ xfs_create(
 	struct xfs_name		*name,
 	mode_t			mode,
 	xfs_dev_t		rdev,
-	xfs_inode_t		**ipp,
-	cred_t			*credp)
+	xfs_inode_t		**ipp)
 {
 	int			is_dir = S_ISDIR(mode);
 	struct xfs_mount	*mp = dp->i_mount;
@@ -1363,7 +1362,7 @@ xfs_create(
 	 * entry pointing to them, but a directory also the "." entry
 	 * pointing to itself.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev, credp,
+	error = xfs_dir_ialloc(&tp, dp, mode, is_dir ? 2 : 1, rdev,
 			       prid, resblks > 0, &ip, &committed);
 	if (error) {
 		if (error == ENOSPC)
@@ -1936,8 +1935,7 @@ xfs_symlink(
 	struct xfs_name		*link_name,
 	const char		*target_path,
 	mode_t			mode,
-	xfs_inode_t		**ipp,
-	cred_t			*credp)
+	xfs_inode_t		**ipp)
 {
 	xfs_mount_t		*mp = dp->i_mount;
 	xfs_trans_t		*tp;
@@ -2049,8 +2047,8 @@ xfs_symlink(
 	/*
 	 * Allocate an inode for the symlink.
 	 */
-	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT),
-			       1, 0, credp, prid, resblks > 0, &ip, NULL);
+	error = xfs_dir_ialloc(&tp, dp, S_IFLNK | (mode & ~S_IFMT), 1, 0,
+			       prid, resblks > 0, &ip, NULL);
 	if (error) {
 		if (error == ENOSPC)
 			goto error_return;
Index: xfs/fs/xfs/xfs_vnodeops.h
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.h	2010-09-29 07:59:07.824253303 +0900
+++ xfs/fs/xfs/xfs_vnodeops.h	2010-09-29 08:00:16.412034907 +0900
@@ -2,7 +2,6 @@
 #define _XFS_VNODEOPS_H 1
 
 struct attrlist_cursor_kern;
-struct cred;
 struct file;
 struct iattr;
 struct inode;
@@ -26,7 +25,7 @@ int xfs_inactive(struct xfs_inode *ip);
 int xfs_lookup(struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode **ipp, struct xfs_name *ci_name);
 int xfs_create(struct xfs_inode *dp, struct xfs_name *name, mode_t mode,
-		xfs_dev_t rdev, struct xfs_inode **ipp, cred_t *credp);
+		xfs_dev_t rdev, struct xfs_inode **ipp);
 int xfs_remove(struct xfs_inode *dp, struct xfs_name *name,
 		struct xfs_inode *ip);
 int xfs_link(struct xfs_inode *tdp, struct xfs_inode *sip,
@@ -34,8 +33,7 @@ int xfs_link(struct xfs_inode *tdp, stru
 int xfs_readdir(struct xfs_inode	*dp, void *dirent, size_t bufsize,
 		       xfs_off_t *offset, filldir_t filldir);
 int xfs_symlink(struct xfs_inode *dp, struct xfs_name *link_name,
-		const char *target_path, mode_t mode, struct xfs_inode **ipp,
-		cred_t *credp);
+		const char *target_path, mode_t mode, struct xfs_inode **ipp);
 int xfs_set_dmattrs(struct xfs_inode *ip, u_int evmask, u_int16_t state);
 int xfs_change_file_space(struct xfs_inode *ip, int cmd,
 		xfs_flock64_t *bf, xfs_off_t offset, int attr_flags);
Index: xfs/fs/xfs/quota/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_qm.c	2010-09-29 08:04:23.610259658 +0900
+++ xfs/fs/xfs/quota/xfs_qm.c	2010-09-29 08:05:08.944255958 +0900
@@ -55,8 +55,6 @@ uint		ndquot;
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
 
-static cred_t	xfs_zerocr;
-
 STATIC void	xfs_qm_list_init(xfs_dqlist_t *, char *, int);
 STATIC void	xfs_qm_list_destroy(xfs_dqlist_t *);
 
@@ -1224,8 +1222,8 @@ xfs_qm_qino_alloc(
 		return error;
 	}
 
-	if ((error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
-				   &xfs_zerocr, 0, 1, ip, &committed))) {
+	error = xfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0, 0, 1, ip, &committed);
+	if (error) {
 		xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES |
 				 XFS_TRANS_ABORT);
 		return error;
@@ -2143,7 +2141,7 @@ xfs_qm_write_sb_changes(
 
 
 /*
- * Given an inode, a uid and gid (from cred_t) make sure that we have
+ * Given an inode, a uid, gid and prid make sure that we have
  * allocated relevant dquot(s) on disk, and that we won't exceed inode
  * quotas by creating this file.
  * This also attaches dquot(s) to the given inode after locking it,
Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2010-09-29 08:02:11.314278656 +0900
+++ xfs/fs/xfs/xfs_inode.c	2010-09-29 08:02:23.567255397 +0900
@@ -982,7 +982,6 @@ xfs_ialloc(
 	mode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	cred_t		*cr,
 	xfs_prid_t	prid,
 	int		okalloc,
 	xfs_buf_t	**ialloc_context,
Index: xfs/fs/xfs/xfs_inode.h
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.h	2010-09-29 08:02:24.912003756 +0900
+++ xfs/fs/xfs/xfs_inode.h	2010-09-29 08:05:33.711255678 +0900
@@ -212,7 +212,6 @@ typedef struct xfs_icdinode {
 #ifdef __KERNEL__
 
 struct bhv_desc;
-struct cred;
 struct xfs_buf;
 struct xfs_bmap_free;
 struct xfs_bmbt_irec;
@@ -456,8 +455,8 @@ void		xfs_inode_free(struct xfs_inode *i
  * xfs_inode.c prototypes.
  */
 int		xfs_ialloc(struct xfs_trans *, xfs_inode_t *, mode_t,
-			   xfs_nlink_t, xfs_dev_t, cred_t *, xfs_prid_t,
-			   int, struct xfs_buf **, boolean_t *, xfs_inode_t **);
+			   xfs_nlink_t, xfs_dev_t, xfs_prid_t, int,
+			   struct xfs_buf **, boolean_t *, xfs_inode_t **);
 
 uint		xfs_ip2xflags(struct xfs_inode *);
 uint		xfs_dic2xflags(struct xfs_dinode *);
Index: xfs/fs/xfs/xfs_utils.c
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.c	2010-09-29 08:02:59.399004595 +0900
+++ xfs/fs/xfs/xfs_utils.c	2010-09-29 08:03:20.536068641 +0900
@@ -56,7 +56,6 @@ xfs_dir_ialloc(
 	mode_t		mode,
 	xfs_nlink_t	nlink,
 	xfs_dev_t	rdev,
-	cred_t		*credp,
 	prid_t		prid,		/* project id */
 	int		okalloc,	/* ok to allocate new space */
 	xfs_inode_t	**ipp,		/* pointer to inode; it will be
@@ -93,7 +92,7 @@ xfs_dir_ialloc(
 	 * transaction commit so that no other process can steal
 	 * the inode(s) that we've just allocated.
 	 */
-	code = xfs_ialloc(tp, dp, mode, nlink, rdev, credp, prid, okalloc,
+	code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid, okalloc,
 			  &ialloc_context, &call_again, &ip);
 
 	/*
@@ -197,7 +196,7 @@ xfs_dir_ialloc(
 		 * other allocations in this allocation group,
 		 * this call should always succeed.
 		 */
-		code = xfs_ialloc(tp, dp, mode, nlink, rdev, credp, prid,
+		code = xfs_ialloc(tp, dp, mode, nlink, rdev, prid,
 				  okalloc, &ialloc_context, &call_again, &ip);
 
 		/*
Index: xfs/fs/xfs/xfs_utils.h
===================================================================
--- xfs.orig/fs/xfs/xfs_utils.h	2010-09-29 08:01:25.693253722 +0900
+++ xfs/fs/xfs/xfs_utils.h	2010-09-29 08:03:33.983064450 +0900
@@ -19,8 +19,7 @@
 #define __XFS_UTILS_H__
 
 extern int xfs_dir_ialloc(xfs_trans_t **, xfs_inode_t *, mode_t, xfs_nlink_t,
-				xfs_dev_t, cred_t *, prid_t, int,
-				xfs_inode_t **, int *);
+				xfs_dev_t, prid_t, int, xfs_inode_t **, int *);
 extern int xfs_droplink(xfs_trans_t *, xfs_inode_t *);
 extern int xfs_bumplink(xfs_trans_t *, xfs_inode_t *);
 extern void xfs_bump_ino_vers2(xfs_trans_t *, xfs_inode_t *);
Index: xfs/fs/xfs/linux-2.6/xfs_cred.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_cred.h	2010-09-29 08:05:55.575003966 +0900
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,28 +0,0 @@
-/*
- * Copyright (c) 2000-2002,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef __XFS_CRED_H__
-#define __XFS_CRED_H__
-
-#include <linux/capability.h>
-
-/*
- * Credentials
- */
-typedef const struct cred cred_t;
-
-#endif  /* __XFS_CRED_H__ */
Index: xfs/fs/xfs/linux-2.6/xfs_globals.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_globals.c	2010-09-29 08:05:45.172259868 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_globals.c	2010-09-29 08:05:47.601005434 +0900
@@ -16,7 +16,6 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 #include "xfs.h"
-#include "xfs_cred.h"
 #include "xfs_sysctl.h"
 
 /*
Index: xfs/fs/xfs/linux-2.6/xfs_linux.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_linux.h	2010-09-29 08:05:55.590004665 +0900
+++ xfs/fs/xfs/linux-2.6/xfs_linux.h	2010-09-29 08:06:23.908255677 +0900
@@ -71,6 +71,7 @@
 #include <linux/random.h>
 #include <linux/ctype.h>
 #include <linux/writeback.h>
+#include <linux/capability.h>
 
 #include <asm/page.h>
 #include <asm/div64.h>
@@ -79,7 +80,6 @@
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-#include <xfs_cred.h>
 #include <xfs_vnode.h>
 #include <xfs_stats.h>
 #include <xfs_sysctl.h>
Index: xfs/fs/xfs/xfs_mount.h
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.h	2010-09-29 08:05:23.440254141 +0900
+++ xfs/fs/xfs/xfs_mount.h	2010-09-29 08:05:25.516047826 +0900
@@ -53,7 +53,6 @@ typedef struct xfs_trans_reservations {
 
 #include "xfs_sync.h"
 
-struct cred;
 struct log;
 struct xfs_mount_args;
 struct xfs_inode;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
