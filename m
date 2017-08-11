Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50315 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751418AbdHKHKj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Aug 2017 03:10:39 -0400
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7B7AcmX031254
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7B7AcPh028680
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:38 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id v7B7AcpD020379
        for <linux-xfs@vger.kernel.org>; Fri, 11 Aug 2017 07:10:38 GMT
Subject: [PATCH 04/16] xfs: add scrub cross-referencing helpers for the
 refcount btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 11 Aug 2017 00:10:37 -0700
Message-ID: <150243543763.29473.17575303942230867687.stgit@magnolia>
In-Reply-To: <150243541274.29473.1227559008347544526.stgit@magnolia>
References: <150243541274.29473.1227559008347544526.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a couple of functions to the refcount btrees that will be used
to cross-reference metadata against the refcountbt.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_refcount.c |   19 +++++++++++++++++++
 fs/xfs/libxfs/xfs_refcount.h |    3 +++
 2 files changed, 22 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 45b1c3b..728133f 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1709,3 +1709,22 @@ xfs_refcount_recover_cow_leftovers(
 	xfs_trans_brelse(tp, agbp);
 	goto out_trans;
 }
+
+/* Is there a record covering a given extent? */
+int
+xfs_refcount_has_record(
+	struct xfs_btree_cur	*cur,
+	xfs_agblock_t		bno,
+	xfs_extlen_t		len,
+	bool			*exists)
+{
+	union xfs_btree_irec	low;
+	union xfs_btree_irec	high;
+
+	memset(&low, 0, sizeof(low));
+	low.rc.rc_startblock = bno;
+	memset(&high, 0xFF, sizeof(high));
+	high.rc.rc_startblock = bno + len - 1;
+
+	return xfs_btree_has_record(cur, &low, &high, exists);
+}
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index eafb9d1..2a731ac 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -83,4 +83,7 @@ static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
 	return (log_res * 3 / 4) / XFS_REFCOUNT_ITEM_OVERHEAD;
 }
 
+extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+
 #endif	/* __XFS_REFCOUNT_H__ */

