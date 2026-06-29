Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F9F2D592D;
	Mon, 29 Jun 2026 22:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782773913; cv=none; b=nTHdUQ6v7WioHApAhyjAEKItez3gn9wQVrm5K6AziO/IGvFjC6ldve+1Cnj0ITzvI/0WlWYAYx1l4UY78oELV8IOxiaEW6kwwZxAjzFHZTiYGsBQGX88OKkB+qIdhlIDhQbQy/zVlnNd8MjN8RYk2aJMKu7ePEjKsMU7+IJg5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782773913; c=relaxed/simple;
	bh=SniYSLMLa20Uz0dGTkj7KdJ6dsIATKkfUM19I91SxWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WcOII+vhqfOu8Bd2i5MJFXjBVhwPbtb4oUOZZheDoaDmbJO/q7jEgwnp9ajLCbJGRsiCfAVUjR7+dzsPb1LR7rnicbYVSal/E5gwvDwAFSHlCuHq19RRWMqhNAWVv4FMc5GgR6F7ay1MFti6rNm/b9PdUhskvCMayCcB7unfnQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YtFi8kzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YtFi8kzx"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 61F7A1F000E9;
	Mon, 29 Jun 2026 22:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782773912;
	bh=ENRQ9NA3W62ZfKQ+6o9iKW3jMWAArB1rfbeTL1oV25s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YtFi8kzx8gctsoVFQzs8pF7OHEtIWmjI5QvWiJB8mJJwrjWbqBzxrAKI7qDnlfTSn
	 o+kEjTeVsbyK/8U7PiAdZgc9RxfnQ2dqP1aMg1Sincaxo3BbpLkTCH1xHYRIJ2G+Kn
	 4ZR2S/FSmMzpQgyjPiCAMqL5FKNCjHG4JcMaI8M5enY6V5vc9NHbVbYNpUiK3+0wMN
	 1fPblagl8MhVfpyOKS7qT33d6PCSRADgk3n2WyxFod1/kN09PfModSWKdgEQVAcmfw
	 ONnWSNPBIEwb5nwpX0BQXjN2/HROouT6sXYEMtZbBjQcZZvjOAJjh7rYjzbpXJawIX
	 X+YoFDMBqd0Nw==
Date: Mon, 29 Jun 2026 15:58:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: brauner@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: add a separate bio_set for iomap_split_ioend
Message-ID: <20260629225831.GG6095@frogsfrogsfrogs>
References: <20260629125229.3400726-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629125229.3400726-1-hch@lst.de>

On Mon, Jun 29, 2026 at 02:52:29PM +0200, Christoph Hellwig wrote:
> iomap_split_ioend can split bios that already come from
> iomap_ioend_bioset and thus deadlock when the bioset is exhausted.
> 
> Add a separate bio_set to avoid this deadlock.

What happens if &iomap_ioend_split_bioset is exhausted?  Won't that also
stall the ioend submission?

<confused>

--D

> Fixes: 5fcbd555d483 ("iomap: split bios to zone append limits in the submission handlers")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/iomap/ioend.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index 01287f1ae021..2fbcb06f6938 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -13,6 +13,7 @@
>  
>  struct bio_set iomap_ioend_bioset;
>  EXPORT_SYMBOL_GPL(iomap_ioend_bioset);
> +struct bio_set iomap_ioend_split_bioset;
>  
>  struct iomap_ioend *iomap_init_ioend(struct inode *inode,
>  		struct bio *bio, loff_t file_offset, u16 ioend_flags)
> @@ -483,7 +484,8 @@ struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
>  	sector_offset = ALIGN_DOWN(sector_offset << SECTOR_SHIFT,
>  			i_blocksize(ioend->io_inode)) >> SECTOR_SHIFT;
>  
> -	split = bio_split(bio, sector_offset, GFP_NOFS, &iomap_ioend_bioset);
> +	split = bio_split(bio, sector_offset, GFP_NOFS,
> +			&iomap_ioend_split_bioset);
>  	if (IS_ERR(split))
>  		return ERR_CAST(split);
>  	split->bi_private = bio->bi_private;
> @@ -506,8 +508,23 @@ EXPORT_SYMBOL_GPL(iomap_split_ioend);
>  
>  static int __init iomap_ioend_init(void)
>  {
> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> +	const unsigned int nr_mempool_entries = 4 * (PAGE_SIZE / SECTOR_SIZE);
> +	int error;
> +
> +	error = bioset_init(&iomap_ioend_bioset, nr_mempool_entries,
>  			   offsetof(struct iomap_ioend, io_bio),
>  			   BIOSET_NEED_BVECS);
> +	if (error)
> +		return error;
> +	error = bioset_init(&iomap_ioend_split_bioset, nr_mempool_entries,
> +			   offsetof(struct iomap_ioend, io_bio),
> +			   BIOSET_NEED_BVECS);
> +	if (error)
> +		goto out_exit_ioend_bioset;
> +	return 0;
> +
> +out_exit_ioend_bioset:
> +	bioset_exit(&iomap_ioend_bioset);
> +	return error;
>  }
>  fs_initcall(iomap_ioend_init);
> -- 
> 2.53.0
> 
