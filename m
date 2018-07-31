Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33832 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732412AbeHABDg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Jul 2018 21:03:36 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6VNIvJ2094517
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:20:57 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2130.oracle.com with ESMTP id 2kge0d3cen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:20:57 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w6VNKtvK025428
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:20:56 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w6VNKtvV006802
        for <linux-xfs@vger.kernel.org>; Tue, 31 Jul 2018 23:20:55 GMT
Subject: [PATCH 1/2] xfs: use a local variable for magic number in
 xfs_da3_node_lookup_int
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 31 Jul 2018 16:20:54 -0700
Message-ID: <153307925470.7924.18204385078598751297.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use a local variable for the block magic number checks instead of
abusing blk->magic.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 9efbd2038ffb..8ffe17b223da 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -1481,6 +1481,7 @@ xfs_da3_node_lookup_int(
 	int			error;
 	int			retval;
 	unsigned int		expected_level = 0;
+	uint16_t		magic;
 	struct xfs_inode	*dp = state->args->dp;
 
 	args = state->args;
@@ -1505,17 +1506,17 @@ xfs_da3_node_lookup_int(
 			return error;
 		}
 		curr = blk->bp->b_addr;
-		blk->magic = be16_to_cpu(curr->magic);
+		magic = be16_to_cpu(curr->magic);
 
-		if (blk->magic == XFS_ATTR_LEAF_MAGIC ||
-		    blk->magic == XFS_ATTR3_LEAF_MAGIC) {
+		if (magic == XFS_ATTR_LEAF_MAGIC ||
+		    magic == XFS_ATTR3_LEAF_MAGIC) {
 			blk->magic = XFS_ATTR_LEAF_MAGIC;
 			blk->hashval = xfs_attr_leaf_lasthash(blk->bp, NULL);
 			break;
 		}
 
-		if (blk->magic == XFS_DIR2_LEAFN_MAGIC ||
-		    blk->magic == XFS_DIR3_LEAFN_MAGIC) {
+		if (magic == XFS_DIR2_LEAFN_MAGIC ||
+		    magic == XFS_DIR3_LEAFN_MAGIC) {
 			blk->magic = XFS_DIR2_LEAFN_MAGIC;
 			blk->hashval = xfs_dir2_leaf_lasthash(args->dp,
 							      blk->bp, NULL);

