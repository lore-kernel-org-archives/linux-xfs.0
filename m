Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6398C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 03:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85862204EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jan 2021 03:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbhASD5P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Jan 2021 22:57:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:59898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729371AbhASD5L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 18 Jan 2021 22:57:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5AF9204EF
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jan 2021 03:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611028586;
        bh=jiybmUjfgZiQyUdhOI3Nqrj7S+ghEYL8HGLpL2J9WRs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=PcjNo/SpAydZmTovviE7zU1Pi9nAVTUltofRbsbgCYfmDHAOGvZK/RZjZ4ew7SHz4
         bP8uD7zPo3ElJgnNB4RhJPIrJ2y/uIj2LU0jiEEhPLr8ufxHSUJ9qSkAzz+W5rcNHe
         4J2okqHeM16GdDOZoPMaV8m13v8MtCnEsSuLTo5muk0QM7fRkl4i5ihKy3xKKJM/CP
         nZfwQaUQF5d3lNMXAyLSXaIa98RfYURabBMXchpp6P5h9rE82wxvevoxIt95wtyXxB
         yTrWK77g9IeiCG/WWrpj309ibM0eaP/Zwli2beBs8z9LXfvclF03xzXKPi+O/WXjrY
         QiGNUE+63dm1A==
Date:   Mon, 18 Jan 2021 19:56:26 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: flush eof/cowblocks if we can't reserve quota
 for file blocks
Message-ID: <20210119035626.GM3134581@magnolia>
References: <161100791789.88816.10902093186807310995.stgit@magnolia>
 <161100795124.88816.6644776235251695171.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100795124.88816.6644776235251695171.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 18, 2021 at 02:12:31PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If a fs modification (data write, reflink, xattr set, fallocate, etc.)
