Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC010212B0A
	for <linux-xfs@vger.kernel.org>; Mon,  3 Mar 2025 14:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741010763; cv=none; b=DB5aAfo593Yt/LhQ8VH7oPQMA0D6SE4Vf5AoXIvHNc9BIIk5sUTlDGnM7q9tkZ4wAbs10EqjIqO4PPbbrT3XqD9GVz5t+tipqfQ0xd56+gNK7uvHnK0SxhqwD5unt22tVLSW7M9ysnYyOSPAPVqov8ej8Xb6HA/jy0clvbD3lDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741010763; c=relaxed/simple;
	bh=TXFtQa1KHUt+Xbdw1iZXxbD5xvzm1SYWxO3e/iIjYJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HEQ/oYqr1SDZuh4UTnR4oiZ3IT4pPuFx8Auzs99OY8pHjTPQM9+120SpXpgE7cbN2jRSdFA31fd3xI0B29hn+Vm7gWVqBVBFvZYvzB7XVvp7m3wZs6RXNQxxIS5OcbwDCrI6zktfA9MGI2ry67UzIlxpOji5inkQgjI7nQevYew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9DBC268D05; Mon,  3 Mar 2025 15:05:48 +0100 (CET)
Date: Mon, 3 Mar 2025 15:05:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de, david@fromorbit.com,
	djwong@kernel.org, sandeen@redhat.com, bfoster@redhat.com,
	aalbersh@kernel.org, axboe@kernel.dk
Subject: Re: Changes to XFS patch integration process
Message-ID: <20250303140547.GA16126@lst.de>
References: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m6movx2b6yeygut6ow5hjkkfyyu32brsfzjcwydqge5gimz5z3@sw5hrcsah3ga>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 03, 2025 at 11:42:12AM +0100, Carlos Maiolino wrote:
> The biggest change here is that for-next will likely need to be rebased
> more often than today. But also patches will spend more time under testings
> in linux-next and everybody will have a more updated tree to work on.

FYI, what other trees do is to keep separate branches for the current
and next release, i.e. right now: for-6.14 and for-6.15 and merge those
into the for-next or have both of them in linux-next (e.g. for-linus and
for-next).  In that case most of the time you don't need to rebase at
all.  Instead you might occasionally need to merge the current into the
next tree to resolve conflicts, and Linus is fine with that if you
document the reason for that merge.

> 
> Also, I'm still thinking how to handle pull requests I receive. I try
> hard to not change the commit hashes from the PRs, so I'm still not sure
> how feasible it will be to keep the same hash ids from PRs giving more often
> than not I'll need to rebase the next merge tree on the top of fixes for the
> current -RC and in some cases, on top of other trees with dependencies.

With the above you just keep the pull requests as-is.

