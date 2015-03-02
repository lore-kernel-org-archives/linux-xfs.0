Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B5B627F60
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 14:22:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 43CD0AC002
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 12:22:49 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id t5XuaEQCIH7jgHDG (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 12:22:44 -0800 (PST)
Date: Mon, 2 Mar 2015 15:22:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150302202228.GA15089@phnom.home.cmpxchg.org>
References: <201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150223073235.GT4251@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Mon, Feb 23, 2015 at 06:32:35PM +1100, Dave Chinner wrote:
> On Sun, Feb 22, 2015 at 05:29:30PM -0800, Andrew Morton wrote:
> > When allocating pages the caller should drain its reserves in
> > preference to dipping into the regular freelist.  This guy has already
> > done his reclaim and shouldn't be penalised a second time.  I guess
> > Johannes's preallocation code should switch to doing this for the same
> > reason, plus the fact that snipping a page off
> > task_struct.prealloc_pages is super-fast and needs to be done sometime
> > anyway so why not do it by default.
> 
> That is at odds with the requirements of demand paging, which
> allocate for objects that are reclaimable within the course of the
> transaction. The reserve is there to ensure forward progress for
> allocations for objects that aren't freed until after the
> transaction completes, but if we drain it for reclaimable objects we
> then have nothing left in the reserve pool when we actually need it.
>
> We do not know ahead of time if the object we are allocating is
> going to modified and hence locked into the transaction. Hence we
> can't say "use the reserve for this *specific* allocation", and so
> the only guidance we can really give is "we will to allocate and
> *permanently consume* this much memory", and the reserve pool needs
> to cover that consumption to guarantee forwards progress.
> 
> Forwards progress for all other allocations is guaranteed because
> they are reclaimable objects - they either freed directly back to
> their source (slab, heap, page lists) or they are freed by shrinkers
> once they have been released from the transaction.
> 
> Hence we need allocations to come from the free list and trigger
> reclaim, regardless of the fact there is a reserve pool there. The
> reserve pool needs to be a last resort once there are no other
> avenues to allocate memory. i.e. it would be used to replace the OOM
> killer for GFP_NOFAIL allocations.

That won't work.  Clean cache can be temporarily unavailable and
off-LRU for several reasons - compaction, migration, pending page
promotion, other reclaimers.  How often are we trying before we dip
into the reserve pool?  As you have noticed, the OOM killer goes off
seemingly prematurely at times, and the reason for that is that we
simply don't KNOW the exact point when we ran out of reclaimable
memory.  We cannot take an atomic snapshot of all zones, of all nodes,
of all tasks running in order to determine this reliably, we have to
approximate it.  That's why OOM is defined as "we have scanned a great
many pages and couldn't free any of them."

So unless you tell us which allocations should come from previously
declared reserves, and which ones should rely on reclaim and may fail,
the reserves can deplete prematurely and we're back to square one.

> > And to make it much worse, how
> > many pages of which orders?  Bless its heart, slub will go and use
> > a 1-order page for allocations which should have been in 0-order
> > pages..

It can always fall back to the minimum order.

> The majority of allocations will be order-0, though if we know that
> they are going to be significant numbers of high order allocations,
> then it should be simple enough to tell the mm subsystem "need a
> reserve of 32 order-0, 4 order-1 and 1 order-3 allocations" and have
> memory compaction just do it's stuff. But, IMO, we should cross that
> bridge when somebody actually needs reservations to be that
> specific....

Compaction can be at an impasse for the same reasons mentioned above.
It can not just stop_machine() to guarantee it can assemble a higher
order page from a bunch of in-use order-0 cache pages.  If you need
higher-order allocations in a transaction, you have to pre-allocate.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
