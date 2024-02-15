Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C4079DD
	for <linux-xfs@vger.kernel.org>; Thu, 15 Feb 2024 05:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707974661; cv=none; b=KFAzpMbBwreiKbkLg9iijJBy5lAYu2QrPE6vm4hfnvNL9w/jjn1Nh73BBYwODPD+7Pez8O6qW5yjapjgu/dgRb7F1uEnFzfTNC6+nu15aNnbPBebzcvqp17+k19rHRbTtiS6Ir30lOgtMjj+ozv1D4UDqE36mCz1nuYLYuZLOmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707974661; c=relaxed/simple;
	bh=qtUVW6E3NXcP1pQpIUbAMj/q+BqmhUI9Jwcq8coaLlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q4ifUnX20JATSc6AHNFrk/K+XLSkMbQb3kNi/hfZlifSIWVAqlHccd0vpYNGY1XSaDfWNc45K+RDb+5GMOKy2J1B+BtJy3ixMrX+bhU7MtD9oikcvFxon9KpVDsUgS0EsgoLxr/EUkuccJtswMMiFCgnmwZmkCB7NK1qFoab3BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 11CF467373; Thu, 15 Feb 2024 06:24:16 +0100 (CET)
Date: Thu, 15 Feb 2024 06:24:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/27] repair: refactor the BLKMAP_NEXTS_MAX check
Message-ID: <20240215052415.GA5617@lst.de>
References: <20240129073215.108519-1-hch@lst.de> <20240129073215.108519-4-hch@lst.de> <Zc1IjZm8sd2dLSBV@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zc1IjZm8sd2dLSBV@dread.disaster.area>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 15, 2024 at 10:11:09AM +1100, Dave Chinner wrote:
> > -#if (BITS_PER_LONG == 32)	/* on 64-bit platforms this is never true */
> > -	if (nex > BLKMAP_NEXTS_MAX) {
> > +	if (sizeof(long) == 32 && nex > BLKMAP_NEXTS32_MAX) {
> 
> That's a really, really big long. sizeof(long) = 4, perhaps?

Yes.
