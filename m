Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:53282 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751622AbeEDWKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 May 2018 18:10:36 -0400
Date: Fri, 4 May 2018 15:10:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 5/5] xfs: print specific dqblk that failed verifiers
Message-ID: <20180504221016.GS26569@magnolia>
References: <f5d059e3-28de-e365-acd4-d82aa9d17db7@redhat.com>
 <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d126a83-c4ef-00a2-dbb6-510e2c41de73@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Fri, May 04, 2018 at 12:35:40PM -0500, Eric Sandeen wrote:
> Rather than printing the top of the buffer that held a corrupted dqblk,
> restructure things to print out the specific one that failed by pushing
> the calls to the verifier_error function down into the verifier which
> iterates over the buffer and detects the error.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_dquot_buf.c | 41 +++++++++++++++++++----------------
>  1 file changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index d71c0b53536b..fb23d941e799 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -152,7 +152,8 @@ xfs_dqblk_repair(
>  STATIC bool
>  xfs_dquot_buf_verify_crc(
>  	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	bool			readahead)
>  {
>  	struct xfs_dqblk	*d = (struct xfs_dqblk *)bp->b_addr;
>  	int			ndquots;
> @@ -173,8 +174,12 @@ xfs_dquot_buf_verify_crc(
>  
>  	for (i = 0; i < ndquots; i++, d++) {
>  		if (!xfs_verify_cksum((char *)d, sizeof(struct xfs_dqblk),
> -				 XFS_DQUOT_CRC_OFF))
> +				 XFS_DQUOT_CRC_OFF)) {
> +			if (!readahead)
> +				xfs_buf_verifier_error(bp, -EFSBADCRC, __func__,
> +					d, sizeof(*d), __this_address);
>  			return false;
> +		}
>  	}
>  	return true;
>  }
> @@ -182,7 +187,8 @@ xfs_dquot_buf_verify_crc(
>  STATIC xfs_failaddr_t
>  xfs_dquot_buf_verify(
>  	struct xfs_mount	*mp,
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	bool			readahead)
>  {
>  	struct xfs_dqblk	*dqb = (struct xfs_dqblk *)bp->b_addr;
>  	xfs_failaddr_t		fa;
> @@ -216,8 +222,13 @@ xfs_dquot_buf_verify(
>  			id = be32_to_cpu(ddq->d_id);
>  
>  		fa = xfs_dqblk_verify(mp, &dqb[i], id + i, 0);
> -		if (fa)
> +		if (fa) {
> +			if (!readahead)
> +				xfs_buf_verifier_error(bp, -EFSCORRUPTED,
> +					__func__, &dqb[i],
> +					sizeof(struct xfs_dqblk), fa);
>  			return fa;
> +		}
>  	}
>  
>  	return NULL;
> @@ -229,7 +240,7 @@ xfs_dquot_buf_verify_struct(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	return xfs_dquot_buf_verify(mp, bp);
> +	return xfs_dquot_buf_verify(mp, bp, false);
>  }
>  
>  static void
> @@ -237,15 +248,10 @@ xfs_dquot_buf_read_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> -	xfs_failaddr_t		fa;
>  
> -	if (!xfs_dquot_buf_verify_crc(mp, bp))
> -		xfs_verifier_error(bp, -EFSBADCRC, __this_address);
> -	else {
> -		fa = xfs_dquot_buf_verify(mp, bp);
> -		if (fa)
> -			xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> -	}
> +	if (!xfs_dquot_buf_verify_crc(mp, bp, false))
> +		return;
> +	xfs_dquot_buf_verify(mp, bp, false);
>  }
>  
>  /*
> @@ -260,8 +266,8 @@ xfs_dquot_buf_readahead_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  
> -	if (!xfs_dquot_buf_verify_crc(mp, bp) ||
> -	    xfs_dquot_buf_verify(mp, bp) != NULL) {
> +	if (!xfs_dquot_buf_verify_crc(mp, bp, true) ||
> +	    xfs_dquot_buf_verify(mp, bp, true) != NULL) {
>  		xfs_buf_ioerror(bp, -EIO);
>  		bp->b_flags &= ~XBF_DONE;
>  	}
> @@ -277,11 +283,8 @@ xfs_dquot_buf_write_verify(
>  	struct xfs_buf		*bp)
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
> -	xfs_failaddr_t		fa;
>  
> -	fa = xfs_dquot_buf_verify(mp, bp);
> -	if (fa)
> -		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
> +	xfs_dquot_buf_verify(mp, bp, false);
>  }
>  
>  const struct xfs_buf_ops xfs_dquot_buf_ops = {
> -- 
> 2.17.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
