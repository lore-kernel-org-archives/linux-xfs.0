Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C53359FA9;
	Fri,  9 Jan 2026 12:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961463; cv=none; b=FpJPmphQ/vcOBCfLsbsbtualXGUXtR0hcsk3bhipWEuOHZY0wGTPevy/F18bLBduyoU+JfmTFy3UrkHsHTIxWtYUaqofnocTFRSFqYaXwppKQN56LFmihGqD+ZO2PIfxuJ3qA1nW7EyY+fMLmsdTpp1RZ4SZpE8vZb62ubgrKeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961463; c=relaxed/simple;
	bh=9CelIXlUwF0eBdZnmpYz4I7obd+q+TVOc4T+qw3wxfk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uRicKGjUcYcLq/2nnuuEf/P/bgEudzWNOzeScnHMK9mmbVAjIacDqpTd8hoZ2r0tKv7g3E0bt0AC1a7E6bItmXAIdPqmGUEFJrg8Vi335syFlpSdpbEmDgWrkU+enPIh1oJ4pAWihvdTo3ENd13AP2xR+BpzaUSmwzxr8tadIvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKWnYr3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKWnYr3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFBAC4CEF1;
	Fri,  9 Jan 2026 12:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767961463;
	bh=9CelIXlUwF0eBdZnmpYz4I7obd+q+TVOc4T+qw3wxfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iKWnYr3dUG6kJOOSvASovWCgx5lJTBcownYg8ZBbON8kHDuUUPaDUWnIgpyCNlA+M
	 ObXNzsKmrlro6RTtS8QBQFyKwKq6khAeM/qP3eqrnB9OOoPgcc59EQRvV/sD0tshJ1
	 Rw8Uaif43Z+zjkzY80d+QiGtro9Xkwlyb7UdGBJSK/cEhgq2y58NU6F16EpfIKX2kD
	 WHJXCuxur+4oREDVU23cCiL3tGpoVaBo76fpQE7yr3ysxeaSs8oHO4DBb9xR8LNJY1
	 1+bQIEGwy6bqg1I+mYxoH/tIf+IilY/TmXhKnE99p6EP84dSbacxM9whF1Ft0XEDQu
	 ++upyY6j0xUig==
Date: Fri, 9 Jan 2026 13:24:19 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>, 
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: rework zone GC buffer management
Message-ID: <aWDzaJB7PXyW09Nb@nidhogg.toxiclabs.cc>
References: <20260106075914.1614368-1-hch@lst.de>
 <20260106075914.1614368-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260106075914.1614368-4-hch@lst.de>

