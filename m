Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C1320CB6;
	Fri,  9 Jan 2026 12:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960736; cv=none; b=bm/DZM+scCsbCz8lCyUrbDDo4923HwL65K3AjYfROPRf5feR1aU3LShhlaQGEjfeBd+PBJnkq+xFrmiFr6jziuubGoTnV4AeErus84FPIcz0h6lXL6tRvtpVfyzVHYblnGHHA8EdmmltujL8cLbdHezL8VKVjk1pC7tqTaFbhiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960736; c=relaxed/simple;
	bh=QAyq9MeN133tnkasGxaRXmYGotMoz8E9R9G6K0jt4wo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBBTbyxrzJtZ4wE2P6nLzTUk7JVHpwSi73olUqc5MxY5gLZPMMf9e58E1cW6+h6PiwkvXuKmk5Tovbg0TKCAFrXEvJZ9ZdLsPreq8CuxXhSLsZ9AYNDzJb27n4AbvDXD5bmYTwplKigmNTEzv891mlJLEdxAE0LfU2oWFaKCI0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YT5jMHOW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YT5jMHOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF77C19422;
	Fri,  9 Jan 2026 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767960736;
	bh=QAyq9MeN133tnkasGxaRXmYGotMoz8E9R9G6K0jt4wo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YT5jMHOWk/WBsID+lQGJMpRPgXnRnavN0ANS/A4ozJXqpDjfVoFuQjSuPWGufdHqM
	 Km3yKS4H0B0JWUY8/Y2t6i9DXnghZH6SEhhm+wCo8W4Kg2OY7oQcOJlfL7PAQPJ2HS
	 4Et2yDeIxprSNz4NhhcpJmVuoNX+zxQeFyeGXRFTlF5/E/A4L8AeWu4XHc81fnbBvg
	 fdlJ+Y/CZ3B6rHc/5Zk7HMaOpx6X9zBjKDab+FJTwV5rkNwj3NDAzi3sm1GUmByN9L
	 ae8UM2JmSqv6UGpgKHcUSvYcn0NVQP/7nqumMLXaC9abZZ4czDAYJ903yC/eFtxYtN
	 AcWYARkGjdmTg==
Date: Fri, 9 Jan 2026 13:12:12 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <aWDv1sbT54cZlEhH@nidhogg.toxiclabs.cc>
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

							^ without.

But not a big deal, if Jens is ok with me pulling this patch I'll fix
this on commit time.


For the patch itself:
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

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
