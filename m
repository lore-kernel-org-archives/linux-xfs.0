Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7AD76034
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 05:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736744659; cv=none; b=qmPvqLUb8TcGz0BNGhBJsWhssChBKjDZebhCcBplbNgf3L+F+bP0rE5j9tjC99VhE4P7+RUqQm4q0YIsKRdFmIPynWdw8sPfjJvYwwbFEKBkjJIx+67qBm4Z7hqrGmuSiBD/KmFZWOAnp+jX2rifrX4Keu/vaTfv7f0X2hvc5jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736744659; c=relaxed/simple;
	bh=IieP86Hi6ROcu3q9rmpoOhK4hVRp+K1rlTEeXOzLqUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NrJLPbuceQeXfo08DDaBGIgpV2Pf+QnonPaIVzH5HPDBkqF+iguUiN0a3NfNTwTP0ehi3ybMOGDvTzQTPEyhM5UD2tluE4RcqNw0mKj3b+a9oVjY+n6jNNgXrlslkKerIln8vDTkIJ7coeOSr6f+S3ShDYwu11oYQvxOAlZMEKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RduozVNE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RduozVNE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4EEC4CED6;
	Mon, 13 Jan 2025 05:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736744658;
	bh=IieP86Hi6ROcu3q9rmpoOhK4hVRp+K1rlTEeXOzLqUc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RduozVNEJqHCxBu0VUCuQO9GZuqnHS/u8SYGXvGHMtv3ljEKNEvx3wnDJ1hG3qtnH
	 T+zv0pTaKblCBfezuGVOjeg0zu6mO3guUblDLWI7s9Err+A2R5Ng2GDCDPNeH9LUA2
	 pNDqghESXKjAav7y9aD8Wu866h2ES2fweDW7KKKi4jrcPMHqS1v9XPyHmKxRDzs/S3
	 /K/v6wDZJWO28peH0vZFknFOB8cVMPgwCXHzeD1OAp0FViltElRNHLfTOMGWsM19Pp
	 FkBQsfKlaLY5kt5afrFWsuQCAE13y0iSeQr7Y0DzlALqYOUlUehC+QRzUccesPjHXU
	 wIdvlczh0drDA==
Date: Sun, 12 Jan 2025 21:04:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: refactor xfs_fs_statfs
Message-ID: <20250113050417.GS1387004@frogsfrogsfrogs>
References: <20250113043259.2054322-1-hch@lst.de>
 <20250113043259.2054322-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250113043259.2054322-2-hch@lst.de>

