Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E651C7D58
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:21:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5F8F1AC002
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:21:01 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SNVyi3ptusUceH6e (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:20:57 -0700 (PDT)
Subject: [PATCH 028/119] xfs: define the on-disk rmap btree format
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:20:52 -0700
Message-ID: <146612645206.12839.17008642336898856662.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now we have all the surrounding call infrastructure in place, we can
start filling out the rmap btree implementation. Start with the
on-disk btree format; add everything needed to read, write and
manipulate rmap btree blocks. This prepares the way for adding the
btree operations implementation.

[darrick: record owner and offset info in rmap btree]
[darrick: fork, bmbt and unwritten state in rmap btree]
[darrick: flags are a separate field in xfs_rmap_irec]
[darrick: calculate maxlevels separately]
[darrick: move the 'unwritten' bit into unused parts of rm_offset]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_btree.c      |    3 +
 fs/xfs/libxfs/xfs_btree.h      |   18 ++--
 fs/xfs/libxfs/xfs_format.h     |  140 +++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.c |  180 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap_btree.h |   32 +++++++
 fs/xfs/libxfs/xfs_sb.c         |    6 +
 fs/xfs/libxfs/xfs_shared.h     |    2 
 fs/xfs/xfs_mount.c             |    2 
 fs/xfs/xfs_mount.h             |    3 +
 fs/xfs/xfs_ondisk.h            |    3 +
 fs/xfs/xfs_trace.h             |    2 
 12 files changed, 384 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rmap_btree.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 06dd760..2de8c20 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -53,6 +53,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_inode_buf.o \
 				   xfs_log_rlimit.o \
 				   xfs_rmap.o \
+				   xfs_rmap_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 624b572..4b90419 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1210,6 +1210,9 @@ xfs_btree_set_refs(
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
index a29067c..90ea2a7 100644
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
index 97f354f..6efc7a3 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1383,11 +1383,151 @@ xfs_rmap_ino_owner(
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
 #define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
 
+#define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
+
+/*
+ * Data record structure
+ */
+struct xfs_rmap_rec {
+	__be32		rm_startblock;	/* extent start block */
+	__be32		rm_blockcount;	/* extent length */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+};
+
+/*
+ * rmap btree record
+ *  rm_offset:63 is the attribute fork flag
+ *  rm_offset:62 is the bmbt block flag
+ *  rm_offset:61 is the unwritten extent flag (same as l0:63 in bmbt)
+ *  rm_offset:54-60 aren't used and should be zero
+ *  rm_offset:0-53 is the block offset within the inode
+ */
+#define XFS_RMAP_OFF_ATTR_FORK	((__uint64_t)1ULL << 63)
+#define XFS_RMAP_OFF_BMBT_BLOCK	((__uint64_t)1ULL << 62)
+#define XFS_RMAP_OFF_UNWRITTEN	((__uint64_t)1ULL << 61)
+
+#define XFS_RMAP_LEN_MAX	((__uint32_t)~0U)
+#define XFS_RMAP_OFF_FLAGS	(XFS_RMAP_OFF_ATTR_FORK | \
+				 XFS_RMAP_OFF_BMBT_BLOCK | \
+				 XFS_RMAP_OFF_UNWRITTEN)
+#define XFS_RMAP_OFF_MASK	((__uint64_t)0x3FFFFFFFFFFFFFULL)
+
+#define XFS_RMAP_OFF(off)		((off) & XFS_RMAP_OFF_MASK)
+
+#define XFS_RMAP_IS_BMBT_BLOCK(off)	(!!((off) & XFS_RMAP_OFF_BMBT_BLOCK))
+#define XFS_RMAP_IS_ATTR_FORK(off)	(!!((off) & XFS_RMAP_OFF_ATTR_FORK))
+#define XFS_RMAP_IS_UNWRITTEN(len)	(!!((off) & XFS_RMAP_OFF_UNWRITTEN))
+
+#define RMAPBT_STARTBLOCK_BITLEN	32
+#define RMAPBT_BLOCKCOUNT_BITLEN	32
+#define RMAPBT_OWNER_BITLEN		64
+#define RMAPBT_ATTRFLAG_BITLEN		1
+#define RMAPBT_BMBTFLAG_BITLEN		1
+#define RMAPBT_EXNTFLAG_BITLEN		1
+#define RMAPBT_UNUSED_OFFSET_BITLEN	7
+#define RMAPBT_OFFSET_BITLEN		54
+
+#define XFS_RMAP_ATTR_FORK		(1 << 0)
+#define XFS_RMAP_BMBT_BLOCK		(1 << 1)
+#define XFS_RMAP_UNWRITTEN		(1 << 2)
+#define XFS_RMAP_KEY_FLAGS		(XFS_RMAP_ATTR_FORK | \
+					 XFS_RMAP_BMBT_BLOCK)
+#define XFS_RMAP_REC_FLAGS		(XFS_RMAP_UNWRITTEN)
+struct xfs_rmap_irec {
+	xfs_agblock_t	rm_startblock;	/* extent start block */
+	xfs_extlen_t	rm_blockcount;	/* extent length */
+	__uint64_t	rm_owner;	/* extent owner */
+	__uint64_t	rm_offset;	/* offset within the owner */
+	unsigned int	rm_flags;	/* state flags */
+};
+
+static inline __u64
+xfs_rmap_irec_offset_pack(
+	const struct xfs_rmap_irec	*irec)
+{
+	__u64			x;
+
+	x = XFS_RMAP_OFF(irec->rm_offset);
+	if (irec->rm_flags & XFS_RMAP_ATTR_FORK)
+		x |= XFS_RMAP_OFF_ATTR_FORK;
+	if (irec->rm_flags & XFS_RMAP_BMBT_BLOCK)
+		x |= XFS_RMAP_OFF_BMBT_BLOCK;
+	if (irec->rm_flags & XFS_RMAP_UNWRITTEN)
+		x |= XFS_RMAP_OFF_UNWRITTEN;
+	return x;
+}
+
+static inline int
+xfs_rmap_irec_offset_unpack(
+	__u64			offset,
+	struct xfs_rmap_irec	*irec)
+{
+	if (offset & ~(XFS_RMAP_OFF_MASK | XFS_RMAP_OFF_FLAGS))
+		return -EFSCORRUPTED;
+	irec->rm_offset = XFS_RMAP_OFF(offset);
+	if (offset & XFS_RMAP_OFF_ATTR_FORK)
+		irec->rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (offset & XFS_RMAP_OFF_BMBT_BLOCK)
+		irec->rm_flags |= XFS_RMAP_BMBT_BLOCK;
+	if (offset & XFS_RMAP_OFF_UNWRITTEN)
+		irec->rm_flags |= XFS_RMAP_UNWRITTEN;
+	return 0;
+}
+
+/*
+ * Key structure
+ *
+ * We don't use the length for lookups
+ */
+struct xfs_rmap_key {
+	__be32		rm_startblock;	/* extent start block */
+	__be64		rm_owner;	/* extent owner */
+	__be64		rm_offset;	/* offset within the owner */
+} __attribute__((packed));
+
+/* btree pointer type */
+typedef __be32 xfs_rmap_ptr_t;
+
 #define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
+static inline void
+xfs_owner_info_unpack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		*owner,
+	uint64_t		*offset,
+	unsigned int		*flags)
+{
+	unsigned int		r = 0;
+
+	*owner = oinfo->oi_owner;
+	*offset = oinfo->oi_offset;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+		r |= XFS_RMAP_ATTR_FORK;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+		r |= XFS_RMAP_BMBT_BLOCK;
+	*flags = r;
+}
+
+static inline void
+xfs_owner_info_pack(
+	struct xfs_owner_info	*oinfo,
+	uint64_t		owner,
+	uint64_t		offset,
+	unsigned int		flags)
+{
+	oinfo->oi_owner = owner;
+	oinfo->oi_offset = XFS_RMAP_OFF(offset);
+	oinfo->oi_flags = 0;
+	if (flags & XFS_RMAP_ATTR_FORK)
+		oinfo->oi_flags |= XFS_OWNER_INFO_ATTR_FORK;
+	if (flags & XFS_RMAP_BMBT_BLOCK)
+		oinfo->oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
+}
+
 /*
  * BMAP Btree format definitions
  *
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
new file mode 100644
index 0000000..7a35c78
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -0,0 +1,180 @@
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
+	if (block->bb_magic != cpu_to_be32(XFS_RMAP_CRC_MAGIC))
+		return false;
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return false;
+	if (!xfs_btree_sblock_v5hdr_verify(bp))
+		return false;
+
+	level = be16_to_cpu(block->bb_level);
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+			return false;
+	} else if (level >= mp->m_rmap_maxlevels)
+		return false;
+
+	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
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
+	.name			= "xfs_rmapbt",
+	.verify_read		= xfs_rmapbt_read_verify,
+	.verify_write		= xfs_rmapbt_write_verify,
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
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_NOFS);
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
+
+/* Compute the maximum height of an rmap btree. */
+void
+xfs_rmapbt_compute_maxlevels(
+	struct xfs_mount		*mp)
+{
+	mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
+			mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+}
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.h b/fs/xfs/libxfs/xfs_rmap_btree.h
index a3b8f90..462767f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.h
+++ b/fs/xfs/libxfs/xfs_rmap_btree.h
@@ -19,6 +19,38 @@
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
+extern void xfs_rmapbt_compute_maxlevels(struct xfs_mount *mp);
 
 int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
 		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index a544686..f86226b 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -37,6 +37,7 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_log.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -734,6 +735,11 @@ xfs_sb_mount_common(
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
index 16002b5..0c5b30b 100644
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
@@ -116,6 +117,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_BTREE_REF	3
 #define	XFS_ALLOC_BTREE_REF	2
 #define	XFS_BMAP_BTREE_REF	2
+#define	XFS_RMAP_BTREE_REF	2
 #define	XFS_DIR_BTREE_REF	2
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index b4153f0..8af1c88 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -42,6 +42,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_sysfs.h"
+#include "xfs_rmap_btree.h"
 
 
 static DEFINE_MUTEX(xfs_uuid_table_mutex);
@@ -680,6 +681,7 @@ xfs_mountfs(
 	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
 	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
 	xfs_ialloc_compute_maxlevels(mp);
+	xfs_rmapbt_compute_maxlevels(mp);
 
 	xfs_set_maxicount(mp);
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0537b1f..0ed0f29 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -116,9 +116,12 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* min bmap btree records */
 	uint			m_inobt_mxr[2];	/* max inobt btree records */
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
+	uint			m_rmap_mxr[2];	/* max rmap btree records */
+	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
+	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
 	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 0272301..48d544f 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -47,11 +47,14 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dsymlink_hdr,		56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_key,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inobt_rec,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_key,		20);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rmap_rec,		24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_timestamp,		8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_key_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_ptr_t,			4);
 	XFS_CHECK_STRUCT_SIZE(xfs_alloc_rec_t,			8);
 	XFS_CHECK_STRUCT_SIZE(xfs_inobt_ptr_t,			4);
+	XFS_CHECK_STRUCT_SIZE(xfs_rmap_ptr_t,			4);
 
 	/* dir/attr trees */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr3_leaf_hdr,	80);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4872fbd..b4ee9c8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2444,6 +2444,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
 		__entry->flags = oinfo->oi_flags;
+		if (unwritten)
+			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
 	TP_printk("dev %d:%d agno %u agbno %u len %u owner %lld offset %llu flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
