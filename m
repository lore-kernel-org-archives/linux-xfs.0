Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 14 Jul 2007 09:38:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6EGcEbm030257
	for <xfs@oss.sgi.com>; Sat, 14 Jul 2007 09:38:15 -0700
Message-ID: <4698FBF9.4090507@sandeen.net>
Date: Sat, 14 Jul 2007 11:38:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] fix ASSERT and ASSERT_ALWAYS
References: <20070714160418.GA7768@lst.de>
In-Reply-To: <20070714160418.GA7768@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
>  - remove the != 0 inside the unlikely in ASSERT_ALWAYS because sparse now
>    complains about comparisms between pointers and 0
>  - add a standalone ASSERT implementation because defining it to
>    ASSERT_ALWAYS means the string is expanded before the #token passing
>    stringification.  This way we get the actual content of the
>    assertatio in the assfail message and don't overflow sparse's
>    strinification buffer leading to sparse error messages.

Looks fine to me.

-Eric

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6-xfs/fs/xfs/support/debug.h
> ===================================================================
> --- linux-2.6-xfs.orig/fs/xfs/support/debug.h	2007-07-14 15:55:12.000000000 +0200
> +++ linux-2.6-xfs/fs/xfs/support/debug.h	2007-07-14 15:55:46.000000000 +0200
> @@ -34,10 +34,10 @@ extern void cmn_err(int, char *, ...)
>  extern void assfail(char *expr, char *f, int l);
>  
>  #define ASSERT_ALWAYS(expr)	\
> -	(unlikely((expr) != 0) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
>  #ifndef DEBUG
> -# define ASSERT(expr)	((void)0)
> +#define ASSERT(expr)	((void)0)
>  
>  #ifndef STATIC
>  # define STATIC static noinline
> @@ -49,8 +49,10 @@ extern void assfail(char *expr, char *f,
>  
>  #else /* DEBUG */
>  
> -# define ASSERT(expr)	ASSERT_ALWAYS(expr)
> -# include <linux/random.h>
> +#include <linux/random.h>
> +
> +#define ASSERT(expr)	\
> +	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
>  #ifndef STATIC
>  # define STATIC noinline
> 
> 
