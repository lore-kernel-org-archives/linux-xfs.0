Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B4E4C433F4
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C3782067B
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 07:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgFDHq0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:46:26 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41578 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728043AbgFDHqZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 03:46:25 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id E3B733A3D34
        for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2020 17:46:14 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZk-0004Av-Dv
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:08 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jgkZk-0017IP-5S
        for linux-xfs@vger.kernel.org; Thu, 04 Jun 2020 17:46:08 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 24/30] xfs: rework stale inodes in xfs_ifree_cluster
Date:   Thu,  4 Jun 2020 17:46:00 +1000
Message-Id: <20200604074606.266213-25-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200604074606.266213-1-david@fromorbit.com>
References: <20200604074606.266213-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=sEHBG_JH86uubuPEzfwA:9 a=EmdybhaG4RS5P0Sq:21 a=QT12gNWgP9Hs2AXr:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Once we have inodes pinning the cluster buffer and attached whenever
they are dirty, we no longer have a guarantee that the items are
flush locked when we lock the cluster buffer. Hence we cannot just
walk the buffer log item list and modify the attached inodes.

If the inode is not flush locked, we have to ILOCK it first and then
flush lock it to do all the prerequisite checks needed to avoid
races with other code. This is already handled by
xfs_ifree_get_one_inode(), so rework the inode iteration loop and
function to update all inodes in cache whether they are attached to
the buffer or not.

Note: we also remove the copying of the log item lsn to the
ili_flush_lsn as xfs_iflush_done() now uses the XFS_ISTALE flag to
trigger aborts and so flush lsn matching is not needed in IO
completion for processing freed inodes.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c | 158 ++++++++++++++++++---------------------------
 1 file changed, 62 insertions(+), 96 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 272b54cf97000..fb4c614c64fda 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2517,17 +2517,19 @@ xfs_iunlink_remove(
 }
 
 /*
- * Look up the inode number specified and mark it stale if it is found. If it is
- * dirty, return the inode so it can be attached to the cluster buffer so it can
- * be processed appropriately when the cluster free transaction completes.
+ * Look up the inode number specified and if it is not already marked XFS_ISTALE
+ * mark it stale. We should only find clean inodes in this lookup that aren't
+ * already stale.
  */
-static struct xfs_inode *
-xfs_ifree_get_one_inode(
-	struct xfs_perag	*pag,
+static void
+xfs_ifree_mark_inode_stale(
+	struct xfs_buf		*bp,
 	struct xfs_inode	*free_ip,
 	xfs_ino_t		inum)
 {
-	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_perag	*pag = bp->b_pag;
+	struct xfs_inode_log_item *iip;
 	struct xfs_inode	*ip;
 
 retry:
@@ -2535,8 +2537,10 @@ xfs_ifree_get_one_inode(
 	ip = radix_tree_lookup(&pag->pag_ici_root, XFS_INO_TO_AGINO(mp, inum));
 
 	/* Inode not in memory, nothing to do */
-	if (!ip)
-		goto out_rcu_unlock;
+	if (!ip) {
+		rcu_read_unlock();
+		return;
+	}
 
 	/*
 	 * because this is an RCU protected lookup, we could find a recently
@@ -2547,9 +2551,9 @@ xfs_ifree_get_one_inode(
 	spin_lock(&ip->i_flags_lock);
 	if (ip->i_ino != inum || __xfs_iflags_test(ip, XFS_ISTALE)) {
 		spin_unlock(&ip->i_flags_lock);
-		goto out_rcu_unlock;
+		rcu_read_unlock();
+		return;
 	}
-	spin_unlock(&ip->i_flags_lock);
 
 	/*
 	 * Don't try to lock/unlock the current inode, but we _cannot_ skip the
@@ -2559,43 +2563,53 @@ xfs_ifree_get_one_inode(
 	 */
 	if (ip != free_ip) {
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)) {
+			spin_unlock(&ip->i_flags_lock);
 			rcu_read_unlock();
 			delay(1);
 			goto retry;
 		}
-
-		/*
-		 * Check the inode number again in case we're racing with
-		 * freeing in xfs_reclaim_inode().  See the comments in that
-		 * function for more information as to why the initial check is
-		 * not sufficient.
-		 */
-		if (ip->i_ino != inum) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			goto out_rcu_unlock;
-		}
 	}
+	ip->i_flags |= XFS_ISTALE;
+	spin_unlock(&ip->i_flags_lock);
 	rcu_read_unlock();
 
-	xfs_iflock(ip);
-	xfs_iflags_set(ip, XFS_ISTALE);
+	/*
+	 * If we can't get the flush lock, the inode is already attached.  All
+	 * we needed to do here is mark the inode stale so buffer IO completion
+	 * will remove it from the AIL.
+	 */
+	iip = ip->i_itemp;
+	if (!xfs_iflock_nowait(ip)) {
+		ASSERT(!list_empty(&iip->ili_item.li_bio_list));
+		ASSERT(iip->ili_last_fields);
+		goto out_iunlock;
+	}
+	ASSERT(!iip || list_empty(&iip->ili_item.li_bio_list));
 
 	/*
-	 * We don't need to attach clean inodes or those only with unlogged
-	 * changes (which we throw away, anyway).
+	 * Clean inodes can be released immediately.  Everything else has to go
+	 * through xfs_iflush_abort() on journal commit as the flock
+	 * synchronises removal of the inode from the cluster buffer against
+	 * inode reclaim.
 	 */
