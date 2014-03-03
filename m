Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A02277F4E
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 11:34:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 887C0304032
	for <xfs@oss.sgi.com>; Mon,  3 Mar 2014 09:34:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id tkkKWnl9PlN37cNP for <xfs@oss.sgi.com>;
	Mon, 03 Mar 2014 09:34:36 -0800 (PST)
Message-ID: <5314BD2B.1010904@sandeen.net>
Date: Mon, 03 Mar 2014 11:34:35 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] xfs: don't leak EFSBADCRC to userspace
References: <1393825194-1719-1-git-send-email-david@fromorbit.com>
	<1393825194-1719-2-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 3/2/14, 11:39 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> While the verifier reoutines may return EFSBADCRC when a buffer ahs
> a bad CRC, we need to translate that to EFSCORRUPTED so that the
> higher layers treat the error appropriately and so we return a
> consistent error to userspace. This fixes a xfs/005 regression.

Can you say a little more about the philosophy here?

xfs/005 regresses because it expects "structure needs cleaning"

So if we instead return our (icky) CRC error code, we get something else.

But it is truly a different root cause.

So the goal is to NEVER leak EFSBADCRC to userspace?  Maybe a comment
above that error definition would help document that.

And I'm bit worried that we'll leak more in the future if things changed,
or if things got missed here.  Everything you have here looks fine, but
it's not obvious that every path has been caught; it seems a bit random.

I know we _just_ merged my "differentiator" patches, but I wonder if
it would be better to add XFS_BSTATE_BADCRC to b_state or some other 
field, and go back to always assigning EFSCORRUPTED.  What do you think?

When I wrote those I wasn't thinking about keeping it all internal
to the filesystem.

-Eric

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
