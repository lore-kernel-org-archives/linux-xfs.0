Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25A601E2606
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770051105; cv=none; b=L9A7mpvOWowD9v+zKfmDmfFbntLtDSzcyZ47UooiiiNhIkAiKkn7XlwJXXfybSPJnX1DhqJNuomABtt73gxIkBgeSJweP49lm6UoA4xYzGCY2o1xTX2y0KSNzHcgM0UsFACnidqgr48sz/uOAUanzYT7QbY7B6GCUY0xbF0cbyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770051105; c=relaxed/simple;
	bh=ugVgd/D2OWhuWlk/dE405CXf9t18hCobOXUEQ+6NviQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fV3/g8iUMYyyBifmbeNCrwwxFXxeGM4tRYgzlwmBxSGHPXv4VIaCIj5bYYplx2pOJcdv/eCYf5UNWEjhxrq5Nqwqi4Aj43WmrGWR5VhbS4srL7n1dKKGMbiauaRv6tYiMU16MY674hMCG3zjbBLmmRBowFZh0U0ikHI5ltoqJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hUYN4UWH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hUYN4UWH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF7AC2BC86;
	Mon,  2 Feb 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770051104;
	bh=ugVgd/D2OWhuWlk/dE405CXf9t18hCobOXUEQ+6NviQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hUYN4UWHV28SjilnzQ3Ejxp5MiI5MIvoPs6/+gLfWNzq5h1/D6lP3ARe8DRvefbli
	 VUC74AdpZahCPtFoUBkX8Ug1W6MkqkwVyaugUsI2BC29Hg3GgaGIn3WTGy2gaM+wXd
	 yvY2MNeZckZhh6wCHGpSffx+nhNMgLNPC00IsHV9vOdjKG/GBuIGiOBsknKPxXqD0m
	 LdH1Hz2S1LVLXJru25bvhRiDiLWOk/PPO2r4jC+3BJvf/8PXaop8MBWvFY18fZRVbV
	 mpX9EofT4odq8qNBpGo4FTO2n6fApC9GtlUlRpDceWEgxqWD/ptlqCv9BratqfgJ1T
	 b1o1Ga/28rrOw==
Date: Mon, 2 Feb 2026 17:51:39 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, 
	ojaswin@linux.ibm.com, djwong@kernel.org, hch@infradead.org
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <aYDWB22-IqrFhpYQ@nidhogg.toxiclabs.cc>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
 <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
 <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
 <04bdccfc-5eb0-4962-992a-5d2d0b0bb41c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04bdccfc-5eb0-4962-992a-5d2d0b0bb41c@gmail.com>

> > > > > What am I missing here? This looks weird...
> > > > > We execute the block if sum is lower than 0, and then we assert it's
> > > > > greater or equal than zero? This looks the assert will never fire as it
> > > > > will only be checked when sum is always negative.
> > > > Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
> > > > confusing, it would be better if we just ASSERT(0) there.
> > > Well, the idea (as discussed in [1] and [2]) was that we should log that sum
> > > has been assigned an illegal negative value (using an ASSERT) and then bail
> > > out.
> > > [1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/
> > > 
> > > [2] https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/
> > I see. I honestly think this is really ugly, pointless, and confusing at
> > a first glance (at least for me). The assert location is logged anyway
> > when it fire.
> > 
> > If I'm the only one who finds this confusing, then fine, otherwise I'd
> > rather see ASSERT(0) in there.
> 
> Sure, Carlos. ASSERT(0); sounds okay to me. Darrick, do you have any hard
> preferences between ASSERT(0); and ASSERT(sum < 0); ? If not, then I can go
> ahead, make the change and send a revision with the suggested change here.
> 

Thanks!