On Tue, Jan 06, 2026 at 08:58:54AM +0100, Christoph Hellwig wrote:
> The double buffering where just one scratch area is used at a time does
> not efficiently use the available memory.  It was originally implemented
> when GC I/O could happen out of order, but that was removed before
> upstream submission to avoid fragmentation.  Now that all GC I/Os are
> processed in order, just use a number of buffers as a simple ring buffer.
> 
> For a synthetic benchmark that fills 256MiB HDD zones and punches out
> holes to free half the space this leads to a decrease of GC time by
> a little more than 25%.
> 
> Thanks to Hans Holmberg <hans.holmberg@wdc.com> for testing and
> benchmarking.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
>  fs/xfs/xfs_zone_gc.c | 106 ++++++++++++++++++++++++-------------------
>  1 file changed, 59 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index 40408b1132e0..960cf79d484e 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -50,23 +50,11 @@
>   */
>  
>  /*
> - * Size of each GC scratch pad.  This is also the upper bound for each
> - * GC I/O, which helps to keep latency down.
> + * Size of each GC scratch allocation, and the number of buffers.
>   */
> -#define XFS_GC_CHUNK_SIZE	SZ_1M
> -
> -/*
> - * Scratchpad data to read GCed data into.
> - *
> - * The offset member tracks where the next allocation starts, and freed tracks
> - * the amount of space that is not used anymore.
> - */
> -#define XFS_ZONE_GC_NR_SCRATCH	2
> -struct xfs_zone_scratch {
> -	struct folio			*folio;
> -	unsigned int			offset;
> -	unsigned int			freed;
> -};
> +#define XFS_GC_BUF_SIZE		SZ_1M
> +#define XFS_GC_NR_BUFS		2
> +static_assert(XFS_GC_NR_BUFS < BIO_MAX_VECS);
>  
>  /*
>   * Chunk that is read and written for each GC operation.
> @@ -141,10 +129,14 @@ struct xfs_zone_gc_data {
>  	struct bio_set			bio_set;
>  
>  	/*
> -	 * Scratchpad used, and index to indicated which one is used.
> +	 * Scratchpad to buffer GC data, organized as a ring buffer over
> +	 * discontiguous folios.  scratch_head is where the buffer is filled,
> +	 * and scratch_tail tracks the buffer space freed.
>  	 */
> -	struct xfs_zone_scratch		scratch[XFS_ZONE_GC_NR_SCRATCH];
> -	unsigned int			scratch_idx;
> +	struct folio			*scratch_folios[XFS_GC_NR_BUFS];
> +	unsigned int			scratch_size;
> +	unsigned int			scratch_head;
> +	unsigned int			scratch_tail;
>  
>  	/*
>  	 * List of bios currently being read, written and reset.
> @@ -210,20 +202,16 @@ xfs_zone_gc_data_alloc(
>  	if (!data->iter.recs)
>  		goto out_free_data;
>  
> -	/*
> -	 * We actually only need a single bio_vec.  It would be nice to have
> -	 * a flag that only allocates the inline bvecs and not the separate
> -	 * bvec pool.
> -	 */
>  	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
>  			BIOSET_NEED_BVECS))
>  		goto out_free_recs;
> -	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++) {
> -		data->scratch[i].folio =
> -			folio_alloc(GFP_KERNEL, get_order(XFS_GC_CHUNK_SIZE));
> -		if (!data->scratch[i].folio)
> +	for (i = 0; i < XFS_GC_NR_BUFS; i++) {
> +		data->scratch_folios[i] =
> +			folio_alloc(GFP_KERNEL, get_order(XFS_GC_BUF_SIZE));
> +		if (!data->scratch_folios[i])
>  			goto out_free_scratch;
>  	}
> +	data->scratch_size = XFS_GC_BUF_SIZE * XFS_GC_NR_BUFS;
>  	INIT_LIST_HEAD(&data->reading);
>  	INIT_LIST_HEAD(&data->writing);
>  	INIT_LIST_HEAD(&data->resetting);
> @@ -232,7 +220,7 @@ xfs_zone_gc_data_alloc(
>  
>  out_free_scratch:
>  	while (--i >= 0)
> -		folio_put(data->scratch[i].folio);
> +		folio_put(data->scratch_folios[i]);
>  	bioset_exit(&data->bio_set);
>  out_free_recs:
>  	kfree(data->iter.recs);
> @@ -247,8 +235,8 @@ xfs_zone_gc_data_free(
>  {
>  	int			i;
>  
> -	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++)
> -		folio_put(data->scratch[i].folio);
> +	for (i = 0; i < XFS_GC_NR_BUFS; i++)
> +		folio_put(data->scratch_folios[i]);
>  	bioset_exit(&data->bio_set);
>  	kfree(data->iter.recs);
>  	kfree(data);
> @@ -590,7 +578,12 @@ static unsigned int
>  xfs_zone_gc_scratch_available(
>  	struct xfs_zone_gc_data	*data)
>  {
> -	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
> +	if (!data->scratch_tail)
> +		return data->scratch_size - data->scratch_head;
> +
> +	if (!data->scratch_head)
> +		return data->scratch_tail;
> +	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
>  }
>  
>  static bool
> @@ -664,6 +657,28 @@ xfs_zone_gc_alloc_blocks(
>  	return oz;
>  }
>  
> +static void
> +xfs_zone_gc_add_data(
> +	struct xfs_gc_bio	*chunk)
> +{
> +	struct xfs_zone_gc_data	*data = chunk->data;
> +	unsigned int		len = chunk->len;
> +	unsigned int		off = data->scratch_head;
> +
> +	do {
> +		unsigned int	this_off = off % XFS_GC_BUF_SIZE;
> +		unsigned int	this_len = min(len, XFS_GC_BUF_SIZE - this_off);
> +
> +		bio_add_folio_nofail(&chunk->bio,
> +				data->scratch_folios[off / XFS_GC_BUF_SIZE],
> +				this_len, this_off);
> +		len -= this_len;
> +		off += this_len;
> +		if (off == data->scratch_size)
> +			off = 0;
> +	} while (len);
> +}
> +
>  static bool
>  xfs_zone_gc_start_chunk(
>  	struct xfs_zone_gc_data	*data)
> @@ -677,6 +692,7 @@ xfs_zone_gc_start_chunk(
>  	struct xfs_inode	*ip;
>  	struct bio		*bio;
>  	xfs_daddr_t		daddr;
> +	unsigned int		len;
>  	bool			is_seq;
>  
>  	if (xfs_is_shutdown(mp))
> @@ -691,17 +707,19 @@ xfs_zone_gc_start_chunk(
>  		return false;
>  	}
>  
> -	bio = bio_alloc_bioset(bdev, 1, REQ_OP_READ, GFP_NOFS, &data->bio_set);
> +	len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
> +	bio = bio_alloc_bioset(bdev,
> +			min(howmany(len, XFS_GC_BUF_SIZE) + 1, XFS_GC_NR_BUFS),
> +			REQ_OP_READ, GFP_NOFS, &data->bio_set);
>  
>  	chunk = container_of(bio, struct xfs_gc_bio, bio);
>  	chunk->ip = ip;
>  	chunk->offset = XFS_FSB_TO_B(mp, irec.rm_offset);
> -	chunk->len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
> +	chunk->len = len;
>  	chunk->old_startblock =
>  		xfs_rgbno_to_rtb(iter->victim_rtg, irec.rm_startblock);
>  	chunk->new_daddr = daddr;
>  	chunk->is_seq = is_seq;
> -	chunk->scratch = &data->scratch[data->scratch_idx];
>  	chunk->data = data;
>  	chunk->oz = oz;
>  	chunk->victim_rtg = iter->victim_rtg;
> @@ -710,13 +728,9 @@ xfs_zone_gc_start_chunk(
>  
>  	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
>  	bio->bi_end_io = xfs_zone_gc_end_io;
> -	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
> -			chunk->scratch->offset);
> -	chunk->scratch->offset += chunk->len;
> -	if (chunk->scratch->offset == XFS_GC_CHUNK_SIZE) {
> -		data->scratch_idx =
> -			(data->scratch_idx + 1) % XFS_ZONE_GC_NR_SCRATCH;
> -	}
> +	xfs_zone_gc_add_data(chunk);
> +	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
> +
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_add_tail(&chunk->entry, &data->reading);
>  	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
> @@ -834,6 +848,7 @@ xfs_zone_gc_finish_chunk(
>  	struct xfs_gc_bio	*chunk)
>  {
>  	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
> +	struct xfs_zone_gc_data	*data = chunk->data;
>  	struct xfs_inode	*ip = chunk->ip;
>  	struct xfs_mount	*mp = ip->i_mount;
>  	int			error;
> @@ -845,11 +860,8 @@ xfs_zone_gc_finish_chunk(
>  		return;
>  	}
>  
> -	chunk->scratch->freed += chunk->len;
> -	if (chunk->scratch->freed == chunk->scratch->offset) {
> -		chunk->scratch->offset = 0;
> -		chunk->scratch->freed = 0;
> -	}
> +	data->scratch_tail =
> +		(data->scratch_tail + chunk->len) % data->scratch_size;
>  
>  	/*
>  	 * Cycle through the iolock and wait for direct I/O and layouts to
> -- 
> 2.47.3
> 
> 
