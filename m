Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:43790 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbfBUPyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Feb 2019 10:54:38 -0500
Date: Thu, 21 Feb 2019 07:54:31 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH][xfs-next] xfs: fix uninitialized error variable
Message-ID: <20190221155431.GQ32253@magnolia>
References: <20190221112224.3748-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190221112224.3748-1-colin.king@canonical.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Colin King <colin.king@canonical.com>
Cc: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Dave Chinner <dchinner@redhat.com>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 21, 2019 at 11:22:24AM +0000, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> A previous commit removed the initialization of variable 'error' to zero,
> and can cause a bogus error return.  This occurs when error contains a
> non-zero garbage value and the call to xchk_should_terminate detects a
> pending fatal signal and checks for a zero error before setting it
> to -EAGAIN. Fix the issue by initializing error to zero.
> 
> Fixes: b9454fe056bd ("xfs: clean up the inode cluster checking in the inobt scrub")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thank you for the cleanup!

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/scrub/ialloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
> index 2c9dad2b61b1..700114f79a7d 100644
> --- a/fs/xfs/scrub/ialloc.c
> +++ b/fs/xfs/scrub/ialloc.c
> @@ -161,7 +161,7 @@ xchk_iallocbt_check_cluster_ifree(
>  	bool				irec_free;
>  	bool				ino_inuse;
>  	bool				freemask_ok;
> -	int				error;
> +	int				error = 0;
>  
>  	if (xchk_should_terminate(bs->sc, &error))
>  		return error;
> -- 
> 2.20.1
> 
