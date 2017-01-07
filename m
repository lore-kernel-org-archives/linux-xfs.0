Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:16611 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162018AbdAGAk6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:40:58 -0500
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070evUh025039
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:40:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.13.8/8.14.4) with ESMTP id v070evUg031912
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:40:57 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070evU1009992
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:40:57 GMT
Subject: [PATCH 47/47] xfs: avoid mount-time deadlock in CoW extent recovery
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:40:56 -0800
Message-ID: <148374965673.30431.8442483450257436954.stgit@birch.djwong.org>
In-Reply-To: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
References: <148374934333.30431.11042523766304087227.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

If a malicious user corrupts the refcount btree to cause a cycle between
different levels of the tree, the next mount attempt will deadlock in
the CoW recovery routine.  The scrub code uses the ability to re-grab a
buffer that was previous locked to a transaction to avoid deadlocks, so
do that here too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 1c47671..c845253 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1646,10 +1646,14 @@ xfs_refcount_recover_cow_leftovers(
 	if (mp->m_sb.sb_agblocks >= XFS_REFC_COW_START)
 		return -EOPNOTSUPP;
 
-	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	error = xfs_trans_alloc_empty(mp, &tp);
 	if (error)
 		return error;
-	cur = xfs_refcountbt_init_cursor(mp, NULL, agbp, agno, NULL);
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agbp);
+	if (error)
+		goto out_trans;
+	cur = xfs_refcountbt_init_cursor(mp, tp, agbp, agno, NULL);
 
 	/* Find all the leftover CoW staging extents. */
 	INIT_LIST_HEAD(&debris);
@@ -1662,7 +1666,7 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		goto out_cursor;
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_buf_relse(agbp);
+	xfs_trans_cancel(tp);
 
 	/* Now iterate the list to free the leftovers */
 	list_for_each_entry(rr, &debris, rr_list) {
@@ -1705,13 +1709,17 @@ xfs_refcount_recover_cow_leftovers(
 
 out_cursor:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_buf_relse(agbp);
+	xfs_trans_cancel(tp);
 	goto out_free;
 
 out_defer:
 	xfs_defer_cancel(&dfops);
 	xfs_trans_cancel(tp);
 	goto out_free;
+
+out_trans:
+	xfs_trans_cancel(tp);
+	return error;
 }
 
 /* Is there a record covering a given extent? */

