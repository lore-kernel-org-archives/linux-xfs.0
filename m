Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1FC367F3A;
	Thu, 23 Jul 2026 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784825035; cv=none; b=IRQDvzASgze4ooGHF8Acz9pfBKapvLtj4bY9MVozCtQ01V3E0FHypboEee3xYZN/F2eLxTDxmIsqtU04yDgrAmgZU6urb093BQqOzv6iC4S+7JEo5e4ezZFxy/rVmLLQHgTlWVuslAWK4FZsYGO8M1QMRDEO4/iPXZtYSAXhX5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784825035; c=relaxed/simple;
	bh=k8B6QsJqeYAfPdzOpm10pDY9/oqjQ8kPNP4q+3cwo1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOklDtA6pEmg7Ev2r8NU8VTKyA/IACuE08SqPVgHRgQZvEk+Rgh+jwVAgGyS1tJb4Yyw8z1XjcoyxRmasMfX3R6cSPh8TvpF0SbySLz5PwqugyttfWTrC7LsNt9kXBpcRuoUz01ltLVG4ZEv4w6eNR+6P70E0XfrHKP5OJ9o80Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnJpf6wK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnJpf6wK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CC32D1F000E9;
	Thu, 23 Jul 2026 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784825032;
	bh=QeKXQ1l0vvph/K8xpDfR2y9JbkmWxrbM1ABJm8+XrjU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nnJpf6wKYuj+HvFM+NLHJJfNq6hHpUB4qoP8KfGjmLCsOHUBA7cAFZPZIh0g74hrt
	 QnyKhEY4THhO2wQ8MYAQZVyqizj5870Oq33+Mk+fbXF/ROU7E7hbvI9AA4e7tRwm6R
	 AV9IKqbT3VjeHO1jTUrRisbh0tkOfO+vjWTi4LuL97sEJIpvRQiWHwcbb7IE3FOnsS
	 bJoAxtIn3Onh1mea5HOh3AaPGrfyaKTPAwRQes8R+msdkeEUgboL1OdW+XdAO9oFWj
	 BwRgIikSqyvVLMEBb2VEW73WtDoy47nfhz0SqU/RwvNRepqTdQm9plYxvSR+TwS6K6
	 AzTmaquLQvFxw==
Date: Thu, 23 Jul 2026 09:43:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: changfengnan@bytedance.com, Joanne Koong <joannelkoong@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, Carlos Maiolino <cem@kernel.org>,
	linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] iomap: use GFP_NOWAIT when application for
 iomap_dio_simple allocations
Message-ID: <20260723164352.GE7380@frogsfrogsfrogs>
References: <20260723050201.3381045-1-hch@lst.de>
 <20260723050201.3381045-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723050201.3381045-4-hch@lst.de>

On Thu, Jul 23, 2026 at 07:01:41AM +0200, Christoph Hellwig wrote:
> For non-blocking iocbs we should avoid blocking allocation where
> possible, so switch to a GFP_NOWAIT allocation here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/direct-io.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
> index 36c976cf0848..5c28124b9f02 100644
> --- a/fs/iomap/direct-io.c
> +++ b/fs/iomap/direct-io.c
> @@ -986,6 +986,7 @@ static void iomap_dio_simple_end_io(struct bio *bio)
>  ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
>  		struct iomap_iter *iomi)
>  {
> +	gfp_t gfp = (iomi->flags & IOMAP_NOWAIT) ? GFP_NOWAIT : GFP_KERNEL;
>  	struct iomap_dio_simple *sr;
>  	unsigned int alignment;
>  	struct bio *bio;
> @@ -1015,7 +1016,11 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
>  
>  	bio = bio_alloc_bioset(iomi->iomap.bdev,
>  			       bio_iov_vecs_to_alloc(iter, BIO_MAX_VECS),
> -			       REQ_OP_READ, GFP_KERNEL, &iomap_dio_simple_pool);
> +			       REQ_OP_READ, gfp, &iomap_dio_simple_pool);
> +	if (!bio) {
> +		ret = -EAGAIN;
> +		goto out_dio_end;
> +	}
>  	sr = container_of(bio, struct iomap_dio_simple, bio);
>  	sr->iocb = iocb;
>  	sr->dio_flags = 0;
> -- 
> 2.53.0
> 
> 
