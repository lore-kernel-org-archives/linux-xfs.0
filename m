Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9608D12C523
	for <linux-xfs@vger.kernel.org>; Fri, 23 Feb 2024 17:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708708829; cv=none; b=Bhpcj7qz3YGE/1o+pfmpf7dscX0lhoviD5T38PPni0LMN404iyITNNXOFTzq5V5shoxPRwCHXvFIvcbf7oxfk3ErZn6KE81uvI9oQJ1crvA3OEhFTTZaNlj60JCw5sJUX3nnVBYzzcUG5YvWn3JY1f7MhO1X6G6KPuznKIB0NCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708708829; c=relaxed/simple;
	bh=WU+BCf/3PqoYzcBvBc42V+gMDSqBoYlR9z0XKdWoqXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jVxRhHfbhXHzblDaRkfu2/IMmfW9/N1EMM05M8hiHOEZHO4FvtGucShI3PbaMwLo/FHUUTKtCIqwjPZ5MrMHH7iJyyXwqLLfO24zl21JydH+unGly9V3LUDcXRliS5srFH3AMOCv1lLXPQbp+cxcd5q1HM1vGPXEsN8d0V9rJn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DHTF9VcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DHTF9VcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0848AC433F1;
	Fri, 23 Feb 2024 17:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708708829;
	bh=WU+BCf/3PqoYzcBvBc42V+gMDSqBoYlR9z0XKdWoqXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DHTF9VcJWQYwgx+uCpq90XuxEkHN2JPdraKi+IqokjKabkN8jOhAD9zsOr62Q6Kr1
	 5x00C3zZMO4gJmJzBNQf1Ri75mR8YNLCnF4MT7tsBgZ6FNgsKQEVZfuIFaJ0x6S9Z8
	 mOMEK8AUzfmngfSjDM5buS7EhY/RXoX/EA31Dl6kHmKTdjKvEja/cyhxH2HsldQGHP
	 T422ZAAeNlcPdEZKuGTyWCm2d1AnMIyVYOK/fQf/oulmWGXGWB/PYq458sAx3awmSb
	 /KjqPfrUBDOgMU5Rki2vL3wwzF1mZ22W8/x2SVNc3fxrcQC/qbHlNIbbpLpDE9Qw5S
	 p9EFWZqVNQKWw==
Date: Fri, 23 Feb 2024 09:20:28 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: support RT inodes in xfs_mod_delalloc
Message-ID: <20240223172028.GT616564@frogsfrogsfrogs>
References: <20240223071506.3968029-1-hch@lst.de>
 <20240223071506.3968029-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240223071506.3968029-8-hch@lst.de>

