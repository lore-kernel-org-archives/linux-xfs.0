Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785C61BE251
	for <linux-xfs@vger.kernel.org>; Thu, 12 Dec 2024 21:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734038641; cv=none; b=tzlpQAIeOmu2/ue1fFwelQEQqQt+Ryt9oYcROHYsPRgZJxrNn4ae9Zdw+mFQ/nIDAWz8tBMfOXe968Ald1kFq8EbvBC6hZdaT+ogOB156dTcmjymMovX75rH9Vm9QJIqPWd/9pfNdvyBhuDaor3qZNWsdoRU0GUovkIAGCcUe/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734038641; c=relaxed/simple;
	bh=mOClCUw7u7fgO0IRhqT3oerITItfnBEvJyX1vFxggaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nLZMU7/rSDX52EEP60nCuvd/NLQI4F9tLrG7o7rrt2ZQrHB897oaeapQIX+U4MrnNsD+7d6s3v8oUxdsnWVujpA30PowHkzyxJ8QQsj4cq9s3ffsWncI84fr8XYjqA0fJsiIxjZVKulO/th9QFk89ohFiNDSeYNRMWzflAPlt+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKkY6glj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKkY6glj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED234C4CECE;
	Thu, 12 Dec 2024 21:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734038641;
	bh=mOClCUw7u7fgO0IRhqT3oerITItfnBEvJyX1vFxggaw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WKkY6gljhtf+fwuAnP/I9RfSUDrXBfh2VDvzer0Apsh4W1cAreQRVrDWPYV2+wuvC
	 baIyM9EqOHLJ7g7WygJycuzqpPdSHysphOYiK8XY/QlM6AlYclw1lfWep+d8GkXdbg
	 pdIKmnwNT3WcBFpyK4C/oHRoBhsv4rQcEixNq3lcaDyuUv/Bcm2w9F5H/iyUUyFqBp
	 v5WFRo4xv7jITW1jze0XntbiLLR1352u4g7zXsj9JDF8c4WWtEOQOaU8KkWKaVp+ur
	 BQGZs35+7niUi/9vuA8O1XJUEoE2R3I+ypr1+7OUKLTpCNySgJGk8jpK+pA33hzNEX
	 xMOu01A8NrEHg==
Date: Thu, 12 Dec 2024 13:24:00 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/43] xfs: refactor xfs_fs_statfs
Message-ID: <20241212212400.GR6678@frogsfrogsfrogs>
References: <20241211085636.1380516-1-hch@lst.de>
 <20241211085636.1380516-7-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241211085636.1380516-7-hch@lst.de>

On Wed, Dec 11, 2024 at 09:54:31AM +0100, Christoph Hellwig wrote:
> Split out helper for data, rt data and inode related informations,
> and assing f_bavail once instead of in three places.

      ^^^^^^ word choice

