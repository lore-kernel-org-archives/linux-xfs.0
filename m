Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7574D271456;
	Fri,  9 Jan 2026 16:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767976224; cv=none; b=ASPBPcG7JrScNWT9o1J2k03UKHViDHTTK1gmUEsoxsxeeHjmMs840sSGze21T9xu5DGCSzqGFq893jjDIs8uOc2AIAfiRM0MO1gHnu4rozGc810+pxuWZ75JFuV+vSKYGzVJeuAhve5FLJKhICqQ2TSZAVHzVjwhZyV1LrRxj/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767976224; c=relaxed/simple;
	bh=M/yqtirED+VcZXJl8nGUr340RjD4PMfUeZjAFFhLUXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lb+FQc1ZdzlzooC5MR3+6olFVRnyoN2Xdb2RjAox0pHcYqCdCHXJ0TxFK0RHPPFsdWGvMaX3s+T6rdbFKfgLbIW4VEmkN5OCiILx8pNQ1OrnuV8NgmAhU9vnMPp0CJZ+8yFys/5+XJFK0NDno8IOEBDFCQkDcinMH35I8IIfbJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/U7JDPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/U7JDPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A752C4CEF1;
	Fri,  9 Jan 2026 16:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767976224;
	bh=M/yqtirED+VcZXJl8nGUr340RjD4PMfUeZjAFFhLUXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X/U7JDPcI3gDeG/lO+XatA9a1MUfcw6mC9hHjEnoCsCUSyKcNCZXE8Wq431i8u/AU
	 PWfo6VRPb48tAZMiYcrxq7Xm17DH08MNEMvJB5PL2VKvr4PeVJ3+G3A3KwByaHvjM/
	 mpRAHzTuIN+z2EW+k5CSQXijCW7mg8Vx/89X2erDBel0741s1MRKmX/kUqog7gOsUN
	 LZaCqzTwn1QuoNflw+PkgELKDVkb4vrbYzSEWZPGEnHFpT7r0IukVt8za2KRPqtSsA
	 b0/4zvgGT1oLPrOIlqDZ83toKm47I7Son8LVxpr4uMd24Lw8FiCa1sbJtrnDnTL8La
	 nXlwa1AHy0ffA==
Date: Fri, 9 Jan 2026 17:30:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <aWEst_dAEWFO3JYd@nidhogg.toxiclabs.cc>
References: <20260106075914.1614368-1-hch@lst.de>
 <20260106075914.1614368-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075914.1614368-2-hch@lst.de>

On Tue, Jan 06, 2026 at 08:58:52AM +0100, Christoph Hellwig wrote:
> Add a helper to allow an existing bio to be resubmitted withtout
> having to re-add the payload.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>  block/bio.c         | 29 +++++++++++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  2 files changed, 30 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index e726c0e280a8..ed99368c662f 100644
> --- a/block/bio.c
> +++ b/block/bio.c

Jens, would you be ok if I pull it through XFS tree, giving it's tightly
connected to xfs?

I have it in our for-next for now so that it can be tested, but I plan
to update it once you pull the patch. If you're ok with this going
through xfs tree, I'll just leave it as-is.

Carlos

> @@ -311,6 +311,35 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>  }
>  EXPORT_SYMBOL(bio_reset);
>  
> +/**
> + * bio_reuse - reuse a bio with the payload left intact
> + * @bio bio to reuse
> + *
> + * Allow reusing an existing bio for another operation with all set up
> + * fields including the payload, device and end_io handler left intact.
> + *
> + * Typically used for bios first used to read data which is then written
> + * to another location without modification.  This must be used by the
> + * I/O submitter on an bio that is not in flight.  Can't be used for
> + * cloned bios.
> + */
> +void bio_reuse(struct bio *bio)
> +{
> +	unsigned short vcnt = bio->bi_vcnt, i;
> +	bio_end_io_t *end_io = bio->bi_end_io;
> +	void *private = bio->bi_private;
> +
> +	WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED));
> +
> +	bio_reset(bio, bio->bi_bdev, bio->bi_opf);
> +	for (i = 0; i < vcnt; i++)
> +		bio->bi_iter.bi_size += bio->bi_io_vec[i].bv_len;
> +	bio->bi_vcnt = vcnt;
> +	bio->bi_private = private;
> +	bio->bi_end_io = end_io;
> +}
> +EXPORT_SYMBOL_GPL(bio_reuse);
> +
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>  	struct bio *parent = bio->bi_private;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index ad2d57908c1c..c0190f8badde 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -414,6 +414,7 @@ static inline void bio_init_inline(struct bio *bio, struct block_device *bdev,
>  }
>  extern void bio_uninit(struct bio *);
>  void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
> +void bio_reuse(struct bio *bio);
>  void bio_chain(struct bio *, struct bio *);
>  
>  int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
> -- 
> 2.47.3
> 
> 
