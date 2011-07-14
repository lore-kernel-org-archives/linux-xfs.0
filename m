Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E6JJUt120520 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 01:19:20 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C1F4EBD65F
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:19:18 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id swuLhqW3mHSHWGgD for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 23:19:18 -0700 (PDT)
Date: Thu, 14 Jul 2011 07:19:15 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 1/5] mm: vmscan: Do not writeback filesystem pages in
	direct reclaim
Message-ID: <20110714061915.GN7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-2-git-send-email-mgorman@suse.de>
	<20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714103801.83e10fdb.kamezawa.hiroyu@jp.fujitsu.com>
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
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 14, 2011 at 10:38:01AM +0900, KAMEZAWA Hiroyuki wrote:
> > @@ -825,6 +825,15 @@ static unsigned long shrink_page_list(struct list_head *page_list,
> >  		if (PageDirty(page)) {
> >  			nr_dirty++;
> >  
> > +			/*
> > +			 * Only kswapd can writeback filesystem pages to
> > +			 * avoid risk of stack overflow
> > +			 */
> > +			if (page_is_file_cache(page) && !current_is_kswapd()) {
> > +				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> > +				goto keep_locked;
> > +			}
> > +
> 
> 
> This will cause tons of memcg OOM kill because we have no help of kswapd (now).
> 
> Could you make this
> 
> 	if (scanning_global_lru(sc) && page_is_file_cache(page) && !current_is_kswapd())
> ...
> 

I can, but as Christoph points out, the request is already being
ignored so how will it help?

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
