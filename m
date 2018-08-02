Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54422 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbeHBLLL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Aug 2018 07:11:11 -0400
Received: by mail-wm0-f66.google.com with SMTP id c14-v6so1661552wmb.4
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 02:20:54 -0700 (PDT)
Date: Thu, 2 Aug 2018 11:20:50 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH v2] xfs: only validate summary counts on primary
 superblock
Message-ID: <20180802092050.wc4qoscerrrek5k2@odin.usersys.redhat.com>
References: <20180802061331.GP30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180802061331.GP30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 11:13:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip the summary counter checks for secondary superblocks and inprogress
> primary superblocks because mkfs has always written those out with
> zeroed summary counters.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: add the inprogress check
> ---

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

>  fs/xfs/libxfs/xfs_sb.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ca1b3a7a9171..081f46e30556 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -148,6 +148,7 @@ xfs_validate_sb_read(
>  STATIC int
>  xfs_validate_sb_write(
>  	struct xfs_mount	*mp,
> +	struct xfs_buf		*bp,
>  	struct xfs_sb		*sbp)
>  {
>  	/*
> @@ -155,10 +156,15 @@ xfs_validate_sb_write(
>  	 * the superblock.  We skip this in the read validator because there
>  	 * could be newer superblocks in the log and if the values are garbage
>  	 * even after replay we'll recalculate them at the end of log mount.
> +	 *
> +	 * mkfs has traditionally written zeroed counters to inprogress and
> +	 * secondary superblocks, so allow this usage to continue because
> +	 * we never read counters from such superblocks.
>  	 */
> -	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> -	    !xfs_verify_icount(mp, sbp->sb_icount) ||
> -	    sbp->sb_ifree > sbp->sb_icount) {
> +	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR && !sbp->sb_inprogress &&
> +	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
> +	     !xfs_verify_icount(mp, sbp->sb_icount) ||
> +	     sbp->sb_ifree > sbp->sb_icount)) {
>  		xfs_warn(mp, "SB summary counter sanity check failed");
>  		return -EFSCORRUPTED;
>  	}
> @@ -756,7 +762,7 @@ xfs_sb_write_verify(
>  	error = xfs_validate_sb_common(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
> -	error = xfs_validate_sb_write(mp, &sb);
> +	error = xfs_validate_sb_write(mp, bp, &sb);
>  	if (error)
>  		goto out_error;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
