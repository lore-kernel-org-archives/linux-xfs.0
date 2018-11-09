Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43016 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728001AbeKJJXv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 10 Nov 2018 04:23:51 -0500
Date: Fri, 9 Nov 2018 15:40:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] Fix misspelling issue in fs/xfs/kmem.c
Message-ID: <20181109234056.GH15721@magnolia>
References: <20181109232301.19977-1-weizhefix@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181109232301.19977-1-weizhefix@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: hmsjwzb <weizhefix@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Sat, Nov 10, 2018 at 07:23:01AM +0800, hmsjwzb wrote:

Sorry, but all submissions must have a Signed-off-by: to be reviewed.

Also, there's no To: header on this message??

NAK.

--D

> ---
>  fs/xfs/kmem.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index fdd9d6ede25c..73ec1f84e591 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -45,7 +45,7 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  		return ptr;
>  
>  	/*
> -	 * __vmalloc() will allocate data pages and auxillary structures (e.g.
> +	 * __vmalloc() will allocate data pages and auxiliary structures (e.g.
>  	 * pagetables) with GFP_KERNEL, yet we may be under GFP_NOFS context
>  	 * here. Hence we need to tell memory reclaim that we are in such a
>  	 * context via PF_MEMALLOC_NOFS to prevent memory reclaim re-entering
> -- 
> 2.17.1
> 
