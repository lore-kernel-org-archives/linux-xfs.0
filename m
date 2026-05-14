Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71341EB5FD;
	Thu, 14 May 2026 18:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778781802; cv=none; b=tbBbqsf3IUAg8BtmwvCiHtRU5eojOf/IqT/4tuuam/1I4hFRAwnY8kW2b4zjfVVTrmvaKth0NUz5w4mCGP+aKqnGoGwEh29mGbY25MYmxPiGqYkE/e2czO9C1BXSXp6b8gJm7i27IOkABWUgP1FJ4Z6Z+lAJTkX1cVK4eD5yuT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778781802; c=relaxed/simple;
	bh=J1X3BoA2Cc85d/P3PJqksp0tNJT+bYcJaDD8XZgoBtY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YvbUv2EFUiVNjq18s2wrm3yH9NtmwBY+ytp91kFJoL29UcsLSl6nssEzCl9Lqkh3zMVD5XzlAnp4H02OWR84f/CbzpCaIQJZMWFrHXk8l8eK1A/xce3f9WDXcDFPWH9xvhgM+627XPe9a+WHDyXlJTyUnVqVaKsYvug2/O27Cg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ieWJjE8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ieWJjE8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7580BC2BCB3;
	Thu, 14 May 2026 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778781801;
	bh=J1X3BoA2Cc85d/P3PJqksp0tNJT+bYcJaDD8XZgoBtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ieWJjE8X4LxLaw0hCjq28cvz9qmLiRnHTZgQRUCiZOeybb91Ec9B1u0xdqEISI0sU
	 xbtoA0TSI5PazLQ1m+LvL9RGUeeBcf/qb3SHn9xEssM6jwn1WuS7u4QKPteh6slI1s
	 EBB+nLuVfAFY16jhmwOwmrPXlBcmUzBzNwnRVvjtkapb8YFmj4PwYds1ain7KxJNqv
	 baOBM5im1Ar7573VmjY1fYDyWcHPpOQgZbYjhQfJpVEqL+TnVDzM8FZ3NRinPLecco
	 zoi7ZhFIMrYAGU/Q+/uoXgEFkOtkK/5+NdWqceQ97fy/Rt7/iM6zTTgSnEBLsSN1Gu
	 /u7Oy2fd9OFfg==
Date: Thu, 14 May 2026 11:03:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, brauner@kernel.org, hch@infradead.org,
	yi.zhang@huawei.com, yizhang089@gmail.com, yangerkun@huawei.com,
	yukuai@fnnas.com
Subject: Re: [PATCH 1/4] iomap: correct the range of a partial dirty clear
Message-ID: <20260514180320.GA9555@frogsfrogsfrogs>
References: <20260514062955.1183976-1-yi.zhang@huaweicloud.com>
 <20260514062955.1183976-2-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514062955.1183976-2-yi.zhang@huaweicloud.com>

On Thu, May 14, 2026 at 02:29:52PM +0800, Zhang Yi wrote:
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
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>

Cc: <stable@vger.kernel.org> # v6.6
Fixes: 4ce02c67972211 ("iomap: Add per-block dirty state tracking to improve performance")

> ---
> This is modified from:
>  https://lore.kernel.org/linux-fsdevel/20240812121159.3775074-2-yi.zhang@huaweicloud.com/
> Changes:
>  - Use round_up() instead of DIV_ROUND_UP() to prevent wasted integer
>    division.
> 
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

Ok, so now we round off up to the next fsblock to compute first_blk...

> +	unsigned int last_blk = (off + len) >> inode->i_blkbits;

...and last_blk (which is really the next block number after the range
that we're undirtying) is now rounded down.  Presumably off/len have to
be aligned to fsblock granularity so we'll never have to deal with
unaligned situations like (off=324,len=1), right?

>  	unsigned long flags;
>  
> +	if (first_blk >= last_blk)

Do we need this check?  When would the test actually be true?

--D

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
