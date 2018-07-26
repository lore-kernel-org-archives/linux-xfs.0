Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44276 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730292AbeGZTnb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jul 2018 15:43:31 -0400
Date: Thu, 26 Jul 2018 13:25:29 -0500
From: Bill O'Donnell <billodo@redhat.com>
Subject: Re: [PATCH 1/2] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180726182529.GB20780@redhat.com>
References: <153262651940.8934.17525988748289196893.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153262651940.8934.17525988748289196893.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 26, 2018 at 10:35:19AM -0700, Darrick J. Wong wrote:
> From: Bill O'Donnell <billodo@redhat.com>
> 
> Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> Add sanity checks for these parameters.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> [darrick: remove the icount check, tweak the comments a little]
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by:
Bill O'Donnell <billodo@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |   45 +++++++++++++++++++++++++++++++++++----------
>  1 file changed, 35 insertions(+), 10 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index b3ad15956366..b2c683588519 100644
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
> @@ -693,9 +694,33 @@ xfs_sb_write_verify(
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
> +	if (error)
> +		goto err;
> +
> +	/*
> +	 * Carry out additional sb sanity checks exclusively for writes.
> +	 * We don't do these checks for reads, since faulty parameters could
> +	 * be fixed in the log, and we shouldn't prohibit mounting for those
> +	 * cases.
> +	 */
> +	if (sb.sb_fdblocks > sb.sb_dblocks ||
> +	    sb.sb_ifree > sb.sb_icount) {
> +		xfs_notice(mp, "SB summary counter sanity check failed");
> +		error = -EFSCORRUPTED;
> +		goto err;
> +	}
> +
> +err:
>  	if (error) {
>  		xfs_verifier_error(bp, error, __this_address);
>  		return;
> 
