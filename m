Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AB5067F8A
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 44551AC002
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:26:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id OmkExunvHJKoVdBG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:26:07 -0700 (PDT)
Subject: [PATCH 04/15] libxfs: add support for reflink btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 29 Jun 2015 20:26:04 -0700
Message-ID: <20150630032604.572.28044.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
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

Import definitions and reflink btree code from the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/inode.c                 |    3 
 include/libxfs.h           |    1 
 include/linux.h            |    1 
 include/xfs_mount.h        |    3 
 libxfs/Makefile            |    2 
 libxfs/xfs_alloc.c         |    2 
 libxfs/xfs_btree.h         |    6 
 libxfs/xfs_format.h        |   59 ++
 libxfs/xfs_reflink_btree.c | 1097 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_reflink_btree.h |   81 +++
 libxfs/xfs_sb.c            |    7 
 libxfs/xfs_shared.h        |    1 
 libxfs/xfs_types.h         |    2 
 13 files changed, 1261 insertions(+), 4 deletions(-)
 create mode 100644 libxfs/xfs_reflink_btree.c
 create mode 100644 libxfs/xfs_reflink_btree.h


diff --git a/db/inode.c b/db/inode.c
index fbae0bd..5045c5a 100644
--- a/db/inode.c
+++ b/db/inode.c
@@ -163,6 +163,9 @@ const field_t	inode_core_flds[] = {
 	{ "filestream", FLDT_UINT1,
 	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_FILESTREAM_BIT-1),C1,
 	  0, TYP_NONE },
+	{ "reflink", FLDT_UINT1,
+	  OI(COFF(flags) + bitsz(__uint16_t) - XFS_DIFLAG_REFLINK_BIT-1),C1,
+	  0, TYP_NONE },
 	{ "gen", FLDT_UINT32D, OI(COFF(gen)), C1, 0, TYP_NONE },
 	{ NULL }
 };
diff --git a/include/libxfs.h b/include/libxfs.h
index e259155..27d7777 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -77,6 +77,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include <xfs/xfs_bmap.h>
 #include <xfs/xfs_trace.h>
 #include <xfs/xfs_trans.h>
+#include <xfs/xfs_reflink_btree.h>
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/linux.h b/include/linux.h
index 5586290..377a778 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -143,6 +143,7 @@ typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
 typedef char*		xfs_caddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 #ifndef	_UCHAR_T_DEFINED
 typedef unsigned char	uchar_t;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 9f41b40..7a6815f 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -66,6 +66,8 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_rlbt_mxr[2];	/* XFS_RLBT_BLOCK_MAXRECS */
+	uint			m_rlbt_mnr[2];	/* XFS_RLBT_BLOCK_MINRECS */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
@@ -132,6 +134,7 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 	int		pagb_count;	/* pagb slots in use */
+	__uint8_t	pagf_reflink_level;
 } xfs_perag_t;
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
diff --git a/libxfs/Makefile b/libxfs/Makefile
index a416f2a..47f6cca 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -43,6 +43,7 @@ QAHFILES = xfs_alloc.h \
 	xfs_log_format.h \
 	xfs_quota_defs.h \
 	xfs_rmap_btree.h \
+	xfs_reflink_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -75,6 +76,7 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_reflink_btree.c \
 	xfs_rtbitmap.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index d42c5fc..abb50a5 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2687,6 +2687,8 @@ xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		return XFS_RL_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 48ab2b1..17c931d 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
@@ -66,6 +68,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_RL	((xfs_btnum_t)XFS_BTNUM_RLi)
 
 /*
  * For logging record fields.
@@ -98,6 +101,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
+	case XFS_BTNUM_RL: __XFS_BTREE_STATS_INC(rlbt, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -113,6 +117,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
+	case XFS_BTNUM_RL: __XFS_BTREE_STATS_ADD(rlbt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -205,6 +210,7 @@ typedef struct xfs_btree_cur
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
 		struct xfs_rmap_irec	r;
+		xfs_reflink_rec_incore_t rl;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index b1e5ea5..b7ba7ac 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
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
@@ -516,6 +518,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline int xfs_sb_version_hasreflink(xfs_sb_t *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
@@ -616,12 +624,15 @@ typedef struct xfs_agf {
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 	uuid_t		agf_uuid;	/* uuid of filesystem */
 
