Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:19901 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753235AbdJIAvm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Oct 2017 20:51:42 -0400
Date: Mon, 9 Oct 2017 11:51:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009005137.GA3666@dastard>
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
> Hello,
> 
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
> 
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

Why re-invent the test infrastructure? Why not just make it a
tests/perf subdir in fstests?

> The plan is to add lots of workloads as we discover regressions and such.  We
> don't want anything that takes too long to run otherwise people won't run this,
> so the existing tests don't take much longer than a few minutes each.  I will be
> adding some more comparison options so you can compare against averages of all
> previous runs and such.

Yup, that fits exactly into what fstests is for... :P

Integrating into fstests means it will be immediately available to
all fs developers, it'll run on everything that everyone already has
setup for filesystem testing, and it will have familiar mkfs/mount
option setup behaviour so there's no new hoops for everyone to jump
through to run it...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
