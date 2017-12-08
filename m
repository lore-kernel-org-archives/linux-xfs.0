Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:60128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752562AbdLHEC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Dec 2017 23:02:28 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vB8425EW176426
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:02:27 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2eqjnsg306-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Fri, 08 Dec 2017 04:02:27 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vB842RfC008592
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:02:27 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vB842QF5008995
        for <linux-xfs@vger.kernel.org>; Fri, 8 Dec 2017 04:02:27 GMT
Date: Thu, 7 Dec 2017 20:02:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFCRAP DONOTMERGE PATCH 1/2] xfs: sketchy implementation of parent
 pointers
Message-ID: <20171208040222.GE19219@magnolia>
References: <20171208035457.GD19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171208035457.GD19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Allison Henderson <allison.henderson@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

This is a, um, "sample" implementation of parent pointers that abuses
struct dentry to return one parent pointer of a file ... if the dentry
cache has been connected.  This exists only to enable testing of the
userspace xfs_scrub bits and is probably too ugly to live.  Wait for the
real implementation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |   57 +++++++++++++
 fs/xfs/xfs_ioctl.c     |   49 +++++++++++
 fs/xfs/xfs_parent.c    |  214 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_parent.h    |   29 +++++++
 5 files changed, 350 insertions(+)
 create mode 100644 fs/xfs/xfs_parent.c
 create mode 100644 fs/xfs/xfs_parent.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e1768e7..9f4de14 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -99,6 +99,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_parent.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index fc4386a..f0ff964 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -545,6 +545,62 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_WARNING)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
+/* Parent Pointers */
+#define XFS_PPTR_NAME_MAX	256
+
+struct xfs_pptr {
+	/* Parent inode number. */
+	__u64				pp_ino;
+	__u64				pp_reserved[2];
+
+	/* Parent generation number. */
+	__u32				pp_gen;
+
+	/* Name in the parent. */
+	__u32				pp_namelen;
+	__u8				pp_name[XFS_PPTR_NAME_MAX];
+};
+
+/* return parents of the handle, not the open fd */
+#define XFS_PPTR_IFLAG_HANDLE	(1U << 0)
+
+#define XFS_PPTR_ALL_IFLAGS	(XFS_PPTR_IFLAG_HANDLE)
+
+/* partial results only */
+#define XFS_PPTR_OFLAG_PARTIAL	(1U << 0)
+
+/* target was the root directory */
+#define XFS_PPTR_OFLAG_ROOT	(1U << 1)
+
+struct xfs_pptr_info {
+	/* i: (optional) file handle. */
+	struct xfs_handle		pi_handle;
+
+	/* i/o: xattr lookup cursor, if necessary */
+	struct xfs_attrlist_cursor	pi_cursor;
+
+	/* i: input flags */
+	__u32				pi_iflags;
+
+	/* o: output flags */
+	__u32				pi_oflags;
+
+	/* i: number of pointers we have space for. */
+	__u32				pi_ptrs_size;
+
+	/* o: number of pointers actually returned. */
+	__u32				pi_ptrs_used;
+
+	/* must be zero */
+	__u64				pi_reserved[6];
+
+	/* o: pointer info, must come last */
+	struct xfs_pptr			pi_ptrs[0];
+};
+
+#define XFS_PPTR_INFO_SIZEOF(nr_ptrs)	(sizeof(struct xfs_pptr_info) + \
+					((nr_ptrs) * sizeof(struct xfs_pptr)))
+
 /*
  * ioctl limits
  */
@@ -589,6 +645,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
+#define XFS_IOC_GET_PPTR	_IOWR('X', 61, struct xfs_pptr_info)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 20dc65f..916b060 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -45,6 +45,7 @@
 #include <linux/fsmap.h>
 #include "xfs_fsmap.h"
 #include "scrub/xfs_scrub.h"
+#include "xfs_parent.h"
 
 #include <linux/capability.h>
 #include <linux/cred.h>
@@ -1730,6 +1731,51 @@ xfs_ioc_scrub_metadata(
 	return 0;
 }
 
