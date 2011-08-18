Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7IE2FZn176985 for <xfs@oss.sgi.com>; Thu, 18 Aug 2011 09:02:15 -0500
Received: from mga14.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DC47753F062
	for <xfs@oss.sgi.com>; Thu, 18 Aug 2011 07:02:14 -0700 (PDT)
Received: from mga14.intel.com (mga14.intel.com [143.182.124.37]) by
	cuda.sgi.com with ESMTP id bdihfITEPQVqFJuv for
	<xfs@oss.sgi.com>; Thu, 18 Aug 2011 07:02:14 -0700 (PDT)
Date: Thu, 18 Aug 2011 22:02:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110818140208.GA21003@localhost>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
	<20110816140652.GC13391@localhost> <20110816150208.GD4844@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110816150208.GD4844@suse.de>
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
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <jweiner@redhat.com>

On Tue, Aug 16, 2011 at 11:02:08PM +0800, Mel Gorman wrote:
> On Tue, Aug 16, 2011 at 10:06:52PM +0800, Wu Fengguang wrote:
> > Mel,
> > 
> > I tend to agree with the whole patchset except for this one.
> > 
> > The worry comes from the fact that there are always the very possible
> > unevenly distribution of dirty pages throughout the LRU lists.
> 
> It is pages under writeback that determines if throttling is considered
> not dirty pages. The distinction is important. I agree with you that if
> it was dirty pages that throttling would be considered too regularly.

Ah right, sorry for the rushed conclusion!

btw, I guess the vmscan will now progress faster due to the reduced
->pageout() and implicitly blocks in get_request_wait() on congested
IO queue.

> > This
> > patch works on local information and may unnecessarily throttle page
> > reclaim when running into small spans of dirty pages.
> > 
> 
> It's also calling wait_iff_congested() not congestion_wait(). This
> takes BDI congestion and zone congestion into account with this check.
> 
>        /*
>          * If there is no congestion, or heavy congestion is not being
>          * encountered in the current zone, yield if necessary instead
>          * of sleeping on the congestion queue
>          */
>         if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
>                         !zone_is_reclaim_congested(zone)) {
> 
> So global information is being taken into account.

That's right.

> > One possible scheme of global throttling is to first tag the skipped
> > page with PG_reclaim (as you already do). And to throttle page reclaim
> > only when running into pages with both PG_dirty and PG_reclaim set,
> 
> It's PG_writeback that is looked at, not PG_dirty.
> 
> > which means we have cycled through the _whole_ LRU list (which is the
> > global and adaptive feedback we want) and run into that dirty page for
> > the second time.
> > 
> 
> This potentially results in more scanning from kswapd before it starts
> throttling which could consume a lot of CPU. If pages under writeback
> are reaching the end of the LRU, it's already the case that kswapd is
> scanning faster than pages can be cleaned. Even then, it only really
> throttles if the zone or a BDI is congested.

Yeah, the first round may already eat a lot of CPU power..

> Taking that into consideration, do you still think there is a big
> advantage to having writeback pages take another lap around the LRU
> that is justifies the expected increase in CPU usage?

Given that there are typically much fewer PG_writeback than PG_dirty
(except for btrfs which probably should be fixed), the current
throttle condition should be strong enough to avoid false positives.

I even start to worry on the opposite side -- it could be less
throttled than necessary when some LRU is full of dirty pages and
somehow the flusher failed to focus on those pages (hence there are no
enough PG_writeback to wait upon at all).

In this case it may help to do "wait on PG_dirty&PG_reclaim and/or
PG_writeback&PG_reclaim". But the most essential task is always to let
the flusher focus more on the pages, rather than the question of
to-sleep-or-not-to-sleep, which will either block the direct reclaim
tasks for arbitrary long time, or act even worse by busy burning the CPU
during the time.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
