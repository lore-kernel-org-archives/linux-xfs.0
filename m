Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EAC5529E14
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 23:58:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CAFB18F8035
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 21:58:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id F4NCMMdfVbyioVeC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 21:58:49 -0700 (PDT)
Subject: [PATCH 33/58] xfs: introduce refcount btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 21:58:45 -0700
Message-ID: <20151007045845.30457.75886.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Add new per-AG refcount btree definitions to the per-AG structures.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    5 +++++
 fs/xfs/libxfs/xfs_btree.c  |    5 +++--
 fs/xfs/libxfs/xfs_btree.h  |    4 ++++
 fs/xfs/libxfs/xfs_format.h |   34 ++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_types.h  |    2 +-
 fs/xfs/xfs_inode.h         |    5 +++++
 fs/xfs/xfs_mount.h         |    3 +++
 7 files changed, 53 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index be44873..6e7f0a6 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2406,6 +2406,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_btreeblks) > be32_to_cpu(agf->agf_length))
 		return false;
 
+	if (xfs_sb_version_hasreflink(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_refcount_level) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	return true;;
 
 }
@@ -2525,6 +2529,7 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a24c092..b6ebfc6 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -44,9 +44,10 @@ kmem_zone_t	*xfs_btree_cur_zone;
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
index dd29d15..4b49e35 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -66,6 +66,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
 #define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
+#define	XFS_BTNUM_REFC	((xfs_btnum_t)XFS_BTNUM_REFCi)
 
 /*
  * For logging record fields.
@@ -98,6 +99,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(ibt, stat); break;	\
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(fibt, stat); break;	\
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_INC(rmap, stat); break;	\
+	case XFS_BTNUM_REFC: break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -113,6 +115,7 @@ do {    \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_ADD(ibt, stat, val); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_ADD(fibt, stat, val); break; \
 	case XFS_BTNUM_RMAP: __XFS_BTREE_STATS_ADD(rmap, stat, val); break; \
+	case XFS_BTNUM_REFC: break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -217,6 +220,7 @@ typedef struct xfs_btree_cur
 	union {
 		struct {			/* needed for BNO, CNT, INO */
 			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
+			struct xfs_bmap_free *flist;	/* list to free after */
 			xfs_agnumber_t	agno;	/* ag number */
 		} a;
 		struct {			/* needed for BMAP */
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c4a73e9..600b327 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -448,6 +448,7 @@ xfs_sb_has_compat_feature(
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
 #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
+#define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
 		 XFS_SB_FEAT_RO_COMPAT_RMAPBT)
@@ -526,6 +527,12 @@ static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
 		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
 }
 
+static inline bool xfs_sb_version_hasreflink(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_REFLINK);
+}
+
 /*
  * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
  * is stored separately from the user-visible UUID; this allows the
@@ -632,12 +639,15 @@ typedef struct xfs_agf {
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
@@ -1024,6 +1034,18 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
@@ -1368,7 +1390,8 @@ XFS_RMAP_INO_OWNER(
 #define XFS_RMAP_OWN_AG		(-5ULL)	/* AG freespace btree blocks */
 #define XFS_RMAP_OWN_INOBT	(-6ULL)	/* Inode btree blocks */
 #define XFS_RMAP_OWN_INODES	(-7ULL)	/* Inode chunk */
-#define XFS_RMAP_OWN_MIN	(-8ULL) /* guard */
+#define XFS_RMAP_OWN_REFC	(-8ULL) /* refcount tree */
+#define XFS_RMAP_OWN_MIN	(-9ULL) /* guard */
 
 #define XFS_RMAP_NON_INODE_OWNER(owner)	(!!((owner) & (1ULL << 63)))
 
@@ -1471,6 +1494,13 @@ xfs_owner_info_pack(
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
index ca9e119..6436a96 100644
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
index cdced0b..4b286cc 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -315,6 +315,9 @@ typedef struct xfs_perag {
 	/* for rcu-safe freeing */
 	struct rcu_head	rcu_head;
 	int		pagb_count;	/* pagb slots in use */
+
+	/* reference count */
+	__uint8_t	pagf_refcount_level;
 } xfs_perag_t;
 
 extern int	xfs_log_sbcount(xfs_mount_t *);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
