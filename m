Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38072 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729335AbeGYXBa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jul 2018 19:01:30 -0400
Date: Wed, 25 Jul 2018 14:47:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v3] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180725214747.GB4218@magnolia>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180725213336.16263-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180725213336.16263-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jul 25, 2018 at 04:33:36PM -0500, Bill O'Donnell wrote:
> Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> Add sanity checks for these parameters.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v3: eliminate need for additional write_flag, doing those
>     unique checks in xfs_sb_write_verify()
> v2: make extra sanity checks exclusive to writes
> 
> 
>  fs/xfs/libxfs/xfs_sb.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b3ad15956366..f583fb8a10e1 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -599,22 +599,16 @@ xfs_sb_to_disk(
>  static int
>  xfs_sb_verify(
>  	struct xfs_buf	*bp,
> +	struct xfs_sb	*sb,
>  	bool		check_version)
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
> -	struct xfs_sb	sb;
> -
> -	/*
> -	 * Use call variant which doesn't convert quota flags from disk 
> -	 * format, because xfs_mount_validate_sb checks the on-disk flags.
> -	 */
> -	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
>  
>  	/*
>  	 * Only check the in progress field for the primary superblock as
>  	 * mkfs.xfs doesn't clear it from secondary superblocks.
>  	 */
> -	return xfs_mount_validate_sb(mp, &sb,
> +	return xfs_mount_validate_sb(mp, sb,
>  				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
>  				     check_version);
>  }
> @@ -637,6 +631,7 @@ xfs_sb_read_verify(
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_dsb	*dsb = XFS_BUF_TO_SBP(bp);
> +	struct xfs_sb	sb;
>  	int		error;
>  
>  	/*
> @@ -657,7 +652,13 @@ xfs_sb_read_verify(
>  			}
>  		}
>  	}
> -	error = xfs_sb_verify(bp, true);
> +
> +	/*
> +	 * Use call variant which doesn't convert quota flags from disk
> +	 * format, because xfs_mount_validate_sb checks the on-disk flags.
> +	 */
> +	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +	error = xfs_sb_verify(bp, &sb, true);
>  
>  out_error:
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> @@ -693,9 +694,26 @@ xfs_sb_write_verify(
>  {
>  	struct xfs_mount	*mp = bp->b_target->bt_mount;
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> +	struct xfs_sb		sb;
>  	int			error;
>  
> -	error = xfs_sb_verify(bp, false);
> +	/*
> +	 * Use call variant which doesn't convert quota flags from disk
> +	 * format, because xfs_mount_validate_sb checks the on-disk flags.
> +	 */
> +	__xfs_sb_from_disk(&sb, XFS_BUF_TO_SBP(bp), false);
> +
> +	error = xfs_sb_verify(bp, &sb, false);
> +
> +	/* Additional sb sanity checks for writes */
> +	if (!error) {
> +		if (sb.sb_fdblocks > sb.sb_dblocks ||
> +		    sb.sb_ifree > sb.sb_icount) {
> +			    xfs_notice(mp, "SB sanity check failed");
> +			    error = -EFSCORRUPTED;
> +		}
> +	}

On the off chance that some day we add more write-time checks, could you
please structure this the usual way?

	error = xfs_sb_verify(bp, &sb, false);
	if (error)
		goto err;

	if (sb.sb_fdblocks > sb.sb_dblocks || sb.sb_ifree > sb.sb_icount) {
		xfs_notice(mp, "SB summary counter sanity check failed");
		error = -EFSCORRUPTED;
		goto err;
	}

err:
	if (error) {
		xfs_verifier_error(bp, error, __this_address);
		return;
	}
}

Other than that, this looks ok to me.

--D

> +
>  	if (error) {
>  		xfs_verifier_error(bp, error, __this_address);
>  		return;
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
