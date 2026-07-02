Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D54454BC005;
	Thu,  2 Jul 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783000816; cv=none; b=VDyTE5n1llso5dEWy6UWb/ja5fpbKiacb1m9oSBZyvBl83wgGGkVROoOApBpVvOXHDWsl+9g5kVjL4nZXbDRCl+91BoiBYfuyQhI79cSKkW+WCrsjtzQYJryfHEeW8uxdenMkEsLB0Pf2DGx7Fu5hCz2WXTWwEf2p6d4wNo4jyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783000816; c=relaxed/simple;
	bh=ji7n9XrdoZf8luFTdAO2J9+a/gKqaz+RyAefvQaeZEo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FvdhxZwlfKGN1H2wcJ0nO36zApyXCeWFPhyClh+VRS3mboe7H8JVgil2Rfy3HkF+2T+R6I4F7DbcCLxLUeP6+ALXmVmMMYU0q5CM52TlByA6nTuC02gc7eQvxpKwycHa8owAWn9Eu9oi51jF/sfrK1zVM2DYQvQPu84zv39HWsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6BFF468BEB; Thu,  2 Jul 2026 16:00:09 +0200 (CEST)
Date: Thu, 2 Jul 2026 16:00:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: brauner@kernel.org, hch@lst.de, djwong@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/18] iomap: add ->iomap_next() and iomap_process()
 helper
Message-ID: <20260702140009.GA21339@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-2-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701000949.1666714-2-joannelkoong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 30, 2026 at 05:09:16PM -0700, Joanne Koong wrote:
> +static int iomap_iter_legacy(struct iomap_iter *iter, const struct iomap_ops *ops)

Overly long line here.  Not that it really matters too much given
that this goes away by the end of the series.

> + * Iterate over filesystem-provided space mappings for the provided file range.
> + *
> + * This function handles cleanup of resources acquired for iteration when the
> + * filesystem indicates there are no more space mappings, which means that this
> + * function must be called in a loop that continues as long it returns a
> + * positive value.  If 0 or a negative value is returned, the caller must not
> + * return to the loop body.  Within a loop body, there are two ways to break out
> + * of the loop body:  leave @iter.status unchanged, or set it to a negative
> + * errno.
> + */
> +int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops)
> +{
> +	if (ops->iomap_next)
> +		return iomap_iter_next(iter, ops);
> +
> +	return iomap_iter_legacy(iter, ops);

Maybe inline the code currently in iomap_iter_next here from the
start, as that what we're getting to by the end of the series anyway.
And just do a:

	if (!ops->iomap_next))
		return iomap_iter_legacy(iter, ops);

at the beginning?

> +int iomap_iter_continue(const struct iomap_iter *iter, struct iomap *iomap,
> 

It seems like this is largely just factored out form the old iomap_iter().
Can you do a prep patch before this one which factors this out?
Preferably in a way that keeps the code in roughly the same place to
minimize the git blame disturbance?

