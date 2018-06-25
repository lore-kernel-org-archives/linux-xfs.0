Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:40895
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753199AbeFYWhi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Jun 2018 18:37:38 -0400
Date: Tue, 26 Jun 2018 08:37:34 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] [RFC] writeback: fix range_cyclic writeback vs
 writepages deadlock
Message-ID: <20180625223734.GA19934@dastard>
References: <20180622030941.25544-1-david@fromorbit.com>
 <984063CF-92B5-40CF-AFA6-96398D8692BF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <984063CF-92B5-40CF-AFA6-96398D8692BF@fb.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Chris Mason <clm@fb.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

On Fri, Jun 22, 2018 at 11:14:20AM -0400, Chris Mason wrote:
> On 21 Jun 2018, at 23:09, Dave Chinner wrote:
> 
> >From: Dave Chinner <dchinner@redhat.com>
> >
> >We've recently seen a workload on XFS filesystems with a repeatable
> >deadlock between background writeback and a multi-process
> >application doing concurrent writes and fsyncs to a small range of a
> >file.
> >
> >
> >The underlying cause of the problem here is that range_cyclic
> >writeback is processing pages in descending index order as we
> >hold higher index pages in a structure controlled from above
> >write_cache_pages(). The write_cache_pages() caller needs to
> >be able to submit these pages for IO before write_cache_pages
> >restarts writeback at mapping index 0 to avoid wcp inverting the
> >page lock/writeback wait order.
> >
> >generic_writepages() is not susceptible to this bug as it has no
> >private context held across write_cache_pages() - filesystems using
> >this infrastructure always submit pages in ->writepage immediately
> >and so there is no problem with range_cyclic going back to mapping
> >index 0.
> >
> >However:
> >	mpage_writepages() has a private bio context,
> >	exofs_writepages() has page_collect
> >	fuse_writepages() has fuse_fill_wb_data
> >	nfs_writepages() has nfs_pageio_descriptor
> >	xfs_vm_writepages() has xfs_writepage_ctx
> >
> >All of these ->writepages implementations can hold pages under
> >writeback in their private structures until write_cache_pages()
> >returns, and hence they are all susceptible to this deadlock.
> >
> >Also worth noting is that ext4 has it's own bastardised version of
> >write_cache_pages() and so it /may/ have an equivalent deadlock. I
> >looked at the code long enough to understand that it has a similar
> >retry loop for range_cyclic writeback reaching the end of the file
> >and then promptly ran away before my eyes bled too much.  I'll leave
> >it for the ext4 developers to determine if their code is actually
> >has this deadlock and how to fix it if it has.
> >
> >There's a few ways I can see avoid this deadlock. There's probably
> >more, but these are the first I've though of:
> >
> >1. get rid of range_cyclic altogether
> >
> >2. range_cyclic always stops at EOF, and we start again from
> >writeback index 0 on the next call into write_cache_pages()
> >
> >2a. wcp also returns EAGAIN to ->writepages implementations to
> >indicate range cyclic has hit EOF. write-pages implementations can
> >then flush the current context and call wpc again to continue. i.e.
> >lift the retry into the ->writepages implementation
> 
> Btrfs has a variation of 2a in our bastardized copy of
> write_cache_pages(), it has a call to flush the bios we've built up
> before doing operations that might deadlock, including waiting for
> writeback, locking pages etc:
> 
>                         if (wbc->sync_mode != WB_SYNC_NONE) {
>                                 if (PageWriteback(page))
>                                         flush_write_bio(epd);
>                                 wait_on_page_writeback(page);
>                         }

Yeah, that's essentially what I was thinking, but it's complicated
by the fact we don't know what the private data contains in wcp.
Seems like a reasonable thing to do if you have all the ducks in a
row.

> I don't see any problems with the solution you picked instead, but
> if we run into more complex variations of this we can just pass a
> callback and a flushing cookie to generic_writepages().
> 
> Open question on the perf benefits of staring IO early while we wait
> for writeback on page X or letting our bio build bigger.

It's async background writeback. IO latency doesn't matter - it's
likely to get throttled anyway - so really the optimisations should
focus around building the most well formed bios we can....

> Open question #2, at least for btrfs we're building a single fat bio
> by adding pages to it along the way.  This is a small variation on
> plugging...we could just pull the last bio off the plug stack and
> stuff the pages in.  Then we'd get all the deadlock prevent implicit
> in plugging for free.

The problem is that there's a lot of context around the bio that the
filesystem has to maintain as well, and we can't put that on the
plug list. I'd prefer that we don't make a simple one-way IO
aggregation mechanism (the plug list) much more complicated by
allowing tasks to use it as a per-task "almost but not quite
submitted bio" stack without a lot more thought about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
