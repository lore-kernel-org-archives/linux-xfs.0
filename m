Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0842E7F47F
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404760; cv=none; b=o9nhx6lvl/JGj80zCYRJejkuwcdiRKkpl3XupPJYftReyEgtH2fNY5LY/6Zbr3Lezj8ecDizpErYFyPRjTcD81MMim8P3/co4/h8sAvUWtk8raLuob0kRhS1FzXK4h85FUsy8q5H7aQzbJgrOukLb6Fb4IH61fJhsrurdu/bxiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404760; c=relaxed/simple;
	bh=s/46qo4n9hzQzb2yGu3i9NqB2OzqSDLwe+IJGoSrZ38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YxyV5Mlr7B8R3B99W0iChkyJG4gSPsZ+VdF6JRgf/R8cMC9HKsKHyb6mrNLpn9s1kex/+9vEPiQLWK2EyEtgsNWVMxocb3goBdeqSpK6VT9CoXFuAwzdw0dNXBkAL8DRal6Enrna+w3mZw1x9kTGMyY9tfLWNJa7Im4TOtGYPtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPg6T7if; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPg6T7if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67BEC113CD;
	Mon, 29 Apr 2024 15:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714404759;
	bh=s/46qo4n9hzQzb2yGu3i9NqB2OzqSDLwe+IJGoSrZ38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lPg6T7ifbi9mcZQBXllq30KervHdh5BSH+tZMqjlCucLf3wYTtdFOc/yayH7zavO2
	 SV0UMyja9Dw4p31p81sE4MXGjvekAwEqiXMsJRGqe0hLU6ThfqKhO/Ma+cas7NWVAH
	 SqDFbOeScgC3Kn4WHrqCAFnDwME6LEIj29w6f1mmA8ppGMLZMGJJonx1Hh6JL26qlL
	 P4M06/WOd1/pQYT4gy3lQ1d3BlvVBZan8aKMQOOsQhOFKdnOlhQA7dpv8Po7i9P8eD
	 3Shaw5Q4lwGwou+I9PtpR1wUxGDGm8wjbTMyTtQyPnQOZGruz4x5tsfTh6J9lwT5yj
	 bvA8bBQWFdpOg==
Date: Mon, 29 Apr 2024 08:32:39 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: simplify iext overflow checking and upgrade
Message-ID: <20240429153239.GY360919@frogsfrogsfrogs>
References: <20240429044917.1504566-1-hch@lst.de>
 <20240429044917.1504566-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429044917.1504566-6-hch@lst.de>

