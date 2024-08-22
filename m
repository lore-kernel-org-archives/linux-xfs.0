Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00A723741
	for <linux-xfs@vger.kernel.org>; Thu, 22 Aug 2024 03:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724298075; cv=none; b=bWslPROauuPp6LA/t/wSH0xEbJeEI19OOW+PNx6N4fVvMRw3ZaMUiL1IuAvVp+k1l1Pe8KetYdTIW1r123qYOAmxsYi1Ngz17RSUlkWexC21AzuNaZ5SrnAReAP8tFjmwCEy01swv8/gtQZPy/X/4FTEQAU6WdLzHGJiK6JY9Ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724298075; c=relaxed/simple;
	bh=v2QgGDN81azFqKcAqkKS3DpkEYX7WY/aKbZIPSe7JK8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jNsOYl7p4r2OGsHWFBF3DuwGw0haZpe68IrdtEGuX5I3hMBfwHOgTJTQ2K5p1oYI2yKDq4a02QW1J1Ih0ibr1hxEmMQLfhb6sXLmpzeqfLX5YxnJU5lQDyGwV/O/b48cabx9bAZss75WKxxPXTunWkH1YBLuCdLvc+BNQ0yaXv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ECEBE227A8E; Thu, 22 Aug 2024 05:41:09 +0200 (CEST)
Date: Thu, 22 Aug 2024 05:41:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/6] xfs: support lowmode allocations in
 xfs_bmap_exact_minlen_extent_alloc
Message-ID: <20240822034109.GB32681@lst.de>
References: <20240820170517.528181-1-hch@lst.de> <20240820170517.528181-7-hch@lst.de> <20240821160723.GA865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240821160723.GA865349@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Aug 21, 2024 at 09:07:23AM -0700, Darrick J. Wong wrote:
> On Tue, Aug 20, 2024 at 07:04:57PM +0200, Christoph Hellwig wrote:
> > Currently the debug-only xfs_bmap_exact_minlen_extent_alloc allocation
> > variant fails to drop into the lowmode last restor allocator, and
> 
>                                          last resort?

Yes.

> > +	/*
> > +	 * Use the low space allocator as it first does a "normal" AG iteration
> > +	 * and then drops the reservation to minlen, which might be required to
> > +	 * find an allocation for the transaction reservation when the file
> > +	 * system is very full.
> 
> Isn't it already doing a minlen allocation?  Oh, that probably refers to
> shrinking args->total, doesn't it.

Yes, without this patch ap->total is left at the full value and never
reduced.

