Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E464D7FC3
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6C4C8F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:54 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id VshUDEBHcvQfmf2s (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:52 -0800 (PST)
Subject: [PATCH 13/76] xfs: define the on-disk rmap btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:49 -0800
Message-ID: <20151219085748.12713.20678.stgit@birch.djwong.org>
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

Now we have all the surrounding call infrastructure in place, we can
start fillin gout the rmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for adding the
btree operations implementation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_btree.c      |    3 +
 fs/xfs/libxfs/xfs_btree.h      |   18 ++--
 fs/xfs/libxfs/xfs_format.h     |   27 ++++++
 fs/xfs/libxfs/xfs_rmap_btree.c |  187 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |   31 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    6 +
 fs/xfs/libxfs/xfs_shared.h     |    2 
 fs/xfs/xfs_mount.h             |    2 
 9 files changed, 269 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index c202ce3..9391080 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -52,6 +52,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
 				   xfs_rmap.o \
+				   xfs_rmap_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4ff6b80..56a84e7 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1129,6 +1129,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_BMAP:
 		xfs_buf_set_ref(bp, XFS_BMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_RMAP:
+		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0d0e546..f7a049b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -38,17 +38,19 @@ union xfs_btree_ptr {
 };
 
 union xfs_btree_key {
-	xfs_bmbt_key_t		bmbt;
-	xfs_bmdr_key_t		bmbr;	/* bmbt root block */
-	xfs_alloc_key_t		alloc;
-	xfs_inobt_key_t		inobt;
+	struct xfs_bmbt_key		bmbt;
+	xfs_bmdr_key_t			bmbr;	/* bmbt root block */
+	xfs_alloc_key_t			alloc;
+	struct xfs_inobt_key		inobt;
+	struct xfs_rmap_key		rmap;
 };
 
 union xfs_btree_rec {
-	xfs_bmbt_rec_t		bmbt;
-	xfs_bmdr_rec_t		bmbr;	/* bmbt root block */
-	xfs_alloc_rec_t		alloc;
-	xfs_inobt_rec_t		inobt;
+	struct xfs_bmbt_rec		bmbt;
+	xfs_bmdr_rec_t			bmbr;	/* bmbt root block */
+	struct xfs_alloc_rec		alloc;
+	struct xfs_inobt_rec		inobt;
+	struct xfs_rmap_rec		rmap;
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index a751ee6..991d67f 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1377,6 +1377,33 @@ XFS_RMAP_INO_OWNER(
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
 
+/*
+ * Data record structure
+ */
+struct xfs_rmap_rec {
+	__be32		rm_startblock;	/* extent start block */
+	__be32		rm_blockcount;	/* extent length */
+	__be64		rm_owner;	/* extent owner */
+};
+
+struct xfs_rmap_irec {
+	xfs_agblock_t	rm_startblock;	/* extent start block */
+	xfs_extlen_t	rm_blockcount;	/* extent length */
+	__uint64_t	rm_owner;	/* extent owner */
+};
+
+/*
+ * Key structure
+ *
+ * We don't use the length for lookups
+ */
+struct xfs_rmap_key {
+	__be32		rm_startblock;	/* extent start block */
+};
+
+/* btree pointer type */
+typedef __be32 xfs_rmap_ptr_t;
+
 #define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
new file mode 100644
index 0000000..9a02699
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -0,0 +1,187 @@
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
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_btree.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_error.h"
+#include "xfs_extent_busy.h"
+
+static struct xfs_btree_cur *
+xfs_rmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+}
+
+static bool
+xfs_rmapbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+	unsigned int		level;
+
+	/*
+	 * magic number and level verification
+	 *
+	 * During growfs operations, we can't verify the exact level or owner as
+	 * the perag is not fully initialised and hence not attached to the
+	 * buffer.  In this case, check against the maximum tree depth.
+	 *
+	 * Similarly, during log recovery we will have a perag structure
+	 * attached, but the agf information will not yet have been initialised
+	 * from the on disk AGF. Again, we can only check against maximum limits
+	 * in this case.
+	 */
+	if (block->bb_magic!= cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+		return false;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return false;
+	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
+		return false;
+	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		return false;
+
+	level = be16_to_cpu(block->bb_level);
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+			return false;
+	} else if (level >= mp->m_ag_maxlevels)
+		return false;
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rmap_mxr[level != 0])
+		return false;
+
+	/* sibling pointer verification */
+	if (!block->bb_u.s.bb_leftsib ||
+	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
+	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
+		return false;
+	if (!block->bb_u.s.bb_rightsib ||
+	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
+	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
+		return false;
+
+	return true;
+}
+
+static void
+xfs_rmapbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, -EFSBADCRC);
+	else if (!xfs_rmapbt_verify(bp))
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
+	}
+}
+
+static void
+xfs_rmapbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_rmapbt_verify(bp)) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp);
+		return;
+	}
+	xfs_btree_sblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
+	.verify_read = xfs_rmapbt_read_verify,
+	.verify_write = xfs_rmapbt_write_verify,
+};
+
+static const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= sizeof(struct xfs_rmap_key),
+
+	.dup_cursor		= xfs_rmapbt_dup_cursor,
+	.buf_ops		= &xfs_rmapbt_buf_ops,
+};
+
+/*
+ * Allocate a new allocation btree cursor.
+ */
+struct xfs_btree_cur *
+xfs_rmapbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_RMAP;
+	cur->bc_flags = XFS_BTREE_CRC_BLOCKS;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ops = &xfs_rmapbt_ops;
+	cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+
+	return cur;
+}
+
+/*
+ * Calculate number of records in an rmap btree block.
+ */
+int
+xfs_rmapbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= XFS_RMAP_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(struct xfs_rmap_rec);
+	return blocklen /
+		(sizeof(struct xfs_rmap_key) + sizeof(xfs_rmap_ptr_t));
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index a3b8f90..2e02362 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -19,6 +19,37 @@
 #define	__XFS_RMAP_BTREE_H__
 
 struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+/* rmaps only exist on crc enabled filesystems */
