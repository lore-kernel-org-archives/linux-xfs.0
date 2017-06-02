Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24958 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:32:46 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MWjoh003620
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:45 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v52MWiAQ016727
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:45 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52MWi1T027755
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:44 GMT
Subject: [PATCH 18/19] xfs: scrub symbolic links
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:32:41 -0700
Message-ID: <149644276157.19430.16747383439620667429.stgit@birch.djwong.org>
In-Reply-To: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
References: <149644264601.19430.6064928774771048026.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create the infrastructure to scrub symbolic link data.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile        |    1 +
 fs/xfs/libxfs/xfs_fs.h |    3 +-
 fs/xfs/scrub/common.c  |    4 ++
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/symlink.c |   94 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h     |    3 +-
 6 files changed, 105 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/symlink.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 39255f4..88a2612 100644
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
index 9390444..35c85c3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -509,7 +509,8 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
-#define XFS_SCRUB_TYPE_MAX	16
+#define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
+#define XFS_SCRUB_TYPE_MAX	17
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 7b6e2d8..4676e59 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -819,6 +819,10 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_xattr,
 		.scrub	= xfs_scrub_xattr,
 	},
+	{ /* symbolic link */
+		.setup	= xfs_scrub_setup_symlink,
+		.scrub	= xfs_scrub_symlink,
+	},
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 7ec2081..f00c5f6c 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -214,6 +214,7 @@ SETUP_FN(xfs_scrub_setup_inode_bmap_data);
 SETUP_FN(xfs_scrub_setup_inode_bmap);
 SETUP_FN(xfs_scrub_setup_directory);
 SETUP_FN(xfs_scrub_setup_xattr);
+SETUP_FN(xfs_scrub_setup_symlink);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -235,6 +236,7 @@ SCRUB_FN(xfs_scrub_bmap_attr);
 SCRUB_FN(xfs_scrub_bmap_cow);
 SCRUB_FN(xfs_scrub_directory);
 SCRUB_FN(xfs_scrub_xattr);
+SCRUB_FN(xfs_scrub_symlink);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
new file mode 100644
index 0000000..bbb1aed
--- /dev/null
+++ b/fs/xfs/scrub/symlink.c
@@ -0,0 +1,94 @@
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
+/* Set us up to scrub a symbolic link. */
+int
+xfs_scrub_setup_symlink(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	/* Allocate the buffer without the inode lock held. */
+	sc->buf = kmem_zalloc_large(MAXPATHLEN + 1, KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xfs_scrub_setup_inode_contents(sc, ip, 0);
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
+	XFS_SCRUB_SYMLINK_GOTO(len > 0, out);
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
+	/* Remote symlink; must read the contents. */
+	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
+	XFS_SCRUB_FILE_OP_ERROR_GOTO(sc, XFS_DATA_FORK, 0, "symlink",
+			&error, out);
+	XFS_SCRUB_SYMLINK_CHECK(len <= strnlen(sc->buf, MAXPATHLEN));
+out:
+	return error;
+}
+#undef XFS_SCRUB_SYMLINK_GOTO
+#undef XFS_SCRUB_SYMLINK_CHECK
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d479144..57a40bb 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3346,7 +3346,8 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTA,		"bmapbta" }, \
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
-	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }
+	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

