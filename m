Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2729A30F927
	for <linux-xfs@vger.kernel.org>; Fri, 12 Dec 2025 08:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765527114; cv=none; b=pTZZJFEoz2m5LefRXF/mwgOVLNo5o6ON6XDlo+dmz2cgZPUblIOP6fdyd0ukuBiaYesfcVjWOTanaCMqooHepac0av5faPipLsJs4MiEPZ132W5paNVAR4VcCNAgqjBJvjy8/1jPIdEUGyFgS+A1KZpjnnvO8CRawEVZtP046q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765527114; c=relaxed/simple;
	bh=Y+oXJFitxbVQc0F7yqQsuwUvdxMO8g4n9JVqmB7BNV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U7XgTvbIwe6J0R9+QwkF5wcGvGeu74v/G9BPo6UKUtSj1HrUdwCqAyL1yNSCfln34Cwpy/vMkgkxm4Q1j9Fmfn6PrrZ0Ny9qM08sYpVPJ4o/NPxyEQOwatFZUJA1rl1DpZL+Kcz8Sbk49B4pm6bV9izhFpY9quLbPD6gM+bHkvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NYybBXeK; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NYybBXeK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=moibsbABWkGI9DiUIHI+KbFed0mUTv9pO2PB0k2kZ0c=; b=NYybBXeKDHeeCbEYEMOeHoFBcg
	Fi0h3pYi+xxZLRkuWKpIBpJPv51XUGAQBEZJyTh19SE0XgP6ANZBSEcav9T0dDzra1gTmG+bEu88F
	xFbqu0WpTj+sExIF/c4+7N1WwavWGk+vSPwvfkJaLL1y0seTaFpX1Pss+DDC63tyVWh5n9LgqxaYw
	7I7K2N7cKGV5pF+AlvVhsi6e0fC8Jc1rE2AMVdjH+Ju4DeXozWLzxkmjc/TpliiRdHsHRoeToI0n1
	k/6jEW0177qslv2ewHhhiM+nP5/EO95C/0+prPPxiSzODGILY0BQ1YzF8Z4ER2SLzZuk+K6CIzSaK
	Pp41MdGQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vTyFe-00000000FW2-1IfA;
	Fri, 12 Dec 2025 08:11:46 +0000
Date: Fri, 12 Dec 2025 00:11:46 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Luca Di Maio <luca.dimaio1@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	dimitri.ledkov@chainguard.dev, smoser@chainguard.dev,
	djwong@kernel.org
Subject: Re: [PATCH v1] xfs: test reproducible builds
Message-ID: <aTvOQqfpiJDCw7e5@infradead.org>
References: <20251211172531.334474-1-luca.dimaio1@gmail.com>
 <aTun4Qs_X1NpNoij@infradead.org>
 <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hxcrjuiglg4qjn4qzgnwdtxpcv6v47rpjrkxaxhmanhxvvwzpx@rz4ytlnsjlcm>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Dec 12, 2025 at 09:09:56AM +0100, Luca Di Maio wrote:
> > > +# Compute hash of the image file
> > > +_hash_image()
> > > +{
> > > +	md5sum "$1" | awk '{print $1}'
> > 
> > md5sum is pretty outdated.  But we're using it in all kinds of other
> > places in xfstests, so I think for now this is the right thing to use
> > here.  Eventually we should switch everything over to a more modern
> > checksum.
> 
> Will move to sha256sum

I mean stick to md5sum for now.  We should eventually migrate
all md5sum user over when introducing a new dependency anyway.
Combine that with proper helpers.  If that's something you want
to do it would be great work, but it should not be requirement
for this.

