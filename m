Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1477E32571B;
	Wed, 14 Jan 2026 19:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768420228; cv=none; b=B2OnHN38TOj/ScglwRlMDnsQVQWgZ2y+yF7y+5Me01z+Il1IMIhNF1CAxcrnVAsZpTmWNyqAA8fBXaCGiJlF07kcNBGndnZ+gvQzFTMwn8bkn4FwIOEyc4uHERvzqLKmIrUGOhOEpXjr9oabrli1ZzpuIdKL9LqtljlSjv8pfXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768420228; c=relaxed/simple;
	bh=M/R+TrDYbTo4nZxT8zvNikkPFeiD4wvTKKo0vVzlv/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R6KBD/urHIzsTRj03UQzdNjmbR3GEWHckLdsWR5m5ahT/RqyBcTaPkq94mVQ32JI97LHQpcWaaBRaoC0A7+U59GHihUp3Rm4f66Y97UkpINdOkinaRpv2Q+QN9AdYvnR7vDOXnaP+8tPKyXGKwqOaaiYRses8OzM3AlhgFYfO8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czkXzQqj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czkXzQqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC469C4CEF7;
	Wed, 14 Jan 2026 19:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768420227;
	bh=M/R+TrDYbTo4nZxT8zvNikkPFeiD4wvTKKo0vVzlv/c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=czkXzQqjtQeEHzg+POnhkmU9FVdyohCMt2pG09BoGJ2AYiU4JmlBVoVvtTSc2Vi0y
	 RdDNSXv+ibsc7xN5kch8cRZMWdy9GWfupT0MaN4Zrhlf44G41o8kbOEMsuWLJIDPcB
	 +Ob1qr97X6NotCA5s46ZJ3BRfekPwoZDIpCze4zMCfesvzDOwmter1uuFqWwF3mGda
	 2E7EhoP5ixlBLdtKqYu9Xpdlc4M2rlJqVY8Tao9vqq3Nus8hRdLEabIzQBJ5/Rydcn
	 I4RMfgsZHZno/YNk9fpPz9cuPFvjahijYne8qtvDQCRgOxEotPVatd/7naobNPFikb
	 u4bGNIm2GS51g==
Date: Wed, 14 Jan 2026 11:50:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/3] xfs: use bio_reuse in the zone GC code
Message-ID: <20260114195027.GH15551@frogsfrogsfrogs>
References: <20260114130651.3439765-1-hch@lst.de>
 <20260114130651.3439765-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114130651.3439765-3-hch@lst.de>

On Wed, Jan 14, 2026 at 02:06:42PM +0100, Christoph Hellwig wrote:
> Replace our somewhat fragile code to reuse the bio, which caused a
> regression in the past with the block layer bio_reuse helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Ok, you're right, that does make more sense to pass REQ_OP to bio_reuse.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_zone_gc.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 3c52cc1497d4..c9a3df6a5289 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -811,8 +811,6 @@ xfs_zone_gc_write_chunk(
>  {
>  	struct xfs_zone_gc_data	*data = chunk->data;
>  	struct xfs_mount	*mp = chunk->ip->i_mount;
> -	phys_addr_t		bvec_paddr =
> -		bvec_phys(bio_first_bvec_all(&chunk->bio));
>  	struct xfs_gc_bio	*split_chunk;
>  
>  	if (chunk->bio.bi_status)
> @@ -825,10 +823,7 @@ xfs_zone_gc_write_chunk(
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_move_tail(&chunk->entry, &data->writing);
>  
> -	bio_reset(&chunk->bio, mp->m_rtdev_targp->bt_bdev, REQ_OP_WRITE);
> -	bio_add_folio_nofail(&chunk->bio, chunk->scratch->folio, chunk->len,
> -			offset_in_folio(chunk->scratch->folio, bvec_paddr));
> -
> +	bio_reuse(&chunk->bio, REQ_OP_WRITE);
>  	while ((split_chunk = xfs_zone_gc_split_write(data, chunk)))
>  		xfs_zone_gc_submit_write(data, split_chunk);
>  	xfs_zone_gc_submit_write(data, chunk);
> -- 
> 2.47.3
> 
> 
