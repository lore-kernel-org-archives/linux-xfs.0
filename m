Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 950897CBC
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 20:23:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5691B30404E
	for <xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:22 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id zEZ0cPgOx926nLaV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 16 Jun 2016 18:23:20 -0700 (PDT)
Subject: [PATCH 050/119] xfs: count the blocks in a btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 16 Jun 2016 18:23:12 -0700
Message-ID: <146612659218.12839.17928675947317698460.stgit@birch.djwong.org>
In-Reply-To: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

Provide a helper method to count the number of blocks in a short form
btree.  The refcount and rmap btrees need to know the number of blocks
already in use to set up their per-AG block reservations during mount.

v2: Use btree_visit_blocks instead of open-coding our own traversal
routine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_btree.c |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_btree.h |    2 ++
 2 files changed, 24 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4b90419..50b2c32 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4803,3 +4803,25 @@ xfs_btree_query_range(
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
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 9963c48..6fa13a9 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
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
