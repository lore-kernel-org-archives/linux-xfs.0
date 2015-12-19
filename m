Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AD848809B
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:07 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 73A6630405F
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:04 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id UsDErya6kvLFJjbM (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:00:57 -0800 (PST)
Subject: [PATCH 41/76] xfs: define the on-disk refcount btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:00:53 -0800
Message-ID: <20151219090053.12713.42826.stgit@birch.djwong.org>
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

Start constructing the refcount btree implementation by establishing
the on-disk format and everything needed to read, write, and
manipulate the refcount btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_btree.c          |    3 +
 fs/xfs/libxfs/xfs_btree.h          |    3 +
 fs/xfs/libxfs/xfs_format.h         |   32 +++++++
 fs/xfs/libxfs/xfs_refcount_btree.c |  173 ++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount_btree.h |   65 ++++++++++++++
 fs/xfs/libxfs/xfs_sb.c             |    9 ++
 fs/xfs/libxfs/xfs_shared.h         |    2 
 fs/xfs/xfs_mount.h                 |    2 
 fs/xfs/xfs_trace.h                 |   11 --
 10 files changed, 291 insertions(+), 10 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_refcount_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9391080..9bac577 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -53,6 +53,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_log_rlimit.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_refcount_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 03ff4e4..79b8137 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1134,6 +1134,9 @@ xfs_btree_set_refs(
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
index ec37ac7..0ca80d3 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -43,6 +43,7 @@ union xfs_btree_key {
 	xfs_alloc_key_t			alloc;
 	struct xfs_inobt_key		inobt;
 	struct xfs_rmap_key		rmap;
+	struct xfs_refcount_key		refc;
 };
 
 union xfs_btree_rec {
@@ -51,6 +52,7 @@ union xfs_btree_rec {
 	struct xfs_alloc_rec		alloc;
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
+	struct xfs_refcount_rec		refc;
 };
 
 /*
@@ -217,6 +219,7 @@ typedef struct xfs_btree_cur
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
 		struct xfs_rmap_irec	r;
+		struct xfs_refcount_irec	rc;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 611083e..7482531 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1509,6 +1509,38 @@ xfs_owner_info_pack(
 
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
index 0000000..7067a05
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -0,0 +1,173 @@
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
+			cur->bc_private.a.flist);
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
+	} else if (level >= mp->m_ag_maxlevels)
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
+/**
+ * xfs_refcountbt_init_cursor() -- Allocate a new refcount btree cursor.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ */
+struct xfs_btree_cur *
+xfs_refcountbt_init_cursor(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	struct xfs_bmap_free	*flist)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	ASSERT(agno != NULLAGNUMBER);
+	ASSERT(agno < mp->m_sb.sb_agcount);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
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
+	cur->bc_private.a.flist = flist;
+	cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	return cur;
+}
+
+/**
+ * xfs_refcountbt_maxrecs() -- Calculate number of records in a refcount
+ *			       btree block.
+ * @mp: XFS mount object
+ * @blocklen: Length of block, in bytes.
+ * @leaf: true if this is a leaf btree block, false otherwise
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
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.h b/fs/xfs/libxfs/xfs_refcount_btree.h
new file mode 100644
index 0000000..d51dc1a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_refcount_btree.h
@@ -0,0 +1,65 @@
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
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
+		struct xfs_bmap_free *flist);
+extern int xfs_refcountbt_maxrecs(struct xfs_mount *mp, int blocklen,
+		bool leaf);
+
+#endif	/* __XFS_REFCOUNT_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 2590c89..c195ea7 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -37,6 +37,8 @@
 #include "xfs_ialloc_btree.h"
 #include "xfs_log.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -738,6 +740,13 @@ xfs_sb_mount_common(
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
index fa2bb9b..bffef9e 100644
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
@@ -216,6 +217,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
+#define	XFS_REFC_BTREE_REF	1
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index edced9c..caed8d3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -92,6 +92,8 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_refc_mxr[2];	/* max refc btree records */
+	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1c91439..11b159a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -38,16 +38,7 @@ struct xlog_recover_item;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
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
