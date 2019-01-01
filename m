Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:54814 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728234AbfAACUD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:20:03 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012J0Rk171077
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:59 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2130.oracle.com with ESMTP id 2pnxedxas9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:19:59 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012Jw4b006876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:58 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012JwTL001636
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:19:58 GMT
Subject: [PATCH 09/22] xfs: hoist inode allocation function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:19:56 -0800
Message-ID: <154630919670.18437.18140552762310785640.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the inode allocation function into libxfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |  253 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    3 
 fs/xfs/xfs_inode.c             |  250 ----------------------------------------
 3 files changed, 256 insertions(+), 250 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 6cc749b67d48..6c548015a882 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2000-2006 Silicon Graphics, Inc.
  * All Rights Reserved.
  */
+#include <linux/iversion.h>
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -13,6 +14,8 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_inode_util.h"
+#include "xfs_trans.h"
+#include "xfs_ialloc.h"
 
 /*
  * helper function to extract extent size hint from inode
@@ -160,3 +163,253 @@ xfs_dic2xflags(
 
 	return flags;
 }
+
+/*
+ * Initialize a newly allocated inode with the given arguments.  Heritable
+ * inode properties will be copied from the parent if one is supplied and the
+ * appropriate inode flags are set on the parent.
+ */
+STATIC void
+xfs_inode_init(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_inode		*ip)
+{
+	struct xfs_inode		*pip = args->pip;
+	struct inode			*inode = VFS_I(ip);
+	uint				flags;
+
+	/*
+	 * We always convert v1 inodes to v2 now - we only support filesystems
+	 * with >= v2 inode capability, so there is no reason for ever leaving
+	 * an inode in v1 format.
+	 */
+	if (ip->i_d.di_version == 1)
+		ip->i_d.di_version = 2;
+
+	inode->i_mode = args->mode;
+	set_nlink(inode, args->nlink);
+	ip->i_d.di_uid = args->uid;
+	ip->i_d.di_gid = args->gid;
+	inode->i_rdev = args->rdev;
+	xfs_set_projid(&ip->i_d, args->prid);
+
+	if (pip && XFS_INHERIT_GID(pip)) {
+		ip->i_d.di_gid = pip->i_d.di_gid;
+		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
+			inode->i_mode |= S_ISGID;
+	}
+
+	/*
+	 * If the group ID of the new file does not match the effective group
+	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
+	 * (and only if the irix_sgid_inherit compatibility variable is set).
+	 */
+	if ((irix_sgid_inherit) &&
+	    (inode->i_mode & S_ISGID) &&
+	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+		inode->i_mode &= ~S_ISGID;
+
+	ip->i_d.di_size = 0;
+	ip->i_d.di_nextents = 0;
+	ASSERT(ip->i_d.di_nblocks == 0);
+
+	inode->i_mtime.tv_sec = 0;
+	inode->i_mtime.tv_nsec = 0;
+	inode->i_atime.tv_sec = 0;
+	inode->i_atime.tv_nsec = 0;
+	inode->i_ctime.tv_sec = 0;
+	inode->i_ctime.tv_nsec = 0;
+
+	ip->i_d.di_extsize = 0;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_dmstate = 0;
+	ip->i_d.di_flags = 0;
+
+	if (ip->i_d.di_version == 3) {
+		inode_set_iversion(inode, 1);
+		ip->i_d.di_flags2 = 0;
+		ip->i_d.di_cowextsize = 0;
+		ip->i_d.di_crtime.t_sec = 0;
+		ip->i_d.di_crtime.t_nsec = 0;
+	}
+
+	args->ops->platform_init(tp, args, ip);
+
+	flags = XFS_ILOG_CORE;
+	switch (args->mode & S_IFMT) {
+	case S_IFIFO:
+	case S_IFCHR:
+	case S_IFBLK:
+	case S_IFSOCK:
+		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
+		ip->i_df.if_flags = 0;
+		flags |= XFS_ILOG_DEV;
+		break;
+	case S_IFREG:
+	case S_IFDIR:
+		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+			uint		di_flags = 0;
+
+			if (S_ISDIR(args->mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_RTINHERIT;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+					di_flags |= XFS_DIFLAG_PROJINHERIT;
+			} else if (S_ISREG(args->mode)) {
+				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+					di_flags |= XFS_DIFLAG_REALTIME;
+				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+					di_flags |= XFS_DIFLAG_EXTSIZE;
+					ip->i_d.di_extsize = pip->i_d.di_extsize;
+				}
+			}
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+			    xfs_inherit_noatime)
+				di_flags |= XFS_DIFLAG_NOATIME;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+			    xfs_inherit_nodump)
+				di_flags |= XFS_DIFLAG_NODUMP;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+			    xfs_inherit_sync)
+				di_flags |= XFS_DIFLAG_SYNC;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+			    xfs_inherit_nosymlinks)
+				di_flags |= XFS_DIFLAG_NOSYMLINKS;
+			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+			    xfs_inherit_nodefrag)
+				di_flags |= XFS_DIFLAG_NODEFRAG;
+			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+				di_flags |= XFS_DIFLAG_FILESTREAM;
+
+			ip->i_d.di_flags |= di_flags;
+		}
+		if (pip &&
+		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
+		    pip->i_d.di_version == 3 &&
+		    ip->i_d.di_version == 3) {
+			uint64_t	di_flags2 = 0;
+
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+			}
+			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+				di_flags2 |= XFS_DIFLAG2_DAX;
+
+			ip->i_d.di_flags2 |= di_flags2;
+		}
+		/* FALLTHROUGH */
+	case S_IFLNK:
+		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_df.if_flags = XFS_IFEXTENTS;
+		ip->i_df.if_bytes = 0;
+		ip->i_df.if_u1.if_root = NULL;
+		break;
+	default:
+		ASSERT(0);
+	}
+	/*
+	 * Attribute fork settings for new inode.
+	 */
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_anextents = 0;
+
+	/*
+	 * Log the new values stuffed into the inode.
+	 */
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_log_inode(tp, ip, flags);
+
+	/* now that we have an i_mode we can setup the inode structure */
+	args->ops->setup(ip);
+}
+
+/*
+ * Allocate an inode on disk and return a copy of its in-core version.
+ * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
+ * appropriately within the inode.  The uid and gid for the inode are
+ * set according to the contents of the given cred structure.
+ *
+ * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
+ * has a free inode available, call xfs_iget() to obtain the in-core
+ * version of the allocated inode.  Finally, fill in the inode and
+ * log its initial contents.  In this case, ialloc_context would be
+ * set to NULL.
+ *
+ * If xfs_dialloc() does not have an available inode, it will replenish
+ * its supply by doing an allocation. Since we can only do one
+ * allocation within a transaction without deadlocks, we must commit
+ * the current transaction before returning the inode itself.
+ * In this case, therefore, we will set ialloc_context and return.
+ * The caller should then commit the current transaction, start a new
+ * transaction, and call xfs_ialloc() again to actually get the inode.
+ *
+ * To ensure that some other process does not grab the inode that
+ * was allocated during the first call to xfs_ialloc(), this routine
+ * also returns the [locked] bp pointing to the head of the freelist
+ * as ialloc_context.  The caller should hold this buffer across
+ * the commit and pass it back into this routine on the second call.
+ *
+ * If we are allocating quota inodes, we do not have a parent inode
+ * to attach to or associate with (i.e. pip == NULL) because they
+ * are not linked into the directory structure - they are attached
+ * directly to the superblock - and so have no parent.
+ */
+int
+xfs_ialloc(
+	struct xfs_trans		*tp,
+	const struct xfs_ialloc_args	*args,
+	struct xfs_buf			**ialloc_context,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_inode		*pip = args->pip;
+	struct xfs_inode		*ip;
+	xfs_ino_t			ino;
+	int				error;
+
+	/*
+	 * Call the space management code to pick
+	 * the on-disk inode to be allocated.
+	 */
+	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
+			    ialloc_context, &ino);
+	if (error)
+		return error;
+	if (*ialloc_context || ino == NULLFSINO) {
+		*ipp = NULL;
+		return 0;
+	}
+	ASSERT(*ialloc_context == NULL);
+
+	/*
+	 * Protect against obviously corrupt allocation btree records. Later
+	 * xfs_iget checks will catch re-allocation of other active in-memory
+	 * and on-disk inodes. If we don't catch reallocating the parent inode
+	 * here we will deadlock in xfs_iget() so we have to do these checks
+	 * first.
+	 */
+	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
+		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Get the in-core inode with the lock held exclusively.
+	 * This is because we're setting fields here we need
+	 * to prevent others from looking at until we're done.
+	 */
+	error = args->ops->iget(mp, tp, ino, &ip);
+	if (error)
+		return error;
+	ASSERT(ip != NULL);
+
+	xfs_inode_init(tp, args, ip);
+	*ipp = ip;
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 6318234003e1..5a1d98d1546d 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -87,4 +87,7 @@ struct xfs_ialloc_ops {
 /* The libxfs client must provide this symbol. */
 extern const struct xfs_ialloc_ops xfs_default_ialloc_ops;
 
+int xfs_ialloc(struct xfs_trans *tp, const struct xfs_ialloc_args *args,
+	       struct xfs_buf **ialloc_context, struct xfs_inode **ipp);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c053e1d422d5..28d794300cdd 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -653,256 +653,6 @@ const struct xfs_ialloc_ops xfs_default_ialloc_ops = {
 	.setup		= xfs_setup_inode,
 };
 
-/*
- * Initialize a newly allocated inode with the given arguments.  Heritable
- * inode properties will be copied from the parent if one is supplied and the
- * appropriate inode flags are set on the parent.
- */
-STATIC void
-xfs_inode_init(
-	struct xfs_trans		*tp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_inode		*ip)
-{
-	struct xfs_inode		*pip = args->pip;
-	struct inode			*inode = VFS_I(ip);
-	uint				flags;
-
-	/*
-	 * We always convert v1 inodes to v2 now - we only support filesystems
-	 * with >= v2 inode capability, so there is no reason for ever leaving
-	 * an inode in v1 format.
-	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
-
-	inode->i_mode = args->mode;
-	set_nlink(inode, args->nlink);
-	ip->i_d.di_uid = args->uid;
-	ip->i_d.di_gid = args->gid;
-	inode->i_rdev = args->rdev;
-	xfs_set_projid(&ip->i_d, args->prid);
-
-	if (pip && XFS_INHERIT_GID(pip)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
-		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(args->mode))
-			inode->i_mode |= S_ISGID;
-	}
-
-	/*
-	 * If the group ID of the new file does not match the effective group
-	 * ID or one of the supplementary group IDs, the S_ISGID bit is cleared
-	 * (and only if the irix_sgid_inherit compatibility variable is set).
-	 */
-	if ((irix_sgid_inherit) &&
-	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
-		inode->i_mode &= ~S_ISGID;
-
-	ip->i_d.di_size = 0;
-	ip->i_d.di_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
-
-	inode->i_mtime.tv_sec = 0;
-	inode->i_mtime.tv_nsec = 0;
-	inode->i_atime.tv_sec = 0;
-	inode->i_atime.tv_nsec = 0;
-	inode->i_ctime.tv_sec = 0;
-	inode->i_ctime.tv_nsec = 0;
-
-	ip->i_d.di_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = 0;
-
-	if (ip->i_d.di_version == 3) {
-		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime.t_sec = 0;
-		ip->i_d.di_crtime.t_nsec = 0;
-	}
-
-	args->ops->platform_init(tp, args, ip);
-
-	flags = XFS_ILOG_CORE;
-	switch (args->mode & S_IFMT) {
-	case S_IFIFO:
-	case S_IFCHR:
-	case S_IFBLK:
-	case S_IFSOCK:
-		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
-		ip->i_df.if_flags = 0;
-		flags |= XFS_ILOG_DEV;
-		break;
-	case S_IFREG:
-	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
-			uint		di_flags = 0;
-
-			if (S_ISDIR(args->mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-					di_flags |= XFS_DIFLAG_PROJINHERIT;
-			} else if (S_ISREG(args->mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
-					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
-					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
-				}
-			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
-			    xfs_inherit_noatime)
-				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
-			    xfs_inherit_nodump)
-				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
-			    xfs_inherit_sync)
-				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
-			    xfs_inherit_nosymlinks)
-				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
-			    xfs_inherit_nodefrag)
-				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
-				di_flags |= XFS_DIFLAG_FILESTREAM;
-
-			ip->i_d.di_flags |= di_flags;
-		}
-		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
-			uint64_t	di_flags2 = 0;
-
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
-				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
-			}
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
-				di_flags2 |= XFS_DIFLAG2_DAX;
-
-			ip->i_d.di_flags2 |= di_flags2;
-		}
-		/* FALLTHROUGH */
-	case S_IFLNK:
-		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-		ip->i_df.if_flags = XFS_IFEXTENTS;
-		ip->i_df.if_bytes = 0;
-		ip->i_df.if_u1.if_root = NULL;
-		break;
-	default:
-		ASSERT(0);
-	}
-	/*
-	 * Attribute fork settings for new inode.
-	 */
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_anextents = 0;
-
-	/*
-	 * Log the new values stuffed into the inode.
-	 */
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
-	xfs_trans_log_inode(tp, ip, flags);
-
-	/* now that we have an i_mode we can setup the inode structure */
-	args->ops->setup(ip);
-}
-
-/*
- * Allocate an inode on disk and return a copy of its in-core version.
- * The in-core inode is locked exclusively.  Set mode, nlink, and rdev
- * appropriately within the inode.  The uid and gid for the inode are
- * set according to the contents of the given cred structure.
- *
- * Use xfs_dialloc() to allocate the on-disk inode. If xfs_dialloc()
- * has a free inode available, call xfs_iget() to obtain the in-core
- * version of the allocated inode.  Finally, fill in the inode and
- * log its initial contents.  In this case, ialloc_context would be
- * set to NULL.
- *
- * If xfs_dialloc() does not have an available inode, it will replenish
- * its supply by doing an allocation. Since we can only do one
- * allocation within a transaction without deadlocks, we must commit
- * the current transaction before returning the inode itself.
- * In this case, therefore, we will set ialloc_context and return.
- * The caller should then commit the current transaction, start a new
- * transaction, and call xfs_ialloc() again to actually get the inode.
- *
- * To ensure that some other process does not grab the inode that
- * was allocated during the first call to xfs_ialloc(), this routine
- * also returns the [locked] bp pointing to the head of the freelist
- * as ialloc_context.  The caller should hold this buffer across
- * the commit and pass it back into this routine on the second call.
- *
- * If we are allocating quota inodes, we do not have a parent inode
- * to attach to or associate with (i.e. pip == NULL) because they
- * are not linked into the directory structure - they are attached
- * directly to the superblock - and so have no parent.
- */
-static int
-xfs_ialloc(
-	struct xfs_trans		*tp,
-	const struct xfs_ialloc_args	*args,
-	struct xfs_buf			**ialloc_context,
-	struct xfs_inode		**ipp)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	struct xfs_inode		*pip = args->pip;
-	struct xfs_inode		*ip;
-	xfs_ino_t			ino;
-	int				error;
-
-	/*
-	 * Call the space management code to pick
-	 * the on-disk inode to be allocated.
-	 */
-	error = xfs_dialloc(tp, pip ? pip->i_ino : 0, args->mode,
-			    ialloc_context, &ino);
-	if (error)
-		return error;
-	if (*ialloc_context || ino == NULLFSINO) {
-		*ipp = NULL;
-		return 0;
-	}
-	ASSERT(*ialloc_context == NULL);
-
-	/*
-	 * Protect against obviously corrupt allocation btree records. Later
-	 * xfs_iget checks will catch re-allocation of other active in-memory
-	 * and on-disk inodes. If we don't catch reallocating the parent inode
-	 * here we will deadlock in xfs_iget() so we have to do these checks
-	 * first.
-	 */
-	if ((pip && ino == pip->i_ino) || !xfs_verify_dir_ino(mp, ino)) {
-		xfs_alert(mp, "Allocated a known in-use inode 0x%llx!", ino);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Get the in-core inode with the lock held exclusively.
-	 * This is because we're setting fields here we need
-	 * to prevent others from looking at until we're done.
-	 */
-	error = args->ops->iget(mp, tp, ino, &ip);
-	if (error)
-		return error;
-	ASSERT(ip != NULL);
-
-	xfs_inode_init(tp, args, ip);
-	*ipp = ip;
-	return 0;
-}
-
 /*
  * Allocates a new inode from disk and return a pointer to the
  * incore copy. This routine will internally commit the current
