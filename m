Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEAB3B1035;
	Thu, 24 Sep 2026 18:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790276007; cv=none; b=SciSVVs9E5cFzS6PtnIx31CpA6Fqz/OKRs8CGv6BtEPk9KydOzS0sVv1D+SBE4VC++m7kAtRYIm8foqp3GoB8eUy2jzGL808/xIZQWM/8NdsrYLH4f581hmH4fMDmY390B8cU3mltVWY89IoF4T/pO5D9vxXxHuZ+sx7B/AstWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790276007; c=relaxed/simple;
	bh=q1a1CCLklZ5exoDiSTeOlzjAl1z3n8g77yAkcYvPVhc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M6nMw16FR0VC9IYf0NQbPgTmc4/VpRN/y4falPeAO7j1Hlk5SCguy/lc+0cuRLndpbh6dUIC78TFT9ORBL+PbvTYH8s4u/0zZP9LZYCMZhHjQKwTmyI98MXvhnwzKHTt+V9zu6clS0XQKr4DsceThnxy11VWi9/9jxyXOv28NZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IepaydXH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IepaydXH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D872A1F00893;
	Thu, 24 Sep 2026 18:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790275997;
	bh=NpUeRyFM8UEm0wbNyQKdr/ttyjEkhvRk2jbwVcNLSw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IepaydXHXXnsqklYZp4z5NqaCuCLv3dRMuyiz05/fj8D1CdW1D5WUQZKDQx8lIyGC
	 ypJPgrYC7gDisLaFflPhGnyeg/WLFySuA3uckdcimixLSoagHflRIFel6KLcNYSknn
	 Wjb6zW6oV0m1xjgHkfpfKvDDRy5E5659mI7b8cFKZ3kQx80egC7mUQlJgRteI4+aVY
	 uOO80q3P3/f57I/T2ES/uI9YMopiFRfByEsUiD6SkG3lwcHCX/YewEz6aSPC0dwU4Y
	 1KQxkE44/fJZvO0MpArFTj7MGprpsYzg0RCXHetTyw0jcm1jvj1DyOFNHCo0d7+GAg
	 fmapLMgCeWGuQ==
Date: Thu, 24 Sep 2026 11:53:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrea Parri <parri.andrea@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Damien Le Moal <dlemoal@kernel.org>, Hannes Reinecke <hare@suse.de>,
	Daniel Gomez <da.gomez@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] iomap: don't lose a failed direct I/O bio's error
 when zeroing the tail
Message-ID: <20260924185317.GK2705364@frogsfrogsfrogs>
References: <20260924091203.198225-1-parri.andrea@gmail.com>
 <20260924091203.198225-5-parri.andrea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924091203.198225-5-parri.andrea@gmail.com>

On Thu, Sep 24, 2026 at 11:11:54AM +0200, Andrea Parri wrote:
> iomap_dio_bio_iter() falls through to the sub-block tail zeroing when
> the data bio submission fails, so that the rest of the block is still
> zeroed and stale data is not exposed.  The zeroing result was assigned
> to ret, which overwrote the submission error with the successful
> zeroing result (zero) and the failed write was reported as success.
> 
> iomap_dio_zero() can only return an error from a can't-happen
> WARN_ON_ONCE() (nr_vecs exceeding BIO_MAX_VECS, which the existing
> comment there says "shall never be reached" for any in-tree
> filesystem), so it isn't a real runtime failure worth reporting to
> userspace, let alone one worth losing the actual submission error for.
> Make iomap_dio_zero() return void and drop the error handling at both
> call sites instead of threading the result through a separate
> variable.
> 
> Fixes: 10553a91652d ("iomap: fix iomap_dio_zero() for fs bs > system page size")
> Cc: stable@vger.kernel.org

Cc: <stable@vger.kernel.org> # v6.12

> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
> ---
>  fs/iomap/direct-io.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 8b4039d16ce89..e00995c296c79 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -296,8 +296,9 @@ u32 iomap_finish_ioend_direct(struct iomap_ioend *ioend)
>  	return vec_count;
>  }
>  
> -static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
> -		loff_t pos, unsigned len)
> +static void iomap_dio_zero(const struct iomap_iter *iter,
> +			   struct iomap_dio *dio, loff_t pos,
> +			   unsigned int len)
>  {
>  	struct inode *inode = file_inode(dio->iocb->ki_filp);
>  	struct bio *bio;
> @@ -305,14 +306,14 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
>  	int nr_vecs = max(1, i_blocksize(inode) / folio_size(zero_folio));
>  
>  	if (!len)
> -		return 0;
> +		return;
>  
>  	/*
>  	 * This limit shall never be reached as most filesystems have a
>  	 * maximum blocksize of 64k.
>  	 */
>  	if (WARN_ON_ONCE(nr_vecs > BIO_MAX_VECS))
> -		return -EINVAL;
> +		return;
>  
>  	bio = iomap_dio_alloc_bio(iter, dio, nr_vecs,
>  				  REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
> @@ -328,8 +329,6 @@ static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
>  		len -= io_len;
>  	}
>  	iomap_dio_submit_bio(iter, dio, bio, pos);
> -
> -	return 0;
>  }
>  
>  static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
> @@ -541,10 +540,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  	if (need_zeroout) {
>  		/* zero out from the start of the block to the write offset */
>  		pad = pos & (fs_block_size - 1);
> -
> -		ret = iomap_dio_zero(iter, dio, pos - pad, pad);
> -		if (ret)
> -			goto out;
> +		iomap_dio_zero(iter, dio, pos - pad, pad);
>  	}
>  
>  	do {
> @@ -582,8 +578,7 @@ static int iomap_dio_bio_iter(struct iomap_iter *iter, struct iomap_dio *dio)
>  		/* zero out from the end of the write to the end of the block */
>  		pad = pos & (fs_block_size - 1);
>  		if (pad)
> -			ret = iomap_dio_zero(iter, dio, pos,
> -					     fs_block_size - pad);
> +			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);

I think this is the original cause of the bug, right?  We might have
already had a nonzero ret, and the assignment here blows that away.
Right?

If the answer to that is yes, then
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

(I should probably whine about how changing the function signature of
iomap_dio_zero should be a separate patch to make it more obvious what's
the actual fix...)

--D

>  	}
>  out:
>  	/* Undo iter limitation to current extent */
> -- 
> 2.53.0
> 
> 
