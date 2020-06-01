Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8418EC433F2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D7FF2076B
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbgFAVnF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:43:05 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55678 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728811AbgFAVnC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:43:02 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 9254E1A8695
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCr-0000XU-3s
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU6t-Qe
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 28/30] xfs: rework xfs_iflush_cluster() dirty inode iteration
Date:   Tue,  2 Jun 2020 07:42:49 +1000
Message-Id: <20200601214251.4167140-29-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=QIgWuTDL c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=ccWGV2Zw5G_KkjRFBUYA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we have all the dirty inodes attached to the cluster
buffer, we don't actually have to do radix tree lookups to find
them. Sure, the radix tree is efficient, but walking a linked list
of just the dirty inodes attached to the buffer is much better.

We are also no longer dependent on having a locked inode passed into
the function to determine where to start the lookup. This means we
can drop it from the function call and treat all inodes the same.

We also make xfs_iflush_cluster skip inodes marked with
XFS_IRECLAIM. This we avoid races with inodes that reclaim is
actively referencing or are being re-initialised by inode lookup. If
they are actually dirty, they'll get written by a future cluster
flush....

We also add a shutdown check after obtaining the flush lock so that
we catch inodes that are dirty in memory and may have inconsistent
state due to the shutdown in progress. We abort these inodes
directly and so they remove themselves directly from the buffer list
and the AIL rather than having to wait for the buffer to be failed
and callbacks run to be processed correctly.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_inode.c      | 148 ++++++++++++++++------------------------
 fs/xfs/xfs_inode.h      |   2 +-
 fs/xfs/xfs_inode_item.c |   2 +-
 3 files changed, 62 insertions(+), 90 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 8566bd0f4334d..931a483d5b316 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3611,117 +3611,94 @@ xfs_iflush(
  */
 int
 xfs_iflush_cluster(
-	struct xfs_inode	*ip,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_perag	*pag;
-	unsigned long		first_index, mask;
-	int			cilist_size;
-	struct xfs_inode	**cilist;
-	struct xfs_inode	*cip;
-	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
-	int			error = 0;
-	int			nr_found;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_log_item	*lip, *n;
+	struct xfs_inode	*ip;
+	struct xfs_inode_log_item *iip;
 	int			clcount = 0;
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
+	int			error = 0;
 
-	for (i = 0; i < nr_found; i++) {
-		cip = cilist[i];
+	/*
+	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
+	 * can remove itself from the list.
+	 */
+	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
+		iip = (struct xfs_inode_log_item *)lip;
+		ip = iip->ili_inode;
 
 		/*
-		 * because this is an RCU protected lookup, we could find a
-		 * recently freed or even reallocated inode during the lookup.
-		 * We need to check under the i_flags_lock for a valid inode
-		 * here. Skip it if it is not valid or the wrong inode.
+		 * Quick and dirty check to avoid locks if possible.
 		 */
-		spin_lock(&cip->i_flags_lock);
-		if (!cip->i_ino ||
-		    __xfs_iflags_test(cip, XFS_ISTALE)) {
-			spin_unlock(&cip->i_flags_lock);
+		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
+			continue;
+		if (xfs_ipincount(ip))
 			continue;
-		}
 
 		/*
-		 * Once we fall off the end of the cluster, no point checking
-		 * any more inodes in the list because they will also all be
-		 * outside the cluster.
+		 * The inode is still attached to the buffer, which means it is
+		 * dirty but reclaim might try to grab it. Check carefully for
+		 * that, and grab the ilock while still holding the i_flags_lock
+		 * to guarantee reclaim will not be able to reclaim this inode
+		 * once we drop the i_flags_lock.
 		 */
-		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
-			spin_unlock(&cip->i_flags_lock);
-			break;
+		spin_lock(&ip->i_flags_lock);
+		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
+		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
+			spin_unlock(&ip->i_flags_lock);
+			continue;
 		}
-		spin_unlock(&cip->i_flags_lock);
 
 		/*
-		 * Do an un-protected check to see if the inode is dirty and
-		 * is a candidate for flushing.  These checks will be repeated
-		 * later after the appropriate locks are acquired.
+		 * ILOCK will pin the inode against reclaim and prevent
+		 * concurrent transactions modifying the inode while we are
+		 * flushing the inode.
 		 */
-		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
+		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
+			spin_unlock(&ip->i_flags_lock);
 			continue;
+		}
+		spin_unlock(&ip->i_flags_lock);
 
 		/*
-		 * Try to get locks.  If any are unavailable or it is pinned,
-		 * then this inode cannot be flushed and is skipped.
+		 * Skip inodes that are already flush locked as they have
+		 * already been written to the buffer.
 		 */
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
+		if (!xfs_iflock_nowait(ip)) {
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			continue;
 		}
 
-
 		/*
-		 * Check the inode number again, just to be certain we are not
-		 * racing with freeing in xfs_reclaim_inode(). See the comments
-		 * in that function for more information as to why the initial
-		 * check is not sufficient.
+		 * If we are shut down, unpin and abort the inode now as there
+		 * is no point in flushing it to the buffer just to get an IO
+		 * completion to abort the buffer and remove it from the AIL.
 		 */
-		if (!cip->i_ino) {
-			xfs_ifunlock(cip);
-			xfs_iunlock(cip, XFS_ILOCK_SHARED);
+		if (XFS_FORCED_SHUTDOWN(mp)) {
+			xfs_iunpin_wait(ip);
+			/* xfs_iflush_abort() drops the flush lock */
+			xfs_iflush_abort(ip);
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			error = -EIO;
 			continue;
 		}
 
-		/*
-		 * arriving here means that this inode can be flushed.  First
-		 * re-check that it's dirty before flushing.
-		 */
-		if (!xfs_inode_clean(cip)) {
-			error = xfs_iflush(cip, bp);
-			if (error) {
-				xfs_iunlock(cip, XFS_ILOCK_SHARED);
-				goto out_free;
-			}
-			clcount++;
-		} else {
-			xfs_ifunlock(cip);
+		/* don't block waiting on a log force to unpin dirty inodes */
+		if (xfs_ipincount(ip)) {
+			xfs_ifunlock(ip);
+			xfs_iunlock(ip, XFS_ILOCK_SHARED);
+			continue;
 		}
-		xfs_iunlock(cip, XFS_ILOCK_SHARED);
+
+		if (!xfs_inode_clean(ip))
+			error = xfs_iflush(ip, bp);
+		else
+			xfs_ifunlock(ip);
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
+		if (error)
+			break;
+		clcount++;
 	}
 
 	if (clcount) {
@@ -3729,11 +3706,6 @@ xfs_iflush_cluster(
 		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
 	}
 
-out_free:
-	rcu_read_unlock();
-	kmem_free(cilist);
-out_put:
-	xfs_perag_put(pag);
 	if (error) {
 		bp->b_flags |= XBF_ASYNC;
 		xfs_buf_ioend_fail(bp);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index d1109eb13ba2e..b93cf9076df8a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -427,7 +427,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
 void		xfs_iunpin_wait(xfs_inode_t *);
 #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
 
-int		xfs_iflush_cluster(struct xfs_inode *, struct xfs_buf *);
+int		xfs_iflush_cluster(struct xfs_buf *);
 void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
 				struct xfs_inode *ip1, uint ip1_mode);
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index e679fac944725..a3a8ae5e39e12 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -513,7 +513,7 @@ xfs_inode_item_push(
 	 * reference for IO until we queue the buffer for delwri submission.
 	 */
 	xfs_buf_hold(bp);
-	error = xfs_iflush_cluster(ip, bp);
+	error = xfs_iflush_cluster(bp);
 	if (!error) {
 		if (!xfs_buf_delwri_queue(bp, buffer_list))
 			rval = XFS_ITEM_FLUSHING;
-- 
2.26.2.761.g0e0b3e54be

