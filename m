Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757158AbdLWBOF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 Dec 2017 20:14:05 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBN1C8pH079469
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:05 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2f1cvd81km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:14:04 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17Hg2010089
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:17 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id vBN17HHl005941
        for <linux-xfs@vger.kernel.org>; Sat, 23 Dec 2017 01:07:17 GMT
Subject: [PATCH 02/20] xfs: refactor long-format btree header verification
 routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 22 Dec 2017 17:07:16 -0800
Message-ID: <151399123598.23543.17447669553893249804.stgit@magnolia>
In-Reply-To: <151399122361.23543.15718507168231759645.stgit@magnolia>
References: <151399122361.23543.15718507168231759645.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create two helper functions to verify the headers of a long format
btree block.  We'll use this later for the realtime rmapbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap_btree.c |   22 ++------------------
 fs/xfs/libxfs/xfs_btree.c      |   45 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h      |    3 +++
 3 files changed, 50 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 00472e1..862be9c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -435,17 +435,11 @@ xfs_bmbt_verify(
 
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
@@ -464,20 +458,8 @@ xfs_bmbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	if (level > max(mp->m_bm_maxlevels[0], mp->m_bm_maxlevels[1]))
 		return false;
-	if (be16_to_cpu(block->bb_numrecs) > mp->m_bmap_dmxr[level != 0])
-		return false;
-
-	/* sibling pointer verification */
-	if (!block->bb_u.l.bb_leftsib ||
-	    (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib))))
-		return false;
-	if (!block->bb_u.l.bb_rightsib ||
-	    (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
-	     !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib))))
-		return false;
 
-	return true;
+	return xfs_btree_lblock_verify(bp, mp->m_bmap_dmxr[level != 0]);
 }
 
 static void
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 5a6146e..d84fdcb 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4529,6 +4529,51 @@ xfs_btree_change_owner(
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
+	if (block->bb_u.l.bb_leftsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_leftsib)))
+		return false;
+	if (block->bb_u.l.bb_rightsib != cpu_to_be64(NULLFSBLOCK) &&
+	    !xfs_verify_fsbno(mp, be64_to_cpu(block->bb_u.l.bb_rightsib)))
+		return false;
+
+	return true;
+}
+
 /**
  * xfs_btree_sblock_v5hdr_verify() -- verify the v5 fields of a short-format
  *				      btree block
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 8a263ea..6bf79ad 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -494,6 +494,9 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 
 bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+bool xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp, uint64_t owner);
+bool xfs_btree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
 xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,

