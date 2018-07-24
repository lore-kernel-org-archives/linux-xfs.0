Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:44548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388651AbeGXWHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Jul 2018 18:07:23 -0400
Date: Tue, 24 Jul 2018 13:27:43 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2 03/15] xfs: fix transaction leak on remote attr
 set/remove failure
Message-ID: <20180724202743.GB4813@magnolia>
References: <20180723130414.47980-1-bfoster@redhat.com>
 <20180723130414.47980-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180723130414.47980-4-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Jul 23, 2018 at 09:04:02AM -0400, Brian Foster wrote:
> The xattr remote value set/remove handlers both clear args.trans in
> the error path without having cancelled the transaction. This leaks
> the transaction, causes warnings around returning to userspace with
> locks held and leads to system lockups or other general problems.
> 
> The higher level xfs_attr_[set|remove]() functions already detect
> and cancel args.trans when set in the error path. Drop the NULL
> assignments from the rmtval handlers and allow the callers to clean
> up the transaction correctly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 7841e6255129..829ab20f0cd7 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -558,7 +558,6 @@ xfs_attr_rmtval_set(
>  	return 0;
>  out_defer_cancel:
>  	xfs_defer_cancel(args->trans->t_dfops);
> -	args->trans = NULL;
>  	return error;
>  }
>  
> @@ -646,6 +645,5 @@ xfs_attr_rmtval_remove(
>  	return 0;
>  out_defer_cancel:
>  	xfs_defer_cancel(args->trans->t_dfops);
> -	args->trans = NULL;
>  	return error;
>  }
> -- 
> 2.17.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
