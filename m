Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5271kqv180558 for <xfs@oss.sgi.com>; Thu, 2 Jun 2011 02:01:46 -0500
Received: from ipmail06.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AB014963D3
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2011 00:01:43 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	5qMrbIUQZt5VvZmV for <xfs@oss.sgi.com>;
	Thu, 02 Jun 2011 00:01:43 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 04/12] vmscan: add customisable shrinker batch size
Date: Thu,  2 Jun 2011 17:00:59 +1000
Message-Id: <1306998067-27659-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1306998067-27659-1-git-send-email-david@fromorbit.com>
References: <1306998067-27659-1-git-send-email-david@fromorbit.com>
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
To: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

For shrinkers that have their own cond_resched* calls, having
shrink_slab break the work down into small batches is not
paticularly efficient. Add a custom batchsize field to the struct
shrinker so that shrinkers can use a larger batch size if they
desire.

A value of zero (uninitialised) means "use the default", so
behaviour is unchanged by this patch.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/mm.h |    1 +
 mm/vmscan.c        |   11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9670f71..9b9777a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1150,6 +1150,7 @@ struct shrink_control {
 struct shrinker {
 	int (*shrink)(struct shrinker *, struct shrink_control *sc);
 	int seeks;	/* seeks to recreate an obj */
+	long batch;	/* reclaim batch size, 0 = default */
 
 	/* These are for internal use */
 	struct list_head list;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3688f47..a17909f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -253,6 +253,8 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		int shrink_ret = 0;
 		long nr;
 		long new_nr;
+		long batch_size = shrinker->batch ? shrinker->batch
+						  : SHRINK_BATCH;
 
 		/*
 		 * copy the current shrinker scan count into a local variable
@@ -302,19 +304,18 @@ unsigned long shrink_slab(struct shrink_control *shrink,
 		trace_mm_shrink_slab_start(shrinker, shrink, nr, nr_pages_scanned,
 					lru_pages, max_pass, delta, total_scan);
 
-		while (total_scan >= SHRINK_BATCH) {
-			long this_scan = SHRINK_BATCH;
+		while (total_scan >= batch_size) {
 			int nr_before;
 
 			nr_before = do_shrinker_shrink(shrinker, shrink, 0);
 			shrink_ret = do_shrinker_shrink(shrinker, shrink,
-							this_scan);
+							batch_size);
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)
 				ret += nr_before - shrink_ret;
-			count_vm_events(SLABS_SCANNED, this_scan);
-			total_scan -= this_scan;
+			count_vm_events(SLABS_SCANNED, batch_size);
+			total_scan -= batch_size;
 
 			cond_resched();
 		}
-- 
1.7.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
