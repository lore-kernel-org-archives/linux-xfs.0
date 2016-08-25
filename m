Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4810A80DB
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:47:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0CB908F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:37 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id pdK1zsH7XlZsut20 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:47:35 -0700 (PDT)
Subject: [PATCH 09/71] xfs: define the on-disk refcount btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:47:28 -0700
Message-ID: <147216884827.4420.14285398405355006339.stgit@birch.djwong.org>
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
 include/darwin.h            |    1 
 include/freebsd.h           |    1 
 include/gnukfreebsd.h       |    1 
 include/irix.h              |    1 
 include/libxfs.h            |    1 
 include/linux.h             |    1 
 include/xfs_mount.h         |    3 +
 libxfs/Makefile             |    2 
 libxfs/init.c               |    2 
 libxfs/xfs_btree.c          |    3 +
 libxfs/xfs_btree.h          |   12 +++
 libxfs/xfs_format.h         |   32 ++++++++
 libxfs/xfs_refcount_btree.c |  177 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount_btree.h |   67 ++++++++++++++++
 libxfs/xfs_sb.c             |    9 ++
 libxfs/xfs_shared.h         |    2 
 libxfs/xfs_trans_resv.c     |    2 
 libxfs/xfs_trans_resv.h     |    1 
 18 files changed, 317 insertions(+), 1 deletion(-)
 create mode 100644 libxfs/xfs_refcount_btree.c
 create mode 100644 libxfs/xfs_refcount_btree.h


diff --git a/include/darwin.h b/include/darwin.h
index 45e0c03..140386a 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -140,6 +140,7 @@ typedef off_t		xfs_off_t;
 typedef u_int64_t	xfs_ino_t;
 typedef u_int32_t	xfs_dev_t;
 typedef int64_t		xfs_daddr_t;
+typedef u_int32_t	xfs_nlink_t;
 
 #define stat64		stat
 #define fstat64		fstat
diff --git a/include/freebsd.h b/include/freebsd.h
index 6e77427..668dcea 100644
--- a/include/freebsd.h
+++ b/include/freebsd.h
@@ -51,6 +51,7 @@ typedef off_t		off64_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
diff --git a/include/gnukfreebsd.h b/include/gnukfreebsd.h
index d55acfb..dfd31ae 100644
--- a/include/gnukfreebsd.h
+++ b/include/gnukfreebsd.h
@@ -40,6 +40,7 @@ typedef off_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
diff --git a/include/irix.h b/include/irix.h
index b92e01b..8b9d588 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -47,6 +47,7 @@ typedef off64_t		xfs_off_t;
 typedef __int64_t	xfs_ino_t;
 typedef __int32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __int32_t	xfs_nlink_t;
 
 typedef unsigned char		__u8;
 typedef signed char		__s8;
diff --git a/include/libxfs.h b/include/libxfs.h
index cf59d6c..ec8f6ab 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -79,6 +79,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/linux.h b/include/linux.h
index 5614719..1663930 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -141,6 +141,7 @@ typedef off64_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 /**
  * Abstraction of mountpoints.
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 8301b78..97b4ad7 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -66,10 +66,13 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_refc_mxr[2];	/* max refc btree records */
+	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
+	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 1b3bcca..ccfd8e9 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -36,6 +36,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_quota_defs.h \
+	xfs_refcount_btree.h \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
 	xfs_sb.h \
@@ -86,6 +87,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_refcount_btree.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
 	xfs_rtbitmap.c \
diff --git a/libxfs/init.c b/libxfs/init.c
index c13b123..706925d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -32,6 +32,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount_btree.h"
 
 #include "libxfs.h"		/* for now */
 
@@ -687,6 +688,7 @@ libxfs_mount(
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_compute_maxlevels(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
+	xfs_refcountbt_compute_maxlevels(mp);
 
 	if (sbp->sb_imax_pct) {
 		/* Make sure the maximum inode count is a multiple of the
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 3ad060f..0468a9e 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -1213,6 +1213,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_RMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_REFC:
+		xfs_buf_set_ref(bp, XFS_REFC_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 81ee006..eb20376 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b028466..6c81ce7 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
new file mode 100644
index 0000000..a7b99e4
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.c
@@ -0,0 +1,177 @@
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
+#include "xfs_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc.h"
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
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
new file mode 100644
index 0000000..9e9ad7c
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 0a1462f..de25489 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -35,6 +35,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
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
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 0c5b30b..c6f4eb4 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
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
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 2ed80a5..10234bb 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -72,7 +72,7 @@ xfs_calc_buf_res(
  *
  * Keep in mind that max depth is calculated separately for each type of tree.
  */
-static uint
+uint
 xfs_allocfree_log_count(
 	struct xfs_mount *mp,
 	uint		num_ops)
diff --git a/libxfs/xfs_trans_resv.h b/libxfs/xfs_trans_resv.h
index 0eb46ed..36a1511 100644
--- a/libxfs/xfs_trans_resv.h
+++ b/libxfs/xfs_trans_resv.h
@@ -102,5 +102,6 @@ struct xfs_trans_resv {
 #define	XFS_ATTRRM_LOG_COUNT		3
 
 void xfs_trans_resv_calc(struct xfs_mount *mp, struct xfs_trans_resv *resp);
+uint xfs_allocfree_log_count(struct xfs_mount *mp, uint num_ops);
 
 #endif	/* __XFS_TRANS_RESV_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
