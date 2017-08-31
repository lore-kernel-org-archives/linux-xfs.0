Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:29115 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750925AbdHaW7E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 18:59:04 -0400
Date: Fri, 1 Sep 2017 08:58:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: remove experimental tag for reflinks
Message-ID: <20170831225839.GS10621@dastard>
References: <20170830145400.3681-1-hch@lst.de>
 <20170831064033.GF3775@magnolia>
 <20170831124321.GA21939@bfoster.bfoster>
 <20170831133019.GA5468@lst.de>
 <20170831153148.GJ3775@magnolia>
 <20170831155923.GG21939@bfoster.bfoster>
 <20170831200936.GO3775@magnolia>
 <20170831203613.GB25053@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170831203613.GB25053@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>

On Thu, Aug 31, 2017 at 04:36:14PM -0400, Brian Foster wrote:
> On Thu, Aug 31, 2017 at 01:09:36PM -0700, Darrick J. Wong wrote:
> > On Thu, Aug 31, 2017 at 11:59:24AM -0400, Brian Foster wrote:
> > > On Thu, Aug 31, 2017 at 08:31:48AM -0700, Darrick J. Wong wrote:
> > > > On Thu, Aug 31, 2017 at 03:30:19PM +0200, Christoph Hellwig wrote:
> > > > > On Thu, Aug 31, 2017 at 08:43:21AM -0400, Brian Foster wrote:
> > > > > > FWIW, I don't really have a strong opinion. To me, removing experimental
> > > > > > means we feel the code has stabilized long enough in principle, there
> > > > > > are no significant problems (i.e., corruption/crash vectors) that we are
> > > > > > aware of and the feature is complete (full userspace tool support, etc).
> > > > > > The in-core extent list thing seems like more of a general problem to me
> > > > > 
> > > > > Agreed so far.
> > > > 
> > > > <nod> Dave?  Eric?  Any perspective you'd like to offer? :)
> > > > 
> > > > > > That aside, shouldn't we consider the rmapbt experimental tag first, or
> > > > > > at least at the same time? It's been around for slightly longer.
> > > > > 
> > > > > I've not done much testing on that or have experience with it in general,
> > > > > nor do I have a customer with a big QA team beating it hard, so I can't
> > > > > really comment on that one.
> > > > 
> > > > rmapbt will remain EXPERIMENTAL because I still have more patches to
> > > > send to finish the feature for realtime devices.  Speaking of which,
> > > > it's now been 53 weeks since the last dump of that, so I'll go do that
> > > > now. :P
> > > > 
> > > > FWIW I /also/ run rmapbt everywhere and haven't had any trouble with it
> > > > since adding the per-AG reservations.
> > > > 
> > > 
> > > My question then is do we want to encourage users to run reflink without
> > > rmapbt because of the latter being experimental, and only so because of
> > > a lack of realtime support? *shrug* Maybe it doesn't really matter.
> > 
> > Probably not, I think realtime users are fairly infrequent and
> > especially so on v5.  The only reasons I can think of to extend our new
> > features to rt are (a) to avoid screwing over the existing usecases and
> > (b) I guess you could build a hybrid xfs between an SSD and a SMR drive
> > wherein we always CoW from one end of the disk to the other.  (That's
> > crazy, but hey.)

Or use RT files as VM image files with deterministic, low overhead
allocation characteristics. And for that use case, I^Hwe want rmap
and reflink on the realtime device so we can scrub and
snapshot/send/recv those image files......

> Yeah, the only use cases I've really heard wrt to realtime any time in
> the recent past has been these kind of future facing experiments as
> opposed to traditional use. Not to say there aren't users out there, but

Let's not forget that there are tens of millions of existing
XFS RT filesystems out there in smart TVs and DVRs.

> I also can't recall seeing any bug reports or anything of that nature
> either any time recently. Maybe it's just perfect code. ;)

No, just carefully constrained applications and a lot of QA.

> I think Dave has thought about the SMR+RT thing in the past.

Yes, and I wrote a document describing it for the device vendors
that were screaming for us to do something to be able to go away and
implement.....  <crickets>

Regardless, IIRC, there have been people using RT devices with SMR
drives for some years now, mainly because the RT device could
guarantee zone aligned and sized allocations for sequential write
applications like video recording....

> > > If realtime is the only barrier, ISTM we could remove the experimental
> > > rmapbt status and just disable rmapbt+rt for now. Then re-enable
> > > EXPERIMENTAL just for rmapbt+rt when that code goes in (which seems like
> > > the most likely end result to me anyways).
> > 
> > It's already disabled.  I suppose it's not /that/ big of a deal if old
> > kernels reject certain feature combinations...

Just add an incompat bit for rtrmapbt and rtreflink when they come
along, and everything will be fine :P

> > ...by the way, we can't add a rt device to an already-mounted
> > filesystem, right?
> 
> I thought it was a mkfs time thing, but I could be mistaken...

It is at the moment, but there's nothing that prevents us from
adding it dynamically if we wanted (same as journal resizing). e.g.
via a remount to specify and open the rt device and growfs to resize
it from zero to device size and allocate and initialise the bitmap
and summary inodes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
