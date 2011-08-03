Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73DviFP156189 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 08:57:44 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 65FE91867ACF
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 06:57:43 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id NknHtGBf0A9sExgX for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 06:57:43 -0700 (PDT)
Date: Wed, 3 Aug 2011 14:57:39 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 7/8] mm: vmscan: Immediately reclaim end-of-LRU dirty
	pages when writeback completes
Message-ID: <20110803135739.GK19099@suse.de>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
	<1311265730-5324-8-git-send-email-mgorman@suse.de>
	<20110803112630.GE27199@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110803112630.GE27199@redhat.com>
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
To: Johannes Weiner <jweiner@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>

On Wed, Aug 03, 2011 at 01:26:30PM +0200, Johannes Weiner wrote:
> On Thu, Jul 21, 2011 at 05:28:49PM +0100, Mel Gorman wrote:
> > When direct reclaim encounters a dirty page, it gets recycled around
> > the LRU for another cycle. This patch marks the page PageReclaim
> > similar to deactivate_page() so that the page gets reclaimed almost
> > immediately after the page gets cleaned. This is to avoid reclaiming
> > clean pages that are younger than a dirty page encountered at the
> > end of the LRU that might have been something like a use-once page.
> > 
> > Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> Apart from the naming of the counter (I like nr_reclaim_preferred),
> 

At the moment it's NR_VMSCAN_IMMEDIATE and the name visible in
/proc/vmstat is nr_vmscan_immediate_reclaim

> Acked-by: Johannes Weiner <jweiner@redhat.com>

Thanks.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
