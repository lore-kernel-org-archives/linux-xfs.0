Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:60854 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729888AbeHBCyO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 22:54:14 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w720x2aW036520
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 01:05:41 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by aserp2120.oracle.com with ESMTP id 2kggep81b7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 02 Aug 2018 01:05:40 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7215ew9014231
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 01:05:40 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7215e3b008778
        for <linux-xfs@vger.kernel.org>; Thu, 2 Aug 2018 01:05:40 GMT
Date: Wed, 1 Aug 2018 18:05:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: only validate summary counts on primary superblock
Message-ID: <20180802010538.GN30972@magnolia>
References: <20180801231855.GL30972@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180801231855.GL30972@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: xfs <linux-xfs@vger.kernel.org>

On Wed, Aug 01, 2018 at 04:18:55PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Skip the summary counter checks for secondary superblocks because
> userspace has always written the secondary supers with zeroed counters.
> mkfs.xfs fails immediately without this patch.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Bleh, self-NAK on this, never mind.

--D

> ---
>  fs/xfs/libxfs/xfs_sb.c |   12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index ca1b3a7a9171..47e1dd4a5009 100644
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
> @@ -155,10 +156,13 @@ xfs_validate_sb_write(
>  	 * the superblock.  We skip this in the read validator because there
>  	 * could be newer superblocks in the log and if the values are garbage
>  	 * even after replay we'll recalculate them at the end of log mount.
> +	 * We only check the primary superblock to allow userspace tools to
> +	 * write secondary superblocks with zeroed counters.
>  	 */
> -	if (sbp->sb_fdblocks > sbp->sb_dblocks ||
> -	    !xfs_verify_icount(mp, sbp->sb_icount) ||
> -	    sbp->sb_ifree > sbp->sb_icount) {
> +	if (XFS_BUF_ADDR(bp) == XFS_SB_DADDR &&
> +	    (sbp->sb_fdblocks > sbp->sb_dblocks ||
> +	     !xfs_verify_icount(mp, sbp->sb_icount) ||
> +	     sbp->sb_ifree > sbp->sb_icount)) {
>  		xfs_warn(mp, "SB summary counter sanity check failed");
>  		return -EFSCORRUPTED;
>  	}
> @@ -756,7 +760,7 @@ xfs_sb_write_verify(
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
