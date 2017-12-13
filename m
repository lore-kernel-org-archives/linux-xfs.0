Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37139 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750745AbdLMXAy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Dec 2017 18:00:54 -0500
Date: Thu, 14 Dec 2017 00:00:52 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 5/9] tests/xfs/group: add group for tests which require a
 logdev
Message-ID: <20171213230052.GJ16026@wotan.suse.de>
References: <20171213004519.29340-1-mcgrof@kernel.org>
 <20171213004519.29340-6-mcgrof@kernel.org>
 <20171213215013.GW4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213215013.GW4094@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 14, 2017 at 08:50:13AM +1100, Dave Chinner wrote:
> On Tue, Dec 12, 2017 at 04:45:15PM -0800, Luis R. Rodriguez wrote:
> > This should make it easy to run these separately or exclude them.
> 
> These should notrun automatically if you don't have an external log
> device configured. Every test should either work with an external
> logdev or explicitly notrun them, so I'm not sure what you're trying
> to acheive here....

The way I'm splitting up tests is one first run with a basic xfs section
on a configuration file, with no external log, which pretty much runs all
tests but excludes all which require external or funky configurations.

A secondary pass then goes through these extra groups and then runs tests
only for the previously excluded groups but with their own respective
section. So for instance in this case I have:

[xfs]
....
[logdev_xfs]
...

Automatic detection if the requirements are met is fine, but this doesn't 
let me easily use say:

	./check -s logdev_xfs -g logdev

> > 
> > Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > ---
> >  tests/xfs/group | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/tests/xfs/group b/tests/xfs/group
> > index d23006041ea2..cce98847de53 100644
> > --- a/tests/xfs/group
> > +++ b/tests/xfs/group
> > @@ -42,7 +42,7 @@
> >  042 fsr ioctl auto
> >  043 dump ioctl tape
> >  044 other auto
> > -045 other auto quick
> > +045 other auto quick logdev
> 
> This change also looks wrong because:
> 
> xfs/044  [not run] This test requires a valid $SCRATCH_LOGDEV
> xfs/045 1s ... 1s
> 
> xfs/044 is the external logdev test, and xfs/045 is a
> duplicate uuid mount test that has nothign to do with external
> log devices.

I see...

> And, FWIW, we already have a "log" group to indicate tests that
> exercise the log, and that mostly includes all the tests that use
> external logs. It would be better to tag all the tests that exercise
> the log with "log" rather than create some new group that doesn't
> really provide any added benefit....

So for my case would one better goal be to just run check without the external
one and one with the external log?

  ./check -s xfs -g log
  ./check -s logdev_xfs -g log

  Luis
