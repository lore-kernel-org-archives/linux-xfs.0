Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:58800 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbfFDVuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:50:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnbfE053365
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:16 GMT
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2sugstfp9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lmm6E172031
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2swngkkj3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:16 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54LoF3P025149
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:15 GMT
Subject: [PATCH 07/10] xfs: clean up long conditionals in xfs_iwalk_ichunk_ra
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 04 Jun 2019 14:50:12 -0700
Message-ID: <155968501261.1657646.16272249682611768545.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor xfs_iwalk_ichunk_ra to avoid long conditionals.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iwalk.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 9ad017ddbae7..8595258b5001 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -84,16 +84,16 @@ xfs_iwalk_ichunk_ra(
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
