Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 Apr 2008 00:12:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3U7BwuX010501
	for <xfs@oss.sgi.com>; Wed, 30 Apr 2008 00:12:02 -0700
Message-ID: <48181C19.1060001@sgi.com>
Date: Wed, 30 Apr 2008 17:13:29 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Fix non-debug build for random32() use
References: <20080430065754.GB108924158@sgi.com>
In-Reply-To: <20080430065754.GB108924158@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Looks good to me.

David Chinner wrote:
> Include linux/random.h in all builds, not just debug.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  fs/xfs/linux-2.6/xfs_linux.h |    1 +
>  fs/xfs/support/debug.h       |    2 --
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_linux.h	2008-04-22 15:06:11.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_linux.h	2008-04-30 16:38:38.754688626 +1000
> @@ -75,6 +75,7 @@
>  #include <linux/delay.h>
>  #include <linux/log2.h>
>  #include <linux/spinlock.h>
> +#include <linux/random.h>
>  
>  #include <asm/page.h>
>  #include <asm/div64.h>
> Index: 2.6.x-xfs-new/fs/xfs/support/debug.h
> ===================================================================
> --- 2.6.x-xfs-new.orig/fs/xfs/support/debug.h	2007-08-02 22:13:10.000000000 +1000
> +++ 2.6.x-xfs-new/fs/xfs/support/debug.h	2008-04-30 16:38:43.518080606 +1000
> @@ -49,8 +49,6 @@ extern void assfail(char *expr, char *f,
>  
>  #else /* DEBUG */
>  
> -#include <linux/random.h>
> -
>  #define ASSERT(expr)	\
>  	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
> 
