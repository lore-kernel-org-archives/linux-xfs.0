Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 650C0C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjBPUjT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbjBPUjP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:39:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06940211DE
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 909D960C1E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1FEC4339B;
        Thu, 16 Feb 2023 20:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579951;
        bh=uTe3aQuTOHJ8JXrnP1Cusl2wxeDQLNxu1H/cSD3SmMg=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vFB3w8IhxQ4gMybVdrmbs00euzz0UlUGh5QcI7BKL0dDqkE28vVGFYy+ZqqOa0VAF
         L0ayWqnh+tgYglhsCnZLr8IqqGSdHGNlz5V9GgRsEIVPm9qGjJnuarmdY2YM9VjKRQ
         qv5sJ4uDMZvIrYnhDTTPwcUulhszx/hwnCygTDw/96mjnxr5WO1cyqoHesGZzZ+ZAN
         zwZczyjsPkcLswuO3lAowfid3yayo5hqZiXapVRySEW3RNhSViQDAEWzMBRZjUSjZ5
         hF8Awuebfjm/2WAz+IelI33qK0I1i9vuPPP8RygMt1ZyaeZ+n4R5+F32fNU6i7aKBM
         GPTs/b/iTUgrg==
Date:   Thu, 16 Feb 2023 12:39:10 -0800
Subject: [PATCH 25/28] xfs: Add parent pointer ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657872744.3473407.10713843286901630791.stgit@magnolia>
In-Reply-To: <167657872335.3473407.14628732092515467392.stgit@magnolia>
References: <167657872335.3473407.14628732092515467392.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch adds a new file ioctl to retrieve the parent pointer of a
given inode

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile            |    1 
 fs/xfs/libxfs/xfs_fs.h     |   74 ++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c |   10 +++
 fs/xfs/libxfs/xfs_parent.h |    2 +
 fs/xfs/xfs_ioctl.c         |   94 ++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_ondisk.h        |    4 +
 fs/xfs/xfs_parent_utils.c  |  126 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent_utils.h  |   11 ++++
 8 files changed, 321 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/xfs_parent_utils.c
 create mode 100644 fs/xfs/xfs_parent_utils.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e2b2cf50ffcf..42d0496fdad7 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -86,6 +86,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
 				   xfs_pwork.o \
+				   xfs_parent_utils.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index b0b4d7a3aa15..9e59a1fdfb0c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,6 +752,79 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+#define XFS_PPTR_MAXNAMELEN				256
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+
+/* Cursor is done iterating pptrs */
+#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+
+ #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
+				XFS_PPTR_OFLAG_DONE)
+
+/* Get an inode parent pointer through ioctl */
+struct xfs_parent_ptr {
+	__u64		xpp_ino;			/* Inode */
+	__u32		xpp_gen;			/* Inode generation */
+	__u32		xpp_diroffset;			/* Directory offset */
+	__u64		xpp_rsvd;			/* Reserved */
+	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+};
+
+/* Iterate through an inodes parent pointers */
+struct xfs_pptr_info {
+	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
+	struct xfs_handle		pi_handle;
+
+	/*
+	 * Structure to track progress in iterating the parent pointers.
+	 * Must be initialized to zeroes before the first ioctl call, and
+	 * not touched by callers after that.
+	 */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* Operational flags: XFS_PPTR_*FLAG* */
+	__u32				pi_flags;
+
+	/* Must be set to zero */
+	__u32				pi_reserved;
+
+	/* # of entries in array */
+	__u32				pi_ptrs_size;
+
+	/* # of entries filled in (output) */
+	__u32				pi_ptrs_used;
+
+	/* Must be set to zero */
+	__u64				pi_reserved2[6];
+
+	/*
+	 * An array of struct xfs_parent_ptr follows the header
+	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * parent pointer array entries.
+	 */
+	struct xfs_parent_ptr		pi_parents[];
+};
+
+static inline size_t
+xfs_pptr_info_sizeof(int nr_ptrs)
+{
+	return sizeof(struct xfs_pptr_info) +
+	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+}
+
+static inline struct xfs_parent_ptr*
+xfs_ppinfo_to_pp(
+	struct xfs_pptr_info	*info,
+	int			idx)
+{
+	return &info->pi_parents[idx];
+}
+
 /*
  * ioctl limits
  */
