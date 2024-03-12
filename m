Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3471B13B2BF;
	Tue, 12 Mar 2024 21:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710277578; cv=none; b=aSYPtqLGXtVC/fWK7n3vIW/Qukp45IQmXq/g2cERUVH+EozfsiI20ItK0pIBEj0k7rnY88N99UKrM6qMQ2rYYkrfiTROKepVeGiYq8OmOOuJteaivUxc9FI8lDx6hj1z6J9/oRybl0z06Ouju36pV/68t5Q6wKfVhmZUDCFdhJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710277578; c=relaxed/simple;
	bh=NZtNQe8FfSLe7l5huBX7qHg3m0jeJ/yz/2Nr1uH4Apw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TcTRKis85VFhJpJhR+QyNDZkd5/B599yRM1b2I/AYC4PBZ+3u2jQLSFtKkLYbTw2HPDlNkSUSIf7HBQYIrP4YVvEwnluBs/F+v11PdjlibZVnASUfQM0boeKXLORkWcru8x8dkq6FeYJUySGitEdmnahpf0Nq+Ye8y2d490olGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9551768BFE; Tue, 12 Mar 2024 22:06:05 +0100 (CET)
Date: Tue, 12 Mar 2024 22:06:05 +0100
From: Christoph Hellwig <hch@lst.de>
To: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] block: add a bio_chain_and_submit helper
Message-ID: <20240312210605.GA1500@lst.de>
References: <20240312144532.1044427-1-hch@lst.de> <20240312144532.1044427-3-hch@lst.de> <ZfBr91m4oQS_VYFg@kbusch-mbp.mynextlight.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfBr91m4oQS_VYFg@kbusch-mbp.mynextlight.net>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Mar 12, 2024 at 08:51:35AM -0600, Keith Busch wrote:
> > +
> > +struct bio *blk_next_bio(struct bio *bio, struct block_device *bdev,
> > +		unsigned int nr_pages, blk_opf_t opf, gfp_t gfp)
> > +{
> > +	return bio_chain_and_submit(bio, bio_alloc(bdev, nr_pages, opf, gfp));
> > +}
> 
> I realize you're not changing any behavior here, but I want to ask, is
> bio_alloc() always guaranteed to return a valid bio? It sure looks like
> it can return NULL under some uncommon conditions, but I can't find
> anyone checking the result. So I guess it's safe?

bio_alloc can only fail if we don't wait for allocations, that is if
__GFP_DIRECT_RECLAIM isn't set.

We could an assert here.  Or work on killing the gfp_flags argument
and just add a bio_alloc_nowait for the few cases that need it.
