Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD8442589D;
	Fri, 16 Oct 2026 09:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142815; cv=none; b=SYST4i6WZRBHa8dlfzwj2zcOYVli8g9QoR8XZ/4P/ghjg6bChtPikoqEBTAp0kmv1u65/hOZF8ryKZ8GydC0NQ48XeJ8G2sDzWOW+efCeuYH3zCdZwHRPgCZtdkmpIgyiRd7D3ULM+1JeTDsaWomjCI7TvJws7N7wpROtb8goCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142815; c=relaxed/simple;
	bh=fD5oBJ1kxmExb3X3q5XMoQ+FrCySS2QVrulRtGOKWRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sIE6ZWAWi4z7pxD399jNDWt8Kcc8rAAiHhUSbfiW67Rv6yqhWZv9zxB02q9jnxhseL0hltJmm4NR6u9eeB83MXrBhJX3JkQFA8sSKAKTatCenhkxARKwof+ZPxOwuQEK13anJk5j10L+OOfDslG4VRzRGFY/IWxyL+IRBulhNms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 228FF68BFE; Fri, 16 Oct 2026 11:26:49 +0200 (CEST)
Date: Fri, 16 Oct 2026 11:26:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Anuj Gupta <anuj1072538@gmail.com>
Cc: asml.silence@gmail.com, hch@lst.de, djwong@kernel.org, cem@kernel.org,
	brauner@kernel.org, axboe@kernel.dk, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	joshi.k@samsung.com, anuj20.g@samsung.com, nj.shetty@samsung.com
Subject: Re: [RFC 3/4] iomap: add dma-buf direct I/O guards and
 registration helper
Message-ID: <20261016092648.GC23141@lst.de>
References: <20261016091919.971295-1-anuj1072538@gmail.com> <20261016091919.971295-4-anuj1072538@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016091919.971295-4-anuj1072538@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Oct 16, 2026 at 02:49:13PM +0530, Anuj Gupta wrote:
> From: Nitesh Shetty <nj.shetty@samsung.com>
> 
> Direct I/O copies data from the CPU in three places, zero-filling
> holes, inline data, and bounce pages. A dma-buf iterator has no
> CPU-visible pages, so refuse it.
> 
> Reads that encounter a hole or unwritten extent therefore return
> -EOPNOTSUPP for the entire operation, even if I/O for an earlier mapped
> extent was already submitted.
> 
> Also add iomap_file_init_dma_buf_io_ctx(), so filesystems can register
> without open-coding the DAX check. The filesystem picks the device,
> iomap does the rest.
> 
> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  fs/iomap/direct-io.c  | 31 ++++++++++++++++++++++++++++++-
>  include/linux/iomap.h |  3 +++
>  2 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce8..fc40f4367ee7 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -427,6 +427,10 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  	unsigned int alignment;
>  	ssize_t ret = 0;
>  
> +	if (iov_iter_is_dmabuf_map(dio->submit.iter) &&
> +	    (iomap->flags & IOMAP_F_INTEGRITY))
> +		return -EOPNOTSUPP;
> +
>  	/*
>  	 * File systems that write out of place and always allocate new blocks
>  	 * need each bio to be block aligned as that's the unit of allocation.
> @@ -595,7 +599,13 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  
>  static int iomap_dio_hole_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  {
> -	loff_t length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
> +	loff_t length;
> +
> +	/* a device mapping cannot be zeroed from the CPU */
> +	if (iov_iter_is_dmabuf_map(dio->submit.iter))
> +		return -EOPNOTSUPP;
> +
> +	length = iov_iter_zero(iomap_length(iter), dio->submit.iter);
>  
>  	dio->size += length;
>  	if (!length)
> @@ -612,6 +622,10 @@ static int iomap_dio_inline_iter(struct iomap_iter *iomi, struct iomap_dio *dio)
>  	loff_t pos = iomi->pos;
>  	u64 copied;
>  
> +	/* inline data is copied from the CPU, which a device mapping bypasses */

Overly lone line here.

> +	/* bouncing copies the data from the CPU, which a device mapping bypasses */

.. and here.  Note that could still copy to/from the device memory in
either case, but that's probably rather pointless at least for actual
device dmabufs.  It might be useful for udmabuf or other kernel
allocations, though.

