Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E011DFFB
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 22:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785794500; cv=none; b=Tv+HrQelKhD8YR6xPsvnH+r2mKFJVpGfoHar+P3A1DzPfx1Sh51BLC8KrChgyzn5L2cMFBQVK59ZJEWdLgi63E0ucAZZEyrr71TavJ3Ms3XMg1Epx7UNVww9gKNKRbifx+BJxzpznHlrF+Ei5EqMLXSeha3DLtumAJsl55CGglA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785794500; c=relaxed/simple;
	bh=wt7wdwpAXtygnHQgrtWx31t1Uxk0Gs/fMh8PKGN4aUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQq6m+IZ9RFuTDAskxjpjdLQOrjzIiTPMd/A7NYBGmW3M0S5zdf1ZT3tPAiIycH+Mzle2Lmp92bEpZjYQMUZhseqVf2bkyxrC4RClDcKKcxudv62z5e1jDN4tIUdQthNR920pQqKD7KqFMF0d2goXFA6iDw/7iXO3ZlfZT9t3N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GBi4dkXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GBi4dkXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76551F000E9;
	Mon,  3 Aug 2026 22:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785794498;
	bh=XUdcNrSa/DTKPEYouqnzV6n8Dlr8yNLN4Tcsbnz58G4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GBi4dkXMYbOfkoMPZY3cf1nvi2qvpBmz6FDJfy2M9+Tk+Z4jbn56MJ5iY+yZcrKpd
	 K7dARNgCIMHM2Y7EOCVX3f41OMY21s35fhIRXO277tBzf2YyV38MZwDVWaf1JHZ9NH
	 bwBKvtSeZkUSnoU0zGOnh4Qi3inRw6SKXnM5Nz69wA1wmOT+vtVy/swIxfzwa2fmBt
	 IRklzfXI6RfVJ3ZZ8iT+bGureNEGXvAuPkBUh6/0TXYdWf+FO5uk19v//W5kfGpxdh
	 UcQb7kYk39aTsr5vEKL2qMtsYaKRRdRQ95b3oRrfddW+rj13IsUnBMdDBlVd29Ss9X
	 O5Xx7qORy9IKw==
Date: Tue, 4 Aug 2026 08:01:30 +1000
From: Dave Chinner <dgc@kernel.org>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH 2/2] xfs: consistent low ag space behavior for sparse
 inode chunk allocs
Message-ID: <anEPukpCKlxRxACR@dread>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-3-bfoster@redhat.com>
 <am05vzAntuhAKXgr@dread>
 <anDYdgP6y2537cY_@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anDYdgP6y2537cY_@bfoster>

On Mon, Aug 03, 2026 at 02:05:42PM -0400, Brian Foster wrote:
> On Sat, Aug 01, 2026 at 10:11:43AM +1000, Dave Chinner wrote:
> > On Fri, Jul 31, 2026 at 12:33:37PM -0400, Brian Foster wrote:
> > > Matt Fleming reports a filesystem shutdown due to inobt block
> > > allocation failure during sparse chunk allocation. Inode creation
> > > can involve multiple allocations in a transaction via the initial
> > > chunk allocation and inode btree growth via the subsequent inobt
> > > record insertion. Technically this should be safe as the chunk
> > > allocation sets the allocation minleft parameter to the max depth of
> > > the inode btree, which means the allocation selects an AG only if
> > > there is enough free space for record insertion after the
> > > allocation. The record insertion naturally occurs in the same AG as
> > > the allocation and the associated AGF is locked and held by the
> > > current transaction.

[snip]

> > i.e. if minleft != 0, then the agfl btree block reservations need to
> > be done for (current level + 1) to take into account space for the
> > trees to split during the dependent allocation chain that minleft !=
> > 0 implies is about to occur.
> > 
> 
> Ok, this more aligns with what the LLM had suggested, at least in terms
> of fixing the problem at the first AGFL check via the minfree
> calculation. IIRC it wanted to bump minleft internally and that came out
> rather uglier than bumping min_free (as below).

