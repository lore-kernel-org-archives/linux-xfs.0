Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19738 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750886AbdAUIDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 21 Jan 2017 03:03:50 -0500
Subject: [PATCH 31/55] xfs: scrub realtime bitmap/summary
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 21 Jan 2017 00:03:44 -0800
Message-ID: <148498582471.15323.5968216416559835021.stgit@birch.djwong.org>
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

Perform simple tests of the realtime bitmap and summary.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile              |    5 ++
 fs/xfs/libxfs/xfs_format.h   |    5 ++
 fs/xfs/libxfs/xfs_fs.h       |    4 +
 fs/xfs/libxfs/xfs_rtbitmap.c |    2 -
 fs/xfs/scrub/agheader.c      |    1 
 fs/xfs/scrub/common.c        |    7 ++
 fs/xfs/scrub/common.h        |    6 ++
 fs/xfs/scrub/rtbitmap.c      |  131 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    3 +
 fs/xfs/xfs_trace.h           |    4 +
 10 files changed, 165 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/scrub/rtbitmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5035ee0..a22b027 100644
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
index 301effc..cb00017 100644
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
index 5484c26..bcb3a69 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -592,7 +592,9 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_DIR	15	/* directory */
 #define XFS_SCRUB_TYPE_XATTR	16	/* extended attribute */
 #define XFS_SCRUB_TYPE_SYMLINK	17	/* symbolic link */
-#define XFS_SCRUB_TYPE_MAX	17
+#define XFS_SCRUB_TYPE_RTBITMAP	18	/* realtime bitmap */
+#define XFS_SCRUB_TYPE_RTSUM	19	/* realtime summary */
+#define XFS_SCRUB_TYPE_MAX	19
 
 #define XFS_SCRUB_FLAG_REPAIR	0x01	/* i: repair this metadata */
 #define XFS_SCRUB_FLAG_CORRUPT	0x02	/* o: needs repair */
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index ea45584..f4b68c0 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -70,7 +70,7 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
  * Get a buffer for the bitmap or summary file block specified.
  * The buffer is returned read and locked.
  */
