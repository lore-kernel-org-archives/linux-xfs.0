Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D03897CBC
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:33:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 370DAAC004
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:33:19 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OR0GKVH3UmZwSHsU (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:33:16 -0700 (PDT)
Subject: [PATCH 11/71] xfs: define the on-disk refcount btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:33:09 -0700
Message-ID: <147216798906.867.6348942755846510156.stgit@birch.djwong.org>
In-Reply-To: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
References: <147216791538.867.12413509832420924168.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Start constructing the refcount btree implementation by establishing
the on-disk format and everything needed to read, write, and
manipulate the refcount btree blocks.

v2: Calculate a separate maxlevels for the refcount btree.

v3: Enable the tracking of per-cursor stats for refcount btrees.
The refcount update code will use this to guess if it's time to
split a refcountbt update across two transactions to avoid
exhausing the transaction reservation.

xfs_refcountbt_init_cursor can be called under the ilock, so
use KM_NOFS to prevent fs activity with a lock held.  This
should shut up some of the lockdep warnings.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
[hch: allocate the cursor with KM_NOFS to quiet lockdep]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_btree.c          |    3 +
 fs/xfs/libxfs/xfs_btree.h          |   12 ++
 fs/xfs/libxfs/xfs_format.h         |   32 ++++++
 fs/xfs/libxfs/xfs_refcount_btree.c |  178 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |   67 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.c             |    9 ++
 fs/xfs/libxfs/xfs_shared.h         |    2 
 fs/xfs/libxfs/xfs_trans_resv.c     |    2 
 fs/xfs/libxfs/xfs_trans_resv.h     |    1 
 fs/xfs/xfs_mount.c                 |    2 
 fs/xfs/xfs_mount.h                 |    3 +
 fs/xfs/xfs_ondisk.h                |    3 +
 fs/xfs/xfs_trace.h                 |   11 --
 14 files changed, 315 insertions(+), 11 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 584e87e..8d749f2 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -55,6 +55,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_ag_resv.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_refcount_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index e860002..2552c03 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1217,6 +1217,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_RMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_REFC:
+		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 81ee006..eb20376 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -49,6 +49,7 @@ union xfs_btree_key {
 	struct xfs_inobt_key		inobt;
 	struct xfs_rmap_key		rmap;
 	struct xfs_rmap_key		__rmap_bigkey[2];
+	struct xfs_refcount_key		refc;
 };
 
 union xfs_btree_rec {
@@ -57,6 +58,7 @@ union xfs_btree_rec {
 	struct xfs_alloc_rec		alloc;
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
+	struct xfs_refcount_rec		refc;
 };
 
 /*
@@ -221,6 +223,15 @@ union xfs_btree_irec {
 	struct xfs_bmbt_irec		b;
 	struct xfs_inobt_rec_incore	i;
 	struct xfs_rmap_irec		r;
+	struct xfs_refcount_irec	rc;
+};
+
+/* Per-AG btree private information. */
+union xfs_btree_cur_private {
+	struct {
+		unsigned long	nr_ops;		/* # record updates */
+		int		shape_changes;	/* # of extent splits */
+	} refc;
 };
 
 /*
@@ -247,6 +258,7 @@ typedef struct xfs_btree_cur
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
 			struct xfs_defer_ops *dfops;	/* deferred updates */
 			xfs_agnumber_t	agno;	/* ag number */
+			union xfs_btree_cur_private	priv;
 		} a;
 		struct {			/* needed for BMAP */
 			struct xfs_inode *ip;	/* pointer to our inode */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index fbcd99f..f8b3c1d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1456,6 +1456,38 @@ typedef __be32 xfs_rmap_ptr_t;
 
 unsigned int xfs_refc_block(struct xfs_mount *mp);
 
+/*
+ * Data record/key structure
+ *
+ * Each record associates a range of physical blocks (starting at
+ * rc_startblock and ending rc_blockcount blocks later) with a
+ * reference count (rc_refcount).  A record is only stored in the
+ * btree if the refcount is > 2.  An entry in the free block btree
+ * means that the refcount is 0, and no entries anywhere means that
+ * the refcount is 1, as was true in XFS before reflinking.
+ */
+struct xfs_refcount_rec {
+	__be32		rc_startblock;	/* starting block number */
+	__be32		rc_blockcount;	/* count of blocks */
+	__be32		rc_refcount;	/* number of inodes linked here */
+};
+
+struct xfs_refcount_key {
+	__be32		rc_startblock;	/* starting block number */
+};
+
+struct xfs_refcount_irec {
+	xfs_agblock_t	rc_startblock;	/* starting block number */
+	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
+	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
+};
+
+#define MAXREFCOUNT	((xfs_nlink_t)~0U)
+#define MAXREFCEXTLEN	((xfs_extlen_t)~0U)
+
+/* btree pointer type */
+typedef __be32 xfs_refcount_ptr_t;
+
 
 /*
  * BMAP Btree format definitions
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
new file mode 100644
index 0000000..359cf0c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -0,0 +1,178 @@
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
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+
+static struct xfs_btree_cur *
+xfs_refcountbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_refcountbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno,
+			cur->bc_private.a.dfops);
+}
+
+STATIC bool
+xfs_refcountbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+	unsigned int		level;
+
+	if (block->bb_magic != cpu_to_be32(XFS_REFC_CRC_MAGIC))
+		return false;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (!xfs_btree_sblock_v5hdr_verify(bp))
+		return false;
+
+	level = be16_to_cpu(block->bb_level);
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_refcount_level)
+			return false;
+	} else if (level >= mp->m_refc_maxlevels)
+		return false;
+
+	return xfs_btree_sblock_verify(bp, mp->m_refc_mxr[level != 0]);
+}
+
+STATIC void
+xfs_refcountbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, -EFSBADCRC);
+	else if (!xfs_refcountbt_verify(bp))
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
+	}
+}
+
+STATIC void
+xfs_refcountbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_refcountbt_verify(bp)) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp);
+		return;
+	}
+	xfs_btree_sblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
+	.name			= "xfs_refcountbt",
+	.verify_read		= xfs_refcountbt_read_verify,
+	.verify_write		= xfs_refcountbt_write_verify,
+};
+
+static const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.rec_len		= sizeof(struct xfs_refcount_rec),
+	.key_len		= sizeof(struct xfs_refcount_key),
+
+	.dup_cursor		= xfs_refcountbt_dup_cursor,
+	.buf_ops		= &xfs_refcountbt_buf_ops,
+};
+
+/*
+ * Allocate a new refcount btree cursor.
+ */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	struct xfs_defer_ops	*dfops)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_REFC;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ops = &xfs_refcountbt_ops;
+
+	cur->bc_nlevels = be32_to_cpu(agf->agf_refcount_level);
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+	cur->bc_private.a.dfops = dfops;
+	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	cur->bc_private.a.priv.refc.nr_ops = 0;
+	cur->bc_private.a.priv.refc.shape_changes = 0;
+
+	return cur;
+}
+
+/*
+ * Calculate the number of records in a refcount btree block.
+ */
+int
+xfs_refcountbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	bool			leaf)
+{
+	blocklen -= XFS_REFCOUNT_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_refcount_rec);
+	return blocklen / (sizeof(struct xfs_refcount_key) +
+			   sizeof(xfs_refcount_ptr_t));
+}
+
+/* Compute the maximum height of a refcount btree. */
+void
+xfs_refcountbt_compute_maxlevels(
+	struct xfs_mount		*mp)
+{
+	mp->m_refc_maxlevels = xfs_btree_compute_maxlevels(mp,
+			mp->m_refc_mnr, mp->m_sb.sb_agblocks);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
new file mode 100644
index 0000000..9e9ad7c
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -0,0 +1,67 @@
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
+#ifndef __XFS_REFCOUNT_BTREE_H__
+#define	__XFS_REFCOUNT_BTREE_H__
+
+/*
+ * Reference Count Btree on-disk structures
+ */
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+/*
+ * Btree block header size
+ */
+#define XFS_REFCOUNT_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_REFCOUNT_REC_ADDR(block, index) \
+	((struct xfs_refcount_rec *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct xfs_refcount_rec))))
+
+#define XFS_REFCOUNT_KEY_ADDR(block, index) \
+	((struct xfs_refcount_key *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(struct xfs_refcount_key)))
+
+#define XFS_REFCOUNT_PTR_ADDR(block, index, maxrecs) \
+	((xfs_refcount_ptr_t *) \
+		((char *)(block) + \
+		 XFS_REFCOUNT_BLOCK_LEN + \
+		 (maxrecs) * sizeof(struct xfs_refcount_key) + \
+		 ((index) - 1) * sizeof(xfs_refcount_ptr_t)))
+
+extern struct xfs_btree_cur *xfs_refcountbt_init_cursor(struct xfs_mount *mp,
+		struct xfs_trans *tp, struct xfs_buf *agbp, xfs_agnumber_t agno,
+		struct xfs_defer_ops *dfops);
+extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
+		bool leaf);
+extern void xfs_refcountbt_compute_maxlevels(struct xfs_mount *mp);
+
+#endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 59c9f59..a937071 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -38,6 +38,8 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -740,6 +742,13 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_refc_mxr[0] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
+			true);
+	mp->m_refc_mxr[1] = xfs_refcountbt_maxrecs(mp, sbp->sb_blocksize,
+			false);
+	mp->m_refc_mnr[0] = mp->m_refc_mxr[0] / 2;
+	mp->m_refc_mnr[1] = mp->m_refc_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 0c5b30b..c6f4eb4 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -39,6 +39,7 @@ extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
@@ -122,6 +123,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
+#define	XFS_REFC_BTREE_REF	1
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 301ef2f..7c840e1 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -73,7 +73,7 @@ xfs_calc_buf_res(
  *
  * Keep in mind that max depth is calculated separately for each type of tree.
  */
-static uint
+uint
 xfs_allocfree_log_count(
 	struct xfs_mount *mp,
 	uint		num_ops)
diff --git a/fs/xfs/libxfs/xfs_trans_resv.h b/fs/xfs/libxfs/xfs_trans_resv.h
index 0eb46ed..36a1511 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.h
+++ b/fs/xfs/libxfs/xfs_trans_resv.h
@@ -102,5 +102,6 @@ struct xfs_trans_resv {
 #define	XFS_ATTRRM_LOG_COUNT		3
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
+uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 
 #endif	/* __XFS_TRANS_RESV_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index faeead6..d556731 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -43,6 +43,7 @@
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -684,6 +685,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_compute_maxlevels(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_refcountbt_compute_maxlevels(mp);
 
 	xfs_set_maxicount(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6141d68..1572388 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -118,10 +118,13 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_refc_mxr[2];	/* max refc btree records */
+	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 69e2986..0c381d7 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -49,6 +49,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_key,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_refcount_rec,		12);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
@@ -56,6 +58,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_refcount_ptr_t,		4);
 	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
 
 	/* dir/attr trees */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 148afc6..6297bc0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -39,16 +39,7 @@ struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
 struct xfs_btree_cur;
-
-#ifndef XFS_REFCOUNT_IREC_PLACEHOLDER
-#define XFS_REFCOUNT_IREC_PLACEHOLDER
-/* Placeholder definition to avoid breaking bisectability. */
-struct xfs_refcount_irec {
-	xfs_agblock_t	rc_startblock;	/* starting block number */
-	xfs_extlen_t	rc_blockcount;	/* count of free blocks */
-	xfs_nlink_t	rc_refcount;	/* number of inodes linked here */
-};
-#endif
+struct xfs_refcount_irec;
 
 DECLARE_EVENT_CLASS(xfs_attr_list_class,
 	TP_PROTO(struct xfs_attr_list_context *ctx),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
