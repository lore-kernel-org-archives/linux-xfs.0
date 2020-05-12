Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E6D6C54E90
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 486DE20714
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 09:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgELJ2T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 05:28:19 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:52050 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729178AbgELJ2T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 05:28:19 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D452010639A
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2020 19:28:15 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-0004H3-A0
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jYRCw-007kYR-0j
        for linux-xfs@vger.kernel.org; Tue, 12 May 2020 19:28:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: convert m_active_trans counter to per-cpu
Date:   Tue, 12 May 2020 19:28:08 +1000
Message-Id: <20200512092811.1846252-3-david@fromorbit.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9
In-Reply-To: <20200512092811.1846252-1-david@fromorbit.com>
References: <20200512092811.1846252-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=DQkj07otzc7_PMFSBPwA:9
        a=8MshfPfKmnwD3r4O:21 a=ea1rjcbdGSVUsQv9:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

It's a global atomic counter, and we are hitting it at a rate of
half a million transactions a second, so it's bouncing the counter
cacheline all over the place on large machines. Convert it to a
per-cpu counter.

And .... oh wow, that was unexpected!

Concurrent create, 50 million inodes, identical 16p/16GB virtual
machines on different physical hosts. Machine A has twice the CPU
cores per socket of machine B:

		unpatched	patched
machine A:	3m45s		2m27s
machine B:	4m13s		4m14s

Create rates:
		unpatched	patched
machine A:	246k+/-15k	384k+/-10k
machine B:	225k+/-13k	223k+/-11k

Concurrent rm of same 50 million inodes:

		unpatched	patched
machine A:	8m30s		3m09s
machine B:	5m02s		4m51s

The transaction rate on the fast machine went from about 250k/sec to
over 600k/sec, which indicates just how much of a bottleneck this
atomic counter was.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  2 +-
 fs/xfs/xfs_super.c | 12 +++++++++---
 fs/xfs/xfs_trans.c |  6 +++---
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 712b3e2583316..af3d8b71e9591 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -84,6 +84,7 @@ typedef struct xfs_mount {
 	 * extents or anything related to the rt device.
 	 */
 	struct percpu_counter	m_delalloc_blks;
+	struct percpu_counter	m_active_trans;	/* in progress xact counter */
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_rtname;	/* realtime device name */
@@ -164,7 +165,6 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
-	atomic_t		m_active_trans;	/* number trans frozen */
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_eofblocks_work; /* background eof blocks
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e80bd2c4c279e..bc4853525ce18 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -883,7 +883,7 @@ xfs_quiesce_attr(
 	int	error = 0;
 
 	/* wait for all modifications to complete */
-	while (atomic_read(&mp->m_active_trans) > 0)
+	while (percpu_counter_sum(&mp->m_active_trans) > 0)
 		delay(100);
 
 	/* force the log to unpin objects from the now complete transactions */
@@ -902,7 +902,7 @@ xfs_quiesce_attr(
 	 * Just warn here till VFS can correctly support
 	 * read-only remount without racing.
 	 */
-	WARN_ON(atomic_read(&mp->m_active_trans) != 0);
+	WARN_ON(percpu_counter_sum(&mp->m_active_trans) != 0);
 
 	xfs_log_quiesce(mp);
 }
@@ -1027,8 +1027,14 @@ xfs_init_percpu_counters(
 	if (error)
 		goto free_fdblocks;
 
+	error = percpu_counter_init(&mp->m_active_trans, 0, GFP_KERNEL);
+	if (error)
+		goto free_delalloc_blocks;
+
 	return 0;
 
+free_delalloc_blocks:
+	percpu_counter_destroy(&mp->m_delalloc_blks);
 free_fdblocks:
 	percpu_counter_destroy(&mp->m_fdblocks);
 free_ifree:
@@ -1057,6 +1063,7 @@ xfs_destroy_percpu_counters(
 	ASSERT(XFS_FORCED_SHUTDOWN(mp) ||
 	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
 	percpu_counter_destroy(&mp->m_delalloc_blks);
+	percpu_counter_destroy(&mp->m_active_trans);
 }
 
 static void
@@ -1792,7 +1799,6 @@ static int xfs_init_fs_context(
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
 	spin_lock_init(&mp->m_perag_lock);
 	mutex_init(&mp->m_growlock);
-	atomic_set(&mp->m_active_trans, 0);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
 	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 28b983ff8b113..636df5017782e 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -68,7 +68,7 @@ xfs_trans_free(
 	xfs_extent_busy_clear(tp->t_mountp, &tp->t_busy, false);
 
 	trace_xfs_trans_free(tp, _RET_IP_);
-	atomic_dec(&tp->t_mountp->m_active_trans);
+	percpu_counter_dec(&tp->t_mountp->m_active_trans);
 	if (!(tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
 		sb_end_intwrite(tp->t_mountp->m_super);
 	xfs_trans_free_dqinfo(tp);
@@ -126,7 +126,7 @@ xfs_trans_dup(
 
 	xfs_trans_dup_dqinfo(tp, ntp);
 
-	atomic_inc(&tp->t_mountp->m_active_trans);
+	percpu_counter_inc(&tp->t_mountp->m_active_trans);
 	return ntp;
 }
 
@@ -275,7 +275,7 @@ xfs_trans_alloc(
 	 */
 	WARN_ON(resp->tr_logres > 0 &&
 		mp->m_super->s_writers.frozen == SB_FREEZE_COMPLETE);
-	atomic_inc(&mp->m_active_trans);
+	percpu_counter_inc(&mp->m_active_trans);
 
 	tp->t_magic = XFS_TRANS_HEADER_MAGIC;
 	tp->t_flags = flags;
-- 
2.26.1.301.g55bc3eb7cb9

