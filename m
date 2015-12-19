Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A77AC7F6C
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:57:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 26783AC004
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:12 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id GB6wf3O9gqy76tic (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:57:08 -0800 (PST)
Subject: [PATCH 06/76] xfs: introduce rmap btree definitions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:57:01 -0800
Message-ID: <20151219085701.12713.836.stgit@birch.djwong.org>
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
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

Add new per-ag rmap btree definitions to the per-ag structures. The
rmap btree will sit inthe empty slots on disk after the free space
btrees, and hence form a part of the array of space management
btrees. This requires the definition of the btree to be contiguous
with the free space btrees.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |    6 ++++++
 fs/xfs/libxfs/xfs_btree.c  |    4 ++--
 fs/xfs/libxfs/xfs_btree.h  |    3 +++
 fs/xfs/libxfs/xfs_format.h |   22 +++++++++++++++++-----
 fs/xfs/libxfs/xfs_types.h  |    4 ++--
 5 files changed, 30 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 89c4775..05c87a2 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2281,6 +2281,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return false;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2411,6 +2415,8 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+		pag->pagf_levels[XFS_BTNUM_RMAPi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index af1bbee..4ff6b80 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -43,9 +43,9 @@ kmem_zone_t	*xfs_btree_cur_zone;
  * Btree magic numbers.
  */
 static const __uint32_t xfs_magics[2][XFS_BTNUM_MAX] = {
-	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
+	{ XFS_ABTB_MAGIC, XFS_ABTC_MAGIC, 0, XFS_BMAP_MAGIC, XFS_IBT_MAGIC,
 	  XFS_FIBT_MAGIC },
-	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC,
+	{ XFS_ABTB_CRC_MAGIC, XFS_ABTC_CRC_MAGIC, XFS_RMAP_CRC_MAGIC,
 	  XFS_BMAP_CRC_MAGIC, XFS_IBT_CRC_MAGIC, XFS_FIBT_CRC_MAGIC }
 };
 #define xfs_btree_magic(cur) \
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 992dec0..4942c4a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -63,6 +63,7 @@ union xfs_btree_rec {
 #define	XFS_BTNUM_BMAP	((xfs_btnum_t)XFS_BTNUM_BMAPi)
 #define	XFS_BTNUM_INO	((xfs_btnum_t)XFS_BTNUM_INOi)
 #define	XFS_BTNUM_FINO	((xfs_btnum_t)XFS_BTNUM_FINOi)
+#define	XFS_BTNUM_RMAP	((xfs_btnum_t)XFS_BTNUM_RMAPi)
 
 /*
  * For logging record fields.
@@ -95,6 +96,7 @@ do {    \
 	case XFS_BTNUM_BMAP: __XFS_BTREE_STATS_INC(__mp, bmbt, stat); break; \
 	case XFS_BTNUM_INO: __XFS_BTREE_STATS_INC(__mp, ibt, stat); break; \
 	case XFS_BTNUM_FINO: __XFS_BTREE_STATS_INC(__mp, fibt, stat); break; \
+	case XFS_BTNUM_RMAP: break;	\
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break;	\
 	}       \
 } while (0)
@@ -115,6 +117,7 @@ do {    \
 		__XFS_BTREE_STATS_ADD(__mp, ibt, stat, val); break; \
 	case XFS_BTNUM_FINO:	\
 		__XFS_BTREE_STATS_ADD(__mp, fibt, stat, val); break; \
+	case XFS_BTNUM_RMAP: break; \
 	case XFS_BTNUM_MAX: ASSERT(0); /* fucking gcc */ ; break; \
 	}       \
 } while (0)
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index e2536bb..5c2703d 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -455,6 +455,7 @@ xfs_sb_has_compat_feature(
 }
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
+#define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
@@ -526,6 +527,12 @@ static inline bool xfs_sb_version_hassparseinodes(struct xfs_sb *sbp)
 		xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_SPINODES);
 }
 
+static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
+}
+
 /*
  * XFS_SB_FEAT_INCOMPAT_META_UUID indicates that the metadata UUID
  * is stored separately from the user-visible UUID; this allows the
@@ -598,10 +605,10 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
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
@@ -618,12 +625,10 @@ typedef struct xfs_agf {
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
@@ -1301,6 +1306,13 @@ typedef __be32 xfs_inobt_ptr_t;
 #define	XFS_FIBT_BLOCK(mp)		((xfs_agblock_t)(XFS_IBT_BLOCK(mp) + 1))
 
 /*
+ * Reverse mapping btree format definitions
+ *
+ * There is a btree for the reverse map per allocation group
+ */
+#define	XFS_RMAP_CRC_MAGIC	0x524d4233	/* 'RMB3' */
+
+/*
  * The first data block of an AG depends on whether the filesystem was formatted
  * with the finobt feature. If so, account for the finobt reserved root btree
  * block.
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index b79dc66..3d50364 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -108,8 +108,8 @@ typedef enum {
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
