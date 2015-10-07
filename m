Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C462529ED8
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:09:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 12D82AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:09:33 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id bgB5Aj8brfGs9mDs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:09:24 -0700 (PDT)
Subject: [PATCH 38/51] libxfs: add support for refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:09:20 -0700
Message-ID: <20151007050920.1504.38788.stgit@birch.djwong.org>
In-Reply-To: <20151007050513.1504.28089.stgit@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
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

Import definitions and refcount btree code from the kernel.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h            |    2 
 include/linux.h             |    1 
 include/xfs_inode.h         |    5 
 include/xfs_mount.h         |    3 
 include/xfs_trace.h         |   26 +
 libxfs/Makefile             |    4 
 libxfs/xfs_alloc.c          |   18 +
 libxfs/xfs_bmap.c           |   80 +++-
 libxfs/xfs_bmap.h           |    9 
 libxfs/xfs_btree.c          |    8 
 libxfs/xfs_btree.h          |    7 
 libxfs/xfs_format.h         |   71 +++
 libxfs/xfs_fs.h             |    1 
 libxfs/xfs_refcount.c       |  980 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_refcount.h       |   41 ++
 libxfs/xfs_refcount_btree.c |  375 ++++++++++++++++
 libxfs/xfs_refcount_btree.h |   65 +++
 libxfs/xfs_sb.c             |    9 
 libxfs/xfs_shared.h         |    2 
 libxfs/xfs_types.h          |    2 
 20 files changed, 1699 insertions(+), 10 deletions(-)
 create mode 100644 libxfs/xfs_refcount.c
 create mode 100644 libxfs/xfs_refcount.h
 create mode 100644 libxfs/xfs_refcount_btree.c
 create mode 100644 libxfs/xfs_refcount_btree.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 9c85a49..8f3d0d1 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -78,6 +78,8 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_trace.h"
 #include "xfs_trans.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_refcount.h"
+#include "xfs_refcount_btree.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/include/linux.h b/include/linux.h
index 8804c2d..97fff5b 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -144,5 +144,6 @@ typedef loff_t		xfs_off_t;
 typedef __uint64_t	xfs_ino_t;
 typedef __uint32_t	xfs_dev_t;
 typedef __int64_t	xfs_daddr_t;
+typedef __uint32_t	xfs_nlink_t;
 
 #endif	/* __XFS_LINUX_H__ */
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 71c0fb4..238edfd 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -81,6 +81,11 @@ xfs_set_projid(struct xfs_icdinode *id, prid_t projid)
 	id->di_projid_lo = (__uint16_t) (projid & 0xffff);
 }
 
