Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3607A811A
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:34:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E9F308F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:14 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ZSNOPEBLUR8jhU5k (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:12 -0700 (PDT)
Subject: [PATCH 032/145] xfs: introduce rmap extent operation stubs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:34:05 -0700
Message-ID: <146612724583.16048.2052256322968130910.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Add the stubs into the extent allocation and freeing paths that the
rmap btree implementation will hook into. While doing this, add the
trace points that will be used to track rmap btree extent
manipulations.

[darrick.wong@oracle.com: Extend the stubs to take full owner info.]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 include/libxfs.h        |    1 +
 include/xfs_trace.h     |    6 +++
 libxfs/Makefile         |    2 +
 libxfs/xfs_alloc.c      |   18 +++++++++-
 libxfs/xfs_rmap.c       |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |   30 ++++++++++++++++
 6 files changed, 144 insertions(+), 1 deletion(-)
 create mode 100644 libxfs/xfs_rmap.c
 create mode 100644 libxfs/xfs_rmap_btree.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 863b0e3..5e76263 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_rmap_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index cdabd18..b4174a3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -186,6 +186,12 @@
 
 #define trace_xfs_bmap_free_deferred(...)	((void) 0)
 #define trace_xfs_bmap_free_defer(...)		((void) 0)
+#define trace_xfs_rmap_free_extent(...)		((void) 0)
+#define trace_xfs_rmap_free_extent_error(...)	((void) 0)
+#define trace_xfs_rmap_alloc_extent(...)	((void) 0)
+#define trace_xfs_rmap_alloc_extent_error(...)	((void) 0)
+#define trace_xfs_rmap_alloc_extent_done(...)	((void) 0)
+#define trace_xfs_rmap_free_extent_done(...)	((void) 0)
 
 /* set c = c to avoid unused var warnings */
 #define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 0073cd1..d7a3e57 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -36,6 +36,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_quota_defs.h \
+	xfs_rmap_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -82,6 +83,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_rmap.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index e3442a3..0f35e96 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -27,6 +27,7 @@
 #include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_cksum.h"
@@ -644,6 +645,14 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
+	/* if not file data, insert new block into the reverse map btree */
+	if (args->oinfo.oi_owner) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
+
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
 						  args->agbp,
@@ -1610,12 +1619,19 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
+	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
+
+	if (oinfo->oi_owner) {
+		error = xfs_rmap_free(tp, agbp, agno, bno, len, oinfo);
+		if (error)
+			goto error0;
+	}
+
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
 	 */
 	bno_cur = xfs_allocbt_init_cursor(mp, tp, agbp, agno, XFS_BTNUM_BNO);
-	cnt_cur = NULL;
 	/*
 	 * Look for a neighboring block on the left (lower block numbers)
 	 * that is contiguous with this space.
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
new file mode 100644
index 0000000..31c6336
--- /dev/null
+++ b/libxfs/xfs_rmap.c
@@ -0,0 +1,88 @@
+
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_btree.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+
+int
+xfs_rmap_free(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, false, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, false, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, false, oinfo);
+	return error;
+}
+
+int
+xfs_rmap_alloc(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, false, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, false, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, false, oinfo);
+	return error;
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
new file mode 100644
index 0000000..a3b8f90
--- /dev/null
+++ b/libxfs/xfs_rmap_btree.h
@@ -0,0 +1,30 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+#ifndef __XFS_RMAP_BTREE_H__
+#define	__XFS_RMAP_BTREE_H__
+
+struct xfs_buf;
+
+int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
+		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		   struct xfs_owner_info *oinfo);
+int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
+		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		  struct xfs_owner_info *oinfo);
+
+#endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
