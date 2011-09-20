Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8KDv0Q9063919 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 08:57:00 -0500
Received: from e8.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 34E281DADFAE
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:56:59 -0700 (PDT)
Received: from e8.ny.us.ibm.com (e8.ny.us.ibm.com [32.97.182.138]) by
	cuda.sgi.com with ESMTP id tgbtRCPkbGA2FCmi for
	<xfs@oss.sgi.com>; Tue, 20 Sep 2011 06:56:59 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p8KDgKTn001855
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 09:42:20 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p8KDuw4s259580 for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 09:56:58 -0400
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p8KDuvbY017324
	for <xfs@oss.sgi.com>; Tue, 20 Sep 2011 07:56:57 -0600
Subject: [PATCH v2] xfs: Check the return value of xfs_trans_get_buf()
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 20 Sep 2011 08:56:55 -0500
Message-ID: <1316527015.9298.60.camel@chandra-lucid.austin.ibm.com>
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
Cc: Alex Elder <aelder@sgi.com>

Ran the xfstests (auto) overnight and didn't see any new issues.

--
Check the return value of xfs_trans_get_buf() and fail appropriately.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

---
 fs/xfs/xfs_attr_leaf.c |    2 ++
 fs/xfs/xfs_btree.c     |    3 ++-
 fs/xfs/xfs_dquot.c     |    5 ++++-
 fs/xfs/xfs_ialloc.c    |   13 ++++++++-----
 fs/xfs/xfs_inode.c     |    9 ++++++---
 fs/xfs/xfs_vnodeops.c  |    9 ++++++++-
 6 files changed, 30 insertions(+), 11 deletions(-)

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
index c2ff0fc..0d1caec 100644
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -308,6 +308,10 @@ xfs_inactive_symlink_rmt(
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
@@ -1648,7 +1652,10 @@ xfs_symlink(
 			byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 			bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, d,
 					       BTOBB(byte_cnt), 0);
-			ASSERT(!xfs_buf_geterror(bp));
+			if (!bp) {
+				error = ENOMEM;
+				goto error2;
+			}
 			if (pathlen < byte_cnt) {
 				byte_cnt = pathlen;
 			}
-- 
1.7.1



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
