Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:47630 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfAACIg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:08:36 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x0126XT1163898
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:35 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2pnxedxaf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:08:35 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x0128Ytm015249
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:34 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x0128YEQ019025
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:08:34 GMT
Subject: [PATCH 1/8] xfs: never try to scrub more than 64 inodes per inobt
 record
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:08:33 -0800
Message-ID: <154630851366.14372.14057534574140159776.stgit@magnolia>
In-Reply-To: <154630850739.14372.14000129432637481206.stgit@magnolia>
References: <154630850739.14372.14000129432637481206.stgit@magnolia>
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
