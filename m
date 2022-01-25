Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F468C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Jan 2022 22:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbiAYWpy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 17:45:54 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55763 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234048AbiAYWpx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 17:45:53 -0500
Received: from dread.disaster.area (pa49-179-45-11.pa.nsw.optusnet.com.au [49.179.45.11])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F313762C376;
        Wed, 26 Jan 2022 09:45:51 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nCUZT-004CwZ-9P; Wed, 26 Jan 2022 09:45:51 +1100
Date:   Wed, 26 Jan 2022 09:45:51 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, rcu@vger.kernel.org
Subject: Re: [PATCH] xfs: require an rcu grace period before inode recycle
Message-ID: <20220125224551.GQ59729@dread.disaster.area>
References: <20220121142454.1994916-1-bfoster@redhat.com>
 <Ye6/g+XMSyp9vYvY@bfoster>
 <20220124220853.GN59729@dread.disaster.area>
 <Ye82TgBY0VmtTjMc@bfoster>
 <20220125003120.GO59729@dread.disaster.area>
 <YfBBzHascwVnefYY@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfBBzHascwVnefYY@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f07da0
        a=Eslsx4mF8WGvnV49LKizaA==:117 a=Eslsx4mF8WGvnV49LKizaA==:17
        a=kj9zAlcOel0A:10 a=DghFqjY3_ZEA:10 a=7-415B0cAAAA:8
        a=9lO7_HsjPXyL1pFJ4ukA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 25, 2022 at 01:30:36PM -0500, Brian Foster wrote:
> On Tue, Jan 25, 2022 at 11:31:20AM +1100, Dave Chinner wrote:
> > On Mon, Jan 24, 2022 at 06:29:18PM -0500, Brian Foster wrote:
> > > On Tue, Jan 25, 2022 at 09:08:53AM +1100, Dave Chinner wrote:
> > > ... but could you elaborate on the scalability tests involved here so I
> > > can get a better sense of it in practice and perhaps observe the impact
> > > of changes in this path?
> > 
> > The same conconrrent fsmark create/traverse/unlink workloads I've
> > been running for the past decade+ demonstrates it pretty simply. I
> > also saw regressions with dbench (both op latency and throughput) as
> > the clinet count (concurrency) increased, and with compilebench.  I
> > didn't look much further because all the common benchmarks I ran
> > showed perf degradations with arbitrary delays that went away with
> > the current code we have.  ISTR that parts of aim7/reaim scalability
> > workloads that the intel zero-day infrastructure runs are quite
> > sensitive to background inactivation delays as well because that's a
> > CPU bound workload and hence any reduction in cache residency
> > results in a reduction of the number of concurrent jobs that can be
> > run.
> > 
> 
> Ok, so if I (single threaded) create (via fs_mark), sync and remove 5m
> empty files, the remove takes about a minute. If I just bump out the
> current queue and block thresholds by 10x and repeat, that time
> increases to about ~1m24s. If I hack up a kernel to disable queueing
> entirely (i.e. fully synchronous inactivation), then I'm back to about a
> minute again. So I'm not producing any performance benefit with
> queueing/batching in this single threaded scenario, but I suspect the
> 10x threshold delta is at least measuring the negative effect of poor
> caching..? (Any decent way to confirm that..?).

Right, background inactivation does not improve performance - it's
necessary to get the transactions out of the evict() path. All we
wanted was to ensure that there were no performance degradations as
a result of background inactivation, not that it was faster.

If you want to confirm that there is an increase in cold cache
access when the batch size is increased, cpu profiles with 'perf
top'/'perf record/report' and CPU cache performance metric reporting
via 'perf stat -dddd' are your friend. See elsewhere in the thread
where I mention those things to Paul.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
