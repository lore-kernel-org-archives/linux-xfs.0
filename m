Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0981F3B98
	for <linux-xfs@vger.kernel.org>; Tue,  1 Jul 2025 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751388712; cv=none; b=KZP/Uf0+IQ2ITxiZEaI57lYXyAFdUY9D6QN48VV8qPCMp4dKiIC1RXtaPv7C2eRic+gwl0hNxsA+NN2ZmO/ggt8iQCp+7w5HvrRinc5N3eH+ZnyvhDK13vWQNDHcLvkCyOKhk8PIBbyNM89qyROqBNpfOrI8v2WFfGw1PAKN6eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751388712; c=relaxed/simple;
	bh=ot1BQu5MNqez82h7x1Hhc77u+5v8KPahxF627KoW5+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSjV8eUsGdGxc0uZe3k/l8g0CHBcP9a7E8HHB4qMVDyWbmm1bqcqt/3gj6FVU2tMdXbLG9VAFu1772m3PxCnOprNo4m4J0hvpuxOMIW+3gnGs57QmaqP+lcQ+ZocSY7WUNsCC6TqymyIt8BmycHDCdDOVVO16chMhasis89ntdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErtABLpy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErtABLpy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05924C4CEEB;
	Tue,  1 Jul 2025 16:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751388712;
	bh=ot1BQu5MNqez82h7x1Hhc77u+5v8KPahxF627KoW5+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ErtABLpyOWUZBlvbC5TjGxLxl+c9k9Q3/hh/N5KnRgoaGLSABghF4dXueTnGWdEp7
	 8zsxQf17pdRm4pz5aLpJU+o2R8vBFSn9mF2AWx+8OOPrIHprBcgP4K1mmzd1IaFqIT
	 ubQyU/mmsmLl2wB2XsPmaYe1+Uydiv2zUkqCJts2v3Sz6VVKz++vMP/2+yWLIs1W6h
	 0U4CajXq83aYcpzcM78xzxUfIXu3rcb4GMqYTixmP93EqwqPiTnneIqjD2x2Bj/mXv
	 /I1CCgQLG/V7dZB5+NGJQLtabyZN3Sl+YwerG4oUcrFWNAjtNg8MAbLXmOnt2ouBed
	 XeFJBqoQOp7jg==
Date: Tue, 1 Jul 2025 09:51:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, John Garry <john.g.garry@oracle.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: remove the bt_meta_sectorsize field in struct
 buftarg
Message-ID: <20250701165151.GJ10009@frogsfrogsfrogs>
References: <20250701104125.1681798-1-hch@lst.de>
 <20250701104125.1681798-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701104125.1681798-8-hch@lst.de>

On Tue, Jul 01, 2025 at 12:40:41PM +0200, Christoph Hellwig wrote:
> The file system only has a single file system sector size.  Read that
> from the in-core super block to avoid confusion about the two different
> "sector sizes" stored in the buftarg.

Yeah, that whole bt_meta_sectorsize stuff was confusing.

>                                        Note that this loosens the
> alignment asserts for memory backed buftargs that set the page size here.

Doesn't matter at all since shmem files are byte addressable anyway. :)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_buf.c     | 20 +++++---------------
>  fs/xfs/xfs_buf.h     | 15 ---------------
>  fs/xfs/xfs_buf_mem.c |  2 --
>  3 files changed, 5 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index b73da43f489c..0f20d9514d0d 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -387,17 +387,18 @@ xfs_buf_map_verify(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map)
>  {
> +	struct xfs_mount	*mp = btp->bt_mount;
>  	xfs_daddr_t		eofs;
>  
>  	/* Check for IOs smaller than the sector size / not sector aligned */
> -	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
> -	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> +	ASSERT(!(BBTOB(map->bm_len) < mp->m_sb.sb_sectsize));

Urgh, should the polarity of this be reversed?

	ASSERT(BBTOB(map->bm_len) >= mp->m_sb.sb_sectsize);

Though I don't really care enough to block the patch so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)(mp->m_sb.sb_sectsize - 1)));
>  
>  	/*
>  	 * Corrupted block numbers can get through to here, unfortunately, so we
>  	 * have to check that the buffer falls within the filesystem bounds.
>  	 */
> -	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> +	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
>  		xfs_alert(btp->bt_mount,
>  			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
> @@ -1726,10 +1727,6 @@ xfs_configure_buftarg(
>  
>  	ASSERT(btp->bt_bdev != NULL);
>  
> -	/* Set up metadata sector size info */
> -	btp->bt_meta_sectorsize = sectorsize;
> -	btp->bt_meta_sectormask = sectorsize - 1;
> -
>  	error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
>  	if (error) {
>  		xfs_warn(btp->bt_mount,
> @@ -1816,14 +1813,7 @@ xfs_alloc_buftarg(
>  	if (error)
>  		goto error_free;
>  
> -	/*
> -	 * When allocating the buftargs we have not yet read the super block and
> -	 * thus don't know the file system sector size yet.
> -	 */
> -	btp->bt_meta_sectorsize = bdev_logical_block_size(btp->bt_bdev);
> -	btp->bt_meta_sectormask = btp->bt_meta_sectorsize - 1;
> -
> -	error = xfs_init_buftarg(btp, btp->bt_meta_sectorsize,
> +	error = xfs_init_buftarg(btp, bdev_logical_block_size(btp->bt_bdev),
>  				mp->m_super->s_id);
>  	if (error)
>  		goto error_free;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b269e115d9ac..8edfd9ed799e 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -79,19 +79,6 @@ struct xfs_buf_cache {
>  int xfs_buf_cache_init(struct xfs_buf_cache *bch);
>  void xfs_buf_cache_destroy(struct xfs_buf_cache *bch);
>  
> -/*
> - * The xfs_buftarg contains 2 notions of "sector size" -
> - *
> - * 1) The metadata sector size, which is the minimum unit and
> - *    alignment of IO which will be performed by metadata operations.
> - * 2) The device logical sector size
> - *
> - * The first is specified at mkfs time, and is stored on-disk in the
> - * superblock's sb_sectsize.
> - *
> - * The latter is derived from the underlying device, and controls direct IO
> - * alignment constraints.
> - */
>  struct xfs_buftarg {
>  	dev_t			bt_dev;
>  	struct block_device	*bt_bdev;
> @@ -99,8 +86,6 @@ struct xfs_buftarg {
>  	struct file		*bt_file;
>  	u64			bt_dax_part_off;
>  	struct xfs_mount	*bt_mount;
> -	unsigned int		bt_meta_sectorsize;
> -	size_t			bt_meta_sectormask;
>  	size_t			bt_logical_sectorsize;
>  	size_t			bt_logical_sectormask;
>  
> diff --git a/fs/xfs/xfs_buf_mem.c b/fs/xfs/xfs_buf_mem.c
> index dcbfa274e06d..46f527750d34 100644
> --- a/fs/xfs/xfs_buf_mem.c
> +++ b/fs/xfs/xfs_buf_mem.c
> @@ -90,8 +90,6 @@ xmbuf_alloc(
>  	btp->bt_dev = (dev_t)-1U;
>  	btp->bt_bdev = NULL; /* in-memory buftargs have no bdev */
>  	btp->bt_file = file;
> -	btp->bt_meta_sectorsize = XMBUF_BLOCKSIZE;
> -	btp->bt_meta_sectormask = XMBUF_BLOCKSIZE - 1;
>  
>  	error = xfs_init_buftarg(btp, XMBUF_BLOCKSIZE, descr);
>  	if (error)
> -- 
> 2.47.2
> 
> 
