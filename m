Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B24B682FB
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:55:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 19FDEAC003
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:38 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4nbqRSKbzP6rCXIX (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:55:36 -0700 (PDT)
Subject: [PATCH 02/24] xfs: have getfsmap fall back to the freesp btrees
	when rmap is not present
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:55:31 -0700
Message-ID: <147216933141.6398.3843782526499785752.stgit@birch.djwong.org>
In-Reply-To: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
References: <147216931783.6398.1716678878794493264.stgit@birch.djwong.org>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

If the reverse-mapping btree isn't available, fall back to the
free space btrees to provide partial reverse mapping information.
The online scrub tool can make use of even partial information to
speed up the data block scan.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_alloc.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_alloc.h |   10 ++++++++++
 2 files changed, 52 insertions(+)


diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 3151fbb..0f93016 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2928,3 +2928,45 @@ err:
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
+/* Find all rmaps between two keys. */
+int
+xfs_alloc_query_range(
+	struct xfs_btree_cur		*cur,
+	struct xfs_alloc_rec_incore	*low_rec,
+	struct xfs_alloc_rec_incore	*high_rec,
+	xfs_alloc_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec;
+	union xfs_btree_irec		high_brec;
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
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index f7c5201..0b00de0 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -210,4 +210,14 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, xfs_agnumber_t agno,
 
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

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
