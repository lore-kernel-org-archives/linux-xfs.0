Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6E09naP106600 for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 19:09:49 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D285F65528
	for <xfs@oss.sgi.com>; Wed, 13 Jul 2011 17:09:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	SWypIicgQmdl83Wo for <xfs@oss.sgi.com>;
	Wed, 13 Jul 2011 17:09:48 -0700 (PDT)
Date: Thu, 14 Jul 2011 10:09:44 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/5] mm: writeback: Prioritise dirty inodes encountered
	by direct reclaim for background flushing
Message-ID: <20110714000944.GY23038@dastard>
References: <1310567487-15367-1-git-send-email-mgorman@suse.de>
	<1310567487-15367-6-git-send-email-mgorman@suse.de>
	<20110713213947.GC21787@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110713213947.GC21787@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, XFS <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Linux-MM <linux-mm@kvack.org>, Mel Gorman <mgorman@suse.de>, Wu Fengguang <fengguang.wu@intel.com>, Johannes Weiner <jweiner@redhat.com>, Minchan Kim <minchan.kim@gmail.com>

On Wed, Jul 13, 2011 at 11:39:47PM +0200, Jan Kara wrote:
> On Wed 13-07-11 15:31:27, Mel Gorman wrote:
> > It is preferable that no dirty pages are dispatched from the page
> > reclaim path. If reclaim is encountering dirty pages, it implies that
> > either reclaim is getting ahead of writeback or use-once logic has
> > prioritise pages for reclaiming that are young relative to when the
> > inode was dirtied.
> > 
> > When dirty pages are encounted on the LRU, this patch marks the inodes
> > I_DIRTY_RECLAIM and wakes the background flusher. When the background
> > flusher runs, it moves such inodes immediately to the dispatch queue
> > regardless of inode age. There is no guarantee that pages reclaim
> > cares about will be cleaned first but the expectation is that the
> > flusher threads will clean the page quicker than if reclaim tried to
> > clean a single page.
>   Hmm, I was looking through your numbers but I didn't see any significant
> difference this patch would make. Do you?
> 
> I was thinking about the problem and actually doing IO from kswapd would be
> a small problem if we submitted more than just a single page. Just to give
> you idea - time to write a single page on plain SATA drive might be like 4
> ms. Time to write sequential 4 MB of data is like 80 ms (I just made up
> these numbers but the orders should be right).

I'm not so concerned about single drives - the numbers look far worse
when you have a high throughput filesystem. For arguments sake, lets
call that 1GB/s (even though I know of plenty of 10+GB/s XFS
filesystems out there). That gives you 4ms for a 4k IO, and 4MB of
data in 4ms seek + 4ms data transfer time, for 8ms total IO time.

> So to write 1000 times more
> data you just need like 20 times longer. That's a factor of 50 in IO
> efficiency.

In the case I tend to care about, it's more like factor of 1000 in
IO efficiency - 3 orders of magnitude or greater difference in
performance.

> So when reclaim/kswapd submits a single page IO once every
> couple of miliseconds, your IO throughput just went close to zero...
> BTW: I just checked your numbers in fsmark test with vanilla kernel.  You
> wrote like 14500 pages from reclaim in 567 seconds. That is about one page
> per 39 ms. That is going to have noticeable impact on IO throughput (not
> with XFS because it plays tricks with writing more than asked but with ext2
> or ext3 you would see it I guess).
> 
> So when kswapd sees high percentage of dirty pages at the end of LRU, it
> could call something like fdatawrite_range() for the range of 4 MB
> (provided the file is large enough) containing that page and IO thoughput
> would not be hit that much and you will get reasonably bounded time when
> the page gets cleaned... If you wanted to be clever, you could possibly be
> more sophisticated in picking the file and range to write so that you get
> rid of the most pages at the end of LRU but I'm not sure it's worth the CPU
> cycles. Does this sound reasonable to you?

That's what Wu's patch did - it pushed it off to the bdi-flusher
because you can't call iput() in memory reclaim context and you need
a reference to the inode before calling fdatawrite_range().

As I mentioned for that patch, writing 4MB instead of a single page
will cause different problems - after just 25 dirty pages, we've
queued 100MB of IO and on a typical desktop system that will take at
least a second to complete. Now we get the opposite problem of IO
latency to clean a specific page and the potential to stall normal
background expired inode writeback forever if we keep hitting dirty
pages during page reclaim.

It's just yet another reason I'd really like to see numbers showing
that not doing IO from memory reclaim causes problems in the cases
where it is said to be needed (like reclaiming memory from a
specific node) and that issuing IO is the -only- solution. If numbers
can't be produced showing that we *need* to do IO from memory
reclaim, then why jump through hoops like we currently are trying to
fix all the nasty corner cases?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
