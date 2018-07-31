Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:32822 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732412AbeHABDm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 21:03:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6VNInkg100667
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:21:02 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp2120.oracle.com with ESMTP id 2kggep37e1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:21:02 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6VNL29N023014
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:21:02 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6VNL16v022493
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:21:01 GMT
Subject: [PATCH 2/2] xfs: check da node magic in _node_lookup_int
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 31 Jul 2018 16:21:00 -0700
Message-ID: <153307926059.7924.13909891112765252120.stgit@magnolia>
In-Reply-To: <153307925470.7924.18204385078598751297.stgit@magnolia>
References: <153307925470.7924.18204385078598751297.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Before we start processing what we /think/ is a da3 node block, actually
check the magic to make sure that we're looking at a node block.  This
way we won't blow the asserts in _node_hdr_from_disk on corrupted
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 8ffe17b223da..376bee94b5dd 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1523,8 +1523,10 @@ xfs_da3_node_lookup_int(
 			break;
 		}
 
-		blk->magic = XFS_DA_NODE_MAGIC;
+		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
+			return -EFSCORRUPTED;
 
+		blk->magic = XFS_DA_NODE_MAGIC;
 
 		/*
 		 * Search an intermediate node for a match.

