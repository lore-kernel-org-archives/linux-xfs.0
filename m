Return-Path: <SRS0=RL8k=AD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7556BC433E4
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B3962068F
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Jun 2020 08:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725833AbgFVIQO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 04:16:14 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60396 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbgFVIQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jun 2020 04:16:12 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 6A1A5820FD1
        for <linux-xfs@vger.kernel.org>; Mon, 22 Jun 2020 18:16:07 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-00045x-Ee
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jnHcc-007d5j-6A
        for linux-xfs@vger.kernel.org; Mon, 22 Jun 2020 18:16:06 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/30] xfs: remove IO submission from xfs_reclaim_inode()
Date:   Mon, 22 Jun 2020 18:15:53 +1000
Message-Id: <20200622081605.1818434-19-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200622081605.1818434-1-david@fromorbit.com>
References: <20200622081605.1818434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=1aYX5UUvoHHSElsYj00A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We no longer need to issue IO from shrinker based inode reclaim to
prevent spurious OOM killer invocation. This leaves only the global
filesystem management operations such as unmount needing to
writeback dirty inodes and reclaim them.

Instead of using the reclaim pass to write dirty inodes before
reclaiming them, use the AIL to push all the dirty inodes before we
try to reclaim them. This allows us to remove all the conditional
SYNC_WAIT locking and the writeback code from xfs_reclaim_inode()
and greatly simplify the checks we need to do to reclaim an inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icache.c | 117 ++++++++++++--------------------------------
 1 file changed, 31 insertions(+), 86 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 01f8efc5f59c..fa4df9b4edb5 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1111,24 +1111,17 @@ xfs_reclaim_inode_grab(
  *	dirty, async	=> requeue
  *	dirty, sync	=> flush, wait and reclaim
  */
-STATIC int
+static bool
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
 	int			sync_mode)
 {
-	struct xfs_buf		*bp = NULL;
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
-	int			error;
 
-restart:
-	error = 0;
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (!xfs_iflock_nowait(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
-			goto out;
-		xfs_iflock(ip);
-	}
+	if (!xfs_iflock_nowait(ip))
+		goto out;
 
 	if (XFS_FORCED_SHUTDOWN(ip->i_mount)) {
 		xfs_iunpin_wait(ip);
@@ -1136,52 +1129,12 @@ xfs_reclaim_inode(
 		xfs_iflush_abort(ip);
 		goto reclaim;
 	}
-	if (xfs_ipincount(ip)) {
-		if (!(sync_mode & SYNC_WAIT))
-			goto out_ifunlock;
-		xfs_iunpin_wait(ip);
-	}
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		goto reclaim;
-	}
-
-	/*
-	 * Never flush out dirty data during non-blocking reclaim, as it would
-	 * just contend with AIL pushing trying to do the same job.
-	 */
-	if (!(sync_mode & SYNC_WAIT))
+	if (xfs_ipincount(ip))
+		goto out_ifunlock;
+	if (!xfs_inode_clean(ip))
 		goto out_ifunlock;
 
-	/*
-	 * Now we have an inode that needs flushing.
-	 *
-	 * Note that xfs_iflush will never block on the inode buffer lock, as
-	 * xfs_ifree_cluster() can lock the inode buffer before it locks the
-	 * ip->i_lock, and we are doing the exact opposite here.  As a result,
-	 * doing a blocking xfs_imap_to_bp() to get the cluster buffer would
-	 * result in an ABBA deadlock with xfs_ifree_cluster().
-	 *
-	 * As xfs_ifree_cluser() must gather all inodes that are active in the
-	 * cache to mark them stale, if we hit this case we don't actually want
-	 * to do IO here - we want the inode marked stale so we can simply
-	 * reclaim it.  Hence if we get an EAGAIN error here,  just unlock the
-	 * inode, back off and try again.  Hopefully the next pass through will
-	 * see the stale flag set on the inode.
-	 */
-	error = xfs_iflush(ip, &bp);
-	if (error == -EAGAIN) {
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		/* backoff longer than in xfs_ifree_cluster */
-		delay(2);
-		goto restart;
-	}
-
-	if (!error) {
-		error = xfs_bwrite(bp);
-		xfs_buf_relse(bp);
-	}
-
+	xfs_ifunlock(ip);
 reclaim:
 	ASSERT(!xfs_isiflocked(ip));
 
@@ -1231,21 +1184,14 @@ xfs_reclaim_inode(
 	ASSERT(xfs_inode_clean(ip));
 
 	__xfs_inode_free(ip);
-	return error;
+	return true;
 
 out_ifunlock:
 	xfs_ifunlock(ip);
 out:
-	xfs_iflags_clear(ip, XFS_IRECLAIM);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	/*
-	 * We could return -EAGAIN here to make reclaim rescan the inode tree in
-	 * a short while. However, this just burns CPU time scanning the tree
-	 * waiting for IO to complete and the reclaim work never goes back to
-	 * the idle state. Instead, return 0 to let the next scheduled
-	 * background reclaim attempt to reclaim the inode again.
-	 */
-	return 0;
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	return false;
 }
 
 /*
@@ -1253,21 +1199,22 @@ xfs_reclaim_inode(
  * corrupted, we still want to try to reclaim all the inodes. If we don't,
  * then a shut down during filesystem unmount reclaim walk leak all the
  * unreclaimed inodes.
+ *
+ * Returns non-zero if any AGs or inodes were skipped in the reclaim pass
+ * so that callers that want to block until all dirty inodes are written back
+ * and reclaimed can sanely loop.
  */
-STATIC int
+static int
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
 	int			flags,
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
-	int			error = 0;
-	int			last_error = 0;
 	xfs_agnumber_t		ag;
 	int			trylock = flags & SYNC_TRYLOCK;
 	int			skipped;
 
-restart:
 	ag = 0;
 	skipped = 0;
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
@@ -1341,9 +1288,8 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				if (!batch[i])
 					continue;
-				error = xfs_reclaim_inode(batch[i], pag, flags);
-				if (error && last_error != -EFSCORRUPTED)
-					last_error = error;
+				if (!xfs_reclaim_inode(batch[i], pag, flags))
+					skipped++;
 			}
 
 			*nr_to_scan -= XFS_LOOKUP_BATCH;
@@ -1359,19 +1305,7 @@ xfs_reclaim_inodes_ag(
 		mutex_unlock(&pag->pag_ici_reclaim_lock);
 		xfs_perag_put(pag);
 	}
-
-	/*
-	 * if we skipped any AG, and we still have scan count remaining, do
-	 * another pass this time using blocking reclaim semantics (i.e
-	 * waiting on the reclaim locks and ignoring the reclaim cursors). This
-	 * ensure that when we get more reclaimers than AGs we block rather
-	 * than spin trying to execute reclaim.
-	 */
-	if (skipped && (flags & SYNC_WAIT) && *nr_to_scan > 0) {
-		trylock = 0;
-		goto restart;
-	}
-	return last_error;
+	return skipped;
 }
 
 int
@@ -1380,8 +1314,18 @@ xfs_reclaim_inodes(
 	int		mode)
 {
 	int		nr_to_scan = INT_MAX;
+	int		skipped;
 
-	return xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	if (!(mode & SYNC_WAIT))
+		return 0;
+
+	do {
+		xfs_ail_push_all_sync(mp->m_ail);
+		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	} while (skipped > 0);
+
+	return 0;
 }
 
 /*
@@ -1402,7 +1346,8 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+	return 0;
 }
 
 /*
-- 
2.26.2.761.g0e0b3e54be

