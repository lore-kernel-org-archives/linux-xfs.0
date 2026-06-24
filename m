Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C57530568F
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jun 2026 07:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782286899; cv=none; b=pBImaENlNkEfk2Cm4acnlU8J/hgnoJinVmq6sQhdrZP+7+74PVBQbqKYF6MvDFXLdtP0ByU97gL2042KQO8pjtbde9fgpQ85W1dvsiYZdeDcTrZd1UfTb6va6/NBePUlwx7WLA9Y79hrVT0kOGAi+nP/XJo0Y/uuGKb8BIabVy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782286899; c=relaxed/simple;
	bh=96e6O4jNTVTIghCLCX3yQ4qzwRVJElyLsP7auPtxzNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eeq6AiaBK4kf0zQixaRkhEr7ZuD090rVG5PEO4EA5jikwcGuh7D7iox9ytVhA3eyHgPAO4qClmlmn2AB0m5cJMiY1pZA6Zp4CWtZ9Q8HbtkKxIGESUn10USUEQsbDHNo7R6mUOygu+9/QWvuF2JqRUEVjvx6oOlLKcy0eZeMd2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97CD768BEB; Wed, 24 Jun 2026 09:41:35 +0200 (CEST)
Date: Wed, 24 Jun 2026 09:41:35 +0200
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: simplify the failure path in
 xfs_buf_alloc_vmalloc
Message-ID: <20260624074135.GA12896@lst.de>
References: <20260617055814.3842058-1-hch@lst.de> <20260617055814.3842058-5-hch@lst.de> <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajkrJHFg4lYeWskS@nidhogg.toxiclabs.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 22, 2026 at 02:34:10PM +0200, Carlos Maiolino wrote:
> >  	for (;;) {
> >  		bp->b_addr = __vmalloc(size, gfp_mask);
> >  		if (bp->b_addr)
> >  			break;
> > -		if (flags & XBF_READ_AHEAD)
> 
> My only concern is that looking at it now, isn't obvious why GRP_NORETRY
> has been set in the first place, perhaps worth adding a comment above
> it? Like:
> 		/* Set during readahead */

Maybe.  But in the end we don't really care why it was set, as it clearly
tells us not to retry, right?

