Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5276A214217
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741014046; cv=none; b=MGlOIRjwlDibPDKL25MRFzxY7GTd9yV52L7H2TjRNyjzzVX2akGrah6CAMFJe1N/+rvWEYlc5KZXjmZxw2CMIQgnUB3sEBmYcz4Jk9kF4fSqg4l/ZrRTzdVr78B3RrcFeGW9zcoQ89oSJnj36xTdU9aEij1JdTuodt2WTtpsq1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741014046; c=relaxed/simple;
	bh=fUsGPsik4qAp+2ZUyH/eUMyJvfJrTUqk8iI3xq3NVi0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MKOW5s+9Vf74A/fc0dmdpCS2fi8gH4e48NSlfNixiXeO+yhPZKkfRgSdbE7fY/hrDPZ2zaaLhfwV+mXfRoMGKnOtalT59AjRXSPqDhuow6V8qPWDpX0275N7ktPXR6PwbVSXMSG6bCOGgyYCBn8lr7QB+08Ck8MfMTpj+ANlulI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lx+tszRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lx+tszRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1847C4CEE6;
	Mon,  3 Mar 2025 15:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741014045;
	bh=fUsGPsik4qAp+2ZUyH/eUMyJvfJrTUqk8iI3xq3NVi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lx+tszRkVQKDBiDBU+RCqwKKgpItvQXX+eczpy4F6YX54DI6L1bp/7ZX/Jd8qPFsH
	 MwoDLPKuRavKqN1ruwmKacNB22ixNalIxCaqorYgLkTBUhuoNDSIq2LPMFdadSC1mZ
	 pT1m7whvIYPegNfQirkWeuG144HRwvCazA/NBVdN0C/j7vngAoFzzZm12KAYSHXKan
	 EzkOwlnQ7yhsnkFr8PoxhcFF6kZNoFLdqSziXM++OJyMAmJhTYEQKgPEdyclwt0hEi
	 eeNN7mqk44lBRy26oCDjcP7I+JpqOdey8evtytd5HYTLcJCy7w6JJ9HL01WSKmNq87
	 LONPz3CwwWhOg==
Date: Mon, 3 Mar 2025 16:00:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, djwong@kernel.org, 
	sandeen@redhat.com, bfoster@redhat.com, aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <rbyicja5damtyfcfxwbk6mspeus42jqwzr6qqch44gizki3zgb@awiat6qbwl7z>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
 <WW-YcYkHs91Udy3MU9JoG8oirMMUKrs7XB4_rExNq8_azaAVtgdcf-7vtuKI23iITfyc832nCqSz_O7R41btrA==@protonmail.internalid>
 <20250303140547.GA16126@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250303140547.GA16126@lst.de>

On Mon, Mar 03, 2025 at 03:05:47PM +0100, Christoph Hellwig wrote:
> On Mon, Mar 03, 2025 at 11:42:12AM +0100, Carlos Maiolino wrote:
> > The biggest change here is that for-next will likely need to be rebased
> > more often than today. But also patches will spend more time under testings
> > in linux-next and everybody will have a more updated tree to work on.
> 
> FYI, what other trees do is to keep separate branches for the current
> and next release, i.e. right now: for-6.14 and for-6.15 and merge those
> into the for-next or have both of them in linux-next (e.g. for-linus and
> for-next).  In that case most of the time you don't need to rebase at
> all.  Instead you might occasionally need to merge the current into the
> next tree to resolve conflicts, and Linus is fine with that if you
> document the reason for that merge.

This is pretty much aligned with my intentions, I haven't looked close yet how
other subsystems deals with it, but by a few releases now, I keep a
xfs-fixes-$ver branch which I collect patches for the current version, so adding
a new branch for the next merge window is what I aimed to do with
xfs-6.15-merge.

The question for me now lies exactly on how to synchronize both. You partially
answered my question, although merging the current into next sounds weird to me.

If I merge current into next, and send Linus a PR for each (let's say for -rc7
and in sequence for the next merge window), Linus will receive two PRs with
possibly the same patches, and yet, on the merge window PR, there will also be a
merge commit from -current, is this what you're describing?

Thanks for the input.

> 
> >
> > Also, I'm still thinking how to handle pull requests I receive. I try
> > hard to not change the commit hashes from the PRs, so I'm still not sure
> > how feasible it will be to keep the same hash ids from PRs giving more often
> > than not I'll need to rebase the next merge tree on the top of fixes for the
> > current -RC and in some cases, on top of other trees with dependencies.
> 
> With the above you just keep the pull requests as-is.
> 
> 

Sounds reasonable
