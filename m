Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:44475 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754342AbdJINAx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2017 09:00:53 -0400
Received: by mail-qk0-f172.google.com with SMTP id r64so23198727qkc.1
        for <linux-xfs@vger.kernel.org>; Mon, 09 Oct 2017 06:00:53 -0700 (PDT)
Date: Mon, 9 Oct 2017 09:00:51 -0400
From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009130050.ufnmdhslc53bwpgc@destiny>
References: <20171006210956.vf326sydjiphsefo@destiny>
 <20171009005137.GA3666@dastard>
 <20171009022509.rz6goq3sec5ppxrr@destiny>
 <20171009051731.GK3666@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171009051731.GK3666@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Oct 09, 2017 at 04:17:31PM +1100, Dave Chinner wrote:
> On Sun, Oct 08, 2017 at 10:25:10PM -0400, Josef Bacik wrote:
> > On Mon, Oct 09, 2017 at 11:51:37AM +1100, Dave Chinner wrote:
> > > On Fri, Oct 06, 2017 at 05:09:57PM -0400, Josef Bacik wrote:
> > > > Hello,
> > > > 
> > > > One thing that comes up a lot every LSF is the fact that we have no general way
> > > > that we do performance testing.  Every fs developer has a set of scripts or
> > > > things that they run with varying degrees of consistency, but nothing central
> > > > that we all use.  I for one am getting tired of finding regressions when we are
> > > > deploying new kernels internally, so I wired this thing up to try and address
> > > > this need.
> > > > 
> > > > We all hate convoluted setups, the more brain power we have to put in to setting
> > > > something up the less likely we are to use it, so I took the xfstests approach
> > > > of making it relatively simple to get running and relatively easy to add new
> > > > tests.  For right now the only thing this framework does is run fio scripts.  I
> > > > chose fio because it already gathers loads of performance data about it's runs.
> > > > We have everything we need there, latency, bandwidth, cpu time, and all broken
> > > > down by reads, writes, and trims.  I figure most of us are familiar enough with
> > > > fio and how it works to make it relatively easy to add new tests to the
> > > > framework.
> > > > 
> > > > I've posted my code up on github, you can get it here
> > > > 
> > > > https://github.com/josefbacik/fsperf
> > > > 
> > > > All (well most) of the results from fio are stored in a local sqlite database.
> > > > Right now the comparison stuff is very crude, it simply checks against the
> > > > previous run and it only checks a few of the keys by default.  You can check
> > > > latency if you want, but while writing this stuff up it seemed that latency was
> > > > too variable from run to run to be useful in a "did my thing regress or improve"
> > > > sort of way.
> > > > 
> > > > The configuration is brain dead simple, the README has examples.  All you need
> > > > to do is make your local.cfg, run ./setup and then run ./fsperf and you are good
> > > > to go.
> > > 
> > > Why re-invent the test infrastructure? Why not just make it a
> > > tests/perf subdir in fstests?
> > > 
> > 
> > Probably should have led with that shouldn't I have?  There's nothing keeping me
> > from doing it, but I didn't want to try and shoehorn in a python thing into
> > fstests.  I need python to do the sqlite and the json parsing to dump into the
> > sqlite database.
> > 
> > Now if you (and others) are not opposed to this being dropped into tests/perf
> > then I'll work that up.  But it's definitely going to need to be done in python.
> > I know you yourself have said you aren't opposed to using python in the past, so
> > if that's still the case then I can definitely wire it all up.
> 
> I have no problems with people using python for stuff like this but,
> OTOH, I'm not the fstests maintainer anymore :P
> 
> > > > The plan is to add lots of workloads as we discover regressions and such.  We
> > > > don't want anything that takes too long to run otherwise people won't run this,
> > > > so the existing tests don't take much longer than a few minutes each.  I will be
> > > > adding some more comparison options so you can compare against averages of all
> > > > previous runs and such.
> > > 
> > > Yup, that fits exactly into what fstests is for... :P
> > > 
> > > Integrating into fstests means it will be immediately available to
> > > all fs developers, it'll run on everything that everyone already has
> > > setup for filesystem testing, and it will have familiar mkfs/mount
> > > option setup behaviour so there's no new hoops for everyone to jump
> > > through to run it...
> > > 
> > 
> > TBF I specifically made it as easy as possible because I know we all hate trying
> > to learn new shit.
> 
> Yeah, it's also hard to get people to change their workflows to add
> a whole new test harness into them. It's easy if it's just a new
> command to an existing workflow :P
> 

Agreed, so if you probably won't run this outside of fstests then I'll add it to
xfstests.  I envision this tool as being run by maintainers to verify their pull
requests haven't regressed since the last set of patches, as well as by anybody
trying to fix performance problems.  So it's way more important to me that you,
Ted, and all the various btrfs maintainers will run it than anybody else.

> > I figured this was different enough to warrant a separate
> > project, especially since I'm going to add block device jobs so Jens can test
> > block layer things.  If we all agree we'd rather see this in fstests then I'm
> > happy to do that too.  Thanks,
> 
> I'm not fussed either way - it's a good discussion to have, though.
> 
> If I want to add tests (e.g. my time-honoured fsmark tests), where
> should I send patches?
> 

I beat you to that!  I wanted to avoid adding fs_mark to the suite because it
means parsing another different set of outputs, so I added a new ioengine to fio
for this

http://www.spinics.net/lists/fio/msg06367.html

and added a fio job to do 500k files

https://github.com/josefbacik/fsperf/blob/master/tests/500kemptyfiles.fio

The test is disabled by default for now because obviously the fio support hasn't
landed yet.

I'd _like_ to expand fio for cases we come up with that aren't possible, as
there's already a ton of measurements that are taken, especially around
latencies.  That said I'm not opposed to throwing new stuff in there, it just
means we have to add stuff to parse the output and store it in the database in a
consistent way, which seems like more of a pain than just making fio do what we
need it to.  Thanks,

Josef
