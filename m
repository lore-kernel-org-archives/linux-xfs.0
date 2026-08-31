Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8565B2C026C;
	Mon, 31 Aug 2026 17:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199118; cv=none; b=LYIbpxqjohCyt0kB2+EGn+7WJycLXCBoVxRAIsJhKZMtDsUlsviFbV9s7qvRWJliM/NJhwgLCUb1w6BGJnHVS0AoVP+tjjzKGPceg1PtUsvoDUuyZjsaC6ecCg+BIoC40yHM7eNg09/E6Y+mPgPigGdCx0cIuQy9s7ZT9mkczE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199118; c=relaxed/simple;
	bh=7hlcXfEhhOEchDnMJGW7aFwVI8RBhWAJpJ10JSj2xnk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lkLQr1KoD2kCWExYwQJZYLN0Ek0iXisL0DDXT5CX1VD/BcQ0KUXgXQnRD9CYjQ89L1yfgHV6aV1XfOrx/w0KUi6WP8G4j5o+rwb7+puN1RWbPmgsMImLzHUdDNa//ilkE67PD4cWH4L4YzJJimyk8kUdodhglQFxH/5x9HuzSjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LxZlOXP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxZlOXP3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CBEF91F000E9;
	Mon, 31 Aug 2026 17:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788199116;
	bh=cgOW/XAgWzpbch2/xR0SNsNGS6YvhUERcwE/ga9MS8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LxZlOXP3l2I7Y6P7owGfNxt06f1epr/NcirlKP0iqJl0JdhJASH9VYd1zW5YbKiIj
	 bqF7lObPAcfC4cmOv3BYtdZurQltJEx3IAZ0NU7n0v8Lu7KEcNMXxJwN1vcc172lzC
	 z/OpJdVPrRnAl1otPp7jSdmDbd5OrImPviHAWVMFi54fXxzzPDn3ekqNQfSOieW4bz
	 Au5nRPZFG4c/kUwn+djgOF2OAYvO9T3q73DQveiToD1tyFqWT5w65aeHbWAeQXjZ4P
	 MLTKCTBqDCOFUeZitlaCn/hULZIwGJ1D/W4guBvO98ktWSUSonCZvKHd7HXgFY/5gU
	 j1tURceGMDIKw==
Date: Mon, 31 Aug 2026 10:58:36 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/17] block: split bio_iov_iter_bounce_write
Message-ID: <20260831175836.GH1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-4-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:51AM +0300, Christoph Hellwig wrote:
> Factor out a bio_alloc_bounce_folios helper that we'll use for a
> different take on read-side bounce buffering soon.
> 
> For that make it and also bio_free_folios available to callers outside of
> bio.c.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks like a simple split of one function into two, right?

If so, then I'm ok with this;
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio.c         | 58 ++++++++++++++++++++++++++-------------------
>  include/linux/bio.h |  2 ++
>  2 files changed, 35 insertions(+), 25 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index efd9483b8348..a87c33fe96ac 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1353,7 +1353,7 @@ static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
>  	return folio_alloc(gfp, get_order(*size));
>  }
>  
> -static void bio_free_folios(struct bio *bio)
> +void bio_free_folios(struct bio *bio)
>  {
>  	struct bio_vec *bv;
>  	int i;
> @@ -1366,11 +1366,8 @@ static void bio_free_folios(struct bio *bio)
>  	}
>  }
>  
> -static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
> -		size_t maxlen, size_t minsize)
> +int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize)
>  {
> -	size_t total_len = min(maxlen, iov_iter_count(iter));
> -
>  	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
>  		return -EINVAL;
>  	if (WARN_ON_ONCE(bio->bi_iter.bi_size))
> @@ -1380,7 +1377,6 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
>  
>  	do {
>  		size_t this_len = min(total_len, SZ_1M);
> -		size_t copied;
>  		struct folio *folio;
>  
>  		if (this_len > minsize * 2)
> @@ -1393,32 +1389,44 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
>  		if (!folio)
>  			break;
>  		bio_add_folio_nofail(bio, folio, this_len, 0);
> +		total_len -= this_len;
> +	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
> +
> +	if (!bio->bi_iter.bi_size)
> +		return -ENOMEM;
> +	return 0;
> +}
> +
> +static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
> +		size_t maxlen, size_t minsize)
> +{
> +	size_t total_len = min(maxlen, iov_iter_count(iter));
> +	size_t total_copied = 0;
> +	struct bio_vec *bv;
> +	int i, error;
> +
> +	error = bio_alloc_bounce_folios(bio, total_len, minsize);
> +	if (error)
> +		return error;
> +
> +	bio_for_each_bvec_all(bv, bio, i) {
> +		struct folio *folio = page_folio(bv->bv_page);
> +		size_t copied;
>  
>  		if (iter->nofault)
> -			copied = copy_folio_from_iter_atomic(folio, 0, this_len,
> -							     iter);
> +			copied = copy_folio_from_iter_atomic(folio, 0,
> +					bv->bv_len, iter);
>  		else
> -			copied = copy_folio_from_iter(folio, 0, this_len, iter);
> -		if (copied < this_len) {
> -			/*
> -			 * Need to revert the iov iter for all bytes we have
> -			 * copied.
> -			 *
> -			 * However the bio size differs from the real copied
> -			 * bytes as @this_len is queued but only advanced
> -			 * less than that.
> -			 * Need to compensate that for the revert.
> -			 */
> -			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len +
> -					copied);
> +			copied = copy_folio_from_iter(folio, 0, bv->bv_len,
> +					iter);
> +		total_copied += copied;
> +		if (copied < bv->bv_len) {
> +			iov_iter_revert(iter, total_copied);
>  			bio_free_folios(bio);
>  			return -EFAULT;
>  		}
> -		total_len -= this_len;
> -	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
> +	}
>  
> -	if (!bio->bi_iter.bi_size)
> -		return -ENOMEM;
>  	return bio_iov_iter_align_down(bio, iter,
>  			&bio->bi_io_vec[bio->bi_vcnt - 1], minsize - 1);
>  }
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 0070be355181..584b6abf6baf 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -527,6 +527,8 @@ extern void bio_check_pages_dirty(struct bio *bio);
>  int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
>  		size_t minsize);
>  void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty);
> +int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize);
> +void bio_free_folios(struct bio *bio);
>  
>  extern void bio_copy_data(struct bio *dst, struct bio *src);
>  extern void bio_free_pages(struct bio *bio);
> -- 
> 2.53.0
> 
> 
