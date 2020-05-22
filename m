Return-Path: <SRS0=AE4z=7E=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BBD6C433EC
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BE5020759
	for <linux-xfs@archiver.kernel.org>; Fri, 22 May 2020 03:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgEVDun (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 21 May 2020 23:50:43 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:60742 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728225AbgEVDum (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:42 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 95F7D3A3745
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:34 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002Vs-Vw
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgIh-NW
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 19/24] xfs: attach inodes to the cluster buffer when dirtied
Date:   Fri, 22 May 2020 13:50:24 +1000
Message-Id: <20200522035029.3022405-20-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=AEOYztjLbpc9pIpwf4AA:9
        a=7PeEbY6SjtFySg17:21 a=YZFmugUgQmE6SMws:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Rather than attach inodes to the cluster buffer just when we are
doing IO, attach the inodes to the cluster buffer when they are
dirtied. The means the buffer always carries a list of dirty inodes
that reference it, and we can use that list to make more fundamental
changes to inode writeback that aren't otherwise possible.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_inode.c |   9 +-
 fs/xfs/xfs_inode.c              | 154 +++++++++++---------------------
 fs/xfs/xfs_inode_item.c         |  19 ++--
 3 files changed, 68 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index e130eb2994156..e5f58a4b13eee 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -162,13 +162,16 @@ xfs_trans_log_inode(
 		/*
 		 * We need an explicit buffer reference for the log item, We
 		 * don't want the buffer attached to the transaction, so we have
-		 * to release the transaction reference we just gained.
+		 * to release the transaction reference we just gained. But we
+		 * don't want to drop the buffer lock until we've attached the
+		 * inode item to the buffer log item list....
 		 */
 		xfs_buf_hold(bp);
-		xfs_trans_brelse(tp, bp);
-
 		spin_lock(&iip->ili_lock);
 		iip->ili_item.li_buf = bp;
+		bp->b_flags |= _XBF_INODES;
+		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
+		xfs_trans_brelse(tp, bp);
 	}
 
 	/*
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index c5529853f513c..961eef2ce8c4a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2498,17 +2498,18 @@ xfs_iunlink_remove(
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
+static void
+xfs_ifree_mark_inode_stale(
 	struct xfs_perag	*pag,
 	struct xfs_inode	*free_ip,
 	xfs_ino_t		inum)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
+	struct xfs_inode_log_item *iip;
 	struct xfs_inode	*ip;
 
 retry:
@@ -2516,8 +2517,10 @@ xfs_ifree_get_one_inode(
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
@@ -2528,9 +2531,9 @@ xfs_ifree_get_one_inode(
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
@@ -2540,43 +2543,45 @@ xfs_ifree_get_one_inode(
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
+	/* If we can't get the flush lock, the inode is already attached */
+	if (!xfs_iflock_nowait(ip))
+		goto out_iunlock;
 
 	/*
-	 * We don't need to attach clean inodes or those only with unlogged
-	 * changes (which we throw away, anyway).
+	 * Inodes not attached to the buffer can be released immediately.
+	 * Everything else has to go through xfs_iflush_abort() on journal
+	 * commit as the flock synchronises removal of the inode from the
+	 * cluster buffer against inode reclaim.
 	 */
-	if (!ip->i_itemp || xfs_inode_clean(ip)) {
-		ASSERT(ip != free_ip);
+	if (!ip->i_itemp || list_empty(&ip->i_itemp->ili_item.li_bio_list)) {
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
+	iip = ip->i_itemp;
+	ASSERT(!list_empty(&iip->ili_item.li_bio_list));
+
+	spin_lock(&iip->ili_lock);
+	iip->ili_last_fields = iip->ili_fields;
+	iip->ili_fields = 0;
+	iip->ili_fsync_fields = 0;
+	spin_unlock(&iip->ili_lock);
+	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
+				&iip->ili_item.li_lsn);
+out_iunlock:
+	if (ip != free_ip)
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 }
 
 /*
@@ -2586,25 +2591,21 @@ xfs_ifree_get_one_inode(
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
+	struct xfs_perag	*pag;
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
 	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, inum));
 	nbufs = igeo->ialloc_blks / igeo->blocks_per_cluster;
 
@@ -2649,53 +2650,12 @@ xfs_ifree_cluster(
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
+			xfs_ifree_mark_inode_stale(pag, free_ip, inum + i);
 
 		xfs_trans_stale_inode_buf(tp, bp);
 		xfs_trans_binval(tp, bp);
@@ -3831,22 +3791,12 @@ xfs_iflush_int(
 	 * Store the current LSN of the inode so that we can tell whether the
 	 * item has moved in the AIL from xfs_iflush_done().
 	 */
+	ASSERT(iip->ili_item.li_lsn);
 	xfs_trans_ail_copy_lsn(mp->m_ail, &iip->ili_flush_lsn,
 				&iip->ili_item.li_lsn);
 
-	/*
-	 * Attach the inode item callback to the buffer whether the flush
-	 * succeeded or not. If not, the caller will shut down and fail I/O
-	 * completion on the buffer to remove the inode from the AIL and release
-	 * the flush lock.
-	 */
-	bp->b_flags |= _XBF_INODES;
-	list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
-
 	/* generate the checksum. */
 	xfs_dinode_calc_crc(mp, dip);
-
-	ASSERT(!list_empty(&bp->b_li_list));
 	return error;
 }
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 86173a52526fe..7718cfc39eec8 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -683,10 +683,7 @@ xfs_inode_item_destroy(
  *
  * Note: Now that we attach the log item to the buffer when we first log the
  * inode in memory, we can have unflushed inodes on the buffer list here. These
- * inodes will have a zero ili_last_fields, so skip over them here. We do
- * this check -after- we've checked for stale inodes, because we're guaranteed
- * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
- * not yet had their dirtying transactions committed to disk.
+ * inodes will have a zero ili_last_fields, so skip over them here.
  */
 void
 xfs_iflush_done(
@@ -704,15 +701,14 @@ xfs_iflush_done(
 	 */
 	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
 		iip = INODE_ITEM(lip);
+		if (!iip->ili_last_fields)
+			continue;
+
 		if (xfs_iflags_test(iip->ili_inode, XFS_ISTALE)) {
-			list_del_init(&lip->li_bio_list);
 			xfs_iflush_abort(iip->ili_inode);
 			continue;
 		}
 
-		if (!iip->ili_last_fields)
-			continue;
-
 		list_move_tail(&lip->li_bio_list, &tmp);
 
 		/* Do an unlocked check for needing the AIL lock. */
@@ -762,12 +758,16 @@ xfs_iflush_done(
 		/*
 		 * Remove the reference to the cluster buffer if the inode is
 		 * clean in memory. Drop the buffer reference once we've dropped
-		 * the locks we hold.
+		 * the locks we hold. If the inode is dirty in memory, we need
+		 * to put the inode item back on the buffer list for another
+		 * pass through the flush machinery.
 		 */
 		ASSERT(iip->ili_item.li_buf == bp);
 		if (!iip->ili_fields) {
 			iip->ili_item.li_buf = NULL;
 			drop_buffer = true;
+		} else {
+			list_add(&lip->li_bio_list, &bp->b_li_list);
 		}
 		spin_unlock(&iip->ili_lock);
 		xfs_ifunlock(iip->ili_inode);
@@ -802,6 +802,7 @@ xfs_iflush_abort(
 		iip->ili_flush_lsn = 0;
 		bp = iip->ili_item.li_buf;
 		iip->ili_item.li_buf = NULL;
+		list_del_init(&iip->ili_item.li_bio_list);
 		spin_unlock(&iip->ili_lock);
 	}
 	xfs_ifunlock(ip);
-- 
2.26.2.761.g0e0b3e54be

