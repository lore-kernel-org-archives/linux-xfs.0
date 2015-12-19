Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF568819D
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:05:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6EC018F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 8Kr7KkLxL1ih39AG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:05:45 -0800 (PST)
Subject: [PATCH 08/53] libxfs: add the reverse-mapping btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:05:41 -0800
Message-ID: <20151219090541.14255.77227.stgit@birch.djwong.org>
In-Reply-To: <20151219090450.14255.48364.stgit@birch.djwong.org>
References: <20151219090450.14255.48364.stgit@birch.djwong.org>
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

>From : Dave Chinner <david@fromorbit.com>

Provide the basic libxfs code for the rmap btree from the kernel.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[split patch, add commit message]
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 include/libxfs.h          |    1 
 include/xfs_mount.h       |    2 
 include/xfs_trace.h       |    7 +
 libxfs/Makefile           |    3 
 libxfs/xfs_alloc.c        |   27 +++
 libxfs/xfs_alloc.h        |    6 +
 libxfs/xfs_bmap.c         |    3 
 libxfs/xfs_bmap_btree.c   |    1 
 libxfs/xfs_btree.h        |   22 ++
 libxfs/xfs_format.h       |   86 ++++++++-
 libxfs/xfs_ialloc.c       |    1 
 libxfs/xfs_ialloc_btree.c |    1 
 libxfs/xfs_rmap.c         |  413 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.c   |  404 ++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h   |   65 +++++++
 libxfs/xfs_sb.c           |    6 +
 libxfs/xfs_shared.h       |    1 
 libxfs/xfs_types.h        |    4 
 18 files changed, 1032 insertions(+), 21 deletions(-)
 create mode 100644 libxfs/xfs_rmap.c
 create mode 100644 libxfs/xfs_rmap_btree.c
 create mode 100644 libxfs/xfs_rmap_btree.h


