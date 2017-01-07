Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40575 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964977AbdAGAgA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Jan 2017 19:36:00 -0500
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v070Zx9d022734
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:36:00 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v070ZxO7005975
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:35:59 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v070Zx2T015585
        for <linux-xfs@vger.kernel.org>; Sat, 7 Jan 2017 00:35:59 GMT
Subject: [PATCH 02/47] xfs: provide a query_range function for freespace
 btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 06 Jan 2017 16:35:56 -0800
Message-ID: <148374935658.30431.17269003732290882771.stgit@birch.djwong.org>
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

Implement a query_range function for the bnobt and cntbt.  This will
be used for getfsmap fallback if there is no rmapbt and by the online
scrub and repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |   10 ++++++++++
 2 files changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 5050056..860e297 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2934,3 +2934,45 @@ xfs_free_extent(
 	xfs_trans_brelse(tp, agbp);
 	return error;
 }
+
+struct xfs_alloc_query_range_info {
+	xfs_alloc_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_alloc_query_range_helper(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_rec		*rec,
+	void				*priv)
+{
+	struct xfs_alloc_query_range_info	*query = priv;
+	struct xfs_alloc_rec_incore		irec;
+
+	irec.ar_startblock = be32_to_cpu(rec->alloc.ar_startblock);
+	irec.ar_blockcount = be32_to_cpu(rec->alloc.ar_blockcount);
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all free space within a given range of blocks. */
+int
+xfs_alloc_query_range(
+	struct xfs_btree_cur			*cur,
+	struct xfs_alloc_rec_incore		*low_rec,
+	struct xfs_alloc_rec_incore		*high_rec,
+	xfs_alloc_query_range_fn		fn,
+	void					*priv)
+{
+	union xfs_btree_irec			low_brec;
+	union xfs_btree_irec			high_brec;
+	struct xfs_alloc_query_range_info	query;
+
+	ASSERT(cur->bc_btnum == XFS_BTNUM_BNO);
+	low_brec.a = *low_rec;
+	high_brec.a = *high_rec;
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_alloc_query_range_helper, &query);
+}
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 7c404a6..f9f8b81 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -223,4 +223,14 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
+typedef int (*xfs_alloc_query_range_fn)(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*rec,
+	void				*priv);
+
+int xfs_alloc_query_range(struct xfs_btree_cur *cur,
+		struct xfs_alloc_rec_incore *low_rec,
+		struct xfs_alloc_rec_incore *high_rec,
+		xfs_alloc_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_ALLOC_H__ */

