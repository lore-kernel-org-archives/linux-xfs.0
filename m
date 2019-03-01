Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43484 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfCAX2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:28:50 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NSmDh125995
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:49 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2130.oracle.com with ESMTP id 2qtupetepd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:28:49 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NSeqf022899
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:41 GMT
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NSewE029945
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:28:40 GMT
Subject: [PATCH 17/23] xfs_db: use TYP_FINOBT for finobt metadump
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:28:39 -0800
Message-ID: <155148291985.16677.7567099875983610765.stgit@magnolia>
In-Reply-To: <155148280859.16677.6057998944865066232.stgit@magnolia>
References: <155148280859.16677.6057998944865066232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
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
