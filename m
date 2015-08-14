Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9005D7F37
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 14:41:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7BA3E8F804B
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 12:41:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BA5hkqygoF8lkFZ1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 12:41:48 -0700 (PDT)
Date: Fri, 14 Aug 2015 15:41:45 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: stop holding ILOCK over filldir callbacks
Message-ID: <20150814194145.GB18522@bfoster.bfoster>
References: <1439330648-1057-1-git-send-email-david@fromorbit.com>
	<1439330648-1057-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1439330648-1057-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, oleg@redhat.com, xfs@oss.sgi.com

On Wed, Aug 12, 2015 at 08:04:08AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent change to the readdir locking made in 40194ec ("xfs:
> reinstate the ilock in xfs_readdir") for CXFS directory sanity was
> probably the wrong thing to do. Deep in the readdir code we
> can take page faults in the filldir callback, and so taking a page
> fault while holding an inode ilock creates a new set of locking
> issues that lockdep warns all over the place about.
> 
> The locking order for regular inodes w.r.t. page faults is io_lock
> -> pagefault -> mmap_sem -> ilock. The directory readdir code now
> triggers ilock -> page fault -> mmap_sem. While we cannot deadlock
> at this point, it inverts all the locking patterns that lockdep
> normally sees on XFS inodes, and so triggers lockdep. We worked
> around this with commit 93a8614 ("xfs: fix directory inode iolock
> lockdep false positive"), but that then just moved the lockdep
> warning to deeper in the page fault path and triggered on security
> inode locks. Fixing the shmem issue there just moved the lockdep
> reports somewhere else, and now we are getting false positives from
> filesystem freezing annotations getting confused.
> 
> Further, if we enter memory reclaim in a readdir path, we now get
> lockdep warning about potential deadlocks because the ilock is held
> when we enter reclaim. This, again, is different to a regular file
> in that we never allow memory reclaim to run while holding the ilock
> for regular files. Hence lockdep now throws
> ilock->kmalloc->reclaim->ilock warnings.
> 
> Basically, the problem is that the ilock is being used to protect
> the directory data and the inode metadata, whereas for a regular
> file the iolock protects the data and the ilock protects the
> metadata. From the VFS perspective, the i_mutex serialises all
> accesses to the directory data, and so not holding the ilock for
> readdir doesn't matter. The issue is that CXFS doesn't access
> directory data via the VFS, so it has no "data serialisaton"
> mechanism. Hence we need to hold the IOLOCK in the correct places to
> provide this low level directory data access serialisation.
> 
> The ilock can then be used just when the extent list needs to be
> read, just like we do for regular files. The directory modification
> code can take the iolock exclusive when the ilock is also taken,
> and this then ensures that readdir is correct excluded while
> modifications are in progress.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_dir2.c  |  3 +++
>  fs/xfs/xfs_dir2_readdir.c | 11 ++++++++---
>  fs/xfs/xfs_inode.c        | 34 +++++++++++++++++++++-------------
>  fs/xfs/xfs_symlink.c      |  7 ++++---
>  4 files changed, 36 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
> index a69fb3a..42799d8 100644
> --- a/fs/xfs/libxfs/xfs_dir2.c
> +++ b/fs/xfs/libxfs/xfs_dir2.c
> @@ -362,6 +362,7 @@ xfs_dir_lookup(
>  	struct xfs_da_args *args;
>  	int		rval;
>  	int		v;		/* type-checking value */
> +	int		lock_mode;
>  
>  	ASSERT(S_ISDIR(dp->i_d.di_mode));
>  	XFS_STATS_INC(xs_dir_lookup);
> @@ -387,6 +388,7 @@ xfs_dir_lookup(
>  	if (ci_name)
>  		args->op_flags |= XFS_DA_OP_CILOOKUP;
>  
> +	lock_mode = xfs_ilock_data_map_shared(dp);
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
>  		rval = xfs_dir2_sf_lookup(args);
>  		goto out_check_rval;
> @@ -419,6 +421,7 @@ out_check_rval:
>  		}
>  	}
>  out_free:
> +	xfs_iunlock(dp, lock_mode);
>  	kmem_free(args);
>  	return rval;
>  }
> diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
> index 098cd78..a989a9c 100644
> --- a/fs/xfs/xfs_dir2_readdir.c
> +++ b/fs/xfs/xfs_dir2_readdir.c
> @@ -171,6 +171,7 @@ xfs_dir2_block_getdents(
>  	int			wantoff;	/* starting block offset */
>  	xfs_off_t		cook;
>  	struct xfs_da_geometry	*geo = args->geo;
> +	int			lock_mode;
>  
>  	/*
>  	 * If the block number in the offset is out of range, we're done.
> @@ -178,7 +179,9 @@ xfs_dir2_block_getdents(
>  	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
>  		return 0;
>  
> +	lock_mode = xfs_ilock_data_map_shared(dp);
>  	error = xfs_dir3_block_read(NULL, dp, &bp);
> +	xfs_iunlock(dp, lock_mode);

Ok, so the iolock bits exclude directory reads/lookups against directory
modification. The ilock around these buffer reads serves the purpose of
the commit 40194ec mentioned above, to protect reading in the extent
tree.

The locking all looks fine, but what I'm not quite clear on is where the
requirement for the iolock comes in. Is this necessary because the ilock
has been pushed down? Are we just trying to mirror how i_mutex is used
and/or provide a consistent locking pattern as for regular files?

Brian

>  	if (error)
>  		return error;
>  
> @@ -529,9 +532,12 @@ xfs_dir2_leaf_getdents(
>  		 * current buffer, need to get another one.
>  		 */
>  		if (!bp || ptr >= (char *)bp->b_addr + geo->blksize) {
> +			int	lock_mode;
>  
> +			lock_mode = xfs_ilock_data_map_shared(dp);
>  			error = xfs_dir2_leaf_readbuf(args, bufsize, map_info,
>  						      &curoff, &bp);
> +			xfs_iunlock(dp, lock_mode);
>  			if (error || !map_info->map_valid)
>  				break;
>  
> @@ -653,7 +659,6 @@ xfs_readdir(
>  	struct xfs_da_args	args = { NULL };
>  	int			rval;
>  	int			v;
> -	uint			lock_mode;
>  
>  	trace_xfs_readdir(dp);
>  
> @@ -666,7 +671,7 @@ xfs_readdir(
>  	args.dp = dp;
>  	args.geo = dp->i_mount->m_dir_geo;
>  
> -	lock_mode = xfs_ilock_data_map_shared(dp);
> +	xfs_ilock(dp, XFS_IOLOCK_SHARED);
>  	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
>  		rval = xfs_dir2_sf_getdents(&args, ctx);
>  	else if ((rval = xfs_dir2_isblock(&args, &v)))
> @@ -675,7 +680,7 @@ xfs_readdir(
>  		rval = xfs_dir2_block_getdents(&args, ctx);
>  	else
>  		rval = xfs_dir2_leaf_getdents(&args, ctx, bufsize);
> -	xfs_iunlock(dp, lock_mode);
> +	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  
>  	return rval;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 793e6c9..83b0752 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -672,30 +672,29 @@ xfs_lookup(
>  {
>  	xfs_ino_t		inum;
>  	int			error;
> -	uint			lock_mode;
>  
>  	trace_xfs_lookup(dp, name);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
>  
> -	lock_mode = xfs_ilock_data_map_shared(dp);
> +	xfs_ilock(dp, XFS_IOLOCK_SHARED);
>  	error = xfs_dir_lookup(NULL, dp, name, &inum, ci_name);
> -	xfs_iunlock(dp, lock_mode);
> -
>  	if (error)
> -		goto out;
> +		goto out_unlock;
>  
>  	error = xfs_iget(dp->i_mount, NULL, inum, 0, 0, ipp);
>  	if (error)
>  		goto out_free_name;
>  
> +	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  	return 0;
>  
>  out_free_name:
>  	if (ci_name)
>  		kmem_free(ci_name->name);
> -out:
> +out_unlock:
> +	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
>  	*ipp = NULL;
>  	return error;
>  }
> @@ -1197,7 +1196,8 @@ xfs_create(
>  		goto out_trans_cancel;
>  
>  
> -	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> +	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
> +		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
>  	xfs_bmap_init(&free_list, &first_block);
> @@ -1236,7 +1236,7 @@ xfs_create(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	unlock_dp_on_error = false;
>  
>  	error = xfs_dir_createname(tp, dp, name, ip->i_ino,
> @@ -1309,7 +1309,7 @@ xfs_create(
>  	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
> -		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> @@ -1457,10 +1457,11 @@ xfs_link(
>  	if (error)
>  		goto error_return;
>  
> +	xfs_ilock(tdp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
>  	xfs_lock_two_inodes(sip, tdp, XFS_ILOCK_EXCL);
>  
>  	xfs_trans_ijoin(tp, sip, XFS_ILOCK_EXCL);
> -	xfs_trans_ijoin(tp, tdp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, tdp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  
>  	/*
>  	 * If we are using project inheritance, we only allow hard link
> @@ -2563,9 +2564,10 @@ xfs_remove(
>  		goto out_trans_cancel;
>  	}
>  
> +	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
>  	xfs_lock_two_inodes(dp, ip, XFS_ILOCK_EXCL);
>  
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
>  
>  	/*
> @@ -2946,6 +2948,12 @@ xfs_rename(
>  	 * whether the target directory is the same as the source
>  	 * directory, we can lock from 2 to 4 inodes.
>  	 */
> +	if (!new_parent)
> +		xfs_ilock(src_dp, XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
> +	else
> +		xfs_lock_two_inodes(src_dp, target_dp,
> +				    XFS_IOLOCK_EXCL | XFS_IOLOCK_PARENT);
> +
>  	xfs_lock_inodes(inodes, num_inodes, XFS_ILOCK_EXCL);
>  
>  	/*
> @@ -2953,9 +2961,9 @@ xfs_rename(
>  	 * we can rely on either trans_commit or trans_cancel to unlock
>  	 * them.
>  	 */
> -	xfs_trans_ijoin(tp, src_dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, src_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	if (new_parent)
> -		xfs_trans_ijoin(tp, target_dp, XFS_ILOCK_EXCL);
> +		xfs_trans_ijoin(tp, target_dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	xfs_trans_ijoin(tp, src_ip, XFS_ILOCK_EXCL);
>  	if (target_ip)
>  		xfs_trans_ijoin(tp, target_ip, XFS_ILOCK_EXCL);
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 4be27b0..7a01486 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -240,7 +240,8 @@ xfs_symlink(
>  	if (error)
>  		goto out_trans_cancel;
>  
> -	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
> +	xfs_ilock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL |
> +		      XFS_IOLOCK_PARENT | XFS_ILOCK_PARENT);
>  	unlock_dp_on_error = true;
>  
>  	/*
> @@ -288,7 +289,7 @@ xfs_symlink(
>  	 * the transaction cancel unlocking dp so don't do it explicitly in the
>  	 * error path.
>  	 */
> -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	unlock_dp_on_error = false;
>  
>  	/*
> @@ -421,7 +422,7 @@ out_release_inode:
>  	xfs_qm_dqrele(pdqp);
>  
>  	if (unlock_dp_on_error)
> -		xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +		xfs_iunlock(dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
> -- 
> 2.5.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
