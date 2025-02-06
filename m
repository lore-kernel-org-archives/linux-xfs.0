Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBD81F5430
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 21:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738877384; cv=none; b=jw4FvJ2XvcEjuwWmmzeP3jTxJjBeEIBTgqAiQ9lYhuB5w6Kqsk8w/UO+IOXI72xwf9HIz1AB6/WZS3YbulijDD1EQ0zp0fl53BxkIknJgQkLGdsFAfdf99mEtpU0Gcd9vVoTLW8tJ6HLEbqW3s5FDwlgKgOUhqFhGS8Yw4ULRBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738877384; c=relaxed/simple;
	bh=x/bzCK3f4a4RqzN4bUEvT7TPYoUMKzmSrfHeHnEnHkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DcY9UC/VKPt8OrHbeuNNMQ062i7ARtqr9HW5NOYlyQsY+Ha4SspJhg96Y+1OZDjMewTO3Y67uk3bGR7tHUSkifI8PBQ8JhYkZ36NqUgOj7OfXHB4oREctiK20nv+e0NprpsoMB4Oqp2gzyCzp7UXRQBMP/RoyrbzPp3y/OeWcNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MiGJx6Fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MiGJx6Fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF6EC4CEDD;
	Thu,  6 Feb 2025 21:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738877383;
	bh=x/bzCK3f4a4RqzN4bUEvT7TPYoUMKzmSrfHeHnEnHkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MiGJx6FhqSDyl2i2Y7Hp17hit22akXDuMcbnbiHy2n1OYM6s4orVcnshkbJFvHw04
	 VnVhWjLN4PvtzlKCpsJ9iVitMq6EpNChkkt9Q7H1C66iO8ySVgF1yNaQCnKcyzdQiN
	 Vf0Zty8h38XmliQ9N1PNAGp6hpen6sLMzylS/ciXO20JBUINzLWRleozeExe3v6YCg
	 1Kdge6d6AbJJCJhkgpp68+nh5VfI82RnuRGx/NgIGN01H09jmzBtbuCCu/pnPNB79X
	 WTOfAUH9CY9gzZHcPflI+ikHc2ifCM83LvNK4pcosLBrLAWnqqW0D7IZ+BRpVrUxJw
	 wHHi7SKu0865g==
Date: Thu, 6 Feb 2025 13:29:42 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: generalize the freespace and reserved blocks
 handling
Message-ID: <20250206212942.GT21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206064511.2323878-7-hch@lst.de>

On Thu, Feb 06, 2025 at 07:44:22AM +0100, Christoph Hellwig wrote:
> The main handling of the incore per-cpu freespace counters is already
> handled in xfs_mod_freecounter for both the block and RT extent cases,
> but the actual counter is passed in an special cases.
> 
> Replace both the percpu counters and the resblks counters with arrays,
> so that support reserved RT extents can be supported, which will be
> needed for garbarge collection on zoned devices.
> 
> Use helpers to access the freespace counters everywhere intead of
> poking through the abstraction by using the percpu_count helpers
> directly.  This also switches the flooring of the frextents counter
> to 0 in statfs for the rthinherit case to a manual min_t call to match
> the handling of the fdblocks counter for normal file systems.

