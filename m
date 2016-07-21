Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 274FB7CBB
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:58:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DED558F8035
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id gWIrc5KtJHkfWRo7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:58:55 -0700 (PDT)
Subject: [PATCH 25/47] xfs: introduce rmap extent operation stubs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:58:50 -0700
Message-ID: <146907713019.25461.56905367142239308.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

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
 fs/xfs/Makefile           |    1 +
 fs/xfs/libxfs/xfs_alloc.c |   19 +++++++++-
 fs/xfs/libxfs/xfs_rmap.c  |   89 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h  |   11 ++++++
 fs/xfs/xfs_trace.h        |   77 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 195 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rmap.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 01857b0..0498291 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -52,6 +52,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_rmap.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6335b8b..dba7ce4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -27,6 +27,7 @@
 #include "xfs_defer.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_rmap.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
@@ -36,7 +37,6 @@
 #include "xfs_trans.h"
 #include "xfs_buf_item.h"
 #include "xfs_log.h"
-#include "xfs_rmap.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -649,6 +649,14 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
+	/* if not file data, insert new block into the reverse map btree */
+	if (args->oinfo.oi_owner != XFS_RMAP_OWN_UNKNOWN) {
+		error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+				       args->agbno, args->len, &args->oinfo);
+		if (error)
+			return error;
+	}
+
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
 						  args->agbp,
@@ -1615,12 +1623,19 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
+	bno_cur = cnt_cur = NULL;
 	mp = tp->t_mountp;
+
+	if (oinfo->oi_owner != XFS_RMAP_OWN_UNKNOWN) {
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
new file mode 100644
index 0000000..b522bfc
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -0,0 +1,89 @@
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
+#include "xfs.h"
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
+#include "xfs_rmap.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
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
+	trace_xfs_rmap_unmap(mp, agno, bno, len, false, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_unmap_done(mp, agno, bno, len, false, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_unmap_error(mp, agno, error, _RET_IP_);
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
+	trace_xfs_rmap_map(mp, agno, bno, len, false, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_map_done(mp, agno, bno, len, false, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_map_error(mp, agno, error, _RET_IP_);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index b30e7ad..dbf0301 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -64,4 +64,15 @@ xfs_rmap_skip_owner_update(
 	oi->oi_owner = XFS_RMAP_OWN_UNKNOWN;
 }
 
+/* Reverse mapping functions. */
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
 #endif	/* __XFS_RMAP_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 939caf5..79e3812 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2423,6 +2423,83 @@ DEFINE_MAP_EXTENT_DEFERRED_EVENT(xfs_defer_map_extent);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
 DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
 
+/* rmap tracepoints */
+DECLARE_EVENT_CLASS(xfs_rmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 struct xfs_owner_info *oinfo),
+	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+		__field(uint64_t, offset)
+		__field(unsigned long, flags)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = oinfo->oi_owner;
+		__entry->offset = oinfo->oi_offset;
+		__entry->flags = oinfo->oi_flags;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%lx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner,
+		  __entry->offset,
+		  __entry->flags)
+);
+#define DEFINE_RMAP_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 struct xfs_owner_info *oinfo), \
+	TP_ARGS(mp, agno, agbno, len, unwritten, oinfo))
+
+/* simple AG-based error/%ip tracepoint class */
+DECLARE_EVENT_CLASS(xfs_ag_error_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error,
+		 unsigned long caller_ip),
+	TP_ARGS(mp, agno, error, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, error)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->error = error;
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d agno %u error %d caller %ps",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->error,
+		  (char *)__entry->caller_ip)
+);
+
+#define DEFINE_AG_ERROR_EVENT(name) \
+DEFINE_EVENT(xfs_ag_error_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, int error, \
+		 unsigned long caller_ip), \
+	TP_ARGS(mp, agno, error, caller_ip))
+
+DEFINE_RMAP_EVENT(xfs_rmap_unmap);
+DEFINE_RMAP_EVENT(xfs_rmap_unmap_done);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_unmap_error);
+DEFINE_RMAP_EVENT(xfs_rmap_map);
+DEFINE_RMAP_EVENT(xfs_rmap_map_done);
+DEFINE_AG_ERROR_EVENT(xfs_rmap_map_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
