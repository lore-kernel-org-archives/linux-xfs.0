Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9B47F4A
	for <linux-xfs@vger.kernel.org>; Wed, 14 Aug 2024 05:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723614524; cv=none; b=iIO5oIxcD54apvi4F+a3GyZ2O4Kb3nbX5nClz+jKMByh+gbCv+ZhrGNQ9blNYRBLXWs0R+Sx8xd5azROfNR8ZkaKjN3/wnY1L8W0/wCJrD4l/dgURrsd7B/hECyL9oxz8X5MCDc9ckbT6d9/tx8ZG2CpveFMcOrML1BikpaQp1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723614524; c=relaxed/simple;
	bh=KAmIsToeiCMZzuHx44xkk5Jr7r/o0drT4Wt41XFavCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cwda9ZfQ52ue8DWq6N/QO3GsQN2NSrz/VTjCOKy4UtgGuoUnDrUTVOxC1NYoYkEt2hW1RcrNWLCO8zYPZh/c8YdDFZ+ur3PMuoRuWZV3GndeHZLrOOlnRh+3aJwOcYrFQF81zaH716XMaiX/NU051R4Scva82GneTDEr8l92G5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 833DD227A88; Wed, 14 Aug 2024 07:48:38 +0200 (CEST)
Date: Wed, 14 Aug 2024 07:48:38 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt
 device does not support discard
Message-ID: <20240814054838.GA31334@lst.de>
References: <20240814042358.19297-1-hch@lst.de> <20240814042358.19297-2-hch@lst.de> <20240814054118.GE865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814054118.GE865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Aug 13, 2024 at 10:41:18PM -0700, Darrick J. Wong wrote:
> Does this still return EOPNOTSUPP if there's no rt device and the data
> device doesn't support discard?

Yes, I'll need to fix that.

> > +	if (rt_bdev) {
> > +		max_blocks += mp->m_sb.sb_rblocks;
> 
> I think this will break xfs_scrub, which (unlike fstrim) breaks up its
> FITRIM requests into smaller pieces.

No breakage noticed during my testing, but I'm not sure how that
would have materialized anyway..

> The (afwul) FITRIM interface says
> that [0, dblocks) trims the data device, and [dblocks, dblocks +
> rblocks) trims the realtime device.
> 
> If the data device doesn't support discard, max_blocks will be rblocks,
> and that's what we use to validate the @start parameter.  For example,
> if the data device is 10T spinning rust and the rt device is a 10G SSD,
> max_blocks will be 10G.  A FITRIM request for just the rt device will be
> [10T, 10G), which now fails with EINVAL.
> 
> I don't have a fix to suggest for this yet, but let me play around with
> this tomorrow and see if I can come up with something better, or figure
> out how I'm being thick. ;)
> 
> My guess is that what we really want is if either device supports
> discard we allow the full range, but if a specific device doesn't
> support discard then we skip it and don't add anything to the outgoing
> range.len.  But that's what I thought the current code does. <shrug>

The problem is that if we allow the full range, but return a smaller
around generic/260 fails.  That is with your patches to not fail if
FITRIM for the RT device is supported, without them it always fails
as soon as FITRIM is supported on the RT device.