-static int
+int
 xfs_rtbuf_get(
 	xfs_mount_t	*mp,		/* file system mount structure */
 	xfs_trans_t	*tp,		/* transaction pointer */
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index f3bbd89..374157f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -248,6 +248,7 @@ xfs_scrub_superblock(
 	XFS_SCRUB_SB_FEAT(metauuid);
 	XFS_SCRUB_SB_FEAT(rmapbt);
 	XFS_SCRUB_SB_FEAT(reflink);
+	XFS_SCRUB_SB_FEAT(realtime);
 #undef XFS_SCRUB_SB_FEAT
 
 #define XFS_SCRUB_SB_FEAT_PREEN(fn) \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 0b55933..b7ac141 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -690,6 +690,13 @@ static const struct xfs_scrub_meta_fns meta_scrub_fns[] = {
 	{xfs_scrub_setup_inode, xfs_scrub_directory, NULL, NULL},
 	{xfs_scrub_setup_inode_xattr, xfs_scrub_xattr, NULL, NULL},
 	{xfs_scrub_setup_inode_symlink, xfs_scrub_symlink, NULL, NULL},
+#ifdef CONFIG_XFS_RT
+	{xfs_scrub_setup_rt, xfs_scrub_rtbitmap, NULL, xfs_sb_version_hasrealtime},
+	{xfs_scrub_setup_rt, xfs_scrub_rtsummary, NULL, xfs_sb_version_hasrealtime},
+#else
+	{NULL, NULL, NULL, NULL},
+	{NULL, NULL, NULL, NULL},
+#endif
 };
 
 /* Dispatch metadata scrubbing. */
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 123dc1d..8dc68b9 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -235,6 +235,10 @@ int xfs_scrub_setup_inode_symlink(struct xfs_scrub_context *sc,
 				  struct xfs_inode *ip,
 				  struct xfs_scrub_metadata *sm,
 				  bool retry_deadlocked);
+int xfs_scrub_setup_rt(struct xfs_scrub_context *sc,
+		       struct xfs_inode *ip,
+		       struct xfs_scrub_metadata *sm,
+		       bool retry_deadlocked);
 
 /* Metadata scrubbers */
 
@@ -255,5 +259,7 @@ int xfs_scrub_bmap_cow(struct xfs_scrub_context *sc);
 int xfs_scrub_directory(struct xfs_scrub_context *sc);
 int xfs_scrub_xattr(struct xfs_scrub_context *sc);
 int xfs_scrub_symlink(struct xfs_scrub_context *sc);
+int xfs_scrub_rtbitmap(struct xfs_scrub_context *sc);
+int xfs_scrub_rtsummary(struct xfs_scrub_context *sc);
 
 #endif	/* __XFS_REPAIR_COMMON_H__ */
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
new file mode 100644
index 0000000..2a5a546f
--- /dev/null
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -0,0 +1,131 @@
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
+	struct xfs_inode		*ip,
+	struct xfs_scrub_metadata	*sm,
+	bool				retry_deadlocked)
+{
+	struct xfs_mount		*mp = ip->i_mount;
+	int				lockmode;
+	int				error = 0;
+
+	if (sm->sm_agno || sm->sm_ino || sm->sm_gen)
+		return -EINVAL;
+
+	error = xfs_scrub_setup(sc, ip, sm, retry_deadlocked);
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
+	XFS_SCRUB_CHECK(sc, bp, "rtbitmap", fs_ok);
+#define XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(error, label) \
+	XFS_SCRUB_OP_ERROR_GOTO(sc, 0, 0, "rtbitmap", error, label)
+/* Scrub the realtime bitmap. */
+int
+xfs_scrub_rtbitmap(
+	struct xfs_scrub_context	*sc)
+{
+	struct xfs_mount		*mp = sc->tp->t_mountp;
+	struct xfs_buf			*bp = NULL;
+	xfs_rtblock_t			rtstart;
+	xfs_rtblock_t			rtend = 0;
+	xfs_rtblock_t			block;
+	xfs_rtblock_t			rem;
+	int				is_free = 0;
+	int				error = 0;
+	int				err2 = 0;
+
+	/* Iterate the bitmap, looking for discrepancies. */
+	rtstart = 0;
+	rem = mp->m_sb.sb_rblocks;
+	while (rem) {
+		if (xfs_scrub_should_terminate(&error))
+			break;
+
+		/* Is the first block free? */
+		err2 = xfs_rtcheck_range(mp, sc->tp, rtstart, 1, 1, &rtend,
+				&is_free);
+		XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(&err2, out);
+
+		/* How long does the extent go for? */
+		err2 = xfs_rtfind_forw(mp, sc->tp, rtstart,
+				mp->m_sb.sb_rblocks - 1, &rtend);
+		XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(&err2, out);
+
+		/* Find the buffer for error reporting. */
+		block = XFS_BITTOBLOCK(mp, rtstart);
+		err2 = xfs_rtbuf_get(mp, sc->tp, block, 0, &bp);
+		XFS_SCRUB_RTBITMAP_OP_ERROR_GOTO(&err2, out);
+		XFS_SCRUB_RTBITMAP_CHECK(rtend >= rtstart);
+
+		xfs_trans_brelse(sc->tp, bp);
+		bp = NULL;
+		rem -= rtend - rtstart + 1;
+		rtstart = rtend + 1;
+	}
+
+out:
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	if (!error && err2)
+		error = err2;
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
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index f798a3e..3036349 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -98,6 +98,8 @@ xfs_growfs_rt(
 /*
  * From xfs_rtbitmap.c
  */
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
 int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
 		      xfs_rtblock_t start, xfs_extlen_t len, int val,
 		      xfs_rtblock_t *new, int *stat);
@@ -128,6 +130,7 @@ int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtcheck_range(...)                         (ENOSYS)
 # define xfs_rtfind_forw(...)                           (ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)                       (ENOSYS)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 87fd942..c52e3a5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3370,7 +3370,9 @@ DEFINE_GETFSMAP_EVENT(xfs_getfsmap_mapping);
 	{ XFS_SCRUB_TYPE_BMBTC,		"bmapbtc" }, \
 	{ XFS_SCRUB_TYPE_DIR,		"dir" }, \
 	{ XFS_SCRUB_TYPE_XATTR,		"xattr" }, \
-	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }
+	{ XFS_SCRUB_TYPE_SYMLINK,	"symlink" }, \
+	{ XFS_SCRUB_TYPE_RTBITMAP,	"rtbitmap" }, \
+	{ XFS_SCRUB_TYPE_RTSUM,		"rtsummary" }
 DECLARE_EVENT_CLASS(xfs_scrub_class,
 	TP_PROTO(struct xfs_inode *ip, int type, xfs_agnumber_t agno,
 		 xfs_ino_t inum, unsigned int gen, unsigned int flags,

