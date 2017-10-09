Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44692 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754408AbdJIOmB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 10:42:01 -0400
Date: Mon, 9 Oct 2017 16:40:15 +0200
From: David Sterba <dsterba@suse.cz>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009144015.GD3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171006210956.vf326sydjiphsefo@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171006210956.vf326sydjiphsefo@destiny>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Oct 06, 2017 at 05:09:57PM -0400, Josef Bacik wrote:
> One thing that comes up a lot every LSF is the fact that we have no general way
> that we do performance testing.  Every fs developer has a set of scripts or
> things that they run with varying degrees of consistency, but nothing central
> that we all use.  I for one am getting tired of finding regressions when we are
> deploying new kernels internally, so I wired this thing up to try and address
> this need.
> 
> We all hate convoluted setups, the more brain power we have to put in to setting
> something up the less likely we are to use it, so I took the xfstests approach
> of making it relatively simple to get running and relatively easy to add new
> tests.  For right now the only thing this framework does is run fio scripts.  I
> chose fio because it already gathers loads of performance data about it's runs.
> We have everything we need there, latency, bandwidth, cpu time, and all broken
> down by reads, writes, and trims.  I figure most of us are familiar enough with
> fio and how it works to make it relatively easy to add new tests to the
> framework.
> 
> I've posted my code up on github, you can get it here
> 
> https://github.com/josefbacik/fsperf

Let me propose an existing framework that is capable of what is in
fsperf, and much more. I'ts Mel Gorman's mmtests
http://github.com/gormanm/mmtests .

I've been using it for a year or so, built a few scripts on top of that to
help me set up configs for specific machines or run tests in sequences.

What are the capabilities regarding filesystem tests:

* create and mount filesystems (based on configs)
* start various workloads, that are possibly adapted to the machine
  (cpu, memory), there are many types, we'd be interested in those
  touching filesystems
* gather system statistics - cpu, memory, IO, latency there are scripts
  that understand the output of various benchmarking tools (fio, dbench,
  ffsb, tiobench, bonnie, fs_mark, iozone, blogbench, ...)
* export the results into plain text or html, with tables and graphs
* it is already able to compare results of several runs, with
  statistical indicators

The testsuite is actively used and maintained, which means that the
efforts are mosly on the configuration side. From users' perspective
this means to spend time with the setup and the rest will work as
expected. Ie. you don't have to start debugging the suite because there
are some version mismatches.

> All (well most) of the results from fio are stored in a local sqlite database.
> Right now the comparison stuff is very crude, it simply checks against the
> previous run and it only checks a few of the keys by default.  You can check
> latency if you want, but while writing this stuff up it seemed that latency was
> too variable from run to run to be useful in a "did my thing regress or improve"
> sort of way.
> 
> The configuration is brain dead simple, the README has examples.  All you need
> to do is make your local.cfg, run ./setup and then run ./fsperf and you are good
> to go.
> 
> The plan is to add lots of workloads as we discover regressions and such.  We
> don't want anything that takes too long to run otherwise people won't run this,
> so the existing tests don't take much longer than a few minutes each.

Sorry, this is IMO the wrong approach to benchmarking. Can you exercise
the filesystem enough in a few minutes? Can you write at least 2 times
memory size of data to the filesystem? Everything works fine when it's
from caches and the filesystem is fresh. With that you can simply start
using phoronix-test-suite and be done, with the same quality of results
we all roll eyes about.

Targeted tests using fio are fine and I understand the need to keep it
minimal. mmtests have support for fio and any jobfile can be used,
internally implemented with the 'fio --cmdline' option that will
transform it to a shell variable that's passed to fio in the end.

As proposed in the thread, why not use xfstests? It could be suitable
for the configs, mkfs/mount and running but I think it would need a lot
of work to enhance the result gathering and presentation. Essentially
duplicating mmtests from that side.

I was positively surprised by various performance monitors that I was
not primarily interested in, like memory allocations or context
switches.  This gives deeper insights into the system and may help
analyzing the benchmark results.

Side note: you can run xfstests from mmtests, ie. the machine/options
confugration is shared.

I'm willing to write more about the actual usage of mmtests, but at this
point I'm proposing the whole framework for consideration.
