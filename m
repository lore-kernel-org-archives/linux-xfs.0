Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D3E537F58
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 10:32:04 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C3146304051
	for <xfs@oss.sgi.com>; Thu, 29 Jan 2015 08:32:01 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D7LfbcxMVRGG5ZXf (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 29 Jan 2015 08:32:01 -0800 (PST)
Date: Thu, 29 Jan 2015 10:46:52 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs:change kmem_free to use generic kvfree()
Message-ID: <20150129154652.GK17652@laptop.bfoster>
References: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1044A02027DFF@CNBJMBX05.corpusers.net>
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
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Wed, Jan 28, 2015 at 02:08:47PM +0800, Wang, Yalin wrote:
> Change kmem_free to use kvfree() generic function,
> remove the duplicated code.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---

Looks good...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/kmem.c | 10 ----------
>  fs/xfs/kmem.h |  5 ++++-
>  2 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 53e95b2..a7a3a63 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -91,16 +91,6 @@ kmem_zalloc_large(size_t size, xfs_km_flags_t flags)
>  	return ptr;
>  }
>  
> -void
> -kmem_free(const void *ptr)
> -{
> -	if (!is_vmalloc_addr(ptr)) {
> -		kfree(ptr);
> -	} else {
> -		vfree(ptr);
> -	}
> -}
> -
>  void *
>  kmem_realloc(const void *ptr, size_t newsize, size_t oldsize,
>  	     xfs_km_flags_t flags)
> diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
> index 64db0e5..cc6b768 100644
> --- a/fs/xfs/kmem.h
> +++ b/fs/xfs/kmem.h
> @@ -63,7 +63,10 @@ kmem_flags_convert(xfs_km_flags_t flags)
>  extern void *kmem_alloc(size_t, xfs_km_flags_t);
>  extern void *kmem_zalloc_large(size_t size, xfs_km_flags_t);
>  extern void *kmem_realloc(const void *, size_t, size_t, xfs_km_flags_t);
> -extern void  kmem_free(const void *);
> +static inline void  kmem_free(const void *ptr)
> +{
> +	kvfree(ptr);
> +}
>  
>  
>  extern void *kmem_zalloc_greedy(size_t *, size_t, size_t);
> -- 
> 2.2.2
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
