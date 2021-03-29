Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208ABC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 02:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA23D6192B
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 02:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbhC2C2z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Mar 2021 22:28:55 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52605 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230242AbhC2C2g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Mar 2021 22:28:36 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 8A9271042870;
        Mon, 29 Mar 2021 13:28:33 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lQhdi-007wbV-Du; Mon, 29 Mar 2021 13:28:26 +1100
Date:   Mon, 29 Mar 2021 13:28:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: xfs ioend batching log reservation deadlock
Message-ID: <20210329022826.GO63242@dread.disaster.area>
References: <YF4AOto30pC/0FYW@bfoster>
 <20210326173244.GY4090233@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326173244.GY4090233@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_x
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=8hYNQG3eBgVaOVE4AQUA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
        a=fCgQI5UlmZDRPDxm0A3o:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 26, 2021 at 10:32:44AM -0700, Darrick J. Wong wrote:
> On Fri, Mar 26, 2021 at 11:39:38AM -0400, Brian Foster wrote:
> > Hi all,
> > 
> > We have a report of a workload that deadlocks on log reservation via
> > iomap_ioend completion batching. To start, the fs format is somewhat
> > unique in that the log is on the smaller side (35MB) and the log stripe
> > unit is 256k, but this is actually a default mkfs for the underlying
> > storage. I don't have much more information wrt to the workload or
> > anything that contributes to the completion processing characteristics.
> > 
> > The overall scenario is that a workqueue task is executing in
> > xfs_end_io() and blocked on transaction reservation for an unwritten
> > extent conversion. Since this task began executing and pulled pending
> > items from ->i_ioend_list, the latter was repopulated with 90 ioends, 67
> > of which have append transactions. These append transactions account for
> > ~520k of log reservation each due to the log stripe unit. All together
> > this consumes nearly all of available log space, prevents allocation of
> > the aforementioned unwritten extent conversion transaction and thus
> > leaves the fs in a deadlocked state.
> > 
> > I can think of different ways we could probably optimize this problem
> > away. One example is to transfer the append transaction to the inode at
> > bio completion time such that we retain only one per pending batch of
> > ioends. The workqueue task would then pull this append transaction from
> > the inode along with the ioend list and transfer it back to the last
> > non-unwritten/shared ioend in the sorted list.
> > 
> > That said, I'm not totally convinced this addresses the fundamental
> > problem of acquiring transaction reservation from a context that
> > essentially already owns outstanding reservation vs. just making it hard
> > to reproduce. I'm wondering if/why we need the append transaction at
> > all. AFAICT it goes back to commit 281627df3eb5 ("xfs: log file size
> > updates at I/O completion time") in v3.4 which changed the completion
> > on-disk size update from being an unlogged update. If we continue to
> > send these potential append ioends to the workqueue for completion
> > processing, is there any reason we can't let the workqueue allocate the
> > transaction as it already does for unwritten conversion?
> 
> Frankly I've never understood what benefit we get from preallocating a
> transaction and letting it twist in the wind consuming log space while
> writeback pushes data to the disk.  It's perfectly fine to delay ioend
> processing while we wait for unwritten conversions and cow remapping to
> take effect, so what's the harm in a slight delay for this?

The difference was that file size updates used to be far, far more
common than unwritten extent updates for buffered IO. When this code
was written, we almost never did buffered writes into unwritten
regions, but we always do sequential writes that required a file
size update.

Given that this code was replacing an un-synchronised size update,
the performance impact of reserving transaction space in IO
completion was significant. There was also the problem of XFS using
global workqueues - the series that introduced the append
transaction also introduced per-mount IO completion workqueues and
so there were concerns about blowing out the number of completion
workers when we have thousands of pending completions all waiting on
log space.

There was a bunch of considerations that probably don't exist
anymore, plus a bunch of new ones, such as the fact that we now
queue and merge ioends to process in a single context rather than
just spraying ioends to worker threads to deal with. The old code
would have worked just fine - the unwritten extent conversion would
not have been blocking all those other IO completions...

Wait, hold on - we're putting both unwritten conversion and size
updates onto the same queue?

Ah, yes, that's exactly what we are doing. We've punted all the size
extension to the unwritten workqueue, regardless of whether it's
just a size update or not. And then the work processes them one at a
time after sorting them. We don't complete/free the append
transactions until we try to merge them one at a time as we walk the
ioend list on the inode. Hence we try to reserve more log space
while we still hold an unknown amount of log space on the queue we
are processin...

IOws, the completion queuing mixing unwritten extent conversion and
size updates is *nesting transactions*.  THat's the deadlock - we
can't take a new transaction reservation while holding another
transaction reservation in a state where it cannot make progress....

> What happens if you replace the call to xfs_setfilesize_ioend in
> xfs_end_ioend with xfs_setfilesize, and skip the transaction
> preallocation altogether?

I expect that the deadlock will go away at the expense of increased
log reservation contention in IO completion because this unbounds
the amount of transaction reservation concurrency that can occur in
buffered writeback. IOWs, this might just hammer the log really,
really hard and that's exactly what we don't want data IO completion
to do....

I'd say the first thing to fix is the ordering problem on the
completion queue. XFS needs more than just offset based ordering, it
needs ioend type based ordering, too. All the size updates should be
processed before the unwritten extent conversions, hence removing
the nesting of transactions....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
