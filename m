Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23999253352
	for <linux-xfs@vger.kernel.org>; Mon, 12 May 2025 17:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747069442; cv=none; b=OUYmF3eq1Chkc1y9kpI62uOXZthiNKjC6XSFp60keRbmY9AKov5yjU+AVGPJAiseCNXk+0xPwql24/sXermwp4p+G2PgqZRvD5RMzMD7sjEQLYVJpuXRMp2W/g5j4ouFTD1PQMszFqCEru/RPwEAVrcdkMcbYbUuCc2bAXw8feg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747069442; c=relaxed/simple;
	bh=zk/45eEJv4g67PWmuZ0AvC00wPMpr7hsgYhUfhkMdoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eDbpeLmXLXlbm9POGVxpZnCqZyViiAK7HHxFX+q6hGcBdzMdMYwj+/QSsNJPtWvW6JsE6uiEbhNCKFsBe0H0QhT+IzOs9RQ8dPdEiWFEg4nH9EFSr5OISyt2Q9nFp3nTb2Ul+pddry4CdoEQmDrxfenw0xcK4qakS2nbWrwk+20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FayxJV2B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FayxJV2B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CA1C4CEEE;
	Mon, 12 May 2025 17:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747069441;
	bh=zk/45eEJv4g67PWmuZ0AvC00wPMpr7hsgYhUfhkMdoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FayxJV2BMC6NhJOCaQiEWsG/uvYrLDomnPBr2ZQUMzX0hgGWRIAyMdhQ25C+uY0h3
	 vb8Rq6P6G8GLMQFLSsKIcBNQ5RWJ10jkXKLsT6yT5p8Dtk3QMmM24dQtWk4H+lA0SC
	 9EZVWg0jrIe/eKxDwmy6EK1RqnVajJzFYcRo+L60+f4HV+PwTeh82uaRFlGtPQ3fN/
	 S7eoEA+sUkhA+7CEjytR53sihMocgDereTs+q5gGx8j3dbG7W3D8ob9U0M4zp8tZ1L
	 j2DyoLw4129CXGSdYhvl449tCYM/i82f23bvWl6qC/7+VQjLDgXld8fC+9wsSpBw6T
	 qyS9PAMi13ahA==
Date: Mon, 12 May 2025 10:04:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, hans.holmberg@wdc.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix zoned GC data corruption due to wrong bv_offset
Message-ID: <20250512170400.GH2701446@frogsfrogsfrogs>
References: <20250512144306.647922-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250512144306.647922-1-hch@lst.de>

On Mon, May 12, 2025 at 04:43:05PM +0200, Christoph Hellwig wrote:
> xfs_zone_gc_write_chunk writes out the data buffer read in earlier using
> the same bio, and currenly looks at bv_offset for the offset into the
> scratch folio for that.  But commit 26064d3e2b4d ("block: fix adding
> folio to bio") changed how bv_page and bv_offset are calculated for
> adding larger folios, breaking this fragile logic.
> 
> Switch to extracting the full physical address from the old bio_vec,
> and calculate the offset into the folio from that instead.
> 
> This fixes data corruption during garbage collection with heavy rockdsb
> workloads.  Thanks to Hans for tracking down the culprit commit during
> long bisection sessions.
> 
> Fixes: 26064d3e2b4d ("block: fix adding folio to bio")
> Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 8c541ca71872..a045b1dedd68 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -801,7 +801,8 @@ xfs_zone_gc_write_chunk(
>  {
>  	struct xfs_zone_gc_data	*data = chunk->data;
>  	struct xfs_mount	*mp = chunk->ip->i_mount;
> -	unsigned int		folio_offset = chunk->bio.bi_io_vec->bv_offset;
> +	phys_addr_t		bvec_paddr =
> +		bvec_phys(bio_first_bvec_all(&chunk->bio));

Hmm.  I started wondering why you can't reuse chunk->scratch->offset in
the bio_add_folio_nofail call below.  I /think/ that's because
xfs_zone_gc_start_chunk increments chunk->scratch->offset after adding
the folio to the bio?

	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
			chunk->scratch->offset);
	chunk->scratch->offset += chunk->len;

And then we can attach the same scratch->folio to different read bios.
Each bio gets a different offset within the folio, right?  So
xfs_zone_gc_write_chunk really does need to find the offset_in_folio
from the read bio.  And I guess that's why you use bvec_phys to figure
that out (instead of, say, wasting space recording it again in the
xfs_gc_bio), correct?

If the answers to all my questions are 'yes' then I think I grok this
sufficiently to say
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

>  	struct xfs_gc_bio	*split_chunk;
>  
>  	if (chunk->bio.bi_status)
> @@ -816,7 +817,7 @@ xfs_zone_gc_write_chunk(
>  
>  	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
>  	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> -			folio_offset);
> +			offset_in_folio(chunk->scratch->folio, bvec_paddr));
>  
>  	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
>  		xfs_zone_gc_submit_write(data, split_chunk);
> -- 
> 2.47.2
> 
> 