+static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+}
+
 typedef struct cred {
 	uid_t	cr_uid;
 	gid_t	cr_gid;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 5410168..8d20d69 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -66,6 +66,8 @@ typedef struct xfs_mount {
 	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
 	uint			m_rmap_mxr[2];	/* max rmap btree records */
 	uint			m_rmap_mnr[2];	/* min rmap btree records */
+	uint			m_refc_mxr[2];	/* max refc btree records */
+	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
@@ -134,6 +136,7 @@ typedef struct xfs_perag {
 	xfs_agino_t	pagl_leftrec;
 	xfs_agino_t	pagl_rightrec;
 	int		pagb_count;	/* pagb slots in use */
+	__uint8_t	pagf_refcount_level;
 } xfs_perag_t;
 
 #define LIBXFS_MOUNT_DEBUGGER		0x0001
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 2c8d34e..f5403d3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -190,4 +190,30 @@
 #define trace_xfs_rmap_lcombine(a...)			((void) 0)
 #define trace_xfs_rmap_rcombine(a...)			((void) 0)
 
+#define trace_xfs_refcountbt_lookup(a...)		((void)0)
+#define trace_xfs_refcountbt_get(a...)			((void)0)
+#define trace_xfs_refcountbt_update(a...)		((void)0)
+#define trace_xfs_refcountbt_insert(a...)		((void)0)
+#define trace_xfs_refcountbt_delete(a...)		((void)0)
+#define trace_xfs_refcount_split_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_split_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_split_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_split_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_center_extents_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_find_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_find_left_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_find_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_find_right_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_merge_center_extents(a...)	((void)0)
+#define trace_xfs_refcount_merge_left_extent(a...)	((void)0)
+#define trace_xfs_refcount_merge_right_extent(a...)	((void)0)
+#define trace_xfs_refcount_modify_extent(a...)		((void)0)
+#define trace_xfs_refcount_modify_extent_error(a...)	((void)0)
+#define trace_xfs_refcount_adjust_error(a...)		((void)0)
+#define trace_xfs_refcount_increase(a...)		((void)0)
+#define trace_xfs_refcount_decrease(a...)		((void)0)
+#define trace_xfs_reflink_relink_blocks(a...)		((void)0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 3255917..1badcc7 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -36,6 +36,8 @@ HFILES = \
 	xfs_inode_fork.h \
 	xfs_quota_defs.h \
 	xfs_rmap_btree.h \
+	xfs_refcount.h \
+	xfs_refcount_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -80,6 +82,8 @@ CFILES = cache.c \
 	xfs_inode_fork.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
+	xfs_refcount.c \
+	xfs_refcount_btree.c \
 	xfs_rtbitmap.c \
 	xfs_rmap.c \
 	xfs_rmap_btree.c \
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index d7f8302..fa76511 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -46,10 +46,23 @@ STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
 STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
 
+unsigned int
+xfs_refc_block(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return XFS_RMAP_BLOCK(mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		return XFS_FIBT_BLOCK(mp) + 1;
+	return XFS_IBT_BLOCK(mp) + 1;
+}
+
 xfs_extlen_t
 xfs_prealloc_blocks(
 	struct xfs_mount	*mp)
 {
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		return xfs_refc_block(mp) + 1;
 	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return XFS_RMAP_BLOCK(mp) + 1;
 	if (xfs_sb_version_hasfinobt(&mp->m_sb))
@@ -2402,6 +2415,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2521,6 +2538,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		/* XXX: pagb_tree doesn't exist in userspace */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 14934eb..8b9a563 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -37,6 +37,7 @@
 #include "xfs_trace.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_quota_defs.h"
+#include "xfs_refcount.h"
 #include "xfs_rmap_btree.h"
 
 
@@ -3994,6 +3995,56 @@ xfs_bmap_btalloc(
 }
 
 /*
+ * For a remap operation, just "allocate" an extent at the address that the
+ * caller passed in, and ensure that the AGFL is the right size.  The caller
+ * will then map the "allocated" extent into the file somewhere.
+ */
+static int
+xfs_bmap_remap(
+	struct xfs_bmalloca	*ap)
+{
+	struct xfs_trans	*tp = ap->tp;
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_agblock_t		bno;
+	struct xfs_alloc_arg	args;
+	int			error;
+
+	/*
+	 * validate that the block number is legal - the enables us to detect
+	 * and handle a silent filesystem corruption rather than crashing.
+	 */
+	memset(&args, 0, sizeof(struct xfs_alloc_arg));
+	args.tp = ap->tp;
+	args.mp = ap->tp->t_mountp;
+	bno = *ap->firstblock;
+	args.agno = XFS_FSB_TO_AGNO(mp, bno);
+	if (args.agno >= mp->m_sb.sb_agcount)
+		return -EFSCORRUPTED;
+
+	args.agbno = XFS_FSB_TO_AGBNO(mp, bno);
+	if (args.agbno >= mp->m_sb.sb_agblocks)
+		return -EFSCORRUPTED;
+
+	/* "Allocate" the extent from the range we passed in. */
+	trace_xfs_reflink_relink_blocks(ap->ip, *ap->firstblock,
+			ap->length);
+	ap->blkno = bno;
+	ap->ip->i_d.di_nblocks += ap->length;
+	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
+
+	/* Fix the freelist, like a real allocator does. */
+
+	args.pag = xfs_perag_get(args.mp, args.agno);
+	ASSERT(args.pag);
+
+	error = xfs_alloc_fix_freelist(&args, XFS_ALLOC_FLAG_FREEING);
+	if (error)
+		goto error0;
+error0:
+	xfs_perag_put(args.pag);
+	return error;
+}
+/*
  * xfs_bmap_alloc is called by xfs_bmapi to allocate an extent for a file.
  * It figures out where to ask the underlying allocator to put the new extent.
  */
@@ -4001,6 +4052,8 @@ STATIC int
 xfs_bmap_alloc(
 	struct xfs_bmalloca	*ap)	/* bmap alloc argument struct */
 {
+	if (ap->flags & XFS_BMAPI_REMAP)
+		return xfs_bmap_remap(ap);
 	if (XFS_IS_REALTIME_INODE(ap->ip) && ap->userdata)
 		return xfs_bmap_rtalloc(ap);
 	return xfs_bmap_btalloc(ap);
@@ -4684,6 +4737,12 @@ xfs_bmapi_write(
 	ASSERT(len > 0);
 	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(!(flags & XFS_BMAPI_REMAP));
+	if (flags & XFS_BMAPI_REMAP) {
+		ASSERT(!(flags & XFS_BMAPI_PREALLOC));
+		ASSERT(!(flags & XFS_BMAPI_CONVERT));
+	}
 
 	if (unlikely(XFS_TEST_ERROR(
 	    (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS &&
@@ -4733,6 +4792,12 @@ xfs_bmapi_write(
 		wasdelay = !inhole && isnullstartblock(bma.got.br_startblock);
 
 		/*
+		 * Make sure we only reflink into a hole.
+		 */
+		if (flags & XFS_BMAPI_REMAP)
+			ASSERT(inhole);
+
+		/*
 		 * First, deal with the hole before the allocated space
 		 * that we found, if any.
 		 */
@@ -5173,9 +5238,18 @@ xfs_bmap_del_extent(
 	/*
 	 * If we need to, add to list of extents to delete.
 	 */
-	if (do_fx)
-		xfs_bmap_add_free(mp, flist, del->br_startblock,
-			del->br_blockcount, NULL);
+	if (do_fx) {
+		if (xfs_is_reflink_inode(ip)) {
+			error = xfs_refcount_put_extent(mp, tp, flist,
+						del->br_startblock,
+						del->br_blockcount, NULL);
+			if (error)
+				goto done;
+		} else
+			xfs_bmap_add_free(mp, flist, del->br_startblock,
+					  del->br_blockcount, NULL);
+	}
+
 	/*
 	 * Adjust inode # blocks in the file.
 	 */
diff --git a/libxfs/xfs_bmap.h b/libxfs/xfs_bmap.h
index da73d59..64d8743 100644
--- a/libxfs/xfs_bmap.h
+++ b/libxfs/xfs_bmap.h
@@ -110,6 +110,12 @@ typedef	struct xfs_bmap_free
  * from written to unwritten, otherwise convert from unwritten to written.
  */
 #define XFS_BMAPI_CONVERT	0x040
+/*
+ * Map the inode offset to the block given in ap->firstblock.  Primarily
+ * used for reflink.  The range must be in a hole, and this flag cannot be
+ * turned on with PREALLOC or CONVERT, and cannot be used on the attr fork.
+ */
+#define XFS_BMAPI_REMAP		0x100
 
 #define XFS_BMAPI_FLAGS \
 	{ XFS_BMAPI_ENTIRE,	"ENTIRE" }, \
@@ -118,7 +124,8 @@ typedef	struct xfs_bmap_free
 	{ XFS_BMAPI_PREALLOC,	"PREALLOC" }, \
 	{ XFS_BMAPI_IGSTATE,	"IGSTATE" }, \
 	{ XFS_BMAPI_CONTIG,	"CONTIG" }, \
-	{ XFS_BMAPI_CONVERT,	"CONVERT" }
+	{ XFS_BMAPI_CONVERT,	"CONVERT" }, \
+	{ XFS_BMAPI_REMAP,	"REMAP" }
 
 
 static inline int xfs_bmapi_aflag(int w)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 000267a..b8f8281 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -41,9 +41,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
 	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
-	  XFS_FIBT_MAGIC },
+	  XFS_FIBT_MAGIC, 0 },
 	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
-	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
+	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC,
+	  XFS_REFC_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
 	xfs_magics[!!((cur)->bc_flags & XFS_BTREE_CRC_BLOCKS)][cur->bc_btnum]
@@ -1117,6 +1118,9 @@ xfs_btree_set_refs(
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
index dd29d15..94848a1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
@@ -66,6 +68,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
 /*
  * For logging record fields.
@@ -98,6 +101,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(refcbt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -113,6 +117,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_ADD(refcbt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -205,6 +210,7 @@ typedef struct xfs_btree_cur
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
 		struct xfs_rmap_irec	r;
+		struct xfs_refcount_irec	rc;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
@@ -217,6 +223,7 @@ typedef struct xfs_btree_cur
 	union {
 		struct {			/* needed for BNO, CNT, INO */
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
+			struct xfs_bmap_free *flist;	/* list to free after */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index ead7f30..0a13520 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -448,9 +448,11 @@ xfs_sb_has_compat_feature(
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
+#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
-		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
+		 XFS_SB_FEAT_RO_COMPAT_REFLINK)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -521,6 +523,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
@@ -633,12 +641,15 @@ typedef struct xfs_agf {
 	__be32		agf_btreeblks;	/* # of blocks held in AGF btrees */
 	uuid_t		agf_uuid;	/* uuid of filesystem */
 
+	__be32		agf_refcount_root;	/* refcount tree root block */
+	__be32		agf_refcount_level;	/* refcount btree levels */
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
@@ -1024,6 +1035,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
 	 XFS_DIFLAG_EXTSZINHERIT | XFS_DIFLAG_NODEFRAG | XFS_DIFLAG_FILESTREAM)
 
 /*
+ * Values for di_flags2
+ * There should be a one-to-one correspondence between these flags and the
+ * XFS_XFLAG_s.
+ */
+#define XFS_DIFLAG2_REFLINK_BIT   0	/* file's blocks may be reflinked */
+#define XFS_DIFLAG2_REFLINK      (1 << XFS_DIFLAG2_REFLINK_BIT)
+
+#define XFS_DIFLAG2_ANY \
+	(XFS_DIFLAG2_REFLINK)
+
+
+/*
  * Inode number format:
  * low inopblog bits - offset in block
  * next agblklog bits - block number in ag
@@ -1368,7 +1391,8 @@ XFS_RMAP_INO_OWNER(
 #define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
-#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+#define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
+#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
@@ -1471,6 +1495,47 @@ xfs_owner_info_pack(
 }
 
 /*
+ * Reference Count Btree format definitions
+ *
+ */
+#define	XFS_REFC_CRC_MAGIC	0x52334643	/* 'R3FC' */
+
+unsigned int xfs_refc_block(struct xfs_mount *mp);
+
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
+
+/*
  * BMAP Btree format definitions
  *
  * This includes both the root block definition that sits inside an inode fork
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index d7ec790..b17ccd5 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -67,6 +67,7 @@ struct fsxattr {
 #define XFS_XFLAG_EXTSZINHERIT	0x00001000	/* inherit inode extent size */
 #define XFS_XFLAG_NODEFRAG	0x00002000  	/* do not defragment */
 #define XFS_XFLAG_FILESTREAM	0x00004000	/* use filestream allocator */
+#define XFS_XFLAG_REFLINK	0x00008000	/* file is reflinked */
 #define XFS_XFLAG_HASATTR	0x80000000	/* no DIFLAG for this	*/
 
 /*
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
new file mode 100644
index 0000000..3e3b166
--- /dev/null
+++ b/libxfs/xfs_refcount.c
@@ -0,0 +1,980 @@
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
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
+#include "xfs_alloc.h"
+#include "xfs_trace.h"
+#include "xfs_cksum.h"
+#include "xfs_trans.h"
+#include "xfs_bit.h"
+#include "xfs_refcount.h"
+
+/**
+ * xfs_refcountbt_lookup_le() -- Look up the first record less than or equal to
+ *				 [bno, len] in the btree given by cur.
+ * @cur: refcount btree cursor
+ * @bno: AG block number to look up
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int
+xfs_refcountbt_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	int			*stat)
+{
+	trace_xfs_refcountbt_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_LE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/**
+ * xfs_refcountbt_lookup_ge() -- Look up the first record greater than or equal
+ *				 to [bno, len] in the btree given by cur.
+ * @cur: refcount btree cursor
+ * @bno: AG block number to look up
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int					/* error */
+xfs_refcountbt_lookup_ge(
+	struct xfs_btree_cur	*cur,	/* btree cursor */
+	xfs_agblock_t		bno,	/* starting block of extent */
+	int			*stat)	/* success/failure */
+{
+	trace_xfs_refcountbt_lookup(cur->bc_mp, cur->bc_private.a.agno, bno,
+			XFS_LOOKUP_GE);
+	cur->bc_rec.rc.rc_startblock = bno;
+	cur->bc_rec.rc.rc_blockcount = 0;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_GE, stat);
+}
+
+/**
+ * xfs_refcountbt_get_rec() -- Get the data from the pointed-to record.
+ *
+ * @cur: refcount btree cursor
+ * @irec: set to the record currently pointed to by the btree cursor
+ * @stat: set to 1 if successful, 0 otherwise
+ */
+int
+xfs_refcountbt_get_rec(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec,
+	int				*stat)
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (!error && *stat == 1) {
+		irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
+		irec->rc_blockcount = be32_to_cpu(rec->refc.rc_blockcount);
+		irec->rc_refcount = be32_to_cpu(rec->refc.rc_refcount);
+		trace_xfs_refcountbt_get(cur->bc_mp, cur->bc_private.a.agno,
+				irec);
+	}
+	return error;
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, refcount].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcountbt_update(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec)
+{
+	union xfs_btree_rec	rec;
+
+	trace_xfs_refcountbt_update(cur->bc_mp, cur->bc_private.a.agno, irec);
+	rec.refc.rc_startblock = cpu_to_be32(irec->rc_startblock);
+	rec.refc.rc_blockcount = cpu_to_be32(irec->rc_blockcount);
+	rec.refc.rc_refcount = cpu_to_be32(irec->rc_refcount);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Insert the record referred to by cur to the value given
+ * by [bno, len, refcount].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcountbt_insert(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*irec,
+	int				*i)
+{
+	trace_xfs_refcountbt_insert(cur->bc_mp, cur->bc_private.a.agno, irec);
+	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
+	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
+	cur->bc_rec.rc.rc_refcount = irec->rc_refcount;
+	return xfs_btree_insert(cur, i);
+}
+
+/*
+ * Remove the record referred to by cur, then set the pointer to the spot
+ * where the record could be re-inserted, in case we want to increment or
+ * decrement the cursor.
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_refcountbt_delete(
+	struct xfs_btree_cur	*cur,
+	int			*i)
+{
+	struct xfs_refcount_irec	irec;
+	int			found_rec;
+	int			error;
+
+	error = xfs_refcountbt_get_rec(cur, &irec, &found_rec);
+	if (error)
+		return error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	trace_xfs_refcountbt_delete(cur->bc_mp, cur->bc_private.a.agno, &irec);
+	error = xfs_btree_delete(cur, i);
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, *i == 1, out_error);
+	if (error)
+		return error;
+	error = xfs_refcountbt_lookup_ge(cur, irec.rc_startblock, &found_rec);
+out_error:
+	return error;
+}
+
+/*
+ * Adjusting the Reference Count
+ *
+ * As stated elsewhere, the reference count btree (refcbt) stores
+ * >1 reference counts for extents of physical blocks.  In this
+ * operation, we're either raising or lowering the reference count of
+ * some subrange stored in the tree:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+-----+ +--+--------+---------
+ *  2  |   | 3 |  4  | |17|   55   |   10
+ * ----+   +---+-----+ +--+--------+---------
+ * X axis is physical blocks number;
+ * reference counts are the numbers inside the rectangles
+ *
+ * The first thing we need to do is to ensure that there are no
+ * refcount extents crossing either boundary of the range to be
+ * adjusted.  For any extent that does cross a boundary, split it into
+ * two extents so that we can increment the refcount of one of the
+ * pieces later:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+-----+ +--+--------+----+----
+ *  2  |   | 3 |  2  | |17|   55   | 10 | 10
+ * ----+   +---+-----+ +--+--------+----+----
+ *
+ * For this next step, let's assume that all the physical blocks in
+ * the adjustment range are mapped to a file and are therefore in use
+ * at least once.  Therefore, we can infer that any gap in the
+ * refcount tree within the adjustment range represents a physical
+ * extent with refcount == 1:
+ *
+ *      <------ adjustment range ------>
+ * ----+---+---+-----+-+--+--------+----+----
+ *  2  |"1"| 3 |  2  |1|17|   55   | 10 | 10
+ * ----+---+---+-----+-+--+--------+----+----
+ *      ^
+ *
+ * For each extent that falls within the interval range, figure out
+ * which extent is to the left or the right of that extent.  Now we
+ * have a left, current, and right extent.  If the new reference count
+ * of the center extent enables us to merge left, center, and right
+ * into one record covering all three, do so.  If the center extent is
+ * at the left end of the range, abuts the left extent, and its new
+ * reference count matches the left extent's record, then merge them.
+ * If the center extent is at the right end of the range, abuts the
+ * right extent, and the reference counts match, merge those.  In the
+ * example, we can left merge (assuming an increment operation):
+ *
+ *      <------ adjustment range ------>
+ * --------+---+-----+-+--+--------+----+----
+ *    2    | 3 |  2  |1|17|   55   | 10 | 10
+ * --------+---+-----+-+--+--------+----+----
+ *          ^
+ *
+ * For all other extents within the range, adjust the reference count
+ * or delete it if the refcount falls below 2.  If we were
+ * incrementing, the end result looks like this:
+ *
+ *      <------ adjustment range ------>
+ * --------+---+-----+-+--+--------+----+----
+ *    2    | 4 |  3  |2|18|   56   | 11 | 10
+ * --------+---+-----+-+--+--------+----+----
+ *
+ * The result of a decrement operation looks as such:
+ *
+ *      <------ adjustment range ------>
+ * ----+   +---+       +--+--------+----+----
+ *  2  |   | 2 |       |16|   54   |  9 | 10
+ * ----+   +---+       +--+--------+----+----
+ *      DDDD    111111DD
+ *
+ * The blocks marked "D" are freed; the blocks marked "1" are only
+ * referenced once and therefore the record is removed from the
+ * refcount btree.
+ */
+
+#define RLNEXT(rl)	((rl).rc_startblock + (rl).rc_blockcount)
+/*
+ * Split a left rlextent that crosses agbno.
+ */
+STATIC int
+try_split_left_rlextent(
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			agbno)
+{
+	struct xfs_refcount_irec	left, tmp;
+	int				found_rec;
+	int				error;
+
+	error = xfs_refcountbt_lookup_le(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &left, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (left.rc_startblock >= agbno || RLNEXT(left) <= agbno)
+		return 0;
+
+	trace_xfs_refcount_split_left_extent(cur->bc_mp, cur->bc_private.a.agno,
+			&left, agbno);
+	tmp = left;
+	tmp.rc_blockcount = agbno - left.rc_startblock;
+	error = xfs_refcountbt_update(cur, &tmp);
+	if (error)
+		goto out_error;
+
+	error = xfs_btree_increment(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+
+	tmp = left;
+	tmp.rc_startblock = agbno;
+	tmp.rc_blockcount -= (agbno - left.rc_startblock);
+	error = xfs_refcountbt_insert(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	return error;
+
+out_error:
+	trace_xfs_refcount_split_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Split a right rlextent that crosses agbno.
+ */
+STATIC int
+try_split_right_rlextent(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbnext)
+{
+	struct xfs_refcount_irec	right, tmp;
+	int				found_rec;
+	int				error;
+
+	error = xfs_refcountbt_lookup_le(cur, agbnext - 1, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &right, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	if (RLNEXT(right) <= agbnext)
+		return 0;
+
+	trace_xfs_refcount_split_right_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &right, agbnext);
+	tmp = right;
+	tmp.rc_startblock = agbnext;
+	tmp.rc_blockcount -= (agbnext - right.rc_startblock);
+	error = xfs_refcountbt_update(cur, &tmp);
+	if (error)
+		goto out_error;
+
+	tmp = right;
+	tmp.rc_blockcount = agbnext - right.rc_startblock;
+	error = xfs_refcountbt_insert(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+	return error;
+
+out_error:
+	trace_xfs_refcount_split_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge the left, center, and right extents.
+ */
+STATIC int
+merge_center(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*center,
+	unsigned long long		extlen,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	error = xfs_refcountbt_lookup_ge(cur, center->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	error = xfs_refcountbt_delete(cur, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (center->rc_refcount > 1) {
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount = extlen;
+	error = xfs_refcountbt_update(cur, left);
+	if (error)
+		goto out_error;
+
+	*aglen = 0;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_center_extents_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge with the left extent.
+ */
+STATIC int
+merge_left(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*cleft,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	if (cleft->rc_refcount > 1) {
+		error = xfs_refcountbt_lookup_le(cur, cleft->rc_startblock,
+				&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, left->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	left->rc_blockcount += cleft->rc_blockcount;
+	error = xfs_refcountbt_update(cur, left);
+	if (error)
+		goto out_error;
+
+	*agbno += cleft->rc_blockcount;
+	*aglen -= cleft->rc_blockcount;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Merge with the right extent.
+ */
+STATIC int
+merge_right(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*right,
+	struct xfs_refcount_irec	*cright,
+	xfs_agblock_t			*agbno,
+	xfs_extlen_t			*aglen)
+{
+	int				error;
+	int				found_rec;
+
+	if (cright->rc_refcount > 1) {
+		error = xfs_refcountbt_lookup_le(cur, cright->rc_startblock,
+			&found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		error = xfs_refcountbt_delete(cur, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+	}
+
+	error = xfs_refcountbt_lookup_le(cur, right->rc_startblock,
+			&found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	right->rc_startblock -= cright->rc_blockcount;
+	right->rc_blockcount += cright->rc_blockcount;
+	error = xfs_refcountbt_update(cur, right);
+	if (error)
+		goto out_error;
+
+	*aglen -= cright->rc_blockcount;
+	return error;
+
+out_error:
+	trace_xfs_refcount_merge_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Find the left extent and the one after it (cleft).  This function assumes
+ * that we've already split any extent crossing agbno.
+ */
+STATIC int
+find_left_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*left,
+	struct xfs_refcount_irec	*cleft,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			aglen)
+{
+	struct xfs_refcount_irec	tmp;
+	int				error;
+	int				found_rec;
+
+	left->rc_blockcount = cleft->rc_blockcount = 0;
+	error = xfs_refcountbt_lookup_le(cur, agbno - 1, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (RLNEXT(tmp) != agbno)
+		return 0;
+	/* We have a left extent; retrieve (or invent) the next right one */
+	*left = tmp;
+
+	error = xfs_btree_increment(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+	if (found_rec) {
+		error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		if (tmp.rc_startblock == agbno)
+			*cleft = tmp;
+		else {
+			cleft->rc_startblock = agbno;
+			cleft->rc_blockcount = min(aglen,
+					tmp.rc_startblock - agbno);
+			cleft->rc_refcount = 1;
+		}
+	} else {
+		cleft->rc_startblock = agbno;
+		cleft->rc_blockcount = aglen;
+		cleft->rc_refcount = 1;
+	}
+	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_private.a.agno,
+			left, cleft, agbno);
+	return error;
+
+out_error:
+	trace_xfs_refcount_find_left_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Find the right extent and the one before it (cright).  This function
+ * assumes that we've already split any extents crossing agbno + aglen.
+ */
+STATIC int
+find_right_extent(
+	struct xfs_btree_cur		*cur,
+	struct xfs_refcount_irec	*right,
+	struct xfs_refcount_irec	*cright,
+	xfs_agblock_t			agbno,
+	xfs_extlen_t			aglen)
+{
+	struct xfs_refcount_irec	tmp;
+	int				error;
+	int				found_rec;
+
+	right->rc_blockcount = cright->rc_blockcount = 0;
+	error = xfs_refcountbt_lookup_ge(cur, agbno + aglen, &found_rec);
+	if (error)
+		goto out_error;
+	if (!found_rec)
+		return 0;
+
+	error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1, out_error);
+
+	if (tmp.rc_startblock != agbno + aglen)
+		return 0;
+	/* We have a right extent; retrieve (or invent) the next left one */
+	*right = tmp;
+
+	error = xfs_btree_decrement(cur, 0, &found_rec);
+	if (error)
+		goto out_error;
+	if (found_rec) {
+		error = xfs_refcountbt_get_rec(cur, &tmp, &found_rec);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(cur->bc_mp, found_rec == 1,
+				out_error);
+
+		if (tmp.rc_startblock == agbno)
+			*cright = tmp;
+		else {
+			cright->rc_startblock = max(agbno,
+					RLNEXT(tmp));
+			cright->rc_blockcount = right->rc_startblock -
+					cright->rc_startblock;
+			cright->rc_refcount = 1;
+		}
+	} else {
+		cright->rc_startblock = agbno;
+		cright->rc_blockcount = aglen;
+		cright->rc_refcount = 1;
+	}
+	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_private.a.agno,
+			cright, right, agbno + aglen);
+	return error;
+
+out_error:
+	trace_xfs_refcount_find_right_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+#undef RLNEXT
+
+/*
+ * Try to merge with any extents on the boundaries of the adjustment range.
+ */
+STATIC int
+try_merge_rlextents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		*agbno,
+	xfs_extlen_t		*aglen,
+	int			adjust)
+{
+	struct xfs_refcount_irec	left, cleft, cright, right;
+	int				error;
+	unsigned long long		ulen;
+
+	left.rc_blockcount = cleft.rc_blockcount = 0;
+	cright.rc_blockcount = right.rc_blockcount = 0;
+
+	/*
+	 * Find extents abutting the start and end of the range, and
+	 * the adjacent extents inside the range.
+	 */
+	error = find_left_extent(cur, &left, &cleft, *agbno, *aglen);
+	if (error)
+		return error;
+	error = find_right_extent(cur, &right, &cright, *agbno, *aglen);
+	if (error)
+		return error;
+
+	/* No left or right extent to merge; exit. */
+	if (left.rc_blockcount == 0 && right.rc_blockcount == 0)
+		return 0;
+
+	/* Try a center merge */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount +
+			right.rc_blockcount;
+	if (left.rc_blockcount != 0 && right.rc_blockcount != 0 &&
+	    memcmp(&cleft, &cright, sizeof(cleft)) == 0 &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    right.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_center_extents(cur->bc_mp,
+			cur->bc_private.a.agno, &left, &cleft, &right);
+		return merge_center(cur, &left, &cleft, ulen, agbno, aglen);
+	}
+
+	/* Try a left merge */
+	ulen = (unsigned long long)left.rc_blockcount + cleft.rc_blockcount;
+	if (left.rc_blockcount != 0 &&
+	    left.rc_refcount == cleft.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_left_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &left, &cleft);
+		return merge_left(cur, &left, &cleft, agbno, aglen);
+	}
+
+	/* Try a right merge */
+	ulen = (unsigned long long)right.rc_blockcount + cright.rc_blockcount;
+	if (right.rc_blockcount != 0 &&
+	    right.rc_refcount == cright.rc_refcount + adjust &&
+	    ulen < MAXREFCEXTLEN) {
+		trace_xfs_refcount_merge_right_extent(cur->bc_mp,
+			cur->bc_private.a.agno, &cright, &right);
+		return merge_right(cur, &right, &cright, agbno, aglen);
+	}
+
+	return error;
+}
+
+/*
+ * Adjust the refcounts of middle extents.  At this point we should have
+ * split extents that crossed the adjustment range; merged with adjacent
+ * extents; and updated agbno/aglen to reflect the merges.  Therefore,
+ * all we have to do is update the extents inside [agbno, agbno + aglen].
+ */
+STATIC int
+adjust_rlextents(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	int			adj,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_refcount_irec	ext, tmp;
+	int				error;
+	int				found_rec, found_tmp;
+	xfs_fsblock_t			fsbno;
+
+	error = xfs_refcountbt_lookup_ge(cur, agbno, &found_rec);
+	if (error)
+		goto out_error;
+
+	while (aglen > 0) {
+		error = xfs_refcountbt_get_rec(cur, &ext, &found_rec);
+		if (error)
+			goto out_error;
+		if (!found_rec) {
+			ext.rc_startblock = cur->bc_mp->m_sb.sb_agblocks;
+			ext.rc_blockcount = 0;
+			ext.rc_refcount = 0;
+		}
+
+		/*
+		 * Deal with a hole in the refcount tree; if a file maps to
+		 * these blocks and there's no refcountbt recourd, pretend that
+		 * there is one with refcount == 1.
+		 */
+		if (ext.rc_startblock != agbno) {
+			tmp.rc_startblock = agbno;
+			tmp.rc_blockcount = min(aglen,
+					ext.rc_startblock - agbno);
+			tmp.rc_refcount = 1 + adj;
+			trace_xfs_refcount_modify_extent(cur->bc_mp,
+					cur->bc_private.a.agno, &tmp);
+
+			/*
+			 * Either cover the hole (increment) or
+			 * delete the range (decrement).
+			 */
+			if (tmp.rc_refcount) {
+				error = xfs_refcountbt_insert(cur, &tmp,
+						&found_tmp);
+				if (error)
+					goto out_error;
+				XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+						found_tmp == 1, out_error);
+			} else {
+				fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+						cur->bc_private.a.agno,
+						tmp.rc_startblock);
+				xfs_bmap_add_free(cur->bc_mp, flist, fsbno,
+						tmp.rc_blockcount, oinfo);
+			}
+
+			agbno += tmp.rc_blockcount;
+			aglen -= tmp.rc_blockcount;
+
+			error = xfs_refcountbt_lookup_ge(cur, agbno, &found_rec);
+			if (error)
+				goto out_error;
+		}
+
+		/* Stop if there's nothing left to modify */
+		if (aglen == 0)
+			break;
+
+		/*
+		 * Adjust the reference count and either update the tree
+		 * (incr) or free the blocks (decr).
+		 */
+		ext.rc_refcount += adj;
+		trace_xfs_refcount_modify_extent(cur->bc_mp,
+				cur->bc_private.a.agno, &ext);
+		if (ext.rc_refcount > 1) {
+			error = xfs_refcountbt_update(cur, &ext);
+			if (error)
+				goto out_error;
+		} else if (ext.rc_refcount == 1) {
+			error = xfs_refcountbt_delete(cur, &found_rec);
+			if (error)
+				goto out_error;
+			XFS_WANT_CORRUPTED_GOTO(cur->bc_mp,
+					found_rec == 1, out_error);
+			goto advloop;
+		} else {
+			fsbno = XFS_AGB_TO_FSB(cur->bc_mp,
+					cur->bc_private.a.agno,
+					ext.rc_startblock);
+			xfs_bmap_add_free(cur->bc_mp, flist, fsbno,
+					ext.rc_blockcount, oinfo);
+		}
+
+		error = xfs_btree_increment(cur, 0, &found_rec);
+		if (error)
+			goto out_error;
+
+advloop:
+		agbno += ext.rc_blockcount;
+		aglen -= ext.rc_blockcount;
+	}
+
+	return error;
+out_error:
+	trace_xfs_refcount_modify_extent_error(cur->bc_mp,
+			cur->bc_private.a.agno, error, _RET_IP_);
+	return error;
+}
+
+/*
+ * Adjust the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @adj: +1 to increment, -1 to decrement reference count
+ * @flist: freelist (only required if adj == -1)
+ * @owner: owner of the blocks (only required if adj == -1)
+ */
+STATIC int
+xfs_refcountbt_adjust_refcount(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	int			adj,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	struct xfs_btree_cur	*cur;
+	int			error;
+
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, flist);
+
+	/*
+	 * Ensure that no rlextents cross the boundary of the adjustment range.
+	 */
+	error = try_split_left_rlextent(cur, agbno);
+	if (error)
+		goto out_error;
+
+	error = try_split_right_rlextent(cur, agbno + aglen);
+	if (error)
+		goto out_error;
+
+	/*
+	 * Try to merge with the left or right extents of the range.
+	 */
+	error = try_merge_rlextents(cur, &agbno, &aglen, adj);
+	if (error)
+		goto out_error;
+
+	/* Now that we've taken care of the ends, adjust the middle extents */
+	error = adjust_rlextents(cur, agbno, aglen, adj, flist, oinfo);
+	if (error)
+		goto out_error;
+
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+out_error:
+	trace_xfs_refcount_adjust_error(mp, agno, error, _RET_IP_);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/**
+ * Increase the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @flist: List of blocks to free
+ */
+int
+xfs_refcount_increase(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_bmap_free	*flist)
+{
+	trace_xfs_refcount_increase(mp, agno, agbno, aglen);
+	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
+			aglen, 1, flist, NULL);
+}
+
+/**
+ * Decrease the reference count of a range of AG blocks.
+ *
+ * @mp: XFS mount object
+ * @tp: XFS transaction object
+ * @agbp: Buffer containing the AGF
+ * @agno: AG number
+ * @agbno: Start of range to adjust
+ * @aglen: Length of range to adjust
+ * @flist: List of blocks to free
+ * @owner: Extent owner
+ */
+int
+xfs_refcount_decrease(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		agbno,
+	xfs_extlen_t		aglen,
+	struct xfs_bmap_free	*flist,
+	struct xfs_owner_info	*oinfo)
+{
+	trace_xfs_refcount_decrease(mp, agno, agbno, aglen);
+	return xfs_refcountbt_adjust_refcount(mp, tp, agbp, agno, agbno,
+			aglen, -1, flist, oinfo);
+}
+
+/**
+ * xfs_refcount_put_extent() - release a range of blocks
+ *
+ * @mp: XFS mount object
+ * @tp: transaction that goes with the free operation
+ * @flist: List of blocks to be freed at the end of the transaction
+ * @fsbno: First fs block of the range to release
+ * @len: Length of range
+ * @owner: owner of the extent
+ */
+int
+xfs_refcount_put_extent(
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	struct xfs_bmap_free	*flist,
+	xfs_fsblock_t		fsbno,
+	xfs_filblks_t		fslen,
+	struct xfs_owner_info	*oinfo)
+{
+	int			error;
+	struct xfs_buf		*agbp;
+	xfs_agnumber_t		agno;		/* allocation group number */
+	xfs_agblock_t		agbno;		/* ag start of range to free */
+	xfs_extlen_t		aglen;		/* ag length of range to free */
+
+	agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	aglen = fslen;
+
+	/*
+	 * Drop reference counts in the refcount tree.
+	 */
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	error = xfs_refcount_decrease(mp, tp, agbp, agno, agbno, aglen, flist,
+			oinfo);
+	xfs_trans_brelse(tp, agbp);
+	return error;
+}
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
new file mode 100644
index 0000000..074d620
--- /dev/null
+++ b/libxfs/xfs_refcount.h
@@ -0,0 +1,41 @@
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
+#ifndef __XFS_REFCOUNT_H__
+#define __XFS_REFCOUNT_H__
+
+extern int xfs_refcountbt_lookup_le(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcountbt_lookup_ge(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, int *stat);
+extern int xfs_refcountbt_get_rec(struct xfs_btree_cur *cur,
+		struct xfs_refcount_irec *irec, int *stat);
+
+extern int xfs_refcount_increase(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t  aglen, struct xfs_bmap_free *flist);
+extern int xfs_refcount_decrease(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_buf *agbp, xfs_agnumber_t agno, xfs_agblock_t agbno,
+		xfs_extlen_t aglen, struct xfs_bmap_free *flist,
+		struct xfs_owner_info *oinfo);
+
+extern int xfs_refcount_put_extent(struct xfs_mount *mp, struct xfs_trans *tp,
+		struct xfs_bmap_free *flist, xfs_fsblock_t fsbno,
+		xfs_filblks_t len, struct xfs_owner_info *oinfo);
+
+#endif	/* __XFS_REFCOUNT_H__ */
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
new file mode 100644
index 0000000..745c6c3
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.c
@@ -0,0 +1,375 @@
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
+			cur->bc_private.a.flist);
+}
+
+STATIC void
+xfs_refcountbt_set_root(
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
+	agf->agf_refcount_root = ptr->s;
+	be32_add_cpu(&agf->agf_refcount_level, inc);
+	pag->pagf_refcount_level += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_refcountbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*start,
+	union xfs_btree_ptr	*new,
+	int			*stat)
+{
+	struct xfs_alloc_arg	args;		/* block allocation args */
+	int			error;		/* error return value */
+
+	memset(&args, 0, sizeof(args));
+	args.tp = cur->bc_tp;
+	args.mp = cur->bc_mp;
+	args.type = XFS_ALLOCTYPE_NEAR_BNO;
+	args.fsbno = XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_private.a.agno,
+			xfs_refc_block(args.mp));
+	args.firstblock = args.fsbno;
+	XFS_RMAP_AG_OWNER(&args.oinfo, XFS_RMAP_OWN_REFC);
+	args.minlen = args.maxlen = args.prod = 1;
+
+	error = xfs_alloc_vextent(&args);
+	if (error)
+		goto out_error;
+	if (args.fsbno == NULLFSBLOCK) {
+		XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+		*stat = 0;
+		return 0;
+	}
+	ASSERT(args.agno == cur->bc_private.a.agno);
+	ASSERT(args.len == 1);
+
+	new->s = cpu_to_be32(args.agbno);
+
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_EXIT);
+	*stat = 1;
+	return 0;
+
+out_error:
+	XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
+	return error;
+}
+
+STATIC int
+xfs_refcountbt_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = cur->bc_mp;
+	struct xfs_trans	*tp = cur->bc_tp;
+	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, XFS_BUF_ADDR(bp));
+	struct xfs_owner_info	oinfo;
+
+	XFS_RMAP_AG_OWNER(&oinfo, XFS_RMAP_OWN_REFC);
+	xfs_bmap_add_free(mp, cur->bc_private.a.flist, fsbno, 1,
+			&oinfo);
+	xfs_trans_binval(tp, bp);
+	return 0;
+}
+
+STATIC int
+xfs_refcountbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mnr[level != 0];
+}
+
+STATIC int
+xfs_refcountbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_refc_mxr[level != 0];
+}
+
+STATIC void
+xfs_refcountbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(rec->refc.rc_startblock != 0);
+
+	key->refc.rc_startblock = rec->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(key->refc.rc_startblock != 0);
+
+	rec->refc.rc_startblock = key->refc.rc_startblock;
+}
+
+STATIC void
+xfs_refcountbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	ASSERT(cur->bc_rec.rc.rc_startblock != 0);
+
+	rec->refc.rc_startblock = cpu_to_be32(cur->bc_rec.rc.rc_startblock);
+	rec->refc.rc_blockcount = cpu_to_be32(cur->bc_rec.rc.rc_blockcount);
+	rec->refc.rc_refcount = cpu_to_be32(cur->bc_rec.rc.rc_refcount);
+}
+
+STATIC void
+xfs_refcountbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_refcount_root != 0);
+
+	ptr->s = agf->agf_refcount_root;
+}
+
+STATIC __int64_t
+xfs_refcountbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_refcount_irec	*rec = &cur->bc_rec.rc;
+	struct xfs_refcount_key		*kp = &key->refc;
+
+	return (__int64_t)be32_to_cpu(kp->rc_startblock) - rec->rc_startblock;
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
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_refcountbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->refc.rc_startblock) <
+	       be32_to_cpu(k2->refc.rc_startblock);
+}
+
+STATIC int
+xfs_refcountbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	struct xfs_refcount_irec	a, b;
+
+	int ret = be32_to_cpu(r1->refc.rc_startblock) +
+		be32_to_cpu(r1->refc.rc_blockcount) <=
+		be32_to_cpu(r2->refc.rc_startblock);
+	if (!ret) {
+		a.rc_startblock = be32_to_cpu(r1->refc.rc_startblock);
+		a.rc_blockcount = be32_to_cpu(r1->refc.rc_blockcount);
+		a.rc_refcount = be32_to_cpu(r1->refc.rc_refcount);
+		b.rc_startblock = be32_to_cpu(r2->refc.rc_startblock);
+		b.rc_blockcount = be32_to_cpu(r2->refc.rc_blockcount);
+		b.rc_refcount = be32_to_cpu(r2->refc.rc_refcount);
+		trace_xfs_refcount_rec_order_error(cur->bc_mp,
+				cur->bc_private.a.agno, &a, &b);
+	}
+
+	return ret;
+}
+#endif	/* DEBUG */
+
+static const struct xfs_btree_ops xfs_refcountbt_ops = {
+	.rec_len		= sizeof(struct xfs_refcount_rec),
+	.key_len		= sizeof(struct xfs_refcount_key),
+
+	.dup_cursor		= xfs_refcountbt_dup_cursor,
+	.set_root		= xfs_refcountbt_set_root,
+	.alloc_block		= xfs_refcountbt_alloc_block,
+	.free_block		= xfs_refcountbt_free_block,
+	.get_minrecs		= xfs_refcountbt_get_minrecs,
+	.get_maxrecs		= xfs_refcountbt_get_maxrecs,
+	.init_key_from_rec	= xfs_refcountbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_refcountbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_refcountbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_refcountbt_init_ptr_from_cur,
+	.key_diff		= xfs_refcountbt_key_diff,
+	.buf_ops		= &xfs_refcountbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_refcountbt_keys_inorder,
+	.recs_inorder		= xfs_refcountbt_recs_inorder,
+#endif
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
diff --git a/libxfs/xfs_refcount_btree.h b/libxfs/xfs_refcount_btree.h
new file mode 100644
index 0000000..d51dc1a
--- /dev/null
+++ b/libxfs/xfs_refcount_btree.h
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
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index ddc1ecd..24d1f9b 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -34,6 +34,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_bmap.h"
+#include "xfs_refcount_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -706,6 +708,13 @@ xfs_sb_mount_common(
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
index 88efbb4..77d1220 100644
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
@@ -216,6 +217,7 @@ int	xfs_log_calc_minimum_size(struct xfs_mount *);
 #define	XFS_INO_REF		2
 #define	XFS_ATTR_BTREE_REF	1
 #define	XFS_DQUOT_REF		1
+#define	XFS_REFC_BTREE_REF	1
 
 /*
  * Flags for xfs_trans_ichgtime().
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index da87796..690d616 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -112,7 +112,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
