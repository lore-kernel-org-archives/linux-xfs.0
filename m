Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28396 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751963AbdJLBn4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2017 21:43:56 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v9C1htJ4001474
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:55 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v9C1ht6a002129
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:55 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v9C1htH3029534
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2017 01:43:55 GMT
Subject: [PATCH 29/30] xfs: scrub realtime bitmap/summary
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 11 Oct 2017 18:43:54 -0700
Message-ID: <150777263398.1724.10464088394123475758.stgit@magnolia>
In-Reply-To: <150777244315.1724.6916081372861799350.stgit@magnolia>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Perform simple tests of the realtime bitmap and summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    2 +
 fs/xfs/libxfs/xfs_format.h |    5 ++
 fs/xfs/libxfs/xfs_fs.h     |    4 +-
 fs/xfs/scrub/common.h      |    9 ++++
 fs/xfs/scrub/rtbitmap.c    |  108 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/scrub.c       |   10 ++++
 fs/xfs/scrub/scrub.h       |   15 ++++++
 7 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 2193a54..9ce581e 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -162,4 +162,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   scrub.o \
 				   symlink.o \
 				   )
+
+xfs-$(CONFIG_XFS_RT)		+= scrub/rtbitmap.o
 endif
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 154c3dd..d4d9bef 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -315,6 +315,11 @@ static inline bool xfs_sb_good_version(struct xfs_sb *sbp)
 	return false;
 }
 
+static inline bool xfs_sb_version_hasrealtime(struct xfs_sb *sbp)
+{
+	return sbp->sb_rblocks > 0;
+}
+
 /*
  * Detect a mismatched features2 field.  Older kernels read/wrote
  * this into the wrong slot, so to be safe we keep them in sync.
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 7444094..f8bac92 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -502,9 +502,11 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
 #define XFS_SCRUB_TYPE_PARENT	18	/* parent pointers */
+#define XFS_SCRUB_TYPE_RTBITMAP	19	/* realtime bitmap */
+#define XFS_SCRUB_TYPE_RTSUM	20	/* realtime summary */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	19
+#define XFS_SCRUB_TYPE_NR	21
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 0542e7d..5b561e2 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -101,6 +101,15 @@ int xfs_scrub_setup_symlink(struct xfs_scrub_context *sc,
 			    struct xfs_inode *ip);
 int xfs_scrub_setup_parent(struct xfs_scrub_context *sc,
 			   struct xfs_inode *ip);
+#ifdef CONFIG_XFS_RT
+int xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip);
+#else
+static inline int
+xfs_scrub_setup_rt(struct xfs_scrub_context *sc, struct xfs_inode *ip)
+{
+	return -ENOENT;
+}
+#endif
 
 void xfs_scrub_ag_free(struct xfs_scrub_context *sc, struct xfs_scrub_ag *sa);
 int xfs_scrub_ag_init(struct xfs_scrub_context *sc, xfs_agnumber_t agno,
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
new file mode 100644
index 0000000..66d4252
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -0,0 +1,108 @@
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
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_inode.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+
+/* Set us up with the realtime metadata locked. */
+int
+xfs_scrub_setup_rt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				error = 0;
+
+	/*
+	 * If userspace gave us an AG number or inode data, they don't
+	 * know what they're doing.  Get out.
+	 */
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	error = xfs_scrub_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	sc->ilock_flags = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+	sc->ip = mp->m_rbmip;
+	xfs_ilock(sc->ip, sc->ilock_flags);
+
+	return 0;
+}
+
+/* Realtime bitmap. */
+
+/* Scrub a free extent record from the realtime bitmap. */
+STATIC int
+xfs_scrub_rtbitmap_helper(
+	struct xfs_trans		*tp,
+	struct xfs_rtalloc_rec		*rec,
+	void				*priv)
+{
+	struct xfs_scrub_context	*sc = priv;
+
+	if (rec->ar_startblock + rec->ar_blockcount <= rec->ar_startblock ||
+	    !xfs_verify_rtbno_ptr(sc->mp, rec->ar_startblock) ||
+	    !xfs_verify_rtbno_ptr(sc->mp, rec->ar_startblock +
+			rec->ar_blockcount - 1))
+		xfs_scrub_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+	return 0;
+}
+
+/* Scrub the realtime bitmap. */
+int
+xfs_scrub_rtbitmap(
+	struct xfs_scrub_context	*sc)
+{
+	int				error;
+
+	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_helper, sc);
+	if (!xfs_scrub_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		goto out;
+
+out:
+	return error;
+}
+
+/* Scrub the realtime summary. */
+int
+xfs_scrub_rtsummary(
+	struct xfs_scrub_context	*sc)
+{
+	/* XXX: implement this some day */
+	return -ENOENT;
+}
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8ecc3a1..09fc59d 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -237,6 +237,16 @@ static const struct xfs_scrub_meta_ops meta_scrub_ops[] = {
 		.setup	= xfs_scrub_setup_parent,
 		.scrub	= xfs_scrub_parent,
 	},
+	{ /* realtime bitmap */
+		.setup	= xfs_scrub_setup_rt,
+		.scrub	= xfs_scrub_rtbitmap,
+		.has	= xfs_sb_version_hasrealtime,
+	},
+	{ /* realtime summary */
+		.setup	= xfs_scrub_setup_rt,
+		.scrub	= xfs_scrub_rtsummary,
+		.has	= xfs_sb_version_hasrealtime,
+	},
 };
 
 /* This isn't a stable feature, warn once per day. */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a264810..9aff4e2 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -87,5 +87,20 @@ int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 int xfs_scrub_symlink(struct xfs_scrub_context *sc);
 int xfs_scrub_parent(struct xfs_scrub_context *sc);
+#ifdef CONFIG_XFS_RT
+int xfs_scrub_rtbitmap(struct xfs_scrub_context *sc);
+int xfs_scrub_rtsummary(struct xfs_scrub_context *sc);
+#else
+static inline int
+xfs_scrub_rtbitmap(struct xfs_scrub_context *sc)
+{
+	return -ENOENT;
+}
+static inline int
+xfs_scrub_rtsummary(struct xfs_scrub_context *sc)
+{
+	return -ENOENT;
+}
+#endif
 
 #endif	/* __XFS_SCRUB_SCRUB_H__ */