diff --git a/include/libxfs.h b/include/libxfs.h
index 04c6f9c..7d1ad46 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -66,6 +66,7 @@ extern uint32_t crc32c_le(uint32_t crc, unsigned char const *p, size_t len);
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_attr_sf.h"
 #include "xfs_inode_fork.h"
 #include "xfs_inode_buf.h"
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 67f3b05..1daee74 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -64,6 +64,8 @@ typedef struct xfs_mount {
 	uint			m_bmap_dmnr[2];	/* XFS_BMAP_BLOCK_DMINRECS */
 	uint			m_inobt_mxr[2];	/* XFS_INOBT_BLOCK_MAXRECS */
 	uint			m_inobt_mnr[2];	/* XFS_INOBT_BLOCK_MINRECS */
+	uint			m_rmap_mxr[2];	/* max rmap btree records */
+	uint			m_rmap_mnr[2];	/* min rmap btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
 	uint			m_in_maxlevels;	/* XFS_IN_MAXLEVELS */
diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 423772f..ebdf778 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -171,4 +171,11 @@
 #define trace_xfs_perag_get_tag(a,b,c,d) ((c) = (c))
 #define trace_xfs_perag_put(a,b,c,d)	((c) = (c))
 
+#define trace_xfs_rmap_alloc_extent(a,b,c,d,e)		((void) 0)
+#define trace_xfs_rmap_alloc_extent_done(a,b,c,d,e)	((void) 0)
+#define trace_xfs_rmap_alloc_extent_error(a,b,c,d,e)	((void) 0)
+#define trace_xfs_rmap_free_extent(a,b,c,d,e)		((void) 0)
+#define trace_xfs_rmap_free_extent_done(a,b,c,d,e)	((void) 0)
+#define trace_xfs_rmap_free_extent_error(a,b,c,d,e)	((void) 0)
+
 #endif /* __TRACE_H__ */
diff --git a/libxfs/Makefile b/libxfs/Makefile
index ecf1921..3255917 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -35,6 +35,7 @@ HFILES = \
 	xfs_inode_buf.h \
 	xfs_inode_fork.h \
 	xfs_quota_defs.h \
+	xfs_rmap_btree.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
@@ -80,6 +81,8 @@ CFILES = cache.c \
 	xfs_ialloc_btree.c \
 	xfs_log_rlimit.c \
 	xfs_rtbitmap.c \
+	xfs_rmap.c \
+	xfs_rmap_btree.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
 	xfs_trans_resv.c
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index b43655c..fb6c705 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -26,6 +26,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
 #include "xfs_cksum.h"
@@ -632,6 +633,12 @@ xfs_alloc_ag_vextent(
 	ASSERT(!args->wasfromfl || !args->isfl);
 	ASSERT(args->agbno % args->alignment == 0);
 
+	/* insert new block into the reverse map btree */
+	error = xfs_rmap_alloc(args->tp, args->agbp, args->agno,
+			       args->agbno, args->len, args->owner);
+	if (error)
+		return error;
+
 	if (!args->wasfromfl) {
 		error = xfs_alloc_update_counters(args->tp, args->pag,
 						  args->agbp,
@@ -2016,6 +2023,7 @@ xfs_alloc_fix_freelist(
 	memset(&targs, 0, sizeof(targs));
 	targs.tp = tp;
 	targs.mp = mp;
+	targs.owner = XFS_RMAP_OWN_AG;
 	targs.agbp = agbp;
 	targs.agno = args->agno;
 	targs.alignment = targs.minlen = targs.prod = targs.isfl = 1;
@@ -2651,6 +2659,8 @@ error0:
  * Free an extent.
  * Just break up the extent address and hand off to xfs_free_ag_extent
  * after fixing up the freelist.
+ *
+ * XXX: need owner of extent being freed
  */
 int				/* error */
 xfs_free_extent(
@@ -2692,6 +2702,12 @@ xfs_free_extent(
 		goto error0;
 	}
 
+	/* XXX: need owner */
+	error = xfs_rmap_free(tp, args.agbp, args.agno, args.agbno, len, 0);
+	if (error)
+		goto error0;
+
+	/* XXX: initially no multiple references, so just free it */
 	error = xfs_free_ag_extent(tp, args.agbp, args.agno, args.agbno, len, 0);
 	if (!error)
 		xfs_extent_busy_insert(tp, args.agno, args.agbno, len, 0);
@@ -2699,3 +2715,14 @@ error0:
 	xfs_perag_put(args.pag);
 	return error;
 }
+
+xfs_extlen_t
+xfs_prealloc_blocks(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb))
+		return XFS_RMAP_BLOCK(mp) + 1;
+	if (xfs_sb_version_hasfinobt(&mp->m_sb))
+		return XFS_FIBT_BLOCK(mp) + 1;
+	return XFS_IBT_BLOCK(mp) + 1;
+}
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 071b28b..a9d8e97 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -72,6 +72,8 @@ typedef unsigned int xfs_alloctype_t;
  * needed freelist blocks is 4 fsbs _per AG_, a potential split of file's bmap
  * btree requires 1 fsb, so we set the number of set-aside blocks
  * to 4 + 4*agcount.
+ *
+ * XXX: this changes for rmapbt filesystems.
  */
 #define XFS_ALLOC_SET_ASIDE(mp)  (4 + ((mp)->m_sb.sb_agcount * 4))
 
@@ -86,10 +88,13 @@ typedef unsigned int xfs_alloctype_t;
  *
  * The AG headers are sector sized, so the amount of space they take up is
  * dependent on filesystem geometry. The others are all single blocks.
+ *
+ * XXX: this changes for rmapbt filesystems.
  */
 #define XFS_ALLOC_AG_MAX_USABLE(mp)	\
 	((mp)->m_sb.sb_agblocks - XFS_BB_TO_FSB(mp, XFS_FSS_TO_BB(mp, 4)) - 7)
 
+xfs_extlen_t	xfs_prealloc_blocks(struct xfs_mount *mp);
 
 /*
  * Argument structure for xfs_alloc routines.
@@ -122,6 +127,7 @@ typedef struct xfs_alloc_arg {
 	char		isfl;		/* set if is freelist blocks - !acctg */
 	char		userdata;	/* set if this is user data */
 	xfs_fsblock_t	firstblock;	/* io first block allocated */
+	uint64_t	owner;		/* owner of blocks being allocated */
 } xfs_alloc_arg_t;
 
 /*
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index ad383b4..3fe18fc 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -753,6 +753,7 @@ xfs_bmap_extents_to_btree(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
+	args.owner = ip->i_ino;
 	args.firstblock = *firstblock;
 	if (*firstblock == NULLFSBLOCK) {
 		args.type = XFS_ALLOCTYPE_START_BNO;
@@ -899,6 +900,7 @@ xfs_bmap_local_to_extents(
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
+	args.owner = ip->i_ino;
 	args.firstblock = *firstblock;
 	/*
 	 * Allocate a block.  We know we need only one, since the
@@ -3680,6 +3682,7 @@ xfs_bmap_btalloc(
 	memset(&args, 0, sizeof(args));
 	args.tp = ap->tp;
 	args.mp = mp;
+	args.owner = ap->ip->i_ino;
 	args.fsbno = ap->blkno;
 
 	/* Trim the allocation back to the maximum an AG can fit. */
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index a21f774..12d1a2d 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -443,6 +443,7 @@ xfs_bmbt_alloc_block(
 	args.mp = cur->bc_mp;
 	args.fsbno = cur->bc_private.b.firstblock;
 	args.firstblock = args.fsbno;
+	args.owner = cur->bc_private.b.ip->i_ino;
 
 	if (args.fsbno == NULLFSBLOCK) {
 		args.fsbno = be64_to_cpu(start->l);
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 8f18bab..48ab2b1 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
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
@@ -63,6 +65,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
+#define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 
 /*
  * For logging record fields.
@@ -94,6 +97,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(bmbt, stat); break;	\
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -108,6 +112,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_ADD(bmbt, stat, val); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
+	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -199,6 +204,7 @@ typedef struct xfs_btree_cur
 		xfs_alloc_rec_incore_t	a;
 		xfs_bmbt_irec_t		b;
 		xfs_inobt_rec_incore_t	i;
+		struct xfs_rmap_irec	r;
 	}		bc_rec;		/* current insert/search record value */
 	struct xfs_buf	*bc_bufs[XFS_BTREE_MAXLEVELS];	/* buf ptr per level */
 	int		bc_ptrs[XFS_BTREE_MAXLEVELS];	/* key/record # */
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index f6100be..52b1d06 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -455,8 +455,10 @@ xfs_sb_has_compat_feature(
 }
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
+#define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
-		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
+		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
+		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
 static inline bool
 xfs_sb_has_ro_compat_feature(
@@ -521,6 +523,12 @@ static inline int xfs_sb_version_hasfinobt(xfs_sb_t *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_FINOBT);
 }
 
+static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
+}
+
 static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 {
 	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
@@ -599,10 +607,10 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 #define	XFS_AGI_GOOD_VERSION(v)	((v) == XFS_AGI_VERSION)
 
 /*
- * Btree number 0 is bno, 1 is cnt.  This value gives the size of the
+ * Btree number 0 is bno, 1 is cnt, 2 is rmap. This value gives the size of the
  * arrays below.
  */
-#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_CNTi + 1)
+#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_RMAPi + 1)
 
 /*
  * The second word of agf_levels in the first a.g. overlaps the EFS
@@ -619,12 +627,10 @@ typedef struct xfs_agf {
 	__be32		agf_seqno;	/* sequence # starting from 0 */
 	__be32		agf_length;	/* size in blocks of a.g. */
 	/*
-	 * Freespace information
+	 * Freespace and rmap information
 	 */
 	__be32		agf_roots[XFS_BTNUM_AGF];	/* root blocks */
-	__be32		agf_spare0;	/* spare field */
 	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
-	__be32		agf_spare1;	/* spare field */
 
 	__be32		agf_flfirst;	/* first freelist block's index */
 	__be32		agf_fllast;	/* last freelist block's index */
@@ -1301,16 +1307,74 @@ typedef __be32 xfs_inobt_ptr_t;
 #define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
 
 /*
- * The first data block of an AG depends on whether the filesystem was formatted
- * with the finobt feature. If so, account for the finobt reserved root btree
- * block.
+ * Reverse mapping btree format definitions
+ *
+ * There is a btree for the reverse map per allocation group
  */
-#define XFS_PREALLOC_BLOCKS(mp) \
+#define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
+
+/*
+ * Special owner types.
+ *
+ * Seeing as we only support up to 8EB, we have the upper bit of the owner field
+ * to tell us we have a special owner value. We use these for static metadata
+ * allocated at mkfs/growfs time, as well as for freespace management metadata.
+ */
+#define XFS_RMAP_OWN_NULL	(-1ULL)	/* No owner, for growfs */
+#define XFS_RMAP_OWN_UNKNOWN	(-2ULL)	/* Unknown owner, for EFI recovery */
+#define XFS_RMAP_OWN_FS		(-3ULL)	/* static fs metadata */
+#define XFS_RMAP_OWN_LOG	(-4ULL)	/* static fs metadata */
+#define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
+#define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
+#define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
+#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+
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
+/*
+ * block numbers in the AG.
+ */
+#define	XFS_IBT_BLOCK(mp)		((xfs_agblock_t)(XFS_CNT_BLOCK(mp) + 1))
+#define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
+#define	XFS_RMAP_BLOCK(mp) \
 	(xfs_sb_version_hasfinobt(&((mp)->m_sb)) ? \
 	 XFS_FIBT_BLOCK(mp) + 1 : \
 	 XFS_IBT_BLOCK(mp) + 1)
 
-
+/*
+ * The first data block of an AG depends on whether the filesystem was formatted
+ * with the optional btree features. These need to be accounted for
+ * appropriately.
+ *
+ * XXX: this should be calculated once at mount time and stored in the struct
+ * xfs_mount rather than calculated every time it is used.
+ */
+#define XFS_PREALLOC_BLOCKS(mp)	xfs_prealloc_blocks(mp)
 
 /*
  * BMAP Btree format definitions
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index af670a8..12eaaab 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -615,6 +615,7 @@ xfs_ialloc_ag_alloc(
 	    args.mp->m_ialloc_min_blks < args.mp->m_ialloc_blks)
 		do_sparse = prandom_u32() & 1;
 #endif
+	args.owner = XFS_RMAP_OWN_INODES;
 
 	/*
 	 * Locking will ensure that we don't have two callers in here
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index f592ad1..77b41be 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -95,6 +95,7 @@ xfs_inobt_alloc_block(
 	memset(&args, 0, sizeof(args));
 	args.tp = cur->bc_tp;
 	args.mp = cur->bc_mp;
+	args.owner = XFS_RMAP_OWN_INOBT;
 	args.fsbno = XFS_AGB_TO_FSB(args.mp, cur->bc_private.a.agno, sbno);
 	args.minlen = 1;
 	args.maxlen = 1;
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
new file mode 100644
index 0000000..b2a3330
--- /dev/null
+++ b/libxfs/xfs_rmap.c
@@ -0,0 +1,413 @@
+
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
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_btree.h"
+#include "xfs_trans.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_trace.h"
+
+
+/*
+ * Lookup the first record less than or equal to [bno, len]
+ * in the btree given by cur.
+ */
+STATIC int
+xfs_rmap_lookup_le(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner,
+	int			*stat)
+{
+	cur->bc_rec.r.rm_startblock = bno;
+	cur->bc_rec.r.rm_blockcount = len;
+	cur->bc_rec.r.rm_owner = owner;
+	return xfs_btree_lookup(cur, XFS_LOOKUP_LE, stat);
+}
+
+/*
+ * Update the record referred to by cur to the value given
+ * by [bno, len, ref].
+ * This either works (return 0) or gets an EFSCORRUPTED error.
+ */
+STATIC int
+xfs_rmap_update(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*irec)
+{
+	union xfs_btree_rec	rec;
+
+	rec.rmap.rm_startblock = cpu_to_be32(irec->rm_startblock);
+	rec.rmap.rm_blockcount = cpu_to_be32(irec->rm_blockcount);
+	rec.rmap.rm_owner = cpu_to_be64(irec->rm_owner);
+	return xfs_btree_update(cur, &rec);
+}
+
+/*
+ * Get the data from the pointed-to record.
+ */
+STATIC int
+xfs_rmap_get_rec(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*irec,
+	int			*stat)
+{
+	union xfs_btree_rec	*rec;
+	int			error;
+
+	error = xfs_btree_get_rec(cur, &rec, stat);
+	if (error || !*stat)
+		return error;
+
+	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
+	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
+	irec->rm_owner = be64_to_cpu(rec->rmap.rm_owner);
+	return 0;
+}
+
+/*
+ * Find the extent in the rmap btree and remove it.
+ *
+ * The record we find should always span a range greater than or equal to the
+ * the extent being freed. This makes the code simple as, in theory, we do not
+ * have to handle ranges that are split across multiple records as extents that
+ * result in bmap btree extent merges should also result in rmap btree extent
+ * merges.  The owner field ensures we don't merge extents from different
+ * structures into the same record, hence this property should always hold true
+ * if we ensure that the rmap btree supports at least the same size maximum
+ * extent as the bmap btree (2^21 blocks at present).
+ *
+ * Complexity: when growing the filesystem, we "free" an extent when growing the
+ * last AG. This extent is new space and so it is not tracked as used space in
+ * the btree. The growfs code will pass in an owner of XFS_RMAP_OWN_NULL to
+ * indicate that it expected that there is no owner of this extent. We verify
+ * that - the extent lookup result in a record that does not overlap.
+ *
+ * Complexity #2: EFIs do not record the owner of the extent, so when recovering
+ * EFIs from the log we pass in XFS_RMAP_OWN_UNKNOWN to tell the rmap btree to
+ * ignore the owner (i.e. wildcard match) so we don't trigger corruption checks
+ * during log recovery.
+ */
+int
+xfs_rmap_free(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rmap_irec	ltrec;
+	int			error;
+	int			i;
+
+	/*
+	 * if rmap btree is not supported, then just return success without
+	 * doing anything.
+	 */
+	if (!xfs_sb_version_hasrmapbt(&tp->t_mountp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_free_extent(mp, agno, bno, len, owner);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	/*
+	 * We always have a left record because there's a static record
+	 * for the AG headers at rm_startblock == 0.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	/* special growfs case - bno is beyond last record */
+	if (owner == XFS_RMAP_OWN_NULL) {
+		XFS_WANT_CORRUPTED_GOTO(mp, bno > ltrec.rm_startblock +
+						ltrec.rm_blockcount, out_error);
+		goto out_done;
+	}
+
+	/* make sure the extent we found covers the entire freeing range. */
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock <= bno, out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_blockcount >= len, out_error);
+
+/*
+	if (owner != ltrec.rm_owner ||
+	    bno > ltrec.rm_startblock + ltrec.rm_blockcount)
+ */
+	//printk("rmfree  ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
+	//		agno, bno, len, owner, ltrec.rm_startblock,
+	//		ltrec.rm_blockcount, ltrec.rm_owner);
+	XFS_WANT_CORRUPTED_GOTO(mp, bno <= ltrec.rm_startblock + ltrec.rm_blockcount,
+				out_error);
+	XFS_WANT_CORRUPTED_GOTO(mp, owner == ltrec.rm_owner ||
+				(owner < XFS_RMAP_OWN_NULL &&
+				 owner >= XFS_RMAP_OWN_MIN), out_error);
+
+	/* exact match is easy */
+	if (ltrec.rm_startblock == bno && ltrec.rm_blockcount == len) {
+	//printk("remove exact\n");
+		/* remove extent from rmap tree */
+		error = xfs_btree_delete(cur, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	} else if (ltrec.rm_startblock == bno) {
+	//printk("remove left\n");
+		/*
+		 * overlap left hand side of extent
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing: |fffffffff|
+		 * Result:            |rrrrrrrrrr|
+		 *         bno       len
+		 */
+		ltrec.rm_startblock += len;
+		ltrec.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else if (ltrec.rm_startblock + ltrec.rm_blockcount == bno + len) {
+	//printk("remove right\n");
+		/*
+		 * overlap right hand side of extent
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:            |fffffffff|
+		 * Result:  |rrrrrrrrrr|
+		 *                    bno       len
+		 */
+		ltrec.rm_blockcount -= len;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else {
+		/*
+		 * overlap middle of extent
+		 *
+		 *       ltbno                ltlen
+		 * Orig:    |oooooooooooooooooooo|
+		 * Freeing:       |fffffffff|
+		 * Result:  |rrrrr|         |rrrr|
+		 *               bno       len
+		 */
+		xfs_extlen_t	orig_len = ltrec.rm_blockcount;
+	//printk("remove middle\n");
+
+		ltrec.rm_blockcount = bno - ltrec.rm_startblock;;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+
+		error = xfs_btree_increment(cur, 0, &i);
+		if (error)
+			goto out_error;
+
+		cur->bc_rec.r.rm_startblock = bno + len;
+		cur->bc_rec.r.rm_blockcount = orig_len - len -
+						     ltrec.rm_blockcount;
+		cur->bc_rec.r.rm_owner = ltrec.rm_owner;
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+	}
+
+out_done:
+	trace_xfs_rmap_free_extent_done(mp, agno, bno, len, owner);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_free_extent_error(mp, agno, bno, len, owner);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
+
+/*
+ * When we allocate a new block, the first thing we do is add a reference to the
+ * extent in the rmap btree. This is how we track the owner of the extent and th
+ * enumber of references to it.
+ *
+ * Initially, we do not have shared extents, and so the extent can only have a
+ * single reference count and owner. This makes the initial implementation easy,
+ * but does not allow us to use the rmap tree for tracking reflink shared files.
+ * Hence the initial implementation is simply a lookup to find the place to
+ * insert (and checking we don't find a duplicate/overlap) and then insertng the
+ * appropriate record.
+ */
+int
+xfs_rmap_alloc(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*agbp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	uint64_t		owner)
+{
+	struct xfs_btree_cur	*cur;
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rmap_irec	ltrec;
+	struct xfs_rmap_irec	gtrec;
+	int			have_gt;
+	int			error;
+	int			i;
+
+	/*
+	 * if rmap btree is not supported, then just return success without
+	 * doing anything.
+	 */
+	if (!xfs_sb_version_hasrmapbt(&tp->t_mountp->m_sb))
+		return 0;
+
+	trace_xfs_rmap_alloc_extent(mp, agno, bno, len, owner);
+	cur = xfs_rmapbt_init_cursor(mp, tp, agbp, agno);
+
+	/*
+	 * chekc to see if we find an existing record for this extent rather
+	 * than just the location for insert.
+	 */
+	error = xfs_rmap_lookup_le(cur, bno, len, owner, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+
+	error = xfs_rmap_get_rec(cur, &ltrec, &i);
+	if (error)
+		goto out_error;
+	XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, ltrec 0x%x/0x%x/0x%llx\n",
+	//		agno, bno, len, owner, ltrec.rm_startblock,
+	//		ltrec.rm_blockcount, ltrec.rm_owner);
+
+	XFS_WANT_CORRUPTED_GOTO(mp, ltrec.rm_startblock + ltrec.rm_blockcount <= bno,
+				out_error);
+
+	error = xfs_btree_increment(cur, 0, &have_gt);
+	if (error)
+		goto out_error;
+	if (have_gt) {
+		error = xfs_rmap_get_rec(cur, &gtrec, &i);
+		if (error)
+			goto out_error;
+		XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+	//printk("rmalloc ag %d bno 0x%x/0x%x/0x%llx, gtrec 0x%x/0x%x/0x%llx\n",
+	//		agno, bno, len, owner, gtrec.rm_startblock,
+	//		gtrec.rm_blockcount, gtrec.rm_owner);
+		XFS_WANT_CORRUPTED_GOTO(mp, bno + len <= gtrec.rm_startblock,
+					out_error);
+	} else {
+		gtrec.rm_owner = XFS_RMAP_OWN_NULL;
+	}
+
+	/* cursor currently points one record past ltrec */
+	if (ltrec.rm_owner == owner &&
+	    ltrec.rm_startblock + ltrec.rm_blockcount == bno) {
+		/*
+		 * left edge contiguous
+		 *
+		 *       ltbno     ltlen
+		 * orig:   |ooooooooo|
+		 * adding:           |aaaaaaaaa|
+		 * result: |rrrrrrrrrrrrrrrrrrr|
+		 *                  bno       len
+		 */
+		//printk("add left\n");
+		ltrec.rm_blockcount += len;
+		if (gtrec.rm_owner == owner &&
+		    bno + len == gtrec.rm_startblock) {
+			//printk("add middle\n");
+			/*
+			 * right edge also contiguous
+			 *
+			 *       ltbno     ltlen    gtbno     gtlen
+			 * orig:   |ooooooooo|         |ooooooooo|
+			 * adding:           |aaaaaaaaa|
+			 * result: |rrrrrrrrrrrrrrrrrrrrrrrrrrrrr|
+			 */
+			ltrec.rm_blockcount += gtrec.rm_blockcount;
+			error = xfs_btree_delete(cur, &i);
+			if (error)
+				goto out_error;
+			XFS_WANT_CORRUPTED_GOTO(mp, i == 1, out_error);
+		}
+
+		error = xfs_btree_decrement(cur, 0, &have_gt);
+		if (error)
+			goto out_error;
+		error = xfs_rmap_update(cur, &ltrec);
+		if (error)
+			goto out_error;
+	} else if (gtrec.rm_owner == owner &&
+		   bno + len == gtrec.rm_startblock) {
+		/*
+		 * right edge contiguous
+		 *
+		 *                 gtbno     gtlen
+		 * Orig:             |ooooooooo|
+		 * adding: |aaaaaaaaa|
+		 * Result: |rrrrrrrrrrrrrrrrrrr|
+		 *        bno       len
+		 */
+		//printk("add right\n");
+		gtrec.rm_startblock = bno;
+		gtrec.rm_blockcount += len;
+		error = xfs_rmap_update(cur, &gtrec);
+		if (error)
+			goto out_error;
+	} else {
+		//printk("add no match\n");
+		/* no contiguous edge with identical owner */
+		cur->bc_rec.r.rm_startblock = bno;
+		cur->bc_rec.r.rm_blockcount = len;
+		cur->bc_rec.r.rm_owner = owner;
+		error = xfs_btree_insert(cur, &i);
+		if (error)
+			goto out_error;
+	}
+
+	trace_xfs_rmap_alloc_extent_done(mp, agno, bno, len, owner);
+	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	return 0;
+
+out_error:
+	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, owner);
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	return error;
+}
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
new file mode 100644
index 0000000..ed1792d
--- /dev/null
+++ b/libxfs/xfs_rmap_btree.c
@@ -0,0 +1,404 @@
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
+#include "libxfs_priv.h"
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
+
+
+/*
+ * Reverse map btree.
+ *
+ * This is a per-ag tree used to track the owner of a given extent. Owner
+ * records are inserted when an extent is allocated, and removed when an extent
+ * is freed. For existing filesystems, there can only be one owner of an extent,
+ * usually an inode or some other metadata structure like a AG btree.
+ *
+ * Initial thoughts are that the
+ * value of the owner field needs external flags to define what it means, and
+ * hence we need a flags field in the record. This means the record is going to
+ * be larger than 16 bytes (agbno,len,owner = 16 bytes), so maybe this isn't the
+ * best idea. Initially just implement the owner field - we can probably steal
+ * bits from the extent length field for type descriptors given that MAXEXTLEN
+ * is only 21 bits if we want to store the type as well. Keep in mind that if we
+ * want to do this there are still restrictions on the length of extents we
+ * track in the rmap btree (see comments on xfs_rmap_free()).
+ *
+ * The rmap btree is part of the free space management, so blocks for the tree
+ * are sourced from the agfl. Hence we need transaction reservation support for
+ * this tree so that the freelist is always large enough. This also impacts on
+ * the minimum space we need to leave free in the AG.
+ *
+ * The tree is ordered by block number - there's no need to order/search by
+ * extent size for  online updating/management of the tree, and the reverse
+ * lookups are going to be "who owns this block" and so are by-block ordering is
+ * perfect for this.
+ *
+ * XXX: open question is how to handle blocks that are owned by the freespace
+ * tree blocks. Right now they will be classified when they are moved to the
+ * freelist or removed from the freelist. i.e. the extent allocation/freeing
+ * will mark the extents allocated as owned by the AG.
+ */
+STATIC struct xfs_btree_cur *
+xfs_rmapbt_dup_cursor(
+	struct xfs_btree_cur	*cur)
+{
+	return xfs_rmapbt_init_cursor(cur->bc_mp, cur->bc_tp,
+			cur->bc_private.a.agbp, cur->bc_private.a.agno);
+}
+
+STATIC void
+xfs_rmapbt_set_root(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr,
+	int			inc)
+{
+	struct xfs_buf		*agbp = cur->bc_private.a.agbp;
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(agbp);
+	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
+	int			btnum = cur->bc_btnum;
+	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+
+	ASSERT(ptr->s != 0);
+
+	agf->agf_roots[btnum] = ptr->s;
+	be32_add_cpu(&agf->agf_levels[btnum], inc);
+	pag->pagf_levels[btnum] += inc;
+	xfs_perag_put(pag);
+
+	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
+}
+
+STATIC int
+xfs_rmapbt_alloc_block(
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
+xfs_rmapbt_free_block(
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
+xfs_rmapbt_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rmap_mnr[level != 0];
+}
+
+STATIC int
+xfs_rmapbt_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	return cur->bc_mp->m_rmap_mxr[level != 0];
+}
+
+STATIC void
+xfs_rmapbt_init_key_from_rec(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	key->rmap.rm_startblock = rec->rmap.rm_startblock;
+}
+
+STATIC void
+xfs_rmapbt_init_rec_from_key(
+	union xfs_btree_key	*key,
+	union xfs_btree_rec	*rec)
+{
+	rec->rmap.rm_startblock = key->rmap.rm_startblock;
+}
+
+STATIC void
+xfs_rmapbt_init_rec_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec)
+{
+	rec->rmap.rm_startblock = cpu_to_be32(cur->bc_rec.r.rm_startblock);
+	rec->rmap.rm_blockcount = cpu_to_be32(cur->bc_rec.r.rm_blockcount);
+	rec->rmap.rm_owner = cpu_to_be64(cur->bc_rec.r.rm_owner);
+}
+
+STATIC void
+xfs_rmapbt_init_ptr_from_cur(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xfs_agf		*agf = XFS_BUF_TO_AGF(cur->bc_private.a.agbp);
+
+	ASSERT(cur->bc_private.a.agno == be32_to_cpu(agf->agf_seqno));
+	ASSERT(agf->agf_roots[cur->bc_btnum] != 0);
+
+	ptr->s = agf->agf_roots[cur->bc_btnum];
+}
+
+STATIC __int64_t
+xfs_rmapbt_key_diff(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*key)
+{
+	struct xfs_rmap_irec	*rec = &cur->bc_rec.r;
+	struct xfs_rmap_key	*kp = &key->rmap;
+
+	return (__int64_t)be32_to_cpu(kp->rm_startblock) - rec->rm_startblock;
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
+
+#if defined(DEBUG) || defined(XFS_WARN)
+STATIC int
+xfs_rmapbt_keys_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_key	*k1,
+	union xfs_btree_key	*k2)
+{
+	return be32_to_cpu(k1->rmap.rm_startblock) <
+	       be32_to_cpu(k2->rmap.rm_startblock);
+}
+
+STATIC int
+xfs_rmapbt_recs_inorder(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*r1,
+	union xfs_btree_rec	*r2)
+{
+	return be32_to_cpu(r1->rmap.rm_startblock) +
+		be32_to_cpu(r1->rmap.rm_blockcount) <=
+		be32_to_cpu(r2->rmap.rm_startblock);
+}
+#endif	/* DEBUG */
+
+static const struct xfs_btree_ops xfs_rmapbt_ops = {
+	.rec_len		= sizeof(struct xfs_rmap_rec),
+	.key_len		= sizeof(struct xfs_rmap_key),
+
+	.dup_cursor		= xfs_rmapbt_dup_cursor,
+	.set_root		= xfs_rmapbt_set_root,
+	.alloc_block		= xfs_rmapbt_alloc_block,
+	.free_block		= xfs_rmapbt_free_block,
+	.get_minrecs		= xfs_rmapbt_get_minrecs,
+	.get_maxrecs		= xfs_rmapbt_get_maxrecs,
+	.init_key_from_rec	= xfs_rmapbt_init_key_from_rec,
+	.init_rec_from_key	= xfs_rmapbt_init_rec_from_key,
+	.init_rec_from_cur	= xfs_rmapbt_init_rec_from_cur,
+	.init_ptr_from_cur	= xfs_rmapbt_init_ptr_from_cur,
+	.key_diff		= xfs_rmapbt_key_diff,
+	.buf_ops		= &xfs_rmapbt_buf_ops,
+#if defined(DEBUG) || defined(XFS_WARN)
+	.keys_inorder		= xfs_rmapbt_keys_inorder,
+	.recs_inorder		= xfs_rmapbt_recs_inorder,
+#endif
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
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
new file mode 100644
index 0000000..9ad65e5
--- /dev/null
+++ b/libxfs/xfs_rmap_btree.h
@@ -0,0 +1,65 @@
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
+#ifndef __XFS_RMAP_BTREE_H__
+#define	__XFS_RMAP_BTREE_H__
+
+/*
+ * Freespace on-disk structures
+ */
+
+struct xfs_buf;
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
+
+int xfs_rmap_alloc(struct xfs_trans *tp, struct xfs_buf *agbp,
+		   xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		   uint64_t owner);
+int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
+		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
+		  uint64_t owner);
+
+#endif	/* __XFS_RMAP_BTREE_H__ */
diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index 78ad889..b23dfd1 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -33,6 +33,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_ialloc_btree.h"
+#include "xfs_rmap_btree.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -711,6 +712,11 @@ xfs_sb_mount_common(
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
diff --git a/libxfs/xfs_shared.h b/libxfs/xfs_shared.h
index 544d0e9..f756920 100644
--- a/libxfs/xfs_shared.h
+++ b/libxfs/xfs_shared.h
@@ -38,6 +38,7 @@ extern const struct xfs_buf_ops xfs_agi_buf_ops;
 extern const struct xfs_buf_ops xfs_agf_buf_ops;
 extern const struct xfs_buf_ops xfs_agfl_buf_ops;
 extern const struct xfs_buf_ops xfs_allocbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_leaf_buf_ops;
 extern const struct xfs_buf_ops xfs_attr3_rmt_buf_ops;
 extern const struct xfs_buf_ops xfs_bmbt_buf_ops;
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index f0d145a..da87796 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -111,8 +111,8 @@ typedef enum {
 } xfs_lookup_t;
 
 typedef enum {
-	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_BMAPi, XFS_BTNUM_INOi,
-	XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
