Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E6Trdj120985 for <xfs@oss.sgi.com>; Thu, 14 Jul 2011 01:29:53 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3C4F01D85C15
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 23:29:51 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id dtYRZyrfpYtBOjnm for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 23:29:51 -0700 (PDT)
Date: Thu, 14 Jul 2011 07:29:47 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 2/5] mm: vmscan: Do not writeback filesystem pages in
	kswapd except in high priority
Message-ID: <20110714062947.GO7529@suse.de>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-3-git-send-email-mgorman@suse.de>
	<20110713233743.GV23038@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110713233743.GV23038@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Jul 14, 2011 at 09:37:43AM +1000, Dave Chinner wrote:
> On Wed, Jul 13, 2011 at 03:31:24PM +0100, Mel Gorman wrote:
> > It is preferable that no dirty pages are dispatched for cleaning from
> > the page reclaim path. At normal priorities, this patch prevents kswapd
> > writing pages.
> > 
> > However, page reclaim does have a requirement that pages be freed
> > in a particular zone. If it is failing to make sufficient progress
> > (reclaiming < SWAP_CLUSTER_MAX at any priority priority), the priority
> > is raised to scan more pages. A priority of DEF_PRIORITY - 3 is
> > considered to tbe the point where kswapd is getting into trouble
> > reclaiming pages. If this priority is reached, kswapd will dispatch
> > pages for writing.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Seems reasonable, but btrfs still will ignore this writeback from
> kswapd, and it doesn't fall over.

At least there are no reports of it falling over :)

> Given that data point, I'd like to
> see the results when you stop kswapd from doing writeback altogether
> as well.
> 

The results for this test will be identical because the ftrace results
show that kswapd is already writing 0 filesystem pages.

Where it makes a difference is when the system is under enough
pressure that it is failing to reclaim any memory and is in danger
of prematurely triggering the OOM killer. Andrea outlined some of
the concerns before at http://lkml.org/lkml/2010/6/15/246

> Can you try removing it altogether and seeing what that does to your
> test results? i.e
> 
> 			if (page_is_file_cache(page)) {
> 				inc_zone_page_state(page, NR_VMSCAN_WRITE_SKIP);
> 				goto keep_locked;
> 			}

It won't do anything, it'll still be writing 0 filesystem-backed pages.

Because of the possibility for the OOM killer triggering prematurely due
to the inability of kswapd to write pages, I'd prefer to separate such a
change by at least one release so that if there is an increase in OOM
reports, it'll be obvious what was the culprit.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
