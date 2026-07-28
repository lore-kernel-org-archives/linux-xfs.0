Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAAF23909F
	for <linux-xfs@vger.kernel.org>; Tue, 28 Jul 2026 15:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785252450; cv=none; b=g4z5FBKont9Kb0wW50HBqR3w0c6KOXCtm4cFMoDqe+3Zt4i8i0AJWekUX/bt0cKRr5Cz3Uy8pluhJPG84eyE6a782s/uROtP5iYO/NN9hJfkafarQ6yHX40XHXui29A8LCw5ffEHhq2hDFdMpavxckLPrpjih7RBe63jdGUlnq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785252450; c=relaxed/simple;
	bh=2vApaw5gWUamDx9iImF2/XstV8O+HvRHkXYMWtJOHeI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gy9tP6If4kwlFKDl+2cESLZXndB6CY6aq6TBDBbN6X4nTHjXrm9TwNiV+OPOM2Ly2vpwhdwfoN9C35yKXtlO4OROTDcQnrgW9+t3ycvNYP2Saaics650UY4uJxjbJjY1tAMPwq29t1UT6wWEf5HVO/wtFRzBN1QTdBToZEXrQTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gmX/U7jp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gmX/U7jp"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 45E1D1F000E9;
	Tue, 28 Jul 2026 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785252449;
	bh=5oLjMHXR+zk6yqyski2wQMzy8ikVIJYJgFTUWCymW+c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gmX/U7jpKeKwBtRWodYK1x3IKi0HDKE528um/zOhftEvCusLYx0TKLorVoN+EdrcV
	 kD1bP0COtu2rMvzq+Hat6YVsbt6J0xo4AEdD9ewXQx0J4ifqdE1qD6Rcd6Sw+H18pW
	 zslAUeR3Tjmy3zQjetubxk0oELaA16evgcZ8cbUmVNDAm5poopQKfayv3jtrJaQe9l
	 wFxaxBRY1DJrrhbXrTVeVhxZN/2WV9EXV7U7KdcbEdkH3rnv24C7GEpzxkgct4E6Dm
	 IjuSFYyvhzVjfEwIefnNFPGfJRSvOD6gV8tD+8aBXgE6OAAZ2sLfhvrW43DSaszYPD
	 9MpsyEYVWlMxQ==
Date: Tue, 28 Jul 2026 08:27:29 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>,
	"Cc : Hans Holmberg" <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add a separate bio_set for spliting GC writes
Message-ID: <20260728152729.GO2901224@frogsfrogsfrogs>
References: <20260728080650.1777545-1-hch@lst.de>
 <20260728080650.1777545-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728080650.1777545-2-hch@lst.de>

On Tue, Jul 28, 2026 at 10:06:44AM +0200, Christoph Hellwig wrote:
> Allocating the new bio for a split from the same pool as the original
> one can deadlock under memory pressure.  Add a separate pool for
> splitting GC write bios to avoid this.
> 
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index f76a09130852..e4f70e024632 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -130,6 +130,9 @@ struct xfs_zone_gc_data {
>  	/* bioset used to allocate the gc_bios */
>  	struct bio_set			bio_set;
>  
> +	/* bioset used when writes need to be split to hardware limits */
> +	struct bio_set			split_bio_set;
> +
>  	/*
>  	 * Scratchpad to buffer GC data, organized as a ring buffer over
>  	 * discontiguous folios.  scratch_head is where the buffer is filled,
> @@ -221,6 +224,9 @@ xfs_zone_gc_data_alloc(
>  	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
>  			BIOSET_NEED_BVECS))
>  		goto out_free_recs;
> +	if (bioset_init(&data->split_bio_set, 16,
> +			offsetof(struct xfs_gc_bio, bio), 0))
> +		goto out_exit_bio_set;
>  	for (i = 0; i < XFS_GC_NR_BUFS; i++) {
>  		data->scratch_folios[i] =
>  			folio_alloc(GFP_KERNEL, get_order(XFS_GC_BUF_SIZE));
> @@ -238,6 +244,8 @@ xfs_zone_gc_data_alloc(
>  out_free_scratch:
>  	while (--i >= 0)
>  		folio_put(data->scratch_folios[i]);
> +	bioset_exit(&data->split_bio_set);
> +out_exit_bio_set:
>  	bioset_exit(&data->bio_set);
>  out_free_recs:
>  	kfree(data->iter.recs);
> @@ -254,6 +262,7 @@ xfs_zone_gc_data_free(
>  
>  	for (i = 0; i < XFS_GC_NR_BUFS; i++)
>  		folio_put(data->scratch_folios[i]);
> +	bioset_exit(&data->split_bio_set);
>  	bioset_exit(&data->bio_set);
>  	kfree(data->iter.recs);
>  	kfree(data);
> @@ -810,7 +819,8 @@ xfs_zone_gc_split_write(
>  			data->mp->m_sb.sb_blocksize) >> SECTOR_SHIFT;
>  	split_len = split_sectors << SECTOR_SHIFT;
>  
> -	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS, &data->bio_set);
> +	split = bio_split(&chunk->bio, split_sectors, GFP_NOFS,
> +			&data->split_bio_set);
>  	split_chunk = container_of(split, struct xfs_gc_bio, bio);
>  	split_chunk->data = data;
>  	ihold(VFS_I(chunk->ip));
> -- 
> 2.53.0
> 
> 