@@ -797,6 +870,7 @@ struct xfs_scrub_metadata {
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 629762701952..9176adfaa9e8 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -29,6 +29,16 @@
 
 struct kmem_cache		*xfs_parent_intent_cache;
 
+/* Initializes a xfs_parent_ptr from an xfs_parent_name_rec */
+void
+xfs_init_parent_ptr(struct xfs_parent_ptr		*xpp,
+		    const struct xfs_parent_name_rec	*rec)
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
index 039005883bb6..13040b9d8b08 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -25,6 +25,8 @@ struct xfs_parent_defer {
 void xfs_init_parent_name_rec(struct xfs_parent_name_rec *rec,
 			      struct xfs_inode *ip,
 			      uint32_t p_diroffset);
+void xfs_init_parent_ptr(struct xfs_parent_ptr *xpp,
+			 const struct xfs_parent_name_rec *rec);
 int __xfs_parent_init(struct xfs_mount *mp, bool grab_log,
 		struct xfs_parent_defer **parentp);
 
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 5cd5154d4d1e..df5a45b97f8f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -37,6 +37,7 @@
 #include "xfs_health.h"
 #include "xfs_reflink.h"
 #include "xfs_ioctl.h"
+#include "xfs_parent_utils.h"
 #include "xfs_xattr.h"
 
 #include <linux/mount.h>
@@ -1675,6 +1676,96 @@ xfs_ioc_scrub_metadata(
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
+	ppi = kmalloc(sizeof(struct xfs_pptr_info), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	/* Copy the data from the user */
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	/* Check size of buffer requested by user */
+	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+		error = -EINVAL;
+		goto out;
+	}
+	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+
+	/*
+	 * Now that we know how big the trailing buffer is, expand
+	 * our kernel xfs_pptr_info to be the same size
+	 */
+	ppi = krealloc(ppi, xfs_pptr_info_sizeof(ppi->pi_ptrs_size), 0);
+	if (!ppi)
+		return -ENOMEM;
+
+	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
+		error = xfs_iget(mp, NULL, ppi->pi_handle.ha_fid.fid_ino,
+				0, 0, &ip);
+		if (error)
+			goto out;
+
+		if (VFS_I(ip)->i_generation != ppi->pi_handle.ha_fid.fid_gen) {
+			error = -EINVAL;
+			goto out;
+		}
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
+			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+out:
+	kmem_free(ppi);
+	return error;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1964,7 +2055,8 @@ xfs_file_ioctl(
 
 	case XFS_IOC_FSGETXATTRA:
 		return xfs_ioc_fsgetxattra(ip, arg);
-
+	case XFS_IOC_GETPARENTS:
+		return xfs_ioc_get_parent_pointer(filp, arg);
 	case XFS_IOC_GETBMAP:
 	case XFS_IOC_GETBMAPA:
 	case XFS_IOC_GETBMAPX:
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 9737b5a9f405..6a6bd05c2a68 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -150,6 +150,10 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_32, efi_extents,	16);
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
+	/* parent pointer ioctls */
+	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+
 	/*
 	 * The v5 superblock format extended several v4 header structures with
 	 * additional data. While new fields are only accessible on v5
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
new file mode 100644
index 000000000000..771279731d42
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_shared.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_inode.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_trans.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_ioctl.h"
+#include "xfs_parent.h"
+#include "xfs_da_btree.h"
+#include "xfs_parent_utils.h"
+
+/*
+ * Get the parent pointers for a given inode
+ *
+ * Returns 0 on success and non zero on error
+ */
+int
+xfs_attr_get_parent_pointer(
+	struct xfs_inode		*ip,
+	struct xfs_pptr_info		*ppi)
+{
+
+	struct xfs_attrlist		*alist;
+	struct xfs_attrlist_ent		*aent;
+	struct xfs_parent_ptr		*xpp;
+	struct xfs_parent_name_rec	*xpnr;
+	char				*namebuf;
+	unsigned int			namebuf_size;
+	int				name_len, i, error = 0;
+	unsigned int			lock_mode, flags = XFS_ATTR_PARENT;
+	struct xfs_attr_list_context	context;
+
+	/* Allocate a buffer to store the attribute names */
+	namebuf_size = sizeof(struct xfs_attrlist) +
+		       (ppi->pi_ptrs_size) * sizeof(struct xfs_attrlist_ent);
+	namebuf = kvzalloc(namebuf_size, GFP_KERNEL);
+	if (!namebuf)
+		return -ENOMEM;
+
+	memset(&context, 0, sizeof(struct xfs_attr_list_context));
+	error = xfs_ioc_attr_list_context_init(ip, namebuf, namebuf_size, 0,
+			&context);
+	if (error)
+		goto out_kfree;
+
+	/* Copy the cursor provided by caller */
+	memcpy(&context.cursor, &ppi->pi_cursor,
+		sizeof(struct xfs_attrlist_cursor));
+	context.attr_filter = XFS_ATTR_PARENT;
+
+	lock_mode = xfs_ilock_attr_map_shared(ip);
+
+	error = xfs_attr_list_ilocked(&context);
+	if (error)
+		goto out_unlock;
+
+	alist = (struct xfs_attrlist *)namebuf;
+	for (i = 0; i < alist->al_count; i++) {
+		struct xfs_da_args args = {
+			.geo = ip->i_mount->m_attr_geo,
+			.whichfork = XFS_ATTR_FORK,
+			.dp = ip,
+			.namelen = sizeof(struct xfs_parent_name_rec),
+			.attr_filter = flags,
+		};
+
+		xpp = xfs_ppinfo_to_pp(ppi, i);
+		memset(xpp, 0, sizeof(struct xfs_parent_ptr));
+		aent = (struct xfs_attrlist_ent *)
+			&namebuf[alist->al_offset[i]];
+		xpnr = (struct xfs_parent_name_rec *)(aent->a_name);
+
+		if (aent->a_valuelen > XFS_PPTR_MAXNAMELEN) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+		name_len = aent->a_valuelen;
+
+		args.name = (char *)xpnr;
+		args.hashval = xfs_da_hashname(args.name, args.namelen),
+		args.value = (unsigned char *)(xpp->xpp_name);
+		args.valuelen = name_len;
+
+		error = xfs_attr_get_ilocked(&args);
+		error = (error == -EEXIST ? 0 : error);
+		if (error) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+
+		xfs_init_parent_ptr(xpp, xpnr);
+		if (!xfs_verify_ino(args.dp->i_mount, xpp->xpp_ino)) {
+			error = -EFSCORRUPTED;
+			goto out_unlock;
+		}
+	}
+	ppi->pi_ptrs_used = alist->al_count;
+	if (!alist->al_more)
+		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+
+	/* Update the caller with the current cursor position */
+	memcpy(&ppi->pi_cursor, &context.cursor,
+			sizeof(struct xfs_attrlist_cursor));
+
+out_unlock:
+	xfs_iunlock(ip, lock_mode);
+out_kfree:
+	kvfree(namebuf);
+
+	return error;
+}
+
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
new file mode 100644
index 000000000000..ad60baee8b2a
--- /dev/null
+++ b/fs/xfs/xfs_parent_utils.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022 Oracle, Inc.
+ * All rights reserved.
+ */
+#ifndef	__XFS_PARENT_UTILS_H__
+#define	__XFS_PARENT_UTILS_H__
+
+int xfs_attr_get_parent_pointer(struct xfs_inode *ip,
+				struct xfs_pptr_info *ppi);
+#endif	/* __XFS_PARENT_UTILS_H__ */

