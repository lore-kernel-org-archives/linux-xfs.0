Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32133 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752055AbdK1CUU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Nov 2017 21:20:20 -0500
Date: Mon, 27 Nov 2017 18:20:14 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: fix uninitialized variable in xfs_scrub_quota
Message-ID: <20171128022014.GD21412@magnolia>
References: <8ac42102-7147-a373-5e2c-a984e1bdbe00@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8ac42102-7147-a373-5e2c-a984e1bdbe00@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Nov 27, 2017 at 04:57:36PM -0600, Eric Sandeen wrote:
> On the first pass through the while(1) loop, we get to
> xfs_scrub_should_terminate() which can test the uninitialized 
> error variable.
> 
> Fixes-coverity-id: 1423737
> Fixes: c2fc338c ("xfs: scrub quota information")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok, will test...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
> 
> compile-tested only
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index 8e58ba8..613def9 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -207,7 +207,7 @@
>  	xfs_dqid_t			id = 0;
>  	uint				dqtype;
>  	int				nimaps;
> -	int				error;
> +	int				error = 0;
>  
>  	if (!XFS_IS_QUOTA_RUNNING(mp) || !XFS_IS_QUOTA_ON(mp))
>  		return -ENOENT;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
