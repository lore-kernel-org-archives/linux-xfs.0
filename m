Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4952E762C
	for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2026 06:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790403605; cv=none; b=D7RoEhxGaXFLZ+T+kjvXvRwuKQhjVim+piQGLa8OHdOEGBP1NSoyNB2XI3pcffleMbAkjPsaykQ9gUrGoGMWTsbo3SV6qKg/NaRbZqJqcmbYq5dFK7fxI4WSsOuak+WP16iZf4yTh2okcatKtlW1WB77Jpr/75Ibu/D2Z/t3l1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790403605; c=relaxed/simple;
	bh=QquJwca0gl1lZPHax8WU+tourBXaHczVHCrBE1hU1SM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvO0NNcAtE+Lk6vd06Yr+XJVOyV97Osh1MJ18zxbd3syyMBHl2dejBYJQ0hWbj5FouszXL7r9yvNAAAPvZlT6omiMcRKHzopP/ef3WwIzuf+20yLEFriNqaII+OVdtN1aqKHn/wrWq9mlGzYSzeD5AsMWTRUhYJAFoop/YEh3hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EE3BC68C4E; Sat, 26 Sep 2026 08:19:59 +0200 (CEST)
Date: Sat, 26 Sep 2026 08:19:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/32] mkfs: support RT data checksums
Message-ID: <20260926061959.GK20636@lst.de>
References: <20260924100512.2733748-1-hch@lst.de> <20260924100512.2733748-30-hch@lst.de> <20260925233908.GO2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925233908.GO2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Sep 25, 2026 at 04:39:08PM -0700, Darrick J. Wong wrote:
> >  	R_RESERVED,
> > +	R_CSUM,
> > +	R_CSUMBSIZE,
> 
> BTW now that Andrey has merged the config file generator code, you'll
> have to add the relevant R_CSUM/R_CSUMBSIZE bits to libfrog/fsgeom.c.

Oh, right.  Another fun learning experience :)

> >  /* data subvol */	[-d agcount=n,agsize=n,file,name=xxx,size=num,\n\
> >  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
> > -			    sectsize=num,concurrency=num]\n\
> > +			    sectsize=num,concurrency=num,\n\
> > +			    csum=type]\n\
> 
> There's no csum= parameter for -d, or at least I didn't see a D_CSUM
> entry above.

Correct.  This is left from an earlier series where I tried to support
cheksums on the data device using NVMe non-PI metadata, but that didn't
got to well.

> > +	cfg->sb_feat.rtcsum_blklog = 0;
> > +	for (l = cfg->rtcsumbsize; l > 1; l >>= 1)
> > +		cfg->sb_feat.rtcsum_blklog++;
> 
> log2_roundup?

Ah, nice.  I was looking for a userspace version of the kernels ilog2,
but could not find it.

