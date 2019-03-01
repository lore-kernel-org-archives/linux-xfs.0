Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47794 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfCAX3O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 Mar 2019 18:29:14 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x21NSvqu126397
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:13 GMT
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2130.oracle.com with ESMTP id 2qtwkut94e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 01 Mar 2019 23:29:13 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x21NTBKw023624
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:12 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x21NTBd2008190
        for <linux-xfs@vger.kernel.org>; Fri, 1 Mar 2019 23:29:11 GMT
Subject: [PATCH 22/23] libxfs: free inode item when committing transaction
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 01 Mar 2019 15:29:10 -0800
Message-ID: <155148295044.16677.1265114091017067700.stgit@magnolia>
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

When we commit a transaction with a dirtied inode, free the inode item
once we're done, and check that we never ijoin a transaction twice.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/trans.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/libxfs/trans.c b/libxfs/trans.c
index b0a04ecd..0f9f12b6 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -380,6 +380,7 @@ libxfs_trans_ijoin(
 	xfs_inode_log_item_t	*iip;
 
 	ASSERT(ip->i_transp == NULL);
+	ASSERT(ip->i_temp == NULL);
 	if (ip->i_itemp == NULL)
 		xfs_inode_item_init(ip, ip->i_mount);
 	iip = ip->i_itemp;
@@ -842,11 +843,8 @@ inode_item_done(
 	mp = iip->ili_item.li_mountp;
 	ASSERT(ip != NULL);
 
-	if (!(iip->ili_fields & XFS_ILOG_ALL)) {
-		ip->i_transp = NULL;	/* disassociate from transaction */
-		iip->ili_flags = 0;	/* reset all flags */
-		return;
-	}
+	if (!(iip->ili_fields & XFS_ILOG_ALL))
+		goto free;
 
 	/*
 	 * Get the buffer containing the on-disk inode.
@@ -867,7 +865,6 @@ inode_item_done(
 		return;
 	}
 
-	ip->i_transp = NULL;	/* disassociate from transaction */
 	bp->b_log_item = NULL;	/* remove log item */
 	bp->b_transp = NULL;	/* remove xact ptr */
 	libxfs_writebuf(bp, 0);
@@ -875,6 +872,10 @@ inode_item_done(
 	fprintf(stderr, "flushing dirty inode %llu, buffer %p\n",
 			ip->i_ino, bp);
 #endif
+free:
+	ip->i_transp = NULL;	/* disassociate from transaction */
+	ip->i_itemp = NULL;
+	kmem_zone_free(xfs_ili_zone, iip);
 }
 
 static void
