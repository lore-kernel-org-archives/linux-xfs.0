Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44598 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725940AbfBHFhb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Feb 2019 00:37:31 -0500
Date: Thu, 7 Feb 2019 21:37:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] Revert
 "mm: don't reclaim inodes with many attached pages"
Message-Id: <20190207213727.a791db810341cec2c013ba93@linux-foundation.org>
In-Reply-To: <20190207102750.GA4570@quack2.suse.cz>
References: <20190130041707.27750-1-david@fromorbit.com>
        <20190130041707.27750-2-david@fromorbit.com>
        <25EAF93D-BC63-4409-AF21-F45B2DDF5D66@fb.com>
        <20190131013403.GI4205@dastard>
        <20190131091011.GP18811@dhcp22.suse.cz>
        <20190131185704.GA8755@castle.DHCP.thefacebook.com>
        <20190131221904.GL4205@dastard>
        <20190207102750.GA4570@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Chris Mason <clm@fb.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>

On Thu, 7 Feb 2019 11:27:50 +0100 Jan Kara <jack@suse.cz> wrote:

> On Fri 01-02-19 09:19:04, Dave Chinner wrote:
> > Maybe for memcgs, but that's exactly the oppose of what we want to
> > do for global caches (e.g. filesystem metadata caches). We need to
> > make sure that a single, heavily pressured cache doesn't evict small
> > caches that lower pressure but are equally important for
> > performance.
> > 
> > e.g. I've noticed recently a significant increase in RMW cycles in
> > XFS inode cache writeback during various benchmarks. It hasn't
> > affected performance because the machine has IO and CPU to burn, but
> > on slower machines and storage, it will have a major impact.
> 
> Just as a data point, our performance testing infrastructure has bisected
> down to the commits discussed in this thread as the cause of about 40%
> regression in XFS file delete performance in bonnie++ benchmark.
> 

Has anyone done significant testing with Rik's maybe-fix?



From: Rik van Riel <riel@surriel.com>
Subject: mm, slab, vmscan: accumulate gradual pressure on small slabs

There are a few issues with the way the number of slab objects to scan is
calculated in do_shrink_slab.  First, for zero-seek slabs, we could leave
the last object around forever.  That could result in pinning a dying
cgroup into memory, instead of reclaiming it.  The fix for that is
trivial.

Secondly, small slabs receive much more pressure, relative to their size,
than larger slabs, due to "rounding up" the minimum number of scanned
objects to batch_size.

We can keep the pressure on all slabs equal relative to their size by
accumulating the scan pressure on small slabs over time, resulting in
sometimes scanning an object, instead of always scanning several.

This results in lower system CPU use, and a lower major fault rate, as
actively used entries from smaller caches get reclaimed less aggressively,
and need to be reloaded/recreated less often.

[akpm@linux-foundation.org: whitespace fixes, per Roman]
[riel@surriel.com: couple of fixes]
  Link: http://lkml.kernel.org/r/20190129142831.6a373403@imladris.surriel.com
Link: http://lkml.kernel.org/r/20190128143535.7767c397@imladris.surriel.com
Fixes: 4b85afbdacd2 ("mm: zero-seek shrinkers")
Fixes: 172b06c32b94 ("mm: slowly shrink slabs with a relatively small number of objects")
Signed-off-by: Rik van Riel <riel@surriel.com>
Tested-by: Chris Mason <clm@fb.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jonathan Lemon <bsd@fb.com>
Cc: Jan Kara <jack@suse.cz>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/shrinker.h~mmslabvmscan-accumulate-gradual-pressure-on-small-slabs
+++ a/include/linux/shrinker.h
@@ -65,6 +65,7 @@ struct shrinker {
 
 	long batch;	/* reclaim batch size, 0 = default */
 	int seeks;	/* seeks to recreate an obj */
+	int small_scan;	/* accumulate pressure on slabs with few objects */
 	unsigned flags;
 
 	/* These are for internal use */
--- a/mm/vmscan.c~mmslabvmscan-accumulate-gradual-pressure-on-small-slabs
+++ a/mm/vmscan.c
@@ -488,18 +488,30 @@ static unsigned long do_shrink_slab(stru
 		 * them aggressively under memory pressure to keep
 		 * them from causing refetches in the IO caches.
 		 */
-		delta = freeable / 2;
+		delta = (freeable + 1) / 2;
 	}
 
 	/*
 	 * Make sure we apply some minimal pressure on default priority
-	 * even on small cgroups. Stale objects are not only consuming memory
+	 * even on small cgroups, by accumulating pressure across multiple
+	 * slab shrinker runs. Stale objects are not only consuming memory
 	 * by themselves, but can also hold a reference to a dying cgroup,
 	 * preventing it from being reclaimed. A dying cgroup with all
 	 * corresponding structures like per-cpu stats and kmem caches
 	 * can be really big, so it may lead to a significant waste of memory.
 	 */
-	delta = max_t(unsigned long long, delta, min(freeable, batch_size));
+	if (!delta && shrinker->seeks) {
+		unsigned long nr_considered;
+
+		shrinker->small_scan += freeable;
+		nr_considered = shrinker->small_scan >> priority;
+
+		delta = 4 * nr_considered;
+		do_div(delta, shrinker->seeks);
+
+		if (delta)
+			shrinker->small_scan -= nr_considered << priority;
+	}
 
 	total_scan += delta;
 	if (total_scan < 0) {
_
