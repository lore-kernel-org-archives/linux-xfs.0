Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:41236 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750993AbdKFVUt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2017 16:20:49 -0500
Date: Tue, 7 Nov 2017 08:20:46 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171106212046.GG4094@dastard>
References: <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103024740.GE4911@magnolia>
 <20171103113622.GB19974@bfoster.bfoster>
 <20171105225028.GB5858@dastard>
 <20171106130100.GA30884@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171106130100.GA30884@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

On Mon, Nov 06, 2017 at 08:01:00AM -0500, Brian Foster wrote:
> On Mon, Nov 06, 2017 at 09:50:28AM +1100, Dave Chinner wrote:
> > On Fri, Nov 03, 2017 at 07:36:23AM -0400, Brian Foster wrote:
> > > On Thu, Nov 02, 2017 at 07:47:40PM -0700, Darrick J. Wong wrote:
> > > > FWIW the way I've been modelling this patch series in my head is that we
> > > > format an arbitrarily large filesystem (m_LBA_size) address space on a
> > > > thinp, feed statfs an "adjusted" size (m_usable_size)i which restricts
> > > > how much space we can allocate, and now growfs increases or decreases
> > > > the adjusted size without having to relocate anything or mess with the
> > > > address space.  If the adjusted size ever exceeds the address space
> > > > size, then we tack on more AGs like we've always done.  From that POV,
> > > > there's no need to physically shrink (i.e. relocate) anything (and we
> > > > can leave that for later/never).
> > 
> > [...]
> > 
> > > For example, suppose we had an absolute crude, barebones implementation
> > > of physical shrink right now that basically trimmmed the amount of space
> > > from the end of the fs iff those AGs were completely empty and otherwise
> > > returned -EBUSY. There is no other userspace support, etc. As such, this
> > > hypothetical feature is extremely limited to being usable immediately
> > > after a growfs and thus probably has no use case other than "undo my
> > > accidental growfs."
> > > 
> > > If we had that right now, _then_ what would the logical shrink interface
> > > look like?
> > 
> > Absolutely no different to what I'm proposing we do right now. That
> > is, the behaviour of the "shrink to size X" ioctl is determined by
> > the feature bit in the superblock.  Hence if the thinspace feature
> > is set we do a thin shrink, and if it is not set we do a physical
> > shrink. i.e. grow/shrink behaviour is defined by the kernel
> > implementation, not the user or the interface.
> > 
> 
> I don't buy that argument at all. ;) What you describe above may be
> reasonable for the current situation where shrink doesn't actually exist
> (or thin comes first),

Which is the case we are discussing here. thinspace shrink is here,
now, physical shrink is no closer than it was 10 years ago. So it's
reasonable to design changes around the needs of thinspace shrink
because physical shrink is still be years away (if ever).

> but the above example assumes that there is at
> least one simple and working physical shrink use case wired up to the
> existing interface already.

IOWs, this is a strawman argument that involves designing an API to
suit the strawman.

[....]

> In summary, my arguments here consist mostly of a collection of red
> flags that I see rather than hard incompatibilities or specific use
> cases I want to support. The problematic situations change depending on
> whether we decide to support physical shrink on thin fs or not and so
> it's not really possible or important to try and pin them all down.
> OTOH, it's also quite possible that none of them ever materialize at
> all.

And that's the point I keep making: we don't know which of the
strawmen being presented are going to matter (if at all) until we
have physical shrink designed and are deep into the implementation.

IOWs, trying to work out the future API needs of a physical shrink
is just a guessing game right now.

> If they do, I'm pretty sure we could find ways to address each one
> individually as we progress, or document potentially confusing behavior
> appropriately, etc. The larger point is that I think much of this simply
> goes away with a cleaner interface. IMO, this boils down to what I think
> is just a matter of practicing good software engineering and system/user
> interface design.

Yes, but designing based on a /guess/ is *bad engineering practice*.
It almost always ends up wrong and has to be reworked, and that
means we get stuck supporting an API we don't need or want forever
more.

Yes, we've categorised the risk that we might need an interface
change in future - as we should - but we don't know which of those
risks are going to materialise.  IOWs, we can't solve this interface
problem with the information or insight we currently have - we need
to implement physical shrink and determine which of these risks
actually materialise, and then we can address the interface issue
knowing that we're solving the problems that physical shrink
introduces.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