Yeah, sounds pretty normal LLM analysis -> fix progression to me.

IME, LLMs often get close to the right solution, but they lack the
subject matter expertise and/or the deep abstract thinking needed to
understand that the problem is in the underlying behavioural
constraints rather than the context triggering the issue.

Hence they output hacks to address the symptom the problematic
context displays rather than a proper fix for the underlying
issue...

> > This isn't an issue just for inobt/finobt blocks on inode chunk
> > alloc, it's also an issue for anything that sets minleft for a
> > dependent, multi-allocation operation (e.g. data extent allocation +
> > BMBT block allocation). 
> > 
> 
> Yeah, I noticed we had a handful of other cases that use minleft like
> this. I wonder if the main reason we don't hit this from the bmapi path
> is that it's usually open to multiple AGs for bmbt allocs and not fixed
> to a single AG like inode chunk and corresponding inobt block allocs
> obviously are.

*nod* Seems likely to me.

Also, data extent allocations often have slop in them for alignment
on top of the minleft value, so I suspect that AGFL reservation
growth could be hidden by the alignment slop that was reserved but
not used.

> > So from this perspective, I think the fix needs to be made to the
> > calculation in xfs_alloc_min_freelist() to take into account minleft
> > needing a larger AGFL reservation if any of the allocations in the
> > chain splits.
> > 
> > Hmmmm. I'm not sure the calculation in xfs_alloc_min_freelist() is
> > correct, either:
> > 
> >         /*
> >          * For a btree shorter than the maximum height, the worst case is that
> >          * every level gets split and a new level is added, then while inserting
> >          * another entry to refill the AGFL, every level under the old root gets
> >          * split again. This is:
> >          *
> >          *   (full height split reservation) + (AGFL refill split height)
> >          * = (current height + 1) + (current height - 1)
> >          * = (new height) + (new height - 2)
> >          * = 2 * new height - 2
> > 
> > i.e. I think the AGFL refill split height is wrong.
> > 
> > Look at it this way: we do the AGFL refill -first-, so if that
> > splits, we consume (current height + 1) blocks, and then new_height
> > = (current height + 1). Then if the actual data allocation does a
> > full split again (i.e. all except for the root block), that needs
> > (new_height -1) blocks. So that becomes:
> > 
> > 	new_height = current height + 1;
> > 	blocks = new_height + (new_height - 1)
> > 	       = 2 * new_height - 1.
> > 
> > IOWs, I think there's an existing off-by one in the AGFL btree block
> > reservation calculation that contributes to this problem as well.
> > 
> 
> Hmm.. I need to stare at this a little more, but I think that makes
> sense.

I've thought on it a bit more, too, and I now realise the original
code is correct. 

I failed to take into account that we can't split the two blocks the
old root was split into again - they will be at 50% capacity after
the first split, so a split up to one of their child nodes will only
add one more ptr to them. They can't fill and split again in the
current transaction chain.

Hence the second split can only occur up to (current height - 1),
and so the existing calculation is correct.

[snip]

> I think this is reasonable. The thing that stands out a little bit is
> that technically we're reserving for the worst case min_free allocation
> requirement of the second alloc, not necessarily the actual number of
> blocks needed, right? That seems fine if so. I just want to make sure
> we're clear and we document the updated calculation appropriately (i.e.
> noting how minleft > 0 is a somewhat special case).
>
> The off-by-one thing aside, IIUC the current min_free calculation
> correctly accounts the actual number of blocks we'd consume in the worst
> case for both allocations, it just doesn't account for how the min_free
> requirements change upon reentry into the allocator after a minleft > 0
> allocation.

Right, that's my understanding of the issue - that min_free is an up
front worst case reservation to prevent downstream ENOSPC within the
AG during the transactional modification that is about to take
place.

i.e. it's taken over 30 years for us to realise that the AGFL
reservation could change in the middle of a multi-allocation
transaction and that the minfree calc has never taken that into
account. i.e. this is yet another zero-day bug in the AGFL fixup
code...

Cheers,

Dave.
-- 
Dave Chinner
dgc@kernel.org
