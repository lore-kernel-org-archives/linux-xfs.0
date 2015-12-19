Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 98ACB7FDF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B9D2304053
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:06 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id WkxKVplC9PFFlhdJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:05 -0800 (PST)
Subject: [PATCH 15/76] xfs: add rmap btree growfs support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:01 -0800
Message-ID: <20151219085801.12713.77410.stgit@birch.djwong.org>
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

Now we can read and write rmap btree blocks, we can add support to
the growfs code to initialise new rmap btree blocks.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_fsops.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b3d1665..38c78da 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -32,6 +32,7 @@
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_fsops.h"
 #include "xfs_itable.h"
@@ -243,6 +244,12 @@ xfs_growfs_data_private(
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			agf->agf_roots[XFS_BTNUM_RMAPi] =
+						cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		}
+
 		agf->agf_flfirst = 0;
 		agf->agf_fllast = cpu_to_be32(XFS_AGFL_SIZE(mp) - 1);
 		agf->agf_flcount = 0;
@@ -382,6 +389,67 @@ xfs_growfs_data_private(
 		if (error)
 			goto error0;
 
+		/* RMAP btree root block */
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			struct xfs_rmap_rec	*rrec;
+			struct xfs_btree_block	*block;
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_rmapbt_buf_ops);
+			if (!bp) {
+				error = -ENOMEM;
+				goto error0;
+			}
+
+			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 2,
+						agno, XFS_BTREE_CRC_BLOCKS);
+			block = XFS_BUF_TO_BLOCK(bp);
+
+
+			/*
+			 * mark the AG header regions as static metadata The BNO
+			 * btree block is the first block after the headers, so
+			 * it's location defines the size of region the static
+			 * metadata consumes.
+			 *
+			 * Note: unlike mkfs, we never have to account for log
+			 * space when growing the data regions
+			 */
+			rrec = XFS_RMAP_REC_ADDR(block, 1);
+			rrec->rm_startblock = 0;
+			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account freespace btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 2);
+			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(2);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account inode btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 3);
+			rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
+							XFS_IBT_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for rmap btree root */ 
+			rrec = XFS_RMAP_REC_ADDR(block, 4);
+			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(1);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+			if (error)
+				goto error0;
+		}
+
 		/*
 		 * INO btree root block
 		 */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
