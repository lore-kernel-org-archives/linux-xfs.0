Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51884 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfCNVGD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:06:03 -0400
Subject: [PATCH 21/36] xfs_db: use TYP_FINOBT for finobt metadump
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:05:59 -0700
Message-ID: <155259755947.31886.6074285457193991395.stgit@magnolia>
In-Reply-To: <155259742281.31886.17157720770696604377.stgit@magnolia>
References: <155259742281.31886.17157720770696604377.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the correct xfs_db type for dumping free inode btree blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/metadump.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/db/metadump.c b/db/metadump.c
index 6ecd5685..3cce3012 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2607,7 +2607,7 @@ copy_inodes(
 		levels = be32_to_cpu(agi->agi_free_level);
 
 		finobt = 1;
-		if (!scan_btree(agno, root, levels, TYP_INOBT, &finobt,
+		if (!scan_btree(agno, root, levels, TYP_FINOBT, &finobt,
 				scanfunc_ino))
 			return 0;
 	}