+#define XFS_RMAP_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_RMAP_REC_ADDR(block, index) \
+	((struct xfs_rmap_rec *) \
+		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(struct xfs_rmap_rec))))
+
+#define XFS_RMAP_KEY_ADDR(block, index) \
+	((struct xfs_rmap_key *) \
+		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(struct xfs_rmap_key)))
+
+#define XFS_RMAP_PTR_ADDR(block, index, maxrecs) \
+	((xfs_rmap_ptr_t *) \
+		((char *)(block) + XFS_RMAP_BLOCK_LEN + \
+		 (maxrecs) * sizeof(struct xfs_rmap_key) + \
+		 ((index) - 1) * sizeof(xfs_rmap_ptr_t)))
+
+struct xfs_btree_cur *xfs_rmapbt_init_cursor(struct xfs_mount *mp,
+				struct xfs_trans *tp, struct xfs_buf *bp,
+				xfs_agnumber_t agno);
+int xfs_rmapbt_maxrecs(struct xfs_mount *mp, int blocklen, int leaf);
 
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a0b071d..7c3eb6c 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -36,6 +36,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_log.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -727,6 +728,11 @@ xfs_sb_mount_common(
 	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
 	mp->m_bmap_dmnr[1] = mp->m_bmap_dmxr[1] / 2;
 
+	mp->m_rmap_mxr[0] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_rmap_mxr[1] = xfs_rmapbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
+	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 544d0e9..fa2bb9b 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -38,6 +38,7 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
 extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
@@ -210,6 +211,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_BTREE_REF	3
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
+#define	XFS_RMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 77def45..6b52575 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -90,6 +90,8 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_inobt_mxr[2];	/* max inobt btree records */
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
+	uint			m_rmap_mxr[2];	/* max rmap btree records */
+	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
