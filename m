Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0024E80B1
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:47:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3CBA0AC002
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:12 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id vplq51ugA1LHA8VI (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:08 -0700 (PDT)
Subject: [PATCH 05/71] xfs: set up per-AG free space reservations
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:47:03 -0700
Message-ID: <147216882319.4420.16258127357814201394.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

One unfortunate quirk of the reference count btree -- it can expand in
size when blocks are written to *other* allocation groups if, say, one
large extent becomes a lot of tiny extents.  Since we don't want to
start throwing errors in the middle of CoWing, we need to reserve some
blocks to handle future expansion.

Use the count of how many reserved blocks we need to have on hand to
create a virtual reservation in the AG.  Through selective clamping of
the maximum length of allocation requests and of the length of the
longest free extent, we can make it look like there's less free space
in the AG unless the reservation owner is asking for blocks.

In other words, play some accounting tricks in-core to make sure that
we always have blocks available.  On the plus side, there's nothing to
clean up if we crash, which is contrast to the strategy that the rough
draft used (actually removing extents from the freespace btrees).

v2: There's really only two kinds of per-AG reservation pools -- one
to feed the AGFL (rmapbt), and one to feed everything else
(refcountbt).  Bearing that in mind, we can embed the reservation
controls in xfs_perag and greatly simplify the block accounting.
Furthermore, fix some longstanding accounting bugs that were a direct
result of the goofy "allocate a block and later fix up the accounting"
strategy by integrating the reservation accounting code more tightly
with the allocator.  This eliminates the ENOSPC complaints resulting
from refcount btree splits during truncate operations.

v3: Since AGFL blocks are considered to be "free", we mustn't change
fdblocks in response to any AGFL grow/shrink operation.  Therefore, we
must give back to fdblocks at umount whatever we borrowed at mount.
We have to let ag_reserved go down to zero because it's used to
determine if we're critically low on reservation.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/xfs_mount.h       |   36 +++++
 include/xfs_trace.h       |   14 ++
 libxfs/Makefile           |    2 
 libxfs/defer_item.c       |    3 
 libxfs/xfs_ag_resv.c      |  325 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_ag_resv.h      |   35 +++++
 libxfs/xfs_alloc.c        |  109 ++++++++++-----
 libxfs/xfs_alloc.h        |    8 +
 libxfs/xfs_bmap.c         |    6 +
 libxfs/xfs_ialloc_btree.c |    2 
 10 files changed, 499 insertions(+), 41 deletions(-)
 create mode 100644 libxfs/xfs_ag_resv.c
 create mode 100644 libxfs/xfs_ag_resv.h


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5cd9464..62b9ef2 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -112,6 +112,22 @@ typedef struct xfs_mount {
 	struct xlog		*m_log;
 } xfs_mount_t;
 
+/* per-AG block reservation data structures*/
+enum xfs_ag_resv_type {
+	XFS_AG_RESV_NONE = 0,
+	XFS_AG_RESV_METADATA,
+	XFS_AG_RESV_AGFL,
+};
+
+struct xfs_ag_resv {
+	/* number of blocks originally reserved here */
+	xfs_extlen_t			ar_orig_reserved;
+	/* number of blocks reserved here */
+	xfs_extlen_t			ar_reserved;
+	/* number of blocks originally asked for */
+	xfs_extlen_t			ar_asked;
+};
+
 /*
  * Per-ag incore structure, copies of information in agf and agi,
  * to improve the performance of allocation group selection.
@@ -142,8 +158,28 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 	int		pagb_count;	/* pagb slots in use */
+
+	/* Blocks reserved for all kinds of metadata. */
+	struct xfs_ag_resv	pag_meta_resv;
+	/* Blocks reserved for just AGFL-based metadata. */
+	struct xfs_ag_resv	pag_agfl_resv;
 } xfs_perag_t;
 