It might've been nice to split the m_resblk and the freecounter wrapping
into two smaller patches, but I can also see that it makes sense to do
both together.

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_ialloc.c       |  2 +-
>  fs/xfs/libxfs/xfs_metafile.c     |  2 +-
>  fs/xfs/libxfs/xfs_sb.c           |  8 +--
>  fs/xfs/scrub/fscounters.c        | 13 ++---
>  fs/xfs/scrub/fscounters_repair.c |  4 +-
>  fs/xfs/scrub/newbt.c             |  2 +-
>  fs/xfs/xfs_fsops.c               | 27 +++++-----
>  fs/xfs/xfs_fsops.h               |  3 +-
>  fs/xfs/xfs_icache.c              |  4 +-
>  fs/xfs/xfs_ioctl.c               | 12 ++---
>  fs/xfs/xfs_iomap.c               |  9 ++--
>  fs/xfs/xfs_mount.c               | 60 +++++++++++++---------
>  fs/xfs/xfs_mount.h               | 85 ++++++++++++++++++++++++--------
>  fs/xfs/xfs_rtalloc.c             |  2 +-
>  fs/xfs/xfs_super.c               | 73 +++++++++++++++------------
>  fs/xfs/xfs_trace.h               |  2 +-
>  16 files changed, 192 insertions(+), 116 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index f3a840a425f5..57513ba19d6a 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1927,7 +1927,7 @@ xfs_dialloc(
>  	 * that we can immediately allocate, but then we allow allocation on the
>  	 * second pass if we fail to find an AG with free inodes in it.
>  	 */
> -	if (percpu_counter_read_positive(&mp->m_fdblocks) <
> +	if (xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) <

The names are easier for me to understand now, at least.

Though I wonder if we should've named this XC_FREE_DBLOCKS?

Code changes look ok though.

--D

>  			mp->m_low_space[XFS_LOWSP_1_PCNT]) {
>  		ok_alloc = false;
>  		low_space = true;
> diff --git a/fs/xfs/libxfs/xfs_metafile.c b/fs/xfs/libxfs/xfs_metafile.c
> index 2f5f554a36d4..7625e694eb8d 100644
> --- a/fs/xfs/libxfs/xfs_metafile.c
> +++ b/fs/xfs/libxfs/xfs_metafile.c
> @@ -95,7 +95,7 @@ xfs_metafile_resv_can_cover(
>  	 * There aren't enough blocks left in the inode's reservation, but it
>  	 * isn't critical unless there also isn't enough free space.
>  	 */
> -	return __percpu_counter_compare(&ip->i_mount->m_fdblocks,
> +	return xfs_compare_freecounter(ip->i_mount, XC_FREE_BLOCKS,
>  			rhs - ip->i_delayed_blks, 2048) >= 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 3dc5f5dba162..80e383f64155 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -1265,8 +1265,7 @@ xfs_log_sb(
>  		mp->m_sb.sb_ifree = min_t(uint64_t,
>  				percpu_counter_sum_positive(&mp->m_ifree),
>  				mp->m_sb.sb_icount);
> -		mp->m_sb.sb_fdblocks =
> -				percpu_counter_sum_positive(&mp->m_fdblocks);
> +		mp->m_sb.sb_fdblocks = xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
>  	}
>  
>  	/*
> @@ -1275,9 +1274,10 @@ xfs_log_sb(
>  	 * we handle nearly-lockless reservations, so we must use the _positive
>  	 * variant here to avoid writing out nonsense frextents.
>  	 */
> -	if (xfs_has_rtgroups(mp))
> +	if (xfs_has_rtgroups(mp)) {
>  		mp->m_sb.sb_frextents =
> -				percpu_counter_sum_positive(&mp->m_frextents);
> +			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS);
> +	}
>  
>  	xfs_sb_to_disk(bp->b_addr, &mp->m_sb);
>  	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index ca23cf4db6c5..22cac61172ee 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -350,7 +350,7 @@ xchk_fscount_aggregate_agcounts(
>  	 * The global incore space reservation is taken from the incore
>  	 * counters, so leave that out of the computation.
>  	 */
> -	fsc->fdblocks -= mp->m_resblks_avail;
> +	fsc->fdblocks -= mp->m_resblks[XC_FREE_BLOCKS].avail;
>  
>  	/*
>  	 * Delayed allocation reservations are taken out of the incore counters
> @@ -513,8 +513,8 @@ xchk_fscounters(
>  	/* Snapshot the percpu counters. */
>  	icount = percpu_counter_sum(&mp->m_icount);
>  	ifree = percpu_counter_sum(&mp->m_ifree);
> -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> -	frextents = percpu_counter_sum(&mp->m_frextents);
> +	fdblocks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
> +	frextents = xfs_sum_freecounter_raw(mp, XC_FREE_RTEXTENTS);
>  
>  	/* No negative values, please! */
>  	if (icount < 0 || ifree < 0)
> @@ -589,15 +589,16 @@ xchk_fscounters(
>  			try_again = true;
>  	}
>  
> -	if (!xchk_fscount_within_range(sc, fdblocks, &mp->m_fdblocks,
> -			fsc->fdblocks)) {
> +	if (!xchk_fscount_within_range(sc, fdblocks,
> +			&mp->m_free[XC_FREE_BLOCKS], fsc->fdblocks)) {
>  		if (fsc->frozen)
>  			xchk_set_corrupt(sc);
>  		else
>  			try_again = true;
>  	}
>  
> -	if (!xchk_fscount_within_range(sc, frextents, &mp->m_frextents,
> +	if (!xchk_fscount_within_range(sc, frextents,
> +			&mp->m_free[XC_FREE_RTEXTENTS],
>  			fsc->frextents - fsc->frextents_delayed)) {
>  		if (fsc->frozen)
>  			xchk_set_corrupt(sc);
> diff --git a/fs/xfs/scrub/fscounters_repair.c b/fs/xfs/scrub/fscounters_repair.c
> index cda13447a373..8fb0db78489e 100644
> --- a/fs/xfs/scrub/fscounters_repair.c
> +++ b/fs/xfs/scrub/fscounters_repair.c
> @@ -64,7 +64,7 @@ xrep_fscounters(
>  
>  	percpu_counter_set(&mp->m_icount, fsc->icount);
>  	percpu_counter_set(&mp->m_ifree, fsc->ifree);
> -	percpu_counter_set(&mp->m_fdblocks, fsc->fdblocks);
> +	xfs_set_freecounter(mp, XC_FREE_BLOCKS, fsc->fdblocks);
>  
>  	/*
>  	 * Online repair is only supported on v5 file systems, which require
> @@ -74,7 +74,7 @@ xrep_fscounters(
>  	 * track of the delalloc reservations separately, as they are are
>  	 * subtracted from m_frextents, but not included in sb_frextents.
>  	 */
> -	percpu_counter_set(&mp->m_frextents,
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS,
>  		fsc->frextents - fsc->frextents_delayed);
>  	if (!xfs_has_rtgroups(mp))
>  		mp->m_sb.sb_frextents = fsc->frextents;
> diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
> index ac38f5843090..1588ce971cb8 100644
> --- a/fs/xfs/scrub/newbt.c
> +++ b/fs/xfs/scrub/newbt.c
> @@ -62,7 +62,7 @@ xrep_newbt_estimate_slack(
>  		free = sc->sa.pag->pagf_freeblks;
>  		sz = xfs_ag_block_count(sc->mp, pag_agno(sc->sa.pag));
>  	} else {
> -		free = percpu_counter_sum(&sc->mp->m_fdblocks);
> +		free = xfs_sum_freecounter_raw(sc->mp, XC_FREE_BLOCKS);
>  		sz = sc->mp->m_sb.sb_dblocks;
>  	}
>  
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 455298503d01..73275d7a6ec0 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -366,6 +366,7 @@ xfs_growfs_log(
>  int
>  xfs_reserve_blocks(
>  	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		request)
>  {
>  	int64_t			lcounter, delta;
> @@ -373,6 +374,8 @@ xfs_reserve_blocks(
>  	int64_t			free;
>  	int			error = 0;
>  
> +	ASSERT(ctr < XC_FREE_NR);
> +
>  	/*
>  	 * With per-cpu counters, this becomes an interesting problem. we need
>  	 * to work out if we are freeing or allocation blocks first, then we can
> @@ -391,16 +394,16 @@ xfs_reserve_blocks(
>  	 * counters directly since we shouldn't have any problems unreserving
>  	 * space.
>  	 */
> -	if (mp->m_resblks > request) {
> -		lcounter = mp->m_resblks_avail - request;
> +	if (mp->m_resblks[ctr].total > request) {
> +		lcounter = mp->m_resblks[ctr].avail - request;
>  		if (lcounter > 0) {		/* release unused blocks */
>  			fdblks_delta = lcounter;
> -			mp->m_resblks_avail -= lcounter;
> +			mp->m_resblks[ctr].avail -= lcounter;
>  		}
> -		mp->m_resblks = request;
> +		mp->m_resblks[ctr].total = request;
>  		if (fdblks_delta) {
>  			spin_unlock(&mp->m_sb_lock);
> -			xfs_add_fdblocks(mp, fdblks_delta);
> +			xfs_add_freecounter(mp, ctr, fdblks_delta);
>  			spin_lock(&mp->m_sb_lock);
>  		}
>  
> @@ -409,7 +412,7 @@ xfs_reserve_blocks(
>  
>  	/*
>  	 * If the request is larger than the current reservation, reserve the
> -	 * blocks before we update the reserve counters. Sample m_fdblocks and
> +	 * blocks before we update the reserve counters. Sample m_free and
>  	 * perform a partial reservation if the request exceeds free space.
>  	 *
>  	 * The code below estimates how many blocks it can request from
> @@ -419,10 +422,10 @@ xfs_reserve_blocks(
>  	 * space to fill it because mod_fdblocks will refill an undersized
>  	 * reserve when it can.
>  	 */
> -	free = percpu_counter_sum(&mp->m_fdblocks) -
> -						xfs_fdblocks_unavailable(mp);
> -	delta = request - mp->m_resblks;
> -	mp->m_resblks = request;
> +	free = xfs_sum_freecounter_raw(mp, ctr) -
> +		xfs_freecounter_unavailable(mp, ctr);
> +	delta = request - mp->m_resblks[ctr].total;
> +	mp->m_resblks[ctr].total = request;
>  	if (delta > 0 && free > 0) {
>  		/*
>  		 * We'll either succeed in getting space from the free block
> @@ -436,9 +439,9 @@ xfs_reserve_blocks(
>  		 */
>  		fdblks_delta = min(free, delta);
>  		spin_unlock(&mp->m_sb_lock);
> -		error = xfs_dec_fdblocks(mp, fdblks_delta, 0);
> +		error = xfs_dec_freecounter(mp, ctr, fdblks_delta, 0);
>  		if (!error)
> -			xfs_add_fdblocks(mp, fdblks_delta);
> +			xfs_add_freecounter(mp, ctr, fdblks_delta);
>  		spin_lock(&mp->m_sb_lock);
>  	}
>  out:
> diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
> index 3e2f73bcf831..9d23c361ef56 100644
> --- a/fs/xfs/xfs_fsops.h
> +++ b/fs/xfs/xfs_fsops.h
> @@ -8,7 +8,8 @@
>  
>  int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
>  int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
> -int xfs_reserve_blocks(struct xfs_mount *mp, uint64_t request);
> +int xfs_reserve_blocks(struct xfs_mount *mp, enum xfs_free_counter cnt,
> +		uint64_t request);
>  int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
>  
>  int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 7b6c026d01a1..c9ded501e89b 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -2076,7 +2076,7 @@ xfs_inodegc_want_queue_rt_file(
>  	if (!XFS_IS_REALTIME_INODE(ip))
>  		return false;
>  
> -	if (__percpu_counter_compare(&mp->m_frextents,
> +	if (xfs_compare_freecounter(mp, XC_FREE_RTEXTENTS,
>  				mp->m_low_rtexts[XFS_LOWSP_5_PCNT],
>  				XFS_FDBLOCKS_BATCH) < 0)
>  		return true;
> @@ -2104,7 +2104,7 @@ xfs_inodegc_want_queue_work(
>  	if (items > mp->m_ino_geo.inodes_per_cluster)
>  		return true;
>  
> -	if (__percpu_counter_compare(&mp->m_fdblocks,
> +	if (xfs_compare_freecounter(mp, XC_FREE_BLOCKS,
>  				mp->m_low_space[XFS_LOWSP_5_PCNT],
>  				XFS_FDBLOCKS_BATCH) < 0)
>  		return true;
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index ed85322507dd..e7f2121f5b62 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1131,15 +1131,15 @@ xfs_ioctl_getset_resblocks(
>  		error = mnt_want_write_file(filp);
>  		if (error)
>  			return error;
> -		error = xfs_reserve_blocks(mp, fsop.resblks);
> +		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, fsop.resblks);
>  		mnt_drop_write_file(filp);
>  		if (error)
>  			return error;
>  	}
>  
>  	spin_lock(&mp->m_sb_lock);
> -	fsop.resblks = mp->m_resblks;
> -	fsop.resblks_avail = mp->m_resblks_avail;
> +	fsop.resblks = mp->m_resblks[XC_FREE_BLOCKS].total;
> +	fsop.resblks_avail = mp->m_resblks[XC_FREE_BLOCKS].avail;
>  	spin_unlock(&mp->m_sb_lock);
>  
>  	if (copy_to_user(arg, &fsop, sizeof(fsop)))
> @@ -1155,9 +1155,9 @@ xfs_ioctl_fs_counts(
>  	struct xfs_fsop_counts	out = {
>  		.allocino = percpu_counter_read_positive(&mp->m_icount),
>  		.freeino  = percpu_counter_read_positive(&mp->m_ifree),
> -		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
> -				xfs_fdblocks_unavailable(mp),
> -		.freertx  = percpu_counter_read_positive(&mp->m_frextents),
> +		.freedata = xfs_estimate_freecounter(mp, XC_FREE_BLOCKS) -
> +				xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS),
> +		.freertx  = xfs_estimate_freecounter(mp, XC_FREE_RTEXTENTS),
>  	};
>  
>  	if (copy_to_user(uarg, &out, sizeof(out)))
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9cdfedf3b8e0..a724fc2612e3 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -432,13 +432,14 @@ xfs_quota_calc_throttle(
>  
>  static int64_t
>  xfs_iomap_freesp(
> -	struct percpu_counter	*counter,
> +	struct xfs_mount	*mp,
> +	unsigned int		idx,
>  	uint64_t		low_space[XFS_LOWSP_MAX],
>  	int			*shift)
>  {
>  	int64_t			freesp;
>  
> -	freesp = percpu_counter_read_positive(counter);
> +	freesp = xfs_estimate_freecounter(mp, idx);
>  	if (freesp < low_space[XFS_LOWSP_5_PCNT]) {
>  		*shift = 2;
>  		if (freesp < low_space[XFS_LOWSP_4_PCNT])
> @@ -537,10 +538,10 @@ xfs_iomap_prealloc_size(
>  
>  	if (unlikely(XFS_IS_REALTIME_INODE(ip)))
>  		freesp = xfs_rtbxlen_to_blen(mp,
> -				xfs_iomap_freesp(&mp->m_frextents,
> +				xfs_iomap_freesp(mp, XC_FREE_RTEXTENTS,
>  					mp->m_low_rtexts, &shift));
>  	else
> -		freesp = xfs_iomap_freesp(&mp->m_fdblocks, mp->m_low_space,
> +		freesp = xfs_iomap_freesp(mp, XC_FREE_BLOCKS, mp->m_low_space,
>  				&shift);
>  
>  	/*
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 477c5262cf91..b81a03b3133d 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1056,7 +1056,8 @@ xfs_mountfs(
>  	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
>  	if (!xfs_is_readonly(mp)) {
> -		error = xfs_reserve_blocks(mp, xfs_default_resblks(mp));
> +		error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS,
> +				xfs_default_resblks(mp));
>  		if (error)
>  			xfs_warn(mp,
>  	"Unable to allocate reserve blocks. Continuing without reserve pool.");
> @@ -1176,7 +1177,7 @@ xfs_unmountfs(
>  	 * we only every apply deltas to the superblock and hence the incore
>  	 * value does not matter....
>  	 */
> -	error = xfs_reserve_blocks(mp, 0);
> +	error = xfs_reserve_blocks(mp, XC_FREE_BLOCKS, 0);
>  	if (error)
>  		xfs_warn(mp, "Unable to free reserved block pool. "
>  				"Freespace may not be correct on next mount.");
> @@ -1223,52 +1224,68 @@ xfs_fs_writable(
>  	return true;
>  }
>  
> +/*
> + * Estimate the amount of free space that is not available to userspace and is
> + * not explicitly reserved from the incore fdblocks.  This includes:
> + *
> + * - The minimum number of blocks needed to support splitting a bmap btree
> + * - The blocks currently in use by the freespace btrees because they record
> + *   the actual blocks that will fill per-AG metadata space reservations
> + */
> +uint64_t
> +xfs_freecounter_unavailable(
> +	struct xfs_mount	*mp,
> +	enum xfs_free_counter	ctr)
> +{
> +	if (ctr == XC_FREE_RTEXTENTS)
> +		return 0;
> +	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +}
> +
>  void
>  xfs_add_freecounter(
>  	struct xfs_mount	*mp,
> -	struct percpu_counter	*counter,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		delta)
>  {
> -	bool			has_resv_pool = (counter == &mp->m_fdblocks);
>  	uint64_t		res_used;
>  
>  	/*
>  	 * If the reserve pool is depleted, put blocks back into it first.
>  	 * Most of the time the pool is full.
>  	 */
> -	if (!has_resv_pool || mp->m_resblks == mp->m_resblks_avail) {
> -		percpu_counter_add(counter, delta);
> +	if (likely(mp->m_resblks[ctr].total == mp->m_resblks[ctr].avail)) {
> +		percpu_counter_add(&mp->m_free[ctr], delta);
>  		return;
>  	}
>  
>  	spin_lock(&mp->m_sb_lock);
> -	res_used = mp->m_resblks - mp->m_resblks_avail;
> +	res_used = mp->m_resblks[ctr].total - mp->m_resblks[ctr].avail;
>  	if (res_used > delta) {
> -		mp->m_resblks_avail += delta;
> +		mp->m_resblks[ctr].avail += delta;
>  	} else {
>  		delta -= res_used;
> -		mp->m_resblks_avail = mp->m_resblks;
> -		percpu_counter_add(counter, delta);
> +		mp->m_resblks[ctr].avail = mp->m_resblks[ctr].total;
> +		percpu_counter_add(&mp->m_free[ctr], delta);
>  	}
>  	spin_unlock(&mp->m_sb_lock);
>  }
>  
> +
> +/* Adjust in-core free blocks or RT extents. */
>  int
>  xfs_dec_freecounter(
>  	struct xfs_mount	*mp,
> -	struct percpu_counter	*counter,
> +	enum xfs_free_counter	ctr,
>  	uint64_t		delta,
>  	bool			rsvd)
>  {
> +	struct percpu_counter	*counter = &mp->m_free[ctr];
>  	int64_t			lcounter;
> -	uint64_t		set_aside = 0;
> +	uint64_t		set_aside;
>  	s32			batch;
> -	bool			has_resv_pool;
>  
> -	ASSERT(counter == &mp->m_fdblocks || counter == &mp->m_frextents);
> -	has_resv_pool = (counter == &mp->m_fdblocks);
> -	if (rsvd)
> -		ASSERT(has_resv_pool);
> +	ASSERT(ctr < XC_FREE_NR);
>  
>  	/*
>  	 * Taking blocks away, need to be more accurate the closer we
> @@ -1295,8 +1312,7 @@ xfs_dec_freecounter(
>  	 * problems (i.e. transaction abort, pagecache discards, etc.) than
>  	 * slightly premature -ENOSPC.
>  	 */
> -	if (has_resv_pool)
> -		set_aside = xfs_fdblocks_unavailable(mp);
> +	set_aside = xfs_freecounter_unavailable(mp, ctr);
>  	percpu_counter_add_batch(counter, -((int64_t)delta), batch);
>  	if (__percpu_counter_compare(counter, set_aside,
>  				     XFS_FDBLOCKS_BATCH) >= 0) {
> @@ -1310,12 +1326,12 @@ xfs_dec_freecounter(
>  	 */
>  	spin_lock(&mp->m_sb_lock);
>  	percpu_counter_add(counter, delta);
> -	if (!has_resv_pool || !rsvd)
> +	if (!rsvd)
>  		goto fdblocks_enospc;
>  
> -	lcounter = (long long)mp->m_resblks_avail - delta;
> +	lcounter = (long long)mp->m_resblks[ctr].avail - delta;
>  	if (lcounter >= 0) {
> -		mp->m_resblks_avail = lcounter;
> +		mp->m_resblks[ctr].avail = lcounter;
>  		spin_unlock(&mp->m_sb_lock);
>  		return 0;
>  	}
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index fbed172d6770..300ffefb2abd 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -105,6 +105,19 @@ struct xfs_groups {
>  	uint64_t		blkmask;
>  };
>  
> +enum xfs_free_counter {
> +	/*
> +	 * Number of free blocks on the data device.
> +	 */
> +	XC_FREE_BLOCKS,
> +
> +	/*
> +	 * Number of free RT extents on the RT device.
> +	 */
> +	XC_FREE_RTEXTENTS,
> +	XC_FREE_NR,
> +};
> +
>  /*
>   * The struct xfsmount layout is optimised to separate read-mostly variables
>   * from variables that are frequently modified. We put the read-mostly variables
> @@ -222,8 +235,7 @@ typedef struct xfs_mount {
>  	spinlock_t ____cacheline_aligned m_sb_lock; /* sb counter lock */
>  	struct percpu_counter	m_icount;	/* allocated inodes counter */
>  	struct percpu_counter	m_ifree;	/* free inodes counter */
> -	struct percpu_counter	m_fdblocks;	/* free block counter */
> -	struct percpu_counter	m_frextents;	/* free rt extent counter */
> +	struct percpu_counter	m_free[XC_FREE_NR];
>  
>  	/*
>  	 * Count of data device blocks reserved for delayed allocations,
> @@ -245,9 +257,11 @@ typedef struct xfs_mount {
>  	atomic64_t		m_allocbt_blks;
>  
>  	struct xfs_groups	m_groups[XG_TYPE_MAX];
> -	uint64_t		m_resblks;	/* total reserved blocks */
> -	uint64_t		m_resblks_avail;/* available reserved blocks */
> -	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> +	struct {
> +		uint64_t	total;		/* total reserved blocks */
> +		uint64_t	avail;		/* available reserved blocks */
> +		uint64_t	save;		/* reserved blks @ remount,ro */
> +	} m_resblks[XC_FREE_NR];
>  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
>  	struct dentry		*m_debugfs;	/* debugfs parent */
>  	struct xfs_kobj		m_kobj;
> @@ -646,45 +660,74 @@ extern void	xfs_unmountfs(xfs_mount_t *);
>   */
>  #define XFS_FDBLOCKS_BATCH	1024
>  
> +uint64_t xfs_freecounter_unavailable(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr);
> +
>  /*
> - * Estimate the amount of free space that is not available to userspace and is
> - * not explicitly reserved from the incore fdblocks.  This includes:
> - *
> - * - The minimum number of blocks needed to support splitting a bmap btree
> - * - The blocks currently in use by the freespace btrees because they record
> - *   the actual blocks that will fill per-AG metadata space reservations
> + * Sum up the freecount, but never return negative values.
>   */
> -static inline uint64_t
> -xfs_fdblocks_unavailable(
> -	struct xfs_mount	*mp)
> +static inline s64 xfs_sum_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_sum_positive(&mp->m_free[ctr]);
> +}
> +
> +/*
> + * Same as above, but does return negative values.  Mostly useful for
> + * special cases like repair and tracing.
> + */
> +static inline s64 xfs_sum_freecounter_raw(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_sum(&mp->m_free[ctr]);
> +}
> +
> +/*
> + * This just provides and estimate without the cpu-local updates, use
> + * xfs_sum_freecounter for the exact value.
> + */
> +static inline s64 xfs_estimate_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr)
> +{
> +	return percpu_counter_read_positive(&mp->m_free[ctr]);
> +}
> +
> +static inline int xfs_compare_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr, s64 rhs, s32 batch)
> +{
> +	return __percpu_counter_compare(&mp->m_free[ctr], rhs, batch);
> +}
> +
> +static inline void xfs_set_freecounter(struct xfs_mount *mp,
> +		enum xfs_free_counter ctr, uint64_t val)
>  {
> -	return mp->m_alloc_set_aside + atomic64_read(&mp->m_allocbt_blks);
> +	percpu_counter_set(&mp->m_free[ctr], val);
>  }
>  
> -int xfs_dec_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +int xfs_dec_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
>  		uint64_t delta, bool rsvd);
> -void xfs_add_freecounter(struct xfs_mount *mp, struct percpu_counter *counter,
> +void xfs_add_freecounter(struct xfs_mount *mp, enum xfs_free_counter ctr,
>  		uint64_t delta);
>  
>  static inline int xfs_dec_fdblocks(struct xfs_mount *mp, uint64_t delta,
>  		bool reserved)
>  {
> -	return xfs_dec_freecounter(mp, &mp->m_fdblocks, delta, reserved);
> +	return xfs_dec_freecounter(mp, XC_FREE_BLOCKS, delta, reserved);
>  }
>  
>  static inline void xfs_add_fdblocks(struct xfs_mount *mp, uint64_t delta)
>  {
> -	xfs_add_freecounter(mp, &mp->m_fdblocks, delta);
> +	xfs_add_freecounter(mp, XC_FREE_BLOCKS, delta);
>  }
>  
>  static inline int xfs_dec_frextents(struct xfs_mount *mp, uint64_t delta)
>  {
> -	return xfs_dec_freecounter(mp, &mp->m_frextents, delta, false);
> +	return xfs_dec_freecounter(mp, XC_FREE_RTEXTENTS, delta, false);
>  }
>  
>  static inline void xfs_add_frextents(struct xfs_mount *mp, uint64_t delta)
>  {
> -	xfs_add_freecounter(mp, &mp->m_frextents, delta);
> +	xfs_add_freecounter(mp, XC_FREE_RTEXTENTS, delta);
>  }
>  
>  extern int	xfs_readsb(xfs_mount_t *, int);
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index bc18b694db75..8da2498417f5 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -1519,7 +1519,7 @@ xfs_rtalloc_reinit_frextents(
>  	spin_lock(&mp->m_sb_lock);
>  	mp->m_sb.sb_frextents = val;
>  	spin_unlock(&mp->m_sb_lock);
> -	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index d92d7a07ea89..f0b0d8320c51 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -834,10 +834,12 @@ xfs_statfs_data(
>  	struct kstatfs		*st)
>  {
>  	int64_t			fdblocks =
> -		percpu_counter_sum(&mp->m_fdblocks);
> +		xfs_sum_freecounter(mp, XC_FREE_BLOCKS);
>  
>  	/* make sure st->f_bfree does not underflow */
> -	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
> +	st->f_bfree = max(0LL,
> +		fdblocks - xfs_freecounter_unavailable(mp, XC_FREE_BLOCKS));
> +
>  	/*
>  	 * sb_dblocks can change during growfs, but nothing cares about reporting
>  	 * the old or new value during growfs.
> @@ -856,7 +858,7 @@ xfs_statfs_rt(
>  	struct kstatfs		*st)
>  {
>  	st->f_bfree = xfs_rtbxlen_to_blen(mp,
> -			percpu_counter_sum_positive(&mp->m_frextents));
> +			xfs_sum_freecounter(mp, XC_FREE_RTEXTENTS));
>  	st->f_blocks = mp->m_sb.sb_rblocks;
>  }
>  
> @@ -922,24 +924,32 @@ xfs_fs_statfs(
>  }
>  
>  STATIC void
> -xfs_save_resvblks(struct xfs_mount *mp)
> +xfs_save_resvblks(
> +	struct xfs_mount	*mp)
>  {
> -	mp->m_resblks_save = mp->m_resblks;
> -	xfs_reserve_blocks(mp, 0);
> +	enum xfs_free_counter	i;
> +
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		mp->m_resblks[i].save = mp->m_resblks[i].total;
> +		xfs_reserve_blocks(mp, i, 0);
> +	}
>  }
>  
>  STATIC void
> -xfs_restore_resvblks(struct xfs_mount *mp)
> +xfs_restore_resvblks(
> +	struct xfs_mount	*mp)
>  {
> -	uint64_t resblks;
> +	uint64_t		resblks;
> +	enum xfs_free_counter	i;
>  
> -	if (mp->m_resblks_save) {
> -		resblks = mp->m_resblks_save;
> -		mp->m_resblks_save = 0;
> -	} else
> -		resblks = xfs_default_resblks(mp);
> -
> -	xfs_reserve_blocks(mp, resblks);
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		if (mp->m_resblks[i].save) {
> +			resblks = mp->m_resblks[i].save;
> +			mp->m_resblks[i].save = 0;
> +		} else
> +			resblks = xfs_default_resblks(mp);
> +		xfs_reserve_blocks(mp, i, resblks);
> +	}
>  }
>  
>  /*
> @@ -1065,7 +1075,8 @@ static int
>  xfs_init_percpu_counters(
>  	struct xfs_mount	*mp)
>  {
> -	int		error;
> +	int			error;
> +	enum xfs_free_counter	i;
>  
>  	error = percpu_counter_init(&mp->m_icount, 0, GFP_KERNEL);
>  	if (error)
> @@ -1075,30 +1086,28 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_icount;
>  
> -	error = percpu_counter_init(&mp->m_fdblocks, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_ifree;
> -
>  	error = percpu_counter_init(&mp->m_delalloc_blks, 0, GFP_KERNEL);
>  	if (error)
> -		goto free_fdblocks;
> +		goto free_ifree;
>  
>  	error = percpu_counter_init(&mp->m_delalloc_rtextents, 0, GFP_KERNEL);
>  	if (error)
>  		goto free_delalloc;
>  
> -	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> -	if (error)
> -		goto free_delalloc_rt;
> +	for (i = 0; i < XC_FREE_NR; i++) {
> +		error = percpu_counter_init(&mp->m_free[i], 0, GFP_KERNEL);
> +		if (error)
> +			goto free_freecounters;
> +	}
>  
>  	return 0;
>  
> -free_delalloc_rt:
> +free_freecounters:
> +	while (--i > 0)
> +		percpu_counter_destroy(&mp->m_free[i]);
>  	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  free_delalloc:
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -free_fdblocks:
> -	percpu_counter_destroy(&mp->m_fdblocks);
>  free_ifree:
>  	percpu_counter_destroy(&mp->m_ifree);
>  free_icount:
> @@ -1112,24 +1121,26 @@ xfs_reinit_percpu_counters(
>  {
>  	percpu_counter_set(&mp->m_icount, mp->m_sb.sb_icount);
>  	percpu_counter_set(&mp->m_ifree, mp->m_sb.sb_ifree);
> -	percpu_counter_set(&mp->m_fdblocks, mp->m_sb.sb_fdblocks);
> -	percpu_counter_set(&mp->m_frextents, mp->m_sb.sb_frextents);
> +	xfs_set_freecounter(mp, XC_FREE_BLOCKS, mp->m_sb.sb_fdblocks);
> +	xfs_set_freecounter(mp, XC_FREE_RTEXTENTS, mp->m_sb.sb_frextents);
>  }
>  
>  static void
>  xfs_destroy_percpu_counters(
>  	struct xfs_mount	*mp)
>  {
> +	enum xfs_free_counter	i;
> +
> +	for (i = 0; i < XC_FREE_NR; i++)
> +		percpu_counter_destroy(&mp->m_free[i]);
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
> -	percpu_counter_destroy(&mp->m_fdblocks);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_rtextents) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_rtextents);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -	percpu_counter_destroy(&mp->m_frextents);
>  }
>  
>  static int
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index b29462363b81..7fdcb519cf2f 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -5621,7 +5621,7 @@ DECLARE_EVENT_CLASS(xfs_metafile_resv_class,
>  
>  		__entry->dev = mp->m_super->s_dev;
>  		__entry->ino = ip->i_ino;
> -		__entry->freeblks = percpu_counter_sum(&mp->m_fdblocks);
> +		__entry->freeblks = xfs_sum_freecounter_raw(mp, XC_FREE_BLOCKS);
>  		__entry->reserved = ip->i_delayed_blks;
>  		__entry->asked = ip->i_meta_resv_asked;
>  		__entry->used = ip->i_nblocks;
> -- 
> 2.45.2
> 
> 
