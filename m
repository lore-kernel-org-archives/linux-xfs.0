Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B72E25A325
	for <linux-xfs@vger.kernel.org>; Thu,  6 Mar 2025 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280930; cv=none; b=cJ/9fo9ksx2lRHgefa9w6QaDqKUNIImpeUWjVEsdnj0hCRifP1UzOjzvyLSiJPJzbo/UWB8M8wgslSO430GLBKmSjEL4cQ8/jLJk7yqX6TygIyOaQrBizhKobNi5+V6SuPot6MW+19s6OkPRPt+ZF6VxW4OD7eEC2Mt8wmbL9g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280930; c=relaxed/simple;
	bh=9puJoRRjtbWLihLDXFOm3bnEKnaBx1Z+jd/BhSZCJLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJS2TPOlKxSm53v8LFzTxlLZfZWKKqtKmC79T4wa6XIkFP8eaRJVJXd9dcHLoecFGAMDkbVQXZ0wwg0cKlcV27NdXEJuRK6ISFfEDzsoHA3jRoLI/eKT1BhZuUmHHyiockZIhCpi8wr289uF5ZQerC8DtMf8tXSJko7Xc1RTJqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 23B8E68C4E; Thu,  6 Mar 2025 18:08:42 +0100 (CET)
Date: Thu, 6 Mar 2025 18:08:41 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@redhat.com,
	bfoster@redhat.com, aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250306170841.GA25819@lst.de>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga> <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid> <20250303140547.GA16126@lst.de> <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z> <l07Q7sLKdafnmrmqBghsvH5o-E7m8nGRwAzBZHTeoEB6coPrxD8D1SvgJJ7HCs_vG6xUTJ9nMdxzEZ_EC90X0g==@protonmail.internalid> <20250304202059.GE2803749@frogsfrogsfrogs> <nausrxvwnnnk7g7ythgaslitvrfy5syeugvsjequ74zsd7gz2l@4bkgm5yrcjqh>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nausrxvwnnnk7g7ythgaslitvrfy5syeugvsjequ74zsd7gz2l@4bkgm5yrcjqh>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Mar 06, 2025 at 08:50:51AM +0100, Carlos Maiolino wrote:
> > If I had a for-6.14 and a for-6.15 branch, I'd base the PRs off of those
> > branches, not the for-next branch itself.
> 
> I see what you mean, but from another POV, you'd be basing a PR on top of one
> series of patches, not on top of everything.

Well, while some subsystems have tons of topic branches that turns into
a mess really quickly.  So what Darrick said makes the most sense in
general.  There might be occasional corner cases where you'd want to
be more fine grained, but they should be very rare.

> 
> Today, what we have, is a relatively stable for-next branch, where we just
> really rebase when something goes wrong, so, usually, when I push things into
> for-next, I've had it tested for a big while.
> 
> Per my conversations off-list (specially with hch), is that this shouldn't be
> the purpose at all of for-next, but a testing branch where (almost anything) can
> go wrong, within reason of course. Please correct me if I'm wrong here.

I would expect for-next to have some amount of sanity testing.  But the
idea is indeed to have the code integrated with other kernel changes
rather sooner than later.

> 
> At the same time, I wish we have a branch that everybody can work with, which
> contains 'everything' staged, ready to go, so I'd do all the merge between
> current and next release myself into such branch. I think having a branch ready
> for people to work with is a maintainer's job, and people shouldn't be bothered
> by trying to figure out which branch they should use to base their patches on
> top.
> 
> I'm hoping to use the master's branch for that if nobody has any objection.

Using master is really confusing.

As I said earlier and Darrick also said the most usual thing is
to have one branch for $CURRELEASE fixes and one for $NEXTRELEASE
development work.  for-next is then a temporary merge of those two.
If you need $CURRELEASE changes in $NEXTRELEASE to avoid a mess, you
either rebase $NEXTRELEASE (usually earlier in the merge window) or
pull the $CURRELEASE into $NEXTRELEASE with a well-documented
merge commit message documenting why it had to be done.