+static inline struct xfs_ag_resv *
+xfs_perag_resv(
+	struct xfs_perag	*pag,
+	enum xfs_ag_resv_type	type)
+{
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+		return &pag->pag_meta_resv;
+	case XFS_AG_RESV_AGFL:
+		return &pag->pag_agfl_resv;
+	default:
+		return NULL;
+	}
+}
+
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
 #define LIBXFS_MOUNT_32BITINODES	0x0002
 #define LIBXFS_MOUNT_32BITINOOPT	0x0004
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index a636a8c..a32eec3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -215,4 +215,18 @@
 #define trace_xfs_rmapbt_free_block(...)	((void) 0)
 #define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
 
+#define trace_xfs_ag_resv_critical(...)		((void) 0)
+#define trace_xfs_ag_resv_needed(...)		((void) 0)
+#define trace_xfs_ag_resv_free(...)		((void) 0)
+#define trace_xfs_ag_resv_free_error(...)	((void) 0)
+#define trace_xfs_ag_resv_init(...)		((void) 0)
+#define trace_xfs_ag_resv_init_error(...)	((void) 0)
+#define trace_xfs_ag_resv_alloc_extent(...)	((void) 0)
+#define trace_xfs_ag_resv_free_extent(...)	((void) 0)
+
+/* set c = c to avoid unused var warnings */
+#define trace_xfs_perag_get(a,b,c,d)	((c) = (c))
+#define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
+#define trace_xfs_perag_put(a,b,c,d)	((c) = (c))
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 62608bd..1b3bcca 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -18,6 +18,7 @@ PKGHFILES = xfs_fs.h \
 	xfs_log_format.h
 
 HFILES = \
+	xfs_ag_resv.h \
 	xfs_alloc.h \
 	xfs_alloc_btree.h \
 	xfs_attr_leaf.h \
@@ -60,6 +61,7 @@ CFILES = cache.c \
 	rdwr.c \
 	trans.c \
 	util.c \
+	xfs_ag_resv.c \
 	xfs_alloc.c \
 	xfs_alloc_btree.c \
 	xfs_attr.c \
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index de4f769..f60a11b 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -95,7 +95,8 @@ xfs_extent_free_finish_item(
 
 	free = container_of(item, struct xfs_extent_free_item, xefi_list);
 	error = xfs_free_extent(tp, free->xefi_startblock,
-			free->xefi_blockcount, &free->xefi_oinfo);
+			free->xefi_blockcount, &free->xefi_oinfo,
+			XFS_AG_RESV_NONE);
 	kmem_free(free);
 	return error;
 }
