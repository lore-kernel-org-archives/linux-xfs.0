Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E2F1F7F7D
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 18:39:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A43DD304032
	for <xfs@oss.sgi.com>; Thu, 25 Jun 2015 16:39:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MZs4xYdjvwhMgS0t (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 25 Jun 2015 16:39:26 -0700 (PDT)
Subject: [PATCH 01/14] xfs: create a per-AG btree to track reference counts
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Jun 2015 16:39:16 -0700
Message-ID: <20150625233916.4992.12808.stgit@birch.djwong.org>
In-Reply-To: <20150625233909.4992.68314.stgit@birch.djwong.org>
References: <20150625233909.4992.68314.stgit@birch.djwong.org>
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

Create a per-AG btree to track the reference counts of physical blocks
to support reflink.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile                   |    1 
 fs/xfs/libxfs/xfs_alloc.c         |   19 +
 fs/xfs/libxfs/xfs_btree.c         |    8 -
 fs/xfs/libxfs/xfs_btree.h         |    7 
 fs/xfs/libxfs/xfs_format.h        |   59 ++++
 fs/xfs/libxfs/xfs_reflink_btree.c |  531 +++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_reflink_btree.h |   70 +++++
 fs/xfs/libxfs/xfs_sb.c            |    7 
 fs/xfs/libxfs/xfs_shared.h        |    1 
 fs/xfs/libxfs/xfs_trans_resv.c    |    2 
 fs/xfs/libxfs/xfs_types.h         |    2 
 fs/xfs/xfs_mount.h                |    5 
 fs/xfs/xfs_stats.c                |    1 
 fs/xfs/xfs_stats.h                |   18 +
 14 files changed, 722 insertions(+), 9 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_reflink_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_reflink_btree.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index e338595..ba89aee 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -52,6 +52,7 @@ xfs-y				+= $(addprefix libxfs/, \
 				   xfs_log_rlimit.o \
 				   xfs_rmap.o \
 				   xfs_rmap_btree.o \
+				   xfs_reflink_btree.o \
 				   xfs_sb.o \
 				   xfs_symlink_remote.o \
 				   xfs_trans_resv.o \
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index c6a1372..fc8a499 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -54,6 +54,8 @@ xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		return XFS_RL_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
@@ -91,9 +93,11 @@ xfs_alloc_set_aside(
 	unsigned int	blocks;
 
 	blocks = 4 + (mp->m_sb.sb_agcount * XFS_ALLOC_AGFL_RESERVE);
-	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
-		return blocks;
-	return blocks + (mp->m_sb.sb_agcount * (2 * mp->m_ag_maxlevels) - 1);
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		blocks += (mp->m_sb.sb_agcount * (2 * mp->m_ag_maxlevels) - 1);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		blocks += (mp->m_sb.sb_agcount * (2 * mp->m_ag_maxlevels) - 1);
+	return blocks;
 }
 
 /*
@@ -123,6 +127,10 @@ xfs_alloc_ag_max_usable(struct xfs_mount *mp)
 		/* rmap root block + full tree split on full AG */
 		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
 	}
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		/* reflink root block + full tree split on full AG */
+		blocks += 1 + (2 * mp->m_ag_maxlevels) - 1;
+	}
 
 	return mp->m_sb.sb_agblocks - blocks;
 }
