Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Jun 2007 22:28:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l585SLWt013610
	for <xfs@oss.sgi.com>; Thu, 7 Jun 2007 22:28:22 -0700
Date: Fri, 08 Jun 2007 15:28:14 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: Be smarter about handling ENOSPC during writeback
Message-ID: <F80A059A828DE0E57A655471@boing.melbourne.sgi.com>
In-Reply-To: <E436D9833B42EFAE6C2CE987@timothy-shimmins-power-mac-g5.local>
References: <20070604045219.GG86004887@sgi.com>
 <E436D9833B42EFAE6C2CE987@timothy-shimmins-power-mac-g5.local>
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

Putting the xfs_reserve_blocks discussion to the side....
(discussed separately)


Back to the review, looking at the changes:

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

* allow xfs_reserve_blocks() to handle a null outval so that
  we can call xfs_reserve_blocks other than thru ioctl,
  where we don't care about outval
* xfs_growfs_data_private() or's in XFS_TRANS_RESERVE like we do for root EAs
  -> allow growfs transaction to dip in to reserve space

>  fs/xfs/xfs_mount.c |   37 +++++++++++++++++++++++++++++++++++--

* xfs_mountfs(): cleanup - restrict a variable (ret64) to the block its used in
* xfs_mountfs(): do our xfs_reserve_blocks() for what we think we'll need
  - pass NULL for 2nd param to it as we don't care (why we changed xfs_fsops.c)
  - defaults to min(1024 FSBs, 5% dblocks)
    -> not sure how one would choose this but it sounds big enough
* xfs_unmountfs(): xfs_reserve_blocks of zero and so restoring the sb free counter

Q: so I guess, for DMF systems which presumably turn this stuff on using the ioctl;
   we should tell them to stop doing this - they could stuff us up by overriding it
   maybe and they don't need to.

>  fs/xfs/xfs_iomap.c |   22 ++++++++--------------

* some whitespace cleanup
xfs_iomap_write_allocate():
* delalloc extent conversion - mark transaction for reserved blocks space
* don't handle ENOSPC here, as we shouldn't get it now I presume
xfs_iomap_write_unwritten
* unwritten extent conversion - mark trans for reserved blocks

Seems simple enough :)
Will we get questions from people about reduced space from df? :)

--Tim



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
>  			tp = xfs_trans_alloc(mp, XFS_TRANS_START_WRITE);
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
>  		tp = xfs_trans_alloc(mp, XFS_TRANS_START_WRITE);
> +		tp->t_flags |= XFS_TRANS_RESERVE;
>  		error = xfs_trans_reserve(tp, resblks,
>  				XFS_WRITE_LOG_RES(mp), 0,
>  				XFS_TRANS_PERM_LOG_RES,
