Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51878 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750764AbeDQEfy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Apr 2018 00:35:54 -0400
Subject: Re: [PATCH V3] xfs: enhance dinode verifier
From: Eric Sandeen <sandeen@sandeen.net>
References: <a1454c1f-e01a-5570-85d3-d55181c9ddd3@redhat.com>
 <c80d14ca-2d47-86f7-62f8-90affb06cef7@sandeen.net>
 <1ffdb61f-d642-1310-a5df-0f166d90aa28@sandeen.net>
Message-ID: <5afa3a18-80dd-d794-bb3e-09226ed37ab5@sandeen.net>
Date: Mon, 16 Apr 2018 23:35:52 -0500
MIME-Version: 1.0
In-Reply-To: <1ffdb61f-d642-1310-a5df-0f166d90aa28@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>
Cc: wen.xu@gatech.edu



On 4/13/18 10:54 AM, Eric Sandeen wrote:
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

Darrick, maybe also add:

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=199377

If you still can

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: due credit 
> V3: clarify the no-offset / no-format cases in a comment
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index ef68b1d..ee8ed90 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -466,6 +466,8 @@
>  				return __this_address;
>  			if (di_size > XFS_DFORK_DSIZE(dip, mp))
>  				return __this_address;
> +			if (dip->di_nextents)
> +				return __this_address;
>  			/* fall through */
>  		case XFS_DINODE_FMT_EXTENTS:
>  		case XFS_DINODE_FMT_BTREE:
> @@ -484,12 +486,31 @@
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
> +	} else {
> +		/*
> +		 * If there is no fork offset, this may be a freshly-made inode
> +		 * in a new disk cluster, in which case di_aformat is zeroed.
> +		 * Otherwise, such an inode must be in EXTENTS format; this goes
> +		 * for freed inodes as well.
> +		 */
> +		switch (dip->di_aformat) {
> +		case 0:
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
