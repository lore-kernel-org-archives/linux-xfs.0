Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F1D4C433E2
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34FA920812
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgEVDus (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:48 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:41150 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728045AbgEVDus (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:48 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 46D64D79178
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyhb-0002Vy-2A
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgIr-QE
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/24] xfs: rename xfs_iflush_int()
Date:   Fri, 22 May 2020 13:50:26 +1000
Message-Id: <20200522035029.3022405-22-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=FsWqk0_xLHmNMxEvWM8A:9
        a=feKkVF1pcEJdOj0I:21 a=ocw2pWKVXKeDyoPj:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

with xfs_iflush() gone, we can rename xfs_iflush_int() back to
xfs_iflush(). Also move it up above xfs_iflush_cluster() so we don't
need the forward definition any more.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c | 293 ++++++++++++++++++++++-----------------------
 1 file changed, 146 insertions(+), 147 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a94528d26328b..cbf8edf62d102 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -44,7 +44,6 @@ kmem_zone_t *xfs_inode_zone;
  */
 #define	XFS_ITRUNC_MAX_EXTENTS	2
 
-STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
 STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
 STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
 
@@ -3429,152 +3428,8 @@ xfs_rename(
 	return error;
 }
 
-/*
- * Non-blocking flush of dirty inode metadata into the backing buffer.
- *
- * The caller must have a reference to the inode and hold the cluster buffer
- * locked. The function will walk across all the inodes on the cluster buffer it
- * can find and lock without blocking, and flush them to the cluster buffer.
- *
- * On success, the caller must write out the buffer returned in *bp and
- * release it. On failure, the filesystem will be shut down, the buffer will
- * have been unlocked and released, and EFSCORRUPTED will be returned.
- */
-int
-xfs_iflush_cluster(
-	struct xfs_inode	*ip,
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	unsigned long		first_index, mask;
-	int			cilist_size;
-	struct xfs_inode	**cilist;
-	struct xfs_inode	*cip;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	int			error = 0;
-	int			nr_found;
-	int			clcount = 0;
-	int			i;
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
-	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
-	if (!cilist)
-		goto out_put;
-
-	mask = ~(igeo->inodes_per_cluster - 1);
-	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
-	rcu_read_lock();
-	/* really need a gang lookup range call here */
-	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
-					first_index, igeo->inodes_per_cluster);
-	if (nr_found == 0)
-		goto out_free;
-
-	for (i = 0; i < nr_found; i++) {
-		cip = cilist[i];
-
-		/*
-		 * because this is an RCU protected lookup, we could find a
-		 * recently freed or even reallocated inode during the lookup.
-		 * We need to check under the i_flags_lock for a valid inode
-		 * here. Skip it if it is not valid or the wrong inode.
-		 */
-		spin_lock(&cip->i_flags_lock);
-		if (!cip->i_ino ||
-		    __xfs_iflags_test(cip, XFS_ISTALE)) {
-			spin_unlock(&cip->i_flags_lock);
-			continue;
-		}
-
-		/*
-		 * Once we fall off the end of the cluster, no point checking
-		 * any more inodes in the list because they will also all be
-		 * outside the cluster.
-		 */
-		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
-			spin_unlock(&cip->i_flags_lock);
-			break;
-		}
-		spin_unlock(&cip->i_flags_lock);
-
-		/*
-		 * Do an un-protected check to see if the inode is dirty and
-		 * is a candidate for flushing.  These checks will be repeated
-		 * later after the appropriate locks are acquired.
-		 */
-		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
-			continue;
-
-		/*
-		 * Try to get locks.  If any are unavailable or it is pinned,
-		 * then this inode cannot be flushed and is skipped.
-		 */
-
-		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
-			continue;
-		if (!xfs_iflock_nowait(cip)) {
-			xfs_iunlock(cip, XFS_ILOCK_SHARED);
-			continue;
-		}
-		if (xfs_ipincount(cip)) {
-			xfs_ifunlock(cip);
-			xfs_iunlock(cip, XFS_ILOCK_SHARED);
-			continue;
-		}
-
-
-		/*
-		 * Check the inode number again, just to be certain we are not
-		 * racing with freeing in xfs_reclaim_inode(). See the comments
-		 * in that function for more information as to why the initial
-		 * check is not sufficient.
-		 */
-		if (!cip->i_ino) {
-			xfs_ifunlock(cip);
-			xfs_iunlock(cip, XFS_ILOCK_SHARED);
-			continue;
-		}
-
-		/*
-		 * arriving here means that this inode can be flushed.  First
-		 * re-check that it's dirty before flushing.
-		 */
-		if (!xfs_inode_clean(cip)) {
-			error = xfs_iflush_int(cip, bp);
-			if (error) {
-				xfs_iunlock(cip, XFS_ILOCK_SHARED);
-				goto out_free;
-			}
-			clcount++;
-		} else {
-			xfs_ifunlock(cip);
-		}
-		xfs_iunlock(cip, XFS_ILOCK_SHARED);
-	}
-
-	if (clcount) {
-		XFS_STATS_INC(mp, xs_icluster_flushcnt);
-		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
-	}
-
-out_free:
-	rcu_read_unlock();
-	kmem_free(cilist);
-out_put:
-	xfs_perag_put(pag);
-	if (error) {
-		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_ioend_fail(bp);
-		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-	}
-	return error;
-}
-
-STATIC int
-xfs_iflush_int(
+static int
+xfs_iflush(
 	struct xfs_inode	*ip,
 	struct xfs_buf		*bp)
 {
@@ -3722,6 +3577,150 @@ xfs_iflush_int(
 	return error;
 }
 
+/*
+ * Non-blocking flush of dirty inode metadata into the backing buffer.
+ *
+ * The caller must have a reference to the inode and hold the cluster buffer
+ * locked. The function will walk across all the inodes on the cluster buffer it
+ * can find and lock without blocking, and flush them to the cluster buffer.
+ *
+ * On success, the caller must write out the buffer returned in *bp and
+ * release it. On failure, the filesystem will be shut down, the buffer will
+ * have been unlocked and released, and EFSCORRUPTED will be returned.
+ */
+int
+xfs_iflush_cluster(
+	struct xfs_inode	*ip,
+	struct xfs_buf		*bp)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_perag	*pag;
+	unsigned long		first_index, mask;
+	int			cilist_size;
+	struct xfs_inode	**cilist;
+	struct xfs_inode	*cip;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	int			error = 0;
+	int			nr_found;
+	int			clcount = 0;
+	int			i;
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
+	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
+	if (!cilist)
+		goto out_put;
+
+	mask = ~(igeo->inodes_per_cluster - 1);
+	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
+	rcu_read_lock();
+	/* really need a gang lookup range call here */
+	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
+					first_index, igeo->inodes_per_cluster);
+	if (nr_found == 0)
+		goto out_free;
+
+	for (i = 0; i < nr_found; i++) {
+		cip = cilist[i];
+
+		/*
+		 * because this is an RCU protected lookup, we could find a
+		 * recently freed or even reallocated inode during the lookup.
+		 * We need to check under the i_flags_lock for a valid inode
+		 * here. Skip it if it is not valid or the wrong inode.
+		 */
+		spin_lock(&cip->i_flags_lock);
+		if (!cip->i_ino ||
+		    __xfs_iflags_test(cip, XFS_ISTALE)) {
+			spin_unlock(&cip->i_flags_lock);
+			continue;
+		}
+
+		/*
+		 * Once we fall off the end of the cluster, no point checking
+		 * any more inodes in the list because they will also all be
+		 * outside the cluster.
+		 */
+		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
+			spin_unlock(&cip->i_flags_lock);
+			break;
+		}
+		spin_unlock(&cip->i_flags_lock);
+
+		/*
+		 * Do an un-protected check to see if the inode is dirty and
+		 * is a candidate for flushing.  These checks will be repeated
+		 * later after the appropriate locks are acquired.
+		 */
+		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
+			continue;
+
+		/*
+		 * Try to get locks.  If any are unavailable or it is pinned,
+		 * then this inode cannot be flushed and is skipped.
+		 */
+
+		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
+			continue;
+		if (!xfs_iflock_nowait(cip)) {
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
+			continue;
+		}
+		if (xfs_ipincount(cip)) {
+			xfs_ifunlock(cip);
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
+			continue;
+		}
+
+
+		/*
+		 * Check the inode number again, just to be certain we are not
+		 * racing with freeing in xfs_reclaim_inode(). See the comments
+		 * in that function for more information as to why the initial
+		 * check is not sufficient.
+		 */
+		if (!cip->i_ino) {
+			xfs_ifunlock(cip);
+			xfs_iunlock(cip, XFS_ILOCK_SHARED);
+			continue;
+		}
+
+		/*
+		 * arriving here means that this inode can be flushed.  First
+		 * re-check that it's dirty before flushing.
+		 */
+		if (!xfs_inode_clean(cip)) {
+			error = xfs_iflush(cip, bp);
+			if (error) {
+				xfs_iunlock(cip, XFS_ILOCK_SHARED);
+				goto out_free;
+			}
+			clcount++;
+		} else {
+			xfs_ifunlock(cip);
+		}
+		xfs_iunlock(cip, XFS_ILOCK_SHARED);
+	}
+
+	if (clcount) {
+		XFS_STATS_INC(mp, xs_icluster_flushcnt);
+		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
+	}
+
+out_free:
+	rcu_read_unlock();
+	kmem_free(cilist);
+out_put:
+	xfs_perag_put(pag);
+	if (error) {
+		bp->b_flags |= XBF_ASYNC;
+		xfs_buf_ioend_fail(bp);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+	}
+	return error;
+}
+
 /* Release an inode. */
 void
 xfs_irele(
-- 
2.26.2.761.g0e0b3e54be