> is unable to reserve enough quota to handle the modification, try
> clearing whatever space the filesystem might have been hanging onto in
> the hopes of speeding up the filesystem.  The flushing behavior will
> become particularly important when we add deferred inode inactivation
> because that will increase the amount of space that isn't actively tied
> to user data.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_attr.c |   10 +++++--
>  fs/xfs/libxfs/xfs_bmap.c |   10 +++++--
>  fs/xfs/xfs_bmap_util.c   |   22 ++++++++++------
>  fs/xfs/xfs_iomap.c       |   24 ++++++++++++-----
>  fs/xfs/xfs_quota.h       |   15 +++++++----
>  fs/xfs/xfs_reflink.c     |   31 +++++++++++++++-------
>  fs/xfs/xfs_trans_dquot.c |   64 ++++++++++++++++++++++++++++++++++++++--------
>  7 files changed, 129 insertions(+), 47 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index fd8e6418a0d3..49da931d0d19 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -395,6 +395,7 @@ xfs_attr_set(
>  	struct xfs_mount	*mp = dp->i_mount;
>  	struct xfs_trans_res	tres;
>  	bool			rsvd = (args->attr_filter & XFS_ATTR_ROOT);
> +	bool			quota_retry = false;
>  	int			error, local;
>  	unsigned int		total;
>  
> @@ -453,6 +454,7 @@ xfs_attr_set(
>  	 * Root fork attributes can use reserved data blocks for this
>  	 * operation if necessary
>  	 */
> +retry:
>  	error = xfs_trans_alloc(mp, &tres, total, 0,
>  			rsvd ? XFS_TRANS_RESERVE : 0, &args->trans);
>  	if (error)
> @@ -465,10 +467,12 @@ xfs_attr_set(
>  
>  		if (rsvd)
>  			quota_flags |= XFS_QMOPT_FORCE_RES;
> -		error = xfs_trans_reserve_quota_nblks(args->trans, dp,
> -				args->total, 0, quota_flags);
> +		error = xfs_trans_reserve_quota_nblks(&args->trans, dp,
> +				args->total, 0, quota_flags, &quota_retry);
>  		if (error)
> -			goto out_trans_cancel;
> +			return error;
> +		if (quota_retry)
> +			goto retry;
>  
>  		error = xfs_has_attr(args);
>  		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index fa6b442eb75f..1bca18a7381b 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1070,6 +1070,7 @@ xfs_bmap_add_attrfork(
>  	int			blks;		/* space reservation */
>  	int			version = 1;	/* superblock attr version */
>  	int			logflags;	/* logging flags */
> +	bool			quota_retry = false;
>  	int			error;		/* error return value */
>  
>  	ASSERT(XFS_IFORK_Q(ip) == 0);
> @@ -1079,17 +1080,20 @@ xfs_bmap_add_attrfork(
>  
>  	blks = XFS_ADDAFORK_SPACE_RES(mp);
>  
> +retry:
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_addafork, blks, 0,
>  			rsvd ? XFS_TRANS_RESERVE : 0, &tp);
>  	if (error)
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, blks, 0, rsvd ?
> +	error = xfs_trans_reserve_quota_nblks(&tp, ip, blks, 0, rsvd ?
>  			XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
> -			XFS_QMOPT_RES_REGBLKS);
> +			XFS_QMOPT_RES_REGBLKS, &quota_retry);
>  	if (error)
> -		goto trans_cancel;
> +		return error;
> +	if (quota_retry)
> +		goto retry;
>  	if (XFS_IFORK_Q(ip))
>  		goto trans_cancel;
>  
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 671cb104861e..d12c9e9e5c7b 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -761,6 +761,7 @@ xfs_alloc_file_space(
>  	 */
>  	while (allocatesize_fsb && !error) {
>  		xfs_fileoff_t	s, e;
> +		bool		quota_retry = false;
>  
>  		/*
>  		 * Determine space reservations for data/realtime.
> @@ -803,6 +804,7 @@ xfs_alloc_file_space(
>  		/*
>  		 * Allocate and setup the transaction.
>  		 */
> +retry:
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
>  				resrtextents, 0, &tp);
>  
> @@ -817,10 +819,12 @@ xfs_alloc_file_space(
>  			break;
>  		}
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
> -						      0, quota_flag);
> +		error = xfs_trans_reserve_quota_nblks(&tp, ip, qblocks, 0,
> +				quota_flag, &quota_retry);
>  		if (error)
> -			goto error1;
> +			return error;
> +		if (quota_retry)
> +			goto retry;
>  
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> @@ -853,8 +857,6 @@ xfs_alloc_file_space(
>  
>  error0:	/* unlock inode, unreserve quota blocks, cancel trans */
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
> -
> -error1:	/* Just cancel transaction */
>  	xfs_trans_cancel(tp);
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	return error;
> @@ -870,8 +872,10 @@ xfs_unmap_extent(
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_trans	*tp;
>  	uint			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> +	bool			quota_retry = false;
>  	int			error;
>  
> +retry:
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	if (error) {
>  		ASSERT(error == -ENOSPC || XFS_FORCED_SHUTDOWN(mp));
> @@ -879,10 +883,12 @@ xfs_unmap_extent(
>  	}
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -			XFS_QMOPT_RES_REGBLKS);
> +	error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
> +			XFS_QMOPT_RES_REGBLKS, &quota_retry);
>  	if (error)
> -		goto out_trans_cancel;
> +		return error;
> +	if (quota_retry)
> +		goto retry;
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 7b9ff824e82d..d9583f1de2fc 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -27,7 +27,7 @@
>  #include "xfs_dquot_item.h"
>  #include "xfs_dquot.h"
>  #include "xfs_reflink.h"
> -
> +#include "xfs_icache.h"
>  
>  #define XFS_ALLOC_ALIGN(mp, off) \
>  	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
> @@ -197,6 +197,7 @@ xfs_iomap_write_direct(
>  	int			quota_flag;
>  	uint			qblocks, resblks;
>  	unsigned int		resrtextents = 0;
> +	bool			quota_retry = false;
>  	int			error;
>  	int			bmapi_flags = XFS_BMAPI_PREALLOC;
>  	uint			tflags = 0;
> @@ -239,6 +240,7 @@ xfs_iomap_write_direct(
>  			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
>  		}
>  	}
> +retry:
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, resrtextents,
>  			tflags, &tp);
>  	if (error)
> @@ -246,9 +248,12 @@ xfs_iomap_write_direct(
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
>  
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0, quota_flag);
> +	error = xfs_trans_reserve_quota_nblks(&tp, ip, qblocks, 0, quota_flag,
> +			&quota_retry);
>  	if (error)
> -		goto out_trans_cancel;
> +		return error;
> +	if (quota_retry)
> +		goto retry;
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> @@ -286,7 +291,6 @@ xfs_iomap_write_direct(
>  
>  out_res_cancel:
>  	xfs_trans_unreserve_quota_nblks(tp, ip, (long)qblocks, 0, quota_flag);
> -out_trans_cancel:
>  	xfs_trans_cancel(tp);
>  	goto out_unlock;
>  }
> @@ -539,6 +543,8 @@ xfs_iomap_write_unwritten(
>  		return error;
>  
>  	do {
> +		bool	quota_retry = false;
> +
>  		/*
>  		 * Set up a transaction to convert the range of extents
>  		 * from unwritten to real. Do allocations in a loop until
> @@ -548,6 +554,7 @@ xfs_iomap_write_unwritten(
>  		 * here as we might be asked to write out the same inode that we
>  		 * complete here and might deadlock on the iolock.
>  		 */
> +retry:
>  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0,
>  				XFS_TRANS_RESERVE, &tp);
>  		if (error)
> @@ -556,10 +563,13 @@ xfs_iomap_write_unwritten(
>  		xfs_ilock(ip, XFS_ILOCK_EXCL);
>  		xfs_trans_ijoin(tp, ip, 0);
>  
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES);
> +		error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
> +				XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES,
> +				&quota_retry);
>  		if (error)
> -			goto error_on_bmapi_transaction;
> +			return error;
> +		if (quota_retry)
> +			goto retry;
>  
>  		/*
>  		 * Modify the unwritten extent state of the buffer.
> diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
> index 1c37b5be60c3..996046eb1492 100644
> --- a/fs/xfs/xfs_quota.h
> +++ b/fs/xfs/xfs_quota.h
> @@ -81,8 +81,9 @@ extern void xfs_trans_mod_dquot_byino(struct xfs_trans *, struct xfs_inode *,
>  		uint, int64_t);
>  extern void xfs_trans_apply_dquot_deltas(struct xfs_trans *);
>  extern void xfs_trans_unreserve_and_mod_dquots(struct xfs_trans *);
> -extern int xfs_trans_reserve_quota_nblks(struct xfs_trans *,
> -		struct xfs_inode *, int64_t, long, uint);
> +int xfs_trans_reserve_quota_nblks(struct xfs_trans **tpp, struct xfs_inode *ip,
> +		int64_t nblocks, long ninos, unsigned int flags,
> +		bool *retry);
>  extern int xfs_trans_reserve_quota_bydquots(struct xfs_trans *,
>  		struct xfs_mount *, struct xfs_dquot *,
>  		struct xfs_dquot *, struct xfs_dquot *, int64_t, long, uint);
> @@ -128,7 +129,8 @@ xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
>  #define xfs_trans_apply_dquot_deltas(tp)
>  #define xfs_trans_unreserve_and_mod_dquots(tp)
>  static inline int xfs_trans_reserve_quota_nblks(struct xfs_trans *tp,

Oops, forgot to change this to 'struct xfs_trans **tpp'...

--D

> -		struct xfs_inode *ip, int64_t nblks, long ninos, uint flags)
> +		struct xfs_inode *ip, int64_t nblks, long ninos,
> +		unsigned int flags, bool *retry)
>  {
>  	return 0;
>  }
> @@ -170,14 +172,17 @@ static inline int
>  xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
>  		int64_t nblks, long ninos, unsigned int flags)
>  {
> -	return xfs_trans_reserve_quota_nblks(tp, ip, -nblks, -ninos, flags);
> +	return xfs_trans_reserve_quota_nblks(&tp, ip, -nblks, -ninos, flags,
> +			NULL);
>  }
>  
>  static inline int
>  xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks,
>  		unsigned int flags)
>  {
> -	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0, flags);
> +	struct xfs_trans	*tp = NULL;
> +
> +	return xfs_trans_reserve_quota_nblks(&tp, ip, nblks, 0, flags, NULL);
>  }
>  
>  static inline int
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 1f3270ffaea5..8d768c3c4b25 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -351,13 +351,14 @@ xfs_reflink_allocate_cow(
>  	bool			convert_now)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_trans	*tp;
>  	xfs_fileoff_t		offset_fsb = imap->br_startoff;
>  	xfs_filblks_t		count_fsb = imap->br_blockcount;
> -	struct xfs_trans	*tp;
> -	int			nimaps, error = 0;
> -	bool			found;
>  	xfs_filblks_t		resaligned;
>  	xfs_extlen_t		resblks = 0;
> +	bool			found;
> +	bool			quota_retry = false;
> +	int			nimaps, error = 0;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
>  	if (!ip->i_cowfp) {
> @@ -376,6 +377,7 @@ xfs_reflink_allocate_cow(
>  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>  
>  	xfs_iunlock(ip, *lockmode);
> +retry:
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
>  	*lockmode = XFS_ILOCK_EXCL;
>  	xfs_ilock(ip, *lockmode);
> @@ -398,10 +400,15 @@ xfs_reflink_allocate_cow(
>  		goto convert;
>  	}
>  
> -	error = xfs_trans_reserve_quota_nblks(tp, ip, resblks, 0,
> -			XFS_QMOPT_RES_REGBLKS);
> -	if (error)
> -		goto out_trans_cancel;
> +	error = xfs_trans_reserve_quota_nblks(&tp, ip, resblks, 0,
> +			XFS_QMOPT_RES_REGBLKS, &quota_retry);
> +	if (error) {
> +		/* This function must return with the ILOCK held. */
> +		xfs_ilock(ip, *lockmode);
> +		return error;
> +	}
> +	if (quota_retry)
> +		goto retry;
>  
>  	xfs_trans_ijoin(tp, ip, 0);
>  
> @@ -1000,9 +1007,11 @@ xfs_reflink_remap_extent(
>  	unsigned int		resblks;
>  	bool			smap_real;
>  	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
> +	bool			quota_retry = false;
>  	int			nimaps;
>  	int			error;
>  
> +retry:
>  	/* Start a rolling transaction to switch the mappings */
>  	resblks = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks, 0, 0, &tp);
> @@ -1087,10 +1096,12 @@ xfs_reflink_remap_extent(
>  	if (!smap_real && dmap_written)
>  		qres += dmap->br_blockcount;
>  	if (qres > 0) {
> -		error = xfs_trans_reserve_quota_nblks(tp, ip, qres, 0,
> -				XFS_QMOPT_RES_REGBLKS);
> +		error = xfs_trans_reserve_quota_nblks(&tp, ip, qres, 0,
> +				XFS_QMOPT_RES_REGBLKS, &quota_retry);
>  		if (error)
> -			goto out_cancel;
> +			goto out;
> +		if (quota_retry)
> +			goto retry;
>  	}
>  
>  	if (smap_real) {
> diff --git a/fs/xfs/xfs_trans_dquot.c b/fs/xfs/xfs_trans_dquot.c
> index 3315498a6fa1..c6abe1f1106c 100644
> --- a/fs/xfs/xfs_trans_dquot.c
> +++ b/fs/xfs/xfs_trans_dquot.c
> @@ -16,6 +16,7 @@
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
>  #include "xfs_trace.h"
> +#include "xfs_icache.h"
>  
>  STATIC void	xfs_trans_alloc_dqinfo(xfs_trans_t *);
>  
> @@ -770,21 +771,40 @@ xfs_trans_reserve_quota_bydquots(
>  	return error;
>  }
>  
> -
>  /*
> - * Lock the dquot and change the reservation if we can.
> - * This doesn't change the actual usage, just the reservation.
> - * The inode sent in is locked.
> + * Lock the dquot and change the reservation if we can.  This doesn't change
> + * the actual usage, just the reservation.  The caller must hold ILOCK_EXCL on
> + * the inode.  If @retry is not a NULL pointer, the caller must ensure that
> + * *retry is set to false before the first time this function is called.
> + *
> + * If the quota reservation fails because we hit a quota limit (and retry is
> + * not a NULL pointer, and *retry is true), this function will try to invoke
> + * the speculative preallocation gc scanner to reduce quota usage.  In order to
> + * do that, we cancel the transaction, NULL out tpp, and drop the ILOCK.  If we
> + * actually do some freeing work, *retry will be set to true.
> + *
> + * This function ends one of four ways:
> + *  a) if retry is NULL, returns the result of trying to change the quota
> + *     reservation, with *tpp still set and the inode still locked;
> + *  b) returns an error code with *tpp cancelled and set to NULL, and the inode
> + *     unlocked;
> + *  c) returns zero with *tpp cancelled and set to NULL, the inode unlocked,
> + *     and *retry is true, which means we cleared space and the caller should
> + *     try again with a new transaction;
> + *  d) returns zero with *tpp still set, the inode still locked, and *retry
> + *     is false, which means the reservation succeeded.
>   */
>  int
>  xfs_trans_reserve_quota_nblks(
> -	struct xfs_trans	*tp,
> +	struct xfs_trans	**tpp,
>  	struct xfs_inode	*ip,
>  	int64_t			nblks,
>  	long			ninos,
> -	uint			flags)
> +	unsigned int		flags,
> +	bool			*retry)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> +	int			error, err2;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return 0;
> @@ -795,13 +815,35 @@ xfs_trans_reserve_quota_nblks(
>  	ASSERT((flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_RTBLKS ||
>  	       (flags & ~(XFS_QMOPT_FORCE_RES)) == XFS_TRANS_DQ_RES_BLKS);
>  
> +	/* Reserve nblks against these dquots, with trans as the mediator. */
> +	error = xfs_trans_reserve_quota_bydquots(*tpp, mp, ip->i_udquot,
> +			ip->i_gdquot, ip->i_pdquot, nblks, ninos, flags);
> +
> +	/* Exit immediately if the caller did not want retries. */
> +	if (retry == NULL)
> +		return error;
> +
>  	/*
> -	 * Reserve nblks against these dquots, with trans as the mediator.
> +	 * If the caller /can/ handle retries, we always cancel the transaction
> +	 * on error, even if we aren't going to attempt a gc scan.
>  	 */
> -	return xfs_trans_reserve_quota_bydquots(tp, mp,
> -						ip->i_udquot, ip->i_gdquot,
> -						ip->i_pdquot,
> -						nblks, ninos, flags);
> +	if (error) {
> +		xfs_trans_cancel(*tpp);
> +		*tpp = NULL;
> +		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +	}
> +
> +	/* We only allow one retry for EDQUOT/ENOSPC. */
> +	if (*retry || (error != -EDQUOT && error != -ENOSPC)) {
> +		*retry = false;
> +		return error;
> +	}
> +
> +	/* Try to free some quota for this file's dquots. */
> +	err2 = xfs_blockgc_free_quota(ip, 0, retry);
> +	if (err2)
> +		return err2;
> +	return *retry ? 0 : error;
>  }
>  
>  /* Change the quota reservations for an inode creation activity. */
> 
