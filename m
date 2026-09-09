Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30885803AB;
	Wed,  9 Sep 2026 16:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788969903; cv=none; b=L9Jee8cOMaPUDffRJ8/0iWmp6yvjPFkFUWDQSC13XyhVp7IHtIxniM7+lHNcyXrJxmFXpNHBscZxSwPmdqClBBmowS1mGSt6iFmZLaTiTlgr//FZlRbpfhnvWwspdWgMNTk6eL7vRjr2nRhJJ6Z6Xwx17R06mpwmN4Y4VAEjBWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788969903; c=relaxed/simple;
	bh=v7Xt2B7MRBNPYS5d73/jlBh914BIr3LH+zzxX1vgLcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e7MunptgGum+6WYpTR6U5i+RL7XbosI0+jdYQ6XW5Ocg1C6v25fN07zX1TYkjMtlut3nLS53aAxoIAt85pV9yovqJ5upI9gHuMH05ofy7Yh9fi2qatQYnzabHNuNolovZpyWSgtlsT36TA9HWhJvKGwalo7+jIWLU4fv1iUSzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PVPwxT1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PVPwxT1c"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7BC7E1F00A3A;
	Wed,  9 Sep 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788969902;
	bh=b/yeayGXFTPVH5rnlvrZLlDbzbq4dQgNc6j4CSlO3kE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PVPwxT1cYloqsXx94a2jXiVd0Z8hkfQ6VapkhnozSpweAFjHKdQ0jlSafpzQY/PGf
	 /FaIvzies5is1VwYwSyO6ObBaOrPUCZs3r0fuX/f1ZCjSgBW9yAwq9BFS9m7uh1aar
	 C0cIg/BNUWTLlmAbqmXFkjEssRYmbF8IlJlkXnCfd6Gev71oPn7cJYvzdDElXX9z92
	 wx2mNTuAXkgQxJT1ecCAblj122ViHESEf90ZnLV6DENPTvNF2jdPd3VbPWtmXFVe8P
	 LPv/0B2vRtno/HsBE83l76b2V3sc/E4VhBVuQ3u0aW+54fQz6hvrVQJAnrynJ+9VtZ
	 VCKYK2CcBoRsA==
Date: Wed, 9 Sep 2026 09:05:01 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>, Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/16] block: add a bio_prepare_reissue helper
Message-ID: <20260909160501.GI2619314@frogsfrogsfrogs>
References: <20260909060924.1102037-1-hch@lst.de>
 <20260909060924.1102037-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909060924.1102037-4-hch@lst.de>

On Wed, Sep 09, 2026 at 09:08:52AM +0300, Christoph Hellwig wrote:
> Add a helper to a clear a bio for reissue without a lot of the
> pointless clearing and reinitializing done by bio_reset and bio_reuse,
> and keeping the page pinning flag intact.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/bio.c         | 20 ++++++++++++++++++++
>  include/linux/bio.h |  1 +
>  2 files changed, 21 insertions(+)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 5792a059ef2a..7f7654e60dd4 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -320,6 +320,26 @@ void bio_reuse(struct bio *bio, blk_opf_t opf)
>  }
>  EXPORT_SYMBOL_GPL(bio_reuse);
>  
> +/**
> + * bio_prepare_reissue - prepare a bio for reuissing the original I/O
> + * @bio:	bio to reuse
> + * @bdev:	block device to use the bio for
> + *
> + * Prepare @bio to be resubmitted to retry the original operation.
> + * The caller must reset bio->bi_iter to the original state.
> + */
> +void bio_prepare_reissue(struct bio *bio, struct block_device *bdev)
> +{
> +	bio->bi_bdev = bdev;
> +	bio_associate_blkg(bio);
> +	bio->bi_flags &=
> +		(BIO_PAGE_PINNED | BIO_CLONED | BIO_QUIET | BIO_REFFED);
> +	bio->bi_status = BLK_STS_OK;
> +	bio->bi_bvec_gap_bit = 0;
> +	atomic_set(&bio->__bi_remaining, 1);
> +}
> +EXPORT_SYMBOL_GPL(bio_prepare_reissue);
> +
>  static struct bio *__bio_chain_endio(struct bio *bio)
>  {
>  	struct bio *parent = bio->bi_private;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 584b6abf6baf..bfa3c0e97b6f 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -479,6 +479,7 @@ static inline void bio_init_inline(struct bio *bio, struct block_device *bdev,
>  extern void bio_uninit(struct bio *);
>  void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
>  void bio_reuse(struct bio *bio, blk_opf_t opf);
> +void bio_prepare_reissue(struct bio *bio, struct block_device *bdev);
>  void bio_chain(struct bio *, struct bio *);
>  void bio_await(struct bio *bio, void *priv,
>  	       void (*submit)(struct bio *bio, void *priv));
> -- 
> 2.53.0
> 
> 
