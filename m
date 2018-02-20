Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:38848 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751786AbeBTVCs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Feb 2018 16:02:48 -0500
Date: Wed, 21 Feb 2018 08:02:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [ANNOUNCE] xfsprogs v4.15.0-rc1 released
Message-ID: <20180220210237.GB7000@dastard>
References: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
 <20180220003635.GA8479@infradead.org>
 <8675595f-abe1-739c-c131-e12737045365@sandeen.net>
 <20180220163347.GB27629@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180220163347.GB27629@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Feb 20, 2018 at 08:33:47AM -0800, Darrick J. Wong wrote:
> On Tue, Feb 20, 2018 at 09:09:22AM -0600, Eric Sandeen wrote:
> > (resend, somehow I keep missing reply-all)
> > 
> > That would be much faster than at least our historical progression
> > for new features:
> > 
> > * Experimental for $LONG_TIME
> > * Drop experimental for $SIGNIFICANT_TIME
> > * Make default after that
> 
> ISTR Dave once telling me that he usually waited ~4 kernel releases to
> drop the experimental tag and then another year to turn it on by
> default in mkfs.  I'll grant you that seven kernels went by before
> EXPERIMENTAL went away, so I don't think we need to wait a whole other
> year.  How about turning it on by default in July or so?

The wait time for "supported -> default" is so that distro's have
time to move to a feature supported kernel before they pick up a new
xfsprogs release that turns on that feature by default. this mostly
avoids the problem of distros accidentally turning on a feature that
is still experimental in their kernel....

It also gives us "early adopter" feedback before large numbers of
unsuspecting users have it enabled for them....

> Speaking of which, hasn't enough time passed to enable spinodes by
> default in mkfs?  Given the likelihood of worse fragmentation once we
> add cow into the mix, we probably want that turned on before reflink.
> 
> Hm.... EXPERIMENTAL was removed for spinodes in July 2016, so that
> probably could be turned on "now".

Yup, enough time has passed there.

> > My sense is that it's a bit premature, having /just/ dropped the
> > EXPERIMENTAL tag, which will (in theory) get more people using
> > it in earnest and maybe shaking out more bugs.
> > 
> > But I'd like to hear what others think as well.
> 
> There's already too much new stuff in mkfs 4.15; let's wait for .17
> because that'll give the more cautious testers more time to find
> whatever other bugs still lurk. :)

I think even that is too fast. If distro's want it as the default
before we set it, then they can patch mkfs themselves.

If this is really a huge problem for distros, then wasn't this what
someone wanted mkfs config files for?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
