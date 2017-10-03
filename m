Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39786 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751177AbdJCUnL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 16:43:11 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v93KhAf6026093
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:43:11 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v93KhAjv015715
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:43:10 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v93KhANt002222
        for <linux-xfs@vger.kernel.org>; Tue, 3 Oct 2017 20:43:10 GMT
Subject: [PATCH 22/25] xfs: scrub symbolic links
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Oct 2017 13:43:08 -0700
Message-ID: <150706338884.19351.12939259197743285478.stgit@magnolia>
In-Reply-To: <150706324963.19351.17715069858921948692.stgit@magnolia>
References: <150706324963.19351.17715069858921948692.stgit@magnolia>
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
 fs/xfs/scrub/common.h  |    2 +
 fs/xfs/scrub/scrub.c   |    4 ++
 fs/xfs/scrub/scrub.h   |    1 +
 fs/xfs/scrub/symlink.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 102 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/symlink.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 4d46399..28637a6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -159,5 +159,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   refcount.o \
 				   rmap.o \
 				   scrub.o \
+				   symlink.o \
 				   )
 endif
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 0834ce6..bb8bcd0 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -500,9 +500,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_BMBTC	14	/* CoW fork block mapping */
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
+#define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	17
+#define XFS_SCRUB_TYPE_NR	18
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index b2d3bc7..30a1756 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -98,6 +98,8 @@ int xfs_scrub_setup_directory(struct xfs_scrub_context *sc,
 			      struct xfs_inode *ip);
 int xfs_scrub_setup_xattr(struct xfs_scrub_context *sc,
 			  struct xfs_inode *ip);
+int xfs_scrub_setup_symlink(struct xfs_scrub_context *sc,
+			    struct xfs_inode *ip);
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d1b80dc..5839a36 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -233,6 +233,10 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_xattr,
 		.scrub	= xfs_scrub_xattr,
 	},
+	{ /* symbolic link */
+		.setup	= xfs_scrub_setup_symlink,
+		.scrub	= xfs_scrub_symlink,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index d31ff58..dc4ed8d 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -85,5 +85,6 @@ int xfs_scrub_bmap_attr(struct xfs_scrub_context *sc);
 int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
+int xfs_scrub_symlink(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
new file mode 100644
index 0000000..0ae3201
--- /dev/null
+++ b/fs/xfs/scrub/symlink.c
@@ -0,0 +1,92 @@
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
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_inode_fork.h"
+#include "xfs_symlink.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Set us up to scrub a symbolic link. */
+int
+xfs_scrub_setup_symlink(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	/* Allocate the buffer without the inode lock held. */
+	sc->buf = kmem_zalloc_large(XFS_SYMLINK_MAXLEN + 1, KM_SLEEP);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xfs_scrub_setup_inode_contents(sc, ip, 0);
+}
+
+/* Symbolic links. */
+
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
+	if (len > XFS_SYMLINK_MAXLEN || len <= 0) {
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
+
+	/* Inline symlink? */
+	if (ifp->if_flags & XFS_IFINLINE) {
+		if (len > XFS_IFORK_DSIZE(ip) ||
+		    len > strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip)))
+			xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		goto out;
+	}
+
+	/* Remote symlink; must read the contents. */
+	error = xfs_readlink_bmap_ilocked(sc->ip, sc->buf);
+	if (!xfs_scrub_fblock_op_ok(sc, XFS_DATA_FORK, 0, &error))
+		goto out;
+	if (strnlen(sc->buf, XFS_SYMLINK_MAXLEN) < len)
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+out:
+	return error;
+}

