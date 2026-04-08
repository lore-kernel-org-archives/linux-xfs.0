Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8755A171BB;
	Wed,  8 Apr 2026 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775684301; cv=none; b=cgejO2JWUae8CwLxHjcQw5hvrVtKMRL1PkiV123PrXyLHZ9sWkL67eDLHHE1a8dSCzYIQonMcnTmU0J6m7d7NbvjN+5GBV3cL80S4XoVeceuYuEQppqyp0S8a4h1SKIqCJbcYqP5OsB/npzuK9JYouLeaeEMBo/65nPU1nQi07U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775684301; c=relaxed/simple;
	bh=DiuqR7BBGqj1sTH1BFY/UQpp4ZrV3YKL3ZlPuZk9Nyk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdKV7SF/yDvUHQOCVcfiEY/Ylz4FQdkvmdV4e2MMt8OwTqUUnmiZZl3Og+T66cudO0P/NUoxoB4tS06puqXZn3Dc4UyI75Pmit8tOjGm4mxAmr4OfATTVk21wR21D3gre5IsZioy2DQTZics2HKA+Fz26nWh0FBNoDvhgsVn6vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tiVTZaVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tiVTZaVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D3FC19424;
	Wed,  8 Apr 2026 21:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775684301;
	bh=DiuqR7BBGqj1sTH1BFY/UQpp4ZrV3YKL3ZlPuZk9Nyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tiVTZaVwW56CI5GJTDpPzZ4S2GBONh55g2ojndB6Lwzf4aS4MaWpHo3tE1cupfPYa
	 j82pfbhNvXASVBYOJgPpZXl5ZVhZNM4rrzNEZhbhqDeKfc5ft9e3DCFXxQ39mdAzbX
	 pbXynYYeQ/eW1kKvP759T0CRPUipABp/MJeo7uQPrxh6DQFmt7zc1sbtP7KSUE2JWa
	 hqS5uuYP0m3VwThoVA46ZUMtZr6jzM7rVjPoHR+jV1Dvu8rj72Pyxu/YpNoxLz+t2e
	 trh8M/ykr21c6rr5dzDI5kI7K3xSfwPvQ1G6t8mXyOjbowAA9KTlGoPSJSyv8h3P4K
	 QEcA9vEvmJNbw==
Date: Thu, 9 Apr 2026 07:38:13 +1000
From: Dave Chinner <dgc@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] xfs: check directory data block header padding in
 scrub
Message-ID: <adbKxVodbqAdM9Ol@dread>
References: <20260408172749.99216-2-ytohnuki@amazon.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408172749.99216-2-ytohnuki@amazon.com>

On Wed, Apr 08, 2026 at 06:27:50PM +0100, Yuto Ohnuki wrote:
> The pad field in xfs_dir3_data_hdr exists for 64-bit alignment and
> should always be zero.
> 
> First, fix xfs_dir3_data_init to zero the full xfs_dir3_data_hdr instead
> of just xfs_dir3_blk_hdr so that the pad field is covered by the memset.
> 
> Then, add the missing scrub check for the pad field in directory data
> block headers. Since old kernels may have written non-zero padding
> without issue, flag this as an optimization opportunity (preen) rather
> than corruption. Add xchk_fblock_set_preen helper for this purpose.
> 
> Signed-off-by: Yuto Ohnuki <ytohnuki@amazon.com>
> ---
> Changes in v2:
> - Fix xfs_dir3_data_init to zero the full xfs_dir3_data_hdr instead of
>   just xfs_dir3_blk_hdr so that the pad field is covered by the memset.
> - Use xchk_fblock_set_preen instead of xchk_fblock_set_corrupt since
>   old kernels may have written non-zero padding without issues.
> - Add xchk_fblock_set_preen helper function.
> - Link to v1: https://lore.kernel.org/all/20260404125032.37693-2-ytohnuki@amazon.com/#t
> ---
>  fs/xfs/libxfs/xfs_dir2_data.c | 10 +++++-----
>  fs/xfs/scrub/common.c         | 11 +++++++++++
>  fs/xfs/scrub/common.h         |  2 ++
>  fs/xfs/scrub/dir.c            |  7 ++++++-
>  4 files changed, 24 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
> index 80ba94f51e5c..037f9449835d 100644
> --- a/fs/xfs/libxfs/xfs_dir2_data.c
> +++ b/fs/xfs/libxfs/xfs_dir2_data.c
> @@ -745,13 +745,13 @@ xfs_dir3_data_init(
>  	 */
>  	hdr = bp->b_addr;
>  	if (xfs_has_crc(mp)) {
> -		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
> +		struct xfs_dir3_data_hdr *hdr3 = bp->b_addr;
>  
>  		memset(hdr3, 0, sizeof(*hdr3));
> -		hdr3->magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
> -		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp));
> -		hdr3->owner = cpu_to_be64(args->owner);
> -		uuid_copy(&hdr3->uuid, &mp->m_sb.sb_meta_uuid);
> +		hdr3->hdr.magic = cpu_to_be32(XFS_DIR3_DATA_MAGIC);
> +		hdr3->hdr.blkno = cpu_to_be64(xfs_buf_daddr(bp));
> +		hdr3->hdr.owner = cpu_to_be64(args->owner);
> +		uuid_copy(&hdr3->hdr.uuid, &mp->m_sb.sb_meta_uuid);
>  
>  	} else
>  		hdr->magic = cpu_to_be32(XFS_DIR2_DATA_MAGIC);

This seems .... a bit of a hack.

For simplicity, performance and long term maintenance of the code,
we should zero the whole directory block header region
unconditionally. This means we don't have to change the dir3 blk header
initialisation code (except to remove the zeroing), we can remove
the manual bestfree zeroing loop, all the padding (implicit and
explicit) will be zeroed, and we know that any future
changes to the dir header structure will automatically be
initialised to zero....

i.e.
	/* initialise the whole directory header region to zero */
	memset(bp->b_addr, 0, geo->data_entry_offset);

> diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
> index e09724cd3725..0a1ec94961ed 100644
> --- a/fs/xfs/scrub/dir.c
> +++ b/fs/xfs/scrub/dir.c
> @@ -492,7 +492,12 @@ xchk_directory_data_bestfree(
>  		goto out;
>  	xchk_buffer_recheck(sc, bp);
>  
> -	/* XXX: Check xfs_dir3_data_hdr.pad is zero once we start setting it. */
> +	if (xfs_has_crc(sc->mp)) {
> +		struct xfs_dir3_data_hdr    *hdr3 = bp->b_addr;
> +
> +		if (hdr3->pad != cpu_to_be32(0))

You don't need endian conversion on a value of 0.

> +			xchk_fblock_set_preen(sc, XFS_DATA_FORK, lblk);
> +	}

Why only update scrub? Why not add code that unconditionally
sets the padding to 0 on directory data block writes? e.g. in
xfs_dir3_data_write_verify() alongside the writing of the LSN into
the header?

That way any directory that is modified ends up having the padding
zeroed at runtime with no additional cost, and so filesystems will
slowly correct themselves over time without needing to run repair...

-Dave.
-- 
Dave Chinner
dgc@kernel.org
