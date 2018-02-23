Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59798 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750916AbeBWB75 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Feb 2018 20:59:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w1N1x4HD068150
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:56 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2ga9bpg1yh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:56 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w1N1xts2014795
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:56 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w1N1xtsV030139
        for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2018 01:59:55 GMT
Subject: [PATCH 2/5] xfs: convert a few more directory asserts to corruption
 returns
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 22 Feb 2018 17:59:54 -0800
Message-ID: <151935119455.21654.14975075500644689016.stgit@magnolia>
In-Reply-To: <151935118240.21654.10146641674018880885.stgit@magnolia>
References: <151935118240.21654.10146641674018880885.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Yet another round of playing whack-a-mole with directory code that
asserts on corrupt on-disk metadata when it really should be returning
-EFSCORRUPTED instead of ASSERTing.  Found by a xfs/391 crash while
lastbit fuzzing of ltail.bestcount.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c |    3 ++-
 fs/xfs/libxfs/xfs_dir2_node.c |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d7e630f..d61d52d 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -1415,7 +1415,8 @@ xfs_dir2_leaf_removename(
 	oldbest = be16_to_cpu(bf[0].length);
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	bestsp = xfs_dir2_leaf_bests_p(ltp);
-	ASSERT(be16_to_cpu(bestsp[db]) == oldbest);
+	if (be16_to_cpu(bestsp[db]) != oldbest)
+		return -EFSCORRUPTED;
 	/*
 	 * Mark the former data entry unused.
 	 */
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 239d97a..0839ffe 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -387,8 +387,9 @@ xfs_dir2_leaf_to_node(
 	dp->d_ops->free_hdr_from_disk(&freehdr, free);
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
-	ASSERT(be32_to_cpu(ltp->bestcount) <=
-				(uint)dp->i_d.di_size / args->geo->blksize);
+	if (be32_to_cpu(ltp->bestcount) >
+				(uint)dp->i_d.di_size / args->geo->blksize)
+		return -EFSCORRUPTED;
 
 	/*
 	 * Copy freespace entries from the leaf block to the new block.

