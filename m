Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49100 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934812AbdGTLwC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 07:52:02 -0400
Date: Thu, 20 Jul 2017 07:52:01 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH RFC] xfs: fix buffer check for primary sb in userspace
 libxfs
Message-ID: <20170720115159.GB3944@bfoster.bfoster>
References: <20170718141337.46255-1-bfoster@redhat.com>
 <20170718231202.GP17762@dastard>
 <20170719111741.GA53744@bfoster.bfoster>
 <20170720024855.GS17762@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170720024855.GS17762@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 20, 2017 at 12:48:55PM +1000, Dave Chinner wrote:
> On Wed, Jul 19, 2017 at 07:17:41AM -0400, Brian Foster wrote:
> > On Wed, Jul 19, 2017 at 09:12:02AM +1000, Dave Chinner wrote:
> > > On Tue, Jul 18, 2017 at 10:13:37AM -0400, Brian Foster wrote:
> > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > ---
> > > > 
> > > > Hi all,
> > > > 
> > > > This patch is actually targeted at userspace. The previous change in commit
> > > > f3d7ebde ("xfs: fix superblock inprogress check") to use ->b_maps technically
> > > > breaks the logic in userspace in a similar way to the original problem because
> > > > userspace has no concept of uncached buffers.  ->b_maps is NULL in userspace
> > > > unless the buffer is truly discontiguous.
> > > > 
> > > > This would normally result in a segfault but this appears to be hidden
> > > > by gcc optimization as -O2 is enabled by default and the
> > > > check_inprogress param to xfs_mount_validate_sb() is unused in
> > > > userspace. Therefore, the segfault is only reproducible when
> > > > optimization is disabled (which is a useful configuration for
> > > > debugging).
> > > > 
> > > > There are obviously different ways to fix this. I'm floating this (untested)
> > > > rfc as a kernel patch (do we ever sync libxfs from xfsprogs -> kernel?) with
> > > > the objective of keeping the libxfs code the same between the kernel and
> > > > userspace. We could alternatively create a custom helper/macro with the
> > > > appropriate check in each place. Thoughts?
> > > 
> > > Wouldn't it be better to simply fix the userspace buffer
> > > initialisation to always have a valid bp->b_maps, just like the
> > > kernel does? (See xfs_buf_get_maps() in the kernel code).  That way
> > > we don't have a landmine lurking in all the shared libxfs code we
> > > bring from the kernel that may interact with uncached buffers.
> > > 
> > 
> > We could certainly create a bp->__b_map field in xfsprogs libxfs and
> > initialize ->b_maps similar to the kernel for nmap == 1 buffers. Given
> > the lack of overlap of uncached buffers between xfsprogs and the kernel
> > (I'm not sure there are other cases where such buffers are commonly
> > handled), I don't personally think one way is notably better than the
> > other.
> > 
> > The tradeoffs seem to be that this patch is fairly localized but leaves
> > the potentially different states for uncached buffers in kernel vs.
> > xfsprogs context. The above approach addresses that issue at the cost of
> > slightly increasing the size of xfs_buf in userspace for something that
> > may not ever be necessary outside of an isolated bit of code. It also
> > only requires a change to xfsprogs libxfs.
> > 
> > Given the tradeoffs, I have no real preference on which approach we
> > take. Do you prefer the latter? If so and there are no other objections,
> > I'll send a patch along those lines.
> 
> I'd prefer the latter (the bp->__b_map solution) simply so we don't
> have to worry about it in future. The closer the kernel and
> userspace buffer caches are in terms of behaviour, implementation
> and structure members the less likely we are to have problems
> related to the kernel using uncached buffers...
> 
> FWIW, my wish list contains porting the kernel side buffer cache
> implementation to userspace to solve the scalabilty problems in the
> current userspace implementation that are exposed when repair
> hammers multiple AGs at once. Hence anything that gets kernel +
> userspace closer together helps get us (minutely) closer to that
> goal....
> 

Sounds reasonable to me. I'll post the xfsprogs __b_map patch I cooked
up and started testing yesterday a bit later...

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
