Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46752 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932153AbeFJFHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 01:07:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w5A57EGi007095
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:39 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2jg4dkt24f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:39 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57co5020246
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:38 GMT
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w5A57cIQ013192
        for <linux-xfs@vger.kernel.org>; Sun, 10 Jun 2018 05:07:38 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v7 22/23] xfs: Add parent pointer ioctl
Date: Sat,  9 Jun 2018 22:05:07 -0700
Message-Id: <1528607108-11059-23-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new file ioctl to retrieve the parent
pointer of a given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_fs.h     | 42 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c | 10 ++++++
 fs/xfs/libxfs/xfs_parent.h |  2 ++
 fs/xfs/xfs_attr_list.c     |  3 ++
 fs/xfs/xfs_ioctl.c         | 86 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |  4 +++
 fs/xfs/xfs_parent_utils.c  | 82 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |  2 ++
 8 files changed, 230 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 641e0af..3fd036b 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -552,6 +552,47 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_WARNING)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u32		xpp_namelen;			/* File name length */
+	__u32		xpp_pad;
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	struct xfs_handle		pi_handle;
+	struct xfs_attrlist_cursor	pi_cursor;
+	__u32				pi_flags;
+	__u32				pi_reserved;
+	__u32				pi_ptrs_size;
+	__u32				pi_ptrs_used;
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use XFS_PPINFO_TO_PP() to access the
+	 * parent pointer array entries.
+	 */
+};
+
+#define XFS_PPTR_INFO_SIZEOF(nr_ptrs) sizeof (struct xfs_pptr_info) + \
+				      nr_ptrs * sizeof(struct xfs_parent_ptr)
+
+#define XFS_PPINFO_TO_PP(info, idx)    \
+	(&(((struct xfs_parent_ptr *)((char *)(info) + sizeof(*(info))))[(idx)]))
+
 /*
  * ioctl limits
  */
@@ -596,6 +637,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_GETPPOINTER	_IOR ('X', 61, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 9f0964a..9cb76b4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -32,6 +32,16 @@
 #include "xfs_attr_sf.h"
 #include "xfs_bmap.h"
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		     struct xfs_parent_name_rec	*rec)
+{
+	xpp->xpp_ino = be64_to_cpu(rec->p_ino);
+	xpp->xpp_gen = be32_to_cpu(rec->p_gen);
+	xpp->xpp_diroffset = be32_to_cpu(rec->p_diroffset);
+}
+
 /*
  * Parent pointer attribute handling.
  *
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index 6197817..7771719 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -33,4 +33,6 @@ int xfs_parent_add(struct xfs_inode *parent,
 		   struct xfs_inode *child, struct xfs_name *child_name,
 		   uint32_t diroffset, xfs_fsblock_t *firstblock,
 		   struct xfs_defer_ops *dfops);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 struct xfs_parent_name_rec *rec);
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index df8faf5..f02b12c 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -581,6 +581,9 @@ xfs_attr_put_listent(
 	if (((context->flags & ATTR_ROOT) == 0) !=
 	    ((flags & XFS_ATTR_ROOT) == 0))
 		return;
+	if (((context->flags & ATTR_PARENT) == 0) !=
+	    ((flags & XFS_ATTR_PARENT) == 0))
+		return;
 
 	arraytop = sizeof(*alist) +
 			context->count * sizeof(alist->al_offset[0]);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 844480a..b3071c0 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -46,6 +46,8 @@
 #include "xfs_fsmap.h"
 #include "scrub/xfs_scrub.h"
 #include "xfs_sb.h"
+#include "xfs_da_format.h"
+#include "xfs_parent_utils.h"
 
 #include <linux/capability.h>
 #include <linux/cred.h>
@@ -1738,6 +1740,87 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+/*
+ * IOCTL routine to get the parent pointers of an inode and return it to user
+ * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * followed by a region large enough to contain an array of struct
+ * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * more parent pointers than can fit in the buffer space, caller may re-call
+ * the function using the returned pi_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ *
+ * Returns 0 on success or non-zero on failure
+ */
+STATIC int
+xfs_ioc_get_parent_pointer(
+	struct file			*filp,
+	void				__user *arg)
+{
+	struct xfs_pptr_info		*ppi = NULL;
+	int				error = 0;
+	struct xfs_inode		*ip = XFS_I(file_inode(filp));
+	struct xfs_mount		*mp = ip->i_mount;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* Allocate an xfs_pptr_info to put the user data */
+	ppi = kmem_alloc(sizeof(struct xfs_pptr_info), KM_SLEEP);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error)
+		goto out;
+
+	/* Check size of buffer requested by user */
+	if (XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = kmem_realloc(ppi, XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size),
+			     KM_SLEEP);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags != 0 && ppi->pi_flags != XFS_PPTR_IFLAG_HANDLE) {
+		error = -EINVAL;
+		goto out;
+	}
+
+	if (ppi->pi_flags == XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+	}
+
+	if (ip->i_ino == mp->m_sb.sb_rootino)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+
+	/* Get the parent pointers */
+	error = xfs_attr_get_parent_pointer(ip, ppi);
+
+	if (error)
+		goto out;
+
+	/* Copy the parent pointers back to the user */
+	error = copy_to_user(arg, ppi,
+			XFS_PPTR_INFO_SIZEOF(ppi->pi_ptrs_size));
+	if (error)
+		goto out;
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1894,7 +1977,8 @@ xfs_file_ioctl(
 		return xfs_ioc_getxflags(ip, arg);
 	case XFS_IOC_SETXFLAGS:
 		return xfs_ioc_setxflags(ip, filp, arg);
-
+	case XFS_IOC_GETPPOINTER:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_FSSETDM: {
 		struct fsdmidata	dmi;
 
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 3723d50..a524db4 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -139,6 +139,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
+
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,		280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,		104);
 }
 
 #endif /* __XFS_ONDISK_H */
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index b89d4eb..57255cd 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -28,6 +28,7 @@
 #include "xfs_trans.h"
 #include "xfs_attr.h"
 #include "xfs_parent.h"