On Mon, Apr 29, 2024 at 06:49:14AM +0200, Christoph Hellwig wrote:
> Currently the calls to xfs_iext_count_may_overflow and
> xfs_iext_count_upgrade are always paired.  Merge them into a single
> function to simplify the callers and the actual check and upgrade
> logic itself.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Much cleaner; I wish I could remember why we did it this way in the
first place...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c       |  5 +--
>  fs/xfs/libxfs/xfs_bmap.c       |  5 +--
>  fs/xfs/libxfs/xfs_inode_fork.c | 57 +++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_inode_fork.h |  6 ++--
>  fs/xfs/xfs_bmap_item.c         |  4 +--
>  fs/xfs/xfs_bmap_util.c         | 24 +++-----------
>  fs/xfs/xfs_dquot.c             |  5 +--
>  fs/xfs/xfs_iomap.c             |  9 ++----
>  fs/xfs/xfs_reflink.c           |  9 ++----
>  fs/xfs/xfs_rtalloc.c           |  5 +--
>  10 files changed, 41 insertions(+), 88 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 1c2a27fce08a9d..ded92ccefe9f6d 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1050,11 +1050,8 @@ xfs_attr_set(
>  		return error;
>  
>  	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
> -		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> +		error = xfs_iext_count_ensure(args->trans, dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> -		if (error == -EFBIG)
> -			error = xfs_iext_count_upgrade(args->trans, dp,
> -					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>  		if (error)
>  			goto out_trans_cancel;
>  	}
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 68e80e8eaaeebe..9a55ce4f1f0d45 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4621,11 +4621,8 @@ xfs_bmapi_convert_delalloc(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, whichfork,
> +	error = xfs_iext_count_ensure(tp, ip, whichfork,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 7d660a9739090a..82e670dd1212c4 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -765,53 +765,46 @@ xfs_ifork_verify_local_attr(
>  	return 0;
>  }
>  
> +/*
> + * Check if the inode fork supports adding nr_to_add more extents.
> + *
> + * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
> + * If we can't upgrade or are already using big counters but still can't fit the
> + * additional extents, return -EFBIG.
> + */
>  int
> -xfs_iext_count_may_overflow(
> +xfs_iext_count_ensure(
> +	struct xfs_trans	*tp,
>  	struct xfs_inode	*ip,
>  	int			whichfork,
> -	int			nr_to_add)
> +	uint			nr_to_add)
>  {
> +	struct xfs_mount	*mp = ip->i_mount;
> +	bool			has_large =
> +		xfs_inode_has_large_extent_counts(ip);
>  	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
> -	uint64_t		max_exts;
>  	uint64_t		nr_exts;
>  
> +	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> +
>  	if (whichfork == XFS_COW_FORK)
>  		return 0;
>  
> -	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
> -				whichfork);
> -
> -	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> -		max_exts = 10;
> -
> +	/* no point in upgrading if if_nextents overflows */
>  	nr_exts = ifp->if_nextents + nr_to_add;
> -	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
> +	if (nr_exts < ifp->if_nextents)
>  		return -EFBIG;
>  
> -	return 0;
> -}
> -
> -/*
> - * Upgrade this inode's extent counter fields to be able to handle a potential
> - * increase in the extent count by nr_to_add.  Normally this is the same
> - * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
> - */
> -int
> -xfs_iext_count_upgrade(
> -	struct xfs_trans	*tp,
> -	struct xfs_inode	*ip,
> -	uint			nr_to_add)
> -{
> -	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
> -
> -	if (!xfs_has_large_extent_counts(ip->i_mount) ||
> -	    xfs_inode_has_large_extent_counts(ip) ||
> -	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
> +	    nr_exts > 10)
>  		return -EFBIG;
>  
> -	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> -
> +	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
> +		if (has_large || !xfs_has_large_extent_counts(mp))
> +			return -EFBIG;
> +		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +	}
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> index bd53eb951b6515..9e1456f5cc2c85 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.h
> +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> @@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
>  
>  int xfs_ifork_verify_local_data(struct xfs_inode *ip);
>  int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
> -int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
> -		int nr_to_add);
> -int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
> -		uint nr_to_add);
> +int xfs_iext_count_ensure(struct xfs_trans *tp, struct xfs_inode *ip,
> +		int whichfork, uint nr_to_add);
>  bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
>  
>  /* returns true if the fork has extents but they are not read in yet. */
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index d27859a684aa69..38067d02ee3ca7 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -524,9 +524,7 @@ xfs_bmap_recover_work(
>  	else
>  		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
>  
> -	error = xfs_iext_count_may_overflow(ip, work->bi_whichfork, iext_delta);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
> +	error = xfs_iext_count_ensure(tp, ip, work->bi_whichfork, iext_delta);
>  	if (error)
>  		goto err_cancel;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index df370d7112dc54..cad3b3e4f1c33e 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -710,11 +710,8 @@ xfs_alloc_file_space(
>  		if (error)
>  			break;
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
> -		if (error == -EFBIG)
> -			error = xfs_iext_count_upgrade(tp, ip,
> -					XFS_IEXT_ADD_NOSPLIT_CNT);
>  		if (error)
>  			goto error;
>  
> @@ -772,10 +769,8 @@ xfs_unmap_extent(
>  	if (error)
>  		return error;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_PUNCH_HOLE_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1051,10 +1046,8 @@ xfs_insert_file_space(
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_PUNCH_HOLE_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -1280,23 +1273,16 @@ xfs_swap_extent_rmap(
>  			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
>  
>  			if (xfs_bmap_is_real_extent(&uirec)) {
> -				error = xfs_iext_count_may_overflow(ip,
> -						XFS_DATA_FORK,
> +				error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  						XFS_IEXT_SWAP_RMAP_CNT);
> -				if (error == -EFBIG)
> -					error = xfs_iext_count_upgrade(tp, ip,
> -							XFS_IEXT_SWAP_RMAP_CNT);
>  				if (error)
>  					goto out;
>  			}
>  
>  			if (xfs_bmap_is_real_extent(&irec)) {
> -				error = xfs_iext_count_may_overflow(tip,
> +				error = xfs_iext_count_ensure(tp, tip,
>  						XFS_DATA_FORK,
>  						XFS_IEXT_SWAP_RMAP_CNT);
> -				if (error == -EFBIG)
> -					error = xfs_iext_count_upgrade(tp, ip,
> -							XFS_IEXT_SWAP_RMAP_CNT);
>  				if (error)
>  					goto out;
>  			}
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 13aba84bd64afb..c2e66d392399dd 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -341,11 +341,8 @@ xfs_dquot_disk_alloc(
>  		goto err_cancel;
>  	}
>  
> -	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
> +	error = xfs_iext_count_ensure(tp, quotip, XFS_DATA_FORK,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, quotip,
> -				XFS_IEXT_ADD_NOSPLIT_CNT);
>  	if (error)
>  		goto err_cancel;
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index c06fca2e751c7c..128ad834ca69b1 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -299,9 +299,7 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
> +	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, nr_exts);
>  	if (error)
>  		goto out_trans_cancel;
>  
> @@ -625,11 +623,8 @@ xfs_iomap_write_unwritten(
>  		if (error)
>  			return error;
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_WRITE_UNWRITTEN_CNT);
> -		if (error == -EFBIG)
> -			error = xfs_iext_count_upgrade(tp, ip,
> -					XFS_IEXT_WRITE_UNWRITTEN_CNT);
>  		if (error)
>  			goto error_on_bmapi_transaction;
>  
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 02cb6c2b257058..af388f2caef304 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -768,11 +768,8 @@ xfs_reflink_end_cow_extent(
>  	del = got;
>  	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  			XFS_IEXT_REFLINK_END_COW_CNT);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip,
> -				XFS_IEXT_REFLINK_END_COW_CNT);
>  	if (error)
>  		goto out_cancel;
>  
> @@ -1272,9 +1269,7 @@ xfs_reflink_remap_extent(
>  	if (dmap_written)
>  		++iext_delta;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
> -	if (error == -EFBIG)
> -		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
> +	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, iext_delta);
>  	if (error)
>  		goto out_cancel;
>  
> diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> index b476a876478d93..37edf4c5ce73ad 100644
> --- a/fs/xfs/xfs_rtalloc.c
> +++ b/fs/xfs/xfs_rtalloc.c
> @@ -695,11 +695,8 @@ xfs_growfs_rt_alloc(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
> -		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> +		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
>  				XFS_IEXT_ADD_NOSPLIT_CNT);
> -		if (error == -EFBIG)
> -			error = xfs_iext_count_upgrade(tp, ip,
> -					XFS_IEXT_ADD_NOSPLIT_CNT);
>  		if (error)
>  			goto out_trans_cancel;
>  
> -- 
> 2.39.2
> 
> 
