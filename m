Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 241557FBB
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 06:58:51 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C36A5AC001
	for <xfs@oss.sgi.com>; Thu, 19 Feb 2015 04:58:47 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id AUQRwXnZXMTbn6Er (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Feb 2015 04:58:45 -0800 (PST)
Date: Thu, 19 Feb 2015 13:58:44 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150219125844.GI28427@dhcp22.suse.cz>
References: <20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150219122914.GH28427@dhcp22.suse.cz>
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
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Thu 19-02-15 13:29:14, Michal Hocko wrote:
[...]
> Something like the following.
__GFP_HIGH doesn't seem to be sufficient so we would need something
slightly else but the idea is still the same:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8d52ab18fe0d..2d224bbdf8e8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2599,6 +2599,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	enum migrate_mode migration_mode = MIGRATE_ASYNC;
 	bool deferred_compaction = false;
 	int contended_compaction = COMPACT_CONTENDED_NONE;
+	int oom = 0;
 
 	/*
 	 * In the slowpath, we sanity check order to avoid ever trying to
@@ -2635,6 +2636,15 @@ retry:
 	alloc_flags = gfp_to_alloc_flags(gfp_mask);
 
 	/*
+	 * __GFP_NOFAIL allocations cannot fail but yet the current context
+	 * might be blocking resources needed by the OOM victim to terminate.
+	 * Allow the caller to dive into memory reserves to succeed the
+	 * allocation and break out from a potential deadlock.
+	 */
+	if (oom > 10 && (gfp_mask & __GFP_NOFAIL))
+		alloc_flags |= ALLOC_NO_WATERMARKS;
+
+	/*
 	 * Find the true preferred zone if the allocation is unconstrained by
 	 * cpusets.
 	 */
@@ -2759,6 +2769,8 @@ retry:
 				goto got_pg;
 			if (!did_some_progress)
 				goto nopage;
+
+			oom++;
 		}
 		/* Wait for some write requests to complete then retry */
 		wait_iff_congested(ac->preferred_zone, BLK_RW_ASYNC, HZ/50);
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
