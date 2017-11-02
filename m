Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32892 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750758AbdKBLZf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 2 Nov 2017 07:25:35 -0400
Date: Thu, 2 Nov 2017 07:25:33 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171102112533.GA15748@bfoster.bfoster>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
 <20171101235300.GT5858@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101235300.GT5858@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2017 at 10:53:00AM +1100, Dave Chinner wrote:
> On Wed, Nov 01, 2017 at 10:17:21AM -0400, Brian Foster wrote:
> > On Wed, Nov 01, 2017 at 11:45:13AM +1100, Dave Chinner wrote:
> > > On Tue, Oct 31, 2017 at 07:24:32AM -0400, Brian Foster wrote:
> > > > On Tue, Oct 31, 2017 at 08:09:41AM +1100, Dave Chinner wrote:
> > > > > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> > > > > > On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > > > > > > This patchset is aimed at filesystems that are installed on sparse
> > > > > > > block devices, a.k.a thin provisioned devices. The aim of the
> > > > > > > patchset is to bring the space management aspect of the storage
> > > > > > > stack up into the filesystem rather than keeping it below the
> > > > > > > filesystem where users and the filesystem have no clue they are
> > > > > > > about to run out of space.
> > > ....
> > > > > I get that "total_blocks" sounds better, but to me that's a capacity
> > > > > measurement, not an indication of the size of the underlying address
> > > > > space the block device has provided. m_usable_blocks is obviously a
> > > > > capacity measurement, but I was trying to convey that m_LBA_size is
> > > > > not a capacity measurement but an externally imposed addressing
> > > > > limit.
> > > > > 
> > > > > <shrug>
> > > > > 
> > > > > I guess if I document it well enough m_total_blocks will work.
> > > > > 
> > > > 
> > > > Hmm, yeah I see what you mean. Unfortunately I can't really think of
> > > > anything aside from m_total_blocks or perhaps m_phys_blocks at the
> > > > moment.
> > > 
> > > m_phys_blocks seems closer to the intent. If that's acceptible I'll
> > > change the code to that.
> > > 
> > 
> > That works for me, thanks..
> > 
> > BTW, was there ever any kind of solution to the metadata block
> > reservation issue in the thin case? We now hide metadata reservation
> > from the user via the m_usable_blocks account. If m_phys_blocks
> > represents a thin volume, how exactly do we prevent those metadata
> > allocations/writes from overrunning what the admin has specified as
> > "usable" with respect to the thin volume?
> 
> The reserved metadata blocks are not accounted from free space when
> they are allocated - they are pulled from the reserved space that
> has already been removed from the free space.
> 

Ok, so the user can set a usable blocks value of something less than the
fs geometry, then the reservation is pulled from that, reducing the
reported "usable" value further. Hence, what ends up reported to the
user is actually something less than the value set by the user, which
means that the filesystem overall respects how much space the admin says
it can use in the underlying volume.

For example, the user creates a 100T thin volume with 10T of usable
space. The fs reserves a further 2T out of that for metadata, so then
what the user sees is 8T of writeable space. The filesystem itself
cannot use more than 10T out of the volume, as instructed. Am I
following that correctly? If so, that sounds reasonable to me from the
"don't overflow my thin volume" perspective.

> i.e. we can use as much or as little of the reserved space as we
> want, but it doesn't affect the free/used space reported to
> userspace at all.
> 
> > > > > > Finally, I tend to agree with Amir's comment with regard to
> > > > > > shrink/growfs... at least infosar as I understand his concern. If we do
> > > > > > support physical shrink in the future, what do we expect the interface
> > > > > > to look like in light of this change?
> > > > > 
> > > > > I don't expect it to look any different. It's exactly the same as
> > > > > growfs - thinspace filesystem will simply do a logical grow/shrink,
> > > > > fat filesystems will need to do a physical grow/shrink
> > > > > adding/removing AGs.
> > > > > 
> > > > 
> > > > How would you physically shrink a thin filesystem?
> > > 
> > > You wouldn't. There should never be a need to do this because it a
> > > thinspace shrink doesn't actually free any space - it's just a usage
> > > limit. fstrim is what actually shrinks the storage space used,
> > > regardless of the current maximum capcity of the thin filesystem.
> > 
> > In other words, the answer is that we can't physically shrink a thin fs
> > because of a limitation on the growfs interface due to how we've used it
> > here.
> 
> No, that is not the what I said. To paraphrase, what I said was "we
> aren't going to support physically shrinking thin filesystems at
> this point in time". That has nothing to do with the growfs API -
> it's an implementation choice that reflects the fact we can't
> physically shrink filesystems and that functionality is no closer to
> being implemented than it was 10+ years ago.
> 

And I'm attempting to examine the ramifications of the decision to reuse
the physical shrink interface for logical shrink. IOW, we can decide
whether or not to allow physical shrink of a thin fs independent from
designing an interface that is capable of supporting it. Just like we
already have an interface that supports physical shrink, even though it
obviously doesn't work.

> i.e. we don't need to rev the interface to support shrink on thin
> filesystems, so there's no need to rev the interface at this point
> in time.
> 
> *If* we implement physical shrink, *then* we can rev the growfs
> interface to allow users to run a physical shrink on thin
> filesystems.
> 

Subsequently, pretty much the remainder of my last mail is based on the
following predicates:

- We've incorporated this change to use growfs->newblocks for logical
  shrink.
- We've implemented physical shrink.
- We've revved the growfs interface to support physical shrink on thin
  filesystems.

I'm not going to repeat all of the previous points... suffice it to say
that asserting that we only have to rev the interface if/when we support
physical shrink in response is a circular argument. I understand that
and I agree. I'm attempting to review how that would look due to the
implementation of this feature, particularly with respect to backwards
compatibility of the existing interface.

IOW, you're using the argument that we can rev the growfs interface in
response to the initial argument regarding the the inability to
physically shrink a thin fs. As a result, I'm claiming that revving the
interface in the future for physical shrink may create more interface
clumsiness than it's worth compared to just revving it now for logical
shrink. In response to the points I attempt to make around that, you
argue above that we aren't any closer to physical shrink than we were 10
years ago and that we don't have to rev the interface unless we support
physical shrink. Round and round... ;P

The best I can read into the response here is that you think physical
shrink is unlikely enough to not need to care very much what kind of
interface confusion could result from needing to rev the current growfs
interface to support physical shrink on thin filesystems in the future.
Is that a fair assessment..?

Brian

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
