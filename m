Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 02:28:03 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q9RwjM016076
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 02:28:00 -0700
Date: Thu, 26 Jun 2008 05:28:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Introduce xfs_trans_bmap_add_attrfork.
Message-ID: <20080626092856.GA27069@infradead.org>
References: <1214196150-5427-1-git-send-email-xaiki@sgi.com> <1214196150-5427-2-git-send-email-xaiki@sgi.com> <1214196150-5427-3-git-send-email-xaiki@sgi.com> <1214196150-5427-4-git-send-email-xaiki@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214196150-5427-4-git-send-email-xaiki@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

> +int
> +xfs_bmap_add_attrfork(
> +	xfs_inode_t		*ip,		/* incore inode pointer */
> +	int			size,		/* space new attribute needs */
> +	int			rsvd)		/* xact may use reserved blks */
> +{
> +	return xfs_trans_bmap_add_attrfork(NULL, ip, size, rsvd);
> +}

Care to add this below xfs_trans_bmap_add_attrfork?  Also please
us struct xfs_inode instead of the typedef.

> +	if (tpp) {
> +		ASSERT(*tpp);
> +		tp = *tpp;
> +	} else {
> +		tp = xfs_trans_alloc(mp, XFS_TRANS_ADDAFORK);
> +		blks = XFS_ADDAFORK_SPACE_RES(mp);
> +		if (rsvd)
> +			tp->t_flags |= XFS_TRANS_RESERVE;
> +		if ((error = xfs_trans_reserve(tp, blks, XFS_ADDAFORK_LOG_RES(mp), 0,
> +					       XFS_TRANS_PERM_LOG_RES, XFS_ADDAFORK_LOG_COUNT)))
> +			goto error0;
> +		xfs_ilock(ip, XFS_ILOCK_EXCL);
> +		error = XFS_TRANS_RESERVE_QUOTA_NBLKS(mp, tp, ip, blks, 0, rsvd ?
> +						      XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
> +						      XFS_QMOPT_RES_REGBLKS);
> +		if (error) {
> +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +			xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES);
> +			return error;
> +		}
> +		if (XFS_IFORK_Q(ip))
> +			goto error1;
> +		ASSERT(ip->i_d.di_anextents == 0);
> +		VN_HOLD(XFS_ITOV(ip));
> +		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> +		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);

> +	if (tpp) {
> +		error = xfs_trans_roll(&tp, ip);
> +	} else {
> +		error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
> +	}

I think it would be much cleaner if all the transaction setup, joining
etc was done in xfs_bmap_add_attrfork, and xfs_trans_bmap_add_attrfork
just gets an always non-NULL xfs_trans pointer.  That would mean
the common code would become just a helper, and
xfs_trans_bmap_add_attrfork would be a small wrapper including the 
xfs_trans_roll.  Alternatively the caller could always do the roll.

> -	if (XFS_IFORK_Q(ip))
> -		goto error1;
> +	if (tpp) {
> +		error = xfs_trans_roll(&tp, ip);
> +	} else {
> +		error = xfs_trans_commit(tp, XFS_TRANS_PERM_LOG_RES);
> +	}

Why is this check made conditional?

> -	ASSERT(ip->i_d.di_anextents == 0);
> -	VN_HOLD(XFS_ITOV(ip));
> -	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
> -	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
>  	switch (ip->i_d.di_format) {
>  	case XFS_DINODE_FMT_DEV:
>  		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
> @@ -4060,23 +4076,30 @@ xfs_bmap_add_attrfork(
>  			XFS_SB_VERSION_ADDATTR2(&mp->m_sb);
>  			sbfields |= (XFS_SB_VERSIONNUM | XFS_SB_FEATURES2);
>  		}
> -		if (sbfields) {
> -			spin_unlock(&mp->m_sb_lock);
> +		spin_unlock(&mp->m_sb_lock);
> +		if (sbfields)
>  			xfs_mod_sb(tp, sbfields);
> -		} else
> -			spin_unlock(&mp->m_sb_lock);

I don't think this change belongs into this patch.

>  	ASSERT(ip->i_df.if_ext_max ==
>  	       XFS_IFORK_DSIZE(ip) / (uint)sizeof(xfs_bmbt_rec_t));
>  	return error;
>  error2:
> +	if (tpp)
> +		tpp = &tp;
>  	xfs_bmap_cancel(&flist);
>  error1:
>  	ASSERT(ismrlocked(&ip->i_lock,MR_UPDATE));
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	if (tpp)
> +		tpp = &tp;
> +	else
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  error0:
>  	xfs_trans_cancel(tp, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
>  	ASSERT(ip->i_df.if_ext_max ==
> diff --git a/fs/xfs/xfs_bmap.h b/fs/xfs/xfs_bmap.h
> index 87224b7..7a21e41 100644
> --- a/fs/xfs/xfs_bmap.h
> +++ b/fs/xfs/xfs_bmap.h
> @@ -166,6 +166,13 @@ xfs_bmap_add_attrfork(
>  	int			size,	/* space needed for new attribute */
>  	int			rsvd);	/* flag for reserved block allocation */
>  
> +int					/* error code */
> +xfs_trans_bmap_add_attrfork(
> +	struct xfs_trans	**tpp,   /* transaction */
> +	struct xfs_inode	*ip,	/* incore inode pointer */
> +	int			size,	/* space needed for new attribute */
> +	int			rsvd);	/* flag for reserved block allocation */
> +
>  /*
>   * Add the extent to the list of extents to be free at transaction end.
>   * The list is maintained sorted (by block number).
> -- 
> 1.5.5.4
> 
> 
---end quoted text---
