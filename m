Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7BKcBRZ004499 for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 15:38:12 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 393491367AFD
	for <xfs@oss.sgi.com>; Thu, 11 Aug 2011 13:39:45 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id ojdadm0HbP4LiPsa for <xfs@oss.sgi.com>;
	Thu, 11 Aug 2011 13:39:45 -0700 (PDT)
Date: Thu, 11 Aug 2011 21:38:05 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 5/7] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-ID: <20110811203805.GC4844@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-6-git-send-email-mgorman@suse.de>
	<4E441D0E.6020602@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E441D0E.6020602@redhat.com>
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
To: Rik van Riel <riel@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Aug 11, 2011 at 02:18:54PM -0400, Rik van Riel wrote:
> On 08/10/2011 06:47 AM, Mel Gorman wrote:
> >It is preferable that no dirty pages are dispatched for cleaning from
> >the page reclaim path. At normal priorities, this patch prevents kswapd
> >writing pages.
> >
> >However, page reclaim does have a requirement that pages be freed
> >in a particular zone. If it is failing to make sufficient progress
> >(reclaiming<  SWAP_CLUSTER_MAX at any priority priority), the priority
> >is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> >considered to be the point where kswapd is getting into trouble
> >reclaiming pages. If this priority is reached, kswapd will dispatch
> >pages for writing.
> >
> >Signed-off-by: Mel Gorman<mgorman@suse.de>
> >Reviewed-by: Minchan Kim<minchan.kim@gmail.com>
> 
> My only worry with this patch is that maybe we'll burn too
> much CPU time freeing pages from a zone. 

The throttling patch prevents too much CPU being used if pages under
writeback are being encountered during scanning. That said, I shared
your concern and recorded kswapd CPU usage over time.

> However, chances
> are we'll have freed pages from other zones when scanning
> one zone multiple times (the page cache dirty limit is global,
> the clean pages have to be _somewhere_).
> 
> Since the bulk of the allocators are not too picky about
> which zone they get their pages from, I suspect this patch
> will be an overall improvement pretty much all the time.
> 

This is roughly similar to my own reasoning.

I uploaded all the kswapd CPU usage charts to
http://www.csn.ul.ie/~mel/postings/riel-20110811

These are smoothened as the raw figures are barely readable. If you
go through them, you'll see that kswapd CPU usage is sometimes higher
but generally within 2-3%.

> Acked-by: Rik van Riel <riel@redhat.com>

Thanks.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
