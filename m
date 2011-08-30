Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7UDnCrq138897 for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 08:49:13 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C31BC13AF65D
	for <xfs@oss.sgi.com>; Tue, 30 Aug 2011 06:52:31 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id N8rjMdCCpxz1WuIP for <xfs@oss.sgi.com>;
	Tue, 30 Aug 2011 06:52:31 -0700 (PDT)
Date: Tue, 30 Aug 2011 14:49:00 +0100
From: Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 6/7] mm: vmscan: Throttle reclaim if encountering too
	many dirty pages under writeback
Message-ID: <20110830134900.GC14369@suse.de>
References: <1312973240-32576-1-git-send-email-mgorman@suse.de>
	<1312973240-32576-7-git-send-email-mgorman@suse.de>
	<20110818165428.4f01a1b9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110818165428.4f01a1b9.akpm@linux-foundation.org>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Minchan Kim <minchan.kim@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>

On Thu, Aug 18, 2011 at 04:54:28PM -0700, Andrew Morton wrote:
> On Wed, 10 Aug 2011 11:47:19 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > The percentage that must be in writeback depends on the priority. At
> > default priority, all of them must be dirty. At DEF_PRIORITY-1, 50%
> > of them must be, DEF_PRIORITY-2, 25% etc. i.e. as pressure increases
> > the greater the likelihood the process will get throttled to allow
> > the flusher threads to make some progress.
> 
> It'd be nice if the code comment were to capture this piece of implicit
> arithmetic.  After all, it's a magic number and magic numbers should
> stick out like sore thumbs.
> 
> And.. how do we know that the chosen magic numbers were optimal?

Good question. The short answer "we don't know but it's not important
to get this particular decision perfect because the real throttling
should happen earlier".

Now the long answer;

For the value to be used, pages under writeback must be reaching the
end of the LRU. This implies that the rate of page consumption is
exceeding the writing speed of the backing storage. Regardless of
what decision is made, the rate of page allocation must be reduced
as the the system is already in a sub-optimal state of requiring more
resources than are available.

The values are based on a simple expontial backoff function with useful
ranges of DEF_PRIORITY to DEF_PRIORITY-2 which is the point where
"kswapd is getting into trouble". However, any decreasing function
within that range is sufficient because while there might be an optimal
choice, it makes little difference overall as the decision is made
too late with no guarantee the process doing the dirtying is throttled.

The truly optimal decision is to throttle writers to slow storage
earlier in balance_dirty_pages() and have dirty_ratio scaled
proportional to the estimate writeback speed of the underlying storage
but we do not have that yet. This patches throttling decision is
fairly close to the best we can do from reclaim context.

-- 
Mel Gorman
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
