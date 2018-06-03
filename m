Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:39618 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeFCXXL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 3 Jun 2018 19:23:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w53NLH63190301
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:11 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2jbvyp9fqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 03 Jun 2018 23:23:11 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w53NNAgb030126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:10 GMT
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w53NN9tu004192
        for <linux-xfs@vger.kernel.org>; Sun, 3 Jun 2018 23:23:09 GMT
Subject: [PATCH 07/10] xfs: xfs_alloc_get_rec should return EFSCORRUPTED for
 obvious bnobt corruption
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 03 Jun 2018 16:23:08 -0700
Message-ID: <152806818878.18187.4844773238575124410.stgit@magnolia>
In-Reply-To: <152806814253.18187.4009340462930782844.stgit@magnolia>
References: <152806814253.18187.4009340462930782844.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Return -EFSCORRUPTED when the bnobt/cntbt return obviously corrupt
values, rather than letting them bounce around in the internal code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index dc9dd3805d97..0214a77808d0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -231,10 +231,14 @@ xfs_alloc_get_rec(
 	int			error;
 
 	error = xfs_btree_get_rec(cur, &rec, stat);
-	if (!error && *stat == 1) {
-		*bno = be32_to_cpu(rec->alloc.ar_startblock);
-		*len = be32_to_cpu(rec->alloc.ar_blockcount);
-	}
+	if (error || !(*stat))
+		return error;
+	if (rec->alloc.ar_blockcount == 0)
+		return -EFSCORRUPTED;
+
+	*bno = be32_to_cpu(rec->alloc.ar_startblock);
+	*len = be32_to_cpu(rec->alloc.ar_blockcount);
+
 	return error;
 }
 

