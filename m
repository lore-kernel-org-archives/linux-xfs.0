Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7B18D7F54
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 18:04:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6909B304043
	for <xfs@oss.sgi.com>; Fri, 27 Feb 2015 16:04:08 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0iV6r04wcIdc2VDl for <xfs@oss.sgi.com>;
	Fri, 27 Feb 2015 16:04:02 -0800 (PST)
Date: Sat, 28 Feb 2015 11:03:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: How to handle TIF_MEMDIE stalls?
Message-ID: <20150228000359.GL4251@dastard>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
	<20150221235227.GA25079@phnom.home.cmpxchg.org>
	<20150223004521.GK12722@dastard>
	<20150222172930.6586516d.akpm@linux-foundation.org>
	<20150223073235.GT4251@dastard> <54F0B662.8020508@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <54F0B662.8020508@suse.cz>
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
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Johannes Weiner <hannes@cmpxchg.org>, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, dchinner@redhat.com, rientjes@google.com, Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org

On Fri, Feb 27, 2015 at 07:24:34PM +0100, Vlastimil Babka wrote:
> On 02/23/2015 08:32 AM, Dave Chinner wrote:
> >> > And then there will be an unknown number of
> >> > slab allocations of unknown size with unknown slabs-per-page rules
> >> > - how many pages needed for them?
> > However many pages needed to allocate the number of objects we'll
> > consume from the slab.
> 
> I think the best way is if slab could also learn to provide reserves for
> individual objects. Either just mark internally how many of them are reserved,
> if sufficient number is free, or translate this to the page allocator reserves,
> as slab knows which order it uses for the given objects.

Which is effectively what a slab based mempool is. Mempools don't
guarantee a reserve is available once it's been resized, however,
and we'd have to have mempools configured for every type of
allocation we are going to do. So from that perspective it's not
really a solution.

Further, the kmalloc heap is backed by slab caches. We do *lots* of
variable sized kmalloc allocations in transactions the size of which
aren't known until allocation time.  In that case, we have to assume
it's going to be a page per object, because the allocations could
actually be that size.

AFAICT, the worst case is a slab-backing page allocation for
every slab object that is allocated, so we may as well cater for
that case from the start...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