diff --git a/libxfs/xfs_ag_resv.c b/libxfs/xfs_ag_resv.c
new file mode 100644
index 0000000..af69235
--- /dev/null
+++ b/libxfs/xfs_ag_resv.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_alloc.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_ag_resv.h"
+#include "xfs_trans_space.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_btree.h"
+
+/*
+ * Per-AG Block Reservations
+ *
+ * For some kinds of allocation group metadata structures, it is advantageous
+ * to reserve a small number of blocks in each AG so that future expansions of
+ * that data structure do not encounter ENOSPC because errors during a btree
+ * split cause the filesystem to go offline.
+ *
+ * Prior to the introduction of reflink, this wasn't an issue because the free
+ * space btrees maintain a reserve of space (the AGFL) to handle any expansion
+ * that may be necessary; and allocations of other metadata (inodes, BMBT,
+ * dir/attr) aren't restricted to a single AG.  However, with reflink it is
+ * possible to allocate all the space in an AG, have subsequent reflink/CoW
+ * activity expand the refcount btree, and discover that there's no space left
+ * to handle that expansion.  Since we can calculate the maximum size of the
+ * refcount btree, we can reserve space for it and avoid ENOSPC.
+ *
+ * Handling per-AG reservations consists of three changes to the allocator's
+ * behavior:  First, because these reservations are always needed, we decrease
+ * the ag_max_usable counter to reflect the size of the AG after the reserved
+ * blocks are taken.  Second, the reservations must be reflected in the
+ * fdblocks count to maintain proper accounting.  Third, each AG must maintain
+ * its own reserved block counter so that we can calculate the amount of space
+ * that must remain free to maintain the reservations.  Fourth, the "remaining
+ * reserved blocks" count must be used when calculating the length of the
+ * longest free extent in an AG and to clamp maxlen in the per-AG allocation
+ * functions.  In other words, we maintain a virtual allocation via in-core
+ * accounting tricks so that we don't have to clean up after a crash. :)
+ *
+ * Reserved blocks can be managed by passing one of the enum xfs_ag_resv_type
+ * values via struct xfs_alloc_arg or directly to the xfs_free_extent
+ * function.  It might seem a little funny to maintain a reservoir of blocks
+ * to feed another reservoir, but the AGFL only holds enough blocks to get
+ * through the next transaction.  The per-AG reservation is to ensure (we
+ * hope) that each AG never runs out of blocks.  Each data structure wanting
+ * to use the reservation system should update ask/used in xfs_ag_resv_init.
+ */
+
+/*
+ * Are we critically low on blocks?  For now we'll define that as the number
+ * of blocks we can get our hands on being less than 10% of what we reserved
+ * or less than some arbitrary number (eight).
+ */
+bool
+xfs_ag_resv_critical(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type)
+{
+	xfs_extlen_t			avail;
+	xfs_extlen_t			orig;
+
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+		avail = pag->pagf_freeblks - pag->pag_agfl_resv.ar_reserved;
+		orig = pag->pag_meta_resv.ar_asked;
+		break;
+	case XFS_AG_RESV_AGFL:
+		avail = pag->pagf_freeblks + pag->pagf_flcount -
+			pag->pag_meta_resv.ar_reserved;
+		orig = pag->pag_agfl_resv.ar_asked;
+		break;
+	default:
+		ASSERT(0);
+		return false;
+	}
+
+	trace_xfs_ag_resv_critical(pag, type, avail);
+
+	return avail < orig / 10 || avail < XFS_BTREE_MAXLEVELS;
+}
+
+/*
+ * How many blocks are reserved but not used, and therefore must not be
+ * allocated away?
+ */
+xfs_extlen_t
+xfs_ag_resv_needed(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type)
+{
+	xfs_extlen_t			len;
+
+	len = pag->pag_meta_resv.ar_reserved + pag->pag_agfl_resv.ar_reserved;
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+	case XFS_AG_RESV_AGFL:
+		len -= xfs_perag_resv(pag, type)->ar_reserved;
+		break;
+	case XFS_AG_RESV_NONE:
+		/* empty */
+		break;
+	default:
+		ASSERT(0);
+	}
+
+	trace_xfs_ag_resv_needed(pag, type, len);
+
+	return len;
+}
+
+/* Clean out a reservation */
+static int
+__xfs_ag_resv_free(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type)
+{
+	struct xfs_ag_resv		*resv;
+	xfs_extlen_t			oldresv;
+	int				error;
+
+	trace_xfs_ag_resv_free(pag, type, 0);
+
+	resv = xfs_perag_resv(pag, type);
+	pag->pag_mount->m_ag_max_usable += resv->ar_asked;
+	/*
+	 * AGFL blocks are always considered "free", so whatever
+	 * was reserved at mount time must be given back at umount.
+	 */
+	oldresv = (type == XFS_AG_RESV_AGFL ? resv->ar_orig_reserved :
+					      resv->ar_reserved);
+	error = xfs_mod_fdblocks(pag->pag_mount, oldresv, true);
+	resv->ar_reserved = 0;
+	resv->ar_asked = 0;
+
+	if (error)
+		trace_xfs_ag_resv_free_error(pag->pag_mount, pag->pag_agno,
+				error, _RET_IP_);
+	return error;
+}
+
+/* Free a per-AG reservation. */
+int
+xfs_ag_resv_free(
+	struct xfs_perag		*pag)
+{
+	int				error = 0;
+	int				err2;
+
+	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_AGFL);
+	if (err2 && !error)
+		error = err2;
+	err2 = __xfs_ag_resv_free(pag, XFS_AG_RESV_METADATA);
+	if (err2 && !error)
+		error = err2;
+	return error;
+}
+
+static int
+__xfs_ag_resv_init(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type,
+	xfs_extlen_t			ask,
+	xfs_extlen_t			used)
+{
+	struct xfs_mount		*mp = pag->pag_mount;
+	struct xfs_ag_resv		*resv;
+	int				error;
+
+	resv = xfs_perag_resv(pag, type);
+	if (used > ask)
+		ask = used;
+	resv->ar_asked = ask;
+	resv->ar_reserved = resv->ar_orig_reserved = ask - used;
+	mp->m_ag_max_usable -= ask;
+
+	trace_xfs_ag_resv_init(pag, type, ask);
+
+	error = xfs_mod_fdblocks(mp, -(int64_t)resv->ar_reserved, true);
+	if (error)
+		trace_xfs_ag_resv_init_error(pag->pag_mount, pag->pag_agno,
+				error, _RET_IP_);
+
+	return error;
+}
+
+/* Create a per-AG block reservation. */
+int
+xfs_ag_resv_init(
+	struct xfs_perag		*pag)
+{
+	xfs_extlen_t			ask;
+	xfs_extlen_t			used;
+	int				error = 0;
+	int				err2;
+
+	if (pag->pag_meta_resv.ar_asked)
+		goto init_agfl;
+
+	/* Create the metadata reservation. */
+	ask = used = 0;
+
+	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_METADATA, ask, used);
+	if (err2 && !error)
+		error = err2;
+
+init_agfl:
+	if (pag->pag_agfl_resv.ar_asked)
+		return error;
+
+	/* Create the AGFL metadata reservation */
+	ask = used = 0;
+
+	err2 = __xfs_ag_resv_init(pag, XFS_AG_RESV_AGFL, ask, used);
+	if (err2 && !error)
+		error = err2;
+
+	return error;
+}
+
+/* Allocate a block from the reservation. */
+void
+xfs_ag_resv_alloc_extent(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type,
+	struct xfs_alloc_arg		*args)
+{
+	struct xfs_ag_resv		*resv;
+	xfs_extlen_t			len;
+	uint				field;
+
+	trace_xfs_ag_resv_alloc_extent(pag, type, args->len);
+
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+	case XFS_AG_RESV_AGFL:
+		resv = xfs_perag_resv(pag, type);
+		break;
+	default:
+		ASSERT(0);
+		/* fall through */
+	case XFS_AG_RESV_NONE:
+		field = args->wasdel ? XFS_TRANS_SB_RES_FDBLOCKS :
+				       XFS_TRANS_SB_FDBLOCKS;
+		xfs_trans_mod_sb(args->tp, field, -(int64_t)args->len);
+		return;
+	}
+
+	len = min_t(xfs_extlen_t, args->len, resv->ar_reserved);
+	resv->ar_reserved -= len;
+	if (type == XFS_AG_RESV_AGFL)
+		return;
+	/* Allocations of reserved blocks only need on-disk sb updates... */
+	xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_RES_FDBLOCKS, -(int64_t)len);
+	/* ...but non-reserved blocks need in-core and on-disk updates. */
+	if (args->len > len)
+		xfs_trans_mod_sb(args->tp, XFS_TRANS_SB_FDBLOCKS,
+				-((int64_t)args->len - len));
+}
+
+/* Free a block to the reservation. */
+void
+xfs_ag_resv_free_extent(
+	struct xfs_perag		*pag,
+	enum xfs_ag_resv_type		type,
+	struct xfs_trans		*tp,
+	xfs_extlen_t			len)
+{
+	xfs_extlen_t			leftover;
+	struct xfs_ag_resv		*resv;
+
+	trace_xfs_ag_resv_free_extent(pag, type, len);
+
+	switch (type) {
+	case XFS_AG_RESV_METADATA:
+	case XFS_AG_RESV_AGFL:
+		resv = xfs_perag_resv(pag, type);
+		break;
+	default:
+		ASSERT(0);
+		/* fall through */
+	case XFS_AG_RESV_NONE:
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (int64_t)len);
+		return;
+	}
+
+	leftover = min_t(xfs_extlen_t, len, resv->ar_asked - resv->ar_reserved);
+	resv->ar_reserved += leftover;
+	if (type == XFS_AG_RESV_AGFL)
+		return;
+	/* Freeing into the reserved pool only requires on-disk update... */
+	xfs_trans_mod_sb(tp, XFS_TRANS_SB_RES_FDBLOCKS, len);
+	/* ...but freeing beyond that requires in-core and on-disk update. */
+	if (len > leftover)
+		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, len - leftover);
+}
diff --git a/libxfs/xfs_ag_resv.h b/libxfs/xfs_ag_resv.h
new file mode 100644
index 0000000..8d6c687
--- /dev/null
+++ b/libxfs/xfs_ag_resv.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (C) 2016 Oracle.  All Rights Reserved.
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
+#ifndef __XFS_AG_RESV_H__
+#define	__XFS_AG_RESV_H__
+
+int xfs_ag_resv_free(struct xfs_perag *pag);
+int xfs_ag_resv_init(struct xfs_perag *pag);
+
+bool xfs_ag_resv_critical(struct xfs_perag *pag, enum xfs_ag_resv_type type);
+xfs_extlen_t xfs_ag_resv_needed(struct xfs_perag *pag,
+		enum xfs_ag_resv_type type);
+
+void xfs_ag_resv_alloc_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
+		struct xfs_alloc_arg *args);
+void xfs_ag_resv_free_extent(struct xfs_perag *pag, enum xfs_ag_resv_type type,
+		struct xfs_trans *tp, xfs_extlen_t len);
+
+#endif	/* __XFS_AG_RESV_H__ */
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 8353c77..5f111dd 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -33,6 +33,7 @@
 #include "xfs_cksum.h"
 #include "xfs_trace.h"
 #include "xfs_trans.h"
