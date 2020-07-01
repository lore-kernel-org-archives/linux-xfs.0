Return-Path: <SRS0=D+gV=AM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51022C433E0
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 04:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C542070C
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jul 2020 04:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725535AbgGAEvP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Jul 2020 00:51:15 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34429 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725272AbgGAEvP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 00:51:15 -0400
Received: from dread.disaster.area (pa49-180-53-24.pa.nsw.optusnet.com.au [49.180.53.24])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id C59C41A83D3
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 14:51:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jqUiF-0002qR-7h
        for linux-xfs@vger.kernel.org; Wed, 01 Jul 2020 14:51:11 +1000
Date:   Wed, 1 Jul 2020 14:51:11 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/30 V2] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
Message-ID: <20200701045111.GQ2005@dread.disaster.area>
References: <20200622081605.1818434-1-david@fromorbit.com>
 <20200622081605.1818434-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622081605.1818434-23-david@fromorbit.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=moVtWZxmCkf3aAMJKIb/8g==:117 a=moVtWZxmCkf3aAMJKIb/8g==:17
        a=kj9zAlcOel0A:10 a=_RQrkK6FrEwA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=sUqSWh8J9-xhi8_rs5AA:9 a=CjuIK1q_8ugA:10
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

Clean up xfs_reclaim_inodes() callers. Most callers want blocking
behaviour, so just make the existing SYNC_WAIT behaviour the
default.

For the xfs_reclaim_worker(), just call xfs_reclaim_inodes_ag()
directly because we just want optimistic clean inode reclaim to be
done in the background.

For xfs_quiesce_attr() we can just remove the inode reclaim calls as
they are a historic relic that was required to flush dirty inodes
that contained unlogged changes. We now log all changes to the
inodes, so the sync AIL push from xfs_log_quiesce() called by
xfs_quiesce_attr() will do all the required inode writeback for
freeze.

Seeing as we now want to loop until all reclaimable inodes have been
reclaimed, make xfs_reclaim_inodes() loop on the XFS_ICI_RECLAIM_TAG
tag rather than having xfs_reclaim_inodes_ag() tell it that inodes
were skipped. This is much more reliable and will always loop until
all reclaimable inodes are reclaimed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
V2
- kill the "skipped inode" checking in xfs_reclaim_inodes_ag() and
  xfs_reclaim_inodes() to trigger looping until the cache is empty
  and replace it with a loop that checks if the XFS_ICI_RECLAIM_TAG
  set on the perag radix tree. This will now always loop if there
  are still inodes to reclaim.
- update commit message to reflect new looping behaviour.

 fs/xfs/xfs_icache.c | 79 ++++++++++++++++++++---------------------------------
 fs/xfs/xfs_icache.h |  2 +-
 fs/xfs/xfs_mount.c  | 11 ++++----
 fs/xfs/xfs_super.c  |  3 --
 4 files changed, 35 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 8d18117242e1..f4e7b98d9639 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -160,24 +160,6 @@ xfs_reclaim_work_queue(
 	rcu_read_unlock();
 }
 
-/*
- * This is a fast pass over the inode cache to try to get reclaim moving on as
- * many inodes as possible in a short period of time. It kicks itself every few
- * seconds, as well as being kicked by the inode cache shrinker when memory
- * goes low. It scans as quickly as possible avoiding locked inodes or those
- * already being flushed, and once done schedules a future pass.
- */
-void
-xfs_reclaim_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-					struct xfs_mount, m_reclaim_work);
-
-	xfs_reclaim_inodes(mp, 0);
-	xfs_reclaim_work_queue(mp);
-}
-
 static void
 xfs_perag_set_reclaim_tag(
 	struct xfs_perag	*pag)
