Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23536 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH1SQj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Aug 2017 14:16:39 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7SIGcen018652
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:16:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7SIGcp0027124
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:16:38 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7SIGbch018780
        for <linux-xfs@vger.kernel.org>; Mon, 28 Aug 2017 18:16:38 GMT
Subject: [PATCH 01/12] xfs: refactor long-format btree header verification
 routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 28 Aug 2017 11:16:36 -0700
Message-ID: <150394419606.24826.3469181916211366453.stgit@magnolia>
In-Reply-To: <150394418979.24826.12970283067445908653.stgit@magnolia>
References: <150394418979.24826.12970283067445908653.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, darrick.wong@oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Create two helper functions to verify the headers of a long format
btree block.  We'll use this later for the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   22 ++-----------------
 fs/xfs/libxfs/xfs_btree.c      |   47 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h      |    3 +++
 3 files changed, 52 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index eddc1df..99bdf08 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -627,17 +627,11 @@ xfs_bmbt_verify(
 
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
@@ -656,20 +650,8 @@ xfs_bmbt_verify(
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
index 9ba49dd..0ba9edb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4493,6 +4493,53 @@ xfs_btree_change_owner(
 			&bbcoi);
 }
 
+/* Verify the v5 fields of a long-format btree block. */
+bool
+xfs_btree_lblock_v5hdr_verify(
+	struct xfs_buf		*bp,
+	uint64_t		owner)
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
index 8666cc6..13fb833 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -480,6 +480,9 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 
 bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+bool xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp, uint64_t owner);
+bool xfs_btree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
 unsigned long long xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,

