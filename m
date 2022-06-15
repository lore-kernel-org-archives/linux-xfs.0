Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D47DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Jun 2022 22:04:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346840AbiFOWEY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 18:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242770AbiFOWEW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:04:22 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDD8E5638B
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:04:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E84015ECAB3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 08:04:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00768Q-85
        for linux-xfs@vger.kernel.org; Thu, 16 Jun 2022 08:04:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00FS1L-6o
        for linux-xfs@vger.kernel.org;
        Thu, 16 Jun 2022 08:04:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: bound maximum wait time for inodegc work
Date:   Thu, 16 Jun 2022 08:04:15 +1000
Message-Id: <20220615220416.3681870-2-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615220416.3681870-1-david@fromorbit.com>
References: <20220615220416.3681870-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62aa5764
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=MKQDRZKB9nwGUNYnySIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Currently inodegc work can sit queued on the per-cpu queue until
the workqueue is either flushed of the queue reaches a depth that
triggers work queuing (and later throttling). This means that we
could queue work that waits for a long time for some other event to
trigger flushing.

Hence instead of just queueing work at a specific depth, use a
delayed work that queues the work at a bound time. We can still
schedule the work immediately at a given depth, but we no long need
to worry about leaving a number of items on the list that won't get
processed until external events prevail.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 36 ++++++++++++++++++++++--------------
 fs/xfs/xfs_mount.h  |  2 +-
 fs/xfs/xfs_super.c  |  2 +-
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 374b3bafaeb0..46b30ecf498c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -442,7 +442,7 @@ xfs_inodegc_queue_all(
 	for_each_online_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		if (!llist_empty(&gc->list))
-			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
 	}
 }
 
@@ -1844,8 +1844,8 @@ void
 xfs_inodegc_worker(
 	struct work_struct	*work)
 {
-	struct xfs_inodegc	*gc = container_of(work, struct xfs_inodegc,
-							work);
+	struct xfs_inodegc	*gc = container_of(to_delayed_work(work),
+						struct xfs_inodegc, work);
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
@@ -2017,6 +2017,7 @@ xfs_inodegc_queue(
 	struct xfs_inodegc	*gc;
 	int			items;
 	unsigned int		shrinker_hits;
+	unsigned long		queue_delay = 1;
 
 	trace_xfs_inode_set_need_inactive(ip);
 	spin_lock(&ip->i_flags_lock);
@@ -2028,19 +2029,26 @@ xfs_inodegc_queue(
 	items = READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, items + 1);
 	shrinker_hits = READ_ONCE(gc->shrinker_hits);
-	put_cpu_ptr(gc);
 
-	if (!xfs_is_inodegc_enabled(mp))
+	/*
+	 * We queue the work while holding the current CPU so that the work
+	 * is scheduled to run on this CPU.
+	 */
+	if (!xfs_is_inodegc_enabled(mp)) {
+		put_cpu_ptr(gc);
 		return;
-
-	if (xfs_inodegc_want_queue_work(ip, items)) {
-		trace_xfs_inodegc_queue(mp, __return_address);
-		queue_work(mp->m_inodegc_wq, &gc->work);
 	}
 
+	if (xfs_inodegc_want_queue_work(ip, items))
+		queue_delay = 0;
+
+	trace_xfs_inodegc_queue(mp, __return_address);
+	mod_delayed_work(mp->m_inodegc_wq, &gc->work, queue_delay);
+	put_cpu_ptr(gc);
+
 	if (xfs_inodegc_want_flush_work(ip, items, shrinker_hits)) {
 		trace_xfs_inodegc_throttle(mp, __return_address);
-		flush_work(&gc->work);
+		flush_delayed_work(&gc->work);
 	}
 }
 
@@ -2057,7 +2065,7 @@ xfs_inodegc_cpu_dead(
 	unsigned int		count = 0;
 
 	dead_gc = per_cpu_ptr(mp->m_inodegc, dead_cpu);
-	cancel_work_sync(&dead_gc->work);
+	cancel_delayed_work_sync(&dead_gc->work);
 
 	if (llist_empty(&dead_gc->list))
 		return;
@@ -2076,12 +2084,12 @@ xfs_inodegc_cpu_dead(
 	llist_add_batch(first, last, &gc->list);
 	count += READ_ONCE(gc->items);
 	WRITE_ONCE(gc->items, count);
-	put_cpu_ptr(gc);
 
 	if (xfs_is_inodegc_enabled(mp)) {
 		trace_xfs_inodegc_queue(mp, __return_address);
-		queue_work(mp->m_inodegc_wq, &gc->work);
+		mod_delayed_work(mp->m_inodegc_wq, &gc->work, 0);
 	}
+	put_cpu_ptr(gc);
 }
 
 /*
@@ -2176,7 +2184,7 @@ xfs_inodegc_shrinker_scan(
 			unsigned int	h = READ_ONCE(gc->shrinker_hits);
 
 			WRITE_ONCE(gc->shrinker_hits, h + 1);
-			queue_work_on(cpu, mp->m_inodegc_wq, &gc->work);
+			mod_delayed_work_on(cpu, mp->m_inodegc_wq, &gc->work, 0);
 			no_items = false;
 		}
 	}
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index ba5d42abf66e..d2eaebd85abf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -61,7 +61,7 @@ struct xfs_error_cfg {
  */
 struct xfs_inodegc {
 	struct llist_head	list;
-	struct work_struct	work;
+	struct delayed_work	work;
 
 	/* approximate count of inodes in the list */
 	unsigned int		items;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 48a7239ed1b2..651ae75a7e23 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1075,7 +1075,7 @@ xfs_inodegc_init_percpu(
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
 		init_llist_head(&gc->list);
 		gc->items = 0;
-		INIT_WORK(&gc->work, xfs_inodegc_worker);
+		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
 	}
 	return 0;
 }
-- 
2.35.1

