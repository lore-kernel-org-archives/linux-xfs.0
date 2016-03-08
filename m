Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 23B6229E05
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 22:17:09 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E9CF5304032
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 20:17:05 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	rSfd3j2IjXK0H56V for <xfs@oss.sgi.com>;
	Mon, 07 Mar 2016 20:17:03 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ad94S-0004A4-UH
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:32 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ad94G-0007u3-Ca
	for xfs@oss.sgi.com; Tue, 08 Mar 2016 15:16:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/16] xfs: introduce rmap btree definitions
Date: Tue,  8 Mar 2016 15:16:03 +1100
Message-Id: <1457410578-30233-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1457410578-30233-1-git-send-email-david@fromorbit.com>
References: <1457410578-30233-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

>From : Dave Chinner <dchinner@redhat.com>

Add new per-ag rmap btree definitions to the per-ag structures. The
rmap btree will sit inthe empty slots on disk after the free space
btrees, and hence form a part of the array of space management
btrees. This requires the definition of the btree to be contiguous
with the free space btrees.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_alloc.c  |  6 ++++++
 fs/xfs/libxfs/xfs_btree.c  |  4 ++--
 fs/xfs/libxfs/xfs_btree.h  |  3 +++
 fs/xfs/libxfs/xfs_format.h | 22 +++++++++++++++++-----
 fs/xfs/libxfs/xfs_types.h  |  4 ++--
 5 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index a708e38..d0b78b7 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2282,6 +2282,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) > XFS_BTREE_MAXLEVELS)
 		return false;
 
+	if (xfs_sb_version_hasrmapbt(&mp->m_sb) &&
+	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) > XFS_BTREE_MAXLEVELS)
+		return false;
+
 	/*
 	 * during growfs operations, the perag is not fully initialised,
 	 * so we can't use it for any useful checking. growfs ensures we can't
@@ -2413,6 +2417,8 @@ xfs_alloc_read_agf(
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
 		pag->pagf_levels[XFS_BTNUM_CNTi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
+		pag->pagf_levels[XFS_BTNUM_RMAPi] =
+			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1f88e1c..5953764 100644
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
index 2e874be..ac9c355 100644
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
index dc97eb21..4a48977 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -455,6 +455,7 @@ xfs_sb_has_compat_feature(
 }
 
 #define XFS_SB_FEAT_RO_COMPAT_FINOBT   (1 << 0)		/* free inode btree */
+#define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
 #define XFS_SB_FEAT_RO_COMPAT_ALL \
 		(XFS_SB_FEAT_RO_COMPAT_FINOBT)
 #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
@@ -538,6 +539,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
 		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
 }
 
+static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
+{
+	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
+		(sbp->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_RMAPBT);
+}
+
 /*
  * end of superblock version macros
  */
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
@@ -1308,6 +1313,13 @@ typedef __be32 xfs_inobt_ptr_t;
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
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
