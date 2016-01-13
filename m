Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 738D67F54
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 11:52:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 15275AC012
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:52:53 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 5rE3gVvn8uvlGK8m (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Jan 2016 09:52:51 -0800 (PST)
Received: from [83.175.99.196] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1aJPbF-0003Oa-Vo
	for xfs@oss.sgi.com; Wed, 13 Jan 2016 17:52:50 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] xfs: factor btree block freeing into a helper
Date: Wed, 13 Jan 2016 18:50:53 +0100
Message-Id: <1452707454-15229-3-git-send-email-hch@lst.de>
In-Reply-To: <1452707454-15229-1-git-send-email-hch@lst.de>
References: <1452707454-15229-1-git-send-email-hch@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_btree.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 3143577..77afb4a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -294,6 +294,19 @@ xfs_btree_sblock_verify_crc(
 	return true;
 }
 
+static int
+xfs_btree_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	int			error;
+
+	error = cur->bc_ops->free_block(cur, bp);
+	if (!error)
+		XFS_BTREE_STATS_INC(cur, free);
+	return error;
+}
+
 /*
  * Delete the btree cursor.
  */
@@ -3282,12 +3295,11 @@ xfs_btree_kill_iroot(
 #endif
 	xfs_btree_copy_ptrs(cur, pp, cpp, numrecs);
 
-	error = cur->bc_ops->free_block(cur, cbp);
+	error = xfs_btree_free_block(cur, cbp);
 	if (error) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
-	XFS_BTREE_STATS_INC(cur, free);
 
 	cur->bc_bufs[level - 1] = NULL;
 	be16_add_cpu(&block->bb_level, -1);
@@ -3320,14 +3332,12 @@ xfs_btree_kill_root(
 	 */
 	cur->bc_ops->set_root(cur, newroot, -1);
 
-	error = cur->bc_ops->free_block(cur, bp);
+	error = xfs_btree_free_block(cur, bp);
 	if (error) {
 		XFS_BTREE_TRACE_CURSOR(cur, XBT_ERROR);
 		return error;
 	}
 
-	XFS_BTREE_STATS_INC(cur, free);
-
 	cur->bc_bufs[level] = NULL;
 	cur->bc_ra[level] = 0;
 	cur->bc_nlevels--;
@@ -3833,10 +3843,9 @@ xfs_btree_delrec(
 	}
 
 	/* Free the deleted block. */
-	error = cur->bc_ops->free_block(cur, rbp);
+	error = xfs_btree_free_block(cur, rbp);
 	if (error)
 		goto error0;
-	XFS_BTREE_STATS_INC(cur, free);
 
 	/*
 	 * If we joined with the left neighbor, set the buffer in the
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