-	if (!ip->i_itemp || xfs_inode_clean(ip)) {
-		ASSERT(ip != free_ip);
+	if (xfs_inode_clean(ip)) {
 		xfs_ifunlock(ip);
-		xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		goto out_no_inode;
+		goto out_iunlock;
 	}
-	return ip;
 
-out_rcu_unlock:
-	rcu_read_unlock();
-out_no_inode:
-	return NULL;
+	/* we have a dirty inode in memory that has not yet been flushed. */
+	ASSERT(iip->ili_fields);
+	spin_lock(&iip->ili_lock);
+	iip->ili_last_fields = iip->ili_fields;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	spin_unlock(&iip->ili_lock);
+	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
+	ASSERT(iip->ili_last_fields);
+
+out_iunlock:
+	if (ip != free_ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 }
 
 /*
@@ -2605,26 +2619,20 @@ xfs_ifree_get_one_inode(
  */
 STATIC int
 xfs_ifree_cluster(
-	xfs_inode_t		*free_ip,
-	xfs_trans_t		*tp,
+	struct xfs_inode	*free_ip,
+	struct xfs_trans	*tp,
 	struct xfs_icluster	*xic)
 {
-	xfs_mount_t		*mp = free_ip->i_mount;
+	struct xfs_mount	*mp = free_ip->i_mount;
+	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
+	struct xfs_buf		*bp;
+	xfs_daddr_t		blkno;
+	xfs_ino_t		inum = xic->first_ino;
 	int			nbufs;
 	int			i, j;
 	int			ioffset;
-	xfs_daddr_t		blkno;
-	xfs_buf_t		*bp;
-	xfs_inode_t		*ip;
-	struct xfs_inode_log_item *iip;
-	struct xfs_log_item	*lip;
-	struct xfs_perag	*pag;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	xfs_ino_t		inum;
 	int			error;
 
-	inum = xic->first_ino;
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
 	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
 
 	for (j = 0; j < nbufs; j++, inum += igeo->inodes_per_cluster) {
@@ -2668,59 +2676,16 @@ xfs_ifree_cluster(
 		bp->b_ops = &xfs_inode_buf_ops;
 
 		/*
-		 * Walk the inodes already attached to the buffer and mark them
-		 * stale. These will all have the flush locks held, so an
-		 * in-memory inode walk can't lock them. By marking them all
-		 * stale first, we will not attempt to lock them in the loop
-		 * below as the XFS_ISTALE flag will be set.
-		 */
-		list_for_each_entry(lip, &bp->b_li_list, li_bio_list) {
-			if (lip->li_type == XFS_LI_INODE) {
-				iip = (struct xfs_inode_log_item *)lip;
-				xfs_trans_ail_copy_lsn(mp->m_ail,
-							&iip->ili_flush_lsn,
-							&iip->ili_item.li_lsn);
-				xfs_iflags_set(iip->ili_inode, XFS_ISTALE);
-			}
-		}
-
-
-		/*
-		 * For each inode in memory attempt to add it to the inode
-		 * buffer and set it up for being staled on buffer IO
-		 * completion.  This is safe as we've locked out tail pushing
-		 * and flushing by locking the buffer.
-		 *
-		 * We have already marked every inode that was part of a
-		 * transaction stale above, which means there is no point in
-		 * even trying to lock them.
+		 * Now we need to set all the cached clean inodes as XFS_ISTALE,
+		 * too. This requires lookups, and will skip inodes that we've
+		 * already marked XFS_ISTALE.
 		 */
-		for (i = 0; i < igeo->inodes_per_cluster; i++) {
-			ip = xfs_ifree_get_one_inode(pag, free_ip, inum + i);
-			if (!ip)
-				continue;
-
-			iip = ip->i_itemp;
-			spin_lock(&iip->ili_lock);
-			iip->ili_last_fields = iip->ili_fields;
-			iip->ili_fields = 0;
-			iip->ili_fsync_fields = 0;
-			spin_unlock(&iip->ili_lock);
-			xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
-						&iip->ili_item.li_lsn);
-
-			list_add_tail(&iip->ili_item.li_bio_list,
-						&bp->b_li_list);
-
-			if (ip != free_ip)
-				xfs_iunlock(ip, XFS_ILOCK_EXCL);
-		}
+		for (i = 0; i < igeo->inodes_per_cluster; i++)
+			xfs_ifree_mark_inode_stale(bp, free_ip, inum + i);
 
 		xfs_trans_stale_inode_buf(tp, bp);
 		xfs_trans_binval(tp, bp);
 	}
-
-	xfs_perag_put(pag);
 	return 0;
 }
 
@@ -3845,6 +3810,7 @@ xfs_iflush_int(
 	iip->ili_fields = 0;
 	iip->ili_fsync_fields = 0;
 	spin_unlock(&iip->ili_lock);
+	ASSERT(iip->ili_last_fields);
 
 	/*
 	 * Store the current LSN of the inode so that we can tell whether the
-- 
2.26.2.761.g0e0b3e54be

