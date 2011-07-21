Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6LGTYCJ035900 for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 11:29:34 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F23071E691E1
	for <xfs@oss.sgi.com>; Thu, 21 Jul 2011 09:29:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fpddoEkbhH3bZWZB for <xfs@oss.sgi.com>;
	Thu, 21 Jul 2011 09:29:33 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 6/8] mm: vmscan: Throttle reclaim if encountering too many
	dirty pages under writeback
Date: Thu, 21 Jul 2011 17:28:48 +0100
Message-Id: <1311265730-5324-7-git-send-email-mgorman@suse.de>
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux-MM <linux-mm@kvack.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Mel Gorman <mgorman@suse.de>

Workloads that are allocating frequently and writing files place a
large number of dirty pages on the LRU. With use-once logic, it is
possible for them to reach the end of the LRU quickly requiring the
reclaimer to scan more to find clean pages. Ordinarily, processes that
are dirtying memory will get throttled by dirty balancing but this
is a global heuristic and does not take into account that LRUs are
maintained on a per-zone basis. This can lead to a situation whereby
reclaim is scanning heavily, skipping over a large number of pages
under writeback and recycling them around the LRU consuming CPU.

This patch checks how many of the number of pages isolated from the
LRU were dirty. If a percentage of them are dirty, the process will be
throttled if a blocking device is congested or the zone being scanned
is marked congested. The percentage that must be dirty depends on
the priority. At default priority, all of them must be dirty. At
DEF_PRIORITY-1, 50% of them must be dirty, DEF_PRIORITY-2, 25%
etc. i.e.  as pressure increases the greater the likelihood the process
will get throttled to allow the flusher threads to make some progress.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 mm/vmscan.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index cf7b501..b0060f8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -720,7 +720,8 @@ static noinline_for_stack void free_page_list(struct list_head *free_pages)
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
 				      struct scan_control *sc,
-				      int priority)
+				      int priority,
+				      unsigned long *ret_nr_dirty)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -971,6 +972,7 @@ keep_lumpy:
 
 	list_splice(&ret_pages, page_list);
 	count_vm_events(PGACTIVATE, pgactivate);
+	*ret_nr_dirty += nr_dirty;
 	return nr_reclaimed;
 }
 
@@ -1420,6 +1422,7 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 	unsigned long nr_taken;
 	unsigned long nr_anon;
 	unsigned long nr_file;
+	unsigned long nr_dirty = 0;
 
 	while (unlikely(too_many_isolated(zone, file, sc))) {
 		congestion_wait(BLK_RW_ASYNC, HZ/10);
@@ -1468,12 +1471,14 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc, priority);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc,
+							priority, &nr_dirty);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
-		nr_reclaimed += shrink_page_list(&page_list, zone, sc, priority);
+		nr_reclaimed += shrink_page_list(&page_list, zone, sc,
+							priority, &nr_dirty);
 	}
 
 	local_irq_disable();
@@ -1483,6 +1488,16 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	putback_lru_pages(zone, sc, nr_anon, nr_file, &page_list);
 
+	/*
+	 * If we have encountered a high number of dirty pages then they
+	 * are reaching the end of the LRU too quickly and global limits are
+	 * not enough to throttle processes due to the page distribution
+	 * throughout zones. Scale the number of dirty pages that must be
+	 * dirty before being throttled to priority.
+	 */
+	if (nr_dirty && nr_dirty >= (nr_taken >> (DEF_PRIORITY-priority)))
+		wait_iff_congested(zone, BLK_RW_ASYNC, HZ/10);
+
 	trace_mm_vmscan_lru_shrink_inactive(zone->zone_pgdat->node_id,
 		zone_idx(zone),
 		nr_scanned, nr_reclaimed,
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
