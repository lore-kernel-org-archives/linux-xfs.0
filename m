Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:41926 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728644AbfAHUcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Jan 2019 15:32:46 -0500
Subject: [PATCH 1/7] xfs: never try to scrub more than 64 inodes per inobt
 record
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 08 Jan 2019 12:32:41 -0800
Message-ID: <154697956133.2494.6394256045335740042.stgit@magnolia>
In-Reply-To: <154697955494.2494.5221420762912855354.stgit@magnolia>
References: <154697955494.2494.5221420762912855354.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, bfoster@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we never check more than XFS_INODES_PER_CHUNK inodes for any
given inobt record since there can be more than one inobt record mapped
to an inode cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/scrub/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 882dc56c5c21..fd431682db0b 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -203,7 +203,8 @@ xchk_iallocbt_check_freemask(
 	int				error = 0;
 
 	/* Make sure the freemask matches the inode records. */
-	nr_inodes = mp->m_inodes_per_cluster;
+	nr_inodes = min_t(unsigned int, XFS_INODES_PER_CHUNK,
+			mp->m_inodes_per_cluster);
 
 	for (agino = irec->ir_startino;
 	     agino < irec->ir_startino + XFS_INODES_PER_CHUNK;
