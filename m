Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A8D47A0B7;
	Tue,  4 Aug 2026 17:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785865349; cv=none; b=s2WpAznzK/niErNXQhA6meKMWBVc7CP2i9pyHUSo4wrtC9MrhhBBD9jIgxOCS4LTUzwDZljuwuSIGPrLSu9NqfeRznCkcforPBSwALSKJamP05ovcvwAaFyK6K6trGjHfPd44+I92GmGapc4HYk9QV9pownyVMI6dwEyEbofVXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785865349; c=relaxed/simple;
	bh=jXatdOHZKZJlfAAaA1bfcq5MC1sXxn3H6cMwUdejr1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S35yH5L3v3Aolc5MxVPuzq0L7S0unCC6AbIPNlrFQW8mnVNTXxJSoesME3fF0zLY4aDfd9BHX2O0yBGu6YfsRoaX6f4kA6CFiUW/cOERT4e/u+LC/LhvUX40UGsR5GGNJS8oBDerJQXqF56xAONcwdcyfOoVcT36rueu0Nhs1mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7AB316732A; Tue,  4 Aug 2026 19:42:23 +0200 (CEST)
Date: Tue, 4 Aug 2026 19:42:23 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v14 05/21] fsverity: improve flushing performance of
 fsverity_fill_zerohash
Message-ID: <20260804174223.GB14046@lst.de>
References: <20260803200820.393203-1-aalbersh@kernel.org> <20260803200820.393203-6-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803200820.393203-6-aalbersh@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 03, 2026 at 10:07:55PM +0200, Andrey Albershteyn wrote:
> The current version calls flush_dcache_folio(), in memcpy_to_folio(), to
> flush whole folio on every digest (which is 128 for 4k) on the HIGHMEM
> systems. Open code folio mapping and flushing to copy all digests at
> once.

This looks correct, although to me optimizing for this feels like
premature optimizations not worth the ugly code unless we have numbers
to justify it.

If Eric wants it:

Reviewed-by: Christoph Hellwig <hch@lst.de>

> +		if (folio_test_partial_kmap(folio) &&
> +		    off > PAGE_SIZE - offset_in_page(offset))
> +			off = PAGE_SIZE - offset_in_page(offset);
> +		for (; to < (vaddr + off); to += vi->tree_params.digest_size)

Style nitpick: no need for braces when comparing with simple
integer arithmetics like this.

> +	for (off = offset; off < (offset + len);

Same here.

