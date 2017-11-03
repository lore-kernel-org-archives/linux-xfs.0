Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35080 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756018AbdKCLgY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Nov 2017 07:36:24 -0400
Date: Fri, 3 Nov 2017 07:36:23 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171103113622.GB19974@bfoster.bfoster>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
 <20171102112533.GA15748@bfoster.bfoster>
 <20171102233017.GX5858@dastard>
 <20171103024740.GE4911@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171103024740.GE4911@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 07:47:40PM -0700, Darrick J. Wong wrote:
> On Fri, Nov 03, 2017 at 10:30:17AM +1100, Dave Chinner wrote:
> > On Thu, Nov 02, 2017 at 07:25:33AM -0400, Brian Foster wrote:
> > > On Thu, Nov 02, 2017 at 10:53:00AM +1100, Dave Chinner wrote:
> > > > On Wed, Nov 01, 2017 at 10:17:21AM -0400, Brian Foster wrote:
> > > > > On Wed, Nov 01, 2017 at 11:45:13AM +1100, Dave Chinner wrote:
> > > > > > On Tue, Oct 31, 2017 at 07:24:32AM -0400, Brian Foster wrote:
> > > > > > > On Tue, Oct 31, 2017 at 08:09:41AM +1100, Dave Chinner wrote:
> > > > > > > > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> > > > > > > > > On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > > > > > > > > > This patchset is aimed at filesystems that are installed on sparse
> > > > > > > > > > block devices, a.k.a thin provisioned devices. The aim of the
> > > > > > > > > > patchset is to bring the space management aspect of the storage
> > > > > > > > > > stack up into the filesystem rather than keeping it below the
> > > > > > > > > > filesystem where users and the filesystem have no clue they are
> > > > > > > > > > about to run out of space.
> > > > > > ....
> > > > > > > > I get that "total_blocks" sounds better, but to me that's a capacity
> > > > > > > > measurement, not an indication of the size of the underlying address
> > > > > > > > space the block device has provided. m_usable_blocks is obviously a
> > > > > > > > capacity measurement, but I was trying to convey that m_LBA_size is
> > > > > > > > not a capacity measurement but an externally imposed addressing
> > > > > > > > limit.
> > > > > > > > 
> > > > > > > > <shrug>
> > > > > > > > 
> > > > > > > > I guess if I document it well enough m_total_blocks will work.
> > > > > > > > 
> > > > > > > 
> > > > > > > Hmm, yeah I see what you mean. Unfortunately I can't really think of
> > > > > > > anything aside from m_total_blocks or perhaps m_phys_blocks at the
> > > > > > > moment.
> > > > > > 
> > > > > > m_phys_blocks seems closer to the intent. If that's acceptible I'll
> > > > > > change the code to that.
> > > > > > 
> > > > > 
> > > > > That works for me, thanks..
> > > > > 
> > > > > BTW, was there ever any kind of solution to the metadata block
> > > > > reservation issue in the thin case? We now hide metadata reservation
> > > > > from the user via the m_usable_blocks account. If m_phys_blocks
> > > > > represents a thin volume, how exactly do we prevent those metadata
> > > > > allocations/writes from overrunning what the admin has specified as
> > > > > "usable" with respect to the thin volume?
> > > > 
> > > > The reserved metadata blocks are not accounted from free space when
> > > > they are allocated - they are pulled from the reserved space that
> > > > has already been removed from the free space.
> > > > 
> > > 
> > > Ok, so the user can set a usable blocks value of something less than the
> > > fs geometry, then the reservation is pulled from that, reducing the
> > > reported "usable" value further. Hence, what ends up reported to the
> > > user is actually something less than the value set by the user, which
> > > means that the filesystem overall respects how much space the admin says
> > > it can use in the underlying volume.
> > > 
> > > For example, the user creates a 100T thin volume with 10T of usable
> > > space. The fs reserves a further 2T out of that for metadata, so then
> > > what the user sees is 8T of writeable space.  The filesystem itself
> > > cannot use more than 10T out of the volume, as instructed. Am I
> > > following that correctly? If so, that sounds reasonable to me from the
> > > "don't overflow my thin volume" perspective.
> > 
> > No, that's not what happens. For thick filesystems, the 100TB volume
> > gets 2TB pulled from it so it appears as a 98TB filesystem. This is
> > done by modifying the free block counts and m_usable_space when the
> > reservations are made.
> > 
> > For thin filesystems, we've already got 90TB of space "reserved",
> > and so the metadata reservations and allocations come from that.
> > i.e. we skip the modification of free block counts and m_usable
> > space in the case of a thinspace filesystem, and so the user still
> > sees 10TB of usable space that they asked to have.
> > 
> > > > i.e. we don't need to rev the interface to support shrink on thin
> > > > filesystems, so there's no need to rev the interface at this point
> > > > in time.
> > > > 
> > > > *If* we implement physical shrink, *then* we can rev the growfs
> > > > interface to allow users to run a physical shrink on thin
> > > > filesystems.
> > > > 
> > > 
> > > Subsequently, pretty much the remainder of my last mail is based on the
> > > following predicates:
> > > 
> > > - We've incorporated this change to use growfs->newblocks for logical
> > >   shrink.
> > > - We've implemented physical shrink.
> > > - We've revved the growfs interface to support physical shrink on thin
> > >   filesystems.
> > > 
> > > I'm not going to repeat all of the previous points... suffice it to say
> > > that asserting that we only have to rev the interface if/when we support
> > > physical shrink in response is a circular argument.
> > 
> > No, it's not.
> > 
> > History tells us that every time someone does this sort of "future
> > planning" for a fixed ABI interface they don't get it right. Hence
> > when that new functionality comes along the interface has to be
> > changed /again/ to fix whatever previous assumptions or requirements
> > were found to be invalid when development of the feature was
> > actually done.
> > 
> > The syscall and ioctl APIs are littered with examples and we should
> > pay heed to the lessons those mistakes teach us. i.e. don't
> > speculate about future API requirements for functionality that may
> > not exist or may change substantially from what it is envisiaged to
> > need right now.
> > 
> > > I understand that
> > > and I agree. I'm attempting to review how that would look due to the
> > > implementation of this feature, particularly with respect to backwards
> > > compatibility of the existing interface.
> > > 
> > > IOW, you're using the argument that we can rev the growfs interface in
> > > response to the initial argument regarding the the inability to
> > > physically shrink a thin fs.
> > 
> > Yes, because when we get physical shrink it is likely that the
> > growfs interface is going to need more than just a new set of flags.
> > 
> > Off the top of my head, we're going to new user-kernel co-ordination
> > requirements such as read-only AGs while we move data out of them in
> > a failsafe manner, interleave this with a whole new set of new
> > "cannot perform operation" cases, handle new partial failure cases,
> > restarting an interrupted shrink, and maybe even a need to ignore
> > partial state to complete a previously failed shrink.
> > 
> > And there's even the possibility that we're going to have to limit
> > physical shrink to rmap enabled filesystems (e.g. how do you find the
> > owner of that bmbt block that is pinning the AG we need to remove
> > without rmap?). At whcih point, a user might want to "force shrink"
> > and then take the filesystem down and run repair....
> > 
> > IOWs, to say all we are going to need from the growfs ioctl for a
> > physical shrink interface is a flag to to tell thin filesystems to
> > do a physical shrink is assuming an awful lot about the physical
> > shrinking implementation and how users will want to interact with
> > the operation. Until we've done all the design work and are well
> > into the implementation, we're not going to have a clue about what
> > we actually need in way of grwofs interface changes for the physical
> > shrink.
> > 
> > As such, trying to determine a future proof growfs interface change
> > right now is simply a waste of time because we're not going to get
> > it right.
> > 
> > > As a result, I'm claiming that revving the
> > > interface in the future for physical shrink may create more interface
> > > clumsiness than it's worth compared to just revving it now for logical
> > > shrink. In response to the points I attempt to make around that, you
> > > argue above that we aren't any closer to physical shrink than we were 10
> > > years ago and that we don't have to rev the interface unless we support
> > > physical shrink. Round and round... ;P
> > > 
> > > The best I can read into the response here is that you think physical
> > > shrink is unlikely enough to not need to care very much what kind of
> > > interface confusion could result from needing to rev the current growfs
> > > interface to support physical shrink on thin filesystems in the future.
> > > Is that a fair assessment..?
> > 
> > Not really. I understand just how complex a physical shrink
> > implementation is going to be, and have a fair idea of the sorts of
> > craziness we'll need to add to xfs_growfs to support/co-ordinate a
> > physical shrink operation.  From that perspective, I don't see a
> > physical shrink working with an unchanged growfs interface. The
> > discussion about whether or not we should physically shrink
> > thinspace filesystems is almost completely irrelevant to the
> > interface requirements of a physical shrink....
> 
> FWIW the way I've been modelling this patch series in my head is that we
> format an arbitrarily large filesystem (m_LBA_size) address space on a
> thinp, feed statfs an "adjusted" size (m_usable_size)i which restricts
> how much space we can allocate, and now growfs increases or decreases
> the adjusted size without having to relocate anything or mess with the
> address space.  If the adjusted size ever exceeds the address space
> size, then we tack on more AGs like we've always done.  From that POV,
> there's no need to physically shrink (i.e. relocate) anything (and we
> can leave that for later/never).
> 

Yeah, that's pretty much my exact perspective on how this feature would
work on the current interface. I don't contend that it wouldn't/couldn't
work with the current interface. It just seems to me that part of the
reason we're using that interface is simply because it's already there
as opposed to it necessarily being the right interface for the feature..

For example, suppose we had an absolute crude, barebones implementation
of physical shrink right now that basically trimmmed the amount of space
from the end of the fs iff those AGs were completely empty and otherwise
returned -EBUSY. There is no other userspace support, etc. As such, this
hypothetical feature is extremely limited to being usable immediately
after a growfs and thus probably has no use case other than "undo my
accidental growfs."

If we had that right now, _then_ what would the logical shrink interface
look like?

Brian

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