+#include "xfs_ag_resv.h"
 
 struct workqueue_struct *xfs_alloc_wq;
 
@@ -70,14 +71,8 @@ xfs_prealloc_blocks(
  * extents need to be actually allocated. To get around this, we explicitly set
  * aside a few blocks which will not be reserved in delayed allocation.
  *
- * When rmap is disabled, we need to reserve 4 fsbs _per AG_ for the freelist
- * and 4 more to handle a potential split of the file's bmap btree.
- *
- * When rmap is enabled, we must also be able to handle two rmap btree inserts
- * to record both the file data extent and a new bmbt block.  The bmbt block
- * might not be in the same AG as the file data extent.  In the worst case
- * the bmap btree splits multiple levels and all the new blocks come from
- * different AGs, so set aside enough to handle rmap btree splits in all AGs.
+ * We need to reserve 4 fsbs _per AG_ for the freelist and 4 more to handle a
+ * potential split of the file's bmap btree.
  */
 unsigned int
 xfs_alloc_set_aside(
@@ -86,8 +81,6 @@ xfs_alloc_set_aside(
 	unsigned int		blocks;
 
 	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
-	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
-		blocks += mp->m_sb.sb_agcount * mp->m_rmap_maxlevels;
 	return blocks;
 }
 
@@ -676,12 +669,29 @@ xfs_alloc_ag_vextent(
 	xfs_alloc_arg_t	*args)	/* argument structure for allocation */
 {
 	int		error=0;
+	xfs_extlen_t	reservation;
+	xfs_extlen_t	oldmax;
 
 	ASSERT(args->minlen > 0);
 	ASSERT(args->maxlen > 0);
 	ASSERT(args->minlen <= args->maxlen);
 	ASSERT(args->mod < args->prod);
 	ASSERT(args->alignment > 0);
+
+	/*
+	 * Clamp maxlen to the amount of free space minus any reservations
+	 * that have been made.
+	 */
+	oldmax = args->maxlen;
+	reservation = xfs_ag_resv_needed(args->pag, args->resv);
+	if (args->maxlen > args->pag->pagf_freeblks - reservation)
+		args->maxlen = args->pag->pagf_freeblks - reservation;
+	if (args->maxlen == 0) {
+		args->agbno = NULLAGBLOCK;
+		args->maxlen = oldmax;
+		return 0;
+	}
+
 	/*
 	 * Branch to correct routine based on the type.
 	 */
@@ -701,12 +711,14 @@ xfs_alloc_ag_vextent(
 		/* NOTREACHED */
 	}
 
+	args->maxlen = oldmax;
+
 	if (error || args->agbno == NULLAGBLOCK)
 		return error;
 
 	ASSERT(args->len >= args->minlen);
 	ASSERT(args->len <= args->maxlen);
-	ASSERT(!args->wasfromfl || !args->isfl);
+	ASSERT(!args->wasfromfl || args->resv != XFS_AG_RESV_AGFL);
 	ASSERT(args->agbno % args->alignment == 0);
 
 	/* if not file data, insert new block into the reverse map btree */
@@ -728,12 +740,7 @@ xfs_alloc_ag_vextent(
 					      args->agbno, args->len));
 	}
 
-	if (!args->isfl) {
-		xfs_trans_mod_sb(args->tp, args->wasdel ?
-				 XFS_TRANS_SB_RES_FDBLOCKS :
-				 XFS_TRANS_SB_FDBLOCKS,
-				 -((long)(args->len)));
-	}
+	xfs_ag_resv_alloc_extent(args->pag, args->resv, args);
 
 	XFS_STATS_INC(args->mp, xs_allocx);
 	XFS_STATS_ADD(args->mp, xs_allocb, args->len);
@@ -1597,7 +1604,8 @@ xfs_alloc_ag_vextent_small(
 	 * to respect minleft even when pulling from the
 	 * freelist.
 	 */
-	else if (args->minlen == 1 && args->alignment == 1 && !args->isfl &&
+	else if (args->minlen == 1 && args->alignment == 1 &&
+		 args->resv != XFS_AG_RESV_AGFL &&
 		 (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount)
 		  > args->minleft)) {
 		error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
@@ -1626,7 +1634,8 @@ xfs_alloc_ag_vextent_small(
 			/*
 			 * If we're feeding an AGFL block to something that
 			 * doesn't live in the free space, we need to clear
-			 * out the OWN_AG rmap.
+			 * out the OWN_AG rmap and add the block back to
+			 * the AGFL per-AG reservation.
 			 */
 			xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_AG);
 			error = xfs_rmap_free(args->tp, args->agbp, args->agno,
@@ -1634,6 +1643,8 @@ xfs_alloc_ag_vextent_small(
 			if (error)
 				goto error0;
 			pag = xfs_perag_get(args->mp, args->agno);
+			xfs_ag_resv_free_extent(pag, XFS_AG_RESV_AGFL,
+					args->tp, 1);
 			xfs_perag_put(pag);
 
 			*stat = 0;
@@ -1682,7 +1693,7 @@ xfs_free_ag_extent(
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
 	struct xfs_owner_info	*oinfo,
-	int			isfl)
+	enum xfs_ag_resv_type	type)
 {
 	xfs_btree_cur_t	*bno_cur;	/* cursor for by-block btree */
 	xfs_btree_cur_t	*cnt_cur;	/* cursor for by-size btree */
@@ -1910,21 +1921,22 @@ xfs_free_ag_extent(
 	 */
 	pag = xfs_perag_get(mp, agno);
 	error = xfs_alloc_update_counters(tp, pag, agbp, len);
+	xfs_ag_resv_free_extent(pag, type, tp, len);
 	xfs_perag_put(pag);
 	if (error)
 		goto error0;
 
-	if (!isfl)
-		xfs_trans_mod_sb(tp, XFS_TRANS_SB_FDBLOCKS, (long)len);
 	XFS_STATS_INC(mp, xs_freex);
 	XFS_STATS_ADD(mp, xs_freeb, len);
 
-	trace_xfs_free_extent(mp, agno, bno, len, isfl, haveleft, haveright);
+	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
+			haveleft, haveright);
 
 	return 0;
 
  error0:
-	trace_xfs_free_extent(mp, agno, bno, len, isfl, -1, -1);
+	trace_xfs_free_extent(mp, agno, bno, len, type == XFS_AG_RESV_AGFL,
+			-1, -1);
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	if (cnt_cur)
@@ -1949,21 +1961,43 @@ xfs_alloc_compute_maxlevels(
 }
 
 /*
- * Find the length of the longest extent in an AG.
+ * Find the length of the longest extent in an AG.  The 'need' parameter
+ * specifies how much space we're going to need for the AGFL and the
+ * 'reserved' parameter tells us how many blocks in this AG are reserved for
+ * other callers.
  */
 xfs_extlen_t
 xfs_alloc_longest_free_extent(
 	struct xfs_mount	*mp,
 	struct xfs_perag	*pag,
-	xfs_extlen_t		need)
+	xfs_extlen_t		need,
+	xfs_extlen_t		reserved)
 {
 	xfs_extlen_t		delta = 0;
 
+	/*
+	 * If the AGFL needs a recharge, we'll have to subtract that from the
+	 * longest extent.
+	 */
 	if (need > pag->pagf_flcount)
 		delta = need - pag->pagf_flcount;
 
+	/*
+	 * If we cannot maintain others' reservations with space from the
+	 * not-longest freesp extents, we'll have to subtract /that/ from
+	 * the longest extent too.
+	 */
+	if (pag->pagf_freeblks - pag->pagf_longest < reserved)
+		delta += reserved - (pag->pagf_freeblks - pag->pagf_longest);
+
+	/*
+	 * If the longest extent is long enough to satisfy all the
+	 * reservations and AGFL rules in place, we can return this extent.
+	 */
 	if (pag->pagf_longest > delta)
 		return pag->pagf_longest - delta;
+
+	/* Otherwise, let the caller try for 1 block if there's space. */
 	return pag->pagf_flcount > 0 || pag->pagf_longest > 0;
 }
 
@@ -2003,20 +2037,24 @@ xfs_alloc_space_available(
 {
 	struct xfs_perag	*pag = args->pag;
 	xfs_extlen_t		longest;
+	xfs_extlen_t		reservation; /* blocks that are still reserved */
 	int			available;
 
 	if (flags & XFS_ALLOC_FLAG_FREEING)
 		return true;
 
+	reservation = xfs_ag_resv_needed(pag, args->resv);
+
 	/* do we have enough contiguous free space for the allocation? */
-	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free);
+	longest = xfs_alloc_longest_free_extent(args->mp, pag, min_free,
+			reservation);
 	if ((args->minlen + args->alignment + args->minalignslop - 1) > longest)
 		return false;
 
-	/* do have enough free space remaining for the allocation? */
+	/* do we have enough free space remaining for the allocation? */
 	available = (int)(pag->pagf_freeblks + pag->pagf_flcount -
-			  min_free - args->total);
-	if (available < (int)args->minleft)
+			  reservation - min_free - args->total);
+	if (available < (int)args->minleft || available <= 0)
 		return false;
 
 	return true;
@@ -2123,7 +2161,7 @@ xfs_alloc_fix_freelist(
 		if (error)
 			goto out_agbp_relse;
 		error = xfs_free_ag_extent(tp, agbp, args->agno, bno, 1,
-					   &targs.oinfo, 1);
+					   &targs.oinfo, XFS_AG_RESV_AGFL);
 		if (error)
 			goto out_agbp_relse;
 		bp = xfs_btree_get_bufs(mp, tp, args->agno, bno, 0);
@@ -2134,7 +2172,7 @@ xfs_alloc_fix_freelist(
 	targs.mp = mp;
 	targs.agbp = agbp;
 	targs.agno = args->agno;
-	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
+	targs.alignment = targs.minlen = targs.prod = 1;
 	targs.type = XFS_ALLOCTYPE_THIS_AG;
 	targs.pag = pag;
 	error = xfs_alloc_read_agfl(mp, tp, targs.agno, &agflbp);
@@ -2145,6 +2183,7 @@ xfs_alloc_fix_freelist(
 	while (pag->pagf_flcount < need) {
 		targs.agbno = 0;
 		targs.maxlen = need - pag->pagf_flcount;
+		targs.resv = XFS_AG_RESV_AGFL;
 
 		/* Allocate as many blocks as possible at once. */
 		error = xfs_alloc_ag_vextent(&targs);
@@ -2826,7 +2865,8 @@ xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
-	struct xfs_owner_info	*oinfo)	/* extent owner */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
+	enum xfs_ag_resv_type	type)	/* block reservation type */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_buf		*agbp;
@@ -2835,6 +2875,7 @@ xfs_free_extent(
 	int			error;
 
 	ASSERT(len != 0);
+	ASSERT(type != XFS_AG_RESV_AGFL);
 
 	if (XFS_TEST_ERROR(false, mp,
 			XFS_ERRTAG_FREE_EXTENT,
@@ -2852,7 +2893,7 @@ xfs_free_extent(
 		agbno + len <= be32_to_cpu(XFS_BUF_TO_AGF(agbp)->agf_length),
 				err);
 
-	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, 0);
+	error = xfs_free_ag_extent(tp, agbp, agno, agbno, len, oinfo, type);
 	if (error)
 		goto err;
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 6fe2d6b..f7c5201 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -87,10 +87,10 @@ typedef struct xfs_alloc_arg {
 	xfs_alloctype_t	otype;		/* original allocation type */
 	char		wasdel;		/* set if allocation was prev delayed */
 	char		wasfromfl;	/* set if allocation is from freelist */
-	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* mask defining userdata treatment */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
 	struct xfs_owner_info	oinfo;	/* owner of blocks being allocated */
+	enum xfs_ag_resv_type	resv;	/* block reservation to use */
 } xfs_alloc_arg_t;
 
 /*
@@ -106,7 +106,8 @@ unsigned int xfs_alloc_set_aside(struct xfs_mount *mp);
 unsigned int xfs_alloc_ag_max_usable(struct xfs_mount *mp);
 
 xfs_extlen_t xfs_alloc_longest_free_extent(struct xfs_mount *mp,
-		struct xfs_perag *pag, xfs_extlen_t need);
+		struct xfs_perag *pag, xfs_extlen_t need,
+		xfs_extlen_t reserved);
 unsigned int xfs_alloc_min_freelist(struct xfs_mount *mp,
 		struct xfs_perag *pag);
 
@@ -184,7 +185,8 @@ xfs_free_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_fsblock_t		bno,	/* starting block number of extent */
 	xfs_extlen_t		len,	/* length of extent */
-	struct xfs_owner_info	*oinfo);/* extent owner */
+	struct xfs_owner_info	*oinfo,	/* extent owner */
+	enum xfs_ag_resv_type	type);	/* block reservation type */
 
 int				/* error */
 xfs_alloc_lookup_ge(
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 7da6b60..a50a8af 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -39,6 +39,7 @@
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
 #include "xfs_rmap.h"
+#include "xfs_ag_resv.h"
 
 
 kmem_zone_t		*xfs_bmap_free_item_zone;
@@ -3493,7 +3494,8 @@ xfs_bmap_longest_free_extent(
 	}
 
 	longest = xfs_alloc_longest_free_extent(mp, pag,
-					xfs_alloc_min_freelist(mp, pag));
+				xfs_alloc_min_freelist(mp, pag),
+				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 	if (*blen < longest)
 		*blen = longest;
 
@@ -3773,7 +3775,7 @@ xfs_bmap_btalloc(
 	}
 	args.minleft = ap->minleft;
 	args.wasdel = ap->wasdel;
-	args.isfl = 0;
+	args.resv = XFS_AG_RESV_NONE;
 	args.userdata = ap->userdata;
 	if (ap->userdata & XFS_ALLOC_USERDATA_ZERO)
 		args.ip = ap->ip;
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 642e3bb..7bf6040 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -131,7 +131,7 @@ xfs_inobt_free_block(
 	xfs_rmap_ag_owner(&oinfo, XFS_RMAP_OWN_INOBT);
 	return xfs_free_extent(cur->bc_tp,
 			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1,
-			&oinfo);
+			&oinfo, XFS_AG_RESV_NONE);
 }
 
 STATIC int

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
