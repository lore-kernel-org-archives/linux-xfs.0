Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:39:15 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EGdCbm030721
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:39:13 -0700
Message-ID: <4698FC34.6090001@sandeen.net>
Date: Sat, 14 Jul 2007 11:39:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix sparse warning in kmem_shake_allow
References: <20070714160604.GB7768@lst.de>
In-Reply-To: <20070714160604.GB7768@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> We can't returned a masked result of a __bitwise type.  Compare it to
> 0 first to keep the behaviour without the warning.
> 

I wonder if this warrants a comment about sparse to keep it
from disappearing again later...

-Eric

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/linux-2.6/kmem.h	2007-07-14 16:00:28.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/linux-2.6/kmem.h	2007-07-14 16:00:38.000000000 +0200
> @@ -103,7 +103,7 @@ extern void *kmem_zone_zalloc(kmem_zone_
>  static inline int
>  kmem_shake_allow(gfp_t gfp_mask)
>  {
> -	return (gfp_mask & __GFP_WAIT);
> +	return (gfp_mask & __GFP_WAIT) != 0;
>  }
>  
>  #endif /* __XFS_SUPPORT_KMEM_H__ */
> 
> 
