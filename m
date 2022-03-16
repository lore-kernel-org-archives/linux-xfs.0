Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5705DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 23:38:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241984AbiCPXjq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Mar 2022 19:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242323AbiCPXjp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Mar 2022 19:39:45 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 50FF51A807
        for <linux-xfs@vger.kernel.org>; Wed, 16 Mar 2022 16:38:30 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 59CD0533478;
        Thu, 17 Mar 2022 10:38:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nUdDo-006KhS-9t; Thu, 17 Mar 2022 10:38:28 +1100
Date:   Thu, 17 Mar 2022 10:38:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Jan Kara <jack@suse.cz>
Cc:     linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: Regression in XFS for fsync heavy workload
Message-ID: <20220316233828.GU3927073@dread.disaster.area>
References: <20220315124943.wtgwrrkuthnwto7w@quack3.lan>
 <20220316010627.GO3927073@dread.disaster.area>
 <20220316095437.ogwo2fxfpddaerie@quack3.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220316095437.ogwo2fxfpddaerie@quack3.lan>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623274f5
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=NEAV23lmAAAA:8 a=7-415B0cAAAA:8
        a=wQElcegjfuxfE__KlWwA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 16, 2022 at 10:54:37AM +0100, Jan Kara wrote:
> On Wed 16-03-22 12:06:27, Dave Chinner wrote:
> > On Tue, Mar 15, 2022 at 01:49:43PM +0100, Jan Kara wrote:
> > > Hello,
> > > 
> > > I was tracking down a regression in dbench workload on XFS we have
> > > identified during our performance testing. These are results from one of
> > > our test machine (server with 64GB of RAM, 48 CPUs, SATA SSD for the test
> > > disk):
> > > 
> > > 			       good		       bad
> > > Amean     1        64.29 (   0.00%)       73.11 * -13.70%*
> > > Amean     2        84.71 (   0.00%)       98.05 * -15.75%*
> > > Amean     4       146.97 (   0.00%)      148.29 *  -0.90%*
> > > Amean     8       252.94 (   0.00%)      254.91 *  -0.78%*
> > > Amean     16      454.79 (   0.00%)      456.70 *  -0.42%*
> > > Amean     32      858.84 (   0.00%)      857.74 (   0.13%)
> > > Amean     64     1828.72 (   0.00%)     1865.99 *  -2.04%*
> > > 
> > > Note that the numbers are actually times to complete workload, not
> > > traditional dbench throughput numbers so lower is better.
> > 
> > How does this work? Dbench is a fixed time workload - the only
> > variability from run to run is the time it takes to run the cleanup
> > phase. Is this some hacked around version of dbench?
> 
> Yes, dbench is a fixed time workload but in fact there is the workload file
> that gets executed in a loop. We run a modified version of dbench
> (https://github.com/mcgrof/dbench) which also reports time spent by each
> execution of the workload file (--show-execute-time option), which has much
> better statistical properties than throughput reported by dbench normally
> (which is for example completely ignorant of metadata operations and that
> leads to big fluctuations in reported numbers especially for high client
> counts).

The high client count fluctuations are actually meaningful and very
enlightening if you know why the fluctations are occurring. :)

e.g. at 280-300 clients on a maximally sized XFS log we run out of
log reservation space and fall off the lockless fast path. At this
point throughput is determined by metadata IO throughput and
transaction reservation latency, not page cache write IO throughput.
IOWs, variations in performance directly reflect the latency impact
of full cycle metadata operations, not just journal fsync
throughput.

At 512 clients, the page cache footprint of dbench is about 10GB.
Hence somewhere around ~7-800 clients on a 16GB RAM machine the
workload  will no longer fit in the page cache, and so now memory
reclaim and page cache repopulation affects measured throughput.

So, yeah, I tend to run bandwidth measurement up to very high client
counts because it gives much more insight into full subsystem cycle
behaviour than just running the "does fsync scale" aspect that low
client count testing exercises....

> > When doing this work, I didn't count cache flushes. What I looked at
> > was the number of log forces vs the number of sleeps waiting on log
> > forces vs log writes vs the number of stalls waiting for log writes.
> > These numbers showed improvements across the board, so any increase
> > in overhead from physical cache flushes was not reflected in the
> > throughput increases I was measuring at the "fsync drives log
> > forces" level.
> 
> Thanks for detailed explanation! I'd just note that e.g. for a machine with
> 8 CPUs, 32 GB of Ram and Intel SSD behind a megaraid_sas controller (it is
> some Dell PowerEdge server) we see even larger regressions like:
> 
>                     good                      bad
> Amean 	1	97.93	( 0.00%)	135.67	( -38.54%)
> Amean 	2	147.69	( 0.00%)	194.82	( -31.91%)
> Amean 	4	242.82	( 0.00%)	352.98	( -45.36%)
> Amean 	8	375.36	( 0.00%)	591.03	( -57.45%)
> 
> I didn't investigate on this machine (it was doing some other tests and I
> had another machine in my hands which also showed some, although smaller,
> regression) but now reading your explanations I'm curious why the
> regression grows with number of threads on that machine. Maybe the culprit
> is different there or just the dynamics isn't as we imagine it on that
> storage controller... I guess I'll borrow the machine and check it.

That sounds more like a poor caching implementation in the hardware
RAID controller than anything else.

> > > The reason as far as I understand it is that
> > > xlog_cil_push_work() never actually ends up writing the iclog (I can see
> > > this in the traces) because it is writing just very small amounts (my
> > > debugging shows xlog_cil_push_work() tends to add 300-1000 bytes to iclog,
> > > 4000 bytes is the largest number I've seen) and very frequent fsync(2)
> > > calls from dbench always end up forcing iclog before it gets filled. So the
> > > cache flushes issued by xlog_cil_push_work() are just pointless overhead
> > > for this workload AFAIU.
> > 
> > It's not quite that straight forward.
> > 
> > Keep in mind that the block layer is supposed to merge new flush
> > requests that occur while there is still a flush in progress. hence
> > the only time this async flush should cause extra flush requests to
> > physically occur unless you have storage that either ignores flush
> > requests (in which case we don't care because bio_submit() aborts
> > real quick) or is really, really fast and so cache flush requests
> > complete before we start hitting the block layer merge case or
> > slowing down other IO.  If storage is slow and there's any amoutn of
> > concurrency, then we're going to be waiting on merged flush requests
> > in the block layer if there's any amount of concurrency, so the
> > impact is fairly well bound there, too.
> >
> > Hence cache flush latency is only going to impact on very
> > low concurrency workloads where any additional wait time directly
> > translates to reduced throughput. That's pretty much what your
> > numbers indicate, too.
> 
> Yes, for higher thread counts I agree flush merging should mitigate the
> impact. But note that there is still some overhead of additional flushes
> because the block layer will merge only with flushes that are queued and
> not yet issued to the device. If there is flush in progress, new flush will
> be queued and will get submitted once the first one completes. It is only
> the third flush that gets merged to the second one.

Yup, and in this workload we'll generally have 4 concurrent CIL push
works being run, so we're over that threshold most of the time on
heavy concurrent fsync workloads.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
