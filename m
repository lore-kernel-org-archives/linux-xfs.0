Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:46862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732373AbeGaVpz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 17:45:55 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6VJrtAJ154355
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 20:03:58 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2kggep2nyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 20:03:58 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6VK3vVo030414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 20:03:57 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6VK3vOK010204
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 20:03:57 GMT
Date: Tue, 31 Jul 2018 13:03:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: check da node magic in _node_lookup_int
Message-ID: <20180731200356.GX30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

From: Darrick J. Wong <darrick.wong@oracle.com>

Before we start processing what we /think/ is a da3 node block, actually
check the magic to make sure that we're looking at a node block.  This
way we won't blow the asserts in _node_hdr_from_disk on corrupted
metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9efbd2038ffb..70e7da634f3e 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1522,8 +1522,11 @@ xfs_da3_node_lookup_int(
 			break;
 		}
 
-		blk->magic = XFS_DA_NODE_MAGIC;
+		if (blk->magic != XFS_DA_NODE_MAGIC &&
+		    blk->magic != XFS_DA3_NODE_MAGIC)
+			return -EFSCORRUPTED;
 
+		blk->magic = XFS_DA_NODE_MAGIC;
 
 		/*
 		 * Search an intermediate node for a match.
