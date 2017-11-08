Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44862 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752436AbdKHUA7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2017 15:00:59 -0500
Date: Wed, 8 Nov 2017 12:00:56 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] fs/xfs: Remove NULL check before kmem_cache_destroy
Message-ID: <20171108200056.GF26910@magnolia>
References: <20171108185310.GA104610@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171108185310.GA104610@debian>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Tim Hansen <devtimhansen@gmail.com>
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 08, 2017 at 01:53:10PM -0500, Tim Hansen wrote:
> kmem_cache_destroy already checks for null values.
> 
> Signed-off-by: Tim Hansen <devtimhansen@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/kmem.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 7509019..4b87472 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -119,8 +119,7 @@ kmem_zone_free(kmem_zone_t *zone, void *ptr)
>  static inline void
>  kmem_zone_destroy(kmem_zone_t *zone)
>  {
> -	if (zone)
> -		kmem_cache_destroy(zone);
> +	kmem_cache_destroy(zone);
>  }
>  
>  extern void *kmem_zone_alloc(kmem_zone_t *, xfs_km_flags_t);
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
