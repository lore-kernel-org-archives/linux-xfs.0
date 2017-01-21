Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25194 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdAUIDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:03:42 -0500
Subject: [PATCH 30/55] xfs: scrub symbolic links
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:03:38 -0800
Message-ID: <148498581836.15323.1917083539546274542.stgit@birch.djwong.org>
In-Reply-To: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
References: <148498561504.15323.8531512066874274553.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Create the infrastructure to scrub symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    3 +
 fs/xfs/scrub/common.c  |    1 
 fs/xfs/scrub/common.h  |    5 ++
 fs/xfs/scrub/symlink.c |  107 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 +
 6 files changed, 118 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index d723ebc..5035ee0 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -116,6 +116,7 @@ xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   inode.o \
 				   refcount.o \
 				   rmap.o \
+				   symlink.o \
 				   )
 
 # low-level transaction/log code
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 6d5bfbd..5484c26 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -591,7 +591,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
-#define XFS_SCRUB_TYPE_MAX	16
+#define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
+#define XFS_SCRUB_TYPE_MAX	17
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index b68dd74..0b55933 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -689,6 +689,7 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode_bmap, xfs_scrub_bmap_cow, NULL, NULL},
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
+	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, NULL, NULL},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 0f3ffd7..123dc1d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -231,6 +231,10 @@ int xfs_scrub_setup_inode_xattr(struct xfs_scrub_context *sc,
 				struct xfs_inode *ip,
 				struct xfs_scrub_metadata *sm,
 				bool retry_deadlocked);
+int xfs_scrub_setup_inode_symlink(struct xfs_scrub_context *sc,
+				  struct xfs_inode *ip,
+				  struct xfs_scrub_metadata *sm,
+				  bool retry_deadlocked);
 
 /* Metadata scrubbers */
 
@@ -250,5 +254,6 @@ int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
+int xfs_scrub_symlink(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
new file mode 100644
index 0000000..80a1e70
--- /dev/null
+++ b/fs/xfs/scrub/symlink.c
@@ -0,0 +1,107 @@
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
+#include "scrub/common.h"
+
+/* Set us up with an inode and a buffer for reading symlink targets. */
+int
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
+	len = ip->i_d.di_size;
+
+	/* Plausible size? */
+	XFS_SCRUB_SYMLINK_GOTO(len <= MAXPATHLEN, out);
+
+	/* Inline symlink? */
+	if (ifp->if_flags & XFS_IFINLINE) {
+		XFS_SCRUB_SYMLINK_GOTO(len > 0, out);
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
index 760552d..87fd942 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3369,7 +3369,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
-	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

