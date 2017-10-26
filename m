Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36105 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932317AbdJZQDd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2017 12:03:33 -0400
Date: Thu, 26 Oct 2017 09:03:28 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 12/14] xfs: convert remaingin xfs_sb_version_... checks
 to bool
Message-ID: <20171026160328.GV5483@magnolia>
References: <20171026083322.20428-1-david@fromorbit.com>
 <20171026083322.20428-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171026083322.20428-13-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2017 at 07:33:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Some were missed in the pass that converted the function return
> values from int to bool. Update the remaining ones for consistency.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_format.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d4d9bef20c3a..3fb6d2a96d36 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -505,12 +505,12 @@ xfs_sb_has_incompat_log_feature(
>  /*
>   * V5 superblock specific feature checks
>   */
> -static inline int xfs_sb_version_hascrc(struct xfs_sb *sbp)
> +static inline bool xfs_sb_version_hascrc(struct xfs_sb *sbp)
>  {
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>  }
>  
> -static inline int xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
> +static inline bool xfs_sb_version_has_pquotino(struct xfs_sb *sbp)
>  {
>  	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5;
>  }
> -- 
> 2.15.0.rc0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
