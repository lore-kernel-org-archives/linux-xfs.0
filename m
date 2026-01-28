Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24112264A9
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 05:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769578512; cv=none; b=WDnEZWWR0UJzKy+HQ3wR4Jg1ZaXWBpRkor2K6yiuSln+L4nJvxb5UmkUzaqD62rWSbR7j1drn9R1CAb4k3A245qDgt5Mu+h5F6mbz+EU3IAJNY3k3O70MCmvGi5DsXPAnw1K4OVaSw4+/2aFiPOdm9qY+L9RRKoIgGKLB+BfkhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769578512; c=relaxed/simple;
	bh=b7BFOsSUaRLzSWydYTJiBKamR5qPGbwA0p0yspD2DyU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JWRlVsHurg8TtRquP7jyt9dNmLxdPV13WTUvX2GYdiEowAJ7xJTniye/biTdH2N4XZFtqHlXOfbXRRUfvIPLm6kxMgJIpBJHHku2KokJfTIjEVBvW3kKSIp1YxxR3DXxsdo+IC+4BuA8C6BLpOsHZ/H8ShLsfYs2Ezyj0NAsOlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eRg9/Aoc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eRg9/Aoc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5002AC4CEF1;
	Wed, 28 Jan 2026 05:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769578512;
	bh=b7BFOsSUaRLzSWydYTJiBKamR5qPGbwA0p0yspD2DyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eRg9/Aoc8fGBdblNfkCyES1FhtC3TeexQFBmtRFAvorOi6nhaUDxq/FxEopadvLQW
	 /gGa8FGNkMHClRjHNYZL9BAfLX84DvugvoO1jeu/lYDATW/PX6xHLfNaqS1h9jP38L
	 4qyHCj8+4dxr5cpAlIVMRKhF0NpXR2dQVIEoliDzVlHm5nDh07ZI/IKc4Ia46oOPXF
	 YsDuQm7Sme8qIjvS7fLVZ3huP4VPp0ogPfrbNb5qwWICxxHfClbgj87+AY7zpeLgQt
	 oD+5HL7931C91RtYhsKGEuuxdeRaVZHKV1GdlngaSiIAkTDdYbwrciBR+Fr830CWDX
	 mO6BiWYUuMc/A==
Date: Tue, 27 Jan 2026 21:35:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	Chris Mason <clm@meta.com>, Keith Busch <kbusch@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: use a seprate member to track space availabe in
 the GC scatch buffer
Message-ID: <20260128053511.GR5945@frogsfrogsfrogs>
References: <20260127151026.299341-1-hch@lst.de>
 <20260127151026.299341-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127151026.299341-2-hch@lst.de>

On Tue, Jan 27, 2026 at 04:10:20PM +0100, Christoph Hellwig wrote:
> When scratch_head wraps back to 0 and scratch_tail is also 0 because no
> I/O has completed yet, the ring buffer could be mistaken for empty.
> 
> Fix this by introducing a separate scratch_available member in
> struct xfs_zone_gc_data.  This actually ends up simplifying the code as
> well.
> 
> Reported-by: Chris Mason <clm@meta.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_zone_gc.c | 25 +++++++++----------------
>  1 file changed, 9 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
> index dfa6653210c7..8c08e5519bff 100644
> --- a/fs/xfs/xfs_zone_gc.c
> +++ b/fs/xfs/xfs_zone_gc.c
> @@ -131,10 +131,13 @@ struct xfs_zone_gc_data {
>  	/*
>  	 * Scratchpad to buffer GC data, organized as a ring buffer over
>  	 * discontiguous folios.  scratch_head is where the buffer is filled,
> -	 * and scratch_tail tracks the buffer space freed.
> +	 * scratch_tail tracks the buffer space freed, and scratch_available
> +	 * counts the space available in the ring buffer between the head and
> +	 * the tail.
>  	 */
>  	struct folio			*scratch_folios[XFS_GC_NR_BUFS];
>  	unsigned int			scratch_size;
> +	unsigned int			scratch_available;
>  	unsigned int			scratch_head;
>  	unsigned int			scratch_tail;

Hrm.  I did some digging (because clearly I'm not that good at
ringbuffer) and came up with this gem from akpm:

"A circular buffer implementation needs only head and tail indices.
`size' above appears to be redundant.

"Implementation-wise, the head and tail indices should *not* be
constrained to be less than the size of the buffer. They should be
allowed to wrap all the way back to zero. This allows you to distinguish
between the completely-empty and completely-full states while using 100%
of the storage."

https://lkml.iu.edu/hypermail/linux/kernel/0409.1/2709.html

Can that apply here?

--D

>  
> @@ -212,6 +215,7 @@ xfs_zone_gc_data_alloc(
>  			goto out_free_scratch;
>  	}
>  	data->scratch_size = XFS_GC_BUF_SIZE * XFS_GC_NR_BUFS;
> +	data->scratch_available = data->scratch_size;
>  	INIT_LIST_HEAD(&data->reading);
>  	INIT_LIST_HEAD(&data->writing);
>  	INIT_LIST_HEAD(&data->resetting);
> @@ -574,18 +578,6 @@ xfs_zone_gc_ensure_target(
>  	return oz;
>  }
>  
> -static unsigned int
> -xfs_zone_gc_scratch_available(
> -	struct xfs_zone_gc_data	*data)
> -{
> -	if (!data->scratch_tail)
> -		return data->scratch_size - data->scratch_head;
> -
> -	if (!data->scratch_head)
> -		return data->scratch_tail;
> -	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
> -}
> -
>  static bool
>  xfs_zone_gc_space_available(
>  	struct xfs_zone_gc_data	*data)
> @@ -596,7 +588,7 @@ xfs_zone_gc_space_available(
>  	if (!oz)
>  		return false;
>  	return oz->oz_allocated < rtg_blocks(oz->oz_rtg) &&
> -		xfs_zone_gc_scratch_available(data);
> +		data->scratch_available;
>  }
>  
>  static void
> @@ -625,8 +617,7 @@ xfs_zone_gc_alloc_blocks(
>  	if (!oz)
>  		return NULL;
>  
> -	*count_fsb = min(*count_fsb,
> -		XFS_B_TO_FSB(mp, xfs_zone_gc_scratch_available(data)));
> +	*count_fsb = min(*count_fsb, XFS_B_TO_FSB(mp, data->scratch_available));
>  
>  	/*
>  	 * Directly allocate GC blocks from the reserved pool.
> @@ -730,6 +721,7 @@ xfs_zone_gc_start_chunk(
>  	bio->bi_end_io = xfs_zone_gc_end_io;
>  	xfs_zone_gc_add_data(chunk);
>  	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
> +	data->scratch_available -= len;
>  
>  	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
>  	list_add_tail(&chunk->entry, &data->reading);
> @@ -862,6 +854,7 @@ xfs_zone_gc_finish_chunk(
>  
>  	data->scratch_tail =
>  		(data->scratch_tail + chunk->len) % data->scratch_size;
> +	data->scratch_available += chunk->len;
>  
>  	/*
>  	 * Cycle through the iolock and wait for direct I/O and layouts to
> -- 
> 2.47.3
> 
> 
