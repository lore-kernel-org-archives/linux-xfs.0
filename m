Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:57492 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfFUT5M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 15:57:12 -0400
Subject: [PATCH 2/6] xfs: account for log space when formatting new AGs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 21 Jun 2019 12:57:06 -0700
Message-ID: <156114702648.1643538.14530619220062934565.stgit@magnolia>
In-Reply-To: <156114701371.1643538.316410894576032261.stgit@magnolia>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, Allison Collins <allison.henderson@oracle.com>

From: Darrick J. Wong <darrick.wong@oracle.com>

When we're writing out a fresh new AG, make sure that we don't list an
internal log as free and that we create the rmap for the region.  growfs
never does this, but we will need it when we hook up mkfs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_ag.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)


diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index fe79693e..237d6c53 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -11,6 +11,7 @@
 #include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_sb.h"
 #include "xfs_mount.h"
 #include "xfs_btree.h"
@@ -45,6 +46,12 @@ xfs_get_aghdr_buf(
 	return bp;
 }
 
+static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
+{
+	return mp->m_sb.sb_logstart > 0 &&
+	       id->agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
+}
+
 /*
  * Generic btree root block init function
  */
@@ -65,11 +72,50 @@ xfs_freesp_init_recs(
 	struct aghdr_init_data	*id)
 {
 	struct xfs_alloc_rec	*arec;
+	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
 
 	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
 	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
+
+	if (is_log_ag(mp, id)) {
+		struct xfs_alloc_rec	*nrec;
+		xfs_agblock_t		start = XFS_FSB_TO_AGBNO(mp,
+							mp->m_sb.sb_logstart);
+
+		ASSERT(start >= mp->m_ag_prealloc_blocks);
+		if (start != mp->m_ag_prealloc_blocks) {
+			/*
+			 * Modify first record to pad stripe align of log
+			 */
+			arec->ar_blockcount = cpu_to_be32(start -
+						mp->m_ag_prealloc_blocks);
+			nrec = arec + 1;
+			/*
+			 * Insert second record at start of internal log
+			 * which then gets trimmed.
+			 */
+			nrec->ar_startblock = cpu_to_be32(
+					be32_to_cpu(arec->ar_startblock) +
+					be32_to_cpu(arec->ar_blockcount));
+			arec = nrec;
+			be16_add_cpu(&block->bb_numrecs, 1);
+		}
+		/*
+		 * Change record start to after the internal log
+		 */
+		be32_add_cpu(&arec->ar_startblock, mp->m_sb.sb_logblocks);
+	}
+
+	/*
+	 * Calculate the record block count and check for the case where
+	 * the log might have consumed all available space in the AG. If
+	 * so, reset the record count to 0 to avoid exposure of an invalid
+	 * record start block.
+	 */
 	arec->ar_blockcount = cpu_to_be32(id->agsize -
 					  be32_to_cpu(arec->ar_startblock));
+	if (!arec->ar_blockcount)
+		block->bb_numrecs = 0;
 }
 
 /*
@@ -155,6 +201,18 @@ xfs_rmaproot_init(
 		rrec->rm_offset = 0;
 		be16_add_cpu(&block->bb_numrecs, 1);
 	}
+
+	/* account for the log space */
+	if (is_log_ag(mp, id)) {
+		rrec = XFS_RMAP_REC_ADDR(block,
+				be16_to_cpu(block->bb_numrecs) + 1);
+		rrec->rm_startblock = cpu_to_be32(
+				XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart));
+		rrec->rm_blockcount = cpu_to_be32(mp->m_sb.sb_logblocks);
+		rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_LOG);
+		rrec->rm_offset = 0;
+		be16_add_cpu(&block->bb_numrecs, 1);
+	}
 }
 
 /*
@@ -215,6 +273,14 @@ xfs_agfblock_init(
 		agf->agf_refcount_level = cpu_to_be32(1);
 		agf->agf_refcount_blocks = cpu_to_be32(1);
 	}
+
+	if (is_log_ag(mp, id)) {
+		int64_t	logblocks = mp->m_sb.sb_logblocks;
+
+		be32_add_cpu(&agf->agf_freeblks, -logblocks);
+		agf->agf_longest = cpu_to_be32(id->agsize -
+			XFS_FSB_TO_AGBNO(mp, mp->m_sb.sb_logstart) - logblocks);
+	}
 }
 
 static void
