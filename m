Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45450 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753352AbeBWSds (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Feb 2018 13:33:48 -0500
Date: Fri, 23 Feb 2018 10:33:24 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [ANNOUNCE] xfsprogs v4.15.0-rc1 released
Message-ID: <20180223183324.GN9827@magnolia>
References: <7025bd78-65f9-ad25-e884-cada818a685b@sandeen.net>
 <20180220003635.GA8479@infradead.org>
 <8675595f-abe1-739c-c131-e12737045365@sandeen.net>
 <20180220163347.GB27629@magnolia>
 <20180220210237.GB7000@dastard>
 <b5f653da-d56d-550f-645c-36da93ba7441@sandeen.net>
 <20180222234446.GH7000@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180222234446.GH7000@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Feb 23, 2018 at 10:44:46AM +1100, Dave Chinner wrote:
> On Thu, Feb 22, 2018 at 02:49:27PM -0600, Eric Sandeen wrote:
> > 
> > 
> > On 2/20/18 3:02 PM, Dave Chinner wrote:
> > > On Tue, Feb 20, 2018 at 08:33:47AM -0800, Darrick J. Wong wrote:
> > >> On Tue, Feb 20, 2018 at 09:09:22AM -0600, Eric Sandeen wrote:
> > >>> (resend, somehow I keep missing reply-all)
> > >>>
> > >>> That would be much faster than at least our historical progression
> > >>> for new features:
> > >>>
> > >>> * Experimental for $LONG_TIME
> > >>> * Drop experimental for $SIGNIFICANT_TIME
> > >>> * Make default after that
> > >>
> > >> ISTR Dave once telling me that he usually waited ~4 kernel releases to
> > >> drop the experimental tag and then another year to turn it on by
> > >> default in mkfs.  I'll grant you that seven kernels went by before
> > >> EXPERIMENTAL went away, so I don't think we need to wait a whole other
> > >> year.  How about turning it on by default in July or so?
> > > 
> > > The wait time for "supported -> default" is so that distro's have
> > > time to move to a feature supported kernel before they pick up a new
> > > xfsprogs release that turns on that feature by default. this mostly
> > > avoids the problem of distros accidentally turning on a feature that
> > > is still experimental in their kernel....
> > 
> > Speaking for Fedora, it brings userspace & kernelspace into a distro
> > together, so that's not a problem.  Speaking for RHEL, it's a long term
> > distro that knows darned well that mixing and matching new & old requires
> > care, if it's done at all.
> 
> Right, but other distros like debian have async kernel and userspace
> package update schedules. It's not until they "freeze" for a release
> that things like userspace and kernel versions are expected to have
> feature matches. e.g. we could upload xfsprogs 4.16 with reflink
> enabled by default to unstable the moment it is released. At that
> point in time, the default unstable kernel might be a 4.15 kernel
> (or older). Worse, the current installer kernel might be be even
> older, even though the nightly build picks up the new installer
> package we uploaded.
> 
> It's unecessary angst and pain that is easily avoided by having some
> delay between saying "this is suported now" and "every new
> filesystem will use it by default"....

Right, and I was suggesting 4.18 or so, which gives distros 4 months to
update their kernels... but now I looked at my notes from 2015 which
said "reflink on by default in 420??", snickered at my own juvenile
humor, and reflected on how that wasn't such an inaccurate forecast
after all. :P

So, uh, how about 4.20?  That'll give everyone a good 9 months to pick
up a new kernel.

(As for debian, I thought they /were/ doing the "update kernel and then
matching xfsprogs" dance, at least for stretch and beyond.)

--D

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
