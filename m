Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45879 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751305AbdLMX7w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:59:52 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.21/8.16.0.21) with SMTP id vBDNlIis099987
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:51 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2eue5b0285-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:59:47 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id vBDNwLDp004174
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:22 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id vBDNwLep008801
        for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2017 23:58:21 GMT
Subject: [PATCH 01/13] xfs: refactor long-format btree header verification
 routines
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 13 Dec 2017 15:58:19 -0800
Message-ID: <151320949899.30654.10787297507975715065.stgit@magnolia>
In-Reply-To: <151320949282.30654.14805160700975182459.stgit@magnolia>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_bmap_btree.c |   22 ++-----------------
 fs/xfs/libxfs/xfs_btree.c      |   47 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h      |    3 +++
 3 files changed, 52 insertions(+), 20 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index c10aeca..862be9c 100644
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
index e0bdff3..72d05b1 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4529,6 +4529,53 @@ xfs_btree_change_owner(
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
index 551a2a0..a046d0f 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -498,6 +498,9 @@ static inline int xfs_btree_get_level(struct xfs_btree_block *block)
 
 bool xfs_btree_sblock_v5hdr_verify(struct xfs_buf *bp);
 bool xfs_btree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+bool xfs_btree_lblock_v5hdr_verify(struct xfs_buf *bp, uint64_t owner);
+bool xfs_btree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
+
 uint xfs_btree_compute_maxlevels(struct xfs_mount *mp, uint *limits,
 				 unsigned long len);
 xfs_extlen_t xfs_btree_calc_size(struct xfs_mount *mp, uint *limits,

