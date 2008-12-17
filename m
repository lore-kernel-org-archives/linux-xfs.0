Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHI4h6C004865 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 12:04:44 -0600
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69E072C1E9
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 10:04:41 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com
	with ESMTP id 2ruj4TvnFNBECC4i for <xfs@oss.sgi.com>;
	Wed, 17 Dec 2008 10:04:41 -0800 (PST)
Message-ID: <49493F38.3070503@sandeen.net>
Date: Wed, 17 Dec 2008 12:04:40 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] avoid memory allocations in xfs_fs_vcmn_err
References: <20081217172736.GA10797@infradead.org>
In-Reply-To: <20081217172736.GA10797@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, xfs@oss.sgi.com

Christoph Hellwig wrote:
> xfs_fs_vcmn_err can be called under a spinlock, but does a sleeping memory
> allocation to create buffer for it's internal sprintf.  Fortunately it's
> the only caller of icmn_err, so we can merge the two and have one single
> static buffer and spinlock protecting it.  While we're at it make sure
> we proper __attribute__ format annotations so that the compiler can detect
> mismatched format strings.
> 
> 
> Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfs/fs/xfs/support/debug.c
> ===================================================================
> --- xfs.orig/fs/xfs/support/debug.c	2008-12-17 14:59:49.000000000 +0100
> +++ xfs/fs/xfs/support/debug.c	2008-12-17 15:10:13.000000000 +0100
> @@ -18,6 +18,13 @@
>  #include <xfs.h>
>  #include "debug.h"
>  
> +/* xfs_mount.h drags a lot of crap in, sorry.. */
> +#include "xfs_sb.h"
> +#include "xfs_inum.h"
> +#include "xfs_ag.h"
> +#include "xfs_dmapi.h"
> +#include "xfs_mount.h"
> +
>  static char		message[1024];	/* keep it off the stack */
>  static DEFINE_SPINLOCK(xfs_err_lock);
>  
> @@ -55,22 +62,42 @@ cmn_err(register int level, char *fmt, .
>  }
>  
>  void
> -icmn_err(register int level, char *fmt, va_list ap)
> +xfs_fs_vcmn_err(
> +	int			level,
> +	struct xfs_mount	*mp,
> +	char			*fmt,
> +	va_list			ap)
>  {
> -	ulong	flags;
> -	int	len;
> +	unsigned long		flags;
> +	int			len = 0;
>  
>  	level &= XFS_ERR_MASK;
> -	if(level > XFS_MAX_ERR_LEVEL)
> +	if (level > XFS_MAX_ERR_LEVEL)
>  		level = XFS_MAX_ERR_LEVEL;
> +
>  	spin_lock_irqsave(&xfs_err_lock,flags);
> -	len = vsnprintf(message, sizeof(message), fmt, ap);
> +
> +	if (mp) {
> +		len = sprintf(message, "Filesystem \"%s\": ", mp->m_fsname);
> +
> +		/*
> +		 * Skip the printk if we can't print anything useful
> +		 * due to an over-long device name.
> +		 */
> +		if (len >= sizeof(message))
> +			goto out;
> +	}
> +
> +	len = vsnprintf(message + len, sizeof(message) - len, fmt, ap);
>  	if (len >= sizeof(message))
>  		len = sizeof(message) - 1;
>  	if (message[len-1] == '\n')
>  		message[len-1] = 0;
> +
>  	printk("%s%s\n", err_level[level], message);
> + out:
>  	spin_unlock_irqrestore(&xfs_err_lock,flags);
> +
>  	BUG_ON(level == CE_PANIC);
>  }
>  
> Index: xfs/fs/xfs/support/debug.h
> ===================================================================
> --- xfs.orig/fs/xfs/support/debug.h	2008-12-17 15:05:34.000000000 +0100
> +++ xfs/fs/xfs/support/debug.h	2008-12-17 15:07:03.000000000 +0100
> @@ -27,8 +27,6 @@
>  #define CE_ALERT        1               /* alert        */
>  #define CE_PANIC        0               /* panic        */
>  
> -extern void icmn_err(int, char *, va_list)
> -	__attribute__ ((format (printf, 2, 0)));
>  extern void cmn_err(int, char *, ...)
>  	__attribute__ ((format (printf, 2, 3)));
>  extern void assfail(char *expr, char *f, int l);
> Index: xfs/fs/xfs/xfs_error.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_error.c	2008-12-17 14:58:02.000000000 +0100
> +++ xfs/fs/xfs/xfs_error.c	2008-12-17 15:12:03.000000000 +0100
> @@ -153,21 +153,6 @@ xfs_errortag_clearall(xfs_mount_t *mp, i
>  }
>  #endif /* DEBUG */
>  
> -static void
> -xfs_fs_vcmn_err(int level, xfs_mount_t *mp, char *fmt, va_list ap)
> -{
> -	if (mp != NULL) {
> -		char	*newfmt;
> -		int	len = 16 + mp->m_fsname_len + strlen(fmt);
> -
> -		newfmt = kmem_alloc(len, KM_SLEEP);
> -		sprintf(newfmt, "Filesystem \"%s\": %s", mp->m_fsname, fmt);
> -		icmn_err(level, newfmt, ap);
> -		kmem_free(newfmt);
> -	} else {
> -		icmn_err(level, fmt, ap);
> -	}
> -}
>  
>  void
>  xfs_fs_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
> Index: xfs/fs/xfs/xfs_error.h
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_error.h	2008-12-17 15:05:46.000000000 +0100
> +++ xfs/fs/xfs/xfs_error.h	2008-12-17 15:12:01.000000000 +0100
> @@ -159,11 +159,15 @@ extern int xfs_errortag_clearall(xfs_mou
>  #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
>  
>  struct xfs_mount;
> -/* PRINTFLIKE4 */
> +
> +extern void xfs_fs_vcmn_err(int level, struct xfs_mount *mp,
> +		char *fmt, va_list ap)
> +	__attribute__ ((format (printf, 3, 0)));
>  extern void xfs_cmn_err(int panic_tag, int level, struct xfs_mount *mp,
> -			char *fmt, ...);
> -/* PRINTFLIKE3 */
> -extern void xfs_fs_cmn_err(int level, struct xfs_mount *mp, char *fmt, ...);
> +			char *fmt, ...)
> +	__attribute__ ((format (printf, 4, 5)));
> +extern void xfs_fs_cmn_err(int level, struct xfs_mount *mp, char *fmt, ...)
> +	__attribute__ ((format (printf, 3, 4)));
>  
>  extern void xfs_hex_dump(void *p, int length);
>  
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
