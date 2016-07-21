Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5E19F7D2D
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 23:59:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3092A304043
	for <xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id HBuJ45aFamrbDgfK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 20 Jul 2016 21:59:43 -0700 (PDT)
Subject: [PATCH 32/47] xfs: teach rmapbt to support interval queries
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 20 Jul 2016 21:59:37 -0700
Message-ID: <146907717693.25461.18075011178601243719.stgit@birch.djwong.org>
In-Reply-To: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
References: <146907695530.25461.3225785294902719773.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, bfoster@redhat.com, xfs@oss.sgi.com

Now that the generic btree code supports querying all records within a
range of keys, use that functionality to allow us to ask for all the
extents mapped to a range of physical blocks.

v2: Move unwritten bit to rm_offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_rmap.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rmap.h |    9 +++++++++
 2 files changed, 52 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ce29d6b..6638bc7 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -183,3 +183,46 @@ out_error:
 	trace_xfs_rmap_map_error(mp, agno, error, _RET_IP_);
 	return error;
 }
+
+struct xfs_rmap_query_range_info {
+	xfs_rmap_query_range_fn	fn;
+	void				*priv;
+};
+
+/* Format btree record and pass to our callback. */
+STATIC int
+xfs_rmap_query_range_helper(
+	struct xfs_btree_cur	*cur,
+	union xfs_btree_rec	*rec,
+	void			*priv)
+{
+	struct xfs_rmap_query_range_info	*query = priv;
+	struct xfs_rmap_irec			irec;
+	int					error;
+
+	error = xfs_rmap_btrec_to_irec(rec, &irec);
+	if (error)
+		return error;
+	return query->fn(cur, &irec, query->priv);
+}
+
+/* Find all rmaps between two keys. */
+int
+xfs_rmap_query_range(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*low_rec,
+	struct xfs_rmap_irec		*high_rec,
+	xfs_rmap_query_range_fn	fn,
+	void				*priv)
+{
+	union xfs_btree_irec		low_brec;
+	union xfs_btree_irec		high_brec;
+	struct xfs_rmap_query_range_info	query;
+
+	low_brec.r = *low_rec;
+	high_brec.r = *high_rec;
+	query.priv = priv;
+	query.fn = fn;
+	return xfs_btree_query_range(cur, &low_brec, &high_brec,
+			xfs_rmap_query_range_helper, &query);
+}
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index aa39a2a..34c811a 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -151,4 +151,13 @@ int xfs_rmap_lookup_eq(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 
+typedef int (*xfs_rmap_query_range_fn)(
+	struct xfs_btree_cur	*cur,
+	struct xfs_rmap_irec	*rec,
+	void			*priv);
+
+int xfs_rmap_query_range(struct xfs_btree_cur *cur,
+		struct xfs_rmap_irec *low_rec, struct xfs_rmap_irec *high_rec,
+		xfs_rmap_query_range_fn fn, void *priv);
+
 #endif	/* __XFS_RMAP_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
