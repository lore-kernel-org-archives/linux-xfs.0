Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA412E6CC6
	for <linux-xfs@vger.kernel.org>; Fri, 17 Oct 2025 12:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760704627; cv=none; b=K6o/R3F6YehsjEMi/xphIkyWxTaIdEobvNKduGgjdKWygB0IkvJYg3I6Bl4KS3s0FUIV0lATfoRt597m5IQGaPyUVqQEiPAaQcZSSDFAvlNjOX2YJU8mxFGA3L9V19brSLSnj8UaLK+LwBghEYnRTtccguh5LL+v+asUbjaHY9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760704627; c=relaxed/simple;
	bh=fNNuRO9PViRaB234zq2RZJJ3ndacwtStazDdzmRe2qI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OQcO3mlp+TQG7rC0t0wgRFW5v7uU8RS/wdHQw3hy+IbmrDhjIozbtW5P5nlrQOTBjoSNjzG436HX12mjSREu1ZbJ/YjHBT3UAscQzTQUzLMYCwiqrsr5bgf73J4tG5PEVn5+I5Vbsu13ozCE8l3VSRA7tFNIleSEYqKX7cU2q2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rB27MQLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rB27MQLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139AAC4CEE7;
	Fri, 17 Oct 2025 12:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760704626;
	bh=fNNuRO9PViRaB234zq2RZJJ3ndacwtStazDdzmRe2qI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rB27MQLirFM506fpJBMOULwE0o27Y8llllQUJzKJIqWPbuFCuYaIpHL1bJDYGyRUT
	 kZZ3AsD/aEOHwlzmBC9KesGTZRK2NA2kPf+6oIL4mJt/+ZLSmsHFEMsYTp/RUP9ej/
	 5xh/pMvkiUy2xcWZFAsnHxow4gSwdAKuObvzIjbQ6EkkogcKKjK8XjfDUZ1/mtjp/h
	 A/OKagC3gQzqI12AlaBpHFQKXa3pYb066ZIE/u+3CSnjAJau++EzpQUBmiHusuLik0
	 9hKB0lrSzaudOz3wCXHwfDDLcbOgfwgpQ8udJygamd21wSunKLQYUryqDqnJIjPmrD
	 pfHX+NYzUVm2g==
Date: Fri, 17 Oct 2025 14:37:02 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Hans Holmberg <hans.holmberg@wdc.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: prevent gc from picking the same zone twice
Message-ID: <lxx3ievmo7icudhyniqxxfu7tf3svvuwzdyab24piyfirt23mz@uclls5yx7y6d>
References: <20251017060710.696868-1-hch@lst.de>
 <4iiJsTfGvQ1w-tO5wCGYxYCAVzsB3qLGXOMX9x_QjbtgyJXOwF13wT3aL3kXsNNFFgqhtt2fLOdCEyvxCYxPWQ==@protonmail.internalid>
 <20251017060710.696868-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017060710.696868-2-hch@lst.de>

On Fri, Oct 17, 2025 at 08:07:02AM +0200, Christoph Hellwig wrote:
> When we are picking a zone for gc it might already be in the pipeline
> which can lead to us moving the same data twice resulting in in write
> amplification and a very unfortunate case where keep on garbage
> collecting the zone we just filled with migrated data stopping all
> forward progress.
> 
> Fix this by introducing a count of on-going GC operations on a zone, so

					  This 'so' shouldn't be here? ^

> and skip any zone with ongoing GC when picking a new victim.
> 
> Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
> Co-developed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

This looks good, but I think it's worth to add a:

Fixes: 080d01c41 ("xfs: implement zoned garbage collection")


