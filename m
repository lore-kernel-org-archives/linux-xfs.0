Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 110867DD4
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:23:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D47AB8F804B
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:48 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2XfKrGDVI5GAKErS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:46 -0700 (PDT)
Subject: [PATCH 054/119] xfs: introduce refcount btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:23:37 -0700
Message-ID: <146612661755.12839.13699464885618790847.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

Add new per-AG refcount btree definitions to the per-AG structures.

v2: Move the reflink inode flag out of the way of the DAX flag, and
add the new cowextsize flag.

v3: Don't allow pNFS to export reflinked files; this will be removed
some day when the Linux pNFS server supports it.

[hch: don't allow pNFS export of reflinked files]
[darrick: fix the feature test in hch's patch]

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_alloc.c      |    5 +++++
 fs/xfs/libxfs/xfs_btree.c      |    5 +++--
 fs/xfs/libxfs/xfs_btree.h      |    3 +++
 fs/xfs/libxfs/xfs_format.h     |   29 ++++++++++++++++++++++++++---
 fs/xfs/libxfs/xfs_rmap_btree.c |    7 +++++--
 fs/xfs/libxfs/xfs_types.h      |    2 +-
 fs/xfs/xfs_inode.h             |    5 +++++
 fs/xfs/xfs_mount.h             |    3 +++
 fs/xfs/xfs_pnfs.c              |    7 +++++++
 9 files changed, 58 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5f05c4e..9009b1f 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2448,6 +2448,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2568,6 +2572,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 #ifdef __KERNEL__
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 50b2c32..1593239 100644
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
index 6fa13a9..9b5a921 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -66,6 +66,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
 /*
  * For logging record fields.
@@ -99,6 +100,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(__mp, rmap, stat); break; \
+	case XFS_BTNUM_REFC: break; \
 	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
@@ -121,6 +123,7 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP:	\
 		__XFS_BTREE_STATS_ADD(__mp, rmap, stat, val); break; \
+	case XFS_BTNUM_REFC: break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); __mp = __mp /* fucking gcc */ ; break; \
 	}       \
 } while (0)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 1b08237..63a97a9 100644
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
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 /*
  * end of superblock version macros
  */
@@ -640,12 +647,15 @@ typedef struct xfs_agf {
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
@@ -1033,9 +1043,14 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
@@ -1382,7 +1397,8 @@ xfs_rmap_ino_owner(
 #define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
-#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+#define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
+#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
@@ -1530,6 +1546,13 @@ xfs_owner_info_pack(
 }
 
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
index 9adb930..090dbbe 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -475,6 +475,9 @@ void
 xfs_rmapbt_compute_maxlevels(
 	struct xfs_mount		*mp)
 {
-	mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
-			mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
+	if (xfs_sb_version_hasreflink(&mp->m_sb))
+		mp->m_rmap_maxlevels = XFS_BTREE_MAXLEVELS;
+	else
+		mp->m_rmap_maxlevels = xfs_btree_compute_maxlevels(mp,
+				mp->m_rmap_mnr, mp->m_sb.sb_agblocks);
 }
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index da87796..690d616 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -112,7 +112,7 @@ typedef enum {
 
 typedef enum {
 	XFS_BTNUM_BNOi, XFS_BTNUM_CNTi, XFS_BTNUM_RMAPi, XFS_BTNUM_BMAPi,
-	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_MAX
+	XFS_BTNUM_INOi, XFS_BTNUM_FINOi, XFS_BTNUM_REFCi, XFS_BTNUM_MAX
 } xfs_btnum_t;
 
 struct xfs_name {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 633f2af..d0ea6ff 100644
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
index e18d74e..823ee63 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -391,6 +391,9 @@ typedef struct xfs_perag {
 	struct xfs_ag_resv	pag_meta_resv;
 	/* Blocks reserved for just AGFL-based metadata. */
 	struct xfs_ag_resv	pag_agfl_resv;
+
+	/* reference count */
+	__uint8_t	pagf_refcount_level;
 } xfs_perag_t;
 
 static inline struct xfs_ag_resv *
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index d5b7566..b21f532 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -139,6 +139,13 @@ xfs_fs_map_blocks(
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
