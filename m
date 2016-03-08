Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C758129E26
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2D79AAC002
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:15 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	T4GerkLpWSA56DwG for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:12 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94T-0004A9-1U
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:33 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007uS-G3
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/16] xfs: introduce rmap extent operation stubs
Date: Tue,  8 Mar 2016 15:16:08 +1100
Message-Id: <1457410578-30233-7-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

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
 fs/xfs/Makefile                |  1 +
 fs/xfs/libxfs/xfs_alloc.c      | 18 ++++++++-
 fs/xfs/libxfs/xfs_rmap.c       | 89 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h | 30 ++++++++++++++
 fs/xfs/xfs_trace.h             | 45 +++++++++++++++++++++
 5 files changed, 182 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/libxfs/xfs_rmap.c
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index f646391..c202ce3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_rmap.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 0222e03..9ecbe0f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_extent_busy.h"
@@ -647,6 +648,14 @@ xfs_alloc_ag_vextent(
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
@@ -1613,12 +1622,19 @@ xfs_free_ag_extent(
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
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
new file mode 100644
index 0000000..3e17294
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -0,0 +1,89 @@
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_btree.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
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
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, oinfo);
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
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, oinfo);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, oinfo);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, oinfo);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
new file mode 100644
index 0000000..a3b8f90
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
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
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8d5842..7968e92 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1701,6 +1701,51 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+DECLARE_EVENT_CLASS(xfs_rmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 struct xfs_owner_info *oinfo),
+	TP_ARGS(mp, agno, agbno, len, oinfo),
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
+	TP_printk("dev %d:%d agno %u agbno %u len %u, owner 0x%llx, offset %llu, flags 0x%lx",
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
+		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 struct xfs_owner_info *oinfo), \
+	TP_ARGS(mp, agno, agbno, len, oinfo))
+DEFINE_RMAP_EVENT(xfs_rmap_free_extent);
+DEFINE_RMAP_EVENT(xfs_rmap_free_extent_done);
+DEFINE_RMAP_EVENT(xfs_rmap_free_extent_error);
+DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent);
+DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_done);
+DEFINE_RMAP_EVENT(xfs_rmap_alloc_extent_error);
+
 DECLARE_EVENT_CLASS(xfs_da_class,
 	TP_PROTO(struct xfs_da_args *args),
 	TP_ARGS(args),
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