+	__be32		agf_reflink_root;	/* reflink tree root */
+	__be32		agf_reflink_level;	/* reflink tree level */
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
@@ -997,6 +1008,7 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG_EXTSZINHERIT_BIT 12	/* inherit inode extent size */
 #define XFS_DIFLAG_NODEFRAG_BIT     13	/* do not reorganize/defragment */
 #define XFS_DIFLAG_FILESTREAM_BIT   14  /* use filestream allocator */
+#define XFS_DIFLAG_REFLINK_BIT      15  /* check reflink btree for CoW */
 #define XFS_DIFLAG_REALTIME      (1 << XFS_DIFLAG_REALTIME_BIT)
 #define XFS_DIFLAG_PREALLOC      (1 << XFS_DIFLAG_PREALLOC_BIT)
 #define XFS_DIFLAG_NEWRTBM       (1 << XFS_DIFLAG_NEWRTBM_BIT)
@@ -1012,13 +1024,15 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 #define XFS_DIFLAG_EXTSZINHERIT  (1 << XFS_DIFLAG_EXTSZINHERIT_BIT)
 #define XFS_DIFLAG_NODEFRAG      (1 << XFS_DIFLAG_NODEFRAG_BIT)
 #define XFS_DIFLAG_FILESTREAM    (1 << XFS_DIFLAG_FILESTREAM_BIT)
