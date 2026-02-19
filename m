Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4996E2E541E;
	Thu, 19 Feb 2026 06:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481486; cv=none; b=fogEpidiCfG/7GPJqFCHRYa/GAV2i5z5u8eNfMHI9SfFaKaaRX195fj85sjMblk+IaDixT1iOEr/dd7hrBTKzVYCrAGRxhdNzLCG2JfTJEc1ux8rmReWzf54BndCF7O386YbFJQw9nhwW2uIG/RXaEJkP7AcxYOT+CiV5AfIllk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481486; c=relaxed/simple;
	bh=e3t3WjjBQq0ZzdFNYZhOQWXe5BFqqRITUn2G5ny4C94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uVJDCy55BP5U27yXoOXqdg9tVPtixXvkkvGO8GHcOhWeuklpNcDn+E1UPUndbG2S4bssAJeOQbm55g1NE84iE7eQABHSzZLOGyQjH472ZHSWV+cFwz824ZHeQtXbpagp/MZ8Id9MfKwCqGj3B45fg/ZPC4BHwNgFmGO3ZR45v/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B8CA568C7B; Thu, 19 Feb 2026 07:11:22 +0100 (CET)
Date: Thu, 19 Feb 2026 07:11:22 +0100
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3 28/35] xfs: add fs-verity support
Message-ID: <20260219061122.GA4091@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-29-aalbersh@kernel.org> <20260218064429.GC8768@lst.de> <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mtnj4ahovgefkl4pexgwkxrreq6fm7hwpk5lgeaihxg7z5zdlz@tpzevymml5qx>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 18, 2026 at 10:57:35AM +0100, Andrey Albershteyn wrote:
> > > +static int
> > > +xfs_fsverity_drop_descriptor_page(
> > > +	struct inode	*inode,
> > > +	u64		offset)
> > > +{
> > > +	pgoff_t index = offset >> PAGE_SHIFT;
> > > +
> > > +	return invalidate_inode_pages2_range(inode->i_mapping, index, index);
> > > +}
> > 
> > What is the rationale for this?  Why do ext4 and f2fs get away without
> > it?
> 
> They don't skip blocks full of zero hashes and then synthesize them.
> XFS has holes in the tree and this is handling for the case
> fs block size < PAGE_SIZE when these tree holes are in one folio
> with descriptor. Iomap can not fill them without getting descriptor
> first.

Should we just simply not create tree holes for that case?  Anything
involving page cache validation is a pain, so if we have an easy
enough way to avoid it I'd rather do that.

