Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:36382 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbeDMD4k (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Apr 2018 23:56:40 -0400
Date: Thu, 12 Apr 2018 20:56:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: enhance dinode verifier
Message-ID: <20180413035632.GB32099@magnolia>
References: <a1454c1f-e01a-5570-85d3-d55181c9ddd3@redhat.com>
 <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, wen.xu@gatech.edu

On Thu, Apr 12, 2018 at 09:55:41PM -0500, Eric Sandeen wrote:
> Add several more validations to xfs_dinode_verify:
> 
> - For LOCAL data fork formats, di_nextents must be 0.
> - For LOCAL attr fork formats, di_anextents must be 0.
> - For inodes with no attr fork offset,
>   - format must be XFS_DINODE_FMT_EXTENTS if set at all
>   - di_anextents must be 0.
> 
> Thanks to dchinner for pointing out a couple related checks I had
> forgotten to add.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: due credit :)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 4fe17b368316..72ab4d2df8cf 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -458,6 +458,8 @@ xfs_dinode_verify(
>  				return __this_address;
>  			if (di_size > XFS_DFORK_DSIZE(dip, mp))
>  				return __this_address;
> +			if (dip->di_nextents)
> +				return __this_address;
>  			/* fall through */
>  		case XFS_DINODE_FMT_EXTENTS:
>  		case XFS_DINODE_FMT_BTREE:
> @@ -476,12 +478,25 @@ xfs_dinode_verify(
>  	if (XFS_DFORK_Q(dip)) {
>  		switch (dip->di_aformat) {
>  		case XFS_DINODE_FMT_LOCAL:
> +			if (dip->di_anextents)
> +				return __this_address;
> +		/* fall through */
>  		case XFS_DINODE_FMT_EXTENTS:
>  		case XFS_DINODE_FMT_BTREE:
>  			break;
>  		default:
>  			return __this_address;
>  		}
> +	} else {	/* No attr fork */
> +		switch (dip->di_aformat) {
> +		case 0:	/* Uninitialized OK */

Might be a good idea to point out that a newly allocated inode chunk
will have all these fields set to zero (as I apparently stumble over
this about once every 10-11 months).

Also, uh, does xfs_repair catch these? :D

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +		case XFS_DINODE_FMT_EXTENTS:
> +			break;
> +		default:
> +			return __this_address;
> +		}
> +		if (dip->di_anextents)
> +			return __this_address;
>  	}
>  
>  	/* only version 3 or greater inodes are extensively verified here */
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
