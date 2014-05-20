Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C1427F4E
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 09:59:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 36A89304043
	for <xfs@oss.sgi.com>; Tue, 20 May 2014 07:59:10 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id IMuY1kXS0oGP5GH8 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 May 2014 07:59:08 -0700 (PDT)
Subject: Re: [PATCH] mm/vmscan: Do not block forever at shrink_inactive_list().
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201405192340.FCD48964.OFQHOOJLVSFFMt@I-love.SAKURA.ne.jp>
	<20140520004449.GE18954@dastard>
	<20140519225915.3370328d.akpm@linux-foundation.org>
	<20140520063024.GH18954@dastard>
In-Reply-To: <20140520063024.GH18954@dastard>
Message-Id: <201405202358.ADF10119.SMOFOQLFtOVHJF@I-love.SAKURA.ne.jp>
Date: Tue, 20 May 2014 23:58:29 +0900
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, riel@redhat.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org, kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org, fengguang.wu@intel.com, kamezawa.hiroyu@jp.fujitsu.com

Today I discussed with Kosaki-san at LinuxCon Japan 2014 about this issue.
He does not like the idea of adding timeout to throttle loop. As Dave
posted a patch that fixes a bug in XFS delayed allocation, I updated
my patch accordingly.

Although the bug in XFS was fixed by Dave's patch, other kernel code
would have bugs which would fall into this infinite throttle loop.
But to keep the possibility of triggering OOM killer minimum, can we
agree with this updated patch (and in the future adding some warning
mechanism like /proc/sys/kernel/hung_task_timeout_secs for detecting
memory allocation stall)?

Dave, if you are OK with this updated patch, please let me know
commit ID of your patch.

Regards.
----------
>From 408e65d9025e8e24838e7bf6ac9066ba8a9391a6 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 20 May 2014 23:34:34 +0900
Subject: [PATCH] mm/vmscan: Do not throttle kswapd at shrink_inactive_list().

I can observe that commit 35cd7815 "vmscan: throttle direct reclaim when
too many pages are isolated already" causes RHEL7 environment to stall
with 0% CPU usage when a certain type of memory pressure is given.
This is because nobody can reclaim memory due to rules listed below.

  (a) XFS uses a kernel worker thread for delayed allocation
  (b) kswapd wakes up the kernel worker thread for delayed allocation
  (c) the kernel worker thread is throttled due to commit 35cd7815

This patch and commit XXXXXXXX "xfs: block allocation work needs to be
kswapd aware" will solve rule (c).

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 mm/vmscan.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 32c661d..5c6960e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1460,12 +1460,22 @@ shrink_inactive_list(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct zone *zone = lruvec_zone(lruvec);
 	struct zone_reclaim_stat *reclaim_stat = &lruvec->reclaim_stat;
 
-	while (unlikely(too_many_isolated(zone, file, sc))) {
-		congestion_wait(BLK_RW_ASYNC, HZ/10);
+	/*
+	 * Throttle only direct reclaimers. Allocations by kswapd (and
+	 * allocation workqueue on behalf of kswapd) should not be
+	 * throttled here; otherwise memory allocation will deadlock.
+	 */
+	if (!sc->hibernation_mode && !current_is_kswapd()) {
+		while (unlikely(too_many_isolated(zone, file, sc))) {
+			congestion_wait(BLK_RW_ASYNC, HZ/10);
 
-		/* We are about to die and free our memory. Return now. */
-		if (fatal_signal_pending(current))
-			return SWAP_CLUSTER_MAX;
+			/*
+			 * We are about to die and free our memory.
+			 * Return now.
+			 */
+			if (fatal_signal_pending(current))
+				return SWAP_CLUSTER_MAX;
+		}
 	}
 
 	lru_add_drain();
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
