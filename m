Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1881F7F56
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 15:58:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0BA97304032
	for <xfs@oss.sgi.com>; Fri,  1 Nov 2013 13:58:09 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wD16ECEF07bNTdis for <xfs@oss.sgi.com>;
	Fri, 01 Nov 2013 13:58:08 -0700 (PDT)
Date: Sat, 2 Nov 2013 07:58:03 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: simplify kmem_{zone_}zalloc
Message-ID: <20131101205803.GQ4446@dastard>
References: <52738187.1000807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52738187.1000807@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: bpm@sgi.com, elder@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Fri, Nov 01, 2013 at 06:25:11PM +0800, Gu Zheng wrote:
> Introduce flag KM_ZERO which is used to alloc zeroed entry, and convert
> kmem_{zone_}zalloc to call kmem_{zone_}alloc() with KM_ZERO directly,
> in order to avoid the setting to zero step.
> 
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/xfs/kmem.c |   14 ++------------
>  fs/xfs/kmem.h |    7 ++++++-
>  2 files changed, 8 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index a02cfb9..d56fcc9 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -65,12 +65,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  void *
>  kmem_zalloc(size_t size, xfs_km_flags_t flags)
>  {
> -	void	*ptr;
> -
> -	ptr = kmem_alloc(size, flags);
> -	if (ptr)
> -		memset((char *)ptr, 0, (int)size);
> -	return ptr;
> +	return kmem_alloc(size, flags | KM_ZERO);
>  }
>  
>  void *
> @@ -132,10 +127,5 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  void *
>  kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  {
> -	void	*ptr;
> -
> -	ptr = kmem_zone_alloc(zone, flags);
> -	if (ptr)
> -		memset((char *)ptr, 0, kmem_cache_size(zone));
> -	return ptr;
> +	return kmem_zone_alloc(zone, flags | KM_ZERO);
>  }

These functions should be made static inline functions in kmem.h
seeing as they are now just a simple wrapper.

Otherwise it's a nice cleanup.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
