Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419E632A3D7
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796535; cv=none; b=D7wiQu53uPTj9HBzKqTAMrQ0XjVzAVzUoqmsBnQhCayZC3vci5ccpBVSE5JNLwIQFMasM7GTuifYPCid6Q8HtDB7M8cIYyi6IU00CdxpDLGEvRxLA8jEBINbplfpb8uMQHhVmtvBb534mEAjRZlGEfFuJl3Y6XBivgOQnXGPUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796535; c=relaxed/simple;
	bh=woDfXGpvqD3kJ+HIecxAMy0b4nzElMqMd7a1W5pHZhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AP7+WPKp/ZAlN8ZJqZeCDB+fiKyvzA/M0syUeZ5eqVzM54eG/kpF4WzPTk+ldh7/ucOB8QnO6ian52EM1mydE8jaJiW6hLmcJ4YEE0EiX+GAmVvbhNgqyMBWpK9v8nVhaRpoBzzO4JDO/6ZN/NiFQKfdiPYlIB3lHaPBrD7GPxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0DA6768C4E; Tue, 30 Jun 2026 07:15:31 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:15:30 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs: fix incorrect use of gfp flags in
 xfs_buf_alloc_backing_mem
Message-ID: <20260630051530.GC20771@lst.de>
References: <20260617055814.3842058-1-hch@lst.de> <20260617055814.3842058-4-hch@lst.de> <20260630014935.GI6078@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630014935.GI6078@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:49:35PM -0700, Darrick J. Wong wrote:
> > +	return xfs_buf_alloc_folio(bp, size, gfp_mask);
> 
> Hrmm, ok.  So first we special-case buffers > PAGE_SIZE -- if they're a
> power of two, we try (not very hard) to allocate a single large folio.
> If that fails or it's not a power-of-two, then we just do vmalloc, which
> allows direct reclaim and retries.

Yes.

> For smaller than PAGE_SIZE buffers that are powers of two, I guess we
> use the slab allocator, otherwise a full folio.  That part strikes me as
> a little strange (efficiency, I guess?), but that's what the code did
> before so I guess it's ok.

That's because slab doesn't guarantee alignent for non-power-of two
allocations, and we need that for the block layer.  There is a comment
in the code explaining that.