+#define XFS_DIFLAG_REFLINK       (1 << XFS_DIFLAG_REFLINK_BIT)
 
 #define XFS_DIFLAG_ANY \
 	(XFS_DIFLAG_REALTIME | XFS_DIFLAG_PREALLOC | XFS_DIFLAG_NEWRTBM | \
 	 XFS_DIFLAG_IMMUTABLE | XFS_DIFLAG_APPEND | XFS_DIFLAG_SYNC | \
 	 XFS_DIFLAG_NOATIME | XFS_DIFLAG_NODUMP | XFS_DIFLAG_RTINHERIT | \
 	 XFS_DIFLAG_PROJINHERIT | XFS_DIFLAG_NOSYMLINKS | XFS_DIFLAG_EXTSIZE | \
-	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
+	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM | \
+	 XFS_DIFLAG_REFLINK)
 
 /*
  * Inode number format:
@@ -1356,6 +1370,12 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
+ * reflink Btree format definitions
+ *
+ */
+#define	XFS_RLBT_CRC_MAGIC	0x524C4233	/* 'RLB3' */
+
+/*
  * The first data block of an AG depends on whether the filesystem was formatted
  * with the optional btree features. These need to be accounted for
  * appropriately.
@@ -1366,6 +1386,39 @@ typedef __be32 xfs_rmap_ptr_t;
 #define XFS_PREALLOC_BLOCKS(mp)	xfs_prealloc_blocks(mp)
 
 /*
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
diff --git a/libxfs/xfs_reflink_btree.c b/libxfs/xfs_reflink_btree.c
new file mode 100644
index 0000000..02a835a
--- /dev/null
+++ b/libxfs/xfs_reflink_btree.c
@@ -0,0 +1,1097 @@
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
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_btree.h"
+#include "xfs_inode.h"
+#include "xfs_bmap.h"
+#include "xfs_reflink_btree.h"
+#include "xfs_alloc.h"
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
+
+#ifdef REFLINK_DEBUG
+static void
+dump_cur_loc(
+	struct xfs_btree_cur	*cur,
+	const char		*str,
+	int			line)
+{
+	xfs_agblock_t		gbno;
+	xfs_extlen_t		glen;
+	xfs_nlink_t		gnr;
+	int			i;
+
+	xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+	printk(KERN_INFO "%s(%d) cur[%d]:[%u,%u,%u,%d] ", str, line,
+	       cur->bc_ptrs[0], gbno, glen, gnr, i);
+	if (i && cur->bc_ptrs[0]) {
+		cur->bc_ptrs[0]--;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk("left[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
+		       gbno, glen, gnr, i);
+		cur->bc_ptrs[0]++;
+	}
+
+	if (i && cur->bc_ptrs[0] < xfs_reflinkbt_get_maxrecs(cur, 0)) {
+		cur->bc_ptrs[0]++;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk("right[%d]:[%u,%u,%u,%d] ", cur->bc_ptrs[0],
+		       gbno, glen, gnr, i);
+		cur->bc_ptrs[0]--;
+	}
+	printk("\n");
+}
+#else
+# define dump_cur_loc(c, s, l)
+#endif
+
+/*
+ * Adjust the ref count of a range of AG blocks.
+ */
+int						/* error */
+xfs_reflinkbt_adjust_refcount(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,		/* transaction pointer */
+	struct xfs_buf		*agbp,		/* buffer for agf structure */
+	xfs_agnumber_t		agno,		/* allocation group number */
+	xfs_agblock_t		agbno,		/* start of range */
+	xfs_extlen_t		aglen,		/* length of range */
+	int			adj)		/* how much to change refcnt */
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	int			i, have;
+	bool			real_crl;	/* cbno/clen is on disk? */
+	xfs_agblock_t		lbno, cbno, rbno;	/* rlextent start */
+	xfs_extlen_t		llen, clen, rlen;	/* rlextent length */
+	xfs_nlink_t		lnr, cnr, rnr;		/* rlextent refcount */
+
+	xfs_agblock_t		bno;		/* ag bno in the loop */
+	xfs_agblock_t		agbend;		/* end agbno of the loop */
+	xfs_extlen_t		len;		/* remaining len to add */
+	xfs_nlink_t		new_cnr;	/* new refcount */
+
+	CHECK_AG_NUMBER(mp, agno);
+	CHECK_AG_EXTENT(mp, agbno, aglen);
+	ASSERT(adj == -1 || adj == 1);
+
+	/*
+	 * Allocate/initialize a cursor for the by-number freespace btree.
+	 */
+	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
+
+	/*
+	 * Split a left rlextent that crosses agbno.
+	 */
+	error = xfs_reflink_lookup_le(cur, agbno, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+		if (lbno < agbno && lbno + llen > agbno) {
+			dbg_printk("split lext crossing agbno [%u:%u:%u]\n",
+				   lbno, llen, lnr);
+			error = xfs_reflinkbt_update(cur, lbno, agbno - lbno,
+					lnr);
+			if (error)
+				goto error0;
+
+			error = xfs_btree_increment(cur, 0, &i);
+			if (error)
+				goto error0;
+
+			error = xfs_reflinkbt_insert(cur, agbno,
+					llen - (agbno - lbno), lnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+	}
+
+	/*
+	 * Split a right rlextent that crosses agbno.
+	 */
+	agbend = agbno + aglen - 1;
+	error = xfs_reflink_lookup_le(cur, agbend, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &rbno, &rlen, &rnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, rbno, rlen, rnr, error0);
+		if (agbend + 1 != mp->m_sb.sb_agblocks &&
+		    agbend + 1 < rbno + rlen) {
+			dbg_printk("split rext crossing agbend [%u:%u:%u]\n",
+				   rbno, rlen, rnr);
+			error = xfs_reflinkbt_update(cur, agbend + 1,
+					rlen - (agbend - rbno + 1), rnr);
+			if (error)
+				goto error0;
+
+			error = xfs_reflinkbt_insert(cur, rbno,
+					agbend - rbno + 1, rnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+	}
+
+	/*
+	 * Start iterating the range we're adjusting.  rlextent boundaries
+	 * should be at agbno and agbend.
+	 */
+	bno = agbno;
+	len = aglen;
+	while (len > 0) {
+		llen = clen = rlen = 0;
+		real_crl = false;
+		/*
+		 * Look up the current and left rlextents.
+		 */
+		error = xfs_reflink_lookup_le(cur, bno, &have);
+		if (error)
+			goto error0;
+		if (have) {
+			error = xfs_reflink_get_rec(cur, &cbno, &clen, &cnr,
+						    &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, cbno, clen, cnr,
+						      error0);
+			if (cbno != bno) {
+				/*
+				 * bno points to a hole; this is the left rlext.
+				 */
+				ASSERT((unsigned long long)lbno + llen <= bno);
+				lbno = cbno;
+				llen = clen;
+				lnr = cnr;
+
+				cbno = bno;
+				clen = len;
+				cnr = 1;
+			} else {
+				real_crl = true;
+				/*
+				 * Go find the left rlext.
+				 */
+				error = xfs_btree_decrement(cur, 0, &have);
+				if (error)
+					goto error0;
+				if (have) {
+					error = xfs_reflink_get_rec(cur, &lbno,
+							&llen, &lnr, &i);
+					if (error)
+						goto error0;
+					XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i,
+							lbno, llen, lnr,
+							error0);
+					ASSERT((unsigned long long)lbno + llen <= bno);
+				}
+				error = xfs_btree_increment(cur, 0, &have);
+				if (error)
+					goto error0;
+			}
+		} else {
+			/*
+			 * No left extent; just invent our current rlextent.
+			 */
+			cbno = bno;
+			clen = len;
+			cnr = 1;
+		}
+
+		/*
+		 * If the left rlext isn't adjacent, forget about it.
+		 */
+		if (llen > 0 && lbno + llen != bno)
+			llen = 0;
+
+		/*
+		 * Look up the right rlextent.
+		 */
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto error0;
+		if (have) {
+			error = xfs_reflink_get_rec(cur, &rbno, &rlen, &rnr,
+						    &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, rbno, rlen, rnr,
+						      error0);
+			if (agbno + aglen < rbno)
+				rlen = 0;
+			if (!real_crl)
+				clen = min(clen, rbno - cbno);
+			ASSERT((unsigned long long)cbno + clen <= rbno);
+		}
+
+		/*
+		 * Point the cursor to cbno (or where it will be inserted).
+		 */
+		if (real_crl) {
+			error = xfs_btree_decrement(cur, 0, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+		}
+		ASSERT(clen > 0);
+		ASSERT(cbno == bno);
+		ASSERT(cbno >= agbno);
+		ASSERT((unsigned long long)cbno + clen <=
+		       (unsigned long long)agbno + aglen);
+		if (real_crl)
+			ASSERT(cnr > 1);
+		else
+			ASSERT(cnr == 1);
+		new_cnr = cnr + adj;
+
+#ifdef REFLINK_DEBUG
+		{
+		xfs_agblock_t gbno;
+		xfs_extlen_t glen;
+		xfs_nlink_t gnr;
+		xfs_reflink_get_rec(cur, &gbno, &glen, &gnr, &i);
+		printk(KERN_ERR "%s: insert ag=%u [%u:%u:%d] ", __func__,
+		       agno, agbno, agbend, adj);
+		if (llen)
+			printk("l:[%u,%u,%u] ", lbno, llen, lnr);
+		printk("[%u,%u,%u,%d] ", cbno, clen, cnr, real_crl);
+		if (rlen)
+			printk("r:[%u,%u,%u] ", rbno, rlen, rnr);
+		printk("\n");
+		dump_cur_loc(cur, "cur", __LINE__);
+		}
+#endif
+		/*
+		 * Nothing to do when unmapping a range of blocks with
+		 * a single owner.
+		 */
+		if (new_cnr == 0) {
+			dbg_printk("single-owner blocks; ignoring");
+			goto advloop;
+		}
+
+		/*
+		 * These blocks have hit MAXRLCOUNT; keep it that way.
+		 */
+		if (cnr == MAXRLCOUNT) {
+			dbg_printk("hit MAXRLCOUNT; moving on");
+			goto advloop;
+		}
+
+		/*
+		 * Try to merge with left and right rlexts outside range.
+		 */
+		if (llen > 0 && rlen > 0 &&
+		    lbno + llen == agbno &&
+		    rbno == agbend + 1 &&
+		    lbno + llen + clen == rbno &&
+		    (unsigned long long)llen + clen + rlen < MAXRLEXTLEN &&
+		    lnr == rnr &&
+		    lnr == new_cnr) {
+			dbg_printk("merge l/c/rext\n");
+			error = xfs_reflinkbt_delete(cur, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_btree_decrement(cur, 0, &have);
+			if (error)
+				goto error0;
+			error = xfs_reflinkbt_update(cur, lbno,
+					llen + clen + rlen, lnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			break;
+		}
+
+		/*
+		 * Try to merge with left rlext outside the range.
+		 */
+		if (llen > 0 &&
+		    lbno + llen == agbno &&
+		    lnr == new_cnr &&
+		    (unsigned long long)llen + clen < MAXRLEXTLEN) {
+			dbg_printk("merge l/cext\n");
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_btree_decrement(cur, 0, &have);
+			if (error)
+				goto error0;
+			error = xfs_reflinkbt_update(cur, lbno,
+					llen + clen, lnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * Try to merge with right rlext outside the range.
+		 */
+		if (rlen > 0 &&
+		    rbno == agbend + 1 &&
+		    rnr == new_cnr &&
+		    cbno + clen == rbno &&
+		    (unsigned long long)clen + rlen < MAXRLEXTLEN) {
+			dbg_printk("merge c/rext\n");
+			if (real_crl) {
+				error = xfs_reflinkbt_delete(cur, &i);
+				if (error)
+					goto error0;
+				XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			}
+
+			error = xfs_reflinkbt_update(cur, cbno,
+					clen + rlen, rnr);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, have == 1, error0);
+			break;
+		}
+
+		/*
+		 * rlext is no longer reflinked; remove it from tree.
+		 */
+		if (new_cnr == 1 && adj < 0) {
+			dbg_printk("remove cext\n");
+			ASSERT(real_crl == true);
+			error = xfs_reflinkbt_delete(cur, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * rlext needs to be added to the tree.
+		 */
+		if (new_cnr == 2 && adj > 0) {
+			dbg_printk("insert cext\n");
+			error = xfs_reflinkbt_insert(cur, cbno, clen,
+					new_cnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, error0);
+			goto advloop;
+		}
+
+		/*
+		 * Update rlext.
+		 */
+		dbg_printk("update cext\n");
+		ASSERT(new_cnr >= 2);
+		error = xfs_reflinkbt_update(cur, cbno, clen, new_cnr);
+		if (error)
+			goto error0;
+
+advloop:
+		bno += clen;
+		len -= clen;
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * xfs_is_reflink_inode() -- Decide if an inode needs to be checked for CoW.
+ *
+ * @ip: XFS inode
+ */
+bool
+xfs_is_reflink_inode(
+	struct xfs_inode	*ip)		/* XFS inode */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	if (!xfs_sb_version_hasreflink(&mp->m_sb))
+		return false;
+	if (!(ip->i_d.di_flags & XFS_DIFLAG_REFLINK))
+		return false;
+
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	return true;
+}
+
+/**
+ * xfs_reflink_bmap_add_free() - release a range of blocks
+ *
+ * @mp: XFS mount object
+ * @flist: List of blocks to be freed at the end of the transaction
+ * @fsbno: First fs block of the range to release
+ * @len: Length of range
+ * @owner: owner of the extent
+ * @tp: transaction that goes with the free operation
+ */
+int
+xfs_reflink_bmap_add_free(
+	struct xfs_mount	*mp,		/* mount point structure */
+	xfs_bmap_free_t		*flist,		/* list of extents */
+	struct xfs_inode	*ip,		/* xfs inode */
+	xfs_fsblock_t		fsbno,		/* fs block number of extent */
+	xfs_filblks_t		fslen,		/* length of extent */
+	uint64_t		owner,		/* extent owner */
+	struct xfs_trans	*tp)		/* transaction */
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_agblock_t		agbend;		/* ag end of range to free */
+	xfs_extlen_t		aglen;		/* ag length of range to free */
+	int			i, have;
+	xfs_agblock_t		lbno;		/* rlextent start */
+	xfs_extlen_t		llen;		/* rlextent length */
+	xfs_nlink_t		lnr;		/* rlextent refcount */
+	xfs_agblock_t		bno;		/* rlext block # in loop */
+	xfs_extlen_t		len;		/* rlext length in loop */
+	unsigned long long	blocks_freed;
+	xfs_fsblock_t		range_fsb;
+
+	if (!xfs_is_reflink_inode(ip)) {
+		xfs_bmap_add_free(fsbno, fslen, flist, mp);
+		return 0;
+	}
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	CHECK_AG_NUMBER(mp, agno);
+	ASSERT(fslen < mp->m_sb.sb_agblocks);
+	CHECK_AG_EXTENT(mp, agbno, fslen);
+	aglen = fslen;
+
+	/*
+	 * Drop reference counts in the reflink tree.
+	 */
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	/*
+	 * Grab a rl btree cursor.
+	 */
+	cur = xfs_reflinkbt_init_cursor(mp, tp, agbp, agno);
+	bno = agbno;
+	len = aglen;
+	agbend = agbno + aglen - 1;
+	blocks_freed = 0;
+
+	/*
+	 * Account for a left extent that partially covers our range.
+	 */
+	error = xfs_reflink_lookup_le(cur, bno, &have);
+	if (error)
+		goto error0;
+	if (have) {
+		error = xfs_reflink_get_rec(cur, &lbno, &llen, &lnr, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr, error0);
+		if (lbno + llen > bno) {
+			blocks_freed += min(len, lbno + llen - bno);
+			bno += blocks_freed;
+			len -= blocks_freed;
+		}
+	}
+
+	while (len > 0) {
+		/*
+		 * Go find the next rlext.
+		 */
+		range_fsb = XFS_AGB_TO_FSB(mp, agno, bno);
+		error = xfs_btree_increment(cur, 0, &have);
+		if (error)
+			goto error0;
+		if (!have) {
+			/*
+			 * There's no right rlextent, so free bno to the end.
+			 */
+			lbno = bno + len;
+			llen = 0;
+		} else {
+			/*
+			 * Find the next rlextent.
+			 */
+			error = xfs_reflink_get_rec(cur, &lbno, &llen,
+					&lnr, &i);
+			if (error)
+				goto error0;
+			XFS_WANT_CORRUPTED_RLEXT_GOTO(mp, i, lbno, llen, lnr,
+						      error0);
+			if (lbno >= bno + len) {
+				lbno = bno + len;
+				llen = 0;
+			}
+		}
+
+		/*
+		 * Free everything up to the start of the rlextent and
+		 * account for still-mapped blocks.
+		 */
+		if (lbno - bno > 0) {
+			xfs_bmap_add_free(range_fsb, lbno - bno,
+					  flist, mp);
+			len -= lbno - bno;
+			bno += lbno - bno;
+		}
+		llen = min(llen, agbend + 1 - lbno);
+		blocks_freed += llen;
+		len -= llen;
+		bno += llen;
+	}
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+
+	error = xfs_reflinkbt_adjust_refcount(mp, tp, agbp, agno, agbno, aglen,
+					      -1);
+	xfs_trans_brelse(tp, agbp);
+
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	xfs_trans_brelse(tp, agbp);
+	return error;
+}
diff --git a/libxfs/xfs_reflink_btree.h b/libxfs/xfs_reflink_btree.h
new file mode 100644
index 0000000..46dd0f2
--- /dev/null
+++ b/libxfs/xfs_reflink_btree.h
@@ -0,0 +1,81 @@
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
+extern int xfs_reflinkbt_adjust_refcount(struct xfs_mount *, struct xfs_trans *,
+		struct xfs_buf *, xfs_agnumber_t, xfs_agblock_t, xfs_extlen_t,
+		int);
+
+extern int xfs_reflink_bmap_add_free(struct xfs_mount *mp,
+		xfs_bmap_free_t *flist, struct xfs_inode *ip,
+		xfs_fsblock_t fsbno, xfs_filblks_t len,
+		uint64_t owner, struct xfs_trans *tp);
+
+extern bool xfs_is_reflink_inode(struct xfs_inode *ip);
+
+#endif	/* __XFS_REFLINK_BTREE_H__ */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 18a4bb0..641d578 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -34,6 +34,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_reflink_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -682,6 +684,11 @@ xfs_sb_mount_common(
 	mp->m_inobt_mnr[0] = mp->m_inobt_mxr[0] / 2;
 	mp->m_inobt_mnr[1] = mp->m_inobt_mxr[1] / 2;
 
+	mp->m_rlbt_mxr[0] = xfs_reflinkbt_maxrecs(mp, sbp->sb_blocksize, 1);
+	mp->m_rlbt_mxr[1] = xfs_reflinkbt_maxrecs(mp, sbp->sb_blocksize, 0);
+	mp->m_rlbt_mnr[0] = mp->m_rlbt_mxr[0] / 2;
+	mp->m_rlbt_mnr[1] = mp->m_rlbt_mxr[1] / 2;
+
 	mp->m_bmap_dmxr[0] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 1);
 	mp->m_bmap_dmxr[1] = xfs_bmbt_maxrecs(mp, sbp->sb_blocksize, 0);
 	mp->m_bmap_dmnr[0] = mp->m_bmap_dmxr[0] / 2;
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index e8e88f3..664c38d 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -53,6 +53,7 @@ extern const struct xfs_buf_ops xfs_dquot_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_quiet_buf_ops;
 extern const struct xfs_buf_ops xfs_symlink_buf_ops;
+extern const struct xfs_buf_ops xfs_reflinkbt_buf_ops;
 
 /*
  * Transaction types.  Used to distinguish types of buffers. These never reach
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index da87796..17feefa 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -112,7 +112,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_RLi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
