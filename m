Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45668 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933353AbeGJOn1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jul 2018 10:43:27 -0400
Date: Tue, 10 Jul 2018 07:43:11 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] common/xfs: remove bad xfs_repair -t option
Message-ID: <20180710144311.GY32415@magnolia>
References: <20180710094129.1052-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180710094129.1052-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Zorro Lang <zlang@redhat.com>
Cc: fstests@vger.kernel.org, linux-xfs@vger.kernel.org

On Tue, Jul 10, 2018 at 05:41:29PM +0800, Zorro Lang wrote:
> The xfs_repair "-t" option shouldn't be used alone. An interval must
> follow the -t option, or xfs_repair will report errors. And only
> modify reporting interval is useless, if we don't enable ag_stride.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>

Makes sense to me, at least given the getopt arg ("t:") in xfs_repair.c.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> Hi,
> 
> I don't know why we must need the -t option for xfs_repair, I can't
> find any description to explain it. But I can find an explanation
> about why we use "-t" for _xfs_check.
> 
>   # xfs_check runs out of memory on large files, so even providing the test
>   # option (-t) to avoid indexing the free space trees doesn't make it pass on
>   # large filesystems. Avoid it.
> 
> The -t option for xfs_repair is totally different with it for
> xfs_check, maybe -m option is more useful if we think about the
> memory size.
> 
> And the -t option need to work with -o ag_stride together. I'd like
> to remove the "-t" option directly, due to I really don't know why
> we need it, or how to give it a proper number.
> 
> If the original author knows why we need it, and can give me some
> suggestions, please help.
> 
> Thanks,
> Zorro
> 
>  common/xfs | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/common/xfs b/common/xfs
> index ecf54bbf..61a3c2d9 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -193,7 +193,6 @@ _scratch_xfs_repair()
>  		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
>  	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
>  		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -r$SCRATCH_RTDEV"
> -	[ "$LARGE_SCRATCH_DEV" = yes ] && SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
>  	$XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
>  }
>  
> -- 
> 2.14.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
