Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 23:12:52 -0700 (PDT)
Received: from relay.sgi.com (relay1.corp.sgi.com [192.26.58.214])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O6CjO6011421
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:12:45 -0700
Message-ID: <4901754D.9020109@sgi.com>
Date: Fri, 24 Oct 2008 17:12:13 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: XFS performance tracking and regression monitoring
References: <490108E6.7060502@sgi.com> <20081024035411.GH18495@disturbed>
In-Reply-To: <20081024035411.GH18495@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>, xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Fri, Oct 24, 2008 at 09:29:42AM +1000, Mark Goodwin wrote:
>> We're about to deploy a system+jbod dedicated for performance
>> regression tracking. The idea is to build the XFS dev branch
>> nightly, run a bunch of self contained benchmarks, and generate
>> a progressive daily report - date on the X-axis, with (perhaps)
>> wallclock runtime on the y-axis.
> 
> wallclock runtime is not indicative of relative performance
> for many benchmarks. e.g. dbench runs for a fixed time and
> then gives a throughput number as it's output. It's the throughput
> you want to compare.....

either, or. Both are differential. I want to keep this really simple,
just provide high level tracking on *when* a performance regression
may have been introduced but only with broad indicators. I don't
think anyone is regularly tracking this for XFS and we should be.

>> The aim is to track relative XFS performance on a daily basis
>> for various workloads on identical h/w. If each workload runs for
>> approx the same duration, the reports can all share the same
>> generic y-axis. THe long term trend should have a positive
>> gradient.
> 
> If you are measuring walltime, then you should see a negative
> gradient as an indication of improvement....

yes :)  what I ment, but was thinking "positively"

>> Regressions can be date correlated with commits.
> 
> For the benchmarks to be useful as regression tests, then the
> harness really needs to be profiling and gathering statistics at the
> same time so that we might be able to determine what caused the
> regression...

I would regard that as follow-up once an issue has been identified.
My proposal is too simple to be useful for diagnosis, but it should
be enough to provide heads-up. That's the aim to start with. The same
h/w can also be set up for more sophisticated measurements in the
longer term.

>> Comments, benchmark suggestions?
> 
> The usual set - bonnie++, postmark, ffsb, fio, sio, etc.
> 
> Then some artificial tests that stress scalability like speed of
> creating 1m small files with long names in a directory, the speed of
> a cold cache read of the directory, the speed of a hot-cache read of
> the directory, time to stat all the files (cold and hot cache),
> time to remove all the files, etc. And then how well it scales
> as you do this with more threads and directories in parallel...

yeah OK, bits and pieces of the the above, enough to provide broad
heads-up.

>> ANyone already running this?
>> Know of a test harness and/or report generator?
> 
> Perhap you might want to look more closely at FFSB - it has a
> fairly interesting automated test harness. e.g. it was used to
> produce these:
> 
> http://btrfs.boxacle.net/
> 
> And you can probably set up custom workloads to cover all the things
> that the standard benchmarks do.....

I'll poke around on those pages for some ideas.

Thanks for the reply.