@@ -2378,6 +2386,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_reflink_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2497,6 +2509,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_reflink_level = be32_to_cpu(agf->agf_reflink_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4c9b9b3..8820aad 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -43,9 +43,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC },
+	  XFS_FIBT_MAGIC, 0 },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
+	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
+	  XFS_RLBT_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
@@ -1117,6 +1118,9 @@ xfs_btree_set_refs(
 	case XFS_BTNUM_RMAP:
 		xfs_buf_set_ref(bp, XFS_RMAP_BTREE_REF);
 		break;
+	case XFS_BTNUM_RL:
+		xfs_buf_set_ref(bp, XFS_REFLINK_BTREE_REF);
+		break;
 	default:
 		ASSERT(0);
 	}
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 48ab2b1..a3f8661 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -43,6 +43,7 @@ union xfs_btree_key {
 	xfs_alloc_key_t			alloc;
 	struct xfs_inobt_key		inobt;
 	struct xfs_rmap_key		rmap;
+	xfs_reflink_key_t		reflink;
 };
 
 union xfs_btree_rec {
@@ -51,6 +52,7 @@ union xfs_btree_rec {
 	struct xfs_alloc_rec		alloc;
 	struct xfs_inobt_rec		inobt;
 	struct xfs_rmap_rec		rmap;
+	xfs_reflink_rec_t		reflink;
 };
 
 /*
@@ -67,6 +69,8 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 
+#define	XFS_BTNUM_RL	((xfs_btnum_t)XFS_BTNUM_RLi)
+
 /*
  * For logging record fields.
  */
@@ -98,6 +102,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
+	case XFS_BTNUM_RL: __XFS_BTREE_STATS_INC(rlbt, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -113,6 +118,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
+	case XFS_BTNUM_RL: __XFS_BTREE_STATS_INC(rlbt, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -205,6 +211,7 @@ typedef struct xfs_btree_cur
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
 		struct xfs_rmap_irec	r;
+		xfs_reflink_rec_incore_t	rl;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 9cff517..e4954ab 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -446,9 +446,11 @@ xfs_sb_has_compat_feature(
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
+#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflink btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -522,6 +524,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline int xfs_sb_version_hasreflink(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 /*
  * end of superblock version macros
  */
@@ -616,12 +624,15 @@ typedef struct xfs_agf {
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 	uuid_t		agf_uuid;	/* uuid of filesystem */
 
+	__be32		agf_reflink_root;	/* reflink tree root block */
+	__be32		agf_reflink_level;	/* reflink btree levels */
+
 	/*
 	 * reserve some contiguous space for future logged fields before we add
 	 * the unlogged fields. This makes the range logging via flags and
 	 * structure offsets much simpler.
 	 */
-	__be64		agf_spare64[16];
+	__be64		agf_spare64[15];
 
 	/* unlogged fields, written during buffer writeback. */
 	__be64		agf_lsn;	/* last write sequence */
@@ -1338,6 +1349,50 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
+ * reflink Btree format definitions
+ *
+ */
+#define	XFS_RLBT_CRC_MAGIC	0x524C4233	/* 'RLB3' */
+
+/*
+ * Data record/key structure
+ */
+typedef struct xfs_reflink_rec {
+	__be32		rr_startblock;	/* starting block number */
+	__be32		rr_blockcount;	/* count of blocks */
+	__be32		rr_nlinks;	/* number of inodes linked here */
+} xfs_reflink_rec_t;
+
+typedef struct xfs_reflink_key {
+	__be32		rr_startblock;	/* starting block number */
+} xfs_reflink_key_t;
+
+typedef struct xfs_reflink_rec_incore {
+	xfs_agblock_t	rr_startblock;	/* starting block number */
+	xfs_extlen_t	rr_blockcount;	/* count of free blocks */
+	xfs_nlink_t	rr_nlinks;	/* number of inodes linked here */
+} xfs_reflink_rec_incore_t;
+
+/*
+ * When a block hits MAXRLCOUNT references, it becomes permanently
+ * stuck in CoW mode, because who knows how many times it's really
+ * referenced.
+ */
+#define MAXRLCOUNT	((xfs_nlink_t)~0U)
+#define MAXRLEXTLEN	((xfs_extlen_t)~0U)
+
+/* btree pointer type */
+typedef __be32 xfs_reflink_ptr_t;
+
+#define	XFS_RL_BLOCK(mp) \
+	(xfs_sb_version_hasrmapbt(&((mp)->m_sb)) ? \
+	 XFS_RMAP_BLOCK(mp) + 1 : \
+	 (xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
+	  XFS_FIBT_BLOCK(mp) + 1 : \
+	  XFS_IBT_BLOCK(mp) + 1))
+
+
+/*
  * BMAP Btree format definitions
  *
  * This includes both the root block definition that sits inside an inode fork
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.c b/fs/xfs/libxfs/xfs_reflink_btree.c
new file mode 100644
index 0000000..8a0fa5d
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_reflink_btree.c
@@ -0,0 +1,531 @@
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
+#include "xfs_reflink_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_extent_busy.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+
+#undef REFLINK_DEBUG
+
+#ifdef REFLINK_DEBUG
+# define dbg_printk(f, a...)  do {printk(KERN_ERR f, ## a); } while (0)
+#else
+# define dbg_printk(f, a...)
+#endif
+
+#define CHECK_AG_NUMBER(mp, agno) \
+	do { \
+		ASSERT((agno) != NULLAGNUMBER); \
+		ASSERT((agno) < (mp)->m_sb.sb_agcount); \
+	} while(0);
+
+#define CHECK_AG_EXTENT(mp, agbno, len) \
+	do { \
+		ASSERT((agbno) != NULLAGBLOCK); \
+		ASSERT((len) > 0); \
+		ASSERT((unsigned long long)(agbno) + (len) <= \
+				(mp)->m_sb.sb_agblocks); \
+	} while(0);
+
+#define XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, have, agbno, len, nr, label) \
+	do { \
+		XFS_WANT_CORRUPTED_GOTO((mp), (have) == 1, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (len) > 0, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (nr) >= 2, label); \
+		XFS_WANT_CORRUPTED_GOTO((mp), (unsigned long long)(agbno) + \
+				(len) <= (mp)->m_sb.sb_agblocks, label); \
+	} while(0);
+
+STATIC struct xfs_btree_cur *
+xfs_reflinkbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_reflinkbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+}
+
+STATIC void
+xfs_reflinkbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_reflink_root = ptr->s;
+	be32_add_cpu(&agf->agf_reflink_level, inc);
+	pag->pagf_reflink_level += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_reflinkbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	int			error;
+	xfs_agblock_t		bno;
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ENTRY);
+
+	/* Allocate the new block from the freelist. If we can't, give up.  */
+	error = xfs_alloc_get_freelist(cur->bc_tp, cur->bc_private.a.agbp,
+				       &bno, 1);
+	if (error) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+		return error;
+	}
+
+	if (bno == NULLAGBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+
+	xfs_extent_busy_reuse(cur->bc_mp, cur->bc_private.a.agno, bno, 1, false);
+
+	xfs_trans_agbtree_delta(cur->bc_tp, 1);
+	new->s = cpu_to_be32(bno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+}
+
+STATIC int
+xfs_reflinkbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agblock_t		bno;
+	int			error;
+
+	bno = xfs_daddr_to_agbno(cur->bc_mp, XFS_BUF_ADDR(bp));
+	error = xfs_alloc_put_freelist(cur->bc_tp, agbp, NULL, bno, 1);
+	if (error)
+		return error;
+
+	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
+			      XFS_EXTENT_BUSY_SKIP_DISCARD);
+	xfs_trans_agbtree_delta(cur->bc_tp, -1);
+
+	xfs_trans_binval(cur->bc_tp, bp);
+	return 0;
+}
+
+STATIC int
+xfs_reflinkbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rlbt_mnr[level != 0];
+}
+
+STATIC int
+xfs_reflinkbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rlbt_mxr[level != 0];
+}
+
+STATIC void
+xfs_reflinkbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(rec->reflink.rr_startblock != 0);
+
+	key->reflink.rr_startblock = rec->reflink.rr_startblock;
+}
+
+STATIC void
+xfs_reflinkbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->reflink.rr_startblock != 0);
+
+	rec->reflink.rr_startblock = key->reflink.rr_startblock;
+}
+
+STATIC void
+xfs_reflinkbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(cur->bc_rec.rl.rr_startblock != 0);
+
+	rec->reflink.rr_startblock = cpu_to_be32(cur->bc_rec.rl.rr_startblock);
+	rec->reflink.rr_blockcount = cpu_to_be32(cur->bc_rec.rl.rr_blockcount);
+	rec->reflink.rr_nlinks = cpu_to_be32(cur->bc_rec.rl.rr_nlinks);
+}
+
+STATIC void
+xfs_reflinkbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_reflink_root != 0);
+
+	ptr->s = agf->agf_reflink_root;
+}
+
+STATIC __int64_t
+xfs_reflinkbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	xfs_reflink_rec_incore_t	*rec = &cur->bc_rec.rl;
+	xfs_reflink_key_t		*kp = &key->reflink;
+
+	return (__int64_t)be32_to_cpu(kp->rr_startblock) - rec->rr_startblock;
+}
+
+static bool
+xfs_reflinkbt_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+	unsigned int		level;
+
+	if (block->bb_magic != cpu_to_be32(XFS_RLBT_CRC_MAGIC))
+		return false;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
+		return false;
+	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
+		return false;
+	if (pag &&
+	    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		return false;
+
+	level = be16_to_cpu(block->bb_level);
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_reflink_level)
+			return false;
+	} else if (level >= mp->m_ag_maxlevels)
+		return false;
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > mp->m_rlbt_mxr[level != 0])
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
+xfs_reflinkbt_read_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_btree_sblock_verify_crc(bp))
+		xfs_buf_ioerror(bp, -EFSBADCRC);
+	else if (!xfs_reflinkbt_verify(bp))
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+
+	if (bp->b_error) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_verifier_error(bp);
+	}
+}
+
+static void
+xfs_reflinkbt_write_verify(
+	struct xfs_buf	*bp)
+{
+	if (!xfs_reflinkbt_verify(bp)) {
+		trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_buf_ioerror(bp, -EFSCORRUPTED);
+		xfs_verifier_error(bp);
+		return;
+	}
+	xfs_btree_sblock_calc_crc(bp);
+
+}
+
+const struct xfs_buf_ops xfs_reflinkbt_buf_ops = {
+	.verify_read = xfs_reflinkbt_read_verify,
+	.verify_write = xfs_reflinkbt_write_verify,
+};
+
+
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_reflinkbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->reflink.rr_startblock) <
+	       be32_to_cpu(k2->reflink.rr_startblock);
+}
+
+STATIC int
+xfs_reflinkbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return be32_to_cpu(r1->reflink.rr_startblock) +
+		be32_to_cpu(r1->reflink.rr_blockcount) <=
+		be32_to_cpu(r2->reflink.rr_startblock);
+}
+#endif	/* DEBUG */
+
+static const struct xfs_btree_ops xfs_reflinkbt_ops = {
+	.rec_len		= sizeof(xfs_reflink_rec_t),
+	.key_len		= sizeof(xfs_reflink_key_t),
+
+	.dup_cursor		= xfs_reflinkbt_dup_cursor,
+	.set_root		= xfs_reflinkbt_set_root,
+	.alloc_block		= xfs_reflinkbt_alloc_block,
+	.free_block		= xfs_reflinkbt_free_block,
+	.get_minrecs		= xfs_reflinkbt_get_minrecs,
+	.get_maxrecs		= xfs_reflinkbt_get_maxrecs,
+	.init_key_from_rec	= xfs_reflinkbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_reflinkbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_reflinkbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_reflinkbt_init_ptr_from_cur,
+	.key_diff		= xfs_reflinkbt_key_diff,
+	.buf_ops		= &xfs_reflinkbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_reflinkbt_keys_inorder,
+	.recs_inorder		= xfs_reflinkbt_recs_inorder,
+#endif
+};
+
+/*
+ * Allocate a new reflink btree cursor.
+ */
+struct xfs_btree_cur *			/* new reflink btree cursor */
+xfs_reflinkbt_init_cursor(
+	struct xfs_mount	*mp,		/* file system mount point */
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno)		/* allocation group number */
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	struct xfs_btree_cur	*cur;
+
+	CHECK_AG_NUMBER(mp, agno);
+	cur = kmem_zone_zalloc(xfs_btree_cur_zone, KM_SLEEP);
+
+	cur->bc_tp = tp;
+	cur->bc_mp = mp;
+	cur->bc_btnum = XFS_BTNUM_RL;
+	cur->bc_blocklog = mp->m_sb.sb_blocklog;
+	cur->bc_ops = &xfs_reflinkbt_ops;
+
+	cur->bc_nlevels = be32_to_cpu(agf->agf_reflink_level);
+
+	cur->bc_private.a.agbp = agbp;
+	cur->bc_private.a.agno = agno;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb))
+		cur->bc_flags |= XFS_BTREE_CRC_BLOCKS;
+
+	return cur;
+}
+
+/*
+ * Calculate number of records in an reflink btree block.
+ */
+int
+xfs_reflinkbt_maxrecs(
+	struct xfs_mount	*mp,
+	int			blocklen,
+	int			leaf)
+{
+	blocklen -= XFS_REFLINK_BLOCK_LEN;
+
+	if (leaf)
+		return blocklen / sizeof(xfs_reflink_rec_t);
+	return blocklen / (sizeof(xfs_reflink_key_t) +
+			   sizeof(xfs_reflink_ptr_t));
+}
+
+/*
+ * Lookup the first record less than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+int					/* error */
+xfs_reflink_lookup_le(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.rl.rr_startblock = bno;
+	cur->bc_rec.rl.rr_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Lookup the first record greater than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+int					/* error */
+xfs_reflink_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	int			*stat)	/* success/failure */
+{
+	cur->bc_rec.rl.rr_startblock = bno;
+	cur->bc_rec.rl.rr_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+int					/* error */
+xfs_reflink_get_rec(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		*bno,	/* output: starting block of extent */
+	xfs_extlen_t		*len,	/* output: length of extent */
+	xfs_nlink_t		*nlink,	/* output: number of links */
+	int			*stat)	/* output: success/failure */
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		CHECK_AG_EXTENT(cur->bc_mp,
+			be32_to_cpu(rec->reflink.rr_startblock),
+			be32_to_cpu(rec->reflink.rr_blockcount));
+		*bno = be32_to_cpu(rec->reflink.rr_startblock);
+		*len = be32_to_cpu(rec->reflink.rr_blockcount);
+		*nlink = be32_to_cpu(rec->reflink.rr_nlinks);
+	}
+	return error;
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, nr].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_reflinkbt_update(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	xfs_nlink_t		nr)	/* reference count */
+{
+	union xfs_btree_rec	rec;
+
+	CHECK_AG_EXTENT(cur->bc_mp, bno, len);
+	ASSERT(nr > 1);
+
+	rec.reflink.rr_startblock = cpu_to_be32(bno);
+	rec.reflink.rr_blockcount = cpu_to_be32(len);
+	rec.reflink.rr_nlinks = cpu_to_be32(nr);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Insert the record referred to by cur to the value given
+ * by [bno, len, nr].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_reflinkbt_insert(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	xfs_extlen_t		len,	/* length of extent */
+	xfs_nlink_t		nr,	/* reference count */
+	int			*i)	/* success? */
+{
+	CHECK_AG_EXTENT(cur->bc_mp, bno, len);
+	ASSERT(nr > 1);
+
+	cur->bc_rec.rl.rr_startblock = bno;
+	cur->bc_rec.rl.rr_blockcount = len;
+	cur->bc_rec.rl.rr_nlinks = nr;
+	return xfs_btree_insert(cur, i);
+}
+
+/*
+ * Remove the record referred to by cur.
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int				/* error */
+xfs_reflinkbt_delete(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	int			*i)	/* success? */
+{
+	xfs_agblock_t		bno;
+	xfs_extlen_t		len;
+	xfs_nlink_t		nr;
+	int			x;
+	int			error;
+
+	error = xfs_reflink_get_rec(cur, &bno, &len, &nr, &x);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, x == 1, error0);
+	error = xfs_btree_delete(cur, i);
+	if (error)
+		return error;
+	error = xfs_reflink_lookup_ge(cur, bno, &x);
+error0:
+	return error;
+}
diff --git a/fs/xfs/libxfs/xfs_reflink_btree.h b/fs/xfs/libxfs/xfs_reflink_btree.h
new file mode 100644
index 0000000..a27588a
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_reflink_btree.h
@@ -0,0 +1,70 @@
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
+#ifndef __XFS_REFLINK_BTREE_H__
+#define	__XFS_REFLINK_BTREE_H__
+
+/*
+ * Freespace on-disk structures
+ */
+
+struct xfs_buf;
+struct xfs_btree_cur;
+struct xfs_mount;
+
+/*
+ * Btree block header size depends on a superblock flag.
+ */
+#define XFS_REFLINK_BLOCK_LEN	XFS_BTREE_SBLOCK_CRC_LEN
+
+/*
+ * Record, key, and pointer address macros for btree blocks.
+ *
+ * (note that some of these may appear unused, but they are used in userspace)
+ */
+#define XFS_REFLINK_REC_ADDR(block, index) \
+	((xfs_reflink_rec_t *) \
+		((char *)(block) + \
+		 XFS_REFLINK_BLOCK_LEN + \
+		 (((index) - 1) * sizeof(xfs_reflink_rec_t))))
+
+#define XFS_REFLINK_KEY_ADDR(block, index) \
+	((xfs_reflink_key_t *) \
+		((char *)(block) + \
+		 XFS_REFLINK_BLOCK_LEN + \
+		 ((index) - 1) * sizeof(xfs_reflink_key_t)))
+
+#define XFS_REFLINK_PTR_ADDR(block, index, maxrecs) \
+	((xfs_reflink_ptr_t *) \
+		((char *)(block) + \
+		 XFS_REFLINK_BLOCK_LEN + \
+		 (maxrecs) * sizeof(xfs_reflink_key_t) + \
+		 ((index) - 1) * sizeof(xfs_reflink_ptr_t)))
+
+extern struct xfs_btree_cur *xfs_reflinkbt_init_cursor(struct xfs_mount *,
+		struct xfs_trans *, struct xfs_buf *,
+		xfs_agnumber_t);
+extern int xfs_reflinkbt_maxrecs(struct xfs_mount *, int, int);
+extern int xfs_reflink_lookup_le(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		int *stat);
+extern int xfs_reflink_lookup_ge(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		int *stat);
+extern int xfs_reflink_get_rec(struct xfs_btree_cur *cur, xfs_agblock_t *bno,
+		xfs_extlen_t *len, xfs_nlink_t *nlink, int *stat);
+
+#endif	/* __XFS_REFLINK_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index db5a19d3..5f8f7fd 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -36,6 +36,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_reflink_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -717,6 +719,11 @@ xfs_sb_mount_common(
 	mp->m_rmap_mnr[0] = mp->m_rmap_mxr[0] / 2;
 	mp->m_rmap_mnr[1] = mp->m_rmap_mxr[1] / 2;
 
