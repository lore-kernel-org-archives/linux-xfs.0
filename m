Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB634AEEA
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 05:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724735960; cv=none; b=ThC9p+lCtysHojtMZg0WeVzl+TK9CXPR2aKzUzXuiksRP4+tuY2Vkkv6fpetIMXiMjIK6Vgnq1hnhHEjoVOkK7Jr2TVF0Sf19iG7/VUpMtPdpKCiN70KCdE5LGY0aXlk7YoW427yVxWtyNWCcF0a6Gpd/3wGpbHHdy5D7LdBy1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724735960; c=relaxed/simple;
	bh=yxzZXHio2Z1dvbBURvGL794QAzmHpK3hgRuNReVooN4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cali4dMJijXuErAznmx+43uCz1vK3UUPQT8nzgOzqfpRF/sSTv2ZaZp1pLrDQs3l8hR00S/w9UDOqgh9nzpPMGMYJJIsDnUbX381xUf1defS+WdlnP2G53JtJujDPZxUZQSuh3dC+VKUXLR0ftFm0YGp71oOZCmqCNvBqlBMqEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hYVdTDsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hYVdTDsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57952C8B7A3;
	Tue, 27 Aug 2024 05:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724735960;
	bh=yxzZXHio2Z1dvbBURvGL794QAzmHpK3hgRuNReVooN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hYVdTDsc9lCgGqw0QPR7aDIahui6xq4ZAmz0Yo/j4tnVWOwjsjJj66o/ZpIbraCmU
	 XqakwGqKGWjaV8S45SjmWcM1upS+omSY+6Ii007h6BAzFJPtaoZdAUlfWkTCJF/hNG
	 JWO6ypXz2HiSJm3Yxd45HIfsigb/3tYjnnYorHn+yHcf8dhpZZLGMJxOkgQI8GJO3R
	 98gcwDNckeDmj/q0K9RMTBu7xmnZfVBKcsTg4Akb9uzcWEZekgcQmXv8Cv6wlZNxEy
	 tE4RV89q0Ut0KgSHXnZ4EhjsUad8SXekyF7dBd+0g1mT/ScbQUa42R7yvfZH7+pXli
	 PgR2/NYsZmEzw==
Date: Mon, 26 Aug 2024 22:19:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, hch@lst.de,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/24] xfs: create incore realtime group structures
Message-ID: <20240827051919.GK865349@frogsfrogsfrogs>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087433.59588.10419191726395528458.stgit@frogsfrogsfrogs>
 <ZsvEmInHRA6GVuz3@dread.disaster.area>
 <20240826191404.GC865349@frogsfrogsfrogs>
 <Zs1Vl38sptZSkvXk@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zs1Vl38sptZSkvXk@infradead.org>

On Mon, Aug 26, 2024 at 09:27:03PM -0700, Christoph Hellwig wrote:
> On Mon, Aug 26, 2024 at 12:14:04PM -0700, Darrick J. Wong wrote:
> > They're not sparse like fsbnos on the data device, they're laid end to
> > end.  IOWs, it's a straight linear translation.  If you have an rtgroup
> > that is 50 blocks long, then rtgroup 1 starts at (50 * blocksize).
> 
> Except with the zone capacity features on ZNS devices, where they
> already are sparse.  But that's like 200 patches away from the state
> here..

Heh.

> > group 0 on a !rtg filesystem can be 64-bits in block/rt count.  This is
> > a /very/ annoying pain point -- if you actually created such a
> > filesystem it actually would never work because the rtsummary file would
> > be created undersized due to an integer overflow, but the verifiers
> > never checked any of that, and due to the same underflow the rtallocator
> > would search the wrong places and (eventually) fall back to a dumb
> > linear scan.
> > 
> > Soooooo this is an obnoxious usecase (broken large !rtg filesystems)
> > that we can't just drop, though I'm pretty sure there aren't any systems
> > in the wild.
> 
> So, do we really need to support that?  I think we've always supported
> a 64-bit block count, so we'll have to support that, but if a > 32bit
> extent count was always broken maybe we should simply stop to pretend
> to support it?

I'm in favor of that.  The rextslog computation only got fixed in 6.8,
which means none of the LTS kernels really have it yet.  And the ones
that do are migrating verrrrry slowly due to the global rtbmp lock.

> > > What's the maximum valid rtg number? We're not ever going to be
> > > supporting 2^32 - 2 rtgs, so what is a realistic maximum we can cap
> > > this at and validate it at?
> > 
> > /me shrugs -- the smallest AG size on the data device is 16M, which
> > technically speaking means that one /could/ format 2^(63-24) groups,
> > or order 39.
> > 
> > Realistically with the maximum rtgroup size of 2^31 blocks, we probably
> > only need 2^(63 - (31 + 10)) = 2^22 rtgroups max on a 1k fsblock fs.
> 
> Note that with zoned file system later on we are bound by hardware
> size.  SMR HDDs by convention some with 256MB zones.  This is a bit
> on the small side, but grouping multiple of those into a RT group
> would be a major pain.  I hope the hardware size will eventually
> increase, maybe when they move to 3-digit TB capcity points.

<nod>

--D