If you agree I can update both nitpicks above when I pull the series,
otherwise, feel free to add to the next version:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/libxfs/xfs_rtgroup.h |  6 ++++++
>  fs/xfs/xfs_zone_gc.c        | 27 +++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
> index d36a6ae0abe5..d4fcf591e63d 100644
> --- a/fs/xfs/libxfs/xfs_rtgroup.h
> +++ b/fs/xfs/libxfs/xfs_rtgroup.h
> @@ -50,6 +50,12 @@ struct xfs_rtgroup {
>  		uint8_t			*rtg_rsum_cache;
>  		struct xfs_open_zone	*rtg_open_zone;
>  	};
> +
> +	/*
> +	 * Count of outstanding GC operations for zoned XFS.  Any RTG with a
> +	 * non-zero rtg_gccount will not be picked as new GC victim.
> +	 */
> +	atomic_t		rtg_gccount;
>  };
> 
>  /*
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 109877d9a6bf..efcb52796d05 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -114,6 +114,8 @@ struct xfs_gc_bio {
>  	/* Open Zone being written to */
>  	struct xfs_open_zone		*oz;
> 
> +	struct xfs_rtgroup		*victim_rtg;
> +
>  	/* Bio used for reads and writes, including the bvec used by it */
>  	struct bio_vec			bv;
>  	struct bio			bio;	/* must be last */
> @@ -264,6 +266,7 @@ xfs_zone_gc_iter_init(
>  	iter->rec_count = 0;
>  	iter->rec_idx = 0;
>  	iter->victim_rtg = victim_rtg;
> +	atomic_inc(&victim_rtg->rtg_gccount);
>  }
> 
>  /*
> @@ -362,6 +365,7 @@ xfs_zone_gc_query(
> 
>  	return 0;
>  done:
> +	atomic_dec(&iter->victim_rtg->rtg_gccount);
>  	xfs_rtgroup_rele(iter->victim_rtg);
>  	iter->victim_rtg = NULL;
>  	return 0;
> @@ -451,6 +455,20 @@ xfs_zone_gc_pick_victim_from(
>  		if (!rtg)
>  			continue;
> 
> +		/*
> +		 * If the zone is already undergoing GC, don't pick it again.
> +		 *
> +		 * This prevents us from picking one of the zones for which we
> +		 * already submitted GC I/O, but for which the remapping hasn't
> +		 * concluded again.  This won't cause data corruption, but
> +		 * increases write amplification and slows down GC, so this is
> +		 * a bad thing.
> +		 */
> +		if (atomic_read(&rtg->rtg_gccount)) {
> +			xfs_rtgroup_rele(rtg);
> +			continue;
> +		}
> +
>  		/* skip zones that are just waiting for a reset */
>  		if (rtg_rmap(rtg)->i_used_blocks == 0 ||
>  		    rtg_rmap(rtg)->i_used_blocks >= victim_used) {
> @@ -688,6 +706,9 @@ xfs_zone_gc_start_chunk(
>  	chunk->scratch = &data->scratch[data->scratch_idx];
>  	chunk->data = data;
>  	chunk->oz = oz;
> +	chunk->victim_rtg = iter->victim_rtg;
> +	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
> +	atomic_inc(&chunk->victim_rtg->rtg_gccount);
> 
>  	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
>  	bio->bi_end_io = xfs_zone_gc_end_io;
> @@ -710,6 +731,8 @@ static void
>  xfs_zone_gc_free_chunk(
>  	struct xfs_gc_bio	*chunk)
>  {
> +	atomic_dec(&chunk->victim_rtg->rtg_gccount);
> +	xfs_rtgroup_rele(chunk->victim_rtg);
>  	list_del(&chunk->entry);
>  	xfs_open_zone_put(chunk->oz);
>  	xfs_irele(chunk->ip);
> @@ -770,6 +793,10 @@ xfs_zone_gc_split_write(
>  	split_chunk->oz = chunk->oz;
>  	atomic_inc(&chunk->oz->oz_ref);
> 
> +	split_chunk->victim_rtg = chunk->victim_rtg;
> +	atomic_inc(&chunk->victim_rtg->rtg_group.xg_active_ref);
> +	atomic_inc(&chunk->victim_rtg->rtg_gccount);
> +
>  	chunk->offset += split_len;
>  	chunk->len -= split_len;
>  	chunk->old_startblock += XFS_B_TO_FSB(data->mp, split_len);
> --
> 2.47.3
> 
