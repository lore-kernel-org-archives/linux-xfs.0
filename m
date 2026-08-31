Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9D149E5E3;
	Mon, 31 Aug 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788198944; cv=none; b=Isry5KyNwJ7X1ZY89I1jHFA/PrlnyhSu/Ba2Z95zKTvrXTYJGF+vE3QKpRMSCS2hjAm7srRWhbJZoBq++5x5S6VQ1ux+Ie6hweu0KwnZDF2QXz1k108Tgu4Bt467+XptvqkdZauO5pghKfZZSdRSWRszvMbe65ZRsVpKIg1zqPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788198944; c=relaxed/simple;
	bh=GnWFjXmVfqhQlhYv1AN9iOpBFURaJ2bt+tSK+T/wCPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TSRFGSb8498wEMAdRoHndVBQRNgSSc2w8swtOXQ8ThZsZfoWA/6Ck2RgtVe1tHU6+VEL+Qdo67ZlAL4homxWnErWDpeDvjebSsezS9wHxBMzrAIfdW4qiWexbQhJMF0f1E02xtEPWcvGI6lHsp4G0HX+cTbSQRklPI2oyPSnalE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PpmxWt2v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PpmxWt2v"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A705A1F000E9;
	Mon, 31 Aug 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788198942;
	bh=tAcAHzx8hMylUGCoG7df5Q8mpV2Fe/nmr+/JU/yK+7M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PpmxWt2vjIk1/HAKIlwqtLmXitMsIarF65QL/qtxl989EfgA6NMfv9JJnYqrVJHcv
	 CudILSsI/Y1Waeenqvrhp6PajHqREx6ppeaPL/fVvkanklOs/LU6ZC+QMJfV74A+OI
	 RI/mxyBaAc2qKATKU7NLJUTfB1unp8Va9rO93X6VXazDfEevMKh5iH4dFTsGw30Mbj
	 TfnDS3wuNnyNJC1Q9cNPU2GvtlWJKfCcPCMbM8vTGSRRAp5bA1d/tSLySEYlPmwSv8
	 b7WCoq2bxTwEMszXlgmPpeRmgEydqhoFbiAizBAxxrPpe7PzS59DOSmqY6jrQkWNIL
	 elgGDfgIfnCDQ==
Date: Mon, 31 Aug 2026 10:55:42 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 05/17] iomap: respect maximum I/O size in
 iomap_dio_bio_iter_one
Message-ID: <20260831175542.GF1933798@frogsfrogsfrogs>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-6-hch@lst.de>

On Mon, Aug 31, 2026 at 09:39:53AM +0300, Christoph Hellwig wrote:
> Respect the maximum I/O size set for PI-enabled I/O in
> iomap_dio_bio_iter_one, otherwise bio_integrity_alloc_buf could
> under-allocate the integrity buffer when the initial kmalloc fails.
> 
> Currently this should not be triggered as file systems that limit the
> size for PI always use bounce buffering, but this will change soon.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This makes sense, as the !DIO_BOUNCE path will soon get used for the
"don't bounce, just try it and see if it fails" code path.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index bc726d47b7dc..91f5b67718a5 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -336,6 +336,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  		struct iomap_dio *dio, loff_t pos, unsigned int alignment,
>  		blk_opf_t op)
>  {
> +	unsigned int maxsize = iomap_max_bio_size(&iter->iomap);
>  	unsigned int nr_vecs;
>  	struct bio *bio;
>  	ssize_t ret;
> @@ -353,14 +354,12 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
>  	bio->bi_private = dio;
>  	bio->bi_end_io = iomap_dio_bio_end_io;
>  
> -
>  	if (dio->flags & IOMAP_DIO_BOUNCE)
> -		ret = bio_iov_iter_bounce(bio, dio->submit.iter,
> -				iomap_max_bio_size(&iter->iomap), alignment);
> +		ret = bio_iov_iter_bounce(bio, dio->submit.iter, maxsize,
> +				alignment);
>  	else
> -		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
> -				BIO_MAX_SIZE, bdev_dma_alignment(bio->bi_bdev),
> -				alignment - 1);
> +		ret = bio_iov_iter_get_pages(bio, dio->submit.iter, maxsize,
> +				bdev_dma_alignment(bio->bi_bdev), alignment - 1);
>  	if (unlikely(ret))
>  		goto out_put_bio;
>  	ret = bio->bi_iter.bi_size;
> -- 
> 2.53.0
> 
> 
