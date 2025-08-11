Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7DE268C40
	for <linux-xfs@vger.kernel.org>; Mon, 11 Aug 2025 10:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754909414; cv=none; b=Y9B2g3kn0LAB6S05Z+DHSlTuZO5uMH3l21sR0405UvvtPANH6pLqjnSqxM5xcT6kqysuEc7SvgbB+hWtSEpHedkF1Wop1TcBvFuXE/sbAROUKOor6sM3RmPWnH4neS53mfSjet/vIbxadDAAHX1nwno3Uve0TUvPaOmdbJnMoLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754909414; c=relaxed/simple;
	bh=7ag2rAxGx3YWMkweJnDP4gf6b/EIQn1bNSOorAW02c8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kpnj9RusiXHaMJx30aKASA5waFVjWg0n+Ry6qgFmE7Vyu/mJTYxGKP5cxCysmRcCzxay8VCClNsbORulZZsooJv1A8HBewDIsFmYAmlvgfPWwiNFP0tTvVwaI1R5c8GScW8NLhlQRWFIK2Gm8Mtr4urMrkeWRZi5cdnap3smLZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2933368AA6; Mon, 11 Aug 2025 12:50:08 +0200 (CEST)
Date: Mon, 11 Aug 2025 12:50:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] xfs: Select XFS_RT if BLK_DEV_ZONED is enabled
Message-ID: <20250811105007.GA4581@lst.de>
References: <04bqii558CCUiFEGBhKdf6qd18qly22OSKw2E3RSDAyvVmxUF09ljpQZ7lIfwSBhPXEsfzj1XUcZ29zXkR2jyQ==@protonmail.internalid> <20250806043449.728373-1-dlemoal@kernel.org> <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q5jrbwhotk5kf3dm6wekreyu5cq2d2g5xs3boipu22mwbsxbj2@cxol3zyusizd>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 06, 2025 at 09:46:58AM +0200, Carlos Maiolino wrote:
> > +	select XFS_RT if BLK_DEV_ZONED
> 
> This looks weird to me.
> Obligating users to enable an optional feature in xfs if their
> kernel are configured with a specific block dev feature doesn't
> sound the right thing to do.
> What if the user doesn't want to use XFS RT devices even though
> BLK_DEV_ZONED is enabled, for whatever other purpose?
> 
> Forcing enabling a filesystem configuration because a specific block
> feature is enabled doesn't sound the right thing to do IMHO.

Yes.  What might be useful is to default XFS_RT to on for BLK_DEV_ZONED.
I.e.

	config XFS_RT
		...
		default BLK_DEV_ZONED
		...

That way we get a good default, but still allow full selection /
deselection.
