Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16485 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756502AbcI1CyB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Sep 2016 22:54:01 -0400
Subject: [PATCH 04/63] xfs: introduce refcount btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 27 Sep 2016 19:53:55 -0700
Message-ID: <147503123547.30303.16012510792256360982.stgit@birch.djwong.org>
In-Reply-To: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
References: <147503120985.30303.14151302091684456858.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>

Add new per-AG refcount btree definitions to the per-AG structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c      |    5 +++++
 fs/xfs/libxfs/xfs_btree.c      |    5 +++--
 fs/xfs/libxfs/xfs_btree.h      |    4 ++++
 fs/xfs/libxfs/xfs_format.h     |   31 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_rmap_btree.c |   22 ++++++++++++++++++++--
 fs/xfs/libxfs/xfs_types.h      |    2 +-
 fs/xfs/xfs_inode.h             |    5 +++++
 fs/xfs/xfs_mount.h             |    3 +++
 fs/xfs/xfs_pnfs.c              |    7 +++++++
 fs/xfs/xfs_stats.c             |    1 +
 fs/xfs/xfs_stats.h             |   18 +++++++++++++++++-
 11 files changed, 93 insertions(+), 10 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index ca75dc9..275d345 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2458,6 +2458,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2578,6 +2582,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index aa1752f..f8bab9b 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -45,9 +45,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3f8556a..e7ef1d9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -72,6 +72,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
 /*
  * For logging record fields.
@@ -105,6 +106,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
+	case XFS_BTNUM_REFC: __XFS_BTREE_STATS_INC(__mp, refcbt, stat); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -127,6 +129,8 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP:	\
 		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
+	case XFS_BTNUM_REFC:	\
+		__XFS_BTREE_STATS_ADD(__mp, refcbt, stat, val); break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 270fb5c..57c52a6 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -456,6 +456,7 @@ xfs_sb_has_compat_feature(
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
+#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
@@ -546,6 +547,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
+{
+	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 /*
  * end of superblock version macros
  */
@@ -641,14 +648,17 @@ typedef struct xfs_agf {
 	uuid_t		agf_uuid;	/* uuid of filesystem */
 
 	__be32		agf_rmap_blocks;	/* rmapbt blocks used */
-	__be32		agf_padding;		/* padding */
+	__be32		agf_refcount_blocks;	/* refcountbt blocks used */
+
+	__be32		agf_refcount_root;	/* refcount tree root block */
+	__be32		agf_refcount_level;	/* refcount btree levels */
 
 	/*
 	 * reserve some contiguous space for future logged fields before we add
 	 * the unlogged fields. This makes the range logging via flags and
 	 * structure offsets much simpler.
 	 */
-	__be64		agf_spare64[15];
+	__be64		agf_spare64[14];
 
 	/* unlogged fields, written during buffer writeback. */
 	__be64		agf_lsn;	/* last write sequence */
@@ -1041,9 +1051,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
  * 16 bits of the XFS_XFLAG_s range.
  */
 #define XFS_DIFLAG2_DAX_BIT	0	/* use DAX for this inode */
+#define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
+#define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
 #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
+#define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
+#define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
 
-#define XFS_DIFLAG2_ANY		(XFS_DIFLAG2_DAX)
+#define XFS_DIFLAG2_ANY \
+	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE)
 
 /*
  * Inode number format:
@@ -1353,7 +1368,8 @@ struct xfs_owner_info {
 #define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
-#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+#define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
+#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
@@ -1434,6 +1450,13 @@ typedef __be32 xfs_rmap_ptr_t;
 	 XFS_IBT_BLOCK(mp) + 1)
 
 /*
+ * Reference Count Btree format definitions
+ *
+ */
+#define	XFS_REFC_CRC_MAGIC	0x52334643	/* 'R3FC' */
+
+
+/*
  * BMAP Btree format definitions
  *
  * This includes both the root block definition that sits inside an inode fork
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 17b8eeb..9c0585e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -512,6 +512,24 @@ void
 xfs_rmapbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
-	mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
-			mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+	/*
+	 * On a non-reflink filesystem, the maximum number of rmap
+	 * records is the number of blocks in the AG, hence the max
+	 * rmapbt height is log_$maxrecs($agblocks).  However, with
+	 * reflink each AG block can have up to 2^32 (per the refcount
+	 * record format) owners, which means that theoretically we
+	 * could face up to 2^64 rmap records.
+	 *
+	 * That effectively means that the max rmapbt height must be
+	 * XFS_BTREE_MAXLEVELS.  "Fortunately" we'll run out of AG
+	 * blocks to feed the rmapbt long before the rmapbt reaches
+	 * maximum height.  The reflink code uses ag_resv_critical to
+	 * disallow reflinking when less than 10% of the per-AG metadata
+	 * block reservation since the fallback is a regular file copy.
+	 */
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
+	else
+		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
+				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 3d50364..be7b6de 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -109,7 +109,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 8f30d25..a8658e6 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -202,6 +202,11 @@ xfs_get_initial_prid(struct xfs_inode *dp)
 	return XFS_PROJID_DEFAULT;
 }
 
