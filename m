Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6938B204F78
	for <linux-xfs@vger.kernel.org>; Tue,  4 Mar 2025 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741097214; cv=none; b=VOMptFQhedNC8jMrx4ypphNeh+6OoqY7wyZjslke5VIuIWFpDOZnEjiUcuWKrC9MLLyIMJeKlQ7W9SqOlPVnd+0eJaqiSDP7oTeA+99j9CzmxfjIXpoXelGu4XudB3l/MMHOgyNLTJxZ5Z6Jq/g4nIMMFS+cX+wmR2dhDdBVR0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741097214; c=relaxed/simple;
	bh=fMwmf899YFUbwmHOfESb2HQSZaRzUs9PvVYODTs4jdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvwKLJCPGAEOvum6/chyC18E8moUltQJm47d3R5qKswrZlpflv8v5ZZ4A6QVEv0k6qgn5c95pYna/S6T67mrM18KBAgeZrRw1k1CnQ29tQqdF7IhI7YDW8ubfzYJZf9pxgrO0oc0YcH2XOocVlsb03xdGPsAsg0MAhhKF2CQs5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8672668D05; Tue,  4 Mar 2025 15:06:48 +0100 (CET)
Date: Tue, 4 Mar 2025 15:06:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/12] xfs: convert buffer cache to use high order
 folios
Message-ID: <20250304140647.GB15778@lst.de>
References: <20250226155245.513494-1-hch@lst.de> <20250226155245.513494-8-hch@lst.de> <20250226173333.GR6242@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250226173333.GR6242@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 26, 2025 at 09:33:33AM -0800, Darrick J. Wong wrote:
> > -	mm_account_reclaimed_pages(bp->b_page_count);
> > +	mm_account_reclaimed_pages(
> > +			DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE));
> 
> Why do we round the number of bytes in the buffer up to base page size?
> 
> Don't we want howmany(BBTOB(bp->b_length), PAGE_SIZE) here?
> 
> Oh wait, howmany *is* DIV_ROUND_UP.  Never mind...

I'll use howmany for consistency with the rest of the XFS code.

> > -	/* Make sure that we have a page list */
> > +	/* Assure zeroed buffer for non-read cases. */
> > +	if (!(flags & XBF_READ))
> > +		gfp_mask |= __GFP_ZERO;
> 
> Didn't this get added ten lines up in "xfs: remove the kmalloc to page
> allocator fallback"?

Yes.  Looks like I didn't finish my refatoring to not duplicate this
properly.

