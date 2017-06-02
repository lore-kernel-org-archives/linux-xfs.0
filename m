Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42553 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVYJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:09 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LO73w014958
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LO749004370
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:07 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v52LO7sK025681
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:07 GMT
Subject: [PATCH 01/13] xfs: optimize _btree_query_all
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:06 -0700
Message-ID: <149643864610.23065.12274956619066749994.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother wandering our way through the leaf nodes when the caller
issues a query_all; just zoom down the left side of the tree and walk
rightwards along level zero.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   44 +++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 39 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 3a673ba..07d75bc 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4849,12 +4849,46 @@ xfs_btree_query_all(
 	xfs_btree_query_range_fn	fn,
 	void				*priv)
 {
-	union xfs_btree_irec		low_rec;
-	union xfs_btree_irec		high_rec;
+	union xfs_btree_rec		*recp;
+	int				stat;
+	int				error;
+
+	/*
+	 * Find the leftmost record.  The btree cursor must be set
+	 * to the low record used to generate low_key.
+	 */
+	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
+	stat = 0;
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		goto out;
+
+	/* Nothing?  See if there's anything to the right. */
+	if (!stat) {
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			goto out;
+	}
 
-	memset(&low_rec, 0, sizeof(low_rec));
-	memset(&high_rec, 0xFF, sizeof(high_rec));
-	return xfs_btree_query_range(cur, &low_rec, &high_rec, fn, priv);
+	while (stat) {
+		/* Find the record. */
+		error = xfs_btree_get_rec(cur, &recp, &stat);
+		if (error || !stat)
+			break;
+
+		/* Callback */
+		error = fn(cur, recp, priv);
+		if (error < 0 || error == XFS_BTREE_QUERY_RANGE_ABORT)
+			break;
+
+		/* Move on to the next record. */
+		error = xfs_btree_increment(cur, 0, &stat);
+		if (error)
+			break;
+	}
+
+out:
+	return error;
 }
 
 /*

