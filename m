Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A025336EF8;
	Tue, 10 Mar 2026 22:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773180784; cv=none; b=pv3G5XnMhuaDZbW0tpx+bm0/+Vahu3GZZvDvLhp53hyuWxI7kGJSVE+gq+alm1aufroIvpCUIVueKOHUfdxBWbyJ9akEldra+Yt9lEuZ8rAngXYU6VTZCiEsrRW09jSSPdZLHURlshMOzQa06cL4K6P1UCfv/Y0/J2WHev5hJAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773180784; c=relaxed/simple;
	bh=stQyjju3gdyz0rZSzHwe2gXFfIWhU/js5qdouHjazkQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bR/v7ksdIMXN/aF0jIKtkzzXEkor0GWTq7Q1c2juAMsxpH9ZK0dx1YXMspxXH8imURRvmbGEoujTSOsZYBcXy0is0fh29G7Us7f3I74Z+1pge6jY03RftM+oCLivtllRBuRogFQtGbBNGGcyD4gxGv6eRysTdz7inR+av+Quzf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iEVZajLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iEVZajLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2CEC19423;
	Tue, 10 Mar 2026 22:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773180784;
	bh=stQyjju3gdyz0rZSzHwe2gXFfIWhU/js5qdouHjazkQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iEVZajLL1gawyOuibaWSq54SPV94syTsSxLgrm//nCXlyx4Gqbqi6lQ+Unk0TXH87
	 NcBSUBFGkaDCAHaOqGZSKevXB5SWnWBharIJuCjipgg23sWxQFyEr5gDFeEw4O5+Va
	 emD7bXEcwnsGuQ4St5RZKCYwn7W86/dvKJbcjNmfXnGkg39RM7B0+TGhSbPwFUSIQ5
	 8YYWR8FPZMwuARB308FAavpkCjalsWztpntdWGC69iNG2Ae17Z8P5z1DRVdOW/KQBi
	 CHcsxSaHLgVkwT/7H8DZ54oEKyCLP8WCaB+8u4TVD7TK+fBQFX80FYhuyDQloSOfik
	 dTzKHaYMLTT/A==
Date: Tue, 10 Mar 2026 15:13:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zhang Yi <yi.zhang@huaweicloud.com>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	brauner@kernel.org, hch@infradead.org, yi.zhang@huawei.com,
	yizhang089@gmail.com, yangerkun@huawei.com, yukuai@fnnas.com
Subject: Re: [PATCH] iomap: fix incorrect did_zero setting in
 iomap_zero_iter()
Message-ID: <20260310221303.GA1770774@frogsfrogsfrogs>
References: <20260310082250.3535486-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310082250.3535486-1-yi.zhang@huaweicloud.com>

On Tue, Mar 10, 2026 at 04:22:50PM +0800, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> The did_zero output parameter was unconditionally set after the loop,
> which is incorrect. It should only be set when the zeroing operation
> actually happens, not when IOMAP_F_STALE is set or when
> IOMAP_F_FOLIO_BATCH is set but !folio causes the loop to break early,
> or when iomap_iter_advance() returns an error.
> 
> This causes did_zero to be incorrectly set when zeroing a clean
> unwritten extent because the loop exits early without actually zeroing
> any data.
> 
> Fix it by using a local variable to track whether any folio was actually
> zeroed, and only set did_zero after the loop if zeroing happened.
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> ---
>  fs/iomap/buffered-io.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 5297491d5e3e..7a3780242cde 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1537,6 +1537,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  		const struct iomap_write_ops *write_ops)
>  {
>  	u64 bytes = iomap_length(iter);
> +	bool zeroed = false;
>  	int status;
>  
>  	do {
> @@ -1555,6 +1556,8 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  		/* a NULL folio means we're done with a folio batch */
>  		if (!folio) {
>  			status = iomap_iter_advance_full(iter);
> +			if (status)
> +				return status;
>  			break;
>  		}
>  
> @@ -1565,6 +1568,7 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  				bytes);
>  
>  		folio_zero_range(folio, offset, bytes);
> +		zeroed = true;
>  		folio_mark_accessed(folio);
>  
>  		ret = iomap_write_end(iter, bytes, bytes, folio);
> @@ -1574,10 +1578,10 @@ static int iomap_zero_iter(struct iomap_iter *iter, bool *did_zero,
>  
>  		status = iomap_iter_advance(iter, bytes);
>  		if (status)
> -			break;
> +			return status;

I think this seems like an unrelated change?  Do any of the callers
behave differently if iomap_zero_range() returns an error but also sets
did_zero to true?

>  	} while ((bytes = iomap_length(iter)) > 0);
>  
> -	if (did_zero)
> +	if (did_zero && zeroed)
>  		*did_zero = true;

Why not just do:

	if (did_zero)
		*did_zero = zeroed;

?

--D

>  	return status;
>  }
> -- 
> 2.52.0
> 
> 
