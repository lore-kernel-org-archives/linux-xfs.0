Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46606 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751119AbcLLHok (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Dec 2016 02:44:40 -0500
Date: Mon, 12 Dec 2016 18:44:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Preparing for XFS reflink D-day
Message-ID: <20161212074430.GX4326@dastard>
References: <CAOQ4uxi_x+7Kc3P_xMr4O3DUKK7uhkfoUoyQsp7PYnxJaeLzcw@mail.gmail.com>
 <20161212015959.GT4326@dastard>
 <CAOQ4uxhiOb9SBgDaqjY5gQ+Z99BRWCFtc=vyGiB4PmXyDYQQZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhiOb9SBgDaqjY5gQ+Z99BRWCFtc=vyGiB4PmXyDYQQZA@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Dec 12, 2016 at 07:06:37AM +0200, Amir Goldstein wrote:
> On Mon, Dec 12, 2016 at 3:59 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Sat, Dec 10, 2016 at 10:04:39AM +0200, Amir Goldstein wrote:
> > our upstream feature stabilisation and support plans.  If you want
> > to run your user base on reflink=1 filesystems on 4.9 kernels then
> > feel free to support them directly. That's enitrely your own choice
> > made entirely your own risk as a downstream distributor.  We'll
> > triage and fix bugs as you report them and incorporate fixes and
> > improvements as relevant, but we're not going to do any more than
> > that.  "Use at your own risk" means exactly that.
> >
> 
> This makes sense. To be clear, my intention was not exactly to run
> 4.9 with reflink=1, but to run 4.9 with "reflink pre-formatted".
> That means addressing exactly the issues you mentioned below
> of preallocating the refcountbt space in all AGs.

This requires all sorts of changes to the code to make that work.
The ship has already sailed for 4.9 so stop thinking we're
going to add /anything/ to mkfs in 4.9.

And given that xfsprogs 4.10 needs to match the functionality we're
about to merge into the kernel for the 4.10 cycle, we're unlikely to
add support for on-disk changes that aren't supported by the 4.10
kernel - that dev cycle is already over, too.

The next 3 dev month cycle is for 4.11, and there's already all the
online scrub/repair code lined up for this release, so getting that
merged holds much greater priority than hacking reflink formats to
work around the EXPERIMENTAL tag.

IOWs, the /earliest/ anything like this could be done is 4.11, but
I'd be really hesitant to rush anything like this into 4.11 because
of all the stuff we already have in the pipeline.  And given that
we're currently looking at around the 4.12 release timeframe for
moving to full support for reflink, what does all this extra
"refcount-but-not-reflink" format shenanigans buy us? At best it's
going to be useful for a 3-6 month window, with very very limited
relevance or use to the rest of the XFS userbase?

When I look at what you ar eproposing from this perspective, the
cost-benefit analysis does not fall favourably on the side of making
these changes.

> > FWIW, Christoph has taken this "downstream risk" path for his own
> > clients and customers that are using the reflink functionality in
> > their systems. He doesn't bother us with triaging or fixing issues
> > his customers hit; all we see from him is a constant stream of bug
> > fixes and improvements to the experimental features his customers
> > are using...
> >
> 
> If I have to go down that path I will, but only as last resort.

That's the preferrable first path - it's been widely used across the
vendor storage ecosystem for many years. It's proven to be a good
model over many years because it puts no additional support or
development load on upstream but provides a steady flow of
additional features and bug fixes back to us.

That's the exact opposite of what you are proposing: that
we supply you with the functionality you require, immediately,
without forward planning, without caring about impact on
established lines of development, etc.

There's just a little bit of difference here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
