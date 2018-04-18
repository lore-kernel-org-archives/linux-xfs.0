Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:47160 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbeDRCpC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 22:45:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w3I2gulK101362
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:01 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2hdrxn8k15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:01 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2j0vT023638
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:00 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w3I2j0rV027007
        for <linux-xfs@vger.kernel.org>; Wed, 18 Apr 2018 02:45:00 GMT
Subject: [PATCH 6/9] xfs: xfs_alloc_get_rec should return EFSCORRUPTED for
 obvious bnobt corruption
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 17 Apr 2018 19:44:59 -0700
Message-ID: <152401949938.12719.10036812380313356065.stgit@magnolia>
In-Reply-To: <152401946245.12719.18338955003321437040.stgit@magnolia>
References: <152401946245.12719.18338955003321437040.stgit@magnolia>
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
index 6dd0984..98b6112 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -228,10 +228,14 @@ xfs_alloc_get_rec(
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
 

