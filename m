Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DAB367CA2
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2016 01:21:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CC472304032
	for <xfs@oss.sgi.com>; Tue, 16 Feb 2016 23:21:16 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	r5qhwOkssL3Dye9Z for <xfs@oss.sgi.com>;
	Tue, 16 Feb 2016 23:21:15 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aVwPu-0004lv-O6
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aVwPu-000143-NG
	for xfs@oss.sgi.com; Wed, 17 Feb 2016 18:20:54 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/15] xfs: move buffer invalidation to xfs_btree_free_block
Date: Wed, 17 Feb 2016 18:20:41 +1100
Message-Id: <1455693652-3899-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1455693652-3899-1-git-send-email-david@fromorbit.com>
References: <1455693652-3899-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@lst.de>

Source kernel commit edfd9dd549212a0923c9b5b142275dc88912abfa

... instead of leaving it in the methods.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 libxfs/xfs_alloc_btree.c  |  2 --
 libxfs/xfs_bmap_btree.c   |  1 -
 libxfs/xfs_btree.c        |  4 +++-
 libxfs/xfs_ialloc_btree.c | 12 ++----------
 4 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c
index 6f13572..79d0fb9 100644
--- a/libxfs/xfs_alloc_btree.c
+++ b/libxfs/xfs_alloc_btree.c
@@ -116,8 +116,6 @@ xfs_allocbt_free_block(
 	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
-
-	xfs_trans_binval(cur->bc_tp, bp);
 	return 0;
 }
 
diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c
index 2ef1836..a63379b 100644
--- a/libxfs/xfs_bmap_btree.c
+++ b/libxfs/xfs_bmap_btree.c
@@ -528,7 +528,6 @@ xfs_bmbt_free_block(
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
-	xfs_trans_binval(tp, bp);
 	return 0;
 }
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index f4a1c67..a736cb5 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -298,8 +298,10 @@ xfs_btree_free_block(
 	int			error;
 
 	error = cur->bc_ops->free_block(cur, bp);
-	if (!error)
+	if (!error) {
+		xfs_trans_binval(cur->bc_tp, bp);
 		XFS_BTREE_STATS_INC(cur, free);
+	}
 	return error;
 }
 
diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c
index 52939c3..a077635 100644
--- a/libxfs/xfs_ialloc_btree.c
+++ b/libxfs/xfs_ialloc_btree.c
@@ -124,16 +124,8 @@ xfs_inobt_free_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_buf		*bp)
 {
-	xfs_fsblock_t		fsbno;
-	int			error;
-
-	fsbno = XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp));
-	error = xfs_free_extent(cur->bc_tp, fsbno, 1);
-	if (error)
-		return error;
-
-	xfs_trans_binval(cur->bc_tp, bp);
-	return error;
+	return xfs_free_extent(cur->bc_tp,
+			XFS_DADDR_TO_FSB(cur->bc_mp, XFS_BUF_ADDR(bp)), 1);
 }
 
 STATIC int
-- 
2.7.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
