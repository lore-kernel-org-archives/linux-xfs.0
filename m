Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD1D273F9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622210; cv=none; b=HsaK/4bAMgriN0K8MYuUtkXP7LUphRKEjBQM+SWxkmYqAUS11Ixg35XnGPhN7tBwo6UwB2x0HOCbPjqyGjMpr3K5U8Sp1p4V9XCaFFUHpvfM6cCAZuC8ciOnHGNfJWxlhD6gdxB20TXCQ+XoGm4hfowZ/I1Uw7kyJnN39bySVHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622210; c=relaxed/simple;
	bh=38eG5utsb/3F7y8NaOvoQ+eKy6gMjV50gteiWUNZrp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aBs/JMjLeCOCsAj7jlUphgQDdZYI9Jx4pNTEnFwegaBI791vpR0ElJFOH4T7uisAXMNAJpBJWPaqFk7qb0g2CfwriiNuqmPnv4h8fpgxZf0QMI5JvqE1liI24cy1JhZTL2EyKao6Q4VTTBKpkSEu7yW0nyHD77u+Q0V15OFiElc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KjlpYcVG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KjlpYcVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBF4C116C6;
	Wed, 28 Jan 2026 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769622210;
	bh=38eG5utsb/3F7y8NaOvoQ+eKy6gMjV50gteiWUNZrp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KjlpYcVG33gSoAKOzzOH6PKN54J7UGJiawOCbCSngkLpwAholIxTcggGO5HPujeDq
	 RWnNA/SjUQw+IpQ4vQcZ61ayp2kYAeIa6GEj8LynjgwWGG27owgPSUwyJ018dTZmvt
	 DimAWS1o7k9MWKGP/DuQxV85s+YF5C9jqPV8VMBJDAWIO2opwoWPKVcp2A6WciPwKx
	 WzSpeOTICVm+22d6IRj7a0kreUI1O4F97+B5XO3T8JLElCnwQ4K0AueNIadSE0qFg6
	 6aDlC0YOGnltTpROqTE9lCb9dTYJTf/z0soxXr20xxZnpGJOBfV3vNci120HcUb+Iq
	 mnRjkbuDqs/hg==
Date: Wed, 28 Jan 2026 18:43:26 +0100
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Hans Holmberg <hans.holmberg@wdc.com>, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/10] xfs: move the guts of XFS_ERRORTAG_DELAY out of
 line
Message-ID: <aXpKcQlSnNs3ubHP@nidhogg.toxiclabs.cc>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-5-hch@lst.de>
 <20260128013525.GD5945@frogsfrogsfrogs>
 <aXnv3tWiFlHwOheE@nidhogg.toxiclabs.cc>
 <20260128141016.GA2054@lst.de>
 <20260128160937.GS5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128160937.GS5945@frogsfrogsfrogs>

On Wed, Jan 28, 2026 at 08:09:37AM -0800, Darrick J. Wong wrote:
> On Wed, Jan 28, 2026 at 03:10:16PM +0100, Christoph Hellwig wrote:
> > On Wed, Jan 28, 2026 at 12:18:38PM +0100, Carlos Maiolino wrote:
> > > I'm curious though if is there any reason why those are ratelimited?
> > > It's not like users would be running with error injection enabled or,
> > > they would be flooding the message ring buffer with it.
> > 
> > Good question.  I'd rather not open that can of worms in this series,
> > though.

Oh, for sure. I'm not talking about this series, it's mostly a food for
thought..

> 
> Well... activating an error injector /can/ trigger a lot of activations,
> and it's annoying to try to sift through pages and pages of the same
> message whilst trying to figure out why an fstest broke.  So I'd leave
> the ratelimiting in.

Fair enough.

> 
> --D
> 
