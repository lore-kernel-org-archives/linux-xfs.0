Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406FB192597
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730217410; cv=none; b=FQe6OLn19lTwcuMPrpmCfDP5mO58Vr1SwYlcaTH8ewd7Jm8FeJdgC5xnTNgq/TojMV35tY5mqjHHgutgqPfZIw0SPYf+UDuKmSe5cdbgOpYXl1ImcI7sOfmghajGDIgUqhj9cymL79aT1Y82Buk6cAHYalyQSCxDkjckHth6DP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730217410; c=relaxed/simple;
	bh=JcM6N/4/GosfjDeirgI6OoMJzmnY84zPAjE2GXGHZVM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HppPqWFDp8wbRgfUIrtAlLQoftZSEXVwVRe/rjIT9q2d0FQEwKshH3qEfmTuFtp2aS8lzccyWh4aL2HdVI+AWSed/FtAVke6iHyPR8dMer5xJu9F9cWa8qvJlTwVtu6Vzn64UCdMY38O8FAyDcH/bUOC+UqPB0q4b7it0z2fyXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dTetP66e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dTetP66e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D29C4CECD;
	Tue, 29 Oct 2024 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730217409;
	bh=JcM6N/4/GosfjDeirgI6OoMJzmnY84zPAjE2GXGHZVM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dTetP66eHEcfc51Sbf6a3FQ09BgU66ziRsyO3XfzrfwYZaEhpPwzTtH/P60cHLGcr
	 sQMHxfyltkLftyenPz3iOHn3xQlht3OR0s9GHiaGy0wi0ShXH4OqGcRiXXJCpMnXCP
	 +emXHIj9N1ZuvkeQWreSqK/efqOzga1qxrqaWobmgtk4wlXza1c/QIeMziWWcNwCj6
	 GhHcgQ5tH+sqquhWPBEzxPMTIAdA+mHjv+WmImfRWNjIxe815EbOWcWjsD2CWlLSeP
	 984rmcMjvu2gobKimcquWq4Zrxe1zDdweGdg7DXy4BlA5R6qIhnTdLj3/RS6juj3uv
	 Z2ptDgmzKcmrQ==
Date: Tue, 29 Oct 2024 08:56:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: remove xfs_page_mkwrite_iomap_ops
Message-ID: <20241029155649.GV2386201@frogsfrogsfrogs>
References: <20241029151214.255015-1-hch@lst.de>
 <20241029151214.255015-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029151214.255015-5-hch@lst.de>

On Tue, Oct 29, 2024 at 04:12:00PM +0100, Christoph Hellwig wrote:
> Shared the regular buffered write iomap_ops with the page fault path
> and just check for the IOMAP_FAULT flag to skip delalloc punching.
> 
> This keeps the delalloc punching checks in one place, and will make it
> easier to convert iomap to an iter model where the begin and end
> handlers are merged into a single callback.

"merged into a single callback"?  What plans are these? :)

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Code changes here look ok to me, so
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c  |  2 +-
>  fs/xfs/xfs_iomap.c | 17 ++++++++---------
>  fs/xfs/xfs_iomap.h |  1 -
>  3 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 7464d874e766..c6de6b865ef1 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -1474,7 +1474,7 @@ xfs_write_fault(
>  	if (IS_DAX(inode))
>  		ret = xfs_dax_fault_locked(vmf, order, true);
>  	else
> -		ret = iomap_page_mkwrite(vmf, &xfs_page_mkwrite_iomap_ops);
> +		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops);
>  	xfs_iunlock(ip, lock_mode);
>  
>  	sb_end_pagefault(inode->i_sb);
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 916531d9f83c..bfc5b0a4d633 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1234,6 +1234,14 @@ xfs_buffered_write_iomap_end(
>  	if (iomap->type != IOMAP_DELALLOC || !(iomap->flags & IOMAP_F_NEW))
>  		return 0;
>  
> +	/*
> +	 * iomap_page_mkwrite() will never fail in a way that requires delalloc
> +	 * extents that it allocated to be revoked.  Hence never try to release
> +	 * them here.
> +	 */
> +	if (flags & IOMAP_FAULT)
> +		return 0;
> +
>  	/* Nothing to do if we've written the entire delalloc extent */
>  	start_byte = iomap_last_written_block(inode, offset, written);
>  	end_byte = round_up(offset + length, i_blocksize(inode));
> @@ -1260,15 +1268,6 @@ const struct iomap_ops xfs_buffered_write_iomap_ops = {
>  	.iomap_end		= xfs_buffered_write_iomap_end,
>  };
>  
> -/*
> - * iomap_page_mkwrite() will never fail in a way that requires delalloc extents
> - * that it allocated to be revoked. Hence we do not need an .iomap_end method
> - * for this operation.
> - */
> -const struct iomap_ops xfs_page_mkwrite_iomap_ops = {
> -	.iomap_begin		= xfs_buffered_write_iomap_begin,
> -};
> -
>  static int
>  xfs_read_iomap_begin(
>  	struct inode		*inode,
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 4da13440bae9..8347268af727 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -48,7 +48,6 @@ xfs_aligned_fsb_count(
>  }
>  
>  extern const struct iomap_ops xfs_buffered_write_iomap_ops;
> -extern const struct iomap_ops xfs_page_mkwrite_iomap_ops;
>  extern const struct iomap_ops xfs_direct_write_iomap_ops;
>  extern const struct iomap_ops xfs_read_iomap_ops;
>  extern const struct iomap_ops xfs_seek_iomap_ops;
> -- 
> 2.45.2
> 
> 