@@ -1100,7 +1082,7 @@ xfs_reclaim_inode_grab(
  *	dirty, async	=> requeue
  *	dirty, sync	=> flush, wait and reclaim
  */
-static bool
+static void
 xfs_reclaim_inode(
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag)
@@ -1173,7 +1155,7 @@ xfs_reclaim_inode(
 	ASSERT(xfs_inode_clean(ip));
 
 	__xfs_inode_free(ip);
-	return true;
+	return;
 
 out_ifunlock:
 	xfs_ifunlock(ip);
@@ -1181,7 +1163,6 @@ xfs_reclaim_inode(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out:
 	xfs_iflags_clear(ip, XFS_IRECLAIM);
-	return false;
 }
 
 /*
@@ -1194,14 +1175,13 @@ xfs_reclaim_inode(
  * so that callers that want to block until all dirty inodes are written back
  * and reclaimed can sanely loop.
  */
-static int
+static void
 xfs_reclaim_inodes_ag(
 	struct xfs_mount	*mp,
 	int			*nr_to_scan)
 {
 	struct xfs_perag	*pag;
 	xfs_agnumber_t		ag = 0;
-	int			skipped = 0;
 
 	while ((pag = xfs_perag_get_tag(mp, ag, XFS_ICI_RECLAIM_TAG))) {
 		unsigned long	first_index = 0;
@@ -1210,14 +1190,7 @@ xfs_reclaim_inodes_ag(
 
 		ag = pag->pag_agno + 1;
 
-		/*
-		 * If the cursor is not zero, we haven't scanned the whole AG
-		 * so we might have skipped inodes here.
-		 */
 		first_index = READ_ONCE(pag->pag_ici_reclaim_cursor);
-		if (first_index)
-			skipped++;
-
 		do {
 			struct xfs_inode *batch[XFS_LOOKUP_BATCH];
 			int	i;
@@ -1270,16 +1243,12 @@ xfs_reclaim_inodes_ag(
 			rcu_read_unlock();
 
 			for (i = 0; i < nr_found; i++) {
-				if (!batch[i])
-					continue;
-				if (!xfs_reclaim_inode(batch[i], pag))
-					skipped++;
+				if (batch[i])
+					xfs_reclaim_inode(batch[i], pag);
 			}
 
 			*nr_to_scan -= XFS_LOOKUP_BATCH;
-
 			cond_resched();
-
 		} while (nr_found && !done && *nr_to_scan > 0);
 
 		if (done)
@@ -1287,27 +1256,18 @@ xfs_reclaim_inodes_ag(
 		WRITE_ONCE(pag->pag_ici_reclaim_cursor, first_index);
 		xfs_perag_put(pag);
 	}
-	return skipped;
 }
 
-int
+void
 xfs_reclaim_inodes(
-	xfs_mount_t	*mp,
-	int		mode)
+	struct xfs_mount	*mp)
 {
 	int		nr_to_scan = INT_MAX;
-	int		skipped;
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
-	if (!(mode & SYNC_WAIT))
-		return 0;
-
-	do {
+	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
-		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
-	} while (skipped > 0);
-
-	return 0;
+		xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	};
 }
 
 /*
@@ -1426,6 +1386,25 @@ xfs_inode_matches_eofb(
 	return true;
 }
 
+/*
+ * This is a fast pass over the inode cache to try to get reclaim moving on as
+ * many inodes as possible in a short period of time. It kicks itself every few
+ * seconds, as well as being kicked by the inode cache shrinker when memory
+ * goes low. It scans as quickly as possible avoiding locked inodes or those
+ * already being flushed, and once done schedules a future pass.
+ */
+void
+xfs_reclaim_worker(
+	struct work_struct *work)
+{
+	struct xfs_mount *mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_reclaim_work);
+	int		nr_to_scan = INT_MAX;
+
+	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
+	xfs_reclaim_work_queue(mp);
+}
+
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 93b54e7d55f0..ae92ca53de42 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -51,7 +51,7 @@ void xfs_inode_free(struct xfs_inode *ip);
 
 void xfs_reclaim_worker(struct work_struct *work);
 
-int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
+void xfs_reclaim_inodes(struct xfs_mount *mp);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 03158b42a194..c8ae49a1e99c 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1011,7 +1011,7 @@ xfs_mountfs(
 	 * quota inodes.
 	 */
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
  out_log_dealloc:
 	mp->m_flags |= XFS_MOUNT_UNMOUNTING;
@@ -1088,13 +1088,12 @@ xfs_unmountfs(
 	xfs_ail_push_all_sync(mp->m_ail);
 
 	/*
-	 * And reclaim all inodes.  At this point there should be no dirty
-	 * inodes and none should be pinned or locked, but use synchronous
-	 * reclaim just to be sure. We can stop background inode reclaim
-	 * here as well if it is still running.
+	 * Reclaim all inodes. At this point there should be no dirty inodes and
+	 * none should be pinned or locked. Stop background inode reclaim here
+	 * if it is still running.
 	 */
 	cancel_delayed_work_sync(&mp->m_reclaim_work);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
+	xfs_reclaim_inodes(mp);
 	xfs_health_unmount(mp);
 
 	xfs_qm_unmount(mp);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 379cbff438bc..5a5d9453cf51 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -890,9 +890,6 @@ xfs_quiesce_attr(
 	/* force the log to unpin objects from the now complete transactions */
 	xfs_log_force(mp, XFS_LOG_SYNC);
 
-	/* reclaim inodes to do any IO before the freeze completes */
-	xfs_reclaim_inodes(mp, 0);
-	xfs_reclaim_inodes(mp, SYNC_WAIT);
 
 	/* Push the superblock and write an unmount record */
 	error = xfs_log_sbcount(mp);
