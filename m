Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:34388 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932114AbdKAXxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2017 19:53:03 -0400
Date: Thu, 2 Nov 2017 10:53:00 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171101235300.GT5858@dastard>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171030133117.GA3535@bfoster.bfoster>
 <20171030210941.GA5858@dastard>
 <20171031112432.GA7093@bfoster.bfoster>
 <20171101004513.GK5858@dastard>
 <20171101141720.GB11709@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171101141720.GB11709@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Nov 01, 2017 at 10:17:21AM -0400, Brian Foster wrote:
> On Wed, Nov 01, 2017 at 11:45:13AM +1100, Dave Chinner wrote:
> > On Tue, Oct 31, 2017 at 07:24:32AM -0400, Brian Foster wrote:
> > > On Tue, Oct 31, 2017 at 08:09:41AM +1100, Dave Chinner wrote:
> > > > On Mon, Oct 30, 2017 at 09:31:17AM -0400, Brian Foster wrote:
> > > > > On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> > > > > > This patchset is aimed at filesystems that are installed on sparse
> > > > > > block devices, a.k.a thin provisioned devices. The aim of the
> > > > > > patchset is to bring the space management aspect of the storage
> > > > > > stack up into the filesystem rather than keeping it below the
> > > > > > filesystem where users and the filesystem have no clue they are
> > > > > > about to run out of space.
> > ....
> > > > I get that "total_blocks" sounds better, but to me that's a capacity
> > > > measurement, not an indication of the size of the underlying address
> > > > space the block device has provided. m_usable_blocks is obviously a
> > > > capacity measurement, but I was trying to convey that m_LBA_size is
> > > > not a capacity measurement but an externally imposed addressing
> > > > limit.
> > > > 
> > > > <shrug>
> > > > 
> > > > I guess if I document it well enough m_total_blocks will work.
> > > > 
> > > 
> > > Hmm, yeah I see what you mean. Unfortunately I can't really think of
> > > anything aside from m_total_blocks or perhaps m_phys_blocks at the
> > > moment.
> > 
> > m_phys_blocks seems closer to the intent. If that's acceptible I'll
> > change the code to that.
> > 
> 
> That works for me, thanks..
> 
> BTW, was there ever any kind of solution to the metadata block
> reservation issue in the thin case? We now hide metadata reservation
> from the user via the m_usable_blocks account. If m_phys_blocks
> represents a thin volume, how exactly do we prevent those metadata
> allocations/writes from overrunning what the admin has specified as
> "usable" with respect to the thin volume?

The reserved metadata blocks are not accounted from free space when
they are allocated - they are pulled from the reserved space that
has already been removed from the free space.

i.e. we can use as much or as little of the reserved space as we
want, but it doesn't affect the free/used space reported to
userspace at all.

> > > > > Finally, I tend to agree with Amir's comment with regard to
> > > > > shrink/growfs... at least infosar as I understand his concern. If we do
> > > > > support physical shrink in the future, what do we expect the interface
> > > > > to look like in light of this change?
> > > > 
> > > > I don't expect it to look any different. It's exactly the same as
> > > > growfs - thinspace filesystem will simply do a logical grow/shrink,
> > > > fat filesystems will need to do a physical grow/shrink
> > > > adding/removing AGs.
> > > > 
> > > 
> > > How would you physically shrink a thin filesystem?
> > 
> > You wouldn't. There should never be a need to do this because it a
> > thinspace shrink doesn't actually free any space - it's just a usage
> > limit. fstrim is what actually shrinks the storage space used,
> > regardless of the current maximum capcity of the thin filesystem.
> 
> In other words, the answer is that we can't physically shrink a thin fs
> because of a limitation on the growfs interface due to how we've used it
> here.

No, that is not the what I said. To paraphrase, what I said was "we
aren't going to support physically shrinking thin filesystems at
this point in time". That has nothing to do with the growfs API -
it's an implementation choice that reflects the fact we can't
physically shrink filesystems and that functionality is no closer to
being implemented than it was 10+ years ago.

i.e. we don't need to rev the interface to support shrink on thin
filesystems, so there's no need to rev the interface at this point
in time.

*If* we implement physical shrink, *then* we can rev the growfs
interface to allow users to run a physical shrink on thin
filesystems.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
