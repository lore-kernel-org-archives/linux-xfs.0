Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35254 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729354AbfHACSL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 22:18:11 -0400
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/24] mm: directed shrinker work deferral
Date: Thu,  1 Aug 2019 12:17:29 +1000
Message-Id: <20190801021752.4986-2-david@fromorbit.com>
In-Reply-To: <20190801021752.4986-1-david@fromorbit.com>
References: <20190801021752.4986-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Introduce a mechanism for ->count_objects() to indicate to the
shrinker infrastructure that the reclaim context will not allow
scanning work to be done and so the work it decides is necessary
needs to be deferred.

This simplifies the code by separating out the accounting of
deferred work from the actual doing of the work, and allows better
decisions to be made by the shrinekr control logic on what action it
can take.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/shrinker.h | 7 +++++++
 mm/vmscan.c              | 8 ++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 9443cafd1969..af78c475fc32 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -31,6 +31,13 @@ struct shrink_control {
 
 	/* current memcg being shrunk (for memcg aware shrinkers) */
 	struct mem_cgroup *memcg;
+
+	/*
+	 * set by ->count_objects if reclaim context prevents reclaim from
+	 * occurring. This allows the shrinker to immediately defer all the
+	 * work and not even attempt to scan the cache.
+	 */
+	bool will_defer;
 };
 
 #define SHRINK_STOP (~0UL)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 44df66a98f2a..ae3035fe94bc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -541,6 +541,13 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	trace_mm_shrink_slab_start(shrinker, shrinkctl, nr,
 				   freeable, delta, total_scan, priority);
 
+	/*
+	 * If the shrinker can't run (e.g. due to gfp_mask constraints), then
+	 * defer the work to a context that can scan the cache.
+	 */
+	if (shrinkctl->will_defer)
+		goto done;
+
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
 	 * pass to avoid too frequent shrinker calls, but if the slab has less
@@ -575,6 +582,7 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 		cond_resched();
 	}
 
+done:
 	if (next_deferred >= scanned)
 		next_deferred -= scanned;
 	else
-- 
2.22.0
