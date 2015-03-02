Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CE0DF7F6A
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 10:05:55 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD1968F804C
	for <xfs@oss.sgi.com>; Mon,  2 Mar 2015 08:05:55 -0800 (PST)
Received: from gum.cmpxchg.org (gum.cmpxchg.org [85.214.110.215]) by
	cuda.sgi.com with ESMTP id kijeZL8P0IP3PkBw (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Mar 2015 08:05:50 -0800 (PST)
Date: Mon, 2 Mar 2015 11:05:37 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150302160537.GA23072@phnom.home.cmpxchg.org>
References: <20150210151934.GA11212@phnom.home.cmpxchg.org>
	<201502111123.ICD65197.FMLOHSQJFVOtFO@I-love.SAKURA.ne.jp>
	<201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150302151832.GE26334@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150302151832.GE26334@dhcp22.suse.cz>
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
To: Michal Hocko <mhocko@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Mon, Mar 02, 2015 at 04:18:32PM +0100, Michal Hocko wrote:
> On Mon 23-02-15 11:45:21, Dave Chinner wrote:
> [...]
> > A reserve memory pool is no different - every time a memory reserve
> > occurs, a watermark is lifted to accommodate it, and the transaction
> > is not allowed to proceed until the amount of free memory exceeds
> > that watermark. The memory allocation subsystem then only allows
> > *allocations* marked correctly to allocate pages from that the
> > reserve that watermark protects. e.g. only allocations using
> > __GFP_RESERVE are allowed to dip into the reserve pool.
> 
> The idea is sound. But I am pretty sure we will find many corner
> cases. E.g. what if the mere reservation attempt causes the system
> to go OOM and trigger the OOM killer? Sure that wouldn't be too much
> different from the OOM triggered during the allocation but there is one
> major difference. Reservations need to be estimated and I expect the
> estimation would be on the more conservative side and so the OOM might
> not happen without them.

The whole idea is that filesystems request the reserves while they can
still sleep for progress or fail the macro-operation with -ENOMEM.

And the estimate wouldn't just be on the conservative side, it would
have to be the worst-case scenario.  If we run out of reserves in an
allocation that can not fail that would be a bug that can lock up the
machine.  We can then fall back to the OOM killer in a last-ditch
effort to make forward progress, but as the victim tasks can get stuck
behind state/locks held by the allocation side, the machine might lock
up after all.

> > By using watermarks, freeing of memory will automatically top
> > up the reserve pool which means that we guarantee that reclaimable
> > memory allocated for demand paging during transacitons doesn't
> > deplete the reserve pool permanently.  As a result, when there is
> > plenty of free and/or reclaimable memory, the reserve pool
> > watermarks will have almost zero impact on performance and
> > behaviour.
> 
> Typical busy system won't be very far away from the high watermark
> so there would be a reclaim performed during increased watermaks
> (aka reservation) and that might lead to visible performance
> degradation. This might be acceptable but it also adds a certain level
> of unpredictability when performance characteristics might change
> suddenly.

There is usually a good deal of clean cache.  As Dave pointed out
before, clean cache can be considered re-allocatable from NOFS
contexts, and so we'd only have to maintain this invariant:

	min_wmark + private_reserves < free_pages + clean_cache

> > Further, because it's just accounting and behavioural thresholds,
> > this allows the mm subsystem to control how the reserve pool is
> > accounted internally. e.g. clean, reclaimable pages in the page
> > cache could serve as reserve pool pages as they can be immediately
> > reclaimed for allocation.
> 
> But they also can turn into hard/impossible to reclaim as well. Clean
> pages might get dirty and e.g. swap backed pages run out of their
> backing storage. So I guess we cannot count with those pages without
> reclaiming them first and hiding them into the reserve. Which is what
> you suggest below probably but I wasn't really sure...

Pages reserved for use by the page cleaning path can't be considered
dirtyable.  They have to be included in the dirty_balance_reserve.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
