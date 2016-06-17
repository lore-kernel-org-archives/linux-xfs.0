Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5D6F8271
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:38:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2F17BAC001
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id mwl7ayhAq3QS1bcT (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:38:20 -0700 (PDT)
Subject: [PATCH 071/145] xfs: count the blocks in a btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:38:16 -0700
Message-ID: <146612749607.16048.847098109670912569.stgit@birch.djwong.org>
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

Provide a helper method to count the number of blocks in a short form
btree.  The refcount and rmap btrees need to know the number of blocks
already in use to set up their per-AG block reservations during mount.

v2: Use btree_visit_blocks instead of open-coding our own traversal
routine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c |   22 ++++++++++++++++++++++
 libxfs/xfs_btree.h |    2 ++
 2 files changed, 24 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index db0267a..1e547f8 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4799,3 +4799,25 @@ xfs_btree_query_range(
 	return xfs_btree_overlapped_query_range(cur, low_rec, high_rec,
 			fn, priv);
 }
+
+int
+xfs_btree_count_blocks_helper(
+	struct xfs_btree_cur	*cur,
+	int			level,
+	void			*data)
+{
+	xfs_extlen_t		*blocks = data;
+	(*blocks)++;
+
+	return 0;
+}
+
+/* Count the blocks in a btree and return the result in *blocks. */
+int
+xfs_btree_count_blocks(
+	struct xfs_btree_cur	*cur,
+	xfs_extlen_t		*blocks)
+{
+	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
+			blocks);
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 9963c48..6fa13a9 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -519,4 +519,6 @@ typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 		xfs_btree_visit_blocks_fn fn, void *data);
 
+int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
+
 #endif	/* __XFS_BTREE_H__ */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
