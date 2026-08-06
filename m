Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82D12E92B3
	for <linux-xfs@vger.kernel.org>; Thu,  6 Aug 2026 13:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786021299; cv=none; b=Fk8+m+f1Sf09zl1P3cIiO5n5vhvPQdMEx1EIexZjAi4L81NzmF560mQ7YhSjLVkryWj/JjmJ0I+JYa5AJgysfm0o04/mwoyiJ2KEnhlFq3o9Zh88mGDYbVzMf5205ffwz9bswaquRpNjnHI/07/TimrhkyB1Jay/jHR0/Hu2xB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786021299; c=relaxed/simple;
	bh=d1CdzCnaSdJxzBUt0/dW+gNyNTn/5Hse5SBjV8Nnhio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VKyHJYExfJWuky9JcqEQ5PNTMZx+aV9eF2p08G9MN+QBV7MuI4ifNUK6wF3kfhK+T4U3a4Sfp38iIMf2pbXed7+WJtFZ2pKzuPk0VM1sodOD9O4cJaq9/HphtDo7xkG5ZG2W1zJbyksQRe4WkIPIPXIxcR7MQxE+M+CTd1vQerE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jR+7GgNo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jR+7GgNo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786021293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fUQi8UKzMf88pGvqybSSw9NxZjLFayDmQpA7WaLayvA=;
	b=jR+7GgNo6J4CtFs56gg51xAkf5UtRVtWJpKfxb3xDwIRc1vl9q3Wk0Iow56osDrJCHzGoF
	PGsnkwKNTxZ0d/mFDTNui9uFz/YGF93VR8z9Uh2SMr84HrUTuY3y5GhTxC68/+9x22JO8O
	8Cr4OMJiU04myri/PobQP5+fcwb8hOA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-676--4xLIPdHP2ycLkILqi9H-g-1; Thu,
 06 Aug 2026 09:01:31 -0400
X-MC-Unique: -4xLIPdHP2ycLkILqi9H-g-1
X-Mimecast-MFC-AGG-ID: -4xLIPdHP2ycLkILqi9H-g_1786021290
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE8DF1955BC6;
	Thu,  6 Aug 2026 13:01:30 +0000 (UTC)
Received: from bfoster (unknown [10.22.80.193])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0B453180049F;
	Thu,  6 Aug 2026 13:01:29 +0000 (UTC)
Date: Thu, 6 Aug 2026 09:01:27 -0400
From: Brian Foster <bfoster@redhat.com>
To: Dave Chinner <dgc@kernel.org>
Cc: linux-xfs@vger.kernel.org, Matt Fleming <matt@readmodwrite.com>
Subject: Re: [PATCH 2/2] xfs: consistent low ag space behavior for sparse
 inode chunk allocs
Message-ID: <anSFp7C6h3CylXYA@bfoster>
References: <20260731163337.152522-1-bfoster@redhat.com>
 <20260731163337.152522-3-bfoster@redhat.com>
 <am05vzAntuhAKXgr@dread>
 <anDYdgP6y2537cY_@bfoster>
 <anEPukpCKlxRxACR@dread>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anEPukpCKlxRxACR@dread>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Aug 04, 2026 at 08:01:30AM +1000, Dave Chinner wrote:
> On Mon, Aug 03, 2026 at 02:05:42PM -0400, Brian Foster wrote:
> > On Sat, Aug 01, 2026 at 10:11:43AM +1000, Dave Chinner wrote:
> > > On Fri, Jul 31, 2026 at 12:33:37PM -0400, Brian Foster wrote:
> > > > Matt Fleming reports a filesystem shutdown due to inobt block
> > > > allocation failure during sparse chunk allocation. Inode creation
> > > > can involve multiple allocations in a transaction via the initial
> > > > chunk allocation and inode btree growth via the subsequent inobt
> > > > record insertion. Technically this should be safe as the chunk
> > > > allocation sets the allocation minleft parameter to the max depth of
> > > > the inode btree, which means the allocation selects an AG only if
> > > > there is enough free space for record insertion after the
> > > > allocation. The record insertion naturally occurs in the same AG as
> > > > the allocation and the associated AGF is locked and held by the
> > > > current transaction.
> 
> [snip]
> 
> > > i.e. if minleft != 0, then the agfl btree block reservations need to
> > > be done for (current level + 1) to take into account space for the
> > > trees to split during the dependent allocation chain that minleft !=
> > > 0 implies is about to occur.
> > > 
> > 
> > Ok, this more aligns with what the LLM had suggested, at least in terms
> > of fixing the problem at the first AGFL check via the minfree
> > calculation. IIRC it wanted to bump minleft internally and that came out
> > rather uglier than bumping min_free (as below).
> 
> Yeah, sounds pretty normal LLM analysis -> fix progression to me.
> 
> IME, LLMs often get close to the right solution, but they lack the
> subject matter expertise and/or the deep abstract thinking needed to
> understand that the problem is in the underlying behavioural
> constraints rather than the context triggering the issue.
> 
> Hence they output hacks to address the symptom the problematic
> context displays rather than a proper fix for the underlying
> issue...
> 

Heh, as it turns out I need to give it a little more credit even. I've
run into a couple issues with just bumping min_free as such.

