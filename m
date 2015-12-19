Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C303129E08
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:06:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 884578F8052
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id OiwyYHrRnCz5yWFl (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:06:49 -0800 (PST)
Subject: [PATCH 17/53] libxfs: refactor short btree block verification
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:06:39 -0800
Message-ID: <20151219090639.14255.68453.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Create xfs_btree_sblock_verify() to verify short-format btree blocks
(i.e. the per-AG btrees with 32-bit block pointers) instead of
open-coding them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc_btree.c  |   30 ++---------------------
 libxfs/xfs_btree.c        |   58 +++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree.h        |    3 ++
 libxfs/xfs_ialloc_btree.c |   24 ++-----------------
 libxfs/xfs_rmap_btree.c   |   23 ++----------------
 5 files changed, 70 insertions(+), 68 deletions(-)


diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index f583bd1..6f13572 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -293,12 +293,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTB_MAGIC):
@@ -311,12 +306,7 @@ xfs_allocbt_verify(
 	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_ABTC_MAGIC):
@@ -330,21 +320,7 @@ xfs_allocbt_verify(
 		return false;
 	}
 
-	/* numrecs verification */
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_alloc_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-
-	return true;
+	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
 }
 
 static void
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 5cf8ee5..9b918d2 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4083,3 +4083,61 @@ xfs_btree_change_owner(
 
 	return 0;
 }
+
+/**
+ * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
+ *				      btree block
+ *
+ * @bp: buffer containing the btree block
+ * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
+ * @pag_max_level: pointer to the per-ag max level field
+ */
+bool
+xfs_btree_sblock_v5hdr_verify(
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+	struct xfs_perag	*pag = bp->b_pag;
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
+		return false;
+	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
+		return false;
+	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		return false;
+	return true;
+}
+
+/**
+ * xfs_btree_sblock_verify() -- verify a short-format btree block
+ *
+ * @bp: buffer containing the btree block
+ * @max_recs: maximum records allowed in this btree node
+ */
+bool
+xfs_btree_sblock_verify(
+	struct xfs_buf		*bp,
+	unsigned int		max_recs)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+
+	/* numrecs verification */
+	if (be16_to_cpu(block->bb_numrecs) > max_recs)
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
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 48ab2b1..dd29d15 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -471,4 +471,7 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 #define XFS_BTREE_TRACE_ARGR(c, r)
 #define	XFS_BTREE_TRACE_CURSOR(c, t)
 
+bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
+bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 88a3e87..ceeb7cb 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -223,7 +223,6 @@ xfs_inobt_verify(
 {
 	struct xfs_mount	*mp = bp->b_target->bt_mount;
 	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
-	struct xfs_perag	*pag = bp->b_pag;
 	unsigned int		level;
 
 	/*
@@ -241,12 +240,7 @@ xfs_inobt_verify(
 	case cpu_to_be32(XFS_FIBT_CRC_MAGIC):
 		if (!xfs_sb_version_hascrc(&mp->m_sb))
 			return false;
-		if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
-		if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-			return false;
-		if (pag &&
-		    be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+		if (!xfs_btree_sblock_v5hdr_verify(bp))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_IBT_MAGIC):
@@ -256,24 +250,12 @@ xfs_inobt_verify(
 		return 0;
 	}
 
-	/* numrecs and level verification */
+	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (level >= mp->m_in_maxlevels)
 		return false;
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_inobt_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
 
-	return true;
+	return xfs_btree_sblock_verify(bp, mp->m_inobt_mxr[level != 0]);
 }
 
 static void
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index ad6a928..b7024cc 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -252,13 +252,10 @@ xfs_rmapbt_verify(
 
 	if (!xfs_sb_version_hasrmapbt(&mp->m_sb))
 		return false;
-	if (!uuid_equal(&block->bb_u.s.bb_uuid, &mp->m_sb.sb_uuid))
-		return false;
-	if (block->bb_u.s.bb_blkno != cpu_to_be64(bp->b_bn))
-		return false;
-	if (pag && be32_to_cpu(block->bb_u.s.bb_owner) != pag->pag_agno)
+	if (!xfs_btree_sblock_v5hdr_verify(bp))
 		return false;
 
+	/* level verification */
 	level = be16_to_cpu(block->bb_level);
 	if (pag && pag->pagf_init) {
 		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
@@ -266,21 +263,7 @@ xfs_rmapbt_verify(
 	} else if (level >= mp->m_ag_maxlevels)
 		return false;
 
-	/* numrecs verification */
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_rmap_mxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.s.bb_leftsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_leftsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_leftsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-	if (!block->bb_u.s.bb_rightsib ||
-	    (be32_to_cpu(block->bb_u.s.bb_rightsib) >= mp->m_sb.sb_agblocks &&
-	     block->bb_u.s.bb_rightsib != cpu_to_be32(NULLAGBLOCK)))
-		return false;
-
-	return true;
+	return xfs_btree_sblock_verify(bp, mp->m_rmap_mxr[level != 0]);
 }
 
 static void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
