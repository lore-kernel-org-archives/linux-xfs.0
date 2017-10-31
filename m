Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:42807 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932578AbdJaWkx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Oct 2017 18:40:53 -0400
Date: Wed, 1 Nov 2017 09:40:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171031224050.GE5858@dastard>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <CAOQ4uxjidk5T=g+uUooqXVunOCf2n2mfKXPGXnSzPEqFYJ=LFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjidk5T=g+uUooqXVunOCf2n2mfKXPGXnSzPEqFYJ=LFQ@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Oct 31, 2017 at 06:49:01AM +0200, Amir Goldstein wrote:
> On Mon, Oct 30, 2017 at 11:09 PM, Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> >> On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> ...
> >> Finally, I tend to agree with Amir's comment with regard to
> >> shrink/growfs... at least infosar as I understand his concern. If we do
> >> support physical shrink in the future, what do we expect the interface
> >> to look like in light of this change?
> >
> > I don't expect it to look any different. It's exactly the same as
> > growfs - thinspace filesystem will simply do a logical grow/shrink,
> > fat filesystems will need to do a physical grow/shrink
> > adding/removing AGs.
> >
> > I suspect Amir is worried about the fact that I put "LBA_size"
> > in geom.datablocks instead of "usable_space" for thin-aware
> > filesystems (i.e. I just screwed up writing the new patch). Like I
> > said, I haven't updated the userspace stuff yet, so the thinspace
> > side of that hasn't been tested yet. If I screwed up xfs_growfs (and
> > I have because some of the tests are reporting incorrect
> > post-grow sizes on fat filesytsems) I tend to find out as soon as I
> > run it.
> >
> > Right now I think using m_LBA_size and m_usable_space in the geom
> > structure was a mistake - they should remain the superblock values
> > because otherwise the hidden metadata reservations can affect what
> > is reported to userspace, and that's where I think the test failures
> > are coming from....
> >
> 
> I see. I suppose you intend to expose m_LBA_size in a new V5 geom value.
> (geom.LBA_blocks?)
> Does it make sense to expose the underlying bdev size in the same V5 geom
> value for fat fs?
> Does it make sense to expose yet another geom value for "total_blocks"?

Yes, yes and yes.

> The interpretation of former geom.datablocks will be "dblocks soft limit"

No. It is unchanged in meaning: "size of filesystem".

> The interpretation of new geom.LBA_blocks will be "dblocks hard limit"

No, it's not a hard limit. It's the "size of the filesystem on-disk
geometry".

> The interpretation of existing growfs will be "increase dblock soft limit",
> but only up to dblocks hard limit.

No. The interpretation is exactly as it is now: "grow filesystem
size to N", and the kernel then determines what combination of
logical (thin) grow and physical (i.e. modifying SB/AG geometry)
grow is required.

> This interpretation would be consistent for both thin and fat fs.

Which is exactly what I'm already providing, without trying to
redefine the interface and presenting an unneccessary different in
grow/shrink behaviour to users.

> A future API for physical shrink/grow can be deployed to change
> "dblocks hard limit", which may involve communicating with blockdev
> (e.g. LVM) via standard interface (i.e. truncate()/fallocate()) to shrink
> or grow it if volume is fat and to allocate/punch it if volume is thin.

We've already got "physical grow" - xfs-growfs queries the block
device for it's size, and passes that to the kernel to physically
grow the fs to that size. We don't need the in-kernel grow
implementation to do this right now.

If you want to add dynamic block device size controls in the
filesystem grow/shrink kernel implementation, then start by
providing the fs/block device implementation to let filesystems
implement that. Then we can worry about how to present that to
userspace through the filesystem, because we're going to have to
completely rethink the way grow/shrink operations are managed and
controlled from an admin perspsective.

This is not the time or place to be overcomplicating a simple
extension to an existing filesystem operation that is completely
transparent to existing users.


> I just feel like there may be opportunities to improve fs/volume management
> integration for fat fs/volumes as well, so we need to keep them in mind when
> designing the new APIs.

I think you're misunderstanding my intentions here: I'm not
designing a new fs/volume management API.  In fact, I'm working in
the opposite direction. I want to get rid of the need to integrate
filesystem and volume manager functionality so that things like thin
provisioning work sanely.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
