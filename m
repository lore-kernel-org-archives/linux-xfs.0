Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7N52isr134633 for <xfs@oss.sgi.com>; Thu, 23 Aug 2012 00:02:44 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	2mMHgh2EcShRCCQA for <xfs@oss.sgi.com>;
	Wed, 22 Aug 2012 22:03:26 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1T4PZk-0003EI-PI
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:24 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1T4PZa-0003bn-Mn
	for xfs@oss.sgi.com; Thu, 23 Aug 2012 15:03:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 008/102] xfs: Check the return value of xfs_trans_get_buf()
Date: Thu, 23 Aug 2012 15:01:26 +1000
Message-Id: <1345698180-13612-9-git-send-email-david@fromorbit.com>
In-Reply-To: <1345698180-13612-1-git-send-email-david@fromorbit.com>
References: <1345698180-13612-1-git-send-email-david@fromorbit.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Chandra Seetharaman <sekharan@us.ibm.com>

Upstream commit: 2a30f36d9069b0646dcdd73def5fd7ab674bffd6

Check the return value of xfs_trans_get_buf() and fail
appropriately.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/quota/xfs_dquot.c |    3 ++-
 fs/xfs/xfs_attr_leaf.c   |    2 ++
 fs/xfs/xfs_btree.c       |    4 ++--
 fs/xfs/xfs_ialloc.c      |   13 ++++++++-----
 fs/xfs/xfs_inode.c       |    9 ++++++---
 fs/xfs/xfs_vnodeops.c    |    9 ++++++++-
 6 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index 6fa2146..478a11b 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -402,7 +402,8 @@ xfs_qm_dqalloc(
 			       dqp->q_blkno,
 			       mp->m_quotainfo->qi_dqchunklen,
 			       0);
-	if (!bp || (error = XFS_BUF_GETERROR(bp)))
+	error = xfs_buf_geterror(bp);
+	if (error)
 		goto error1;
 	/*
 	 * Make a chunk of dquots out of this buffer and log
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index f49ecf2..ec4f133 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2962,6 +2962,8 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 			bp = xfs_trans_get_buf(*trans,
 					dp->i_mount->m_ddev_targp,
 					dblkno, dblkcnt, XBF_LOCK);
+			if (!bp)
+				return ENOMEM;
 			xfs_trans_binval(*trans, bp);
 			/*
 			 * Roll to next transaction.
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2f9e97c..9896456 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -974,8 +974,8 @@ xfs_btree_get_buf_block(
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
 				 mp->m_bsize, flags);
 
-	ASSERT(*bpp);
-	ASSERT(!XFS_BUF_GETERROR(*bpp));
+	if (!*bpp)
+		return ENOMEM;
 
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 84ebeec..53f1e8a 100644
--- a/fs/xfs/xfs_ialloc.c
+++ b/fs/xfs/xfs_ialloc.c
@@ -150,7 +150,7 @@ xfs_check_agi_freecount(
 /*
  * Initialise a new set of inodes.
  */
-STATIC void
+STATIC int
 xfs_ialloc_inode_init(
 	struct xfs_mount	*mp,
 	struct xfs_trans	*tp,
@@ -202,8 +202,8 @@ xfs_ialloc_inode_init(
 		fbuf = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					 mp->m_bsize * blks_per_cluster,
 					 XBF_LOCK);
-		ASSERT(fbuf);
-		ASSERT(!XFS_BUF_GETERROR(fbuf));
+		if (!fbuf)
+			return ENOMEM;
 
 		/*
 		 * Initialize all inodes in this buffer and then log them.
@@ -226,6 +226,7 @@ xfs_ialloc_inode_init(
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
+	return 0;
 }
 
 /*
@@ -370,9 +371,11 @@ xfs_ialloc_ag_alloc(
 	 * rather than a linear progression to prevent the next generation
 	 * number from being easily guessable.
 	 */
-	xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno, args.len,
-			      random32());
+	error = xfs_ialloc_inode_init(args.mp, tp, agno, args.agbno,
+			args.len, random32());
 
+	if (error)
+		return error;
 	/*
 	 * Convert the results.
 	 */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 5715279..2966b4d 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1898,7 +1898,7 @@ xfs_iunlink_remove(
  * inodes that are in memory - they all must be marked stale and attached to
  * the cluster buffer.
  */
-STATIC void
+STATIC int
 xfs_ifree_cluster(
 	xfs_inode_t	*free_ip,
 	xfs_trans_t	*tp,
@@ -1944,6 +1944,8 @@ xfs_ifree_cluster(
 					mp->m_bsize * blks_per_cluster,
 					XBF_LOCK);
 
+		if (!bp)
+			return ENOMEM;
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
 		 * stale. These will all have the flush locks held, so an
@@ -2053,6 +2055,7 @@ retry:
 	}
 
 	xfs_perag_put(pag);
+	return 0;
 }
 
 /*
@@ -2133,10 +2136,10 @@ xfs_ifree(
 	dip->di_mode = 0;
 
 	if (delete) {
-		xfs_ifree_cluster(ip, tp, first_ino);
+		error = xfs_ifree_cluster(ip, tp, first_ino);
 	}
 
-	return 0;
+	return error;
 }
 
 /*
diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
index fbdb33b..154223c 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -754,6 +754,10 @@ xfs_inactive_symlink_rmt(
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
 			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
+		if (!bp) {
+			error = ENOMEM;
+			goto error1;
+		}
 		xfs_trans_binval(tp, bp);
 	}
 	/*
@@ -2116,7 +2120,10 @@ xfs_symlink(
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					       BTOBB(byte_cnt), 0);
-			ASSERT(bp && !XFS_BUF_GETERROR(bp));
+			if (!bp) {
+				error = ENOMEM;
+				goto error2;
+			}
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
