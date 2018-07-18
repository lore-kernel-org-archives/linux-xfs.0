Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:37762 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730902AbeGRQat (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jul 2018 12:30:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w6IFnkWH009065
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:16 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp2120.oracle.com with ESMTP id 2k9yjgj8y1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:16 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFqFbZ028293
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:15 GMT
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w6IFpt0q007548
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jul 2018 15:52:07 GMT
Subject: [PATCH 4/8] xfs: clean up xfs_btree_del_cursor callers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 18 Jul 2018 08:50:57 -0700
Message-ID: <153192905779.31685.9007503975897283723.stgit@magnolia>
In-Reply-To: <153192902811.31685.11590100183112248407.stgit@magnolia>
References: <153192902811.31685.11590100183112248407.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Less trivial cleanups of the error argument to xfs_btree_del_cursor;
these require some minor code refactoring.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   11 +++--------
 fs/xfs/scrub/repair.c        |    7 +++----
 2 files changed, 6 insertions(+), 12 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 240a32984d13..a38e5840a73f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1675,11 +1675,11 @@ xfs_refcount_recover_cow_leftovers(
 	high.rc.rc_startblock = -1U;
 	error = xfs_btree_query_range(cur, &low, &high,
 			xfs_refcount_recover_extent, &debris);
-	if (error)
-		goto out_cursor;
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
 	xfs_trans_cancel(tp);
+	if (error)
+		goto out_free;
 
 	/* Now iterate the list to free the leftovers */
 	list_for_each_entry_safe(rr, n, &debris, rr_list) {
@@ -1727,11 +1727,6 @@ xfs_refcount_recover_cow_leftovers(
 		kmem_free(rr);
 	}
 	return error;
-
-out_cursor:
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_trans_brelse(tp, agbp);
-	goto out_trans;
 }
 
 /* Is there a record covering a given extent? */
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 35c589a04fac..ea39e2bdc96a 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -747,9 +747,9 @@ xfs_repair_dispose_btree_block(
 
 	/* Can we find any other rmappings? */
 	error = xfs_rmap_has_other_keys(cur, agbno, 1, oinfo, &has_other_rmap);
+	xfs_btree_del_cursor(cur, error);
 	if (error)
-		goto out_cur;
-	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		goto out_free;
 
 	/*
 	 * If there are other rmappings, this block is cross linked and must
@@ -779,8 +779,7 @@ xfs_repair_dispose_btree_block(
 		return xfs_trans_roll_inode(&sc->tp, sc->ip);
 	return xfs_repair_roll_ag_trans(sc);
 
-out_cur:
-	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+out_free:
 	if (agf_bp != sc->sa.agf_bp)
 		xfs_trans_brelse(sc->tp, agf_bp);
 	return error;