+	mp->m_rlbt_mxr[0] = xfs_reflinkbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_rlbt_mxr[1] = xfs_reflinkbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_rlbt_mnr[0] = mp->m_rlbt_mxr[0] / 2;
+	mp->m_rlbt_mnr[1] = mp->m_rlbt_mxr[1] / 2;
+
 	mp->m_bsize = XFS_FSB_TO_BB(mp, 1);
 	mp->m_ialloc_inos = (int)MAX((__uint16_t)XFS_INODES_PER_CHUNK,
 					sbp->sb_inopblock);
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 88efbb4..d1de74e 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -216,6 +216,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
+#define XFS_REFLINK_BTREE_REF	1
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index d495f82..a6d1d3b 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -81,6 +81,8 @@ xfs_allocfree_log_count(
 
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		num_trees++;
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		num_trees++;
 
 	return num_ops * num_trees * (2 * mp->m_ag_maxlevels - 1);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 3d50364..1a93ac9 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -109,7 +109,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_RLi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index cdced0b..69af7f7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -92,6 +92,8 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* min inobt btree records */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rlbt_mxr[2];	/* max rlbt btree records */
+	uint			m_rlbt_mnr[2];	/* min rlbt btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* max inobt btree levels. */
@@ -315,6 +317,9 @@ typedef struct xfs_perag {
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
 	int		pagb_count;	/* pagb slots in use */
+
+	/* reflink */
+	__uint8_t	pagf_reflink_level;
 } xfs_perag_t;
 
 extern int	xfs_log_sbcount(xfs_mount_t *);
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 67bbfa2..57449b8 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -61,6 +61,7 @@ static int xfs_stat_proc_show(struct seq_file *m, void *v)
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
 		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
+		{ "rlbt2",		XFSSTAT_END_RLBT_V2		},
 		/* we print both series of quota information together */
 		{ "qm",			XFSSTAT_END_QM			},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 8414db2..d943c04 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -215,7 +215,23 @@ struct xfsstats {
 	__uint32_t		xs_rmap_2_alloc;
 	__uint32_t		xs_rmap_2_free;
 	__uint32_t		xs_rmap_2_moves;
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
+#define XFSSTAT_END_RLBT_V2		(XFSSTAT_END_RMAP_V2+15)
+	__uint32_t		xs_rlbt_2_lookup;
+	__uint32_t		xs_rlbt_2_compare;
+	__uint32_t		xs_rlbt_2_insrec;
+	__uint32_t		xs_rlbt_2_delrec;
+	__uint32_t		xs_rlbt_2_newroot;
+	__uint32_t		xs_rlbt_2_killroot;
+	__uint32_t		xs_rlbt_2_increment;
+	__uint32_t		xs_rlbt_2_decrement;
+	__uint32_t		xs_rlbt_2_lshift;
+	__uint32_t		xs_rlbt_2_rshift;
+	__uint32_t		xs_rlbt_2_split;
+	__uint32_t		xs_rlbt_2_join;
+	__uint32_t		xs_rlbt_2_alloc;
+	__uint32_t		xs_rlbt_2_free;
+	__uint32_t		xs_rlbt_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RLBT_V2+6)
 	__uint32_t		xs_qm_dqreclaims;
 	__uint32_t		xs_qm_dqreclaim_misses;
 	__uint32_t		xs_qm_dquot_dups;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
