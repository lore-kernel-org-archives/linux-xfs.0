Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47532 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbeKOQLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 11:11:03 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAF63wlS148427
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:36 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2nr7cs7jjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:36 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wAF64ZUr021755
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:35 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id wAF64ZKW027534
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 06:04:35 GMT
Subject: [PATCH 2/9] xfs: never try to scrub more than 64 inodes per inobt
 record
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 14 Nov 2018 22:04:34 -0800
Message-ID: <154226187415.13280.16593356573868407559.stgit@magnolia>
In-Reply-To: <154226186169.13280.4536602352984659736.stgit@magnolia>
References: <154226186169.13280.4536602352984659736.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Make sure we never check more than XFS_INODES_PER_CHUNK inodes for any
given inobt record since there can be more than one inobt record mapped
to an inode cluster.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/scrub/ialloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 31ec0c16be4a..b06a0b4de070 100644
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
