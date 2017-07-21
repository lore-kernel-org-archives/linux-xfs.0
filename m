Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35353 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750972AbdGUEks (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jul 2017 00:40:48 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v6L4elW6010435
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4el0g002045
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:47 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v6L4el4S009348
        for <linux-xfs@vger.kernel.org>; Fri, 21 Jul 2017 04:40:47 GMT
Subject: [PATCH 21/22] xfs: scrub realtime bitmap/summary
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 20 Jul 2017 21:40:45 -0700
Message-ID: <150061204560.14732.4403077084695467619.stgit@magnolia>
In-Reply-To: <150061190859.14732.17040548800470377701.stgit@magnolia>
References: <150061190859.14732.17040548800470377701.stgit@magnolia>
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
 fs/xfs/scrub/agheader.c    |    1 
 fs/xfs/scrub/common.c      |   15 +++++++
 fs/xfs/scrub/common.h      |    3 +
 fs/xfs/scrub/rtbitmap.c    |  101 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    4 +-
 8 files changed, 133 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e73cdc2..86fc94c 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -156,4 +156,6 @@ xfs-y				+= $(addprefix scrub/, \
 				   rmap.o \
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
index 4ad3056..83121fc 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -501,7 +501,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_XATTR	17	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	18	/* symbolic link */
 #define XFS_SCRUB_TYPE_PARENT	19	/* parent pointers */
-#define XFS_SCRUB_TYPE_MAX	19
+#define XFS_SCRUB_TYPE_RTBITMAP	20	/* realtime bitmap */
+#define XFS_SCRUB_TYPE_RTSUM	21	/* realtime summary */
+#define XFS_SCRUB_TYPE_MAX	21
 
 /* i: repair this metadata */
 #define XFS_SCRUB_FLAG_REPAIR		(1 << 0)
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 137d2ad..8048a63 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -247,6 +247,7 @@ xfs_scrub_superblock(
 	XFS_SCRUB_SB_FEAT(metauuid);
 	XFS_SCRUB_SB_FEAT(rmapbt);
 	XFS_SCRUB_SB_FEAT(reflink);
+	XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
 #define XFS_SCRUB_SB_FEAT_PREEN(fn) \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 6f701c6..6e40fa6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -860,6 +860,21 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_parent,
 		.scrub	= xfs_scrub_parent,
 	},
+#ifdef CONFIG_XFS_RT
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
+#else
+	{ NULL },
+	{ NULL },
+#endif
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 1873a31..43a74f0 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -225,6 +225,7 @@ SETUP_FN(xfs_scrub_setup_directory);
 SETUP_FN(xfs_scrub_setup_xattr);
 SETUP_FN(xfs_scrub_setup_parent);
 SETUP_FN(xfs_scrub_setup_symlink);
+SETUP_FN(xfs_scrub_setup_rt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -250,6 +251,8 @@ SCRUB_FN(xfs_scrub_directory);
 SCRUB_FN(xfs_scrub_xattr);
 SCRUB_FN(xfs_scrub_parent);
 SCRUB_FN(xfs_scrub_symlink);
+SCRUB_FN(xfs_scrub_rtbitmap);
+SCRUB_FN(xfs_scrub_rtsummary);
 #undef SCRUB_FN
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
new file mode 100644
index 0000000..b061066
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -0,0 +1,101 @@
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
+#include "xfs_alloc.h"
+#include "xfs_rtalloc.h"
+#include "xfs_inode.h"
+#include "scrub/common.h"
+
+/* Set us up with the realtime metadata locked. */
+int
+xfs_scrub_setup_rt(
+	struct xfs_scrub_context	*sc,
+	struct xfs_inode		*ip)
+{
+	struct xfs_mount		*mp = sc->mp;
+	int				lockmode;
+	int				error = 0;
+
+	if (sc->sm->sm_agno || sc->sm->sm_ino || sc->sm->sm_gen)
+		return -EINVAL;
+
+	error = xfs_scrub_setup_fs(sc, ip);
+	if (error)
+		return error;
+
+	lockmode = XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP;
+	xfs_ilock(mp->m_rbmip, lockmode);
+	xfs_trans_ijoin(sc->tp, mp->m_rbmip, lockmode);
+
+	return 0;
+}
+
+/* Realtime bitmap. */
+
+#define XFS_SCRUB_RTBITMAP_CHECK(fs_ok) \
+	XFS_SCRUB_CHECK(sc, bp, "rtbitmap", fs_ok)
+#define XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(error, label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, 0, 0, "rtbitmap", error, label)
+/* Scrub a free extent record from the realtime bitmap. */
+STATIC int
+xfs_scrub_rtbitmap_helper(
+	struct xfs_trans		*tp,
+	struct xfs_rtalloc_rec		*rec,
+	void				*priv)
+{
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
+	error = xfs_rtalloc_query_all(sc->tp, xfs_scrub_rtbitmap_helper, NULL);
+	XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(&error, out);
+
+out:
+	return error;
+}
+#undef XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO
+#undef XFS_SCRUB_RTBITMAP_CHECK
+
+/* Scrub the realtime summary. */
+int
+xfs_scrub_rtsummary(
+	struct xfs_scrub_context	*sc)
+{
+	/* XXX: implement this some day */
+	return -ENOENT;
+}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 39824f8..1be7b00 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3330,7 +3330,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
 	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
-	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }, \
+	{ XFS_SCRUB_TYPE_RTBITMAP,	"rtbitmap" }, \
+	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, struct xfs_scrub_metadata *sm,
 		 int error),

