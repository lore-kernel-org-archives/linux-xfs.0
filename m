Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A5A77D16
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:59:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9ABC0304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:11 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id qBbOfC5I6Vx4bY1w (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:09 -0700 (PDT)
Subject: [PATCH 27/47] xfs: add rmap btree growfs support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:03 -0700
Message-ID: <146907714363.25461.1931077605118735756.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Now we can read and write rmap btree blocks, we can add support to
the growfs code to initialise new rmap btree blocks.

[darrick.wong@oracle.com: fill out the rmap offset fields]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_fsops.c |   73 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index b625b61..27e6e8c 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -33,6 +33,7 @@
 #include "xfs_btree.h"
 #include "xfs_alloc_btree.h"
 #include "xfs_alloc.h"
+#include "xfs_rmap_btree.h"
 #include "xfs_ialloc.h"
 #include "xfs_fsops.h"
 #include "xfs_itable.h"
@@ -241,6 +242,12 @@ xfs_growfs_data_private(
 		agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
 		agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
 		agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			agf->agf_roots[XFS_BTNUM_RMAPi] =
+						cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		}
+
 		agf->agf_flfirst = cpu_to_be32(1);
 		agf->agf_fllast = 0;
 		agf->agf_flcount = 0;
@@ -380,6 +387,72 @@ xfs_growfs_data_private(
 		if (error)
 			goto error0;
 
+		/* RMAP btree root block */
+		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+			struct xfs_rmap_rec	*rrec;
+			struct xfs_btree_block	*block;
+
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_rmapbt_buf_ops);
+			if (!bp) {
+				error = -ENOMEM;
+				goto error0;
+			}
+
+			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 0,
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
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account freespace btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 2);
+			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(2);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account inode btree root blocks */
+			rrec = XFS_RMAP_REC_ADDR(block, 3);
+			rrec->rm_startblock = cpu_to_be32(XFS_IBT_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
+							XFS_IBT_BLOCK(mp));
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			rrec->rm_offset = 0;
+			be16_add_cpu(&block->bb_numrecs, 1);
+
+			/* account for rmap btree root */
+			rrec = XFS_RMAP_REC_ADDR(block, 4);
+			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+			rrec->rm_blockcount = cpu_to_be32(1);
+			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
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
