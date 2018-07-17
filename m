Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36955 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbeGQJtY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jul 2018 05:49:24 -0400
Received: by mail-wr1-f67.google.com with SMTP id q10-v6so490059wrd.4
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jul 2018 02:17:45 -0700 (PDT)
Date: Tue, 17 Jul 2018 11:17:41 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] libxfs: add more bounds checking to sb sanity checks
Message-ID: <20180717091741.i5qztlxpmauh7bqx@odin.usersys.redhat.com>
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180716192655.27792-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180716192655.27792-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 16, 2018 at 02:26:55PM -0500, Bill O'Donnell wrote:
> Current sb verifier doesn't check bounds on sb_fdblocks and sb_ifree.
> Add sanity checks for these parameters.
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
> v2: make extra sanity checks exclusive to writes (allow read)

It looks mostly ok for me, I'm still wondering if it wouldn't be better to avoid
adding a write_flag argument for xfs_sb_verify, but I think avoiding it would
require some refactoring of the sb verify code, once we convert from BE to CPU
in xfs_sb_verify, and I'm not sure if it is worth.

So,

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
>  fs/xfs/libxfs/xfs_sb.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index 350119eeaecb..6a98ec68e8ad 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -104,7 +104,8 @@ xfs_mount_validate_sb(
>  	xfs_mount_t	*mp,
>  	xfs_sb_t	*sbp,
>  	bool		check_inprogress,
> -	bool		check_version)
> +	bool		check_version,
> +	bool		write_flag)
>  {
>  	uint32_t	agcount = 0;
>  	uint32_t	rem;
> @@ -266,6 +267,15 @@ xfs_mount_validate_sb(
>  		return -EFSCORRUPTED;
>  	}
>  
> +	/* Additional sb sanity checks for writes */
> +	if (write_flag) {
> +		if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> +		    sbp->sb_ifree > sbp->sb_icount) {
> +			    xfs_notice(mp, "SB sanity check failed");
> +			    return -EFSCORRUPTED;
> +		}
> +	}
> +
>  	if (sbp->sb_unit) {
>  		if (!xfs_sb_version_hasdalign(sbp) ||
>  		    sbp->sb_unit > sbp->sb_width ||
> @@ -599,7 +609,9 @@ xfs_sb_to_disk(
>  static int
>  xfs_sb_verify(
>  	struct xfs_buf	*bp,
> -	bool		check_version)
> +	bool		check_version,
> +	bool		write_flag)
> +
>  {
>  	struct xfs_mount *mp = bp->b_target->bt_mount;
>  	struct xfs_sb	sb;
> @@ -616,7 +628,7 @@ xfs_sb_verify(
>  	 */
>  	return xfs_mount_validate_sb(mp, &sb,
>  				     bp->b_maps[0].bm_bn == XFS_SB_DADDR,
> -				     check_version);
> +				     check_version, write_flag);
>  }
>  
>  /*
> @@ -657,7 +669,7 @@ xfs_sb_read_verify(
>  			}
>  		}
>  	}
> -	error = xfs_sb_verify(bp, true);
> +	error = xfs_sb_verify(bp, true, false);
>  
>  out_error:
>  	if (error == -EFSCORRUPTED || error == -EFSBADCRC)
> @@ -695,7 +707,7 @@ xfs_sb_write_verify(
>  	struct xfs_buf_log_item	*bip = bp->b_log_item;
>  	int			error;
>  
> -	error = xfs_sb_verify(bp, false);
> +	error = xfs_sb_verify(bp, false, true);
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

-- 
Carlos