On Mon, Jan 13, 2025 at 05:32:59AM +0100, Christoph Hellwig wrote:
> Split out helpers for data, rt data and inode related information, and
> assigning f_bavail once instead of in three places.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good now,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_qm_bhv.c |   1 -
>  fs/xfs/xfs_super.c  | 132 ++++++++++++++++++++++++++------------------
>  2 files changed, 78 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
> index db5b8afd9d1b..37f1230e7584 100644
> --- a/fs/xfs/xfs_qm_bhv.c
> +++ b/fs/xfs/xfs_qm_bhv.c
> @@ -40,7 +40,6 @@ xfs_fill_statvfs_from_dquot(
>  
>  		statp->f_blocks = min(statp->f_blocks, limit);
>  		statp->f_bfree = min(statp->f_bfree, remaining);
> -		statp->f_bavail = min(statp->f_bavail, remaining);
>  	}
>  
>  	limit = dqp->q_ino.softlimit ?
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 20cc00b992a6..809ac6d1813c 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -819,81 +819,105 @@ xfs_fs_sync_fs(
>  	return 0;
>  }
>  
> -STATIC int
> -xfs_fs_statfs(
> -	struct dentry		*dentry,
> -	struct kstatfs		*statp)
> +static xfs_extlen_t
> +xfs_internal_log_size(
> +	struct xfs_mount	*mp)
>  {
> -	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
> -	xfs_sb_t		*sbp = &mp->m_sb;
> -	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
> -	uint64_t		fakeinos, id;
> -	uint64_t		icount;
> -	uint64_t		ifree;
> -	uint64_t		fdblocks;
> -	xfs_extlen_t		lsize;
> -	int64_t			ffree;
> -
> -	/*
> -	 * Expedite background inodegc but don't wait. We do not want to block
> -	 * here waiting hours for a billion extent file to be truncated.
> -	 */
> -	xfs_inodegc_push(mp);
> -
> -	statp->f_type = XFS_SUPER_MAGIC;
> -	statp->f_namelen = MAXNAMELEN - 1;
> -
> -	id = huge_encode_dev(mp->m_ddev_targp->bt_dev);
> -	statp->f_fsid = u64_to_fsid(id);
> +	if (!mp->m_sb.sb_logstart)
> +		return 0;
> +	return mp->m_sb.sb_logblocks;
> +}
>  
> -	icount = percpu_counter_sum(&mp->m_icount);
> -	ifree = percpu_counter_sum(&mp->m_ifree);
> -	fdblocks = percpu_counter_sum(&mp->m_fdblocks);
> +static void
> +xfs_statfs_data(
> +	struct xfs_mount	*mp,
> +	struct kstatfs		*st)
> +{
> +	int64_t			fdblocks =
> +		percpu_counter_sum(&mp->m_fdblocks);
>  
> -	statp->f_bsize = sbp->sb_blocksize;
> -	lsize = sbp->sb_logstart ? sbp->sb_logblocks : 0;
> +	/* make sure st->f_bfree does not underflow */
> +	st->f_bfree = max(0LL, fdblocks - xfs_fdblocks_unavailable(mp));
>  	/*
>  	 * sb_dblocks can change during growfs, but nothing cares about reporting
>  	 * the old or new value during growfs.
>  	 */
> -	statp->f_blocks = sbp->sb_dblocks - lsize;
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
> +	st->f_bfree = xfs_rtbxlen_to_blen(mp,
> +			percpu_counter_sum_positive(&mp->m_frextents));
> +	st->f_blocks = mp->m_sb.sb_rblocks;
> +}
>  
> -	/* make sure statp->f_bfree does not underflow */
> -	statp->f_bfree = max_t(int64_t, 0,
> -				fdblocks - xfs_fdblocks_unavailable(mp));
> -	statp->f_bavail = statp->f_bfree;
> +static void
> +xfs_statfs_inodes(
> +	struct xfs_mount	*mp,
> +	struct kstatfs		*st)
> +{
> +	uint64_t		icount = percpu_counter_sum(&mp->m_icount);
> +	uint64_t		ifree = percpu_counter_sum(&mp->m_ifree);
> +	uint64_t		fakeinos = XFS_FSB_TO_INO(mp, st->f_bfree);
>  
> -	fakeinos = XFS_FSB_TO_INO(mp, statp->f_bfree);
> -	statp->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
> +	st->f_files = min(icount + fakeinos, (uint64_t)XFS_MAXINUMBER);
>  	if (M_IGEO(mp)->maxicount)
> -		statp->f_files = min_t(typeof(statp->f_files),
> -					statp->f_files,
> +		st->f_files = min_t(typeof(st->f_files), st->f_files,
>  					M_IGEO(mp)->maxicount);
>  
>  	/* If sb_icount overshot maxicount, report actual allocation */
> -	statp->f_files = max_t(typeof(statp->f_files),
> -					statp->f_files,
> -					sbp->sb_icount);
> +	st->f_files = max_t(typeof(st->f_files), st->f_files,
> +			mp->m_sb.sb_icount);
>  
> -	/* make sure statp->f_ffree does not underflow */
> -	ffree = statp->f_files - (icount - ifree);
> -	statp->f_ffree = max_t(int64_t, ffree, 0);
> +	/* Make sure st->f_ffree does not underflow */
> +	st->f_ffree = max_t(int64_t, 0, st->f_files - (icount - ifree));
> +}
>  
> -	if (XFS_IS_REALTIME_MOUNT(mp) &&
> -	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
> -		s64	freertx;
> +STATIC int
> +xfs_fs_statfs(
> +	struct dentry		*dentry,
> +	struct kstatfs		*st)
> +{
> +	struct xfs_mount	*mp = XFS_M(dentry->d_sb);
> +	struct xfs_inode	*ip = XFS_I(d_inode(dentry));
>  
> -		statp->f_blocks = sbp->sb_rblocks;
> -		freertx = percpu_counter_sum_positive(&mp->m_frextents);
> -		statp->f_bavail = statp->f_bfree =
> -			xfs_rtbxlen_to_blen(mp, freertx);
> -	}
> +	/*
> +	 * Expedite background inodegc but don't wait. We do not want to block
> +	 * here waiting hours for a billion extent file to be truncated.
> +	 */
> +	xfs_inodegc_push(mp);
> +
> +	st->f_type = XFS_SUPER_MAGIC;
> +	st->f_namelen = MAXNAMELEN - 1;
> +	st->f_bsize = mp->m_sb.sb_blocksize;
> +	st->f_fsid = u64_to_fsid(huge_encode_dev(mp->m_ddev_targp->bt_dev));
> +
> +	xfs_statfs_data(mp, st);
> +	xfs_statfs_inodes(mp, st);
> +
> +	if (XFS_IS_REALTIME_MOUNT(mp) &&
> +	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME)))
> +		xfs_statfs_rt(mp, st);
>  
>  	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
>  	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
>  			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
> -		xfs_qm_statvfs(ip, statp);
> +		xfs_qm_statvfs(ip, st);
>  
> +	/*
> +	 * XFS does not distinguish between blocks available to privileged and
> +	 * unprivileged users.
> +	 */
> +	st->f_bavail = st->f_bfree;
>  	return 0;
>  }
>  
> -- 
> 2.45.2
> 
