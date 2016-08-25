Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 752E580A6
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:46:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 44DF18F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:46:56 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id a3yjzckw23GfsmfL (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:46:54 -0700 (PDT)
Subject: [PATCH 03/71] xfs: count the blocks in a btree
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:46:50 -0700
Message-ID: <147216881078.4420.6999962677135186371.stgit@birch.djwong.org>
In-Reply-To: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
References: <147216879156.4420.2446767701729565218.stgit@birch.djwong.org>
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

Provide a helper method to count the number of blocks in a short form
btree.  The refcount and rmap btrees need to know the number of blocks
already in use to set up their per-AG block reservations during mount.

v2: Use btree_visit_blocks instead of open-coding our own traversal
routine.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/xfs_btree.c |   23 +++++++++++++++++++++++
 libxfs/xfs_btree.h |    2 ++
 2 files changed, 25 insertions(+)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index b3e2ce9..43c809f 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4821,3 +4821,26 @@ xfs_btree_calc_size(
 	}
 	return rval;
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
+	*blocks = 0;
+	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
+			blocks);
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 607463a..be4a0c1 100644
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