+#include "xfs_da_btree.h"
 
 /*
  * Add a parent record to an inode with existing parent records.
@@ -66,3 +67,84 @@ xfs_parent_remove_deferred(
 		ATTR_PARENT);
 }
 
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(struct xfs_inode		*ip,
+			     struct xfs_pptr_info	*ppi)
+
+{
+
+	struct attrlist			*alist;
+	struct attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len;
+	int				error = 0;
+	unsigned int			flags = ATTR_PARENT;
+	int				i;
+	struct xfs_attr_list_context	context;
+	struct xfs_da_args		args;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct attrlist_ent);
+	namebuf = kmem_zalloc_large(namebuf_size, KM_SLEEP);
+	if (!namebuf)
+		return -ENOMEM;
+
+	error = xfs_attr_list_context_init(ip, namebuf, namebuf_size, flags,
+			(attrlist_cursor_kern_t *)&ppi->pi_cursor, &context);
+	if (error)
+		goto out_kfree;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	error = xfs_attr_list_int_ilocked(&context);
+	if (error)
+		goto out_kfree;
+
+	alist = (struct attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		xpp = XFS_PPINFO_TO_PP(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct attrlist_ent *) &namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -ERANGE;
+			goto out_kfree;
+		}
+		name_len = aent->a_valuelen;
+
+		error = xfs_attr_args_init(&args, ip, (char *)xpnr,
+				sizeof(struct xfs_parent_name_rec), flags);
+		if (error)
+			goto out_kfree;
+
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+		args.op_flags = XFS_DA_OP_OKNOENT;
+
+		error = xfs_attr_get_ilocked(ip, &args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error)
+			goto out_kfree;
+
+		xpp->xpp_namelen = name_len;
+		xfs_init_parent_ptr(xpp, xpnr);
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+
+out_kfree:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	kmem_free(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index 9e0ac13..33e3b2c 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -27,4 +27,6 @@ int xfs_parent_remove_deferred(struct xfs_inode *parent,
 			       struct xfs_inode *child,
 			       xfs_dir2_dataptr_t diroffset,
 			       struct xfs_defer_ops *dfops);
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
 #endif	/* __XFS_PARENT_UTILS_H__ */
-- 
2.7.4

