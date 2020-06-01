Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CA0DC433E4
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E82C6206E2
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 21:42:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728450AbgFAVm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 17:42:58 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:55486 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728590AbgFAVm4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 17:42:56 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 3AE961A7DE2
        for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2020 07:42:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-0000XC-PM
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jfsCq-00HU6P-GK
        for linux-xfs@vger.kernel.org; Tue, 02 Jun 2020 07:42:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 22/30] xfs: remove SYNC_WAIT from xfs_reclaim_inodes()
Date:   Tue,  2 Jun 2020 07:42:43 +1000
Message-Id: <20200601214251.4167140-23-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200601214251.4167140-1-david@fromorbit.com>
References: <20200601214251.4167140-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=oUvfQH9j-zolZsU4VWYA:9
        a=DiKeHqHhRZ4A:10
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

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 48 ++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |  2 +-
 fs/xfs/xfs_mount.c  | 11 +++++------
 fs/xfs/xfs_super.c  |  3 ---
 4 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ebe55124d6cb8..a27470fc201ff 100644
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
@@ -1298,24 +1280,17 @@ xfs_reclaim_inodes_ag(
 	return skipped;
 }
 
-int
+void
 xfs_reclaim_inodes(
-	xfs_mount_t	*mp,
-	int		mode)
+	struct xfs_mount	*mp)
 {
 	int		nr_to_scan = INT_MAX;
 	int		skipped;
 
-	xfs_reclaim_inodes_ag(mp, &nr_to_scan);
-	if (!(mode & SYNC_WAIT))
-		return 0;
-
 	do {
 		xfs_ail_push_all_sync(mp->m_ail);
 		skipped = xfs_reclaim_inodes_ag(mp, &nr_to_scan);
 	} while (skipped > 0);
-
-	return 0;
 }
 
 /*
@@ -1434,6 +1409,25 @@ xfs_inode_matches_eofb(
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
index 93b54e7d55f0d..ae92ca53de423 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -51,7 +51,7 @@ void xfs_inode_free(struct xfs_inode *ip);
 
 void xfs_reclaim_worker(struct work_struct *work);
 
-int xfs_reclaim_inodes(struct xfs_mount *mp, int mode);
+void xfs_reclaim_inodes(struct xfs_mount *mp);
 int xfs_reclaim_inodes_count(struct xfs_mount *mp);
 long xfs_reclaim_inodes_nr(struct xfs_mount *mp, int nr_to_scan);
 
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 03158b42a1943..c8ae49a1e99c3 100644
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
index fa58cb07c8fdf..9b03ea43f4fe7 100644
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
-- 
2.26.2.761.g0e0b3e54be

