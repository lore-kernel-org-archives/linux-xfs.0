Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:51144 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbeIRIV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Sep 2018 04:21:56 -0400
Date: Mon, 17 Sep 2018 19:51:15 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: remove duplicated include from alloc.c
Message-ID: <20180918025114.GB20086@magnolia>
References: <20180918020734.23180-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918020734.23180-1-yuehaibing@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: YueHaibing <yuehaibing@huawei.com>
Cc: linux-xfs@vger.kernel.org, dchinner@redhat.com, bfoster@redhat.com, linux-kernel@vger.kernel.org

On Tue, Sep 18, 2018 at 10:07:34AM +0800, YueHaibing wrote:
> Remove duplicated include xfs_alloc.h
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/scrub/alloc.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
> index 036b5c7..376bcb5 100644
> --- a/fs/xfs/scrub/alloc.c
> +++ b/fs/xfs/scrub/alloc.c
> @@ -17,7 +17,6 @@
>  #include "xfs_sb.h"
>  #include "xfs_alloc.h"
>  #include "xfs_rmap.h"
> -#include "xfs_alloc.h"
>  #include "scrub/xfs_scrub.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
> -- 
> 2.7.0
> 
> 
