Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 21:41:05 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O4ejwD006523
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:40:45 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B6A6610E664C
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:40:43 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id jFAfi6DuSb6kIiIO for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 21:40:43 -0700 (PDT)
Date: Fri, 24 Oct 2008 14:54:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS performance tracking and regression monitoring
Message-ID: <20081024035411.GH18495@disturbed>
References: <490108E6.7060502@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <490108E6.7060502@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 09:29:42AM +1000, Mark Goodwin wrote:
> We're about to deploy a system+jbod dedicated for performance
> regression tracking. The idea is to build the XFS dev branch
> nightly, run a bunch of self contained benchmarks, and generate
> a progressive daily report - date on the X-axis, with (perhaps)
> wallclock runtime on the y-axis.

wallclock runtime is not indicative of relative performance
for many benchmarks. e.g. dbench runs for a fixed time and
then gives a throughput number as it's output. It's the throughput
you want to compare.....

> The aim is to track relative XFS performance on a daily basis
> for various workloads on identical h/w. If each workload runs for
> approx the same duration, the reports can all share the same
> generic y-axis. THe long term trend should have a positive
> gradient.

If you are measuring walltime, then you should see a negative
gradient as an indication of improvement....

> Regressions can be date correlated with commits.

For the benchmarks to be useful as regression tests, then the
harness really needs to be profiling and gathering statistics at the
same time so that we might be able to determine what caused the
regression...

> Comments, benchmark suggestions?

The usual set - bonnie++, postmark, ffsb, fio, sio, etc.

Then some artificial tests that stress scalability like speed of
creating 1m small files with long names in a directory, the speed of
a cold cache read of the directory, the speed of a hot-cache read of
the directory, time to stat all the files (cold and hot cache),
time to remove all the files, etc. And then how well it scales
as you do this with more threads and directories in parallel...

> ANyone already running this?
> Know of a test harness and/or report generator?

Perhap you might want to look more closely at FFSB - it has a
fairly interesting automated test harness. e.g. it was used to
produce these:

http://btrfs.boxacle.net/

And you can probably set up custom workloads to cover all the things
that the standard benchmarks do.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
