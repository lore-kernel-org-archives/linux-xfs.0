Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D35227FB2
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2015 01:05:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C2DC0304032
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2015 23:05:17 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	4SsscTgMwBnhnrwB for <xfs@oss.sgi.com>;
	Tue, 02 Jun 2015 23:05:15 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Z01nQ-0001DG-Lo
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
Received: from dave by disappointment with local (Exim 4.82_1-5b7a7c0-XX)
	(envelope-from <dave@disappointment.disaster>) id 1Z01nQ-0002vL-L5
	for xfs@oss.sgi.com; Wed, 03 Jun 2015 16:05:00 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/20] xfs: introduce rmap extent operation stubs
Date: Wed,  3 Jun 2015 16:04:46 +1000
Message-Id: <1433311497-10245-10-git-send-email-david@fromorbit.com>
In-Reply-To: <1433311497-10245-1-git-send-email-david@fromorbit.com>
References: <1433311497-10245-1-git-send-email-david@fromorbit.com>
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile                |  1 +
 fs/xfs/libxfs/xfs_alloc.c      | 11 ++++++
 fs/xfs/libxfs/xfs_rmap.c       | 89 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h | 30 ++++++++++++++
 fs/xfs/xfs_trace.h             | 37 ++++++++++++++++++
 5 files changed, 168 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_rmap.c
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b346326..07f36d3 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -50,6 +50,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_rmap.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 4353135..f62775a 100644
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
@@ -644,6 +645,12 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
+	/* insert new block into the reverse map btree */
+	error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+			       args->agbno, args->len, args->owner);
+	if (error)
+		return error;
+
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
 						  args->agbp,
@@ -1610,6 +1617,10 @@ xfs_free_ag_extent(
 	xfs_extlen_t	nlen;		/* new length of freespace */
 	xfs_perag_t	*pag;		/* per allocation group data */
 
+	error = xfs_rmap_free(tp, agbp, agno, bno, len, owner);
+	if (error)
+		goto error0;
+
 	mp = tp->t_mountp;
 	/*
 	 * Allocate and initialize a cursor for the by-block btree.
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
new file mode 100644
index 0000000..3958cf8
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
+	uint64_t		owner)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, owner);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, owner);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, owner);
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
+	uint64_t		owner)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	int			error = 0;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
+	if (1)
+		goto out_error;
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, owner);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, owner);
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
new file mode 100644
index 0000000..f1caa40
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
+		   uint64_t owner);
+int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
+		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		  uint64_t owner);
+
+#endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 8d916d3..25bd4f5 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1673,6 +1673,43 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_loopfailed);
 DEFINE_ALLOC_EVENT(xfs_alloc_vextent_allfailed);
 
+DECLARE_EVENT_CLASS(xfs_rmap_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner),
+	TP_ARGS(mp, agno, agbno, len, owner),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+		__field(uint64_t, owner)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+		__entry->owner = owner;
+	),
+	TP_printk("dev %d:%d agno %u agbno %u len %u, owner 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len,
+		  __entry->owner)
+);
+#define DEFINE_RMAP_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner), \
+	TP_ARGS(mp, agno, agbno, len, owner))
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
2.0.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
