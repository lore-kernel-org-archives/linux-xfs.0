Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:31065 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753073AbdLNWD3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Dec 2017 17:03:29 -0500
Date: Fri, 15 Dec 2017 09:03:26 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/13] xfs: refactor verifier callers to print address of
 failing check
Message-ID: <20171214220326.GI5858@dastard>
References: <151320949282.30654.14805160700975182459.stgit@magnolia>
 <151320951732.30654.12381419566973424218.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151320951732.30654.12381419566973424218.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Dec 13, 2017 at 03:58:37PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the callers of verifiers to print the instruction address of a
> failing check.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Just a quick comment about formatting as I browsed the patch...

> @@ -567,13 +568,14 @@ xfs_agfl_read_verify(
>  	if (!xfs_sb_version_hascrc(&mp->m_sb))
>  		return;
>  
> -	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
> +	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF)) {
> +		fa = __this_address;
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_agfl_verify(bp))
> +	} else if ((fa = xfs_agfl_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, fa);

We are really trying to get rid of assignments in if() statements,
so I'd prefer we don't add a bunch of new ones. While I understand
there's a lot of mechanical change in this patch, I'd prefer to see
these end up as something more like:

> -	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF))
> +	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF)) {
> +		fa = __this_address;
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (xfs_agfl_verify(bp))
> +	} else if ((fa = xfs_agfl_verify(bp)))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);

	if (!xfs_buf_verify_cksum(bp, XFS_AGFL_CRC_OFF)) {
		fa = __this_address;
		error = -EFSBADCRC;
	} else {
		fa = xfs_agfl_verify(bp);
		if (fa)
			error = -EFSCORRUPTED;
	}

	if (error) {
		xfs_buf_ioerror(bp, error);
		xfs_verifier_error(bp, fa);
	}

.....

> @@ -2459,16 +2462,18 @@ xfs_agf_read_verify(
>  	struct xfs_buf	*bp)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> +	xfs_failaddr_t	fa;
>  
>  	if (xfs_sb_version_hascrc(&mp->m_sb) &&
> -	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF))
> +	    !xfs_buf_verify_cksum(bp, XFS_AGF_CRC_OFF)) {
> +		fa = __this_address;
>  		xfs_buf_ioerror(bp, -EFSBADCRC);
> -	else if (XFS_TEST_ERROR(xfs_agf_verify(mp, bp), mp,
> -				XFS_ERRTAG_ALLOC_READ_AGF))
> +	} else if (XFS_TEST_ERROR((fa = xfs_agf_verify(mp, bp)), mp,
> +				  XFS_ERRTAG_ALLOC_READ_AGF))
>  		xfs_buf_ioerror(bp, -EFSCORRUPTED);
>  
>  	if (bp->b_error)
> -		xfs_verifier_error(bp);
> +		xfs_verifier_error(bp, fa);
>  }

Because this sort of thing is now getting towards being unreadable.
With the way we keep adding to verifier checks, it's only going to
get worse if we don't take steps to clean it up...

> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index 4c9f35d..0bbbf0b 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -347,13 +347,15 @@ xfs_corruption_error(
>   */
>  void
>  xfs_verifier_error(
> -	struct xfs_buf		*bp)
> +	struct xfs_buf		*bp,
> +	xfs_failaddr_t		fa)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  
>  	xfs_alert(mp, "Metadata %s detected at %pS, %s block 0x%llx",
>  		  bp->b_error == -EFSBADCRC ? "CRC error" : "corruption",
> -		  __return_address, bp->b_ops->name, bp->b_bn);
> +		  fa ? fa : __return_address, bp->b_ops->name,
> +		  bp->b_bn);
>  
>  	xfs_alert(mp, "Unmount and run xfs_repair");

I'm also wondering if we should move the xfs_buf_ioerror() call
inside this function, too, rather than coding multiple calls in the
verifiers to set bp->b_error in each branch of the verifier that
has an error...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
