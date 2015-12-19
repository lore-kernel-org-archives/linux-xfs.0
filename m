Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 839BA7FC4
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02AE6AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:44 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Xq4aEitO4qkETF0X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:42 -0800 (PST)
Subject: [PATCH 11/76] xfs: introduce rmap extent operation stubs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:36 -0800
Message-ID: <20151219085736.12713.10731.stgit@birch.djwong.org>
In-Reply-To: <20151219085622.12713.88678.stgit@birch.djwong.org>
References: <20151219085622.12713.88678.stgit@birch.djwong.org>
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

>From : Dave Chinner <dchinner@redhat.com>

Add the stubs into the extent allocation and freeing paths that the
rmap btree implementation will hook into. While doing this, add the
trace points that will be used to track rmap btree extent
manipulations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_alloc.c      |   11 +++++
 fs/xfs/libxfs/xfs_rmap.c       |   89 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |   30 +++++++++++++
 fs/xfs/xfs_trace.h             |   37 +++++++++++++++++
 5 files changed, 168 insertions(+)
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
index 1fc3d28..46a8906 100644
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
@@ -646,6 +647,12 @@ xfs_alloc_ag_vextent(
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
@@ -1612,6 +1619,10 @@ xfs_free_ag_extent(
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
index 877079eb..f506396 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1676,6 +1676,43 @@ DEFINE_ALLOC_EVENT(xfs_alloc_vextent_noagbp);
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
