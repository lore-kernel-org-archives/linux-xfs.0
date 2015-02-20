Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B9387F56
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 17:09:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BFE18AC002
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 15:09:22 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	mzYTz7eDH4UyJho4 for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 15:09:20 -0800 (PST)
Date: Sat, 21 Feb 2015 10:09:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150220230910.GG12722@dastard>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150218082502.GA4478@dhcp22.suse.cz>
	<20150218104859.GM12722@dastard>
	<20150218121602.GC4478@dhcp22.suse.cz>
	<20150219110124.GC15569@phnom.home.cmpxchg.org>
	<20150219122914.GH28427@dhcp22.suse.cz>
	<20150219214356.GW12722@dastard>
	<20150220124849.GH21248@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150220124849.GH21248@dhcp22.suse.cz>
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
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

On Fri, Feb 20, 2015 at 01:48:49PM +0100, Michal Hocko wrote:
> On Fri 20-02-15 08:43:56, Dave Chinner wrote:
> > On Thu, Feb 19, 2015 at 01:29:14PM +0100, Michal Hocko wrote:
> > > On Thu 19-02-15 06:01:24, Johannes Weiner wrote:
> > > [...]
> > > > Preferrably, we'd get rid of all nofail allocations and replace them
> > > > with preallocated reserves.  But this is not going to happen anytime
> > > > soon, so what other option do we have than resolving this on the OOM
> > > > killer side?
> > > 
> > > As I've mentioned in other email, we might give GFP_NOFAIL allocator
> > > access to memory reserves (by giving it __GFP_HIGH).
> > 
> > Won't work when you have thousands of concurrent transactions
> > running in XFS and they are all doing GFP_NOFAIL allocations.
> 
> Is there any bound on how many transactions can run at the same time?

Yes. As many reservations that can fit in the available log space.

The log can be sized up to 2GB, and for filesystems larger than 4TB
will default to 2GB. Log space reservations depend on the operation
being done - an inode timestamp update requires about 5kB of
reservation, and rename requires about 200kB. Hence we can easily
have thousands of active transactions, even in the worst case
log space reversation cases.

You're saying it would be insane to have hundreds or thousands of
threads doing GFP_NOFAIL allocations concurrently. Reality check:
XFS has been operating successfully under such workload conditions
in production systems for many years.

> > That's why I suggested the per-transaction reserve pool - we can use
> > that
> 
> I am still not sure what you mean by reserve pool (API wise). How
> does it differ from pre-allocating memory before the "may not fail
> context"? Could you elaborate on it, please?

It is preallocating memory: into a reserve pool associated with the
transaction, done as part of the transaction reservation mechanism
we already have in XFS. The allocator then uses that reserve pool
to allocate from if an allocation would otherwise fail.

There is no way we can preallocate specific objects before the
transaction - that's just insane, especially handling the unbound
demand paged object requirement. Hence the need for a "preallocated
reserve pool" that the allocator can dip into that covers the memory
we need to *allocate and can't reclaim* during the course of the
transaction.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
