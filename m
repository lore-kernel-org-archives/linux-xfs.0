Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E2D3C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 22:16:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444716AbiEFWU2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 18:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444713AbiEFWUY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 18:20:24 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0FC5954FA6;
        Fri,  6 May 2022 15:16:40 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0DFC410E6304;
        Sat,  7 May 2022 08:16:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nn6FZ-008sE9-FI; Sat, 07 May 2022 08:16:37 +1000
Date:   Sat, 7 May 2022 08:16:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs/larp: Make test failures debuggable
Message-ID: <20220506221637.GK1949718@dread.disaster.area>
References: <20220223033751.97913-1-catherine.hoang@oracle.com>
 <20220223033751.97913-2-catherine.hoang@oracle.com>
 <20220506075141.GH1949718@dread.disaster.area>
 <20220506161442.GP27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506161442.GP27195@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62759e47
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=10HhR1E9DKAKBJvufwEA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 06, 2022 at 09:14:42AM -0700, Darrick J. Wong wrote:
> On Fri, May 06, 2022 at 05:51:41PM +1000, Dave Chinner wrote:
> > Hi Catherine,
> > 
> > These are all the mods I needed to make to be able to understand the
> > test failures I was getting as I debugged the new LARP recovery
> > algorithm I've written.  You'll need to massage the test number in
> > this patch to apply it on top of your patch.

vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

> > I haven't added any new test cases yet, nor have I done anything to
> > manage the larp sysfs knob, but we'll need to do those in the near
> > future.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > Zorro, can you consider merging this test in the near future?  We're
> > right at the point of merging the upstream kernel code and so really
> > need to start growing the test coverage of this feature, and this
> > test should simply not-run on kernels that don't have the feature
> > enabled....
> > 
> > Cheers,
> > 
> > Dave.
> > ---
> > 
> >  tests/xfs/600     |  20 +++++-----
> >  tests/xfs/600.out | 109 ++++++++++++++++++++++++++++++++++++------------------
> >  2 files changed, 85 insertions(+), 44 deletions(-)
> > 
> > diff --git a/tests/xfs/600 b/tests/xfs/600
> > index 252cdf27..84704646 100755
> > --- a/tests/xfs/600
> > +++ b/tests/xfs/600
> > @@ -16,7 +16,7 @@ _begin_fstest auto quick attr
> >  
> >  _cleanup()
> >  {
> > -	rm -rf $tmp.* $testdir
> > +	rm -rf $tmp.*
> >  	test -w /sys/fs/xfs/debug/larp && \
> >  		echo 0 > /sys/fs/xfs/debug/larp
> 
> Blergh, this ^^^^^^^^^ is going to need fixing too.
> 
> Please save the old value, then write it back in the _cleanup function.

Yes, I know about this. I haven't done anything about it yet because
I haven't decided yet whether it should stay or be removed. Getting
the test and the code it tests working has been my focus so far.

I have a wrapper script that sets the knob for the entire of the
fstests run (i.e. so all attr and recovery tests exercise the LARP
functionality) and so I'm not sure that this test should twiddle the
knob at all. i.e. right now it would be more useful to me for the
test to check if the knob is not set to just _not_run the test,
rather than turn it on and off and all that...

Indeed, we probably shouldn't be forcing everyone to test a brand
new experimental feature that might be unstable and cause the test
run to halt prematurely (e.g. because it crashes).

> <slightly ot rant>
> 
> These sysfs knobs are a pain because they all reset to defaults if
> xfs.ko gets cycled.  I know, I know, at least Dave and Ted don't do
> modular kernels and so never see this happen, but I do.

sysfs knobs get reset by reboots to load a new kernel, so the impact
is identical - I have to reset the knob every time I load a new test
kernel, just like you have to reset it every time you load a new
module.

> I bet Dave also
> hasn't ever run xfs/434 or xfs/436, which might be why I'm the only one
> seeing dquot leaks with 5.19-next.

Yup, there are a bunch of tests that I never run because:

- scsi_debug requires modular kernel
- I always build with fatal XFS ASSERTs, so the tests that want
  non-fatal asserts don't run
- xfs/43[4-6] require a modular kernel
- xfs/490 requires CONFIG_XFS_DEBUG be turned off (I *never* do
  that)
- I generally don't have source code on my test machines, so
  api-violations.sh won't run (xfs/437)

And there's probably a few more in that list as well.

IMO, any test that depends on a specific debug config or test
environment setup that aren't (or can't be) consistently used by the
entire developer base should be discouraged precisely because it
means different developers end up with different code coverage and
might miss problems they really should know about.

> (I might be able to lift the xfs-as-module requirement if "echo 1 >
> /sys/kernel/slab/*/validate" does what I think it might, since all we
> want to do is look for slab leaks, and those tests rmmod/modprobe as a
> brute force way of making the slab debug code check for leaks.)

Doesn't running fstests with KASAN enabled find those slab leaks?

> In case anyone's wondering, a solution to the knobs getting unset after
> an rmmod/modprobe cycle is to add a file
> /etc/udev/rules.d/99-fstester.rules containing:
> 
> ACTION=="add|change", SUBSYSTEM=="module", DEVPATH=="/module/${module}", RUN+="/bin/sh -c \"echo ${value} > ${knob}\""
> 
> which should be enough to keep LARP turned on.

I don't want it turned on unconditionally - I have to test both the
existing code path and the new LARP code path, so I'm constantly
toggling the value between test runs.

> Anyway, since this is a proposed test, I say that with this applied and
> the debug knob bits fixed, the whole thing is
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
