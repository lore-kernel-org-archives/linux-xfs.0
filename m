Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56374 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdJ3NbS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:31:18 -0400
Date: Mon, 30 Oct 2017 09:31:17 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC PATCH 0/14] xfs: Towards thin provisioning aware filesystems
Message-ID: <20171030133117.GA3535@bfoster.bfoster>
References: <20171026083322.20428-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026083322.20428-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 07:33:08PM +1100, Dave Chinner wrote:
> This patchset is aimed at filesystems that are installed on sparse
> block devices, a.k.a thin provisioned devices. The aim of the
> patchset is to bring the space management aspect of the storage
> stack up into the filesystem rather than keeping it below the
> filesystem where users and the filesystem have no clue they are
> about to run out of space.
> 

Just a few high level comments/thoughts after a very quick pass..

...
> The patchset has several parts to it. It is built on a 4.14-rc5
> kernel with for-next and Darrick's scrub tree from a couple of days
> ago merged into it.
> 
> The first part of teh series is a growfs refactoring. This can
> probably stand alone, and the idea is to move the refactored
> infrastructure into libxfs so it can be shared with mkfs. This also
> cleans up a lot of the cruft in growfs and so makes it much easier
> to add the changes later in the series.
> 

It'd be nice to see this as a separate patchset. It does indeed seem
like it could be applied before all of the other bits are worked out.

> The second part of the patchset moves the functionality of
> sb_dblocks into the struct xfs_mount. This provides the separation
> of address space checks and capacty related calculations that the
> thinspace mods require. This also fixes the problem of freshly made,
> empty filesystems reporting 2% of the space as used.
> 

This all seems mostly sane to me. FWIW, the in-core fields (particularly
->m_LBA_size) strike me as oddly named. "LBA size" strikes me as the
addressable range of the underlying device, regardless of fs size (but I
understand that's not how it's used here). If we have ->m_usable_blocks,
why not name the other something like ->m_total_blocks or just
->m_blocks? That suggests to me that the fields are related, mutable,
accounted in units of blocks, etc. Just a nit, though.

That aside, it also seems like this part could technically stand as an
independent change. 

> The XFS_IOC_FSGEOMETRY ioctl needed to be bumped to a new version
> because the structure needed growing.
> 
> Finally, there's the patches that provide thinspace support and the
> growfs mods needed to grow and shrink.
> 

I still think there's a gap related to fs and bdev block size that needs
to be addressed with regard to preventing pool depletion, but I think
that can ultimately be handled with documentation. I also wonder a bit
about consistency between online modifications to usable blocks and fs
blocks that might have been allocated but not yet written (i.e.,
unwritten extents and the log on freshly created filesystems). IOW,
shrinking the filesystem in such cases may not limit pool allocation in
the way a user might expect.

Did we ever end up with support for bdev fallocate? If so, I wonder if
for example it would be useful to fallocate the physical log at mount or
mkfs time for thin enabled fs'. The unwritten extent case may just be a
matter of administration sanity since the filesystem shrink will
consider those as allocated blocks and thus imply that the fs expects
the ability to write them.

Finally, I tend to agree with Amir's comment with regard to
shrink/growfs... at least infosar as I understand his concern. If we do
support physical shrink in the future, what do we expect the interface
to look like in light of this change? FWIW, I also think there's an
element of design/interface consistency to the argument (aside from the
concern over the future of the physical shrink api). We've separated
total blocks from usable blocks in other userspace interfaces
(geometry). Not doing so for growfs is somewhat inconsistent, and also
creates confusion over the meaning of newblocks in different contexts.

Given that this already requires on-disk changes and the addition of a
feature bit, it seems prudent to me to update the growfs API
accordingly. Isn't a growfs new_usable_blocks field or some such all we
really need to address that concern?

Brian

> I've smoke tested the non-thinspace code paths (running auto tests
> on a scrub enabled kernel+userspace right now) as I haven't updated
> the userspace code to exercise the thinp code paths yet. I know the
> concept works, but my userspace code has an older on-disk format
> from the prototype so it will take me a couple of days to update and
> work out how to get fstests to integrate it reliably. So this is
> mainly a heads-up RFC patchset....
> 
> Comments, thoughts, flames all welcome....
> 
> Cheers,
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
