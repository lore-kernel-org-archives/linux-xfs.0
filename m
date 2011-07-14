Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6EFnMV6144730 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 10:49:22 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0E0DE17C9FC6
	for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 08:49:20 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id fNfIBHJjG9oiqDgz for <xfs@oss.sgi.com>;
	Thu, 14 Jul 2011 08:49:20 -0700 (PDT)
Date: Thu, 14 Jul 2011 16:49:15 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 5/5] mm: writeback: Prioritise dirty inodes encountered
	by direct reclaim for background flushing
Message-ID: <20110714154915.GV7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-6-git-send-email-mgorman@suse.de>
	<20110714150959.GA30936@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110714150959.GA30936@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 14, 2011 at 11:09:59AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 13, 2011 at 03:31:27PM +0100, Mel Gorman wrote:
> > It is preferable that no dirty pages are dispatched from the page
> > reclaim path. If reclaim is encountering dirty pages, it implies that
> > either reclaim is getting ahead of writeback or use-once logic has
> > prioritise pages for reclaiming that are young relative to when the
> > inode was dirtied.
> 
> what does this buy us? 

Very little. The vague intention was to avoid a situation where kswapds
priority was raised such that it had to write pages to clean a
particular zone.

> If at all we should prioritize by a zone,
> e.g. tell write_cache_pages only to bother with writing things out
> if the dirty page is in a given zone.   We'd probably still cluster
> around it to make sure we get good I/O patterns, but would only start
> I/O if it has a page we actually care about.
> 

That would make more sense. I've dropped this patch entirely.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
