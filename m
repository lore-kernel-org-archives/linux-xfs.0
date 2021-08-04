Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45FA3C4338F
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ABD960E96
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Aug 2021 11:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbhHDLwj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Aug 2021 07:52:39 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:55893 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237838AbhHDLwj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Aug 2021 07:52:39 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 28E821142114;
        Wed,  4 Aug 2021 21:52:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mBFRh-00EP6C-KT; Wed, 04 Aug 2021 21:52:25 +1000
Date:   Wed, 4 Aug 2021 21:52:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: [PATCH, post-03/20 1/1] xfs: hook up inodegc to CPU dead notification
Message-ID: <20210804115225.GP2757197@dread.disaster.area>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804032030.GT3601443@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8
        a=sGUq737XIWKEaOxEyHwA:9 a=CjuIK1q_8ugA:10
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


From: Dave Chinner <dchinner@redhat.com>

So we don't leave queued inodes on a CPU we won't ever flush.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_icache.h |  1 +
 fs/xfs/xfs_super.c  |  2 +-
 3 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index f772f2a67a8b..9e2c95903c68 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1966,6 +1966,42 @@ xfs_inodegc_start(
 	}
 }
 
+/*
+ * Fold the dead CPU inodegc queue into the current CPUs queue.
+ */
+void
+xfs_inodegc_cpu_dead(
+	struct xfs_mount	*mp,
+	int			dead_cpu)
+{
+	struct xfs_inodegc	*dead_gc, *gc;
+	struct llist_node	*first, *last;
+	int			count = 0;
+
+	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
+	cancel_work_sync(&dead_gc->work);
+
+	if (llist_empty(&dead_gc->list))
+		return;
+
+	first = dead_gc->list.first;
+	last = first;
+	while (last->next) {
+		last = last->next;
+		count++;
+	}
+	dead_gc->list.first = NULL;
+	dead_gc->items = 0;
+
+	/* Add pending work to current CPU */
+	gc = get_cpu_ptr(mp->m_inodegc);
+	llist_add_batch(first, last, &gc->list);
+	count += READ_ONCE(gc->items);
+	WRITE_ONCE(gc->items, count);
+	put_cpu_ptr(gc);
+	queue_work(mp->m_inodegc_wq, &gc->work);
+}
+
 #ifdef CONFIG_XFS_RT
 static inline bool
 xfs_inodegc_want_queue_rt_file(
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index bdf2a8d3fdd5..853d5bfc0cfb 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -79,5 +79,6 @@ void xfs_inodegc_worker(struct work_struct *work);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
+void xfs_inodegc_cpu_dead(struct xfs_mount *mp, int cpu);
 
 #endif
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index c251679e8514..f579ec49eb7a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2187,7 +2187,7 @@ xfs_cpu_dead(
 	spin_lock(&xfs_mount_list_lock);
 	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
 		spin_unlock(&xfs_mount_list_lock);
-		/* xfs_subsys_dead(mp, cpu); */
+		xfs_inodegc_cpu_dead(mp, cpu);
 		spin_lock(&xfs_mount_list_lock);
 	}
 	spin_unlock(&xfs_mount_list_lock);
