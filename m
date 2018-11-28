Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:35302 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbeK2Kag (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Nov 2018 05:30:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wASNOo01157344
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:18 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2nxxkqn6vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:18 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id wASNRCWx023998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:13 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wASNRCV7026787
        for <linux-xfs@vger.kernel.org>; Wed, 28 Nov 2018 23:27:12 GMT
Subject: [PATCH 2/9] xfs: never try to scrub more than 64 inodes per inobt
 record
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 28 Nov 2018 15:27:11 -0800
Message-ID: <154344763127.3835.18426913692184041622.stgit@magnolia>
In-Reply-To: <154344761877.3835.7785580513047409388.stgit@magnolia>
References: <154344761877.3835.7785580513047409388.stgit@magnolia>
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
