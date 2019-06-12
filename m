Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33326 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbfFLGsr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 02:48:47 -0400
Subject: [PATCH 09/14] xfs: clean up long conditionals in xfs_iwalk_ichunk_ra
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 11 Jun 2019 23:48:30 -0700
Message-ID: <156032211027.3774243.5478410694643352793.stgit@magnolia>
In-Reply-To: <156032205136.3774243.15725828509940520561.stgit@magnolia>
References: <156032205136.3774243.15725828509940520561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ichunk_ra to avoid long conditionals.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iwalk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index b30257a4bebb..a2102fa94ff5 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -83,16 +83,16 @@ xfs_iwalk_ichunk_ra(
 	agbno = XFS_AGINO_TO_AGBNO(mp, irec->ir_startino);
 
 	blk_start_plug(&plug);
-	for (i = 0;
-	     i < XFS_INODES_PER_CHUNK;
-	     i += igeo->inodes_per_cluster,
-			agbno += igeo->blocks_per_cluster) {
-		if (xfs_inobt_maskn(i, igeo->inodes_per_cluster) &
-		    ~irec->ir_free) {
+	for (i = 0; i < XFS_INODES_PER_CHUNK; i += igeo->inodes_per_cluster) {
+		xfs_inofree_t	imask;
+
+		imask = xfs_inobt_maskn(i, igeo->inodes_per_cluster);
+		if (imask & ~irec->ir_free) {
 			xfs_btree_reada_bufs(mp, agno, agbno,
 					igeo->blocks_per_cluster,
 					&xfs_inode_buf_ops);
 		}
+		agbno += igeo->blocks_per_cluster;
 	}
 	blk_finish_plug(&plug);
 }
