Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D756322B5A3;
	Fri,  9 Jan 2026 16:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767975547; cv=none; b=cienR8JB1gJwH4i+mS2Kr1V88VfG9CM80E44hHqEpoKfFqftRUIjbIm/6rBix1MgmczQAs1UUGCViBmR36ON7InXMgzXtdIvANDciZ3tK9CkfWD/hKNC9g2kGlXKdzEwGBvogPm1TT0nF6M0WY4PbivzHeD6w73k5b2PoP5e1aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767975547; c=relaxed/simple;
	bh=sABgJhb0V/ePvQAWDARmgFz6U21C244PrNIIzReWlcw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQl4FLMSgBciVkFsBliYYhey1+22o922584AScEz9iIrtCyhAhr6Qhl16kW7Y0bZmhYZFUSdzI9nY5Vg1x/iUykk2xgxjeeknB8LTA07ZusYussF1HfiAOfJ19rbnGvhRNiqUq/xkcDFINEG7ywRC0JUtqPHAd53gy8ybQphPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLo+2OKE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLo+2OKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F46BC4CEF7;
	Fri,  9 Jan 2026 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767975547;
	bh=sABgJhb0V/ePvQAWDARmgFz6U21C244PrNIIzReWlcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tLo+2OKEkgqk/kqhrsKz00Mjwp5RkUGfBCzWbjAbOQfnRafDCy155agfZ4qfJzVIE
	 N2VKaj5pyaDZvtiADxEqAolSssgWmUYn+IlBHLXzlVZ6POxDv+NW+kiPKR7r0SZUuG
	 PklkfprKp2jSU8qFue2O+AeMbrNscdYsqA1s17BXR1jOcGPSBU0mOfHGQfM/YBcsY2
	 6zUK2riG5Nrh0qHsVDITLugcPhiIDUbTjTIGm6XutsIaXg1b/pMxchV9hhXX070vg8
	 9v3xwxRk2nG4/yc7gBx2z4susFkfmvJiJU6/cZ9MVHWiE8UbyQb+SCaCZmtcd2wY2M
	 szis/g3QHzzTA==
Date: Fri, 9 Jan 2026 08:19:06 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <20260109161906.GN15551@frogsfrogsfrogs>
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
> @@ -311,6 +311,35 @@ void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
>  }
>  EXPORT_SYMBOL(bio_reset);

General question about bio_reset -- it calls bio_uninit, which strips
off the integrity and crypt metadata.  I /think/ that will all get
re-added if necessary during the subsequent bio submission, right?

For your zonegc case, I wonder if it's actually a good idea to keep that
metadata attached as long as the bdev doesn't change across reuse?

--D

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
