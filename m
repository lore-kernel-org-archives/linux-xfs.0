Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7GF2GV6212814 for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 10:02:16 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 24C5418D410E
	for <xfs@oss.sgi.com>; Tue, 16 Aug 2011 08:02:14 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id YLxXx0lnmZQXEYMn for <xfs@oss.sgi.com>;
	Tue, 16 Aug 2011 08:02:14 -0700 (PDT)
Date: Tue, 16 Aug 2011 16:02:08 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110816150208.GD4844@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
	<20110816140652.GC13391@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110816140652.GC13391@localhost>
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
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Johannes Weiner <jweiner@redhat.com>

On Tue, Aug 16, 2011 at 10:06:52PM +0800, Wu Fengguang wrote:
> Mel,
> 
> I tend to agree with the whole patchset except for this one.
> 
> The worry comes from the fact that there are always the very possible
> unevenly distribution of dirty pages throughout the LRU lists.

It is pages under writeback that determines if throttling is considered
not dirty pages. The distinction is important. I agree with you that if
it was dirty pages that throttling would be considered too regularly.

> This
> patch works on local information and may unnecessarily throttle page
> reclaim when running into small spans of dirty pages.
> 

It's also calling wait_iff_congested() not congestion_wait(). This
takes BDI congestion and zone congestion into account with this check.

       /*
         * If there is no congestion, or heavy congestion is not being
         * encountered in the current zone, yield if necessary instead
         * of sleeping on the congestion queue
         */
        if (atomic_read(&nr_bdi_congested[sync]) == 0 ||
                        !zone_is_reclaim_congested(zone)) {

So global information is being taken into account.

> One possible scheme of global throttling is to first tag the skipped
> page with PG_reclaim (as you already do). And to throttle page reclaim
> only when running into pages with both PG_dirty and PG_reclaim set,

It's PG_writeback that is looked at, not PG_dirty.

> which means we have cycled through the _whole_ LRU list (which is the
> global and adaptive feedback we want) and run into that dirty page for
> the second time.
> 

This potentially results in more scanning from kswapd before it starts
throttling which could consume a lot of CPU. If pages under writeback
are reaching the end of the LRU, it's already the case that kswapd is
scanning faster than pages can be cleaned. Even then, it only really
throttles if the zone or a BDI is congested.

Taking that into consideration, do you still think there is a big
advantage to having writeback pages take another lap around the LRU
that is justifies the expected increase in CPU usage?

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
