Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7D7A37FBF
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 02:58:14 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 60C178F8066
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:14 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id MEwsCwebGMw6ZnEL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 00:58:11 -0800 (PST)
Subject: [PATCH 16/76] xfs: enhance rmap btree growfs support
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sat, 19 Dec 2015 00:58:08 -0800
Message-ID: <20151219085808.12713.45620.stgit@birch.djwong.org>
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

Fill out the rmap offset fields.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_fsops.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 38c78da..119be0a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -393,6 +393,7 @@ xfs_growfs_data_private(
 		if (xfs_sb_version_hasrmapbt(&mp->m_sb)) {
 			struct xfs_rmap_rec	*rrec;
 			struct xfs_btree_block	*block;
+
 			bp = xfs_growfs_get_hdr_buf(mp,
 				XFS_AGB_TO_DADDR(mp, agno, XFS_RMAP_BLOCK(mp)),
 				BTOBB(mp->m_sb.sb_blocksize), 0,
@@ -402,7 +403,7 @@ xfs_growfs_data_private(
 				goto error0;
 			}
 
-			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 2,
+			xfs_btree_init_block(mp, bp, XFS_RMAP_CRC_MAGIC, 0, 0,
 						agno, XFS_BTREE_CRC_BLOCKS);
 			block = XFS_BUF_TO_BLOCK(bp);
 
@@ -420,6 +421,7 @@ xfs_growfs_data_private(
 			rrec->rm_startblock = 0;
 			rrec->rm_blockcount = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_FS);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account freespace btree root blocks */
@@ -427,6 +429,7 @@ xfs_growfs_data_private(
 			rrec->rm_startblock = cpu_to_be32(XFS_BNO_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(2);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			/* account inode btree root blocks */
@@ -435,13 +438,15 @@ xfs_growfs_data_private(
 			rrec->rm_blockcount = cpu_to_be32(XFS_RMAP_BLOCK(mp) -
 							XFS_IBT_BLOCK(mp));
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_INOBT);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
-			/* account for rmap btree root */ 
+			/* account for rmap btree root */
 			rrec = XFS_RMAP_REC_ADDR(block, 4);
 			rrec->rm_startblock = cpu_to_be32(XFS_RMAP_BLOCK(mp));
 			rrec->rm_blockcount = cpu_to_be32(1);
 			rrec->rm_owner = cpu_to_be64(XFS_RMAP_OWN_AG);
+			rrec->rm_offset = 0;
 			be16_add_cpu(&block->bb_numrecs, 1);
 
 			error = xfs_bwrite(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
