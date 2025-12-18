Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A779019CD0A;
	Thu, 18 Dec 2025 09:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766051133; cv=none; b=GWoiVNLyqLDKghgcRZaFj0gIuZIeFPcKLeCskpzizAYVHO4rP63DpC7vW7B7zu1mqJIxfToTvQuDoo8wqeM9NFrPVdxZa2yxnI96f4WFk6R/I2cKkEtCwBK0Luyi7xTpQ+G0qwdzklNdnH7eVmCY2AjhbBbkEX5HQb55+XPkgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766051133; c=relaxed/simple;
	bh=fkcelwqTsF89+HlRta8uDdbmAEpcH5zat2Dex6HfToA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eb5baTPXY0m2K3nPeuitNgUsEmjjzXeYvEBL2IQ+g+Mx4NzUPbBElsXq+Sovmg4BEDRqAwYFVOUg15q16sxEGkGDDtCOjuGM6Kmuazr1Ur+px6DC6wMc7cu/XjBNEY5D+w0wY7Kb0PBA5OlEcMfMnfzzbmhKdoU5lKO5O1myGJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1C6EA68AFE; Thu, 18 Dec 2025 10:45:27 +0100 (CET)
Date: Thu, 18 Dec 2025 10:45:26 +0100
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <20251218094526.GA10629@lst.de>
References: <20251218063234.1539374-1-hch@lst.de> <20251218063234.1539374-2-hch@lst.de> <aUPL8Jr39N-SIf_W@fedora>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUPL8Jr39N-SIf_W@fedora>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Dec 18, 2025 at 05:40:00PM +0800, Ming Lei wrote:
> > +/**
> > + * bio_reuse - reuse a bio with the payload left intact
> > + * @bio bio to reuse
> > + *
> > + * Allow reusing an existing bio for another operation with all set up
> > + * fields including the payload, device and end_io handler left intact.
> > + *
> > + * Typically used for bios first used to read data which is then written
> > + * to another location without modification.
> > + */
> > +void bio_reuse(struct bio *bio)
> > +{
> > +	unsigned short vcnt = bio->bi_vcnt, i;
> > +	bio_end_io_t *end_io = bio->bi_end_io;
> > +	void *private = bio->bi_private;
> 
> The incoming bio can't be a cloned bio, so

It better no be, yes.

