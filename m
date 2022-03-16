Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84B5AC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 01:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242252AbiCPBHp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 21:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236125AbiCPBHo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 21:07:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5DD9FB87E
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 18:06:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 486B710E5545;
        Wed, 16 Mar 2022 12:06:28 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUI7P-005xf3-3k; Wed, 16 Mar 2022 12:06:27 +1100
Date:   Wed, 16 Mar 2022 12:06:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220316010627.GO3927073@dread.disaster.area>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62313814
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ThVJ9TQub90cD4A3kPMA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 01:49:43PM +0100, Jan Kara wrote:
> Hello,
> 
> I was tracking down a regression in dbench workload on XFS we have
> identified during our performance testing. These are results from one of
> our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
> disk):
> 
> 			       good		       bad
> Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
> Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
> Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
> Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
> Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
> Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
> Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*
> 
> Note that the numbers are actually times to complete workload, not
> traditional dbench throughput numbers so lower is better.

How does this work? Dbench is a fixed time workload - the only
variability from run to run is the time it takes to run the cleanup
phase. Is this some hacked around version of dbench?

> Eventually I have
> tracked down the problem to commit bad77c375e8d ("xfs: CIL checkpoint
> flushes caches unconditionally").  Before this commit we submit ~63k cache
> flush requests during the dbench run, after this commit we submit ~150k
> cache flush requests. And the additional cache flushes are coming from
> xlog_cil_push_work().

Yup, that was a known trade-off with this series of changes to the
REQ_FLUSH/REQ_FUA behaviour of the CIL - fsync heavy workloads could
see higher cache flush counts, and low concurrency rates would see
that as increased runtime because there isn't the journal write load
needed to compeltely mitigate the impact of more frequent cache
flushes.

The trade-off is, OTOH, that other workloads see 10-1000x lower cache
flush rates when streaming large CIL checkpoints through the log as
fast as it can issue sequential IO to the disk. e.g. a 32MB CIL
threshold (>256MB journal) with 32KB iclogbuf size (default) on an
async workload will write ~1000 iclogs to flush a 32MB CIL
checkpoint. Prior to this series, every one of those iclog writes
would be issued as REQ_FLUSH|REQ_FUA. After this patch series,
we do a REQ_FLUSH from xfs_flush_bdev_async(), the first iclog is
REQ_FUA, and the last iclog is REQ_FLUSH|REQ_FUA. IOW, we reduce
the number of FUA + cache flushes by 3 orders or magnitude for these
cases....

There's a heap more detail of the changes and the complexity in
the commit message for the commit two patches further along in
that series where these benefits are realised - see commit
eef983ffeae7 ("xfs: journal IO cache flush reductions") for more
details.

When doing this work, I didn't count cache flushes. What I looked at
was the number of log forces vs the number of sleeps waiting on log
forces vs log writes vs the number of stalls waiting for log writes.
These numbers showed improvements across the board, so any increase
in overhead from physical cache flushes was not reflected in the
throughput increases I was measuring at the "fsync drives log
forces" level.

> The reason as far as I understand it is that
> xlog_cil_push_work() never actually ends up writing the iclog (I can see
> this in the traces) because it is writing just very small amounts (my
> debugging shows xlog_cil_push_work() tends to add 300-1000 bytes to iclog,
> 4000 bytes is the largest number I've seen) and very frequent fsync(2)
> calls from dbench always end up forcing iclog before it gets filled. So the
> cache flushes issued by xlog_cil_push_work() are just pointless overhead
> for this workload AFAIU.

It's not quite that straight forward.

Keep in mind that the block layer is supposed to merge new flush
requests that occur while there is still a flush in progress. hence
the only time this async flush should cause extra flush requests to
physically occur unless you have storage that either ignores flush
requests (in which case we don't care because bio_submit() aborts
real quick) or is really, really fast and so cache flush requests
complete before we start hitting the block layer merge case or
slowing down other IO.  If storage is slow and there's any amoutn of
concurrency, then we're going to be waiting on merged flush requests
in the block layer if there's any amount of concurrency, so the
impact is fairly well bound there, too.

Hence cache flush latency is only going to impact on very
low concurrency workloads where any additional wait time directly
translates to reduced throughput. That's pretty much what your
numbers indicate, too.

> Is there a way we could help this? I had some idea like call
> xfs_flush_bdev_async() only once we find enough items while walking the
> cil->xc_cil list that we think iclog write is likely.

That might be possible, but I don't see that a list walk can
determine this effectively. I've been putting off trying to optimise
this stuff because the infrastructure needed to make decisions like
this efficiently is still backed up waiting on merge.

We need the xlog_write() rework merged, because this patch:

https://lore.kernel.org/linux-xfs/20220309052937.2696447-1-david@fromorbit.com/T/#mf335766c6c17dbf9c438ed30fa0b7e15d355a6be

provides the information we need to determine how many iclogs we are
likely to need to determine whether to make a sync or async flush.

The resultant rewrite of xlog_write() also gives us a callback for
the first iclog in any write to set state on that iclog appropriate
for the current context. That can easily be used to set the
XLOG_ICL_NEED_FLUSH flag if an async flush has not been completed.

> This should still
> submit it rather early to provide the latency advantage. Otherwise postpone
> the flush to the moment we know we are going to flush the iclog to save
> pointless flushes. But we would have to record whether the flush happened
> or not in the iclog and it would all get a bit hairy...

I think we can just set the NEED_FLUSH flag appropriately.

However, given all this, I'm wondering if the async cache flush was
really a case of premature optimisation. That is, we don't really
gain anything by reducing the flush latency of the first iclog write
wehn we are writing 100-1000 iclogs before the commit record, and it
can be harmful to some workloads by issuing more flushes than we
need to.

So perhaps the right thing to do is just get rid of it and always
mark the first iclog in a checkpoint as NEED_FLUSH....

> I'm definitely not
> an expert in XFS logging code so that's why I'm just writing here my
> current findings if people have some ideas.

Thanks for running the tests and doing some investigation, Jan. We
should be able to mitigate some of this impact, so let me run a
couple of experiments here and I'll get back to you.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
