Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 01:18:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L8InSB002509
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 01:18:49 -0700
Date: Wed, 21 May 2008 04:19:39 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Remove kmem_free build warnings
Message-ID: <20080521081939.GA15771@infradead.org>
References: <20080521080648.82DCF58C4C29@chook.melbourne.sgi.com> <op.ubhvm6ax3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ubhvm6ax3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Looks good, although you might want to pick up realloc as in my patch
while you're at it :)

On Wed, May 21, 2008 at 06:10:08PM +1000, Barry Naujok wrote:
>
>
> ===========================================================================
> fs/xfs/linux-2.6/kmem.c
> ===========================================================================
>
> --- a/fs/xfs/linux-2.6/kmem.c	2008-05-21 18:06:48.000000000 +1000
> +++ b/fs/xfs/linux-2.6/kmem.c	2008-05-21 18:04:44.400231547 +1000
> @@ -90,7 +90,7 @@ kmem_zalloc_greedy(size_t *size, size_t
>  }
>
>  void
> -kmem_free(void *ptr)
> +kmem_free(const void *ptr)
>  {
>  	if (((unsigned long)ptr < VMALLOC_START) ||
>  	    ((unsigned long)ptr >= VMALLOC_END)) {
>
> ===========================================================================
> fs/xfs/linux-2.6/kmem.h
> ===========================================================================
>
> --- a/fs/xfs/linux-2.6/kmem.h	2008-05-21 18:06:48.000000000 +1000
> +++ b/fs/xfs/linux-2.6/kmem.h	2008-05-21 18:05:33.673925302 +1000
> @@ -58,7 +58,7 @@ extern void *kmem_alloc(size_t, unsigned
>  extern void *kmem_zalloc(size_t, unsigned int __nocast);
>  extern void *kmem_zalloc_greedy(size_t *, size_t, size_t, unsigned int 
> __nocast);
>  extern void *kmem_realloc(void *, size_t, size_t, unsigned int __nocast);
> -extern void  kmem_free(void *);
> +extern void  kmem_free(const void *);
>
>  /*
>   * Zone interfaces
>
>
>
---end quoted text---
