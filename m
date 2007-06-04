Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 04 Jun 2007 02:41:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l549fTWt019011
	for <xfs@oss.sgi.com>; Mon, 4 Jun 2007 02:41:30 -0700
Date: Mon, 04 Jun 2007 19:41:19 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
Message-ID: <E4C7CA19461547A0919B23A2@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070604045219.GG86004887@sgi.com>
References: <20070604045219.GG86004887@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Hi Dave,

As an aside,
I don't understand the following bit of code in xfs_reserve_blocks():
        /*
         * If our previous reservation was larger than the current value,
         * then move any unused blocks back to the free pool.
         */
        fdblks_delta = 0;
        if (mp->m_resblks > request) {
                lcounter = mp->m_resblks_avail - request;
                if (lcounter  > 0) {            /* release unused blocks */
                        fdblks_delta = lcounter;
                        mp->m_resblks_avail -= lcounter;
                }

I can't see why it is not calculating a delta for:
  delta = m_resblks - request
and using that to update the m_resblks_avail and fdblks_delta;
like we do in the case below where the request is the larger one.
Instead it is affectively doing:
m_resblks_avail = m_resblks_avail - m_resblks_avail + request
                = request
It looks wrong to me.
What am I missing?
And why doesn't sb_fdblocks need to be updated in this case.

Thanks,
--Tim

--On 4 June 2007 2:52:19 PM +1000 David Chinner <dgc@sgi.com> wrote:

>
> During delayed allocation extent conversion or unwritten extent
> conversion, we need to reserve some blocks for transactions
> reservations. We need to reserve these blocks in case a btree
> split occurs and we need to allocate some blocks.
>
> Unfortunately, we've only ever reserved the number of data blocks we
> are allocating, so in both the unwritten and delalloc case we can
> get ENOSPC to the transaction reservation. This is bad because in
> both cases we cannot report the failure to the writing application.
>
> The fix is two-fold:
>
> 	1 - leverage the reserved block infrastructure XFS already
> 	has to reserve a small pool of blocks by default to allow
> 	specially marked transactions to dip into when we are at
> 	ENOSPC.
>
> 	    Default setting is min(5%, 1024 blocks).
>
> 	2 - convert critical transaction reservations to be allowed
> 	to dip into this pool. Spots changed are delalloc
> 	conversion, unwritten extent conversion and growing a
> 	filesystem at ENOSPC.
>
> Comments?
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> Principal Engineer
> SGI Australian Software Group
>
> ---
>  fs/xfs/xfs_fsops.c |   10 +++++++---
>  fs/xfs/xfs_iomap.c |   22 ++++++++--------------
>  fs/xfs/xfs_mount.c |   37 +++++++++++++++++++++++++++++++++++--
>  3 files changed, 50 insertions(+), 19 deletions(-)
>
> Index: 2.6.x-xfs-new/fs/xfs/xfs_fsops.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_fsops.c	2007-05-11 10:35:29.288847149 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_fsops.c	2007-05-11 11:13:34.195363437 +1000
> @@ -179,6 +179,7 @@ xfs_growfs_data_private(
>  		up_write(&mp->m_peraglock);
>  	}
>  	tp = xfs_trans_alloc(mp, XFS_TRANS_GROWFS);
> +	tp->t_flags |= XFS_TRANS_RESERVE;
>  	if ((error = xfs_trans_reserve(tp, XFS_GROWFS_SPACE_RES(mp),
>  			XFS_GROWDATA_LOG_RES(mp), 0, 0, 0))) {
>  		xfs_trans_cancel(tp, 0);
> @@ -500,8 +501,9 @@ xfs_reserve_blocks(
>  	unsigned long		s;
>
>  	/* If inval is null, report current values and return */
> -
>  	if (inval == (__uint64_t *)NULL) {
> +		if (!outval)
> +			return EINVAL;
>  		outval->resblks = mp->m_resblks;
>  		outval->resblks_avail = mp->m_resblks_avail;
>  		return 0;
> @@ -564,8 +566,10 @@ retry:
>  		}
>  	}
>  out:
> -	outval->resblks = mp->m_resblks;
> -	outval->resblks_avail = mp->m_resblks_avail;
> +	if (outval) {
> +		outval->resblks = mp->m_resblks;
> +		outval->resblks_avail = mp->m_resblks_avail;
> +	}
>  	XFS_SB_UNLOCK(mp, s);
>
>  	if (fdblks_delta) {
> Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-05-11 10:35:29.292846630 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-05-11 11:13:47.229662318 +1000
> @@ -718,7 +718,7 @@ xfs_mountfs(
>  	bhv_vnode_t	*rvp = NULL;
>  	int		readio_log, writeio_log;
>  	xfs_daddr_t	d;
> -	__uint64_t	ret64;
> +	__uint64_t	resblks;
>  	__int64_t	update_flags;
>  	uint		quotamount, quotaflags;
>  	int		agno;
> @@ -835,6 +835,7 @@ xfs_mountfs(
>  	 */
>  	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
>  	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
> +		__uint64_t	ret64;
>  		if (xfs_uuid_mount(mp)) {
>  			error = XFS_ERROR(EINVAL);
>  			goto error1;
> @@ -1127,13 +1128,27 @@ xfs_mountfs(
>  		goto error4;
>  	}
>
> -
>  	/*
>  	 * Complete the quota initialisation, post-log-replay component.
>  	 */
>  	if ((error = XFS_QM_MOUNT(mp, quotamount, quotaflags, mfsi_flags)))
>  		goto error4;
>
> +	/*
> +	 * Now we are mounted, reserve a small amount of unused space for
> +	 * privileged transactions. This is needed so that transaction
> +	 * space required for critical operations can dip into this pool
> +	 * when at ENOSPC. This is needed for operations like create with
> +	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
> +	 * are not allowed to use this reserved space.
> +	 *
> +	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
> +	 * This may drive us straight to ENOSPC on mount, but that implies
> +	 * we were already there on the last unmount.
> +	 */
> +	resblks = min_t(__uint64_t, mp->m_sb.sb_dblocks / 20, 1024);
> +	xfs_reserve_blocks(mp, &resblks, NULL);
> +
>  	return 0;
>
>   error4:
> @@ -1172,6 +1187,7 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
>  #if defined(DEBUG) || defined(INDUCE_IO_ERROR)
>  	int64_t		fsid;
>  #endif
> +	__uint64_t	resblks;
>
>  	/*
>  	 * We can potentially deadlock here if we have an inode cluster
> @@ -1200,6 +1216,23 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
>  		xfs_binval(mp->m_rtdev_targp);
>  	}
>
> +	/*
> +	 * Unreserve any blocks we have so that when we unmount we don't account
> +	 * the reserved free space as used. This is really only necessary for
> +	 * lazy superblock counting because it trusts the incore superblock
> +	 * counters to be aboslutely correct on clean unmount.
> +	 *
> +	 * We don't bother correcting this elsewhere for lazy superblock
> +	 * counting because on mount of an unclean filesystem we reconstruct the
> +	 * correct counter value and this is irrelevant.
> +	 *
> +	 * For non-lazy counter filesystems, this doesn't matter at all because
> +	 * we only every apply deltas to the superblock and hence the incore
> +	 * value does not matter....
> +	 */
> +	resblks = 0;
> +	xfs_reserve_blocks(mp, &resblks, NULL);
> +
>  	xfs_log_sbcount(mp, 1);
>  	xfs_unmountfs_writesb(mp);
>  	xfs_unmountfs_wait(mp); 		/* wait for async bufs */
> Index: 2.6.x-xfs-new/fs/xfs/xfs_iomap.c
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/xfs_iomap.c	2007-05-11 11:13:13.862017149 +1000
> +++ 2.6.x-xfs-new/fs/xfs/xfs_iomap.c	2007-05-11 11:13:34.199362915 +1000
> @@ -489,13 +489,13 @@ xfs_iomap_write_direct(
>  	if (unlikely(rt)) {
>  		resrtextents = qblocks = resaligned;
>  		resrtextents /= mp->m_sb.sb_rextsize;
> -  		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> -  		quota_flag = XFS_QMOPT_RES_RTBLKS;
> -  	} else {
> -  		resrtextents = 0;
> +		resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
> +		quota_flag = XFS_QMOPT_RES_RTBLKS;
> +	} else {
> +		resrtextents = 0;
>  		resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
> -  		quota_flag = XFS_QMOPT_RES_REGBLKS;
> -  	}
> +		quota_flag = XFS_QMOPT_RES_REGBLKS;
> +	}
>
>  	/*
>  	 * Allocate and setup the transaction
> @@ -788,18 +788,12 @@ xfs_iomap_write_allocate(
>  		nimaps = 0;
>  		while (nimaps == 0) {
>  			tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> +			tp->t_flags |= XFS_TRANS_RESERVE;
>  			nres = XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK);
>  			error = xfs_trans_reserve(tp, nres,
>  					XFS_WRITE_LOG_RES(mp),
>  					0, XFS_TRANS_PERM_LOG_RES,
>  					XFS_WRITE_LOG_COUNT);
> -			if (error == ENOSPC) {
> -				error = xfs_trans_reserve(tp, 0,
> -						XFS_WRITE_LOG_RES(mp),
> -						0,
> -						XFS_TRANS_PERM_LOG_RES,
> -						XFS_WRITE_LOG_COUNT);
> -			}
>  			if (error) {
>  				xfs_trans_cancel(tp, 0);
>  				return XFS_ERROR(error);
> @@ -917,8 +911,8 @@ xfs_iomap_write_unwritten(
>  		 * from unwritten to real. Do allocations in a loop until
>  		 * we have covered the range passed in.
>  		 */
> -
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_STRAT_WRITE);
> +		tp->t_flags |= XFS_TRANS_RESERVE;
>  		error = xfs_trans_reserve(tp, resblks,
>  				XFS_WRITE_LOG_RES(mp), 0,
>  				XFS_TRANS_PERM_LOG_RES,
