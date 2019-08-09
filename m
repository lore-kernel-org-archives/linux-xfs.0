Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55570 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYaD9092809
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8hasj983-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO3cl008086
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6vkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Lbhib018990
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 07/18] xfs: Factor up trans handling in xfs_attr3_leaf_flipflags
Date: Fri,  9 Aug 2019 14:37:15 -0700
Message-Id: <20190809213726.32336-8-allison.henderson@oracle.com>
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Since delayed operations cannot roll transactions, factor
up the transaction handling into the calling function

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 10 ++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.c |  5 -----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 72af8e2..f36c792 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -752,6 +752,11 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -1090,6 +1095,11 @@ xfs_attr_node_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8d2e11f..8a6f5df 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2891,10 +2891,5 @@ xfs_attr3_leaf_flipflags(
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-
 	return error;
 }
-- 
2.7.4
