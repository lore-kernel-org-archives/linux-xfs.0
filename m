Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D81D51B
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 06:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yinq9zLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61652C433C7;
	Wed, 29 Nov 2023 06:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701238700;
	bh=CEg5DBhZE2WoI2xl29XuomfbDllLcCxZd/om6+Jdqbk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yinq9zLDvgHy9JwtGPnrfluwJo7I0iISvyly2qEjNt5FQGBrCaGIT2aV+TOoI5aEE
	 nhc2sK18XhLaG/aybhjeTolUI7YFTZjAw1umhoMIi48iFV2GaSmYKs8b1jZLhBqYfY
	 07GrAJ7cflrw29ZvqA3P9v+jqeAJp6MfpLNtmMjc8XzS/7I8UCSrom1SjysfpDuXih
	 rK9W5cxgmC/v7xfiDzvla4kPxOV1elvVJTuyycda2L84exOPM6FaehjZp9EfdDujAc
	 YnazkhJvq860bpE5MfE4Ut+MOosC6MFQKvaV4PrKjt1YllLBZ5OEU31NK7xXNeCkVy
	 DuYMaLysnHDvw==
Date: Tue, 28 Nov 2023 22:18:19 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: repair free space btrees
Message-ID: <20231129061819.GA361584@frogsfrogsfrogs>
References: <170086926983.2770967.13303859275299344660.stgit@frogsfrogsfrogs>
 <170086927042.2770967.1697193414262580501.stgit@frogsfrogsfrogs>
 <ZWYDASlIqLQvk9Wh@infradead.org>
 <20231128211358.GB4167244@frogsfrogsfrogs>
 <ZWbSq7591xG1I+SQ@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWbSq7591xG1I+SQ@infradead.org>

On Tue, Nov 28, 2023 at 09:56:59PM -0800, Christoph Hellwig wrote:
> On Tue, Nov 28, 2023 at 01:13:58PM -0800, Darrick J. Wong wrote:
> > >  - xrep_abt_find_freespace accounts the old allocbt blocks as freespace
> > >    per the comment, although as far as I understand  the code in
> > >    xrep_abt_walk_rmap the allocbt blocks aren't actually added to the
> > >    free_records xfarray, but recorded into the old_allocbt_blocks
> > >    bitmap (btw, why are we using different data structures for them?)
> > 
> > The old free space btree blocks are tracked via old_allocbt_blocks so
> > that we can reap the space after committing the new btree roots.
> 
> Yes, I got that from the code.  But I'm a bit confused about the
> comment treating the old allocbt blocks as free space, while the code
> doesn't.  Or I guess the confusion is that we really have two slightly
> different notions of "free space":
> 
>   1) the space we try to build the trees for
>   2) the space used as free space to us for the trees
> 
> The old allocbt blocks are part of 1 but not of 2.

Yeah.  The blocks for #2 only come from the gaps in the rmapbt records
that we find during the scan.

Part of the confusion here might be the naming -- at the end of the
rmapbt scan, old_allocbt_blocks is set to all the blocks that the rmapbt
says are OWN_AG.  Each rmapbt block encountered during the scan is added
to not_allocbt_blocks, and afterwards each block on the AGFL is also
added to not_allocbt_blocks.

After that is where the definitions of old_allocbt_blocks shifts.
This expression will help us to identify possible former bnobt/cntbt
blocks:

	(OWN_AG blocks) & ~(rmapbt blocks | agfl blocks);

Substituting from above definitions, that becomes:

	old_allocbt_blocks & ~not_allocbt_blocks

The OWN_AG bitmap itself isn't needed after this point, so what we
really do instead is:

	old_allocbt_blocks &= ~not_allocbt_blocks;

IOWs, after this point, "old_allocbt_blocks" is a bitmap of alleged
former bnobt/cntbt blocks.  The xagb_bitmap_disunion operation modifies
its first parameter in place to avoid copying records around.

The gaps (aka the new freespace records) are stashed in the free_records
xfarray.  Next, some of the @free_records are diverted to the newbt
reservation and used to format new btree blocks.

I hope that makes things clearer?

> > >  - what happens if the AG is so full and fragmented that we do not
> > >    have space to create a second set of allocbts without tearing down
> > >    the old ones first?
> > 
> > xrep_abt_reserve_space returns -ENOSPC, so we throw away all the incore
> > records and throw the errno out to userspace.  Across all the btree
> > rebuilding code, the block reservation step happens as the very last
> > thing before we start writing btree blocks, so it's still possible to
> > back out cleanly.
> 
> But that means we can't repair the allocation btrees for this case.

Yep.  At least we revert cleanly here -- when that happens to
xfs_repair it just blows up and leaves a dead fs. :/

Practically speaking, the rmapbt reservations are large enough that we
can rebuild the trees if we have to, even if that just means stealing
from the per-AG space reservations later.

Though you could create the fs from hell by using reflink and cow to
fragmenting the rmapbt until it swells up and consumes the entire AG.
That would require billions of fragments; even with my bmap inflation
xfs_db commands that still takes about 2 days to get the rmapbt to the
point of overflowing the regular reservation.

I tried pushing it to eat an entire AG but then the ILOM exploded and no
idea what happened to that machine and its 512G of RAM.  The lab people
kind of hate me now.

> > > > +	/* We require the rmapbt to rebuild anything. */
> > > > +	if (!xfs_has_rmapbt(mp))
> > > > +		return -EOPNOTSUPP;
> > > 
> > > Shoudn't this be checked by the .has callback in struct xchk_meta_ops?
> > 
> > No.  Checking doesn't require the rmapbt because all we do is walk the
> > bnobt/cntbt records and cross-reference them with whatever metadata we
> > can find.
> 
> Oh, and .has applies to both checking and repairing.  Gt it.

Correct.

> > This wrapper simplifes the interface to xrep_newbt_add_blocks so that
> > external callers don't have to know which magic values of xfs_alloc_arg
> > are actually used by xrep_newbt_add_blocks and therefore need to be set.
> > 
> > For all the other repair functions, they have to allocate space from the
> > free space btree, so xrep_newbt_add_blocks is passed the full
> > _alloc_args as returned by the allocator to xrep_newbt_alloc_ag_blocks.
> 
> Ok.  Maybe throw in a comment that it just is a convenience wrapper?

Will do.

--D
