Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DCC0A7F47
	for <xfs@oss.sgi.com>; Wed,  4 Mar 2015 00:53:12 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 595C2AC003
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 22:53:09 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	yPQXoqJDVDMobPLn for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 22:53:05 -0800 (PST)
Date: Wed, 4 Mar 2015 17:52:42 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150304065242.GR18360@dastard>
References: <20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard>
	<20150302202228.GA15089@phnom.home.cmpxchg.org>
	<20150302231206.GK18360@dastard>
	<20150303025023.GA22453@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150303025023.GA22453@phnom.home.cmpxchg.org>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Mon, Mar 02, 2015 at 09:50:23PM -0500, Johannes Weiner wrote:
> On Tue, Mar 03, 2015 at 10:12:06AM +1100, Dave Chinner wrote:
> > On Mon, Mar 02, 2015 at 03:22:28PM -0500, Johannes Weiner wrote:
> > > On Mon, Feb 23, 2015 at 06:32:35PM +1100, Dave Chinner wrote:
> > > > On Sun, Feb 22, 2015 at 05:29:30PM -0800, Andrew Morton wrote:
> > > > > When allocating pages the caller should drain its reserves in
> > > > > preference to dipping into the regular freelist.  This guy has already
> > > > > done his reclaim and shouldn't be penalised a second time.  I guess
> > > > > Johannes's preallocation code should switch to doing this for the same
> > > > > reason, plus the fact that snipping a page off
> > > > > task_struct.prealloc_pages is super-fast and needs to be done sometime
> > > > > anyway so why not do it by default.
> > > > 
> > > > That is at odds with the requirements of demand paging, which
> > > > allocate for objects that are reclaimable within the course of the
> > > > transaction. The reserve is there to ensure forward progress for
> > > > allocations for objects that aren't freed until after the
> > > > transaction completes, but if we drain it for reclaimable objects we
> > > > then have nothing left in the reserve pool when we actually need it.
> > > >
> > > > We do not know ahead of time if the object we are allocating is
> > > > going to modified and hence locked into the transaction. Hence we
> > > > can't say "use the reserve for this *specific* allocation", and so
> > > > the only guidance we can really give is "we will to allocate and
> > > > *permanently consume* this much memory", and the reserve pool needs
> > > > to cover that consumption to guarantee forwards progress.
> > > > 
> > > > Forwards progress for all other allocations is guaranteed because
> > > > they are reclaimable objects - they either freed directly back to
> > > > their source (slab, heap, page lists) or they are freed by shrinkers
> > > > once they have been released from the transaction.
> > > > 
> > > > Hence we need allocations to come from the free list and trigger
> > > > reclaim, regardless of the fact there is a reserve pool there. The
> > > > reserve pool needs to be a last resort once there are no other
> > > > avenues to allocate memory. i.e. it would be used to replace the OOM
> > > > killer for GFP_NOFAIL allocations.
> > > 
> > > That won't work.
> > 
> > I don't see why not...
> > 
> > > Clean cache can be temporarily unavailable and
> > > off-LRU for several reasons - compaction, migration, pending page
> > > promotion, other reclaimers.  How often are we trying before we dip
> > > into the reserve pool?  As you have noticed, the OOM killer goes off
> > > seemingly prematurely at times, and the reason for that is that we
> > > simply don't KNOW the exact point when we ran out of reclaimable
> > > memory.
> > 
> > Sure, but that's irrelevant to the problem at hand. At some point,
> > the Mm subsystem is going to decide "we're at OOM" - it's *what
> > happens next* that matters.
> 
> It's not irrelevant at all.  That point is an arbitrary magic number
> that is a byproduct of many imlementation details and concurrency in
> the memory management layer.  It's completely fine to tie allocations
> which can fail to this point, but you can't reasonably calibrate your
> emergency reserves, which are supposed to guarantee progress, to such
> an unpredictable variable.
> 
> When you reserve based on the share of allocations that you know will
> be unreclaimable, you are assuming that all other allocations will be
> reclaimable, and that is simply flawed.  There is so much concurrency
> in the MM subsystem that you can't reasonably expect a single scanner
> instance to recover the majority of theoretically reclaimable memory.

On one hand you say "memory accounting is unreliable, so detecting
OOM is unreliable, and so we have an unreliable trigger point.

On the other hand you say "single scanner instance can't reclaim all
memory", again stating we have an unreliable trigger point.

On the gripping hand, that unreliable trigger point is what
kicks the OOM killer.

Yet you consider that point to be reliable enough to kick the OOM
killer, but too unreliable to trigger allocation from a reserve
pool?

Say what?

I suspect you've completely misunderstood what I've been suggesting.

By definition, we have the pages we reserved in the reserve pool,
and unless we've exhausted that reservation with permanent
allocations we should always be able to allocate from it. If the
pool got emptied by demand page allocations, then we back off and
retry reclaim until the reclaimable objects are released back into
the reserve pool. i.e. reclaim fills reserve pools first, then when
they are full pages can go back on free lists for normal
allocations.  This provides the mechanism for forwards progress, and
it's essentially the same mechanism that mempools use to guarantee
forwards progess. the only difference is that reserve pool refilling
comes through reclaim via shrinker invocation...

In reality, though, I don't really care how the mm subsystem
implements that pool as long as it handles the cases I've described
(e.g http://oss.sgi.com/archives/xfs/2015-03/msg00039.html). I don't
think we're making progress here, anyway, so unless you come up with
some other solution this thread is going to die here....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
