Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666544D8BA
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 06:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723616192; cv=none; b=YKjGYTuwvJG+SV3paIXWyoocOU5Hi8njZpvNKE9y42e1MDtSQhjJtf8iw3e4tRluAwNhB07t+c5iD4qDNEkD9U2K33fQeh87HT1FU7NYiRmlCtcZ1wTDdZCfrr1UAid4ALjQvKn4i2JQBVYVc3O2GBr4bNfOtsnEGqvlpovrYpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723616192; c=relaxed/simple;
	bh=7cnehLmEEUNlTWzBpOTHF5LhpqNqQNIRZWlBMaXLiOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hv3chEk8YVQSwKRlPWGC/vAIs3lRp5Dp0dTgIJC/Lhobn4me5gXnUH0pfvGp8GysfTV4NjcAtRuoT+Oa3+1a021zIFfbOHLKAUC3ATRnRgSMLn5Ao5F5OIehpS7m48E1lyDosvE3oYXF8/fRd43Kn2kzxFI0h4OzEMn1bjCZgIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sv8BirZQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sv8BirZQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08334C4AF10;
	Wed, 14 Aug 2024 06:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723616192;
	bh=7cnehLmEEUNlTWzBpOTHF5LhpqNqQNIRZWlBMaXLiOg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sv8BirZQWJvZi8t5jWTn6XcPWfsDw1riBXx4z9/suvhMlu7Dyai4e71vx63Qntdg/
	 OkKh7cnVYub2HmkcPxP4SDxkrUqCbRY/ZfIEjNQogShMV2V4vyZ1VNkKz+vyjPfFjv
	 FvsZZwziEpr1nXiwuu4RtAT3GxYIRvfZaOcRBgNF8avRuHjYFaSrojcbpD48zx7L/o
	 6IhN5JWD41tVbp2orpZIpOvyK77JrtLdIMQatRKAeMETkIm+Z0q1JNGQ7wTzTaueiA
	 GPJW8nZcm8GBVMMOWIc/bXlUIzyfbbiAVbXTUzwf0PQzOddqQXsFlmnIHql/XHMyc/
	 RTaDHeh7dvlhw==
Date: Tue, 13 Aug 2024 23:16:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: chandan.babu@oracle.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device
 does not support discard
Message-ID: <20240814061631.GF865349@frogsfrogsfrogs>
References: <20240814042358.19297-1-hch@lst.de>
 <20240814042358.19297-2-hch@lst.de>
 <20240814054118.GE865349@frogsfrogsfrogs>
 <20240814054838.GA31334@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814054838.GA31334@lst.de>

On Wed, Aug 14, 2024 at 07:48:38AM +0200, Christoph Hellwig wrote:
> On Tue, Aug 13, 2024 at 10:41:18PM -0700, Darrick J. Wong wrote:
> > Does this still return EOPNOTSUPP if there's no rt device and the data
> > device doesn't support discard?
> 
> Yes, I'll need to fix that.
> 
> > > +	if (rt_bdev) {
> > > +		max_blocks += mp->m_sb.sb_rblocks;
> > 
> > I think this will break xfs_scrub, which (unlike fstrim) breaks up its
> > FITRIM requests into smaller pieces.
> 
> No breakage noticed during my testing, but I'm not sure how that
> would have materialized anyway..

scrub silently starts discarding less than it does now.  My guess is
nobody would notice because meh and who cares? ;)

> > The (afwul) FITRIM interface says
> > that [0, dblocks) trims the data device, and [dblocks, dblocks +
> > rblocks) trims the realtime device.
> > 
> > If the data device doesn't support discard, max_blocks will be rblocks,
> > and that's what we use to validate the @start parameter.  For example,
> > if the data device is 10T spinning rust and the rt device is a 10G SSD,
> > max_blocks will be 10G.  A FITRIM request for just the rt device will be
> > [10T, 10G), which now fails with EINVAL.
> > 
> > I don't have a fix to suggest for this yet, but let me play around with
> > this tomorrow and see if I can come up with something better, or figure
> > out how I'm being thick. ;)
> > 
> > My guess is that what we really want is if either device supports
> > discard we allow the full range, but if a specific device doesn't
> > support discard then we skip it and don't add anything to the outgoing
> > range.len.  But that's what I thought the current code does. <shrug>
> 
> The problem is that if we allow the full range, but return a smaller
> around generic/260 fails.  That is with your patches to not fail if
> FITRIM for the RT device is supported, without them it always fails
> as soon as FITRIM is supported on the RT device.

Ugh.  We can't just lie and add unsupported ranges to range.len because
(a) that's dishonest even if there's no expectation that the discards
did anything and (b) we'd have walk the freespace metadata just to lie.

OTOH generic/260 is butt-ugly with all the accounting special cases in
there.  Maybe there's a way to change the test to figure out how much
discarding is possible on an xfs filesystem so that it can handle
hetergeneous filesystems?

--D
