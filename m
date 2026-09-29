Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CEB0351C17;
	Tue, 29 Sep 2026 01:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790644001; cv=none; b=cfxMAdPoxrdd+NaJzj4QZ7JVCx/NZwJkvdSxut5gseMC9YrdMsoimCbQt5dCArlUsfMlNo/WM2tPcq9fBXQythnBO6YFuxEu2YIhW/yIuz8fbJsEtq8waAuiZkw3B/Nkj1HOcrduqTRaz1SlgdE70sWgr7E21m1JYZhkshuYvA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790644001; c=relaxed/simple;
	bh=mDPM37/KsmOSBDsKAf1fSB83Lad8d8Yospq5A6p1X2Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W0dGSE+zQ6O75O7Oq6LIXMgmqDKRF0hdpKQBItEudf41+dPoWJJJsaHmRQO7RphUGT/Zo4dUIbiKO2CjdnnzQzkD054g2I7NrgFaUNme06TAhHa3QAH9YZaLdp5TURrR2zwdgQnhmwASpCeRBk7HKCZVfHnRn6KHsHa7wtIM/ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MG4iJBNX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MG4iJBNX"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A65031F000FF;
	Tue, 29 Sep 2026 01:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790643999;
	bh=eSqX1y5jf0iJm9aQ/Uwsh+dRyv2y2JByVpu9ugM0DME=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MG4iJBNX9hMVLe2Bu1PqioSkob6lmilRW0hudK+SWfmDlbEAdVvljpjYkGMmf9Hw9
	 kcLQEOUMbvQ4rG3+93ZzKWvAq0IEs8bkIPj+kdKN3mrbxukYj6pPr+h8CF8GLgANP+
	 cWapnw4J5/4wv6X89MrLnPZffRBEI8SO52dwE9p/N7bd1VW3fKUHIP5rGi0vnihZ4G
	 fhWw8lV1fH4ockjix4pFYPUuRC4CzqwnrY8xwgPewOwQIjVdug8PNhbBxhJiXBGUmv
	 z5OJfnYk9UvZrJiXf1YCHl+hSm+XGHPSXHnu6KCk3GqhZFZEUuEJil2QJUI67TvANR
	 F0QdWFUIBA1gw==
Date: Mon, 28 Sep 2026 18:06:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 16/21] xfs: add data checksum support to zoned garbage
 collection
Message-ID: <20260929010639.GX2705364@frogsfrogsfrogs>
References: <20260924100032.2733101-1-hch@lst.de>
 <20260924100032.2733101-17-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924100032.2733101-17-hch@lst.de>

On Thu, Sep 24, 2026 at 11:59:48AM +0200, Christoph Hellwig wrote:
> Transfer the checksum from the old location to the new one.  The
> implementation mirrors that of user data reads and writes.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 65 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 53 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 5fdcf98a2133..1cebd2ee2136 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -21,6 +21,7 @@
>  #include "xfs_zone_alloc.h"
>  #include "xfs_zone_priv.h"
>  #include "xfs_zones.h"
> +#include "xfs_rtcsum.h"
>  #include "xfs_trace.h"
>  
>  /*
> @@ -106,6 +107,10 @@ struct xfs_gc_bio {
>  	/* Realtime group currently being reclaimed */
>  	struct xfs_rtgroup		*victim_rtg;
>  
> +	/* Buffer for data checksums */
> +	struct xfs_buf			*csum_bp;
> +	void				*csum_buf;

Where is csum_buf used?

