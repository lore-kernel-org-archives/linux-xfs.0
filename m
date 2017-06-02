Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24996 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBWcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 18:32:52 -0400
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52MWpD0003681
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v52MWpjT030450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:51 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v52MWoJ7001188
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 22:32:50 GMT
Subject: [PATCH 19/19] xfs: scrub realtime bitmap/summary
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 15:32:49 -0700
Message-ID: <149644276961.19430.3578652870843528729.stgit@birch.djwong.org>
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

Perform simple tests of the realtime bitmap and summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile            |    5 ++
 fs/xfs/libxfs/xfs_format.h |    5 ++
 fs/xfs/libxfs/xfs_fs.h     |    4 +-
 fs/xfs/scrub/agheader.c    |    1 
 fs/xfs/scrub/common.c      |   15 +++++++
 fs/xfs/scrub/common.h      |    3 +
 fs/xfs/scrub/rtbitmap.c    |  101 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trace.h         |    4 +-
 8 files changed, 136 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 88a2612..9d57a99 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -118,6 +118,11 @@ xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
 				   rmap.o \
 				   symlink.o \
 				   )
+ifeq ($(CONFIG_XFS_DEBUG)$(CONFIG_XFS_RT),yy)
+xfs-$(CONFIG_XFS_DEBUG)		+= $(addprefix scrub/, \
+				   rtbitmap.o \
+				   )
+endif
 
 # low-level transaction/log code
 xfs-y				+= xfs_log.o \
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index dc9b34a..532d372 100644
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
index 35c85c3..bdd203f 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -510,7 +510,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
-#define XFS_SCRUB_TYPE_MAX	17
+#define XFS_SCRUB_TYPE_RTBITMAP	18	/* realtime bitmap */
+#define XFS_SCRUB_TYPE_RTSUM	19	/* realtime summary */
+#define XFS_SCRUB_TYPE_MAX	19
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 127f06c..1338633 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -246,6 +246,7 @@ xfs_scrub_superblock(
 	XFS_SCRUB_SB_FEAT(metauuid);
 	XFS_SCRUB_SB_FEAT(rmapbt);
 	XFS_SCRUB_SB_FEAT(reflink);
+	XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
 #define XFS_SCRUB_SB_FEAT_PREEN(fn) \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 4676e59..0170c05 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -823,6 +823,21 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 		.setup	= xfs_scrub_setup_symlink,
 		.scrub	= xfs_scrub_symlink,
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
index f00c5f6c..22313f5 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -215,6 +215,7 @@ SETUP_FN(xfs_scrub_setup_inode_bmap);
 SETUP_FN(xfs_scrub_setup_directory);
 SETUP_FN(xfs_scrub_setup_xattr);
 SETUP_FN(xfs_scrub_setup_symlink);
+SETUP_FN(xfs_scrub_setup_rt);
 #undef SETUP_FN
 
 /* Metadata scrubbers */
@@ -237,6 +238,8 @@ SCRUB_FN(xfs_scrub_bmap_cow);
 SCRUB_FN(xfs_scrub_directory);
 SCRUB_FN(xfs_scrub_xattr);
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
index 57a40bb..e17ed1b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3347,7 +3347,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
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

