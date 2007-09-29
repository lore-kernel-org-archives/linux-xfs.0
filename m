Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 29 Sep 2007 03:12:12 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8TAC5No005212
	for <xfs@oss.sgi.com>; Sat, 29 Sep 2007 03:12:06 -0700
Date: Sat, 29 Sep 2007 10:48:35 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH V2] refactor xfs_mountfs for clarity & stack savings
Message-ID: <20070929094835.GA29582@infradead.org>
References: <46D37A82.2080608@sandeen.net> <20070828195221.GA7237@infradead.org> <46D48BDE.5000903@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D48BDE.5000903@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

Any chance we can get this commited?

On Tue, Aug 28, 2007 at 03:55:58PM -0500, Eric Sandeen wrote:
> Refactoring xfs_mountfs() to call sub-functions for logical
> chunks can help save a bit of stack, and can make it easier to
> read this long function.
> 
> The mount path is one of the longest common callchains, easily
> getting to within a few bytes of the end of a 4k stack when
> over lvm, quotas are enabled, and quotacheck must be done.
> 
> With this change on top of the other stack-related changes
> I've sent, I can get xfs to survive a normal xfsqa run on
> 4k stacks over lvm.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> Index: linux-2.6-xfs/fs/xfs/xfs_mount.c
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/xfs_mount.c
> +++ linux-2.6-xfs/fs/xfs/xfs_mount.c
> @@ -734,49 +734,13 @@ xfs_initialize_perag_data(xfs_mount_t *m
>  }
>  
>  /*
> - * xfs_mountfs
> - *
> - * This function does the following on an initial mount of a file system:
> - *	- reads the superblock from disk and init the mount struct
> - *	- if we're a 32-bit kernel, do a size check on the superblock
> - *		so we don't mount terabyte filesystems
> - *	- init mount struct realtime fields
> - *	- allocate inode hash table for fs
> - *	- init directory manager
> - *	- perform recovery and init the log manager
> + * Update alignment values based on mount options and sb values
>   */
> -int
> -xfs_mountfs(
> -	xfs_mount_t	*mp,
> -	int		mfsi_flags)
> +STATIC int
> +xfs_update_alignment(xfs_mount_t *mp, int mfsi_flags, __uint64_t *update_flags)
>  {
> -	xfs_buf_t	*bp;
>  	xfs_sb_t	*sbp = &(mp->m_sb);
> -	xfs_inode_t	*rip;
> -	bhv_vnode_t	*rvp = NULL;
> -	int		readio_log, writeio_log;
> -	xfs_daddr_t	d;
> -	__uint64_t	resblks;
> -	__int64_t	update_flags;
> -	uint		quotamount, quotaflags;
> -	int		agno;
> -	int		uuid_mounted = 0;
> -	int		error = 0;
>  
> -	if (mp->m_sb_bp == NULL) {
> -		if ((error = xfs_readsb(mp, mfsi_flags))) {
> -			return error;
> -		}
> -	}
> -	xfs_mount_common(mp, sbp);
> -
> -	/*
> -	 * Check if sb_agblocks is aligned at stripe boundary
> -	 * If sb_agblocks is NOT aligned turn off m_dalign since
> -	 * allocator alignment is within an ag, therefore ag has
> -	 * to be aligned at stripe boundary.
> -	 */
> -	update_flags = 0LL;
>  	if (mp->m_dalign && !(mfsi_flags & XFS_MFSI_SECOND)) {
>  		/*
>  		 * If stripe unit and stripe width are not multiples
> @@ -787,8 +751,7 @@ xfs_mountfs(
>  			if (mp->m_flags & XFS_MOUNT_RETERR) {
>  				cmn_err(CE_WARN,
>  					"XFS: alignment check 1 failed");
> -				error = XFS_ERROR(EINVAL);
> -				goto error1;
> +				return XFS_ERROR(EINVAL);
>  			}
>  			mp->m_dalign = mp->m_swidth = 0;
>  		} else {
> @@ -798,8 +761,7 @@ xfs_mountfs(
>  			mp->m_dalign = XFS_BB_TO_FSBT(mp, mp->m_dalign);
>  			if (mp->m_dalign && (sbp->sb_agblocks % mp->m_dalign)) {
>  				if (mp->m_flags & XFS_MOUNT_RETERR) {
> -					error = XFS_ERROR(EINVAL);
> -					goto error1;
> +					return XFS_ERROR(EINVAL);
>  				}
>  				xfs_fs_cmn_err(CE_WARN, mp,
>  "stripe alignment turned off: sunit(%d)/swidth(%d) incompatible with agsize(%d)",
> @@ -816,8 +778,7 @@ xfs_mountfs(
>  "stripe alignment turned off: sunit(%d) less than bsize(%d)",
>                                          	mp->m_dalign,
>  						mp->m_blockmask +1);
> -					error = XFS_ERROR(EINVAL);
> -					goto error1;
> +					return XFS_ERROR(EINVAL);
>  				}
>  				mp->m_swidth = 0;
>  			}
> @@ -830,11 +791,11 @@ xfs_mountfs(
>  		if (XFS_SB_VERSION_HASDALIGN(sbp)) {
>  			if (sbp->sb_unit != mp->m_dalign) {
>  				sbp->sb_unit = mp->m_dalign;
> -				update_flags |= XFS_SB_UNIT;
> +				*update_flags |= XFS_SB_UNIT;
>  			}
>  			if (sbp->sb_width != mp->m_swidth) {
>  				sbp->sb_width = mp->m_swidth;
> -				update_flags |= XFS_SB_WIDTH;
> +				*update_flags |= XFS_SB_WIDTH;
>  			}
>  		}
>  	} else if ((mp->m_flags & XFS_MOUNT_NOALIGN) != XFS_MOUNT_NOALIGN &&
> @@ -843,49 +804,45 @@ xfs_mountfs(
>  			mp->m_swidth = sbp->sb_width;
>  	}
>  
> -	xfs_alloc_compute_maxlevels(mp);
> -	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> -	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> -	xfs_ialloc_compute_maxlevels(mp);
> +	return 0;
> +}
>  
> -	if (sbp->sb_imax_pct) {
> -		__uint64_t	icount;
> +/*
> + * Set the maximum inode count for this filesystem
> + */
> +STATIC void
> +xfs_set_maxicount(xfs_mount_t *mp)
> +{
> +	xfs_sb_t	*sbp = &(mp->m_sb);
> +	__uint64_t	icount;
>  
> -		/* Make sure the maximum inode count is a multiple of the
> -		 * units we allocate inodes in.
> +	if (sbp->sb_imax_pct) {
> +		/*
> +		 * Make sure the maximum inode count is a multiple
> +		 * of the units we allocate inodes in.
>  		 */
> -
>  		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
>  		do_div(icount, 100);
>  		do_div(icount, mp->m_ialloc_blks);
>  		mp->m_maxicount = (icount * mp->m_ialloc_blks)  <<
>  				   sbp->sb_inopblog;
> -	} else
> +	} else {
>  		mp->m_maxicount = 0;
> -
> -	mp->m_maxioffset = xfs_max_file_offset(sbp->sb_blocklog);
> -
> -	/*
> -	 * XFS uses the uuid from the superblock as the unique
> -	 * identifier for fsid.  We can not use the uuid from the volume
> -	 * since a single partition filesystem is identical to a single
> -	 * partition volume/filesystem.
> -	 */
> -	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
> -	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
> -		if (xfs_uuid_mount(mp)) {
> -			error = XFS_ERROR(EINVAL);
> -			goto error1;
> -		}
> -		uuid_mounted=1;
>  	}
> +}
> +
> +/*
> + * Set the default minimum read and write sizes unless
> + * already specified in a mount option.
> + * We use smaller I/O sizes when the file system
> + * is being used for NFS service (wsync mount option).
> + */
> +STATIC void
> +xfs_set_rw_sizes(xfs_mount_t *mp)
> +{
> +	xfs_sb_t	*sbp = &(mp->m_sb);
> +	int		readio_log, writeio_log;
>  
> -	/*
> -	 * Set the default minimum read and write sizes unless
> -	 * already specified in a mount option.
> -	 * We use smaller I/O sizes when the file system
> -	 * is being used for NFS service (wsync mount option).
> -	 */
>  	if (!(mp->m_flags & XFS_MOUNT_DFLT_IOSIZE)) {
>  		if (mp->m_flags & XFS_MOUNT_WSYNC) {
>  			readio_log = XFS_WSYNC_READIO_LOG;
> @@ -911,17 +868,14 @@ xfs_mountfs(
>  		mp->m_writeio_log = writeio_log;
>  	}
>  	mp->m_writeio_blocks = 1 << (mp->m_writeio_log - sbp->sb_blocklog);
> +}
>  
> -	/*
> -	 * Set the inode cluster size.
> -	 * This may still be overridden by the file system
> -	 * block size if it is larger than the chosen cluster size.
> -	 */
> -	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> -
> -	/*
> -	 * Set whether we're using inode alignment.
> -	 */
> +/*
> + * Set whether we're using inode alignment.
> + */
> +STATIC void
> +xfs_set_inoalignment(xfs_mount_t *mp)
> +{
>  	if (XFS_SB_VERSION_HASALIGN(&mp->m_sb) &&
>  	    mp->m_sb.sb_inoalignmt >=
>  	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
> @@ -937,14 +891,22 @@ xfs_mountfs(
>  		mp->m_sinoalign = mp->m_dalign;
>  	else
>  		mp->m_sinoalign = 0;
> -	/*
> -	 * Check that the data (and log if separate) are an ok size.
> -	 */
> +}
> +
> +/*
> + * Check that the data (and log if separate) are an ok size.
> + */
> +STATIC int
> +xfs_check_sizes(xfs_mount_t *mp, int mfsi_flags)
> +{
> +	xfs_buf_t	*bp;
> +	xfs_daddr_t	d;
> +	int		error;
> +
>  	d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_dblocks);
>  	if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_dblocks) {
>  		cmn_err(CE_WARN, "XFS: size check 1 failed");
> -		error = XFS_ERROR(E2BIG);
> -		goto error1;
> +		return XFS_ERROR(E2BIG);
>  	}
>  	error = xfs_read_buf(mp, mp->m_ddev_targp,
>  			     d - XFS_FSS_TO_BB(mp, 1),
> @@ -953,10 +915,9 @@ xfs_mountfs(
>  		xfs_buf_relse(bp);
>  	} else {
>  		cmn_err(CE_WARN, "XFS: size check 2 failed");
> -		if (error == ENOSPC) {
> +		if (error == ENOSPC)
>  			error = XFS_ERROR(E2BIG);
> -		}
> -		goto error1;
> +		return error;
>  	}
>  
>  	if (((mfsi_flags & XFS_MFSI_CLIENT) == 0) &&
> @@ -964,8 +925,7 @@ xfs_mountfs(
>  		d = (xfs_daddr_t)XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
>  		if (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) {
>  			cmn_err(CE_WARN, "XFS: size check 3 failed");
> -			error = XFS_ERROR(E2BIG);
> -			goto error1;
> +			return XFS_ERROR(E2BIG);
>  		}
>  		error = xfs_read_buf(mp, mp->m_logdev_targp,
>  				     d - XFS_FSB_TO_BB(mp, 1),
> @@ -974,17 +934,110 @@ xfs_mountfs(
>  			xfs_buf_relse(bp);
>  		} else {
>  			cmn_err(CE_WARN, "XFS: size check 3 failed");
> -			if (error == ENOSPC) {
> +			if (error == ENOSPC)
>  				error = XFS_ERROR(E2BIG);
> -			}
> +			return error;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/*
> + * xfs_mountfs
> + *
> + * This function does the following on an initial mount of a file system:
> + *	- reads the superblock from disk and init the mount struct
> + *	- if we're a 32-bit kernel, do a size check on the superblock
> + *		so we don't mount terabyte filesystems
> + *	- init mount struct realtime fields
> + *	- allocate inode hash table for fs
> + *	- init directory manager
> + *	- perform recovery and init the log manager
> + */
> +int
> +xfs_mountfs(
> +	xfs_mount_t	*mp,
> +	int		mfsi_flags)
> +{
> +	xfs_sb_t	*sbp = &(mp->m_sb);
> +	xfs_inode_t	*rip;
> +	bhv_vnode_t	*rvp = NULL;
> +	__uint64_t	resblks;
> +	__int64_t	update_flags = 0LL;
> +	uint		quotamount, quotaflags;
> +	int		agno;
> +	int		uuid_mounted = 0;
> +	int		error = 0;
> +
> +	if (mp->m_sb_bp == NULL) {
> +		error = xfs_readsb(mp, mfsi_flags);
> +		if (error)
> +			return error;
> +	}
> +	xfs_mount_common(mp, sbp);
> +
> +	/*
> +	 * Check if sb_agblocks is aligned at stripe boundary
> +	 * If sb_agblocks is NOT aligned turn off m_dalign since
> +	 * allocator alignment is within an ag, therefore ag has
> +	 * to be aligned at stripe boundary.
> +	 */
> +	error = xfs_update_alignment(mp, mfsi_flags, &update_flags);
> +	if (error)
> +		goto error1;
> +
> +	xfs_alloc_compute_maxlevels(mp);
> +	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
> +	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
> +	xfs_ialloc_compute_maxlevels(mp);
> +
> +	xfs_set_maxicount(mp);
> +
> +	mp->m_maxioffset = xfs_max_file_offset(sbp->sb_blocklog);
> +
> +	/*
> +	 * XFS uses the uuid from the superblock as the unique
> +	 * identifier for fsid.  We can not use the uuid from the volume
> +	 * since a single partition filesystem is identical to a single
> +	 * partition volume/filesystem.
> +	 */
> +	if ((mfsi_flags & XFS_MFSI_SECOND) == 0 &&
> +	    (mp->m_flags & XFS_MOUNT_NOUUID) == 0) {
> +		if (xfs_uuid_mount(mp)) {
> +			error = XFS_ERROR(EINVAL);
>  			goto error1;
>  		}
>  	}
>  
>  	/*
> +	 * Set the minimum read and write sizes
> +	 */
> +	xfs_set_rw_sizes(mp);
> +
> +	/*
> +	 * Set the inode cluster size.
> +	 * This may still be overridden by the file system
> +	 * block size if it is larger than the chosen cluster size.
> +	 */
> +	mp->m_inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> +
> +	/*
> +	 * Set inode alignment fields
> +	 */
> +	xfs_set_inoalignment(mp);
> +
> +	/*
> +	 * Check that the data (and log if separate) are an ok size.
> +	 */
> +	error = xfs_check_sizes(mp, mfsi_flags);
> +	if (error)
> +		goto error1;
> +
> +	/*
>  	 * Initialize realtime fields in the mount structure
>  	 */
> -	if ((error = xfs_rtmount_init(mp))) {
> +	error = xfs_rtmount_init(mp);
> +	if (error) {
>  		cmn_err(CE_WARN, "XFS: RT mount failed");
>  		goto error1;
>  	}
> @@ -1102,7 +1155,8 @@ xfs_mountfs(
>  	/*
>  	 * Initialize realtime inode pointers in the mount structure
>  	 */
> -	if ((error = xfs_rtmount_inodes(mp))) {
> +	error = xfs_rtmount_inodes(mp);
> +	if (error) {
>  		/*
>  		 * Free up the root inode.
>  		 */
> @@ -1120,7 +1174,8 @@ xfs_mountfs(
>  	/*
>  	 * Initialise the XFS quota management subsystem for this mount
>  	 */
> -	if ((error = XFS_QM_INIT(mp, &quotamount, &quotaflags)))
> +	error = XFS_QM_INIT(mp, &quotamount, &quotaflags);
> +	if (error)
>  		goto error4;
>  
>  	/*
> @@ -1137,7 +1192,8 @@ xfs_mountfs(
>  	/*
>  	 * Complete the quota initialisation, post-log-replay component.
>  	 */
> -	if ((error = XFS_QM_MOUNT(mp, quotamount, quotaflags, mfsi_flags)))
> +	error = XFS_QM_MOUNT(mp, quotamount, quotaflags, mfsi_flags);
> +	if (error)
>  		goto error4;
>  
>  	/*
> 
> 
> 
---end quoted text---
