Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B23F08164
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:04:42 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 783418F8039
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:42 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id kEVIp3w2gfCuz74E (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:04:39 -0800 (PST)
Subject: [PATCH 74/76] xfs: set up per-AG preallocated block pools
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:04:36 -0800
Message-ID: <20151219090436.12713.63259.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

One unfortunate quirk of the reference count btree -- it can expand in
size when blocks are written to *other* allocation groups if, say, one
large extent becomes a lot of tiny extents.  Since we don't want to
start throwing errors in the middle of CoWing, establish a pool of
reserved blocks in each AG to feed such an expansion.  Reserved pools
can be large enough to obviate the need for external allocations and
use EFI/EFDs so that the the reserved blocks will be freed if the
system crashes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_perag_pool.c |  379 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_perag_pool.h |   47 +++++
 fs/xfs/xfs_trace.h             |   15 ++
 4 files changed, 442 insertions(+)
 create mode 100644 fs/xfs/libxfs/xfs_perag_pool.c
 create mode 100644 fs/xfs/libxfs/xfs_perag_pool.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 798e2b0..d2ab008 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -51,6 +51,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_fork.o \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
+				   xfs_perag_pool.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
 				   xfs_refcount.o \
diff --git a/fs/xfs/libxfs/xfs_perag_pool.c b/fs/xfs/libxfs/xfs_perag_pool.c
new file mode 100644
index 0000000..b49ffd2
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_perag_pool.c
@@ -0,0 +1,379 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
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
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_perag_pool.h"
+#include "xfs_trans_space.h"
+
+/**
+ * xfs_perag_pool_free() -- Free a per-AG reserved block pool.
+ */
+int
+xfs_perag_pool_free(
+	struct xfs_perag_pool		*p)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe, *n;
+	struct xfs_trans		*tp;
+	xfs_fsblock_t			fsb;
+	struct xfs_bmap_free		freelist;
+	int				committed;
+	int				error = 0, err;
+
+	if (!p)
+		return 0;
+
+	mp = p->pp_mount;
+	list_for_each_entry_safe(ppe, n, &p->pp_entries, ppe_list) {
+		list_del(&ppe->ppe_list);
+		if (XFS_FORCED_SHUTDOWN(mp)) {
+			kmem_free(ppe);
+			continue;
+		}
+
+		/* Set up transaction. */
+		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		tp->t_flags |= XFS_TRANS_RESERVE;
+		err = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, 0, 0);
+		if (err)
+			goto loop_cancel;
+		xfs_bmap_init(&freelist, &fsb);
+		fsb = XFS_AGB_TO_FSB(p->pp_mount, p->pp_agno, ppe->ppe_bno);
+
+		trace_xfs_perag_pool_free_extent(mp, p->pp_agno, ppe->ppe_bno,
+				ppe->ppe_len, &p->pp_oinfo);
+
+		/* Free the block. */
+		xfs_bmap_add_free(mp, &freelist, fsb, ppe->ppe_len,
+				&p->pp_oinfo);
+
+		err = xfs_bmap_finish(&tp, &freelist, &committed, NULL);
+		if (err)
+			goto loop_cancel;
+
+		err = xfs_trans_commit(tp);
+		if (!error)
+			error = err;
+		kmem_free(ppe);
+		continue;
+loop_cancel:
+		if (!error)
+			error = err;
+		xfs_trans_cancel(tp);
+		kmem_free(ppe);
+	}
+
+	kmem_free(p);
+	if (error)
+		trace_xfs_perag_pool_free_error(mp, p->pp_agno, error,
+				_RET_IP_);
+	return error;
+}
+
+/* Allocate a block for the pool. */
+static int
+xfs_perag_pool_grab_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_extlen_t			*len)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+	struct xfs_alloc_arg		args;
+	int				error;
+
+	mp = p->pp_mount;
+
+	/* Set up the allocation. */
+	memset(&args, 0, sizeof(args));
+	args.mp = mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.fsbno = XFS_AGB_TO_FSB(mp, p->pp_agno, p->pp_agbno);
+	args.firstblock = args.fsbno;
+	args.oinfo = p->pp_oinfo;
+	args.minlen = 1;
+
+	/* Allocate blocks. */
+	args.tp = tp;
+	args.maxlen = args.prod = *len;
+	p->pp_allocating = true;
+	error = xfs_alloc_vextent(&args);
+	p->pp_allocating = false;
+	if (error)
+		goto out_error;
+	if (args.fsbno == NULLFSBLOCK) {
+		/* oh well, we're headed towards failure. */
+		error = -ENOSPC;
+		goto out_error;
+	}
+	*len = args.len;
+
+	trace_xfs_perag_pool_grab_block(mp, p->pp_agno, args.agbno, args.len,
+			&p->pp_oinfo);
+
+	/* Add to our list. */
+	ASSERT(args.agno == p->pp_agno);
+	ppe = kmem_alloc(sizeof(struct xfs_perag_pool_entry), KM_SLEEP);
+	ppe->ppe_bno = args.agbno;
+	ppe->ppe_len = args.len;
+	list_add_tail(&ppe->ppe_list, &p->pp_entries);
+	return 0;
+
+out_error:
+	trace_xfs_perag_pool_grab_block_error(mp, p->pp_agno, error, _RET_IP_);
+	return error;
+}
+
+/* Ensure the pool has some capacity. */
+static int
+__xfs_perag_pool_ensure_capacity(
+	struct xfs_perag_pool		*p,
+	xfs_extlen_t			sz,
+	bool				force)
+{
+	struct xfs_mount		*mp = p->pp_mount;
+	struct xfs_trans		*tp;
+	struct xfs_perag		*pag;
+	uint				resblks;
+	xfs_extlen_t			alloc_len;
+	int				error;
+
+	if (sz <= p->pp_len - p->pp_inuse)
+		return 0;
+	sz -= p->pp_len - p->pp_inuse;
+
+	trace_xfs_perag_pool_ensure_capacity(mp, p->pp_agno,
+			p->pp_len - p->pp_inuse, sz, &p->pp_oinfo);
+
+	/* Do we even have enough free blocks? */
+	pag = xfs_perag_get(mp, p->pp_agno);
+	resblks = pag->pagf_freeblks;
+	xfs_perag_put(pag);
+	if (force && resblks < sz)
+		sz = resblks;
+	if (resblks < sz) {
+		error = -ENOSPC;
+		goto out_error;
+	}
+
+	while (sz) {
+		/* Set up a transaction */
+		resblks = XFS_DIOSTRAT_SPACE_RES(mp, sz);
+		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
+		error = xfs_trans_reserve(tp, &M_RES(mp)->tr_write, resblks, 0);
+		if (error)
+			goto out_cancel;
+
+		/* Allocate the blocks */
+		alloc_len = sz;
+		error = xfs_perag_pool_grab_block(p, tp, &alloc_len);
+		if (error)
+			goto out_cancel;
+
+		/* Commit the transaction */
+		error = xfs_trans_commit(tp);
+		if (error)
+			goto out_error;
+
+		p->pp_len += alloc_len;
+		sz -= alloc_len;
+	}
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+out_error:
+	trace_xfs_perag_pool_ensure_capacity_error(mp, p->pp_agno, error,
+			_RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_ensure_capacity() -- Ensure the pool has some capacity.
+ *
+ * @p: per-AG reserved blocks pool.
+ * @sz: Ensure that there are at least this many free blocks.
+ */
+int
+xfs_perag_pool_ensure_capacity(
+	struct xfs_perag_pool		*p,
+	xfs_extlen_t			sz)
+{
+	if (!p)
+		return 0;
+	return __xfs_perag_pool_ensure_capacity(p, sz, false);
+}
+
+/**
+ * xfs_perag_pool_init() -- Initialize a per-AG reserved block pool.
+ */
+int
+xfs_perag_pool_init(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			len,
+	xfs_extlen_t			inuse,
+	uint64_t			owner,
+	struct xfs_perag_pool		**pp)
+{
+	struct xfs_perag_pool		*p;
+	struct xfs_owner_info		oinfo;
+	int				error;
+
+	XFS_RMAP_AG_OWNER(&oinfo, owner);
+	trace_xfs_perag_pool_init(mp, agno, agbno, len, &oinfo);
+	trace_xfs_perag_pool_init(mp, agno, agbno, inuse, &oinfo);
+
+	p = kmem_alloc(sizeof(struct xfs_perag_pool), KM_SLEEP);
+	p->pp_mount = mp;
+	p->pp_agno = agno;
+	p->pp_agbno = agbno;
+	p->pp_inuse = p->pp_len = inuse;
+	p->pp_oinfo = oinfo;
+	p->pp_allocating = false;
+	INIT_LIST_HEAD(&p->pp_entries);
+	*pp = p;
+
+	/* Try to reserve some blocks. */
+	error = __xfs_perag_pool_ensure_capacity(p, len - inuse, true);
+	if (error == -ENOSPC)
+		error = 0;
+
+	if (error)
+		trace_xfs_perag_pool_init_error(mp, agno, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_alloc_block() -- Allocate a block from the pool.
+ *
+ * @p: Reserved block pool.
+ * @tp: Transaction to record the allocation.
+ * @bno: (out) The allocated block number.
+ */
+int
+xfs_perag_pool_alloc_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_agblock_t			*bno)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+	xfs_extlen_t			len;
+	int				error;
+
+	if (p == NULL || p->pp_allocating)
+		return -EINVAL;
+
+	mp = p->pp_mount;
+	mp = mp;
+	/* Empty pool?  Grab another block. */
+	if (list_empty(&p->pp_entries)) {
+		len = 1;
+		error = xfs_perag_pool_grab_block(p, tp, &len);
+		if (error)
+			goto err;
+		ASSERT(len == 1);
+		if (list_empty(&p->pp_entries)) {
+			error = -ENOSPC;
+			goto err;
+		}
+	}
+
+	/* Find an available block. */
+	ppe = list_first_entry(&p->pp_entries, struct xfs_perag_pool_entry,
+			ppe_list);
+	*bno = ppe->ppe_bno;
+
+	trace_xfs_perag_pool_alloc_block(mp, p->pp_agno, *bno, 1, &p->pp_oinfo);
+
+	/* Update the accounting. */
+	ppe->ppe_len--;
+	ppe->ppe_bno++;
+	if (ppe->ppe_len == 0)
+		list_del(&ppe->ppe_list);
+	p->pp_inuse++;
+
+	return 0;
+err:
+	trace_xfs_perag_pool_alloc_block_error(mp, p->pp_agno, error, _RET_IP_);
+	return error;
+}
+
+/**
+ * xfs_perag_pool_free_block() -- Put a block back in the pool.
+ *
+ * @p: Reserved block pool.
+ * @tp: Transaction to record the free operation.
+ * @bno: Block to put back.
+ */
+int
+xfs_perag_pool_free_block(
+	struct xfs_perag_pool		*p,
+	struct xfs_trans		*tp,
+	xfs_agblock_t			bno)
+{
+	struct xfs_mount		*mp;
+	struct xfs_perag_pool_entry	*ppe;
+
+	if (p == NULL)
+		return -EINVAL;
+
+	mp = p->pp_mount;
+	mp = mp;
+	trace_xfs_perag_pool_free_block(mp, p->pp_agno, bno, 1, &p->pp_oinfo);
+
+	list_for_each_entry(ppe, &p->pp_entries, ppe_list) {
+		if (ppe->ppe_bno - 1 == bno) {
+
+			/* Adjust bookkeeping. */
+			p->pp_inuse--;
+			ppe->ppe_bno--;
+			ppe->ppe_len++;
+			return 0;
+		}
+		if (ppe->ppe_bno + ppe->ppe_len == bno) {
+			p->pp_inuse--;
+			ppe->ppe_len++;
+			return 0;
+		}
+	}
+	ppe = kmem_alloc(sizeof(struct xfs_perag_pool_entry), KM_SLEEP);
+	ppe->ppe_bno = bno;
+	ppe->ppe_len = 1;
+	p->pp_inuse--;
+
+	list_add_tail(&ppe->ppe_list, &p->pp_entries);
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_perag_pool.h b/fs/xfs/libxfs/xfs_perag_pool.h
new file mode 100644
index 0000000..ecdcd2a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_perag_pool.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright (c) 2000-2001,2005 Silicon Graphics, Inc.
+ * Copyright (c) 2015 Oracle.
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
+
+struct xfs_perag_pool_entry {
+	struct list_head	ppe_list;	/* pool list */
+	xfs_agblock_t		ppe_bno;	/* AG block number */
+	xfs_extlen_t		ppe_len;	/* length */
+};
+
+struct xfs_perag_pool {
+	struct xfs_mount	*pp_mount;	/* XFS mount */
+	xfs_agnumber_t		pp_agno;	/* AG number */
+	xfs_agblock_t		pp_agbno;	/* suggested AG block number */
+	xfs_extlen_t		pp_len;		/* blocks in pool */
+	xfs_extlen_t		pp_inuse;	/* blocks in use */
+	struct xfs_owner_info	pp_oinfo;	/* owner */
+	struct list_head	pp_entries;	/* pool entries */
+	bool			pp_allocating;	/* are we allocating? */
+};
+
+int xfs_perag_pool_free(struct xfs_perag_pool *p);
+int xfs_perag_pool_init(struct xfs_mount *mp, xfs_agnumber_t agno,
+		xfs_agblock_t agbno, xfs_extlen_t len, xfs_extlen_t inuse,
+		uint64_t owner, struct xfs_perag_pool **pp);
+
+int xfs_perag_pool_ensure_capacity(struct xfs_perag_pool *p, xfs_extlen_t sz);
+
+int xfs_perag_pool_alloc_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
+		xfs_agblock_t *bno);
+int xfs_perag_pool_free_block(struct xfs_perag_pool *p, struct xfs_trans *tp,
+		xfs_agblock_t bno);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0773938..dad57dc 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3160,6 +3160,21 @@ DEFINE_INODE_EVENT(xfs_reflink_cancel_pending_cow);
 DEFINE_INODE_IREC_EVENT(xfs_reflink_cancel_cow);
 DEFINE_INODE_ERROR_EVENT(xfs_reflink_cancel_pending_cow_error);
 
+/* perag pool tracepoints */
+#define DEFINE_PERAG_POOL_EVENT	DEFINE_RMAP_EVENT
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_free_extent);
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_grab_block);
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_init);
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_ensure_capacity);
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_alloc_block);
+DEFINE_PERAG_POOL_EVENT(xfs_perag_pool_free_block);
+
+DEFINE_AG_ERROR_EVENT(xfs_perag_pool_free_error);
+DEFINE_AG_ERROR_EVENT(xfs_perag_pool_grab_block_error);
+DEFINE_AG_ERROR_EVENT(xfs_perag_pool_init_error);
+DEFINE_AG_ERROR_EVENT(xfs_perag_pool_ensure_capacity_error);
+DEFINE_AG_ERROR_EVENT(xfs_perag_pool_alloc_block_error);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
