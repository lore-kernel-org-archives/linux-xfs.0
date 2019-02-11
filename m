Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45259 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbfBKTqM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Feb 2019 14:46:12 -0500
Date: Mon, 11 Feb 2019 11:46:06 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v2 00/10] xfs: stable fixes for v4.19.y
Message-ID: <20190211194606.GO11489@garbanzo.do-not-panic.com>
References: <20190204165427.23607-1-mcgrof@kernel.org>
 <20190205220655.GF14116@dastard>
 <20190206040559.GA4119@sasha-vm>
 <20190206215454.GG14116@dastard>
 <20190208060620.GA31898@sasha-vm>
 <20190208221726.GM11489@garbanzo.do-not-panic.com>
 <20190209215627.GB69686@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190209215627.GB69686@sasha-vm>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Sasha Levin <sashal@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com, stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org

On Sat, Feb 09, 2019 at 04:56:27PM -0500, Sasha Levin wrote:
> On Fri, Feb 08, 2019 at 02:17:26PM -0800, Luis Chamberlain wrote:
> > On Fri, Feb 08, 2019 at 01:06:20AM -0500, Sasha Levin wrote:
> > Have you found pmem
> > issues not present on other sections?
> 
> Originally I've added this because the xfs folks suggested that pmem vs
> block exercises very different code paths and we should be testing both
> of them.
> 
> Looking at the baseline I have, it seems that there are differences
> between the failing tests. For example, with "MKFS_OPTIONS='-f -m
> crc=1,reflink=0,rmapbt=0, -i sparse=0'",

That's my "xfs" section.

> generic/524 seems to fail on pmem but not on block.

This is useful thanks! Can you get the failure rate? How often does it
fail when you run the test? Always? Does it *never* fail on block? How
many consecutive runs did you have run on block?

To help with this oscheck has naggy-check.sh, you could run it until
a failure is hit:

./naggy-check.sh -f -s xfs generic/524

And on another host:

./naggy-check.sh -f -s xfs_pmem generic/524

> > Any reason you don't name the sections with more finer granularity?
> > It would help me in ensuring when we revise both of tests we can more
> > easily ensure we're talking about apples, pears, or bananas.
> 
> Nope, I'll happily rename them if there are "official" names for it :)

Well since I am pushing out the stable fixes and am using oscheck to
be transparent about how I test and what I track, and since I'm using
section names, yes it would be useful to me. Simply adding a _pmem
postfix to the pmem ones would suffice.

> > FWIW, I run two different bare metal hosts now, and each has a VM guest
> > per section above. One host I use for tracking stable, the other host for
> > my changes. This ensures I don't mess things up easier and I can re-test
> > any time fast.
> > 
> > I dedicate a VM guest to test *one* section. I do this with oscheck
> > easily:
> > 
> > ./oscheck.sh --test-section xfs_nocrc | tee log-xfs-4.19.18+
> > 
> > For instance will just test xfs_nocrc section. On average each section
> > takes about 1 hour to run.
> 
> We have a similar setup then. I just spawn the VM on azure for each
> section and run them all in parallel that way.

Indeed.

> I thought oscheck runs everything on a single VM,

By default it does.

> is it a built in
> mechanism to spawn a VM for each config?

Yes:

./oscheck.sh --test-section xfs_nocrc_512

For instance will test section xfs_nocrc_512 *only* on that host.

> If so, I can add some code in
> to support azure and we can use the same codebase.

Groovy. I believe the next step will if you can send me your delta
of expunges, and then I can run naggy-check.sh on them to see if I
can reach similar results. I believe you have a larger expunge list.
I suspect some of this may you may not have certain quirks handled.
We will see. But getting this right and to sync our testing should
yield good confirmation of failures.

> > I could run the tests on raw nvme and do away with the guests, but
> > that loses some of my ability to debug on crashes easily and out to
> > baremetal.. but curious, how long do your tests takes? How about per
> > section? Say just the default "xfs" section?
> 
> I think that the longest config takes about 5 hours, otherwise
> everything tends to take about 2 hours.

Oh wow, mine are only 1 hour each. Guess I got a decent rig now :)

> I basically run these on "repeat" until I issue a stop order, so in a
> timespan of 48 hours some configs run ~20 times and some only ~10.

I see... so you iterate over all tests and many times a day and this is
how you've built your expunge list. Correct?

It could could explain how you may end up with a larger set. This can
mean some tests only fail at a non-100% failure rate, for these I'm
annotating the failure rate as a comment on each expunge line. Having a
consistent format for this and proper agreed upon term would be good.
Right now I just mention how oftem I have to run a test before reaching
a failure.  This provides a rough estimate how many times one should
iterate running the test in a loop before detecting a failure. Of course
this may not always be acurate, given systems vary and this could play
an impact on the failure... but at least it provides some guidance. It
would be curious to see if we end up with similar failure rates for
tests don't always fail. And if there is a divergence, how big this
could be.

  Luis
