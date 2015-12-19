Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67A298094
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 03:01:05 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5970C304062
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:05 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Z8TVq8bosswpKFuF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 01:01:03 -0800 (PST)
Subject: [PATCH 42/76] xfs: add refcount btree support to growfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 01:00:59 -0800
Message-ID: <20151219090059.12713.66191.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Modify the growfs code to initialize new refcount btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsops.c |   38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 64bb02b..7c37c22 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -260,6 +260,11 @@ xfs_growfs_data_private(
 		agf->agf_longest = cpu_to_be32(tmpsize);
 		if (xfs_sb_version_hascrc(&mp->m_sb))
 			uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			agf->agf_refcount_root = cpu_to_be32(
+					xfs_refc_block(mp));
+			agf->agf_refcount_level = cpu_to_be32(1);
+		}
 
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
@@ -451,6 +456,17 @@ xfs_growfs_data_private(
 			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
+			/* account for refc btree root */
+			if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+				rrec = XFS_RMAP_REC_ADDR(block, 5);
+				rrec->rm_startblock = cpu_to_be32(
+						xfs_refc_block(mp));
+				rrec->rm_blockcount = cpu_to_be32(1);
+				rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_REFC);
+				rrec->rm_offset = 0;
+				be16_add_cpu(&block->bb_numrecs, 1);
+			}
+
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 			if (error)
@@ -508,6 +524,28 @@ xfs_growfs_data_private(
 				goto error0;
 		}
 
+		/*
+		 * refcount btree root block
+		 */
+		if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+			bp = xfs_growfs_get_hdr_buf(mp,
+				XFS_AGB_TO_DADDR(mp, agno, xfs_refc_block(mp)),
+				BTOBB(mp->m_sb.sb_blocksize), 0,
+				&xfs_refcountbt_buf_ops);
+			if (!bp) {
+				error = -ENOMEM;
+				goto error0;
+			}
+
+			xfs_btree_init_block(mp, bp, XFS_REFC_CRC_MAGIC,
+					     0, 0, agno,
+					     XFS_BTREE_CRC_BLOCKS);
+
+			error = xfs_bwrite(bp);
+			xfs_buf_relse(bp);
+			if (error)
+				goto error0;
+		}
 	}
 	xfs_trans_agblocks_delta(tp, nfree);
 	/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
