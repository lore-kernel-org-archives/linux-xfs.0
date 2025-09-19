Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1B24677D
	for <linux-xfs@vger.kernel.org>; Fri, 19 Sep 2025 17:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758304367; cv=none; b=qH+tdGce3La5Uj4CxQ17aq0F3/5Ak/DC/jMz6tQ+jrsa+O6KUuMjnegkZ8dTFMoH1j4S0ccSgjhFzgSNkCj8krfdqch4WM2QcC7pJ0SoghLrtleUcjHzbgZTowrq+MIPkIVwwOev7mi2IIlsaqPAVbPnmvyb+z7+//q9/7Z9de0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758304367; c=relaxed/simple;
	bh=JiikXA/UkLE3ZfexlXAcWPgIeZ3Y8/8YCGn8e/aRzxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WnnWrgtS1MajghbH9gf2uK8xJmfIGG2hRHp5XQJZ7TUeXCJM8TpFSfkFdwIv8IJqQUBFbgm8PHksRVG6O4Bq6G1guQC/ZPaW6GKVv3jnynG2Lxpey7XyuBByudLJKCWd+3KlMpn54mM3LkprXbfcAUmDRIKd1Ftll5fdgzLOinQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UDWX5AsB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UDWX5AsB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B379C4CEF0;
	Fri, 19 Sep 2025 17:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758304367;
	bh=JiikXA/UkLE3ZfexlXAcWPgIeZ3Y8/8YCGn8e/aRzxk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UDWX5AsB8hlFJGQ0/qbWjCqwLTtISIY8Fs0TZ23Nkn4Yh0pR1acXT/jg+5+JBbmpn
	 QCjD341f+XB3Xvz/AEDFmE+Y1BJaWT3fL0p+s2JiQg0rU6cHPWyl5pV+p4XcD/XH6d
	 Qkjf09uZEgduR8w3pC1q5nZzevyjDF+xXBlRKBh2VseKDUt5mxTEW4CLjZYNyowuhA
	 +6idxT8Ehg/8ER5/4UOPQCvNO7J8ZXOXhbLdI3oISnipfN+e+7D5pgvdLVJ15j/WEY
	 77KM49YqTMPcoHGeSo1WXiEuj1oJMcaBY/opMkZoMfBZCsVur5BIQ6N8PzQUZagefZ
	 MgZKPMWaYy5Uw==
Date: Fri, 19 Sep 2025 10:52:46 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: track the number of blocks in each buftarg
Message-ID: <20250919175246.GQ8096@frogsfrogsfrogs>
References: <20250919131222.802840-1-hch@lst.de>
 <20250919131222.802840-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919131222.802840-2-hch@lst.de>

