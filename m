Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AC7DE7D9B
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:43:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 707B4304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:44 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id eO6yMvLDzb87y72K (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:43:42 -0700 (PDT)
Subject: [PATCH 01/20] xfs: refactor long-format btree header verification
	routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:43:32 -0700
Message-ID: <147216861266.3688.15987417236994523745.stgit@birch.djwong.org>
In-Reply-To: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
References: <147216860614.3688.3200692982609112535.stgit@birch.djwong.org>
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
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Create two helper functions to verify the headers of a long format
btree block.  We'll use this later for the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   22 ++-----------------
 fs/xfs/libxfs/xfs_btree.c      |   47 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h      |    3 +++
 3 files changed, 52 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 1fc3eed..df691d2 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -677,17 +677,11 @@ xfs_bmbt_verify(
 
 	switch (block->bb_magic) {
 	case cpu_to_be32(XFS_BMAP_CRC_MAGIC):
-		if (!xfs_sb_version_hascrc(&mp->m_sb))
-			return false;
-		if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
-			return false;
-		if (be64_to_cpu(block->bb_u.l.bb_blkno) != bp->b_bn)
-			return false;
 		/*
 		 * XXX: need a better way of verifying the owner here. Right now
 		 * just make sure there has been one set.
 		 */
-		if (be64_to_cpu(block->bb_u.l.bb_owner) == 0)
+		if (!xfs_btree_lblock_v5hdr_verify(bp, XFS_RMAP_OWN_UNKNOWN))
 			return false;
 		/* fall through */
 	case cpu_to_be32(XFS_BMAP_MAGIC):
@@ -706,20 +700,8 @@ xfs_bmbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return false;
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.l.bb_leftsib ||
-	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
-		return false;
-	if (!block->bb_u.l.bb_rightsib ||
-	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
-		return false;
 
-	return true;
+	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a926c54..753e5ed 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4457,6 +4457,53 @@ xfs_btree_change_owner(
 			&bbcoi);
 }
 
+/* Verify the v5 fields of a long-format btree block. */
+bool
+xfs_btree_lblock_v5hdr_verify(
+	struct xfs_buf		*bp,
+	__uint64_t		owner)
+{
+	struct xfs_mount	*mp = bp->b_target->bt_mount;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
+
+	if (!xfs_sb_version_hascrc(&mp->m_sb))
+		return false;
+	if (!uuid_equal(&block->bb_u.l.bb_uuid, &mp->m_sb.sb_meta_uuid))
+		return false;
+	if (block->bb_u.l.bb_blkno != cpu_to_be64(bp->b_bn))
+		return false;
+	if (owner != XFS_RMAP_OWN_UNKNOWN &&
+	    be64_to_cpu(block->bb_u.l.bb_owner) != owner)
+		return false;
+	return true;
+}
+
+/* Verify a long-format btree block. */
+bool
+xfs_btree_lblock_verify(
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
+	if (!block->bb_u.l.bb_leftsib ||
+	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
+	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
+		return false;
+	if (!block->bb_u.l.bb_rightsib ||
+	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
+	     !XFS_FSB_SANITY_CHECK(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
+		return false;
+
+	return true;
+}
+
 /**
  * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
  *				      btree block
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f81b2a8..a7770dd 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -513,6 +513,9 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 
 bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+bool xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp, __uint64_t owner);
+bool xfs_btree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
 xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
