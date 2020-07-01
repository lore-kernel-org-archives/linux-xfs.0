Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF811C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 04:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7D4D2073E
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 04:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbgGAEso (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:48:44 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:47391 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbgGAEso (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 00:48:44 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8CC333A3DC6
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 14:48:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqUfo-0002qC-7g
        for linux-xfs@vger.kernel.org; Wed, 01 Jul 2020 14:48:40 +1000
Date:   Wed, 1 Jul 2020 14:48:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 21/30 V2] xfs: remove SYNC_TRYLOCK from inode reclaim
Message-ID: <20200701044840.GP2005@dread.disaster.area>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200622081605.1818434-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-22-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=3gPCGDIPrRFzZevPBEEA:9 a=CjuIK1q_8ugA:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

All background reclaim is SYNC_TRYLOCK already, and even blocking
reclaim (SYNC_WAIT) can use trylock mechanisms as
xfs_reclaim_inodes_ag() will keep cycling until there are no more
reclaimable inodes. Hence we can kill SYNC_TRYLOCK from inode
reclaim and make everything unconditionally non-blocking.

We remove all the optimistic "avoid blocking on locks" checks done
in xfs_reclaim_inode_grab() as nothing blocks on locks anymore.
Further, checking XFS_IFLOCK optimistically can result in detecting
inodes in the process of being cleaned (i.e. between being removed
from the AIL and having the flush lock dropped), so for
xfs_reclaim_inodes() to reliably reclaim all inodes we need to drop
these checks anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
V2
- drop the optimistic unlocked checks from xfs_reclaim_inode_grab()
  because they are now unnecessary and the XFS_IFLOCK check races
  with IO completion on unmount.
- update commit message to reflect changes to
  xfs_reclaim_inode_grab()

 fs/xfs/xfs_icache.c | 63 +++++++++++++++++++++--------------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f387ec21dd35..8d18117242e1 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -174,7 +174,7 @@ xfs_reclaim_worker(
 	struct xfs_mount *mp = container_of(to_delayed_work(work),
 					struct xfs_mount, m_reclaim_work);
 
-	xfs_reclaim_inodes(mp, SYNC_TRYLOCK);
+	xfs_reclaim_inodes(mp, 0);
 	xfs_reclaim_work_queue(mp);
 }
 
@@ -1028,48 +1028,37 @@ xfs_cowblocks_worker(
 
 /*
  * Grab the inode for reclaim exclusively.
- * Return 0 if we grabbed it, non-zero otherwise.
+ *
+ * We have found this inode via a lookup under RCU, so the inode may have
+ * already been freed, or it may be in the process of being recycled by
+ * xfs_iget(). In both cases, the inode will have XFS_IRECLAIM set. If the inode
+ * has been fully recycled by the time we get the i_flags_lock, XFS_IRECLAIMABLE
+ * will not be set. Hence we need to check for both these flag conditions to
+ * avoid inodes that are no longer reclaim candidates.
+ *
+ * Note: checking for other state flags here, under the i_flags_lock or not, is
+ * racy and should be avoided. Those races should be resolved only after we have
+ * ensured that we are able to reclaim this inode and the world can see that we
+ * are going to reclaim it.
+ *
+ * Return true if we grabbed it, false otherwise.
  */
-STATIC int
+static bool
 xfs_reclaim_inode_grab(
-	struct xfs_inode	*ip,
-	int			flags)
+	struct xfs_inode	*ip)
 {
 	ASSERT(rcu_read_lock_held());
 
-	/* quick check for stale RCU freed inode */
-	if (!ip->i_ino)
-		return 1;
-
-	/*
-	 * If we are asked for non-blocking operation, do unlocked checks to
-	 * see if the inode already is being flushed or in reclaim to avoid
-	 * lock traffic.
-	 */
-	if ((flags & SYNC_TRYLOCK) &&
-	    __xfs_iflags_test(ip, XFS_IFLOCK | XFS_IRECLAIM))
-		return 1;
-
-	/*
-	 * The radix tree lock here protects a thread in xfs_iget from racing
-	 * with us starting reclaim on the inode.  Once we have the
-	 * XFS_IRECLAIM flag set it will not touch us.
-	 *
-	 * Due to RCU lookup, we may find inodes that have been freed and only
-	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
-	 * aren't candidates for reclaim at all, so we must check the
-	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
-	 */
 	spin_lock(&ip->i_flags_lock);
 	if (!__xfs_iflags_test(ip, XFS_IRECLAIMABLE) ||
 	    __xfs_iflags_test(ip, XFS_IRECLAIM)) {
 		/* not a reclaim candidate. */
 		spin_unlock(&ip->i_flags_lock);
-		return 1;
+		return false;
 	}
 	__xfs_iflags_set(ip, XFS_IRECLAIM);
 	spin_unlock(&ip->i_flags_lock);
-	return 0;
+	return true;
 }
 
 /*
@@ -1114,8 +1103,7 @@ xfs_reclaim_inode_grab(
 static bool
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
-	struct xfs_perag	*pag,
-	int			sync_mode)
+	struct xfs_perag	*pag)
 {
 	xfs_ino_t		ino = ip->i_ino; /* for radix_tree_delete */
 
@@ -1209,7 +1197,6 @@ xfs_reclaim_inode(
 static int
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
-	int			flags,
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
@@ -1254,7 +1241,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				struct xfs_inode *ip = batch[i];
 
-				if (done || xfs_reclaim_inode_grab(ip, flags))
+				if (done || !xfs_reclaim_inode_grab(ip))
 					batch[i] = NULL;
 
 				/*
@@ -1285,7 +1272,7 @@ xfs_reclaim_inodes_ag(
 			for (i = 0; i < nr_found; i++) {
 				if (!batch[i])
 					continue;
-				if (!xfs_reclaim_inode(batch[i], pag, flags))
+				if (!xfs_reclaim_inode(batch[i], pag))
 					skipped++;
 			}
 
@@ -1311,13 +1298,13 @@ xfs_reclaim_inodes(
 	int		nr_to_scan = INT_MAX;
 	int		skipped;
 
-	xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	if (!(mode & SYNC_WAIT))
 		return 0;
 
 	do {
 		xfs_ail_push_all_sync(mp->m_ail);
-		skipped = xfs_reclaim_inodes_ag(mp, mode, &nr_to_scan);
+		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	} while (skipped > 0);
 
 	return 0;
@@ -1341,7 +1328,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	return 0;
 }
 
