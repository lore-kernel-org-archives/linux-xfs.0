Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE42DC43381
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5E7664E2E
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 18:23:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233991AbhBWSXO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 13:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233981AbhBWSW7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Feb 2021 13:22:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4FC1C64E61;
        Tue, 23 Feb 2021 18:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614104538;
        bh=0k7ph56M6eE4UJfIfoCbA8rQNrb5IDiAYJFoaXPEttE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NSJ+qf3009oCLWIgY9Tkzj52C13tDuNmTzUvAIXqNJZYW2UnytNTyXl+GXn5uHK5U
         p2a+fJqSR8pf47IeCnweQ0ESrYh0OpgOMlduqntlgbpof8QoSOTd+vyF7jGddsDYMn
         kSCTie+bcodPKdnacQiHrUux0gt2XPbKPRm48OqecMHyyZKJx70DJJfGHMMgV6VqYC
         AlNEWjLOlRKFRg5RVi8qblgqY7ePHJfBP+cluaeIVyporvqzx+psaLtlR9+1U4w/Rr
         Gosa7vmH9LOXpTveN+cjjW81YR/YAD/YvFSFpvUTrIxFbJ5CLAyIGHHbMyBwweinMf
         xGIuj0FhzAOUw==
Date:   Tue, 23 Feb 2021 10:22:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't reuse busy extents on extent trim
Message-ID: <20210223182217.GL7272@magnolia>
References: <20210222153442.897089-1-bfoster@redhat.com>
 <20210222182745.GA7272@magnolia>
 <20210223123106.GB946926@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210223123106.GB946926@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 23, 2021 at 07:31:06AM -0500, Brian Foster wrote:
> On Mon, Feb 22, 2021 at 10:27:45AM -0800, Darrick J. Wong wrote:
> > On Mon, Feb 22, 2021 at 10:34:42AM -0500, Brian Foster wrote:
> > > Freed extents are marked busy from the point the freeing transaction
> > > commits until the associated CIL context is checkpointed to the log.
> > > This prevents reuse and overwrite of recently freed blocks before
> > > the changes are committed to disk, which can lead to corruption
> > > after a crash. The exception to this rule is that metadata
> > > allocation is allowed to reuse busy extents because metadata changes
> > > are also logged.
> > > 
> > > As of commit 97d3ac75e5e0 ("xfs: exact busy extent tracking"), XFS
> > > has allowed modification or complete invalidation of outstanding
> > > busy extents for metadata allocations. This implementation assumes
> > > that use of the associated extent is imminent, which is not always
> > > the case. For example, the trimmed extent might not satisfy the
> > > minimum length of the allocation request, or the allocation
> > > algorithm might be involved in a search for the optimal result based
> > > on locality.
> > > 
> > > generic/019 reproduces a corruption caused by this scenario. First,
> > > a metadata block (usually a bmbt or symlink block) is freed from an
> > > inode. A subsequent bmbt split on an unrelated inode attempts a near
> > > mode allocation request that invalidates the busy block during the
> > > search, but does not ultimately allocate it. Due to the busy state
> > > invalidation, the block is no longer considered busy to subsequent
> > > allocation. A direct I/O write request immediately allocates the
> > > block and writes to it.
> > 
> > I really hope there's a fstest case coming for this... :)
> > 
> 
> generic/019? :) I'm not sure of a good way to reproduce on demand given
> the conditions required to reproduce.

<nod> I guess you'd have to have a fs where extents take a long time to
exit the busy tree, and then set up the allocations and frees just
right.  FWIW I've never hit this in generic/019.

