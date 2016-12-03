Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19770 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbcLCBjd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:39:33 -0500
Subject: [PATCH 31/55] xfs: scrub symbolic links
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:38:36 -0800
Message-ID: <148072911681.12995.8680059044865880492.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Create the infrastructure to scrub symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile         |    1 +
 fs/xfs/libxfs/xfs_fs.h  |    3 +-
 fs/xfs/repair/common.c  |   27 +++++++++++++++
 fs/xfs/repair/common.h  |    1 +
 fs/xfs/repair/symlink.c |   84 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h      |    3 +-
 6 files changed, 117 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/repair/symlink.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 7bbd779..f02b53c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -115,6 +115,7 @@ xfs-$(CONFIG_XFS_ONLINE_REPAIR)	+= $(addprefix repair/, \
 				   inode.o \
 				   refcount.o \
 				   rmap.o \
+				   symlink.o \
 				   )
 
 # low-level transaction/log code
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index d6b702d..93a983c 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -591,7 +591,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
-#define XFS_SCRUB_TYPE_MAX	16
+#define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
+#define XFS_SCRUB_TYPE_MAX	17
 
 #define XFS_SCRUB_FLAG_REPAIR	0x1	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x2	/* o: needs repair */
diff --git a/fs/xfs/repair/common.c b/fs/xfs/repair/common.c
index 925aabd..c1a8ddd 100644
--- a/fs/xfs/repair/common.c
+++ b/fs/xfs/repair/common.c
@@ -851,6 +851,32 @@ xfs_scrub_setup_inode_xattr(
 	return 0;
 }
 
+/* Set us up with an inode and a buffer for reading symlink targets. */
+STATIC int
+xfs_scrub_setup_inode_symlink(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	void				*buf;
+	int				error;
+
+	/* Allocate the buffer without the inode lock held. */
+	buf = kmem_zalloc_large(MAXPATHLEN + 1, KM_SLEEP);
+	if (!buf)
+		return -ENOMEM;
+
+	error = xfs_scrub_setup_inode(sc, ip, sm, retry_deadlocked);
+	if (error) {
+		kmem_free(buf);
+		return error;
+	}
+
+	sc->buf = buf;
+	return 0;
+}
+
 /* Scrubbing dispatch. */
 
 struct xfs_scrub_meta_fns {
@@ -879,6 +905,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
+	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/repair/common.h b/fs/xfs/repair/common.h
index c8a4fe4..af0bfb2 100644
--- a/fs/xfs/repair/common.h
+++ b/fs/xfs/repair/common.h
@@ -211,5 +211,6 @@ int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
+int xfs_scrub_symlink(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/repair/symlink.c b/fs/xfs/repair/symlink.c
new file mode 100644
index 0000000..932201b
--- /dev/null
+++ b/fs/xfs/repair/symlink.c
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2016-2017 Oracle.  All Rights Reserved.
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
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "repair/common.h"
+
+/* Symbolic links. */
+
+#define XFS_SCRUB_SYMLINK_CHECK(fs_ok) \
+	XFS_SCRUB_INO_CHECK(sc, ip->i_ino, NULL, "symlink", fs_ok)
+#define XFS_SCRUB_SYMLINK_GOTO(fs_ok, label) \
+	XFS_SCRUB_INO_GOTO(sc, ip->i_ino, NULL, "symlink", fs_ok, label)
+int
+xfs_scrub_symlink(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_inode		*ip = sc->ip;
+	struct xfs_ifork		*ifp;
+	loff_t				len;
+	int				error = 0;
+
+	if (!S_ISLNK(VFS_I(ip)->i_mode))
+		return -ENOENT;
+	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	len = i_size_read(VFS_I(ip));
+
+	/* Plausible size? */
+	XFS_SCRUB_SYMLINK_GOTO(len <= MAXPATHLEN, out);
+
+	/* Inline symlink? */
+	if (ifp->if_flags & XFS_IFINLINE) {
+		XFS_SCRUB_SYMLINK_GOTO((ifp->if_u1.if_data && len > 0) ||
+				(ifp->if_u1.if_data == NULL && len == 0), out);
+		if (len == 0)
+			goto out;
+		XFS_SCRUB_SYMLINK_CHECK(len <= XFS_IFORK_DSIZE(ip));
+		XFS_SCRUB_SYMLINK_CHECK(len <= strnlen(ifp->if_u1.if_data,
+				XFS_IFORK_DSIZE(ip)));
+		goto out;
+	}
+
+	/* Remote symlink; must read. */
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	error = xfs_readlink(sc->ip, sc->buf);
+	xfs_ilock(sc->ip, XFS_ILOCK_EXCL);
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, 0, "symlink",
+			&error, out);
+	XFS_SCRUB_SYMLINK_CHECK(len <= strnlen(sc->buf, MAXPATHLEN));
+out:
+	return error;
+}
+#undef XFS_SCRUB_SYMLINK_GOTO
+#undef XFS_SCRUB_SYMLINK_CHECK
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee34ded..53d5451 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3478,7 +3478,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
-	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

