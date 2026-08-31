Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A24D353A72;
	Mon, 31 Aug 2026 18:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199482; cv=none; b=m1KzO0L5BBiwPBYIp6iIZWCFIlQQj34QbliouquzOAMBMNzoT0dRMURhQCLEHp+uTTM3UpzuRxYKMimchRdMd7Bh1vtPBq4EnwBJ6svHV6OIBg87jL99CImKejEvcebNYUW22Vuzdx4jtBxdgtRUGaH1cr90HSKX+a7vgEv72bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199482; c=relaxed/simple;
	bh=/NYvPj7eAOAn7UdYrC65ybioEF48RHttCPjrXGuNB6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ntR+s5kRQ8JGWhPctdI+40/cC8aZ+N3Hn7vkUJ53zEeaGzGkU4UnoWr/Hbu5fyFaedDvKCNpvVxITYaTMoh0/yPruvIczIqZVzCtDoa92lqsjYj1IB3Ra3ezZOhyWLKmKfwRHVHBVReyvMRkvQGLRjK+YXvjtrbwM97i6Oo4f2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fEO3izI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fEO3izI3"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D1F761F000E9;
	Mon, 31 Aug 2026 18:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788199480;
	bh=TcIj3qN74m0gr8cszLQKLQ5q2xc2S6ABykuk3oNs2OY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fEO3izI3Ht2uUuLegmfjFhMtWBdsCwgHKIcsgJ9+LxXXYKVo0JwQWLdI6rn3kwVV7
	 SWTG9EGkm7xJ8qNfClhakFQxSmSSeIHw2daZFv2m8zWEsXpssTgMxGvBZbvPMAgu0B
	 uELZelq0pvrP0UUIddNJgBqlMHPuevN/0vJ3mF+z0i7dJQA/jlk2z39g3gcLV8lf09
	 y1a5t5Dz6SIl0DjGDw4hWTcOTiAw/VLOi7yK5enwtxwdAA/KURbCFzN/e97fPURQz6
	 P+IiCoQkkioPJvtGG3AQ+DCFeITftK9wy4EAeIwho7cXaYADwfTP4XwgA1k1ftj84H
	 Yp1PNvAO9ny/g==
Date: Mon, 31 Aug 2026 11:04:40 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/17] block: pass a maxlen argument to
 bio_iov_iter_get_pages
Message-ID: <20260831180440.GJ1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-2-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:49AM +0300, Christoph Hellwig wrote:
> Writes that require additional per-I/O allocations such as when using
> file system level protection information can be limited to a maximum
> size.  Allow passing that to bio_iov_iter_get_pages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

I'm slightly wary of what weird bugs might fall out on account of
reducing the size of the bi_iter size, but AFAICT it's a reasonable
thing to do, so

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio.c          |  8 ++++++--
>  block/blk-map.c      |  2 +-
>  block/fops.c         |  3 ++-
>  fs/iomap/direct-io.c | 10 +++++-----
>  include/linux/bio.h  |  3 ++-
>  5 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 898b2f5ef8c8..efd9483b8348 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1261,6 +1261,7 @@ static inline bool bio_iov_bvec_aligned(const struct bio *bio,
>   * bio_iov_iter_get_pages - add user or kernel pages to a bio
>   * @bio: bio to add pages to
>   * @iter: iov iterator describing the region to be added
> + * @maxlen: maximum size to consume from @iter
>   * @mem_align_mask: the mask the source address and length must be aligned to,
>   *	0 for no requirement
>   * @len_align_mask: the mask to align the total size to, 0 for any length
> @@ -1281,7 +1282,8 @@ static inline bool bio_iov_bvec_aligned(const struct bio *bio,
>   * is returned only if 0 pages could be pinned.
>   */
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
> -			   unsigned mem_align_mask, unsigned len_align_mask)
> +			   unsigned maxlen, unsigned mem_align_mask,
> +			   unsigned len_align_mask)
>  {
>  	iov_iter_extraction_t flags = 0;
>  
> @@ -1293,6 +1295,8 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>  		    !bio_iov_bvec_aligned(bio, mem_align_mask))
>  			return -EINVAL;
>  
> +		/* Truncate to the maximum size that the caller can handle */
> +		bio->bi_iter.bi_size = min(bio->bi_iter.bi_size, maxlen);
>  		iov_iter_advance(iter, bio->bi_iter.bi_size);
>  		return 0;
>  	}
> @@ -1306,7 +1310,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
>  		ssize_t ret;
>  
>  		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec,
> -				BIO_MAX_SIZE - bio->bi_iter.bi_size,
> +				maxlen - bio->bi_iter.bi_size,
>  				&bio->bi_vcnt, bio->bi_max_vecs,
>  				mem_align_mask, flags);
>  		if (ret <= 0) {
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 9cb9605d1f62..81cba3af4e9c 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -274,7 +274,7 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>  	 * No alignment requirements on our part to support arbitrary
>  	 * passthrough commands.
>  	 */
> -	ret = bio_iov_iter_get_pages(bio, iter, 0, 0);
> +	ret = bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE, 0, 0);
>  	if (ret)
>  		goto out_put;
>  	ret = blk_rq_append_bio(rq, bio);
> diff --git a/block/fops.c b/block/fops.c
> index 2ce7c6c4714e..a83df69b175a 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -46,7 +46,8 @@ static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
>  static inline int blkdev_iov_iter_get_pages(struct bio *bio,
>  		struct iov_iter *iter, struct block_device *bdev)
>  {
> -	return bio_iov_iter_get_pages(bio, iter, bdev_dma_alignment(bdev),
> +	return bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE,
> +			bdev_dma_alignment(bdev),
>  			bdev_logical_block_size(bdev) - 1);
>  }
>  
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce8..bc726d47b7dc 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -359,8 +359,8 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  				iomap_max_bio_size(&iter->iomap), alignment);
>  	else
>  		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
> -					     bdev_dma_alignment(bio->bi_bdev),
> -					     alignment - 1);
> +				BIO_MAX_SIZE, bdev_dma_alignment(bio->bi_bdev),
> +				alignment - 1);
>  	if (unlikely(ret))
>  		goto out_put_bio;
>  	ret = bio->bi_iter.bi_size;
> @@ -1034,9 +1034,9 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
>  	bio->bi_iter.bi_sector = iomap_sector(&iomi->iomap, iomi->pos);
>  	bio->bi_ioprio = iocb->ki_ioprio;
>  
> -	ret = bio_iov_iter_get_pages(bio, iter,
> -				bdev_dma_alignment(bio->bi_bdev),
> -				alignment - 1);
> +	ret = bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE,
> +			bdev_dma_alignment(bio->bi_bdev),
> +			alignment - 1);
>  	if (unlikely(ret))
>  		goto out_bio_put;
>  
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index bb3235497e67..0070be355181 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -516,7 +516,8 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
>  		size_t len, enum req_op op);
>  
>  int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
> -		unsigned mem_align_mask, unsigned len_align_mask);
> +		unsigned maxlen, unsigned mem_align_mask,
> +		unsigned len_align_mask);
>  
>  bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter);
>  void __bio_release_pages(struct bio *bio, bool mark_dirty);
> -- 
> 2.53.0
> 
> 
