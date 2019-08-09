Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:55560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728046AbfHIVhp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYQ2H092733
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2u8hasj981-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNLAB071957
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxjwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79Lbhag001884
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
From: Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH v2 10/18] xfs: Factor up trans roll from xfs_attr3_leaf_setflag
Date: Fri,  9 Aug 2019 14:37:18 -0700
Message-Id: <20190809213726.32336-11-allison.henderson@oracle.com>
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

New delayed allocation routines cannot be handling
transactions so factor them up into the calling functions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 5 +++++
 fs/xfs/libxfs/xfs_attr_leaf.c | 5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6bd87e6..7648ceb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1239,6 +1239,11 @@ xfs_attr_node_removename(
 		error = xfs_attr3_leaf_setflag(args);
 		if (error)
 			goto out;
+
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
+		if (error)
+			goto out;
+
 		error = xfs_attr_rmtval_remove(args);
 		if (error)
 			goto out;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 8a6f5df..4a22ced 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2773,10 +2773,7 @@ xfs_attr3_leaf_setflag(
 			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	return xfs_trans_roll_inode(&args->trans, args->dp);
+	return error;
 }
 
 /*
-- 
2.7.4
