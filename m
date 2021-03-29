Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F28BC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 23:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C75FB61879
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 23:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbhC2XwE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 19:52:04 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:41489 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229441AbhC2Xvp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 19:51:45 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D61E8106A09;
        Tue, 30 Mar 2021 10:51:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lR1fa-008HSa-Lc; Tue, 30 Mar 2021 10:51:42 +1100
Date:   Tue, 30 Mar 2021 10:51:42 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <20210329235142.GR63242@dread.disaster.area>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
 <20210329022826.GO63242@dread.disaster.area>
 <YGIWqX4pmfsv9LPk@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGIWqX4pmfsv9LPk@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=ZmAiFlH-nWBhn4JOufMA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 02:04:25PM -0400, Brian Foster wrote:
> On Mon, Mar 29, 2021 at 01:28:26PM +1100, Dave Chinner wrote:
> > I'd say the first thing to fix is the ordering problem on the
> > completion queue. XFS needs more than just offset based ordering, it
> > needs ioend type based ordering, too. All the size updates should be
> > processed before the unwritten extent conversions, hence removing
> > the nesting of transactions....
> > 
> 
> Generally speaking this makes sense if we need to retain the
> preallocated size update transactions for some reason. One thing to note
> is that we'd be putting on-disk size updates ahead of other ioend
> completions on background writeback. I suspect that might not matter
> much for unwritten ioends since we'd just expose unwritten extents after
> a crash, but the effect on cow writeback completion is not as clear to
> me.

The old code (pre-queue+merge) completed completions in random order
(i.e. whatever the workqueue and scheduler resulted in) so I don't
think this is a concern.

My concern is that it is a fairly major change of behaviour for IO
completion, we know this is a performance sensitive path, and that
we shouldn't make sweeping architectural changes without having a
bunch of performance regression tests demonstrating that the change
does not have unexpected, adverse side effects.

Hence my suggestion that we first the deadlock first, then do the
investigation work to determine if removing the pre-IO transaction
reservation is a benefit or not. We often do the simple, low risk
bug fix first, then do the more extensive rework that may have
unexpected side effects so that we have a less risky backport
candidate for stable distros. I don't see this as any different
here.

> For one, it looks like a cow ioend can both require a transaction
> allocation for fork remap as well as have an append transaction already
> attached, so we'd probably have to tweak how individual ioends are
> processed as opposed to just ordering them differently. I also thought
> cow blocks don't necessarily have to cover shared (or even existing)
> blocks in the data fork due to preallocation, so we'd probably need to
> investigate things like whether this makes it possible to put an on-disk
> update ahead of a cow remap that lands somewhere in the range between
> the in-core inode size and the (smaller) on-disk inode size, and if so,
> whether that could result in problematic behavior.

These things all used to happen before we (recently) added all the
per-inode queuing and merging code to IO completion. So there's no
real evidence that there is a problem completing them in different
orders. If someone runs fsync, then they'll all get completed before
fsync returns, so AFAICT this is just unnecessary complication of a
relatively simple mechanism.

> I'm not sure this is
> worth the associated complexity if there's opportunity to remove the
> need for most of these transactions in the first place. Hm?

Please keep in mind I'm not saying "we can't remove this code" as
Christoph has implied. Last time this came up, like the "use
unwritten extents for delalloc", I asked for performance/benchmark
results that indicate that the change doesn't introduce excessive
overhead or unexpected regressions. Again, I'm asking for that work
to be done *before* we make a signficant change in behaviour because
that change in behaviour is not necessary to fix the bug.

> @@ -182,12 +185,10 @@ xfs_end_ioend(
>  		error = xfs_reflink_end_cow(ip, offset, size);
>  	else if (ioend->io_type == IOMAP_UNWRITTEN)
>  		error = xfs_iomap_write_unwritten(ip, offset, size, false);
> -	else
> -		ASSERT(!xfs_ioend_is_append(ioend) || ioend->io_private);
>  
>  done:
> -	if (ioend->io_private)
> -		error = xfs_setfilesize_ioend(ioend, error);
> +	if (ioend->io_flags & IOMAP_F_APPEND)
> +		error = xfs_setfilesize(ip, offset, size);
>  	iomap_finish_ioends(ioend, error);
>  	memalloc_nofs_restore(nofs_flag);
>  }
> @@ -221,16 +222,28 @@ xfs_end_io(
>  	struct iomap_ioend	*ioend;
>  	struct list_head	tmp;
>  	unsigned long		flags;
> +	xfs_off_t		maxendoff;
>  
>  	spin_lock_irqsave(&ip->i_ioend_lock, flags);
>  	list_replace_init(&ip->i_ioend_list, &tmp);
>  	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
>  
>  	iomap_sort_ioends(&tmp);
> +
> +	/* XXX: track max endoff manually? */
> +	ioend = list_last_entry(&tmp, struct iomap_ioend, io_list);
> +	if (((ioend->io_flags & IOMAP_F_SHARED) ||
> +	     (ioend->io_type != IOMAP_UNWRITTEN)) &&
> +	    xfs_ioend_is_append(ioend)) {
> +		ioend->io_flags |= IOMAP_F_APPEND;
> +		maxendoff = ioend->io_offset + ioend->io_size;
> +	}
> +
>  	while ((ioend = list_first_entry_or_null(&tmp, struct iomap_ioend,
>  			io_list))) {
>  		list_del_init(&ioend->io_list);
>  		iomap_ioend_try_merge(ioend, &tmp, xfs_ioend_merge_private);
> +		ASSERT(ioend->io_offset + ioend->io_size <= maxendoff);
>  		xfs_end_ioend(ioend);
>  	}
>  }

So now when I run a workload that is untarring a large tarball full
of small files, we have as many transaction reserve operations
runnning concurrently as there are IO completions queued.

Right now, we the single threaded writeback (bdi-flusher) runs
reservations serially, so we are introducing a large amount of
concurrency to reservations here. IOWs, instead of throttling active
reservations before we submit the IO we end up with attempted
reservations only being bounded by the number of kworkers the
completion workqueue can throw at the system.  Then we might have
tens of active filesystems doing the same thing, each with their own
set of workqueues and kworkers...

Yes, we can make "lots of IO to a single inode" have less overhead,
but we do not want to do that at the expense of bad behaviour when
we have "single IOs to lots of inodes". That's the concern I have
here, and that's going to take a fair amount of work to characterise
and measure the impact, especially on large machines with slow
disks...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
