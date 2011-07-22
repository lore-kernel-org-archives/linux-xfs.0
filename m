Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MDNPpo085818 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 08:23:25 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A85C21EECC66
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 06:23:24 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 1LZFhMtCCw6BXLqC for <xfs@oss.sgi.com>;
	Fri, 22 Jul 2011 06:23:24 -0700 (PDT)
Date: Fri, 22 Jul 2011 14:23:19 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
	pages when writeback completes
Message-ID: <20110722132319.GX5349@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-8-git-send-email-mgorman@suse.de>
	<1311339228.27400.34.camel@twins>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311339228.27400.34.camel@twins>
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
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Fri, Jul 22, 2011 at 02:53:48PM +0200, Peter Zijlstra wrote:
> On Thu, 2011-07-21 at 17:28 +0100, Mel Gorman wrote:
> > When direct reclaim encounters a dirty page, it gets recycled around
> > the LRU for another cycle. This patch marks the page PageReclaim
> > similar to deactivate_page() so that the page gets reclaimed almost
> > immediately after the page gets cleaned. This is to avoid reclaiming
> > clean pages that are younger than a dirty page encountered at the
> > end of the LRU that might have been something like a use-once page.
> > 
> 
> > @@ -834,7 +834,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  			 */
> >  			if (page_is_file_cache(page) &&
> >  					(!current_is_kswapd() || priority >= DEF_PRIORITY - 2)) {
> > -				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > +				/*
> > +				 * Immediately reclaim when written back.
> > +				 * Similar in principal to deactivate_page()
> > +				 * except we already have the page isolated
> > +				 * and know it's dirty
> > +				 */
> > +				inc_zone_page_state(page, NR_VMSCAN_INVALIDATE);
> > +				SetPageReclaim(page);
> > +
> 
> I find the invalidate name somewhat confusing. It makes me think we'll
> drop the page without writeback, like invalidatepage().

I wasn't that happy with it either to be honest but didn't think of a
better one at the time. nr_reclaim_deferred?

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
