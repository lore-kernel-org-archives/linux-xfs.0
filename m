Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 198BF7F4E
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 05:54:22 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB8368F8035
	for <xfs@oss.sgi.com>; Fri,  6 Mar 2015 03:54:18 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id 9YPcQYLMhF1RgRl3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Mar 2015 03:54:16 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20150223004521.GK12722@dastard>
	<20150228162943.GA17989@phnom.home.cmpxchg.org>
	<20150228164158.GE5404@thunk.org>
	<20150228221558.GA23028@phnom.home.cmpxchg.org>
	<201503012017.EAD00571.HOOJVOStMFLFQF@I-love.SAKURA.ne.jp>
In-Reply-To: <201503012017.EAD00571.HOOJVOStMFLFQF@I-love.SAKURA.ne.jp>
Message-Id: <201503062053.GIC34848.FOMFtOSOLFJHVQ@I-love.SAKURA.ne.jp>
Date: Fri, 6 Mar 2015 20:53:53 +0900
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
To: david@fromorbit.com
Cc: tytso@mit.edu, hannes@cmpxchg.org, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, fernando_b1@lab.ntt.co.jp, torvalds@linux-foundation.org

Tetsuo Handa wrote:
> If underestimating is tolerable, can we simply set different watermark
> levels for GFP_ATOMIC / GFP_NOIO / GFP_NOFS / GFP_KERNEL allocations?
> For example,
> 
>    GFP_KERNEL (or above) can fail if memory usage exceeds 95%
>    GFP_NOFS can fail if memory usage exceeds 97%
>    GFP_NOIO can fail if memory usage exceeds 98%
>    GFP_ATOMIC can fail if memory usage exceeds 99%
> 
> I think that below order-0 GFP_NOIO allocation enters into retry-forever loop
> when GFP_KERNEL (or above) allocation starts waiting for reclaim sounds
> strange. Use of same watermark is preventing kernel worker threads from
> processing workqueue. While it is legal to do blocking operation from
> workqueue, being blocked forever is an exclusive occupation for workqueue;
> other jobs in the workqueue get stuck.
> 

Below experimental patch which raises zone watermark works for me.

----------
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6d77432..92233e1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1710,6 +1710,7 @@ struct task_struct {
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
 	unsigned long	task_state_change;
 #endif
+	gfp_t gfp_mask;
 };
 
 /* Future-safe accessor for struct task_struct's cpus_allowed. */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 7abfa70..1a6b830 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1810,6 +1810,12 @@ static bool __zone_watermark_ok(struct zone *z, unsigned int order,
 		min -= min / 2;
 	if (alloc_flags & ALLOC_HARDER)
 		min -= min / 4;
+	if (min == mark) {
+		if (current->gfp_mask & __GFP_FS)
+			min <<= 1;
+		if (current->gfp_mask & __GFP_IO)
+			min <<= 1;
+	}
 #ifdef CONFIG_CMA
 	/* If allocation can't use CMA areas don't use free CMA pages */
 	if (!(alloc_flags & ALLOC_CMA))
@@ -2810,6 +2816,7 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 		.nodemask = nodemask,
 		.migratetype = gfpflags_to_migratetype(gfp_mask),
 	};
+	gfp_t orig_gfp_mask;
 
 	gfp_mask &= gfp_allowed_mask;
 
@@ -2831,6 +2838,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
 	if (IS_ENABLED(CONFIG_CMA) && ac.migratetype == MIGRATE_MOVABLE)
 		alloc_flags |= ALLOC_CMA;
 
+	orig_gfp_mask = current->gfp_mask;
+	current->gfp_mask = gfp_mask;
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
@@ -2873,6 +2882,7 @@ out:
 	if (unlikely(!page && read_mems_allowed_retry(cpuset_mems_cookie)))
 		goto retry_cpuset;
 
+	current->gfp_mask = orig_gfp_mask;
 	return page;
 }
 EXPORT_SYMBOL(__alloc_pages_nodemask);
----------

Thanks again to Jonathan Corbet for writing https://lwn.net/Articles/635354/ .
Is Dave Chinner's "reservations" suggestion conceptually doing the patch above?

Dave's suggestion is to ask each GFP_NOFS and GFP_NOIO users to estimate
how much amount of pages they need for their transaction like

	if (min == mark) {
		if (current->gfp_mask & __GFP_FS)
			min += atomic_read(&reservation_for_gfp_fs);
		if (current->gfp_mask & __GFP_IO)
			min += atomic_read(&reservation_for_gfp_io);
	}

than ask the administrator to specify a static amount like

	if (min == mark) {
		if (current->gfp_mask & __GFP_FS)
			min += sysctl_reservation_for_gfp_fs;
		if (current->gfp_mask & __GFP_IO)
			min += sysctl_reservation_for_gfp_io;
	}

?

The retry-forever loop will happen if underestimated, won't it?
Then, how to handle it when the OOM killer missed the target (due to
__GFP_FS) or the OOM killer cannot be invoked (due to !__GFP_FS)?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
