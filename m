Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:41396 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751035AbdLMXrA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 18:47:00 -0500
Date: Thu, 14 Dec 2017 10:39:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 5/9] tests/xfs/group: add group for tests which require a
 logdev
Message-ID: <20171213233914.GD5858@dastard>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-6-mcgrof@kernel.org>
 <20171213215013.GW4094@dastard>
 <20171213230052.GJ16026@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213230052.GJ16026@wotan.suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 14, 2017 at 12:00:52AM +0100, Luis R. Rodriguez wrote:
> On Thu, Dec 14, 2017 at 08:50:13AM +1100, Dave Chinner wrote:
> > On Tue, Dec 12, 2017 at 04:45:15PM -0800, Luis R. Rodriguez wrote:
> > > This should make it easy to run these separately or exclude them.
> > 
> > These should notrun automatically if you don't have an external log
> > device configured. Every test should either work with an external
> > logdev or explicitly notrun them, so I'm not sure what you're trying
> > to acheive here....
> 
> The way I'm splitting up tests is one first run with a basic xfs section
> on a configuration file, with no external log, which pretty much runs all
> tests but excludes all which require external or funky configurations.
> 
> A secondary pass then goes through these extra groups and then runs tests
> only for the previously excluded groups but with their own respective
> section. So for instance in this case I have:
> 
> [xfs]
> ....
> [logdev_xfs]
> ...

Which seems to me like a misguided attempt to optimise test
runtimes. i.e. this doesn't provide test coverage of external log
behaviour in all the cases that need to be tested.

Data integrity code paths are affected by having an external log. IO
ordering changes with external logs, which can expose update/crash
recovery problems. external logs can expose data IO race conditions
that are masked by interleaved log IO. etc, etc, etc.

You can't just run an internal log test then add couple of extra
external log tests and say "external logs work fine".

> Automatic detection if the requirements are met is fine, but this doesn't 
> let me easily use say:
> 
> 	./check -s logdev_xfs -g logdev

You can do that if we ignore the fact that a large number of tests
need to be run on both internal and external log devices to cover
the differences in behaviour between them.

> > And, FWIW, we already have a "log" group to indicate tests that
> > exercise the log, and that mostly includes all the tests that use
> > external logs. It would be better to tag all the tests that exercise
> > the log with "log" rather than create some new group that doesn't
> > really provide any added benefit....
> 
> So for my case would one better goal be to just run check without the external
> one and one with the external log?

See above. Your test coverage assumptions are wrong, so what you are
trying to do really doesn't tell you whether external logs work
correctly or not. It's worse that not testing external logs at all,
because it gives the false impression that they have been
exhaustively tested and work just fine when that really isn't the
case.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
