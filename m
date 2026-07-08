Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818783DFC67;
	Wed,  8 Jul 2026 21:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783546821; cv=none; b=hDbGupmXO6vemeSKb6v+FUwCwRoeegcGUpwOpAn3MQd72HM3xq2HMqT2ajffSspwyxuksOonSGayzp+XXG1NgfPMLuTXHvOH/P+Oi6Hed2mUVXh3z6nCcfKgG7YVx4nErqr1U3GuIESKevWqyBeu9MkRMaSVZjrLejdAcu2A8i0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783546821; c=relaxed/simple;
	bh=+456Cwu+AAzsB0zfFdf4X3D8wO78nl47N6/TrzCHLCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uhiM1KJq/m6olwMnbQX5ZOHQvS4CX3abgsyGO2qzroAX7Rz35aaJPZskd5wSsTLrzH4YoVccnE3Yi3qLw59ro11HsnGz6UElxOrmiEv4oibCcHLFNtevD8oe10geDAS0xHeGah3SItgfv5gqMmElLtg0C4lg6togw58euI66cOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=io2qeCao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="io2qeCao"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E44EE1F000E9;
	Wed,  8 Jul 2026 21:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783546820;
	bh=jOEFoW2s9tzbelFQ3G+XOL6CYtXjBKg3rkw8BVOaQfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=io2qeCaozNOMNJ9ochGhQmkybMg7td4/xPSh917yfBmG94wxVR+IPUieiPDQ3+tm5
	 zQ8PpnmbH1UV/bpryua4TDk7Ah/qDpv5l3B7KZmLPuNRDH82UDrdM8Gf1F2Wu/9hE9
	 RFkUGaLwZs+fUeislGKuZU1ZhjbrhvMhkraXEZ55njbybbHaeTTb44YRVZTTL9fvUE
	 LiKWuJX/HTKI3L1J1UAFsM3ls1kveAJRr5lmuMoEezGfnikmnUKfKzWc52jvwpzr12
	 xLHg+oxaOI0yFikMbE+8s6D0Z2yR/6fJIs/7+NmInZcv/jUZ5e4syTJKAJpnSoTU9i
	 9XgIP+xDzOXUg==
Date: Wed, 8 Jul 2026 14:40:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
	joannelkoong@gmail.com, yi.zhang@huawei.com, yizhang089@gmail.com,
	yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH v2 1/5] iomap: correct the range of a partial dirty clear
Message-ID: <20260708214019.GE9368@frogsfrogsfrogs>
References: <20260520030357.679687-1-yi.zhang@huaweicloud.com>
 <20260520030357.679687-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520030357.679687-2-yi.zhang@huaweicloud.com>

On Wed, May 20, 2026 at 11:03:53AM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The block range calculation in ifs_clear_range_dirty() is incorrect when
> partially clearing a range in a folio. We cannot clear the dirty bit of
> the first block or the last block if the start or end offset is not
> blocksize-aligned. This has not yet caused any issues since we always
> clear a whole folio in iomap_writeback_folio().
> 
> Fix this by rounding up the first block to blocksize alignment, and
> calculate the last block by rounding down (using truncation). Correct
> the nr_blks calculation accordingly.
> 
> Fixes: 4ce02c679722 ("iomap: Add per-block dirty state tracking to improve performance")
> Cc: <stable@vger.kernel.org> # v6.6
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

My apologies for the unnecessary delay, I was on vacation when this came
through and I never saw it. :/

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/iomap/buffered-io.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d7b648421a70..64351a448a8b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -176,13 +176,17 @@ static void ifs_clear_range_dirty(struct folio *folio,
>  {
>  	struct inode *inode = folio->mapping->host;
>  	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> -	unsigned int first_blk = (off >> inode->i_blkbits);
> -	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
> -	unsigned int nr_blks = last_blk - first_blk + 1;
> +	unsigned int first_blk = round_up(off, i_blocksize(inode)) >>
> +				 inode->i_blkbits;
> +	unsigned int last_blk = (off + len) >> inode->i_blkbits;
>  	unsigned long flags;
>  
> +	if (first_blk >= last_blk)
> +		return;
> +
>  	spin_lock_irqsave(&ifs->state_lock, flags);
> -	bitmap_clear(ifs->state, first_blk + blks_per_folio, nr_blks);
> +	bitmap_clear(ifs->state, first_blk + blks_per_folio,
> +		     last_blk - first_blk);
>  	spin_unlock_irqrestore(&ifs->state_lock, flags);
>  }
>  
> -- 
> 2.52.0
> 
> 
