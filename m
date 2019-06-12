Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:43714 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbfFLPCD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Jun 2019 11:02:03 -0400
Date: Wed, 12 Jun 2019 08:01:55 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] mkfs: remove useless log options in usage
Message-ID: <20190612150155.GA3773859@magnolia>
References: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560330575-2209-1-git-send-email-xuyang2018.jy@cn.fujitsu.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 05:09:35PM +0800, Yang Xu wrote:
> Since commit 2cf637cf(mkfs: remove logarithm based CLI options),
> xfsprogs has discarded log options in node_options, remove it in usage.
> 
> Signed-off-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index db3ad38e..91391b72 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -858,7 +858,7 @@ usage( void )
>  			    (sunit=value,swidth=value|su=num,sw=num|noalign),\n\
>  			    sectsize=num\n\
>  /* force overwrite */	[-f]\n\
> -/* inode size */	[-i log=n|perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
> +/* inode size */	[-i perblock=n|size=num,maxpct=n,attr=0|1|2,\n\
>  			    projid32bit=0|1,sparse=0|1]\n\
>  /* no discard */	[-K]\n\
>  /* log subvol */	[-l agnum=n,internal,size=num,logdev=xxx,version=n\n\
> -- 
> 2.18.1
> 
> 
> 