> +
>  	/* Bio used for reads and writes, including the bvec used by it */
>  	struct bio			bio;	/* must be last */
>  };
> @@ -660,6 +665,20 @@ xfs_zone_gc_alloc_blocks(
>  	return true;
>  }
>  
> +static void
> +xfs_zone_gc_free_chunk(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	atomic_dec(&chunk->victim_rtg->rtg_gccount);
> +	xfs_rtgroup_rele(chunk->victim_rtg);
> +	list_del(&chunk->entry);
> +	xfs_open_zone_put(chunk->oz);
> +	if (chunk->csum_bp)
> +		xfs_buf_rele(chunk->csum_bp);
> +	xfs_irele(chunk->ip);
> +	bio_put(&chunk->bio);
> +}
> +
>  static void
>  xfs_zone_gc_add_data(
>  	struct xfs_gc_bio	*chunk)
> @@ -725,6 +744,11 @@ xfs_zone_gc_start_chunk(
>  	if (!xfs_zone_gc_iter_irec(mp, iter, &irec, &ip))
>  		return false;
>  
> +	if (xfs_has_rtcsum(mp)) {
> +		irec.rm_blockcount = min(irec.rm_blockcount,
> +			xfs_rtcsum_max_len(mp, irec.rm_startblock));
> +	}
> +
>  	if (!xfs_zone_gc_alloc_blocks(data, &irec.rm_blockcount, &daddr,
>  			&is_seq)) {
>  		xfs_irele(ip);
> @@ -748,6 +772,7 @@ xfs_zone_gc_start_chunk(
>  	chunk->data = data;
>  	chunk->oz = data->oz;
>  	chunk->victim_rtg = iter->victim_rtg;
> +	chunk->csum_bp = NULL;
>  	atomic_inc(&rtg_group(chunk->victim_rtg)->xg_active_ref);
>  	atomic_inc(&chunk->victim_rtg->rtg_gccount);
>  
> @@ -764,22 +789,22 @@ xfs_zone_gc_start_chunk(
>  	list_add_tail(&chunk->entry, &data->reading);
>  	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
>  
> +	if (xfs_is_rtcsum_inode(ip)) {
> +		int error;
> +
> +		error = xfs_rtcsum_read_async(mp, chunk->old_startblock,
> +				&chunk->csum_bp);
> +		if (error) {
> +			xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
> +			xfs_zone_gc_free_chunk(chunk);
> +			return false;
> +		}

Ok so this starts the csum block read asynchronously, and then submits
the read bio.  chunk->csum_bp is the checksum buffer of the rtcsum file
of the zone we're cleaning out, right?

> +	}
> +
>  	submit_bio(bio);
>  	return true;
>  }
>  
> -static void
> -xfs_zone_gc_free_chunk(
> -	struct xfs_gc_bio	*chunk)
> -{
> -	atomic_dec(&chunk->victim_rtg->rtg_gccount);
> -	xfs_rtgroup_rele(chunk->victim_rtg);
> -	list_del(&chunk->entry);
> -	xfs_open_zone_put(chunk->oz);
> -	xfs_irele(chunk->ip);
> -	bio_put(&chunk->bio);
> -}
> -
>  static void
>  xfs_zone_gc_submit_write(
>  	struct xfs_zone_gc_data	*data,
> @@ -832,6 +857,9 @@ xfs_zone_gc_split_write(
>  	split_chunk->old_startblock = chunk->old_startblock;
>  	split_chunk->new_daddr = chunk->new_daddr;
>  	split_chunk->oz = chunk->oz;
> +	split_chunk->csum_bp = chunk->csum_bp;
> +	if (split_chunk->csum_bp)
> +		xfs_buf_hold(split_chunk->csum_bp);
>  	atomic_inc(&chunk->oz->oz_ref);
>  
>  	split_chunk->victim_rtg = chunk->victim_rtg;
> @@ -919,6 +947,19 @@ xfs_zone_gc_finish_chunk(
>  
>  	if (chunk->is_seq)
>  		chunk->new_daddr = chunk->bio.bi_iter.bi_sector;
> +
> +	if (xfs_is_rtcsum_inode(ip)) {
> +		unsigned int	boff;
> +
> +		error = xfs_buf_read_async_wait(chunk->csum_bp);
> +		if (error)
> +			goto free;
> +
> +		boff = xfs_rtb_to_rtcsumoff(mp, chunk->old_startblock);
> +		error = xfs_rtcsum_log(chunk->oz, chunk->new_daddr, chunk->len,
> +				chunk->csum_bp->b_addr + boff);

...and then write the same checksum to the new daddr using the old
checksum.  There's no explicit validation of the checksum in the garbage
collector itself, but I gather the read ioend did this for us already,
right?

--D

> +	}
> +
>  	error = xfs_zoned_end_io(ip, chunk->offset, chunk->len,
>  			chunk->new_daddr, chunk->oz, chunk->old_startblock);
>  free:
> -- 
> 2.53.0
> 
> 