+static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
+{
+	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+}
+
 /*
  * In-core inode flags.
  */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 041d949..8fab496 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -399,6 +399,9 @@ typedef struct xfs_perag {
 	struct xfs_ag_resv	pag_meta_resv;
 	/* Blocks reserved for just AGFL-based metadata. */
 	struct xfs_ag_resv	pag_agfl_resv;
+
+	/* reference count */
+	__uint8_t		pagf_refcount_level;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 0f14b2e..93a7aaf 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -114,6 +114,13 @@ xfs_fs_map_blocks(
 		return -ENXIO;
 
 	/*
+	 * The pNFS block layout spec actually supports reflink like
+	 * functionality, but the Linux pNFS server doesn't implement it yet.
+	 */
+	if (xfs_is_reflink_inode(ip))
+		return -ENXIO;
+
+	/*
 	 * Lock out any other I/O before we flush and invalidate the pagecache,
 	 * and then hand out a layout to the remote system.  This is very
 	 * similar to direct I/O, except that the synchronization is much more
diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
index 6e812fe0..12d48cd 100644
--- a/fs/xfs/xfs_stats.c
+++ b/fs/xfs/xfs_stats.c
@@ -62,6 +62,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
 		{ "ibt2",		XFSSTAT_END_IBT_V2		},
 		{ "fibt2",		XFSSTAT_END_FIBT_V2		},
 		{ "rmapbt",		XFSSTAT_END_RMAP_V2		},
+		{ "refcntbt",		XFSSTAT_END_REFCOUNT		},
 		/* we print both series of quota information together */
 		{ "qm",			XFSSTAT_END_QM			},
 	};
diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
index 657865f..79ad2e6 100644
--- a/fs/xfs/xfs_stats.h
+++ b/fs/xfs/xfs_stats.h
@@ -213,7 +213,23 @@ struct xfsstats {
 	__uint32_t		xs_rmap_2_alloc;
 	__uint32_t		xs_rmap_2_free;
 	__uint32_t		xs_rmap_2_moves;
-#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_RMAP_V2+6)
+#define XFSSTAT_END_REFCOUNT		(XFSSTAT_END_RMAP_V2 + 15)
+	__uint32_t		xs_refcbt_2_lookup;
+	__uint32_t		xs_refcbt_2_compare;
+	__uint32_t		xs_refcbt_2_insrec;
+	__uint32_t		xs_refcbt_2_delrec;
+	__uint32_t		xs_refcbt_2_newroot;
+	__uint32_t		xs_refcbt_2_killroot;
+	__uint32_t		xs_refcbt_2_increment;
+	__uint32_t		xs_refcbt_2_decrement;
+	__uint32_t		xs_refcbt_2_lshift;
+	__uint32_t		xs_refcbt_2_rshift;
+	__uint32_t		xs_refcbt_2_split;
+	__uint32_t		xs_refcbt_2_join;
+	__uint32_t		xs_refcbt_2_alloc;
+	__uint32_t		xs_refcbt_2_free;
+	__uint32_t		xs_refcbt_2_moves;
+#define XFSSTAT_END_XQMSTAT		(XFSSTAT_END_REFCOUNT + 6)
 	__uint32_t		xs_qm_dqreclaims;
 	__uint32_t		xs_qm_dqreclaim_misses;
 	__uint32_t		xs_qm_dquot_dups;

