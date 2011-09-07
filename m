Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p87G1vNr169918 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 11:01:58 -0500
Received: from e7.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E835D13CA32B
	for <xfs@oss.sgi.com>; Wed,  7 Sep 2011 09:06:02 -0700 (PDT)
Received: from e7.ny.us.ibm.com (e7.ny.us.ibm.com [32.97.182.137]) by
	cuda.sgi.com with ESMTP id OCqs1QrGutLNKQDk for
	<xfs@oss.sgi.com>; Wed, 07 Sep 2011 09:06:02 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p87EfVc5008274
	for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 10:41:31 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p87G1jTF146402 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:01:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p87G1eGP006324 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:01:40 -0400
Received: from [9.53.40.164] (chandra-lucid.austin.ibm.com [9.53.40.164])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id
	p87G1dIe006265 for <xfs@oss.sgi.com>; Wed, 7 Sep 2011 12:01:39 -0400
Subject: [PATCH] xfs: check the return value of xfs_trans_get_buf()
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Wed, 07 Sep 2011 11:01:38 -0500
Message-ID: <1315411298.9298.5.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: XFS Mailing List <xfs@oss.sgi.com>

Check the return value of xfs_trans_get_buf() and fail appropriately.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/fs/xfs/xfs_attr_leaf.c b/fs/xfs/xfs_attr_leaf.c
index 8fad960..58c3add 100644
--- a/fs/xfs/xfs_attr_leaf.c
+++ b/fs/xfs/xfs_attr_leaf.c
@@ -2948,6 +2948,8 @@ xfs_attr_leaf_freextent(xfs_trans_t **trans, xfs_inode_t *dp,
 			bp = xfs_trans_get_buf(*trans,
 					dp->i_mount->m_ddev_targp,
 					dblkno, dblkcnt, XBF_LOCK);
+			if (!bp)
+				return ENOMEM;
 			xfs_trans_binval(*trans, bp);
 			/*
 			 * Roll to next transaction.
diff --git a/fs/xfs/xfs_btree.c b/fs/xfs/xfs_btree.c
index 2b9fd38..28cc019 100644
--- a/fs/xfs/xfs_btree.c
+++ b/fs/xfs/xfs_btree.c
@@ -970,7 +970,8 @@ xfs_btree_get_buf_block(
 	*bpp = xfs_trans_get_buf(cur->bc_tp, mp->m_ddev_targp, d,
 				 mp->m_bsize, flags);
 
-	ASSERT(!xfs_buf_geterror(*bpp));
+	if (!*bpp)
+		return ENOMEM;
 
 	*block = XFS_BUF_TO_BLOCK(*bpp);
 	return 0;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 3e2ccae..0c5fe66 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -402,8 +402,11 @@ xfs_qm_dqalloc(
 			       dqp->q_blkno,
 			       mp->m_quotainfo->qi_dqchunklen,
 			       0);
-	if (!bp || (error = xfs_buf_geterror(bp)))
+
+	error = xfs_buf_geterror(bp);
+	if (error)
 		goto error1;
+
 	/*
 	 * Make a chunk of dquots out of this buffer and log
 	 * the entire thing.
diff --git a/fs/xfs/xfs_ialloc.c b/fs/xfs/xfs_ialloc.c
index 9f24ec2..207e0b0 100644
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
-		ASSERT(!xfs_buf_geterror(fbuf));
-
+		if (!fbuf)
+			return ENOMEM;
 		/*
 		 * Initialize all inodes in this buffer and then log them.
 		 *
@@ -225,6 +225,7 @@ xfs_ialloc_inode_init(
 		}
 		xfs_trans_inode_alloc_buf(tp, fbuf);
 	}
+	return 0;
 }
 
 /*
@@ -369,9 +370,11 @@ xfs_ialloc_ag_alloc(
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
index 7f237ba..d689253 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1644,7 +1644,7 @@ xfs_iunlink_remove(
  * inodes that are in memory - they all must be marked stale and attached to
  * the cluster buffer.
  */
-STATIC void
+STATIC int
 xfs_ifree_cluster(
 	xfs_inode_t	*free_ip,
 	xfs_trans_t	*tp,
@@ -1690,6 +1690,8 @@ xfs_ifree_cluster(
 					mp->m_bsize * blks_per_cluster,
 					XBF_LOCK);
 
+		if (!bp)
+			return ENOMEM;
 		/*
 		 * Walk the inodes already attached to the buffer and mark them
 		 * stale. These will all have the flush locks held, so an
@@ -1799,6 +1801,7 @@ retry:
 	}
 
 	xfs_perag_put(pag);
+	return 0;
 }
 
 /*
@@ -1878,10 +1881,10 @@ xfs_ifree(
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
index c2ff0fc..a4f3624 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -308,6 +308,8 @@ xfs_inactive_symlink_rmt(
 		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp,
 			XFS_FSB_TO_DADDR(mp, mval[i].br_startblock),
 			XFS_FSB_TO_BB(mp, mval[i].br_blockcount), 0);
+		if (!bp) 
+			goto error1;
 		xfs_trans_binval(tp, bp);
 	}
 	/*
@@ -1648,7 +1650,8 @@ xfs_symlink(
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					       BTOBB(byte_cnt), 0);
-			ASSERT(!xfs_buf_geterror(bp));
+			if (!bp)
+				goto error2;
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
