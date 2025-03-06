Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6217B158851
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 17:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741282813; cv=none; b=LnoBNry8D56RuR2TKay4dM934/8+SM+SLFI4fcdAMZ7aGcW9mv9XcufEtCTsLDPxHsapG7guxXCOCx26uNG6rORuf/cfbbWBY+1P8RN5vgvJsYX597DeLkonaNzQF5tvNcQjHIK72pE4rAOFAiKwafbb9TBKcRH+7hap5UOnozM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741282813; c=relaxed/simple;
	bh=mwGEW8Xz+rbp95JZaGjd+WbUxb6iiRG09mjcn3MCoTk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qGAAooQrbLnwIRfbcAfbJoP+QH35x/iFLny48RqjztfBS8yrV6UWkt9RODN8g3TNLF95mxChtimFwXBDAHMWoge/6FXjnU0UBrjy+/LoIctfSS3bRobXl/MY124vHVmBrJYe8Kk2OHUrtLudRtx66Unw2ur8bhaEawtpHcmyLQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tjNCN9J/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tjNCN9J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D17B8C4CEE0;
	Thu,  6 Mar 2025 17:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741282812;
	bh=mwGEW8Xz+rbp95JZaGjd+WbUxb6iiRG09mjcn3MCoTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tjNCN9J/hJ3082tV4Ky9OdDipiaHY0DtJqaiFVocEfN/wZW/PkJpT7s7wGgp96WXT
	 CpnUJxXGTVevuhQTKdtZpBFqPVX57nGJSciXCXhnxrpIu6cGVrIpoDP8pe2ACdlUT5
	 sB77TLnLep2jQ5T7+tIGXLDfpwvleA2yzzl4g0Mx93y0IJPodSeLwg7T6TuFzbuARm
	 BqSHTow71DqIdQwklu6b9i72rBBFwAMrMqdBpvItAd/TAiTZjmR2anYsR/zISzzS13
	 raELsDK5IQlf3aDVvyekMkrupmPlvwSLExGDCkrgAbXjTQtPE1lFwvNnBG+HSpzgBb
	 Dl88DpWqbY8uw==
Date: Thu, 6 Mar 2025 09:40:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	david@fromorbit.com, sandeen@redhat.com, bfoster@redhat.com,
	aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250306174012.GN2803749@frogsfrogsfrogs>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
 <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid>
 <20250303140547.GA16126@lst.de>
 <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
 <l07Q7sLKdafnmrmqBghsvH5o-E7m8nGRwAzBZHTeoEB6coPrxD8D1SvgJJ7HCs_vG6xUTJ9nMdxzEZ_EC90X0g==@protonmail.internalid>
 <20250304202059.GE2803749@frogsfrogsfrogs>
 <nausrxvwnnnk7g7ythgaslitvrfy5syeugvsjequ74zsd7gz2l@4bkgm5yrcjqh>
 <20250306170841.GA25819@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306170841.GA25819@lst.de>

On Thu, Mar 06, 2025 at 06:08:41PM +0100, Christoph Hellwig wrote:
> On Thu, Mar 06, 2025 at 08:50:51AM +0100, Carlos Maiolino wrote:
> > > If I had a for-6.14 and a for-6.15 branch, I'd base the PRs off of those
> > > branches, not the for-next branch itself.
> > 
> > I see what you mean, but from another POV, you'd be basing a PR on top of one
> > series of patches, not on top of everything.
> 
> Well, while some subsystems have tons of topic branches that turns into
> a mess really quickly.  So what Darrick said makes the most sense in
> general.  There might be occasional corner cases where you'd want to
> be more fine grained, but they should be very rare.
> 
> > 
> > Today, what we have, is a relatively stable for-next branch, where we just
> > really rebase when something goes wrong, so, usually, when I push things into
> > for-next, I've had it tested for a big while.
> > 
> > Per my conversations off-list (specially with hch), is that this shouldn't be
> > the purpose at all of for-next, but a testing branch where (almost anything) can
> > go wrong, within reason of course. Please correct me if I'm wrong here.
> 
> I would expect for-next to have some amount of sanity testing.  But the
> idea is indeed to have the code integrated with other kernel changes
> rather sooner than later.
> 
> > 
> > At the same time, I wish we have a branch that everybody can work with, which
> > contains 'everything' staged, ready to go, so I'd do all the merge between
> > current and next release myself into such branch. I think having a branch ready
> > for people to work with is a maintainer's job, and people shouldn't be bothered
> > by trying to figure out which branch they should use to base their patches on
> > top.
> > 
> > I'm hoping to use the master's branch for that if nobody has any objection.
> 
> Using master is really confusing.
> 
> As I said earlier and Darrick also said the most usual thing is
> to have one branch for $CURRELEASE fixes and one for $NEXTRELEASE
> development work.  for-next is then a temporary merge of those two.
> If you need $CURRELEASE changes in $NEXTRELEASE to avoid a mess, you
> either rebase $NEXTRELEASE (usually earlier in the merge window) or
> pull the $CURRELEASE into $NEXTRELEASE with a well-documented
> merge commit message documenting why it had to be done.

Eliminating the possibility of such messes is also why I avoided doing
bugfixes and merge window prep whenever I could. ;)

--D