+struct getpptr_info {
+	struct xfs_pptr_info __user *data;
+	unsigned int		idx;
+};
+
+STATIC int
+xfs_getpptr_format(
+	struct xfs_pptr		*pp,
+	void			*arg)
+{
+	struct getpptr_info	*info = arg;
+
+	if (copy_to_user(&info->data->pi_ptrs[info->idx++], pp,
+			sizeof(struct xfs_pptr)))
+		return -EFAULT;
+	return 0;
+}
+
+STATIC int
+xfs_ioc_get_parent_pointers(
+	struct file		*filp,
+	void			__user *arg)
+{
+	struct getpptr_info	info = { NULL };
+	struct xfs_pptr_info	pi;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&pi, arg, sizeof(pi)))
+		return -EFAULT;
+
+	info.data = arg;
+	error = xfs_parent_get_pointers(filp, &pi, xfs_getpptr_format, &info);
+	if (error)
+		return error;
+
+	pi.pi_ptrs_used = info.idx;
+	if (copy_to_user(arg, &pi, sizeof(pi)))
+		return -EFAULT;
+
+	return 0;
+}
+
 int
 xfs_ioc_swapext(
 	xfs_swapext_t	*sxp)
@@ -1914,6 +1960,9 @@ xfs_file_ioctl(
 	case XFS_IOC_SCRUB_METADATA:
 		return xfs_ioc_scrub_metadata(ip, arg);
 
+	case XFS_IOC_GET_PPTR:
+		return xfs_ioc_get_parent_pointers(filp, arg);
+
 	case XFS_IOC_FD_TO_HANDLE:
 	case XFS_IOC_PATH_TO_HANDLE:
 	case XFS_IOC_PATH_TO_FSHANDLE: {
diff --git a/fs/xfs/xfs_parent.c b/fs/xfs/xfs_parent.c
new file mode 100644
index 0000000..91b07e0
--- /dev/null
+++ b/fs/xfs/xfs_parent.c
@@ -0,0 +1,214 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
+#include "xfs_export.h"
+#include "xfs_parent.h"
+
+struct xfs_pptr_buf {
+	uint32_t		idx;
+	struct xfs_pptr		recs[0];
+};
+
+#define XFS_PARENT_ITER_ABORT	(1)
+
+/* Package up a pptr structure and emit it to the caller. */
+static int
+xfs_parent_emit(
+	struct xfs_pptr_info	*pi,
+	struct xfs_pptr_buf	*pb,
+	uint64_t		ino,
+	uint32_t		gen,
+	uint8_t			namelen,
+	const char		*name)
+{
+	struct xfs_pptr		*pptr;
+
+	if (pb->idx >= pi->pi_ptrs_size)
+		return XFS_PARENT_ITER_ABORT;
+
+	pptr = &pb->recs[pb->idx++];
+	pptr->pp_ino = ino;
+	pptr->pp_gen = gen;
+	pptr->pp_namelen = namelen;
+	memcpy(pptr->pp_name, name, namelen);
+
+	return 0;
+}
+
+/*
+ * No need to do permission checks on the various pathname components
+ * as the handle operations are privileged.
+ */
+STATIC int
+xfs_parent_handle_acceptable(
+	void			*context,
+	struct dentry		*dentry)
+{
+	return 1;
+}
+
+/* Get parent info for an inode by walking the parent dentry. */
+static int
+xfs_parent_get_dparent(
+	struct file		*filp,
+	struct xfs_pptr_info	*pi,
+	struct xfs_pptr_buf	*pb)
+{
+	struct xfs_inode	*ip;
+	struct inode		*dir_inode;
+	struct dentry		*dentry;
+	struct dentry		*dparent;
+	unsigned int		ilock;
+	int			error = 0;
+
+	pi->pi_oflags |= XFS_PPTR_OFLAG_PARTIAL;
+
+	/* Any nonzero byte in the cursor means we've already retrieved one. */
+	if (memchr_inv(&pi->pi_cursor, 0, sizeof(pi->pi_cursor)))
+		return 0;
+	memset(&pi->pi_cursor, 0xFF, sizeof(pi->pi_cursor));
+
+	if (pi->pi_iflags & XFS_PPTR_IFLAG_HANDLE) {
+		struct xfs_handle	*handle = &pi->pi_handle;
+		struct xfs_fid64	fid = { 0 };
+
+		/* Extract the desired file from the handle info. */
+		if (sizeof(handle->ha_fid) - sizeof(handle->ha_fid.fid_len) !=
+				handle->ha_fid.fid_len)
+			return -EINVAL;
+
+		fid.ino = handle->ha_fid.fid_ino;
+		fid.gen = handle->ha_fid.fid_gen;
+
+		dentry = exportfs_decode_fh(filp->f_path.mnt,
+				(struct fid *)&fid, 3,
+				FILEID_INO32_GEN | XFS_FILEID_TYPE_64FLAG,
+				xfs_parent_handle_acceptable, NULL);
+		if (IS_ERR(dentry))
+			return PTR_ERR(dentry);
+	} else {
+		/* Or just use the dentry of the open file. */
+		dentry = dget(file_dentry(filp));
+	}
+
+	/* Lock XFS inode... */
+	ip = XFS_I(d_inode(dentry));
+	ilock = XFS_IOLOCK_SHARED | XFS_MMAPLOCK_SHARED | XFS_ILOCK_SHARED;
+	xfs_ilock(ip, ilock);
+
+	/* Bail out early for the root dir. */
+	if (ip->i_ino == ip->i_mount->m_sb.sb_rootino) {
+		pi->pi_oflags |= XFS_PPTR_OFLAG_ROOT;
+		goto out_dentry;
+	}
+
+	/* Filter out the unconnected inodes. */
+	if (d_unlinked(dentry) || (dentry->d_flags & DCACHE_DISCONNECTED))
+		goto out_dentry;
+	if (IS_ROOT(dentry)) {
+		pi->pi_oflags |= XFS_PPTR_OFLAG_ROOT;
+		goto out_dentry;
+	}
+
+	/* Otherwise look up the parent... */
+	dparent = dget_parent(dentry);
+	if (IS_ERR(dparent)) {
+		error = PTR_ERR(dparent);
+		goto out_dentry;
+	}
+
+	dir_inode = d_inode(dparent);
+	if (!dir_inode)
+		goto out_dparent;
+
+	/* ...and emit a record. */
+	error = xfs_parent_emit(pi, pb, dir_inode->i_ino,
+			dir_inode->i_generation,
+			ACCESS_ONCE(dentry->d_name.len),
+			ACCESS_ONCE(dentry->d_name.name));
+	if (error == XFS_PARENT_ITER_ABORT)
+		error = 0;
+
+out_dparent:
+	dput(dparent);
+out_dentry:
+	xfs_iunlock(ip, ilock);
+	dput(dentry);
+	return error;
+}
+
+/* Walk all the parent pointers of a file. */
+int
+xfs_parent_get_pointers(
+	struct file		*filp,
+	struct xfs_pptr_info	*pi,
+	xfs_parent_format_t	formatter,
+	void			*arg)
+{
+	struct xfs_pptr_buf	*pb;
+	size_t			sz;
+	unsigned int		i;
+	int			error;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (pi->pi_iflags & ~XFS_PPTR_ALL_IFLAGS)
+		return -EINVAL;
+	if (memchr_inv(pi->pi_reserved, 0, sizeof(pi->pi_reserved)))
+		return -EINVAL;
+
+	/*
+	 * Allocate temporary buffer to hold pptr records while we have
+	 * the inode locked.
+	 */
+	sz = sizeof(struct xfs_pptr_buf) +
+			(pi->pi_ptrs_size * sizeof(struct xfs_pptr));
+	if (sz > PAGE_SIZE * 4)
+		return -ENOMEM;
+	pb = kmem_zalloc_large(sz, KM_SLEEP | KM_MAYFAIL);
+	if (!pb)
+		return -ENOMEM;
+
+	/* Record parent pointer information in buffer. */
+	error = xfs_parent_get_dparent(filp, pi, pb);
+	if (error)
+		goto out;
+
+	/* Format records to userspace. */
+	for (i = 0; error == 0 && i < pb->idx; i++)
+		error = formatter(&pb->recs[i], arg);
+
+out:
+	kmem_free(pb);
+	return error;
+}
diff --git a/fs/xfs/xfs_parent.h b/fs/xfs/xfs_parent.h
new file mode 100644
index 0000000..23ee505
--- /dev/null
+++ b/fs/xfs/xfs_parent.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_PARENT_H__
+#define __XFS_PARENT_H__
+
+/* pptr to userspace formatter - copy to user & advance pointer */
+typedef int (*xfs_parent_format_t)(struct xfs_pptr *, void *);
+
+int xfs_parent_get_pointers(struct file *filp, struct xfs_pptr_info *pi,
+		xfs_parent_format_t formatter, void *priv);
+
+#endif /* __XFS_PARENT_H__ */
