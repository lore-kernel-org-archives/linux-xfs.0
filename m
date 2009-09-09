Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89HFk2I172388 for <xfs@oss.sgi.com>; Wed, 9 Sep 2009 12:15:56 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 845731B8F709
	for <xfs@oss.sgi.com>; Wed,  9 Sep 2009 10:16:16 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 3Pasw6G57DdDGOQa for
	<xfs@oss.sgi.com>; Wed, 09 Sep 2009 10:16:16 -0700 (PDT)
Message-ID: <4AA7E2DE.9090402@sandeen.net>
Date: Wed, 09 Sep 2009 12:16:14 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: fix up the noreturn annotations
References: <4AA19639.6090208@sandeen.net>
	<20090908143956.GA15533@infradead.org>
In-Reply-To: <20090908143956.GA15533@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> The usage function in mkfs needs a noreturn annotation too, otherwise
> gcc will complain, similarly the do_msg function in repair would need
> it if do_abort is set, but because conditional annotations aren't
> possible just clean this area up an inline the do_msg function into
> it's callers.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> Index: xfsprogs-dev/mkfs/xfs_mkfs.c
> ===================================================================
> --- xfsprogs-dev.orig/mkfs/xfs_mkfs.c	2009-09-08 11:33:17.892004074 -0300
> +++ xfsprogs-dev/mkfs/xfs_mkfs.c	2009-09-08 11:33:26.993004077 -0300
> @@ -27,6 +27,7 @@
>   */
>  static void conflict(char opt, char *tab[], int oldidx, int newidx);
>  static void illegal(char *value, char *opt);
> +static __attribute__((noreturn)) void usage (void);
>  static __attribute__((noreturn)) void reqval(char opt, char *tab[], int idx);
>  static void respec(char opt, char *tab[], int idx);
>  static void unknown(char opt, char *s);
> @@ -2554,7 +2555,7 @@ cvtnum(
>  	return -1LL;
>  }
>  
> -void
> +static void __attribute__((noreturn))
>  usage( void )
>  {
>  	fprintf(stderr, _("Usage: %s\n\
> Index: xfsprogs-dev/mkfs/xfs_mkfs.h
> ===================================================================
> --- xfsprogs-dev.orig/mkfs/xfs_mkfs.h	2009-09-08 11:33:17.904015867 -0300
> +++ xfsprogs-dev/mkfs/xfs_mkfs.h	2009-09-08 11:33:26.993004077 -0300
> @@ -68,7 +68,6 @@
>  
>  
>  /* xfs_mkfs.c */
> -extern void usage (void);
>  extern int isdigits (char *str);
>  extern long long cvtnum (unsigned int blocksize,
>  			 unsigned int sectorsize, char *s);
> Index: xfsprogs-dev/repair/xfs_repair.c
> ===================================================================
> --- xfsprogs-dev.orig/repair/xfs_repair.c	2009-09-08 11:33:31.211278768 -0300
> +++ xfsprogs-dev/repair/xfs_repair.c	2009-09-08 11:34:30.158256533 -0300
> @@ -339,18 +339,6 @@ process_args(int argc, char **argv)
>  		usage();
>  }
>  
> -void
> -do_msg(int do_abort, char const *msg, va_list args)
> -{
> -	vfprintf(stderr, msg, args);
> -
> -	if (do_abort)  {
> -		if (dumpcore)
> -			abort();
> -		exit(1);
> -	}
> -}
> -
>  void __attribute__((noreturn))
>  do_error(char const *msg, ...)
>  {
> @@ -359,7 +347,10 @@ do_error(char const *msg, ...)
>  	fprintf(stderr, _("\nfatal error -- "));
>  
>  	va_start(args, msg);
> -	do_msg(1, msg, args);
> +	vfprintf(stderr, msg, args);
> +	if (dumpcore)
> +		abort();
> +	exit(1);
>  }
>  
>  /*
> @@ -372,7 +363,10 @@ do_abort(char const *msg, ...)
>  	va_list args;
>  
>  	va_start(args, msg);
> -	do_msg(1, msg, args);
> +	vfprintf(stderr, msg, args);
> +	if (dumpcore)
> +		abort();
> +	exit(1);
>  }
>  
>  void
> @@ -383,7 +377,7 @@ do_warn(char const *msg, ...)
>  	fs_is_dirty = 1;
>  
>  	va_start(args, msg);
> -	do_msg(0, msg, args);
> +	vfprintf(stderr, msg, args);
>  	va_end(args);
>  }
>  
> @@ -395,7 +389,7 @@ do_log(char const *msg, ...)
>  	va_list args;
>  
>  	va_start(args, msg);
> -	do_msg(0, msg, args);
> +	vfprintf(stderr, msg, args);
>  	va_end(args);
>  }
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
