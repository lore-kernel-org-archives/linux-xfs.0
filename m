Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729541AbfBDOwf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 09:52:35 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3087E80F88
        for <linux-xfs@vger.kernel.org>; Mon,  4 Feb 2019 14:52:35 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-66.bos.redhat.com [10.18.41.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CA4FC100191D
        for <linux-xfs@vger.kernel.org>; Mon,  4 Feb 2019 14:52:34 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 6/9] xfs: distinguish between bnobt and cntbt magic values
Date: Mon,  4 Feb 2019 09:52:28 -0500
Message-Id: <20190204145231.47034-7-bfoster@redhat.com>
In-Reply-To: <20190204145231.47034-1-bfoster@redhat.com>
References: <20190204145231.47034-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The allocation btree verifiers share code that is unable to detect
cross-tree magic value corruptions such as a bnobt block with a
cntbt magic value. Populate the b_ops->magic field of the associated
verifier structures such that the structure verifier can check the
magic value against the expected value based on tree type.

The btree level check requires knowledge of the tree type to
determine the appropriate maximum value. This was previously part of
the hardcoded magic value checks. With that code removed, peek at
the first magic value in the verifier to determine the expected tree
type of the current block.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c | 60 ++++++++++++++-------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 480d0f52da64..9fe949f6055e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -297,48 +297,34 @@ xfs_allocbt_verify(
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
 	unsigned int		level;
+	xfs_btnum_t		btnum = XFS_BTNUM_BNOi;
+
+	if (!xfs_verify_magic(bp, block->bb_magic))
+		return __this_address;
+
+	if (xfs_sb_version_hascrc(&mp->m_sb)) {
+		fa = xfs_btree_sblock_v5hdr_verify(bp);
+		if (fa)
+			return fa;
+	}
 
 	/*
-	 * magic number and level verification
-	 *
-	 * During growfs operations, we can't verify the exact level or owner as
-	 * the perag is not fully initialised and hence not attached to the
-	 * buffer.  In this case, check against the maximum tree depth.
+	 * The perag may not be attached during grow operations or fully
+	 * initialized from the AGF during log recovery. Therefore we can only
+	 * check against maximum tree depth from those contexts.
 	 *
-	 * Similarly, during log recovery we will have a perag structure
-	 * attached, but the agf information will not yet have been initialised
-	 * from the on disk AGF. Again, we can only check against maximum limits
-	 * in this case.
+	 * Otherwise check against the per-tree limit. Peek at one of the
+	 * verifier magic values to determine the type of tree we're verifying
+	 * against.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	switch (block->bb_magic) {
-	case cpu_to_be32(XFS_ABTB_CRC_MAGIC):
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
-		if (fa)
-			return fa;
-		/* fall through */
-	case cpu_to_be32(XFS_ABTB_MAGIC):
-		if (pag && pag->pagf_init) {
-			if (level >= pag->pagf_levels[XFS_BTNUM_BNOi])
-				return __this_address;
-		} else if (level >= mp->m_ag_maxlevels)
+	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
+		btnum = XFS_BTNUM_CNTi;
+	if (pag && pag->pagf_init) {
+		if (level >= pag->pagf_levels[btnum])
 			return __this_address;
-		break;
-	case cpu_to_be32(XFS_ABTC_CRC_MAGIC):
-		fa = xfs_btree_sblock_v5hdr_verify(bp);
-		if (fa)
-			return fa;
-		/* fall through */
-	case cpu_to_be32(XFS_ABTC_MAGIC):
-		if (pag && pag->pagf_init) {
-			if (level >= pag->pagf_levels[XFS_BTNUM_CNTi])
-				return __this_address;
-		} else if (level >= mp->m_ag_maxlevels)
-			return __this_address;
-		break;
-	default:
+	} else if (level >= mp->m_ag_maxlevels)
 		return __this_address;
-	}
 
 	return xfs_btree_sblock_verify(bp, mp->m_alloc_mxr[level != 0]);
 }
@@ -379,6 +365,8 @@ xfs_allocbt_write_verify(
 
 const struct xfs_buf_ops xfs_bnobt_buf_ops = {
 	.name = "xfs_bnobt",
+	.magic = { cpu_to_be32(XFS_ABTB_MAGIC),
+		   cpu_to_be32(XFS_ABTB_CRC_MAGIC) },
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
 	.verify_struct = xfs_allocbt_verify,
@@ -386,6 +374,8 @@ const struct xfs_buf_ops xfs_bnobt_buf_ops = {
 
 const struct xfs_buf_ops xfs_cntbt_buf_ops = {
 	.name = "xfs_cntbt",
+	.magic = { cpu_to_be32(XFS_ABTC_MAGIC),
+		   cpu_to_be32(XFS_ABTC_CRC_MAGIC) },
 	.verify_read = xfs_allocbt_read_verify,
 	.verify_write = xfs_allocbt_write_verify,
 	.verify_struct = xfs_allocbt_verify,
-- 
2.17.2
