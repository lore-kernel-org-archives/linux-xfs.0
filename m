Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3F8137F51
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 11:44:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B17E8AC005
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 09:44:33 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kbZRuJC6HG7uRdAx for
	<xfs@oss.sgi.com>; Mon, 03 Mar 2014 09:44:32 -0800 (PST)
Date: Mon, 3 Mar 2014 12:44:26 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
Message-ID: <20140303174425.GB28196@laptop.bfoster>
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

This change looks Ok to me, but when I start looking through the users
of bp->b_error, I see examples like xfs_dir3_data_read() being called in
xfs_dir2_leaf_addname() where it looks like an error could bubble all
the way up to xfs_vn_mknod() and its callers.

If the intent is to use EFSBADCRC as an internal-only error to
differentiate corruption from crc failure, why not push this more
closely to the boundaries that we have already defined? For example, we
already convert positive errnos to negative at the internal/external
boundaries. Could we convert those to use some kind of
XFS_USERSPACE_ERROR(error) macro/helper that converts errors
appropriately?

Another thought could be to reconsider whether we still need some of
these extra warnings, as in the xfs_mount.c hunk below, now that we have
the generic xfs_verifier_error() messaging. E.g., if we could remove
those, perhaps we could snub out EFSBADCRC in or around the verifier
after it makes a distinction.

Brian

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
