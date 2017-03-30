Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32618 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933443AbdC3P6X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Mar 2017 11:58:23 -0400
Subject: [PATCH 3/9] xfs: provide a query_range function for freespace btrees
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 30 Mar 2017 08:58:18 -0700
Message-ID: <149088949857.25895.936552860313902403.stgit@birch.djwong.org>
In-Reply-To: <149088947516.25895.12489128187852930801.stgit@birch.djwong.org>
References: <149088947516.25895.12489128187852930801.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Brian Foster <bfoster@redhat.com>, linux-ext4@vger.kernel.org, linux-api@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Implement a query_range function for the bnobt and cntbt.  This will
be used for getfsmap fallback if there is no rmapbt and by the online
scrub and repair code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_alloc.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_alloc.h |   10 ++++++++++
 2 files changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 369adcc..f65b8d4 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2868,3 +2868,45 @@ xfs_free_extent(
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
index 2a8d0fa..6c2643c 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -219,4 +219,14 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 
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

