Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 289E68157
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:34:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95B3DAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:52 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id L6TVVSnXKLhZ6kHB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:34:50 -0700 (PDT)
Subject: [PATCH 038/145] xfs: teach rmapbt to support interval queries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:34:43 -0700
Message-ID: <146612728370.16048.5124604381084390901.stgit@birch.djwong.org>
In-Reply-To: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
References: <146612704434.16048.12932915166928562654.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

Now that the generic btree code supports querying all records within a
range of keys, use that functionality to allow us to ask for all the
extents mapped to a range of physical blocks.

v2: Move unwritten bit to rm_offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_rmap.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_rmap_btree.h |    9 +++++++++
 2 files changed, 52 insertions(+)


diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 5034fd3..390ddde 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -182,3 +182,46 @@ out_error:
 	trace_xfs_rmap_alloc_extent_error(mp, agno, bno, len, false, oinfo);
 	return error;
 }
+
+struct xfs_rmapbt_query_range_info {
+	xfs_rmapbt_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_rmapbt_query_range_helper(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	void			*priv)
+{
+	struct xfs_rmapbt_query_range_info	*query = priv;
+	struct xfs_rmap_irec			irec;
+	int					error;
+
+	error = xfs_rmapbt_btrec_to_irec(rec, &irec);
+	if (error)
+		return error;
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all rmaps between two keys. */
+int
+xfs_rmapbt_query_range(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*low_rec,
+	struct xfs_rmap_irec		*high_rec,
+	xfs_rmapbt_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec;
+	union xfs_btree_irec		high_brec;
+	struct xfs_rmapbt_query_range_info	query;
+
+	low_brec.r = *low_rec;
+	high_brec.r = *high_rec;
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_rmapbt_query_range_helper, &query);
+}
diff --git a/libxfs/xfs_rmap_btree.h b/libxfs/xfs_rmap_btree.h
index 796071c..e926c6e 100644
--- a/libxfs/xfs_rmap_btree.h
+++ b/libxfs/xfs_rmap_btree.h
@@ -74,4 +74,13 @@ int xfs_rmap_free(struct xfs_trans *tp, struct xfs_buf *agbp,
 		  xfs_agnumber_t agno, xfs_agblock_t bno, xfs_extlen_t len,
 		  struct xfs_owner_info *oinfo);
 
+typedef int (*xfs_rmapbt_query_range_fn)(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv);
+
+int xfs_rmapbt_query_range(struct xfs_btree_cur *cur,
+		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
+		xfs_rmapbt_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_RMAP_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
