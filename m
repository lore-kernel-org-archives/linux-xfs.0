Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13DC21CA13
	for <linux-xfs@vger.kernel.org>; Mon,  2 Feb 2026 18:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770058430; cv=none; b=BJV+FmlVhDniXj8vUu1F77tM/YZDtZrXGRvjXKSI7h2QEc9nRdbOrmTjX5Qp+Vv1VYjbSwPVUbKs7QxmUXIbElfGdiWVNGsuUH4sg1FETDpRnD6xhYYL2LXKmPHfVaVDoZRpkUdptTcOwZ9NuszNhWYW2B4NcT1Jfnwv+SWSkjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770058430; c=relaxed/simple;
	bh=LkysjhOGhB6fJPvFmnFlmwpZAq/UF0nlrR6pr06AadQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMMHoIETc8mkuJm430mgg5zmF0kxIXNavwOzr8J1KOYLb/yiKZ+wzIXSfgGbnnZ77m2gyX8VD1jmgZ3IdyclD9E51AasWVvydJPp5DU6s50hY0gw51tm7oGk7nwCZBuYGSXdrqJRbCxCgGG+p9n16o3pwikhQWbL3EmBOjTtSEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LiEV+iuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LiEV+iuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749D5C116C6;
	Mon,  2 Feb 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770058429;
	bh=LkysjhOGhB6fJPvFmnFlmwpZAq/UF0nlrR6pr06AadQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LiEV+iuKSDNokcMGpmZqtdjly73YywE8rodn9TktdIawouRdkhEdsZO63sGwh71o5
	 ZH07+8LRC/ZFP21cac4mZB5PO4cp+aAW8r3DCVgmXfXXWMsLWWeHE/V5D8pBmnqs/B
	 WIzpjVQmoNxf+5mkgBJJEYI9RiAvlgp0N2TMjRKa+x6OAMQ5BIjXGidOx8MpqkkrBD
	 f+jwcWUvRupP0our9EptqfESK3+D0XXHY/LXAjAnpsCL2qNeWreHsh6+PKF+V1jr3f
	 OUu7xFj060QChV5KQ6RkvWT9IQ43Gv8JKvtmpk+mwmnqQBro/WWJFBJheUUpSCAkC5
	 3ZPhT4QiFOBCw==
Date: Mon, 2 Feb 2026 10:53:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hch@infradead.org
Subject: Re: [PATCH v2 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <20260202185348.GI7712@frogsfrogsfrogs>
References: <cover.1769625536.git.nirjhar.roy.lists@gmail.com>
 <e9f8457440db64b07ab448bd7d426d3eb9d457d6.1769625536.git.nirjhar.roy.lists@gmail.com>
 <aXse1lm9J66RTvwZ@nidhogg.toxiclabs.cc>
 <aXsgia9chv4y91u3@nidhogg.toxiclabs.cc>
 <d6020236-04e6-442f-af6f-0fd690442902@gmail.com>
 <aXtdDnpguPkytiPT@nidhogg.toxiclabs.cc>
 <04bdccfc-5eb0-4962-992a-5d2d0b0bb41c@gmail.com>
 <aYDWB22-IqrFhpYQ@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYDWB22-IqrFhpYQ@nidhogg.toxiclabs.cc>

On Mon, Feb 02, 2026 at 05:51:39PM +0100, Carlos Maiolino wrote:
> > > > > > What am I missing here? This looks weird...
> > > > > > We execute the block if sum is lower than 0, and then we assert it's
> > > > > > greater or equal than zero? This looks the assert will never fire as it
> > > > > > will only be checked when sum is always negative.
> > > > > Ugh, nvm, I'll grab more coffee. On the other hand, this still looks
> > > > > confusing, it would be better if we just ASSERT(0) there.
> > > > Well, the idea (as discussed in [1] and [2]) was that we should log that sum
> > > > has been assigned an illegal negative value (using an ASSERT) and then bail
> > > > out.
> > > > [1] https://lore.kernel.org/all/20260122181148.GE5945@frogsfrogsfrogs/
> > > > 
> > > > [2] https://lore.kernel.org/all/20260128161447.GV5945@frogsfrogsfrogs/
> > > I see. I honestly think this is really ugly, pointless, and confusing at
> > > a first glance (at least for me). The assert location is logged anyway
> > > when it fire.
> > > 
> > > If I'm the only one who finds this confusing, then fine, otherwise I'd
> > > rather see ASSERT(0) in there.
> > 
> > Sure, Carlos. ASSERT(0); sounds okay to me. Darrick, do you have any hard
> > preferences between ASSERT(0); and ASSERT(sum < 0); ? If not, then I can go
> > ahead, make the change and send a revision with the suggested change here.

Personally I think it's kinda dumb to log debugging messages that tell
you very little:

XFS: Assertion failed: 0, file: <whatever>

when you could actually say what the problem is:

XFS: Assertion failed: sum >= 0, file: <whatever>

but cem already said yes so I'm really just talking into the internet
here.

--D

> 
> Thanks!
> 
