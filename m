Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 080CF7F47
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 04:50:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 95742AC001
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 02:50:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gEE1pjtMxaMf0gBJ (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 15 Oct 2015 02:50:07 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id C62F619CBD3
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 09:50:06 +0000 (UTC)
Date: Thu, 15 Oct 2015 11:50:03 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] xfs: more info from kmem deadlocks and high-level error
	msgs
Message-ID: <20151015095003.GB27267@redhat.com>
References: <561884F5.2050808@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <561884F5.2050808@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Oct 09, 2015 at 10:24:37PM -0500, Eric Sandeen wrote:
> In an effort to get more useful out of "possible memory
> allocation deadlock" messages, print the size of the
> requested allocation, and dump the stack if the xfs error
> level is tuned high.
> 
> The stack dump is implemented in define_xfs_printk_level()
> for error levels >= LOGLEVEL_ERR, partly because it
> seems generically useful, and also because kmem.c has
> no knowledge of xfs error level tunables or other such bits,
> it's very kmem-specific.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index a7a3a63..dfe3a8b 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
> @@ -55,8 +55,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  			return ptr;
>  		if (!(++retries % 100))
>  			xfs_err(NULL,
> -		"possible memory allocation deadlock in %s (mode:0x%x)",
> -					__func__, lflags);
> +		"possible memory allocation deadlock size %u in %s (mode:0x%x)",
> +					(unsigned int)size, __func__, lflags);
>  		congestion_wait(BLK_RW_ASYNC, HZ/50);
>  	} while (1);
>  }
> diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
> index d8b6754..11792d8 100644
> --- a/fs/xfs/xfs_message.c
> +++ b/fs/xfs/xfs_message.c
> @@ -17,6 +17,7 @@
>  
>  #include "xfs.h"
>  #include "xfs_fs.h"
> +#include "xfs_error.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
>  #include "xfs_trans_resv.h"
> @@ -43,6 +44,7 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
>  {								\
>  	struct va_format	vaf;				\
>  	va_list			args;				\
> +	int			level;				\
>  								\
>  	va_start(args, fmt);					\
>  								\
> @@ -51,6 +53,11 @@ void func(const struct xfs_mount *mp, const char *fmt, ...)	\
>  								\
>  	__xfs_printk(kern_level, mp, &vaf);			\
>  	va_end(args);						\
> +								\
> +	if (!kstrtoint(kern_level, 0, &level) &&		\
> +	    level <= LOGLEVEL_ERR &&				\
> +	    xfs_error_level >= XFS_ERRLEVEL_HIGH)		\
> +		xfs_stack_trace();				\
>  }								\
>  
>  define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