I started hitting xfs/076 failures with this change and observe that
this seemed to pretty much defeat the purpose of sparse inodes in this
test. I end up seeing -ENOSPC at like 60% usage or something rather than
the expected 95%+. Without tracing exactly, I think the issue here is
the more aggressive min_free filters down into
xfs_alloc_longest_free_extent() and trips up the allocation there.

Before digging too deep into that, the second thing I realized when
poking around is that this min_left bump for ->minfree != 0 creates a
transient AGFL increase for the uncommon case of full allocbt splits.
IOW, every inode chunk allocation would aggressively populate AGFL for
the inode chunk alloc and then an inobt record insert alloc (or maybe
more likely just the next alloc on the AG) would trim the AGFL back down
based on the normal requirement. This may be immediately harmless (i.e.
no test failures), but it doesn't feel quite right and wouldn't surprise
me a ton if at some point down the road we hear about some obscure
allocation regression or some such tied to this spurious behavior.

Anyways, this is all just to say that I think the general
design/approach here still applies, but I've tweaked the implementation
a bit to store the elevated AGFL requirement in ->minleft instead of
minfree so that it only affects the AG selection in the first alloc and
doesn't lead to real AGFL state changes unless really necessary in the
followup alloc. So far this seems to prevent both the original shutdown
problem and allows sparse inodes to remain working as intended..

Getting back to the LLM.. this is kind of what it wanted to do
initially, but still with a worse (IMO) implementation. I don't know if
that was luck or through real analysis, but that question is not all
that unique to LLMs either. ;)

Brian

> > > This isn't an issue just for inobt/finobt blocks on inode chunk
> > > alloc, it's also an issue for anything that sets minleft for a
> > > dependent, multi-allocation operation (e.g. data extent allocation +
> > > BMBT block allocation). 
> > > 
> > 
> > Yeah, I noticed we had a handful of other cases that use minleft like
> > this. I wonder if the main reason we don't hit this from the bmapi path
> > is that it's usually open to multiple AGs for bmbt allocs and not fixed
> > to a single AG like inode chunk and corresponding inobt block allocs
> > obviously are.
> 
> *nod* Seems likely to me.
> 
> Also, data extent allocations often have slop in them for alignment
> on top of the minleft value, so I suspect that AGFL reservation
> growth could be hidden by the alignment slop that was reserved but
> not used.
> 
> > > So from this perspective, I think the fix needs to be made to the
> > > calculation in xfs_alloc_min_freelist() to take into account minleft
> > > needing a larger AGFL reservation if any of the allocations in the
> > > chain splits.
> > > 
> > > Hmmmm. I'm not sure the calculation in xfs_alloc_min_freelist() is
> > > correct, either:
> > > 
> > >         /*
> > >          * For a btree shorter than the maximum height, the worst case is that
> > >          * every level gets split and a new level is added, then while inserting
> > >          * another entry to refill the AGFL, every level under the old root gets
> > >          * split again. This is:
> > >          *
> > >          *   (full height split reservation) + (AGFL refill split height)
> > >          * = (current height + 1) + (current height - 1)
> > >          * = (new height) + (new height - 2)
> > >          * = 2 * new height - 2
> > > 
> > > i.e. I think the AGFL refill split height is wrong.
> > > 
> > > Look at it this way: we do the AGFL refill -first-, so if that
> > > splits, we consume (current height + 1) blocks, and then new_height
> > > = (current height + 1). Then if the actual data allocation does a
> > > full split again (i.e. all except for the root block), that needs
> > > (new_height -1) blocks. So that becomes:
> > > 
> > > 	new_height = current height + 1;
> > > 	blocks = new_height + (new_height - 1)
> > > 	       = 2 * new_height - 1.
> > > 
> > > IOWs, I think there's an existing off-by one in the AGFL btree block
> > > reservation calculation that contributes to this problem as well.
> > > 
> > 
> > Hmm.. I need to stare at this a little more, but I think that makes
> > sense.
> 
> I've thought on it a bit more, too, and I now realise the original
> code is correct. 
> 
> I failed to take into account that we can't split the two blocks the
> old root was split into again - they will be at 50% capacity after
> the first split, so a split up to one of their child nodes will only
> add one more ptr to them. They can't fill and split again in the
> current transaction chain.
> 
> Hence the second split can only occur up to (current height - 1),
> and so the existing calculation is correct.
> 
> [snip]
> 
> > I think this is reasonable. The thing that stands out a little bit is
> > that technically we're reserving for the worst case min_free allocation
> > requirement of the second alloc, not necessarily the actual number of
> > blocks needed, right? That seems fine if so. I just want to make sure
> > we're clear and we document the updated calculation appropriately (i.e.
> > noting how minleft > 0 is a somewhat special case).
> >
> > The off-by-one thing aside, IIUC the current min_free calculation
> > correctly accounts the actual number of blocks we'd consume in the worst
> > case for both allocations, it just doesn't account for how the min_free
> > requirements change upon reentry into the allocator after a minleft > 0
> > allocation.
> 
> Right, that's my understanding of the issue - that min_free is an up
> front worst case reservation to prevent downstream ENOSPC within the
> AG during the transactional modification that is about to take
> place.
> 
> i.e. it's taken over 30 years for us to realise that the AGFL
> reservation could change in the middle of a multi-allocation
> transaction and that the minfree calc has never taken that into
> account. i.e. this is yet another zero-day bug in the AGFL fixup
> code...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> dgc@kernel.org
> 

