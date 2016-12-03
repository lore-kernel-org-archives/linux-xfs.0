Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:31672 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758171AbcLCBhj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Dec 2016 20:37:39 -0500
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81])
        by userp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id uB31bFxZ007735
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 3 Dec 2016 01:37:15 GMT
Subject: [PATCH 09/55] xfs: provide a query_range function for freespace
 btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Dec 2016 17:36:11 -0800
Message-ID: <148072897162.12995.6409538139504689728.stgit@birch.djwong.org>
In-Reply-To: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
References: <148072891404.12995.15510849192837089093.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
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

