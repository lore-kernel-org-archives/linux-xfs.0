Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QBL1sc125545 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 06:21:02 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6E5D81D8E871
	for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 04:20:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	9j5tILqFFRNRKCy0 for <xfs@oss.sgi.com>;
	Tue, 26 Jul 2011 04:20:59 -0700 (PDT)
Date: Tue, 26 Jul 2011 21:20:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/8] Reduce filesystem writeback from page reclaim v2
Message-ID: <20110726112055.GC8048@dastard>
References: <1311265730-5324-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1311265730-5324-1-git-send-email-mgorman@suse.de>
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

On Thu, Jul 21, 2011 at 05:28:42PM +0100, Mel Gorman wrote:
> Warning: Long post with lots of figures. If you normally drink coffee
> and you don't have a cup, get one or you may end up with a case of
> keyboard face.

[snip]

> Overall, having kswapd avoiding writes does improve performance
> which is not a surprise. Dave asked "do we even need IO at all from
> reclaim?". On NUMA machines, the answer is "yes" unless the VM can
> wake the flusher thread to clean a specific node.

Great answer, Mel. ;)

> When kswapd never
> writes, processes can stall for significant periods of time waiting on
> flushers to clean the correct pages. If all writing is to be deferred
> to flushers, it must ensure that many writes on one node would not
> starve requests for cleaning pages on another node.

Ok, so that's a direction we need to work towards, then.

> I'm currently of the opinion that we should consider merging patches
> 1-7 and discuss what is required before merging. It can be tackled
> later how the flushers can prioritise writing of pages belonging to
> a particular zone before disabling all writes from reclaim.

Sounds reasonable to me.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
