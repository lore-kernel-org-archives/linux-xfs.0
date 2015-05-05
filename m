Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A41977F58
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 10:31:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8BCCB304039
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 08:31:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nIEanAdKNHQWiIHP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 08:31:24 -0700 (PDT)
Date: Tue, 5 May 2015 11:31:20 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: xfs_attr_inactive leaves inconsistent attr fork
	state behind
Message-ID: <20150505153120.GE43235@bfoster.bfoster>
References: <1430780408-12539-1-git-send-email-david@fromorbit.com>
	<1430780408-12539-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1430780408-12539-3-git-send-email-david@fromorbit.com>
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
Cc: xfs@oss.sgi.com

On Tue, May 05, 2015 at 09:00:08AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_attr_inactive() is supposed to clean up the attribute fork when
> the inode is being freed. While it removes attribute fork extents,
> it completely ignores attributes in local format, which means that
> there can still be active attributes on the inode after
> xfs_attr_inactive() has run.
> 
> This leads to problems with concurrent inode writeback - the in-core
> inode attribute fork is removed without locking on the assumption
> that nothing will be attempting to access the attribute fork after a
> call to xfs_attr_inactive() because it isn't supposed to exist on
> disk any more.
> 
> To fix this, make xfs_attr_inactive() completely remove all traces
> of the attribute fork from the inode, regardless of it's state.
> Further, also remove the in-core attribute fork structure safely so
> that there is nothing further that needs to be done by callers to
> clean up the attribute fork. This means we can remove the in-core
> and on-disk attribute forks atomically.
> 
> Also, on error simply remove the in-memory attribute fork. There's
> nothing that can be done with it once we have failed to remove the
> on-disk attribute fork, so we may as well just blow it away here
> anyway.
> 
> cc: <stable@vger.kernel.org> # 3.12 to 4.0
> Reported-by: Waiman Long <waiman.long@hp.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c |  2 +-
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>  fs/xfs/xfs_attr_inactive.c    | 83 ++++++++++++++++++++++++++-----------------
>  fs/xfs/xfs_inode.c            | 12 +++----
>  4 files changed, 57 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 04e79d5..36b354e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -574,7 +574,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>   * After the last attribute is removed revert to original inode format,
>   * making all literal area available to the data fork once more.
>   */
> -STATIC void
> +void
>  xfs_attr_fork_reset(
>  	struct xfs_inode	*ip,
>  	struct xfs_trans	*tp)
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 025c4b8..6478627 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -53,7 +53,7 @@ int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int	xfs_attr_shortform_list(struct xfs_attr_list_context *context);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
> -
> +void	xfs_attr_fork_reset(struct xfs_inode *ip, struct xfs_trans *tp);
>  
>  /*
>   * Internal routines when attribute fork size == XFS_LBSIZE(mp).
> diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
> index f9c1c64..d811a0f 100644
> --- a/fs/xfs/xfs_attr_inactive.c
> +++ b/fs/xfs/xfs_attr_inactive.c
> @@ -380,23 +380,31 @@ xfs_attr3_root_inactive(
>  	return error;
>  }
>  
> +/*
> + * xfs_attr_inactive kills all traces of an attribute fork on an inode. It
> + * removes both the on-disk and in-memory inode fork. Note that this also has to
> + * handle the condition of inodes without attributes but with an attribute fork
> + * configured, so we can't use xfs_inode_hasattr() here.
> + *
> + * The in-memory attribute fork is removed even on error.
> + */
>  int
> -xfs_attr_inactive(xfs_inode_t *dp)
> +xfs_attr_inactive(
> +	struct xfs_inode	*dp)
>  {
> -	xfs_trans_t *trans;
> -	xfs_mount_t *mp;
> -	int error;
> +	struct xfs_trans	*trans;
> +	struct xfs_mount	*mp;
> +	int			cancel_flags = 0;
> +	int			lock_mode = XFS_ILOCK_SHARED;
> +	int			error = 0;
>  
>  	mp = dp->i_mount;
>  	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
>  
> -	xfs_ilock(dp, XFS_ILOCK_SHARED);
> -	if (!xfs_inode_hasattr(dp) ||
> -	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> -		xfs_iunlock(dp, XFS_ILOCK_SHARED);
> -		return 0;
> -	}
> -	xfs_iunlock(dp, XFS_ILOCK_SHARED);
> +	xfs_ilock(dp, lock_mode);
> +	if (!XFS_IFORK_Q(dp))
> +		goto out_destroy_fork;
> +	xfs_iunlock(dp, lock_mode);
>  
>  	/*
>  	 * Start our first transaction of the day.
> @@ -408,13 +416,15 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	 * the inode in every transaction to let it float upward through
>  	 * the log.
>  	 */
> +	lock_mode = 0;
>  	trans = xfs_trans_alloc(mp, XFS_TRANS_ATTRINVAL);
>  	error = xfs_trans_reserve(trans, &M_RES(mp)->tr_attrinval, 0, 0);
> -	if (error) {
> -		xfs_trans_cancel(trans, 0);
> -		return error;
> -	}
> -	xfs_ilock(dp, XFS_ILOCK_EXCL);
> +	if (error)
> +		goto out_cancel;
> +
> +	lock_mode = XFS_ILOCK_EXCL;
> +	cancel_flags = XFS_TRANS_RELEASE_LOG_RES | XFS_TRANS_ABORT;
> +	xfs_ilock(dp, lock_mode);
>  
>  	/*
>  	 * No need to make quota reservations here. We expect to release some
> @@ -423,28 +433,37 @@ xfs_attr_inactive(xfs_inode_t *dp)
>  	xfs_trans_ijoin(trans, dp, 0);
>  
>  	/*
> -	 * Decide on what work routines to call based on the inode size.
> +	 * It's unlikely we've raced with an attribute fork creation, but check
> +	 * anyway just in case.

Same comment as before with regard to "attribute fork creation,"
otherwise looks good to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	 */
> -	if (!xfs_inode_hasattr(dp) ||
> -	    dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
> -		error = 0;
> -		goto out;
> +	if (!XFS_IFORK_Q(dp))
> +		goto out_cancel;
> +
> +	/* invalidate and truncate the attribute fork extents */
> +	if (dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
> +		error = xfs_attr3_root_inactive(&trans, dp);
> +		if (error)
> +			goto out_cancel;
> +
> +		error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
> +		if (error)
> +			goto out_cancel;
>  	}
> -	error = xfs_attr3_root_inactive(&trans, dp);
> -	if (error)
> -		goto out;
>  
> -	error = xfs_itruncate_extents(&trans, dp, XFS_ATTR_FORK, 0);
> -	if (error)
> -		goto out;
> +	/* Reset the attribute fork - this also destroys the in-core fork */
> +	xfs_attr_fork_reset(dp, trans);
>  
>  	error = xfs_trans_commit(trans, XFS_TRANS_RELEASE_LOG_RES);
> -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> -
> +	xfs_iunlock(dp, lock_mode);
>  	return error;
>  
> -out:
> -	xfs_trans_cancel(trans, XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
> -	xfs_iunlock(dp, XFS_ILOCK_EXCL);
> +out_cancel:
> +	xfs_trans_cancel(trans, cancel_flags);
> +out_destroy_fork:
> +	/* kill the in-core attr fork before we drop the inode lock */
> +	if (dp->i_afp)
> +		xfs_idestroy_fork(dp, XFS_ATTR_FORK);
> +	if (lock_mode)
> +		xfs_iunlock(dp, lock_mode);
>  	return error;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index d6ebc85..1117dd3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -1946,21 +1946,17 @@ xfs_inactive(
>  	/*
>  	 * If there are attributes associated with the file then blow them away
>  	 * now.  The code calls a routine that recursively deconstructs the
> -	 * attribute fork.  We need to just commit the current transaction
> -	 * because we can't use it for xfs_attr_inactive().
> +	 * attribute fork. If also blows away the in-core attribute fork.
>  	 */
> -	if (ip->i_d.di_anextents > 0) {
> -		ASSERT(ip->i_d.di_forkoff != 0);
> -
> +	if (XFS_IFORK_Q(ip)) {
>  		error = xfs_attr_inactive(ip);
>  		if (error)
>  			return;
>  	}
>  
> -	if (ip->i_afp)
> -		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
> -
> +	ASSERT(!ip->i_afp);
>  	ASSERT(ip->i_d.di_anextents == 0);
> +	ASSERT(ip->i_d.di_forkoff == 0);
>  
>  	/*
>  	 * Free the inode.
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
