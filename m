Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BB218DB34
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 07:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741247457; cv=none; b=H1ZlECN5gXVE1z+jrerzSBIAppWcp7tlo4Cl1XNVZl7h+aLaBsR9nDU11r4HvQ69Jn4WRS6gVJwBH9G4sfQcOQpUm7aHixDVAC23NU6njTCL3z5xtibUv+suwwk6zByPwLZursfu2xrl28FrUf5G5Z1ZyI5Q0hJbXMUL3WYOr/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741247457; c=relaxed/simple;
	bh=jbwMw6akV6/Dkx8DEYvEsxZaFEW+LzaPJAISY6a/IcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBIzQ+rY89HQ522CbkIO187pGtTIW6kLwJmcdsweaB8ldFc0PMyNU7KNUUBUgGG6vn/xoEOfU6dDmRaJ1HaS3MtxD00Fac9GyycqE4XKpt6pwZloqkPfIQPnm8HmMAD2bxRf6t3/pb0WoLrDvPLrZZxTNAIKdq6Bxia+AHvoLIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DvO7Kjqa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DvO7Kjqa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99336C4CEE4;
	Thu,  6 Mar 2025 07:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741247456;
	bh=jbwMw6akV6/Dkx8DEYvEsxZaFEW+LzaPJAISY6a/IcE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DvO7Kjqa3qpE1nfqMN0uoyyhKoHYi2PWD/hCaocekNMKdXF6n7qldnxOfainihHCQ
	 eatL5rAXQs0B2i4ae3wURUiUap1hBgJCnV5ZQE5phpMCPAOjl5sA2MAtFZQQdwey0i
	 Qg9BvMC/bzkqW6H7rzR/G9jeBiDIq5hYxhtpNUn9GaIENy/Ma+YBryM/5KqxoTBW0c
	 u6Utrt4hXedU62ni1Xr25mCSq2WSbP5NmH4FYpPVGSgiC6fUSmbxEnuGxOUIDSEO3K
	 7iFhFkKGRiwWRuHo2RGPFNuGXdq6n/NbSM+/OQSwTQPRFxiW4HyBrmBhRs7Ew0D16e
	 ExBp17pXVb7MA==
Date: Thu, 6 Mar 2025 08:50:51 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, 
	david@fromorbit.com, sandeen@redhat.com, bfoster@redhat.com, aalbersh@kernel.org, 
	axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <nausrxvwnnnk7g7ythgaslitvrfy5syeugvsjequ74zsd7gz2l@4bkgm5yrcjqh>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
 <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid>
 <20250303140547.GA16126@lst.de>
 <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
 <l07Q7sLKdafnmrmqBghsvH5o-E7m8nGRwAzBZHTeoEB6coPrxD8D1SvgJJ7HCs_vG6xUTJ9nMdxzEZ_EC90X0g==@protonmail.internalid>
 <20250304202059.GE2803749@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304202059.GE2803749@frogsfrogsfrogs>

On Tue, Mar 04, 2025 at 12:20:59PM -0800, Darrick J. Wong wrote:
> On Mon, Mar 03, 2025 at 04:00:39PM +0100, Carlos Maiolino wrote:
> > On Mon, Mar 03, 2025 at 03:05:47PM +0100, Christoph Hellwig wrote:
> > > On Mon, Mar 03, 2025 at 11:42:12AM +0100, Carlos Maiolino wrote:
> > > > The biggest change here is that for-next will likely need to be rebased
> > > > more often than today. But also patches will spend more time under testings
> > > > in linux-next and everybody will have a more updated tree to work on.
> > >
> > > FYI, what other trees do is to keep separate branches for the current
> > > and next release, i.e. right now: for-6.14 and for-6.15 and merge those
> > > into the for-next or have both of them in linux-next (e.g. for-linus and
> > > for-next).  In that case most of the time you don't need to rebase at
> > > all.  Instead you might occasionally need to merge the current into the
> > > next tree to resolve conflicts, and Linus is fine with that if you
> > > document the reason for that merge.
> 
> Separate branches for 6.14 and 6.15 that then get merged into a for-next
> is what I did when I had separate trains running at the same time.  Most
> of the time I just rolled the post-rc6 fixes into the next release, so I
> usually only dealt with one at a time.
> 
> (to some grumbling)
> 
> > This is pretty much aligned with my intentions, I haven't looked close yet how
> > other subsystems deals with it, but by a few releases now, I keep a
> > xfs-fixes-$ver branch which I collect patches for the current version, so adding
> > a new branch for the next merge window is what I aimed to do with
> > xfs-6.15-merge.
> >
> > The question for me now lies exactly on how to synchronize both. You partially
> > answered my question, although merging the current into next sounds weird to me.
> >
> > If I merge current into next, and send Linus a PR for each (let's say for -rc7
> > and in sequence for the next merge window), Linus will receive two PRs with
> > possibly the same patches, and yet, on the merge window PR, there will also be a
> > merge commit from -current, is this what you're describing?
> 
> If I had a for-6.14 and a for-6.15 branch, I'd base the PRs off of those
> branches, not the for-next branch itself.

I see what you mean, but from another POV, you'd be basing a PR on top of one
series of patches, not on top of everything.

Today, what we have, is a relatively stable for-next branch, where we just
really rebase when something goes wrong, so, usually, when I push things into
for-next, I've had it tested for a big while.

Per my conversations off-list (specially with hch), is that this shouldn't be
the purpose at all of for-next, but a testing branch where (almost anything) can
go wrong, within reason of course. Please correct me if I'm wrong here.

At the same time, I wish we have a branch that everybody can work with, which
contains 'everything' staged, ready to go, so I'd do all the merge between
current and next release myself into such branch. I think having a branch ready
for people to work with is a maintainer's job, and people shouldn't be bothered
by trying to figure out which branch they should use to base their patches on
top.

I'm hoping to use the master's branch for that if nobody has any objection.

Carlos

> 
> > Thanks for the input.
> >
> > >
> > > >
> > > > Also, I'm still thinking how to handle pull requests I receive. I try
> > > > hard to not change the commit hashes from the PRs, so I'm still not sure
> > > > how feasible it will be to keep the same hash ids from PRs giving more often
> > > > than not I'll need to rebase the next merge tree on the top of fixes for the
> > > > current -RC and in some cases, on top of other trees with dependencies.
> > >
> > > With the above you just keep the pull requests as-is.
> > >
> > >
> >
> > Sounds reasonable
> 
> Or you can ask the PR submitter to rebase off latest for-6.15 and handle
> the merge themselves.
> 
> --D
