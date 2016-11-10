Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:57365 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756140AbcKJXC7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2016 18:02:59 -0500
Date: Fri, 11 Nov 2016 10:02:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] XFS buffer cache scalability improvements
Message-ID: <20161110230200.GI28922@dastard>
References: <1476821653-2595-1-git-send-email-dev@lynxeye.de>
 <20161018212116.GC23194@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20161018212116.GC23194@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Lucas Stach <dev@lynxeye.de>
Cc: linux-xfs@vger.kernel.org

Hi Lucas,

On Wed, Oct 19, 2016 at 08:21:16AM +1100, Dave Chinner wrote:
> On Tue, Oct 18, 2016 at 10:14:11PM +0200, Lucas Stach wrote:
> > The second patch is logical follow up. The rhashtable cache index is protected by
> > RCU and does not need any additional locking. By switching the buffer cache entries
> > over to RCU freeing the buffer cache can be operated in a completely lock-free
> > manner. This should help scalability in the long run.
> 
> Yup, that's another reason I'd considered rhashtables :P
> 
> However, this is where it gets hairy. The buffer lifecycle is
> intricate, subtle, and has a history of nasty bugs that just never
> seem to go away. This change will require a lot of verification
> work to ensure things like the LRU manipulations haven't been
> compromised by the removal of this lock...
.....
> It's a performance modification - any performance/profile numbers
> that show the improvement?

Here's why detailed performance measurement for changes like this
are important: RCU freeing and lockless lookups are not a win for
the XFS buffer cache.

I fixed the code to be RCU safe (use bp->b_lock, XFS_BSTATE_FREE and
memory barriers) and verified that it worked OK (no regressions over
a nightly xfstests cycle across all my test machines) so this
morning I've run performance tests against it. I've also modified
the rhashtable patch with all my review comments:

[dchinner: reduce minimum hash size to an acceptable size for large
	   filesystems with many AGs with no active use.]
[dchinner: remove stale rbtree asserts.]
[dchinner: use xfs_buf_map for compare function argument.]
[dchinner: make functions static.]
[dchinner: remove redundant comments.]

The results show that RCU freeing significantly slows down my fsmark
file creation benchmark (https://lkml.org/lkml/2016/3/31/1161) that
hammers the buffer cache - it is not uncommon for profiles to show
10-11% CPU usage in _xfs_buf_find() with the rbtree implementation.
These tests were run on 4.9-rc4+for-next:

			files/s		wall time	sys CPU
rbtree:		     220910+/-1.9e+04	4m21.639s	48m17.206s
rhashtable:	     227518+/-1.9e+04	4m22.179s	45m41.639s
With RCU freeing:    198181+/-3e+04	4m45.286s	51m36.842s

So we can see that rbtree->rhashtable reduces system time and
increases create a little but not significantly, and the overall
runtime is pretty much unchanged. However, adding RCU lookup/freeing
to the rhashtable shows a siginficant degradation - 10% decrease in
create rate, 50% increase in create rate stddev, and a 10% increase
in system time. Not good.

The reasons for this change is quite obvious from my monitoring:
there is significant change in memory usage footprint and memory
reclaim overhead. RCU freeing delays the freeing of the buffers,
which means the buffer cache shrinker is not actually freeing memory
when demand occurs.  Instead, freeing is delayed to the end of the
rcu grace period and hence does not releive pressure quickly. Hence
memory reclaim transfers that pressure to other caches, increasing
reclaim scanning work and allocation latency. The result is higher
reclaim CPU usage, a very different memory usage profile over the
course of the test and, ultimately, lower performance.

Further, because we normally cycle through buffers so fast, RCU
freeing means that we are no longer finding hot buffers in the slab
cache during allocation. The idea of the slab cache is that on
heavily cycled slabs the objects being allocated are the ones that
were just freed and so are still hot in the CPU caches. When we
switch to RCU freeing, this no longer happens because freeing only
ever happens in sparse, periodic batches. Hence we end up allocating
cache cold buffers and so end up with more cache misses when first
allocating new buffers.

IOWs, the loss of performance due to RCU freeing is not made up by
the anticipated reduction the overhead of uncontended locks on
lookup. This is mainly because there is no measurable lookup locking
overhead now that rhashtables are used. rbtree CPU profile:

   - 9.39%  _xfs_buf_find
        0.92% xfs_perag_get                                                                                                                                            ¿
      - 0.90% xfs_buf_trylock                                                                                                                                          ¿
           0.71% down_trylock

rhashtable:

   - 2.62% _xfs_buf_find
      - 1.12% xfs_perag_get
         + 0.58% radix_tree_lookup
      - 0.91% xfs_buf_trylock
           0.82% down_trylock

rhashtable+RCU:

   - 2.31% _xfs_buf_find
        0.91% xfs_perag_get
      - 0.83% xfs_buf_trylock
           0.75% down_trylock

So with the rhashtable change in place, we've already removed the
cause of the pag_buf_lock contention (the rbtree pointer chasing) so
there just isn't any overhead that using RCU can optimise away.
Hence there's no gains to amortise the efficiency losses using RCU
freeing introduces, and as a result using RCU is slower than
traditional locking techniques.

I'll keep testing the rhashtbale code - it look solid enough at this
point to consider it for the 4.10 cycle.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