On Fri, Feb 23, 2024 at 08:15:03AM +0100, Christoph Hellwig wrote:
> To prepare for re-enabling delalloc on RT devices, track the data blocks
> (which use the RT device when the inode sits on it) and the indirect
> blocks (which don't) separately to xfs_mod_delalloc, and add a new
> percpu counter to also track the RT delalloc blocks.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  | 12 ++++++------
>  fs/xfs/scrub/fscounters.c |  3 +++
>  fs/xfs/xfs_mount.c        | 16 +++++++++++++---
>  fs/xfs/xfs_mount.h        |  9 ++++++++-
>  fs/xfs/xfs_super.c        | 11 ++++++++++-
>  5 files changed, 40 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 074d833e845af3..d7fda286a4eaa0 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1926,7 +1926,7 @@ xfs_bmap_add_extent_delay_real(
>  	}
>  
>  	if (da_new != da_old)
> -		xfs_mod_delalloc(mp, (int64_t)da_new - da_old);
> +		xfs_mod_delalloc(bma->ip, 0, (int64_t)da_new - da_old);
>  
>  	if (bma->cur) {
>  		da_new += bma->cur->bc_ino.allocated;
> @@ -2622,7 +2622,7 @@ xfs_bmap_add_extent_hole_delay(
>  		/*
>  		 * Nothing to do for disk quota accounting here.
>  		 */
> -		xfs_mod_delalloc(ip->i_mount, (int64_t)newlen - oldlen);
> +		xfs_mod_delalloc(ip, 0, (int64_t)newlen - oldlen);
>  	}
>  }
>  
> @@ -3292,7 +3292,7 @@ xfs_bmap_alloc_account(
>  		 * yet.
>  		 */
>  		if (ap->wasdel) {
> -			xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
> +			xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
>  			return;
>  		}
>  
> @@ -3316,7 +3316,7 @@ xfs_bmap_alloc_account(
>  	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
>  	if (ap->wasdel) {
>  		ap->ip->i_delayed_blks -= ap->length;
> -		xfs_mod_delalloc(ap->ip->i_mount, -(int64_t)ap->length);
> +		xfs_mod_delalloc(ap->ip, -(int64_t)ap->length, 0);
>  		fld = isrt ? XFS_TRANS_DQ_DELRTBCOUNT : XFS_TRANS_DQ_DELBCOUNT;
>  	} else {
>  		fld = isrt ? XFS_TRANS_DQ_RTBCOUNT : XFS_TRANS_DQ_BCOUNT;
> @@ -4041,7 +4041,7 @@ xfs_bmapi_reserve_delalloc(
>  		goto out_unreserve_frextents;
>  
>  	ip->i_delayed_blks += alen;
> -	xfs_mod_delalloc(ip->i_mount, alen + indlen);
> +	xfs_mod_delalloc(ip, alen, indlen);
>  
>  	got->br_startoff = aoff;
>  	got->br_startblock = nullstartblock(indlen);
> @@ -4938,7 +4938,7 @@ xfs_bmap_del_extent_delay(
>  		fdblocks += del->br_blockcount;
>  
>  	xfs_add_fdblocks(mp, fdblocks);
> -	xfs_mod_delalloc(mp, -(int64_t)fdblocks);
> +	xfs_mod_delalloc(ip, -(int64_t)del->br_blockcount, -da_diff);
>  	return error;
>  }
>  
> diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> index 5c6d7244078942..b442e50e81555f 100644
> --- a/fs/xfs/scrub/fscounters.c
> +++ b/fs/xfs/scrub/fscounters.c
> @@ -426,6 +426,9 @@ xchk_fscount_count_frextents(
>  		goto out_unlock;
>  	}
>  
> +	fsc->frextents -=
> +		xfs_rtb_to_rtx(mp, percpu_counter_sum(&mp->m_delalloc_rtblks));

Should m_delalloc_rtblks be measured in rt extents (and not fsblocks)
since a sub-rtx delalloc doesn't make any sense?  As written, here we'd
also have to signal a corruption if (m_delalloc_rtblks % rextsize > 0).

--D

> +
>  out_unlock:
>  	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
>  	return error;
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index 2e06837051d6b0..afc30d3333e8ad 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1388,9 +1388,19 @@ xfs_clear_incompat_log_features(
>  #define XFS_DELALLOC_BATCH	(4096)
>  void
>  xfs_mod_delalloc(
> -	struct xfs_mount	*mp,
> -	int64_t			delta)
> +	struct xfs_inode	*ip,
> +	int64_t			data_delta,
> +	int64_t			ind_delta)
>  {
> -	percpu_counter_add_batch(&mp->m_delalloc_blks, delta,
> +	struct xfs_mount	*mp = ip->i_mount;
> +
> +	if (XFS_IS_REALTIME_INODE(ip)) {
> +		percpu_counter_add_batch(&mp->m_delalloc_rtblks, data_delta,
> +				XFS_DELALLOC_BATCH);
> +		if (!ind_delta)
> +			return;
> +		data_delta = 0;
> +	}
> +	percpu_counter_add_batch(&mp->m_delalloc_blks, data_delta + ind_delta,
>  			XFS_DELALLOC_BATCH);
>  }
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 891a54d57f576d..71c7d06f3210c8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -195,6 +195,12 @@ typedef struct xfs_mount {
>  	 * extents or anything related to the rt device.
>  	 */
>  	struct percpu_counter	m_delalloc_blks;
> +
> +	/*
> +	 * RT version of the above.
> +	 */
> +	struct percpu_counter	m_delalloc_rtblks;
> +
>  	/*
>  	 * Global count of allocation btree blocks in use across all AGs. Only
>  	 * used when perag reservation is enabled. Helps prevent block
> @@ -586,6 +592,7 @@ struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
>  void xfs_force_summary_recalc(struct xfs_mount *mp);
>  int xfs_add_incompat_log_feature(struct xfs_mount *mp, uint32_t feature);
>  bool xfs_clear_incompat_log_features(struct xfs_mount *mp);
> -void xfs_mod_delalloc(struct xfs_mount *mp, int64_t delta);
> +void xfs_mod_delalloc(struct xfs_inode *ip, int64_t data_delta,
> +		int64_t ind_delta);
>  
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index b16828410ec19b..1e21f8b953cf77 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1053,12 +1053,18 @@ xfs_init_percpu_counters(
>  	if (error)
>  		goto free_fdblocks;
>  
> -	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> +	error = percpu_counter_init(&mp->m_delalloc_rtblks, 0, GFP_KERNEL);
>  	if (error)
>  		goto free_delalloc;
>  
> +	error = percpu_counter_init(&mp->m_frextents, 0, GFP_KERNEL);
> +	if (error)
> +		goto free_delalloc_rt;
> +
>  	return 0;
>  
> +free_delalloc_rt:
> +	percpu_counter_destroy(&mp->m_delalloc_rtblks);
>  free_delalloc:
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
>  free_fdblocks:
> @@ -1087,6 +1093,9 @@ xfs_destroy_percpu_counters(
>  	percpu_counter_destroy(&mp->m_icount);
>  	percpu_counter_destroy(&mp->m_ifree);
>  	percpu_counter_destroy(&mp->m_fdblocks);
> +	ASSERT(xfs_is_shutdown(mp) ||
> +	       percpu_counter_sum(&mp->m_delalloc_rtblks) == 0);
> +	percpu_counter_destroy(&mp->m_delalloc_rtblks);
>  	ASSERT(xfs_is_shutdown(mp) ||
>  	       percpu_counter_sum(&mp->m_delalloc_blks) == 0);
>  	percpu_counter_destroy(&mp->m_delalloc_blks);
> -- 
> 2.39.2
> 
> 
