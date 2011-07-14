Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EBqR4c133166 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 06:52:27 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 150D7D000AA
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 04:52:25 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0f80vd9YzExIY2o1 for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2011 04:52:25 -0700 (PDT)
Date: Thu, 14 Jul 2011 21:52:21 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-ID: <20110714115220.GB21663@dastard>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-3-git-send-email-mgorman@suse.de>
	<20110713233743.GV23038@dastard> <20110714062947.GO7529@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714062947.GO7529@suse.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 14, 2011 at 07:29:47AM +0100, Mel Gorman wrote:
> On Thu, Jul 14, 2011 at 09:37:43AM +1000, Dave Chinner wrote:
> > On Wed, Jul 13, 2011 at 03:31:24PM +0100, Mel Gorman wrote:
> > > It is preferable that no dirty pages are dispatched for cleaning from
> > > the page reclaim path. At normal priorities, this patch prevents kswapd
> > > writing pages.
> > > 
> > > However, page reclaim does have a requirement that pages be freed
> > > in a particular zone. If it is failing to make sufficient progress
> > > (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> > > is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> > > considered to tbe the point where kswapd is getting into trouble
> > > reclaiming pages. If this priority is reached, kswapd will dispatch
> > > pages for writing.
> > > 
> > > Signed-off-by: Mel Gorman <mgorman@suse.de>
> > 
> > Seems reasonable, but btrfs still will ignore this writeback from
> > kswapd, and it doesn't fall over.
> 
> At least there are no reports of it falling over :)

However you want to spin it.

> > Given that data point, I'd like to
> > see the results when you stop kswapd from doing writeback altogether
> > as well.
> > 
> 
> The results for this test will be identical because the ftrace results
> show that kswapd is already writing 0 filesystem pages.

You mean these numbers:

Kswapd reclaim write file async I/O           4483       4286 0          1          0          0

Which shows that kswapd, under this workload has been improved to
the point that it doesn't need to do IO. Yes, you've addressed the
one problematic workload, but the numbers do not provide the answers
to the fundamental question that have been raised during
discussions. i.e. do we even need IO at all from reclaim?

> Where it makes a difference is when the system is under enough
> pressure that it is failing to reclaim any memory and is in danger
> of prematurely triggering the OOM killer. Andrea outlined some of
> the concerns before at http://lkml.org/lkml/2010/6/15/246

So put the system under more pressure such that with this patch
series memory reclaim still writes from kswapd. Can you even get it
to that stage, and if you can, does the system OOM more or less if
you don't do file IO from reclaim?

> > Can you try removing it altogether and seeing what that does to your
> > test results? i.e
> > 
> > 			if (page_is_file_cache(page)) {
> > 				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > 				goto keep_locked;
> > 			}
> 
> It won't do anything, it'll still be writing 0 filesystem-backed pages.
> 
> Because of the possibility for the OOM killer triggering prematurely due
> to the inability of kswapd to write pages, I'd prefer to separate such a
> change by at least one release so that if there is an increase in OOM
> reports, it'll be obvious what was the culprit.

I'm not asking for release quality patches or even when such fixes
would roll out.

What you've shown here is that memory reclaim can be more efficient
without issuing IO itself under medium memory pressure. Now the
question is whether it can do so under heavy, sustained, near OOM
memory pressure?

IOWs, what I want to see is whether the fundamental principle of
IO-less reclaim can be validated as workable or struck down.  This
patchset demonstrates that IO-less reclaim is superior for a
workload that produces medium levels of sustained IO-based memory
pressure, which leads to the conclusion that the approach has merit
and needs further investigation.

It's that next step that I'm asking you to test now. What form
potential changes take or when they are released is irrelevant to me
at this point, because we still haven't determined if the
fundamental concept is completely sound or not. If the concept is
sound I'm quite happy to wait until the implementation is fully
baked before it gets rolled out....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
