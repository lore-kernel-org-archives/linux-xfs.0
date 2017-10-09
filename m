Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751647AbdJIGyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Oct 2017 02:54:37 -0400
Date: Mon, 9 Oct 2017 14:54:34 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [ANNOUNCE] fsperf: a simple fs/block performance testing
 framework
Message-ID: <20171009065434.GD10593@eguan.usersys.redhat.com>
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
Cc: Josef Bacik <josef@toxicpanda.com>, linux-fsdevel@vger.kernel.org, kernel-team@fb.com, linux-btrfs@vger.kernel.org, linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, tytso@mit.edu

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

I have no problem either if python is really needed, after all this is a
very useful infrastructure improvement. But the python version problem
brought up by Ted made me a bit nervous, we need to work that round
carefully.

OTOH, I'm just curious, what is the specific reason that python is a
hard requirement? If we can use perl, that'll be much easier for
fstests.

BTW, opinions from key fs developers/fstests users, like you, are also
very important and welcomed :)

Thanks,
Eryu

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
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
