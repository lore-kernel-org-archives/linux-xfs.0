Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6DEVWd5087188 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 09:31:33 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA4F5681E1
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 07:31:31 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id QALHUMZRTeOgbDDC for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 07:31:31 -0700 (PDT)
From: Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in direct
	reclaim
Date: Wed, 13 Jul 2011 15:31:23 +0100
Message-Id: <1310567487-15367-2-git-send-email-mgorman@suse.de>
In-Reply-To: <1310567487-15367-1-git-send-email-mgorman@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
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

From: Mel Gorman <mel@csn.ul.ie>

When kswapd is failing to keep zones above the min watermark, a process
will enter direct reclaim in the same manner kswapd does. If a dirty
page is encountered during the scan, this page is written to backing
storage using mapping->writepage.

This causes two problems. First, it can result in very deep call
stacks, particularly if the target storage or filesystem are complex.
Some filesystems ignore write requests from direct reclaim as a result.
The second is that a single-page flush is inefficient in terms of IO.
While there is an expectation that the elevator will merge requests,
this does not always happen. Quoting Christoph Hellwig;

	The elevator has a relatively small window it can operate on,
	and can never fix up a bad large scale writeback pattern.

This patch prevents direct reclaim writing back filesystem pages by
checking if current is kswapd. Anonymous pages are still written to
swap as there is not the equivalent of a flusher thread for anonymos
pages. If the dirty pages cannot be written back, they are placed
back on the LRU lists.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 include/linux/mmzone.h |    1 +
 mm/vmscan.c            |    9 +++++++++
 mm/vmstat.c            |    1 +
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9f7c3eb..b70a0c0 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -100,6 +100,7 @@ enum zone_stat_item {
 	NR_UNSTABLE_NFS,	/* NFS unstable pages */
 	NR_BOUNCE,
 	NR_VMSCAN_WRITE,
+	NR_VMSCAN_WRITE_SKIP,
 	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 4f49535..2d3e5b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		if (PageDirty(page)) {
 			nr_dirty++;
 
+			/*
+			 * Only kswapd can writeback filesystem pages to
+			 * avoid risk of stack overflow
+			 */
+			if (page_is_file_cache(page) && !current_is_kswapd()) {
+				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
+				goto keep_locked;
+			}
+
 			if (references == PAGEREF_RECLAIM_CLEAN)
 				goto keep_locked;
 			if (!may_enter_fs)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 20c18b7..fd109f3 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -702,6 +702,7 @@ const char * const vmstat_text[] = {
 	"nr_unstable",
 	"nr_bounce",
 	"nr_vmscan_write",
+	"nr_vmscan_write_skip",
 	"nr_writeback_temp",
 	"nr_isolated_anon",
 	"nr_isolated_file",
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