On Fri, Sep 19, 2025 at 06:12:08AM -0700, Christoph Hellwig wrote:
> Add a bt_nr_sectors to track the number of sector in each buftarg, and
> replace the check that hard codes sb_dblock in xfs_buf_map_verify with
> this new value so that it is correct for non-ddev buftargs.  The
> RT buftarg only has a superblock in the first block, so it is unlikely
> to trigger this, or are we likely to ever have enough blocks in the
> in-memory buftargs, but we might as well get the check right.
> 
> Fixes: 10616b806d1d ("xfs: fix _xfs_buf_find oops on blocks beyond the filesystem end")
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks reasonable to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c              | 42 +++++++++++++++++++----------------
>  fs/xfs/xfs_buf.h              |  4 +++-
>  fs/xfs/xfs_buf_item_recover.c | 10 +++++++++
>  fs/xfs/xfs_super.c            |  7 +++---
>  fs/xfs/xfs_trans.c            | 23 ++++++++++---------
>  5 files changed, 52 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index f9ef3b2a332a..2037c88e604a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -387,8 +387,6 @@ xfs_buf_map_verify(
>  	struct xfs_buftarg	*btp,
>  	struct xfs_buf_map	*map)
>  {
> -	xfs_daddr_t		eofs;
> -
>  	/* Check for IOs smaller than the sector size / not sector aligned */
>  	ASSERT(!(BBTOB(map->bm_len) < btp->bt_meta_sectorsize));
>  	ASSERT(!(BBTOB(map->bm_bn) & (xfs_off_t)btp->bt_meta_sectormask));
> @@ -397,11 +395,10 @@ xfs_buf_map_verify(
>  	 * Corrupted block numbers can get through to here, unfortunately, so we
>  	 * have to check that the buffer falls within the filesystem bounds.
>  	 */
> -	eofs = XFS_FSB_TO_BB(btp->bt_mount, btp->bt_mount->m_sb.sb_dblocks);
> -	if (map->bm_bn < 0 || map->bm_bn >= eofs) {
> +	if (map->bm_bn < 0 || map->bm_bn >= btp->bt_nr_sectors) {
>  		xfs_alert(btp->bt_mount,
>  			  "%s: daddr 0x%llx out of range, EOFS 0x%llx",
> -			  __func__, map->bm_bn, eofs);
> +			  __func__, map->bm_bn, btp->bt_nr_sectors);
>  		WARN_ON(1);
>  		return -EFSCORRUPTED;
>  	}
> @@ -1720,26 +1717,30 @@ xfs_configure_buftarg_atomic_writes(
>  int
>  xfs_configure_buftarg(
>  	struct xfs_buftarg	*btp,
> -	unsigned int		sectorsize)
> +	unsigned int		sectorsize,
> +	xfs_rfsblock_t		nr_blocks)
>  {
> -	int			error;
> +	struct xfs_mount	*mp = btp->bt_mount;
>  
> -	ASSERT(btp->bt_bdev != NULL);
> +	if (btp->bt_bdev) {
> +		int		error;
>  
> -	/* Set up metadata sector size info */
> -	btp->bt_meta_sectorsize = sectorsize;
> -	btp->bt_meta_sectormask = sectorsize - 1;
> +		error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
> +		if (error) {
> +			xfs_warn(mp,
> +				"Cannot use blocksize %u on device %pg, err %d",
> +				sectorsize, btp->bt_bdev, error);
> +			return -EINVAL;
> +		}
>  
> -	error = bdev_validate_blocksize(btp->bt_bdev, sectorsize);
> -	if (error) {
> -		xfs_warn(btp->bt_mount,
> -			"Cannot use blocksize %u on device %pg, err %d",
> -			sectorsize, btp->bt_bdev, error);
> -		return -EINVAL;
> +		if (bdev_can_atomic_write(btp->bt_bdev))
> +			xfs_configure_buftarg_atomic_writes(btp);
>  	}
>  
> -	if (bdev_can_atomic_write(btp->bt_bdev))
> -		xfs_configure_buftarg_atomic_writes(btp);
> +	btp->bt_meta_sectorsize = sectorsize;
> +	btp->bt_meta_sectormask = sectorsize - 1;
> +	/* m_blkbb_log is not set up yet */
> +	btp->bt_nr_sectors = nr_blocks << (mp->m_sb.sb_blocklog - BBSHIFT);
>  	return 0;
>  }
>  
> @@ -1749,6 +1750,9 @@ xfs_init_buftarg(
>  	size_t				logical_sectorsize,
>  	const char			*descr)
>  {
> +	/* The maximum size of the buftarg is only known once the sb is read. */
> +	btp->bt_nr_sectors = (xfs_daddr_t)-1;
> +
>  	/* Set up device logical sector size mask */
>  	btp->bt_logical_sectorsize = logical_sectorsize;
>  	btp->bt_logical_sectormask = logical_sectorsize - 1;
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index b269e115d9ac..8fa7bdf59c91 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -103,6 +103,7 @@ struct xfs_buftarg {
>  	size_t			bt_meta_sectormask;
>  	size_t			bt_logical_sectorsize;
>  	size_t			bt_logical_sectormask;
> +	xfs_daddr_t		bt_nr_sectors;
>  
>  	/* LRU control structures */
>  	struct shrinker		*bt_shrinker;
> @@ -372,7 +373,8 @@ struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
>  extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
> -int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize);
> +int xfs_configure_buftarg(struct xfs_buftarg *btp, unsigned int sectorsize,
> +		xfs_fsblock_t nr_blocks);
>  
>  #define xfs_readonly_buftarg(buftarg)	bdev_read_only((buftarg)->bt_bdev)
>  
> diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
> index 5d58e2ae4972..e4c8af873632 100644
> --- a/fs/xfs/xfs_buf_item_recover.c
> +++ b/fs/xfs/xfs_buf_item_recover.c
> @@ -736,6 +736,16 @@ xlog_recover_do_primary_sb_buffer(
>  	 */
>  	xfs_sb_from_disk(&mp->m_sb, dsb);
>  
> +	/*
> +	 * Grow can change the device size.  Mirror that into the buftarg.
> +	 */
> +	mp->m_ddev_targp->bt_nr_sectors =
> +		XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
> +	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp) {
> +		mp->m_rtdev_targp->bt_nr_sectors =
> +			XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
> +	}
> +
>  	if (mp->m_sb.sb_agcount < orig_agcount) {
>  		xfs_alert(mp, "Shrinking AG count in log recovery not supported");
>  		return -EFSCORRUPTED;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 77acb3e5a4ec..9e759c5b1096 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -535,7 +535,8 @@ xfs_setup_devices(
>  {
>  	int			error;
>  
> -	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize);
> +	error = xfs_configure_buftarg(mp->m_ddev_targp, mp->m_sb.sb_sectsize,
> +			mp->m_sb.sb_dblocks);
>  	if (error)
>  		return error;
>  
> @@ -545,7 +546,7 @@ xfs_setup_devices(
>  		if (xfs_has_sector(mp))
>  			log_sector_size = mp->m_sb.sb_logsectsize;
>  		error = xfs_configure_buftarg(mp->m_logdev_targp,
> -					    log_sector_size);
> +				log_sector_size, mp->m_sb.sb_logblocks);
>  		if (error)
>  			return error;
>  	}
> @@ -559,7 +560,7 @@ xfs_setup_devices(
>  		mp->m_rtdev_targp = mp->m_ddev_targp;
>  	} else if (mp->m_rtname) {
>  		error = xfs_configure_buftarg(mp->m_rtdev_targp,
> -					    mp->m_sb.sb_sectsize);
> +				mp->m_sb.sb_sectsize, mp->m_sb.sb_rblocks);
>  		if (error)
>  			return error;
>  	}
> diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> index 575e7028f423..474f5a04ec63 100644
> --- a/fs/xfs/xfs_trans.c
> +++ b/fs/xfs/xfs_trans.c
> @@ -452,19 +452,17 @@ xfs_trans_mod_sb(
>   */
>  STATIC void
>  xfs_trans_apply_sb_deltas(
> -	xfs_trans_t	*tp)
> +	struct xfs_trans	*tp)
>  {
> -	struct xfs_dsb	*sbp;
> -	struct xfs_buf	*bp;
> -	int		whole = 0;
> -
> -	bp = xfs_trans_getsb(tp);
> -	sbp = bp->b_addr;
> +	struct xfs_mount	*mp = tp->t_mountp;
> +	struct xfs_buf		*bp = xfs_trans_getsb(tp);
> +	struct xfs_dsb		*sbp = bp->b_addr;
> +	int			whole = 0;
>  
>  	/*
>  	 * Only update the superblock counters if we are logging them
>  	 */
> -	if (!xfs_has_lazysbcount((tp->t_mountp))) {
> +	if (!xfs_has_lazysbcount(mp)) {
>  		if (tp->t_icount_delta)
>  			be64_add_cpu(&sbp->sb_icount, tp->t_icount_delta);
>  		if (tp->t_ifree_delta)
> @@ -491,8 +489,7 @@ xfs_trans_apply_sb_deltas(
>  	 * write the correct value ondisk.
>  	 */
>  	if ((tp->t_frextents_delta || tp->t_res_frextents_delta) &&
> -	    !xfs_has_rtgroups(tp->t_mountp)) {
> -		struct xfs_mount	*mp = tp->t_mountp;
> +	    !xfs_has_rtgroups(mp)) {
>  		int64_t			rtxdelta;
>  
>  		rtxdelta = tp->t_frextents_delta + tp->t_res_frextents_delta;
> @@ -505,6 +502,8 @@ xfs_trans_apply_sb_deltas(
>  
>  	if (tp->t_dblocks_delta) {
>  		be64_add_cpu(&sbp->sb_dblocks, tp->t_dblocks_delta);
> +		mp->m_ddev_targp->bt_nr_sectors +=
> +			XFS_FSB_TO_BB(mp, tp->t_dblocks_delta);
>  		whole = 1;
>  	}
>  	if (tp->t_agcount_delta) {
> @@ -524,7 +523,7 @@ xfs_trans_apply_sb_deltas(
>  		 * recompute the ondisk rtgroup block log.  The incore values
>  		 * will be recomputed in xfs_trans_unreserve_and_mod_sb.
>  		 */
> -		if (xfs_has_rtgroups(tp->t_mountp)) {
> +		if (xfs_has_rtgroups(mp)) {
>  			sbp->sb_rgblklog = xfs_compute_rgblklog(
>  						be32_to_cpu(sbp->sb_rgextents),
>  						be32_to_cpu(sbp->sb_rextsize));
> @@ -537,6 +536,8 @@ xfs_trans_apply_sb_deltas(
>  	}
>  	if (tp->t_rblocks_delta) {
>  		be64_add_cpu(&sbp->sb_rblocks, tp->t_rblocks_delta);
> +		mp->m_rtdev_targp->bt_nr_sectors +=
> +			XFS_FSB_TO_BB(mp, tp->t_rblocks_delta);
>  		whole = 1;
>  	}
>  	if (tp->t_rextents_delta) {
> -- 
> 2.47.2
> 
> 
