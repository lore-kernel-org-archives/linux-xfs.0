Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AAlTSO181071 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 05:47:29 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 18EB61E7335B
	for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 03:47:28 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 2GxeKALuwN8ySkRA for <xfs@oss.sgi.com>;
	Wed, 10 Aug 2011 03:47:28 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in kswapd
	except in high priority
Date: Wed, 10 Aug 2011 11:47:18 +0100
Message-Id: <1312973240-32576-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1312973240-32576-1-git-send-email-mgorman@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
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

It is preferable that no dirty pages are dispatched for cleaning from
the page reclaim path. At normal priorities, this patch prevents kswapd
writing pages.

However, page reclaim does have a requirement that pages be freed
in a particular zone. If it is failing to make sufficient progress
(reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
considered to be the point where kswapd is getting into trouble
reclaiming pages. If this priority is reached, kswapd will dispatch
pages for writing.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 mm/vmscan.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7863f8e..6d7c696 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -710,7 +710,8 @@ static noinline_for_stack void free_page_list(struct list_head *free_pages)
  */
 static unsigned long shrink_page_list(struct list_head *page_list,
 				      struct zone *zone,
-				      struct scan_control *sc)
+				      struct scan_control *sc,
+				      int priority)
 {
 	LIST_HEAD(ret_pages);
 	LIST_HEAD(free_pages);
@@ -816,9 +817,11 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 
 			/*
 			 * Only kswapd can writeback filesystem pages to
-			 * avoid risk of stack overflow
+			 * avoid risk of stack overflow but do not writeback
+			 * unless under significant pressure.
 			 */
-			if (page_is_file_cache(page) && !current_is_kswapd()) {
+			if (page_is_file_cache(page) &&
+					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
 				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
 				goto keep_locked;
 			}
@@ -1454,12 +1457,12 @@ shrink_inactive_list(unsigned long nr_to_scan, struct zone *zone,
 
 	spin_unlock_irq(&zone->lru_lock);
 
-	nr_reclaimed = shrink_page_list(&page_list, zone, sc);
+	nr_reclaimed = shrink_page_list(&page_list, zone, sc, priority);
 
 	/* Check if we should syncronously wait for writeback */
 	if (should_reclaim_stall(nr_taken, nr_reclaimed, priority, sc)) {
 		set_reclaim_mode(priority, sc, true);
-		nr_reclaimed += shrink_page_list(&page_list, zone, sc);
+		nr_reclaimed += shrink_page_list(&page_list, zone, sc, priority);
 	}
 
 	local_irq_disable();
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