> > > Finally, the filesystem crashes while in a
> > > state where the initial metadata block free had not committed to the
> > > on-disk log. After recovery, the original metadata block is in its
> > > original location as expected, but has been corrupted by the
> > > aforementioned dio.
> > 
> > Wheee!
> > 
> > Looking at xfs_alloc_ag_vextent_exact, I guess the allocator will go
> > find a freespace record, call xfs_extent_busy_trim (which could erase
> > the busy extent entry), decide that it's not interested after all, and
> > bail out without restoring the busy entry.
> > 
> > Similarly, xfs_alloc_cur_check calls _busy_trim (same side effects) as
> > we wander around the free space btrees looking for a good chunk of
> > space... and doesn't restore the busy record if it decides to consider a
> > different extent.
> > 
> 
> Yep. I was originally curious whether the more recent allocator rework
> introduced this problem somehow, but AFAICT that just refactored the
> relevant allocator code and this bug has been latent in the existing
> code for quite some time. That's not hugely surprising given the rare
> combination of conditions required to reproduce.
> 
> > So I guess this "speculatively remove busy records and forget to restore
> > them" behavior opens the door to the write allocating blocks that aren't
> > yet free and nonbusy, right?  And the solution presented here is to
> > avoid letting go of the busy record for the bmbt allocation, and if the
> > btree split caller decides it really /must/ have that block for the bmbt
> > it can force the log and try again, just like we do for a file data
> > allocation?
> > 
> 
> Yes, pretty much. The metadata allocation that is allowed to safely
> reuse busy extents ends up invalidating a set of blocks during a NEAR
> mode search (i.e. bmbt allocation), but ends up only using one of those
> blocks. A data allocation immediately comes along next, finds one of the
> other invalidated blocks and writes to it. A crash/recovery leaves the
> invalidated busy block in its original metadata location having already
> been written to by the dio.
> 
> > Another solution could have been to restore the record if we decide not
> > to go ahead with the allocation, but as we haven't yet committed to
> > using the space, there's no sense in thrashing the busy records?
> > 
> 
> That was my original thought as well. Then after looking through the
> code a bit I thought that something like allowing the allocator to
> "track" a reusable, but still busy extent until allocation is imminent
> might be a bit more straightforward of an implementation given the
> layering between the allocator and busy extent tracking code. IOW, we'd
> split the busy trim/available and busy invalidate logic into two steps
> instead of doing it immediately in the busy trim path. That would allow
> the allocator to consider the same set of reusable busy blocks but not
> commit to any of them until the allocation search is complete.
> 
> However, either of those options require a bit of thought and rework
> (and perhaps some value proposition justification for the complexity)
> while the current trim reuse code is pretty much bolted on and broken.
> Therefore, I think it's appropriate to fix the bug in one step and
> follow up with a different implementation separately.

<nod> I'm not sure that's even worth the effort... :)

--D

> > Assuming I got all that right,
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> 
> Thanks.
> 
> Brian
> 
> > --D
> > 
> > 
> > > This demonstrates that it is fundamentally unsafe to modify busy
> > > extent state for extents that are not guaranteed to be allocated.
> > > This applies to pretty much all of the code paths that currently
> > > trim busy extents for one reason or another. Therefore to address
> > > this problem, drop the reuse mechanism from the busy extent trim
> > > path. This code already knows how to return partial non-busy ranges
> > > of the targeted free extent and higher level code tracks the busy
> > > state of the allocation attempt. If a block allocation fails where
> > > one or more candidate extents is busy, we force the log and retry
> > > the allocation.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_extent_busy.c | 14 --------------
> > >  1 file changed, 14 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> > > index 3991e59cfd18..ef17c1f6db32 100644
> > > --- a/fs/xfs/xfs_extent_busy.c
> > > +++ b/fs/xfs/xfs_extent_busy.c
> > > @@ -344,7 +344,6 @@ xfs_extent_busy_trim(
> > >  	ASSERT(*len > 0);
> > >  
> > >  	spin_lock(&args->pag->pagb_lock);
> > > -restart:
> > >  	fbno = *bno;
> > >  	flen = *len;
> > >  	rbp = args->pag->pagb_tree.rb_node;
> > > @@ -363,19 +362,6 @@ xfs_extent_busy_trim(
> > >  			continue;
> > >  		}
> > >  
> > > -		/*
> > > -		 * If this is a metadata allocation, try to reuse the busy
> > > -		 * extent instead of trimming the allocation.
> > > -		 */
> > > -		if (!(args->datatype & XFS_ALLOC_USERDATA) &&
> > > -		    !(busyp->flags & XFS_EXTENT_BUSY_DISCARDED)) {
> > > -			if (!xfs_extent_busy_update_extent(args->mp, args->pag,
> > > -							  busyp, fbno, flen,
> > > -							  false))
> > > -				goto restart;
> > > -			continue;
> > > -		}
> > > -
> > >  		if (bbno <= fbno) {
> > >  			/* start overlap */
> > >  
> > > -- 
> > > 2.26.2
> > > 
> > 
> 
