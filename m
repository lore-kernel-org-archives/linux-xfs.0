Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31004 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754883AbdDFXXd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2017 19:23:33 -0400
Date: Thu, 6 Apr 2017 16:23:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: simplify xfs_calc_dquots_per_chunk
Message-ID: <20170406232327.GD4864@birch.djwong.org>
References: <b99b73b5-9525-bf50-ecd4-ccb361545b12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b99b73b5-9525-bf50-ecd4-ccb361545b12@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Apr 05, 2017 at 04:03:17PM -0500, Eric Sandeen wrote:
> ndquots is a 32-bit value, and we don't care
> about the remainder; there is no reason to use do_div
> here, it seems to be the result of a decade+ historical
> accident.
> 
> Worse, the do_div implementation in userspace breaks
> when fed a 32-bit dividend, so we commented it out there
> in any case.
> 
> Change to simple division, and then we can change
> userspace to match, and mandate a 64-bit dividend in
> the do_div() in userspace as well.

This looks fine since nbblks is (unsigned int) and BBTOB doesn't cast to
a 64-bit quantity, therefore 64-bit division isn't ncessary.  This
passes compilation on i386 and armhf, so I guess I'll go test it.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> --- 
> 
> tested w/ ./check -g quota
> 
> diff --git a/fs/xfs/libxfs/xfs_dquot_buf.c b/fs/xfs/libxfs/xfs_dquot_buf.c
> index ac9a003..747085b 100644
> --- a/fs/xfs/libxfs/xfs_dquot_buf.c
> +++ b/fs/xfs/libxfs/xfs_dquot_buf.c
> @@ -35,13 +35,8 @@
>  xfs_calc_dquots_per_chunk(
>  	unsigned int		nbblks)	/* basic block units */
>  {
> -	unsigned int	ndquots;
> -
>  	ASSERT(nbblks > 0);
> -	ndquots = BBTOB(nbblks);
> -	do_div(ndquots, sizeof(xfs_dqblk_t));
> -
> -	return ndquots;
> +	return BBTOB(nbblks) / sizeof(xfs_dqblk_t);
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
