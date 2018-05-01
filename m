Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:38090 "EHLO
        ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750743AbeEAWlf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 18:41:35 -0400
Date: Wed, 2 May 2018 08:39:52 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH] xfs: skip discard of unwritten extents
Message-ID: <20180501223952.GX23861@dastard>
References: <20180426180624.6134-1-bfoster@redhat.com>
 <20180430220020.GE13766@dastard>
 <20180501173815.GJ4525@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180501173815.GJ4525@bfoster.bfoster>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Tue, May 01, 2018 at 01:38:15PM -0400, Brian Foster wrote:
> On Tue, May 01, 2018 at 08:00:20AM +1000, Dave Chinner wrote:
> > On Thu, Apr 26, 2018 at 02:06:24PM -0400, Brian Foster wrote:
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Hi all,
> > > 
> > > What do folks think of something like this?
> > 
> > Definitely sounds like something we need to address.
> > 
> > > The motivation here is that
> > > the VDO (dedup) devs had reported seeing online discards during
> > > write-only workloads. These turn out to be related to trimming post-eof
> > > preallocation blocks after large file copies. To my knowledge, this
> > > isn't really a prevalent or serious issue, but I think that technically
> > > these discards are unnecessary and so I was looking into how we could
> > > avoid them.
> > 
> > We simply trucate post-eof extents, right? So we know in
> > xfs_itruncate_extents() if the inode size is changing, not to
> > mention we know if the extent is beyond EOF? e.g. all calls to
> > xfs_itruncate_extents() other than xfs_free_eofblocks() change the
> > inode size and so directly indicate they are removing written
> > blocks. Anything where the inode size is not changing is doing a
> > post-eof removal, and so we can assume no data has been written?
> > 
> 
> Yes, xfs_free_eofblocks() is the only caller explicitly responsible for
> trimming post-eof extents.
> 
> > So rather than converting everything to unwritten extents, the "skip
> > discard flag" is simply triggered via extents being freed sitting
> > beyond the current EOF (not the new EOF) and/or being unwritten?
> > 
> 
> That was pretty much my initial thought, but note that the extent free
> is ultimately deferred down in xfs_free_eofblocks() ->
> xfs_itruncate_extents() -> xfs_bunmapi() -> xfs_bmap_del_extent_real()
> -> xfs_bmap_add_free(). We can communicate this down to that point with
> an itruncate_extents() parameter and XFS_BMAPI_NODISCARD flag or some
> such, it just seemed a bit kludgy to pass that down through those layers
> when the unwritten state is known in the bunmapi code (but I'll take
> that approach if preferred).

Hmmm - don't we already pass the XFS_BMAPI* flags to
xfs_bmap_del_extent_real()? If so, I don't think there's anything
extra that needs plumbing here. Conceptually it seems cleaner to me
to direct extent freeing policy through the bmapi interface flags
than it is add another flag interface elsewhere...

> > > This behavior is of course not directly related to unwritten extents,
> > > but the immediate/obvious solution to bubble up a bmapi flag of some
> > > kind to xfs_free_eofblocks() seemed rather crude. From there, I figured
> > > that we technically don't need to discard any unwritten extents (within
> > > or beyond EOF) because they haven't been written to since being
> > > allocated. In fact, I'm not sure we have to even busy them, but it's
> > > roughly equivalent logic either way and I'm trying to avoid getting too
> > > clever.
> > 
> > I think we still need to busy them to avoid re-allocating them in
> > the same checkpoint, as data extent free/realloc in the same
> > checkpoint could result in a failed recovery (i.e. partial
> > checkpoint replay) leaving the extent linked into two separate
> > files.
> > 
> 
> Ah, Ok.. I was only thinking about metadata/data reuse. Hm, isn't the
> filesystem essentially corrupted on a failed/partial recovery anyways?
> (Not that this matters much in this context, I wasn't planning to bypass
> the busy sequence...).

Yeah, the filesystem will be metadata corrupt, but IIUC skipping the
busy extent state and multiply linking data extents will make it
worse because repair just throws away multiply linked data extents.
i.e. partial log recovery could cause valid user data that should
have been left at rest to be thrown away by repair.

> > > I also recall that we've discussed using unwritten extents for delalloc
> > > -> real conversion to avoid the small stale data exposure window that
> > > exists in writeback. Without getting too deep into the reason we don't
> > > currently do an initial unwritten allocation [1], I don't think there's
> > > anything blocking us from converting any post-eof blocks that happen to
> > > be part of the resulting normal allocation. As it is, the imap is
> > > already trimmed to EOF by the writeback code for coherency reasons. If
> > > we were to convert post-eof blocks (not part of this patch) along with
> > > something like this patch, then we'd indirectly prevent discards for
> > > eofblocks trims.
> > 
> > I think we should leave that as a separate problem, as writeback
> > currently has issues with the way we manage bufferhead state.
> > i.e. things don't work right if we put unwritten extents under
> > delalloc buffers and vice versa. [ I have patches to address that
> > I'm working on.] And there's also the issue that we need to change
> > the delalloc reservations to take into account block allocations
> > required by unwritten extent conversion needed by delalloc.
> > 
> 
> Right.. I wasn't planning to try and solve the whole buffer head state
> mismatch thing as a dependency to not discard eofblocks. I was only
> going to convert blocks that happened to be post-eof after the
> xfs_iomap_write_allocate() allocation because those blocks by definition
> don't have buffers. So it's essentially just another xfs_bmapi_write()
> call from xfs_iomap_write_allocate() to convert eofblocks if the just
> allocated mapping crosses eof.

I think it's a bit more complex than that. We have delalloc buffers
in memory beyond the on disk EOF (i.e. in-memory EOF is far beyond
on disk EOF) but when we do the allocation we would have to mark the
entire extent covering beyond the current IO past the on-disk EOF as
unwritten. Hence the range between the on-disk EOF and the in-memory
EOF ends up with unwritten extents under a delalloc range. Now our
IO completion needs to be different for the next IO beyond EOF,
because it needs to do unwritten completion, not just a file size
update. This is currently problematic because we use the "buffer
head is delalloc" state to determine the IO completion action, not
the on disk extent state.

We could solve this with the current code, but it just gets complex
(even more so than what we have now). I'd much prefer we change over
to doing allocation based on the extent tree state (the patches I
have) rather than bufferhead state first, and then the change to
using unwritten extents for delalloc ranges is nice and
simple...

> > Hence I think we should address that as a separate problem, not as
> > the solution to avoiding discard of post-eof extents.
> > 
> 
> Fair enough, I'll look into tacking on a separate patch to also skip
> discards for unwritten extents (irrespective of eof).

Awesome!

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
