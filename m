Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5AD307F3F
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:49:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 31FAD8F8078
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 07:49:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7RsYFSOw0nz0FnSa for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 07:49:01 -0800 (PST)
Date: Wed, 5 Mar 2014 10:48:56 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
Message-ID: <20140305154855.GA55736@bfoster.bfoster>
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
	<1393825194-1719-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1393825194-1719-2-git-send-email-david@fromorbit.com>
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

On Mon, Mar 03, 2014 at 04:39:53PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> While the verifier reoutines may return EFSBADCRC when a buffer ahs
> a bad CRC, we need to translate that to EFSCORRUPTED so that the
> higher layers treat the error appropriately and so we return a
> consistent error to userspace. This fixes a xfs/005 regression.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looking through again, I don't see any obvious cases where EFSBADCRC
could slip through. The verifier users mostly call
xfs_trans_read_buf_map(). The readahead case looks like it should be
handled by the xfs_buf_iowait() checks therein.

The one case I came across that looked suspicious is the readahead/read
cycle for inode log recovery in xlog_recover_commit_trans(). This calls
into xfs_buf_read() and ultimately uses bp->b_error directly in
xlog_recover_inode_pass2(). That said, I don't see any crc checking in
these verifiers and thus they don't source EFSBADCRC. Looks good to
me...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_mount.c     |  3 +++
>  fs/xfs/xfs_symlink.c   |  4 ++++
>  fs/xfs/xfs_trans_buf.c | 11 +++++++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index f96c056..993cb19 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -314,6 +314,9 @@ reread:
>  		error = bp->b_error;
>  		if (loud)
>  			xfs_warn(mp, "SB validate failed with error %d.", error);
> +		/* bad CRC means corrupted metadata */
> +		if (error == EFSBADCRC)
> +			error = EFSCORRUPTED;
>  		goto release_buf;
>  	}
>  
> diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
> index 14e58f2..5fda189 100644
> --- a/fs/xfs/xfs_symlink.c
> +++ b/fs/xfs/xfs_symlink.c
> @@ -80,6 +80,10 @@ xfs_readlink_bmap(
>  		if (error) {
>  			xfs_buf_ioerror_alert(bp, __func__);
>  			xfs_buf_relse(bp);
> +
> +			/* bad CRC means corrupted metadata */
> +			if (error == EFSBADCRC)
> +				error = EFSCORRUPTED;
>  			goto out;
>  		}
>  		byte_cnt = XFS_SYMLINK_BUF_SPACE(mp, byte_cnt);
> diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
> index 647b6f1..b8eef05 100644
> --- a/fs/xfs/xfs_trans_buf.c
> +++ b/fs/xfs/xfs_trans_buf.c
> @@ -275,6 +275,10 @@ xfs_trans_read_buf_map(
>  			XFS_BUF_UNDONE(bp);
>  			xfs_buf_stale(bp);
>  			xfs_buf_relse(bp);
> +
> +			/* bad CRC means corrupted metadata */
> +			if (error == EFSBADCRC)
> +				error = EFSCORRUPTED;
>  			return error;
>  		}
>  #ifdef DEBUG
> @@ -338,6 +342,9 @@ xfs_trans_read_buf_map(
>  				if (tp->t_flags & XFS_TRANS_DIRTY)
>  					xfs_force_shutdown(tp->t_mountp,
>  							SHUTDOWN_META_IO_ERROR);
> +				/* bad CRC means corrupted metadata */
> +				if (error == EFSBADCRC)
> +					error = EFSCORRUPTED;
>  				return error;
>  			}
>  		}
> @@ -375,6 +382,10 @@ xfs_trans_read_buf_map(
>  		if (tp->t_flags & XFS_TRANS_DIRTY)
>  			xfs_force_shutdown(tp->t_mountp, SHUTDOWN_META_IO_ERROR);
>  		xfs_buf_relse(bp);
> +
> +		/* bad CRC means corrupted metadata */
> +		if (error == EFSBADCRC)
> +			error = EFSCORRUPTED;
>  		return error;
>  	}
>  #ifdef DEBUG
> -- 
> 1.9.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
