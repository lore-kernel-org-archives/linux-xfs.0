Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:51718 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfAaXYR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Jan 2019 18:24:17 -0500
Date: Thu, 31 Jan 2019 15:24:05 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH -next] xfs: remove duplicated xfs_defer.h
Message-ID: <20190131232405.GE5761@magnolia>
References: <20190117070217.12432-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190117070217.12432-1-yuehaibing@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: YueHaibing <yuehaibing@huawei.com>
Cc: linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org

On Thu, Jan 17, 2019 at 03:02:17PM +0800, YueHaibing wrote:
> Remove duplicated include.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks fine to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_trans_bmap.c     | 1 -
>  fs/xfs/xfs_trans_extfree.c  | 1 -
>  fs/xfs/xfs_trans_refcount.c | 1 -
>  fs/xfs/xfs_trans_rmap.c     | 1 -
>  4 files changed, 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
> index 11cff44..e1c7d55 100644
> --- a/fs/xfs/xfs_trans_bmap.c
> +++ b/fs/xfs/xfs_trans_bmap.c
> @@ -17,7 +17,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_inode.h"
> -#include "xfs_defer.h"
>  
>  /*
>   * This routine is called to allocate a "bmap update done"
> diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
> index 0710434..8ee7a3f 100644
> --- a/fs/xfs/xfs_trans_extfree.c
> +++ b/fs/xfs/xfs_trans_extfree.c
> @@ -18,7 +18,6 @@
>  #include "xfs_alloc.h"
>  #include "xfs_bmap.h"
>  #include "xfs_trace.h"
> -#include "xfs_defer.h"
>  
>  /*
>   * This routine is called to allocate an "extent free done"
> diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
> index 6c947ff..8d73472 100644
> --- a/fs/xfs/xfs_trans_refcount.c
> +++ b/fs/xfs/xfs_trans_refcount.c
> @@ -16,7 +16,6 @@
>  #include "xfs_refcount_item.h"
>  #include "xfs_alloc.h"
>  #include "xfs_refcount.h"
> -#include "xfs_defer.h"
>  
>  /*
>   * This routine is called to allocate a "refcount update done"
> diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
> index a428909..5c7936b 100644
> --- a/fs/xfs/xfs_trans_rmap.c
> +++ b/fs/xfs/xfs_trans_rmap.c
> @@ -16,7 +16,6 @@
>  #include "xfs_rmap_item.h"
>  #include "xfs_alloc.h"
>  #include "xfs_rmap.h"
> -#include "xfs_defer.h"
>  
>  /* Set the map extent flags for this reverse mapping. */
>  static void
> -- 
> 2.7.0
> 
> 
