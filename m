Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41249 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750784AbdEPT1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 May 2017 15:27:52 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v4GJRpJ5031317
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2017 19:27:51 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v4GJRpJn026393
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2017 19:27:51 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v4GJRnfu022319
        for <linux-xfs@vger.kernel.org>; Tue, 16 May 2017 19:27:50 GMT
Date: Tue, 16 May 2017 12:27:48 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] xfs: avoid mount-time deadlock in CoW extent recovery
Message-ID: <20170516192748.GQ4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

If a malicious user corrupts the refcount btree to cause a cycle between
different levels of the tree, the next mount attempt will deadlock in
the CoW recovery routine while grabbing buffer locks.  We can use the
ability to re-grab a buffer that was previous locked to a transaction to
avoid deadlocks, so do that here.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b177ef3..6fd337c 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1629,10 +1629,14 @@ xfs_refcount_recover_cow_leftovers(
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
@@ -1645,10 +1649,11 @@ xfs_refcount_recover_cow_leftovers(
 	if (error)
 		goto out_cursor;
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_buf_relse(agbp);
+	xfs_trans_brelse(tp, agbp);
+	xfs_trans_cancel(tp);
 
 	/* Now iterate the list to free the leftovers */
-	list_for_each_entry(rr, &debris, rr_list) {
+	list_for_each_entry_safe(rr, n, &debris, rr_list) {
 		/* Set up transaction. */
 		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, 0, 0, 0, &tp);
 		if (error)
@@ -1676,8 +1681,15 @@ xfs_refcount_recover_cow_leftovers(
 		error = xfs_trans_commit(tp);
 		if (error)
 			goto out_free;
+
+		list_del(&rr->rr_list);
+		kmem_free(rr);
 	}
 
+	return error;
+out_defer:
+	xfs_defer_cancel(&dfops);
+	xfs_trans_cancel(tp);
 out_free:
 	/* Free the leftover list */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
@@ -1688,11 +1700,8 @@ xfs_refcount_recover_cow_leftovers(
 
 out_cursor:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_buf_relse(agbp);
-	goto out_free;
-
-out_defer:
-	xfs_defer_cancel(&dfops);
+	xfs_trans_brelse(tp, agbp);
+out_trans:
 	xfs_trans_cancel(tp);
-	goto out_free;
+	return error;
 }
