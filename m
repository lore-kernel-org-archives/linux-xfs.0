Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EE123D7F5
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 01:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564349; cv=none; b=FriQvTGnpWbYXLR8S+XPKKka4n+JgYP6qeaw2Ge+qp6en+vaEplXncBwE+QZ9pYIqNFTosodw6itQn8LcKck5bUnDNSuQ64eJZUFWGg9AIKk5vHRFjTv89UO/G3CIKSswRmkvL30wEp0vuSccIUtWg37Ihs2GyzmxoumHPe64LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564349; c=relaxed/simple;
	bh=uBlZ2SUbEbcZJfrENYORUDGpreYqUqB9v46AT0XIxHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HUEFmNjJX+qaL5iQPJbMRiljXAvjMi5GTvo/R2lE3NFI5PzdntVkIBFW1Ouyw3nVWmQTp1+3C/V6c8grZTfkKsc5HSuUKq5OuNKeYN9oSrIEgDP6oXKqEG28jy/BY60ggMqsXUj10CJ0YHD2MqIV3pqm+Vi6zYNhzIjCOCF5oMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qcMU9AYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qcMU9AYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D7DC116C6;
	Wed, 28 Jan 2026 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769564348;
	bh=uBlZ2SUbEbcZJfrENYORUDGpreYqUqB9v46AT0XIxHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qcMU9AYUHXjhW0lx53tZKB+O6/85WXPvCnXU9rg6n8tDvDJd0aycoY9MBtKsr0++p
	 XgTYKnQFk3l50vCWRjRUBAS5czxsLw2ngp4UYth2uqsn65vtt20uaj4Wxc9CXAJ2ty
	 VSH/Sy4Xg4uI8lTWj0HWzRRVGHnssPrljjw0Xqb8d9YPf55RL6EE7bgr4Tteh20oRt
	 aL2WS5GybBIV+WxkPqlp+GHZd+XqqUWxGH7RPYps7g40Vi6AQlgCgX8vJ07C9Xxmmi
	 tepsPBVsCEOOO8sjcCBPDRU/7AHjfldgXu+J6hVJUBxmMsN14qAZYAytd9NNGIPR0N
	 UXa/BjXj+uQHQ==
Date: Tue, 27 Jan 2026 17:39:08 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/10] xfs: refactor zone reset handling
Message-ID: <20260128013908.GH5945@frogsfrogsfrogs>
References: <20260127160619.330250-1-hch@lst.de>
 <20260127160619.330250-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127160619.330250-9-hch@lst.de>

On Tue, Jan 27, 2026 at 05:05:48PM +0100, Christoph Hellwig wrote:
> Include the actual bio submission in the common zone reset handler to
> share more code and prepare for adding error injection for zone reset.
> 
> Note the I plan to refactor the block layer submit_bio_wait and
> bio_await_chain code in the next merge window to remove some of the
> code duplication added here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Seems fine to me...
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 49 +++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 60964c926f9f..4023448e85d1 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -893,40 +893,55 @@ xfs_zone_gc_finish_reset(
>  	bio_put(&chunk->bio);
>  }
>  
> -static bool
> -xfs_zone_gc_prepare_reset(
> -	struct bio		*bio,
> -	struct xfs_rtgroup	*rtg)
> +static void
> +xfs_submit_zone_reset_bio(
> +	struct xfs_rtgroup	*rtg,
> +	struct bio		*bio)
>  {
>  	trace_xfs_zone_reset(rtg);
>  
>  	ASSERT(rtg_rmap(rtg)->i_used_blocks == 0);
>  	bio->bi_iter.bi_sector = xfs_gbno_to_daddr(&rtg->rtg_group, 0);
>  	if (!bdev_zone_is_seq(bio->bi_bdev, bio->bi_iter.bi_sector)) {
> -		if (!bdev_max_discard_sectors(bio->bi_bdev))
> -			return false;
> +		/*
> +		 * Also use the bio to drive the state machine when neither
> +		 * zone reset nor discard is supported to keep things simple.
> +		 */
> +		if (!bdev_max_discard_sectors(bio->bi_bdev)) {
> +			bio_endio(bio);
> +			return;
> +		}
>  		bio->bi_opf &= ~REQ_OP_ZONE_RESET;
>  		bio->bi_opf |= REQ_OP_DISCARD;
>  		bio->bi_iter.bi_size =
>  			XFS_FSB_TO_B(rtg_mount(rtg), rtg_blocks(rtg));
>  	}
>  
> -	return true;
> +	submit_bio(bio);
> +}
> +
> +static void xfs_bio_wait_endio(struct bio *bio)
> +{
> +	complete(bio->bi_private);
>  }
>  
>  int
>  xfs_zone_gc_reset_sync(
>  	struct xfs_rtgroup	*rtg)
>  {
> -	int			error = 0;
> +	DECLARE_COMPLETION_ONSTACK(done);
>  	struct bio		bio;
> +	int			error;
>  
>  	bio_init(&bio, rtg_mount(rtg)->m_rtdev_targp->bt_bdev, NULL, 0,
> -			REQ_OP_ZONE_RESET);
> -	if (xfs_zone_gc_prepare_reset(&bio, rtg))
> -		error = submit_bio_wait(&bio);
> -	bio_uninit(&bio);
> +			REQ_OP_ZONE_RESET | REQ_SYNC);
> +	bio.bi_private = &done;
> +	bio.bi_end_io = xfs_bio_wait_endio;
> +	xfs_submit_zone_reset_bio(rtg, &bio);
> +	wait_for_completion_io(&done);
>  
> +	error = blk_status_to_errno(bio.bi_status);
> +	bio_uninit(&bio);
>  	return error;
>  }
>  
> @@ -961,15 +976,7 @@ xfs_zone_gc_reset_zones(
>  		chunk->data = data;
>  		WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  		list_add_tail(&chunk->entry, &data->resetting);
> -
> -		/*
> -		 * Also use the bio to drive the state machine when neither
> -		 * zone reset nor discard is supported to keep things simple.
> -		 */
> -		if (xfs_zone_gc_prepare_reset(bio, rtg))
> -			submit_bio(bio);
> -		else
> -			bio_endio(bio);
> +		xfs_submit_zone_reset_bio(rtg, bio);
>  	} while (next);
>  }
>  
> -- 
> 2.47.3
> 
> 