("assigning"?)

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_qm_bhv.c |   2 +-
>  fs/xfs/xfs_super.c  | 128 ++++++++++++++++++++++++++------------------
>  2 files changed, 78 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index 847ba29630e9..6d5de3fa58e8 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -34,7 +34,7 @@ xfs_fill_statvfs_from_dquot(
>  		blkres->hardlimit;
>  	if (limit && statp->f_blocks > limit) {
>  		statp->f_blocks = limit;
> -		statp->f_bfree = statp->f_bavail =
> +		statp->f_bfree =
>  			(statp->f_blocks > blkres->reserved) ?
>  			 (statp->f_blocks - blkres->reserved) : 0;
>  	}
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bfa8cc927009..a74a0cc1f6f6 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -819,20 +819,74 @@ xfs_fs_sync_fs(
>  	return 0;
>  }
>  
> +static xfs_extlen_t
> +xfs_internal_log_size(
> +	struct xfs_mount	*mp)
> +{
> +	if (!mp->m_sb.sb_logstart)
> +		return 0;
> +	return mp->m_sb.sb_logblocks;
> +}
> +
> +static void
> +xfs_statfs_data(
> +	struct xfs_mount	*mp,
> +	struct kstatfs		*st)
> +{
> +	int64_t			fdblocks =
> +		percpu_counter_sum(&mp->m_fdblocks);
> +
> +	/* make sure st->f_bfree does not underflow */
> +	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
> +	st->f_blocks = mp->m_sb.sb_dblocks - xfs_internal_log_size(mp);
> +}
> +
> +/*
> + * When stat(v)fs is called on a file with the realtime bit set or a directory
> + * with the rtinherit bit, report freespace information for the RT device
> + * instead of the main data device.
> + */
> +static void
> +xfs_statfs_rt(
> +	struct xfs_mount	*mp,
> +	struct kstatfs		*st)
> +{
> +	int64_t			freertx =
> +		percpu_counter_sum_positive(&mp->m_frextents);
> +
> +	st->f_bfree = xfs_rtbxlen_to_blen(mp, freertx);
> +	st->f_blocks = mp->m_sb.sb_rblocks;
> +}
> +
> +static void
> +xfs_statfs_inodes(
> +	struct xfs_mount	*mp,
> +	struct kstatfs		*st)
> +{
> +	uint64_t		icount = percpu_counter_sum(&mp->m_icount);
> +	uint64_t		ifree = percpu_counter_sum(&mp->m_ifree);
> +	uint64_t		fakeinos = XFS_FSB_TO_INO(mp, st->f_bfree);
> +
> +	st->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
> +	if (M_IGEO(mp)->maxicount)
> +		st->f_files = min_t(typeof(st->f_files), st->f_files,
> +					M_IGEO(mp)->maxicount);
> +
> +	/* If sb_icount overshot maxicount, report actual allocation */
> +	st->f_files = max_t(typeof(st->f_files), st->f_files,
> +			mp->m_sb.sb_icount);
> +
> +	/* Make sure st->f_ffree does not underflow */
> +	st->f_ffree = max_t(int64_t, 0, st->f_files - (icount - ifree));
> +}
> +
>  STATIC int
>  xfs_fs_statfs(
>  	struct dentry		*dentry,
> -	struct kstatfs		*statp)
> +	struct kstatfs		*st)
>  {
>  	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
> -	xfs_sb_t		*sbp = &mp->m_sb;
>  	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> -	uint64_t		fakeinos, id;
> -	uint64_t		icount;
> -	uint64_t		ifree;
> -	uint64_t		fdblocks;
> -	xfs_extlen_t		lsize;
> -	int64_t			ffree;
>  
>  	/*
>  	 * Expedite background inodegc but don't wait. We do not want to block
> @@ -840,56 +894,28 @@ xfs_fs_statfs(
>  	 */
>  	xfs_inodegc_push(mp);
>  
> -	statp->f_type = XFS_SUPER_MAGIC;
> -	statp->f_namelen = MAXNAMELEN - 1;
> -
> -	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
> -	statp->f_fsid = u64_to_fsid(id);
> -
> -	icount = percpu_counter_sum(&mp->m_icount);
> -	ifree = percpu_counter_sum(&mp->m_ifree);
> -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> -
> -	statp->f_bsize = sbp->sb_blocksize;
> -	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
> -	statp->f_blocks = sbp->sb_dblocks - lsize;
> -
> -	/* make sure statp->f_bfree does not underflow */
> -	statp->f_bfree = max_t(int64_t, 0,
> -				fdblocks - xfs_fdblocks_unavailable(mp));
> -	statp->f_bavail = statp->f_bfree;
> -
> -	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> -	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
> -	if (M_IGEO(mp)->maxicount)
> -		statp->f_files = min_t(typeof(statp->f_files),
> -					statp->f_files,
> -					M_IGEO(mp)->maxicount);
> -
> -	/* If sb_icount overshot maxicount, report actual allocation */
> -	statp->f_files = max_t(typeof(statp->f_files),
> -					statp->f_files,
> -					sbp->sb_icount);
> -
> -	/* make sure statp->f_ffree does not underflow */
> -	ffree = statp->f_files - (icount - ifree);
> -	statp->f_ffree = max_t(int64_t, ffree, 0);
> +	st->f_type = XFS_SUPER_MAGIC;
> +	st->f_namelen = MAXNAMELEN - 1;
> +	st->f_bsize = mp->m_sb.sb_blocksize;
> +	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev));
> +		

Whitespace ^^^ damage here.

> +	xfs_statfs_data(mp, st);
> +	xfs_statfs_inodes(mp, st);
>  
>  	if (XFS_IS_REALTIME_MOUNT(mp) &&
> -	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
> -		s64	freertx;
> -
> -		statp->f_blocks = sbp->sb_rblocks;
> -		freertx = percpu_counter_sum_positive(&mp->m_frextents);
> -		statp->f_bavail = statp->f_bfree =
> -			xfs_rtbxlen_to_blen(mp, freertx);
> -	}
> +	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME)))
> +		xfs_statfs_rt(mp, st);
>  
>  	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
>  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
>  			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
> -		xfs_qm_statvfs(ip, statp);
> +		xfs_qm_statvfs(ip, st);

Nice cleanup of all of that.

> +	/*
> +	 * XFS does not distinguish between blocks available to privileged and
> +	 * unprivileged users.
> +	 */
> +	st->f_bavail = st->f_bfree;

Not relevant to this patch, but I noticed that (a) the statfs manpage
now tells me to go look at statvfs, and (b) statvfs advertises a
f_favail field that nobody in the kernel actually sets.

--D

>  	return 0;
>  }
>  
> -- 
> 2.45.2
> 
> 
