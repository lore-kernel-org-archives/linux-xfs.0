Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p32M5qMV063919 for <xfs@oss.sgi.com>; Sat, 2 Apr 2011 17:05:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9C3A1399F2D
	for <xfs@oss.sgi.com>; Sat,  2 Apr 2011 15:09:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mn0JqjiN4AdZYh8B for
	<xfs@oss.sgi.com>; Sat, 02 Apr 2011 15:09:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1Q690D-0000UL-Qk
	for xfs@oss.sgi.com; Sat, 02 Apr 2011 22:09:05 +0000
Date: Sat, 2 Apr 2011 18:09:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix xfs_debug warnings
Message-ID: <20110402220905.GA1861@infradead.org>
References: <20110402181340.GA12639@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110402181340.GA12639@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Err, the subject should have been:

[PATCH] xfs: fix xfs_debug warnings

On Sat, Apr 02, 2011 at 02:13:40PM -0400, Christoph Hellwig wrote:
> For a CONFIG_XFS_DEBUG=n build gcc complains about statements with no
> effect in xfs_debug:
> 
> fs/xfs/quota/xfs_qm_syscalls.c: In function 'xfs_qm_scall_trunc_qfiles':
> fs/xfs/quota/xfs_qm_syscalls.c:291:3: warning: statement with no effect
> 
> The reason for that is that the various new xfs message functions have a
> return value which is never used, and in case of the non-debug build
> xfs_debug the macro evaluates to a plain 0 which produces the above
> warnings.  This can be fixed by turning xfs_debug into an inline function
> instead of a macro, but in addition to that I've also changed all the
> message helpers to return void as we never use their return values.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_message.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_message.c	2011-04-02 07:29:33.619237021 -0700
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_message.c	2011-04-02 07:33:02.383304718 -0700
> @@ -28,53 +28,47 @@
>  /*
>   * XFS logging functions
>   */
> -static int
> +static void
>  __xfs_printk(
>  	const char		*level,
>  	const struct xfs_mount	*mp,
>  	struct va_format	*vaf)
>  {
>  	if (mp && mp->m_fsname)
> -		return printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
> -	return printk("%sXFS: %pV\n", level, vaf);
> +		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
> +	printk("%sXFS: %pV\n", level, vaf);
>  }
>  
> -int xfs_printk(
> +void xfs_printk(
>  	const char		*level,
>  	const struct xfs_mount	*mp,
>  	const char		*fmt, ...)
>  {
>  	struct va_format	vaf;
>  	va_list			args;
> -	int			 r;
>  
>  	va_start(args, fmt);
>  
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  
> -	r = __xfs_printk(level, mp, &vaf);
> +	__xfs_printk(level, mp, &vaf);
>  	va_end(args);
> -
> -	return r;
>  }
>  
>  #define define_xfs_printk_level(func, kern_level)		\
> -int func(const struct xfs_mount *mp, const char *fmt, ...)	\
> +void func(const struct xfs_mount *mp, const char *fmt, ...)	\
>  {								\
>  	struct va_format	vaf;				\
>  	va_list			args;				\
> -	int			r;				\
>  								\
>  	va_start(args, fmt);					\
>  								\
>  	vaf.fmt = fmt;						\
>  	vaf.va = &args;						\
>  								\
> -	r = __xfs_printk(kern_level, mp, &vaf);			\
> +	__xfs_printk(kern_level, mp, &vaf);			\
>  	va_end(args);						\
> -								\
> -	return r;						\
>  }								\
>  
>  define_xfs_printk_level(xfs_emerg, KERN_EMERG);
> @@ -88,7 +82,7 @@ define_xfs_printk_level(xfs_info, KERN_I
>  define_xfs_printk_level(xfs_debug, KERN_DEBUG);
>  #endif
>  
> -int
> +void
>  xfs_alert_tag(
>  	const struct xfs_mount	*mp,
>  	int			panic_tag,
> @@ -97,7 +91,6 @@ xfs_alert_tag(
>  	struct va_format	vaf;
>  	va_list			args;
>  	int			do_panic = 0;
> -	int			r;
>  
>  	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
>  		xfs_printk(KERN_ALERT, mp,
> @@ -110,12 +103,10 @@ xfs_alert_tag(
>  	vaf.fmt = fmt;
>  	vaf.va = &args;
>  
> -	r = __xfs_printk(KERN_ALERT, mp, &vaf);
> +	__xfs_printk(KERN_ALERT, mp, &vaf);
>  	va_end(args);
>  
>  	BUG_ON(do_panic);
> -
> -	return r;
>  }
>  
>  void
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_message.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_message.h	2011-04-02 07:29:33.631735833 -0700
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_message.h	2011-04-02 07:32:07.359236603 -0700
> @@ -3,32 +3,34 @@
>  
>  struct xfs_mount;
>  
> -extern int xfs_printk(const char *level, const struct xfs_mount *mp,
> +extern void xfs_printk(const char *level, const struct xfs_mount *mp,
>                        const char *fmt, ...)
>          __attribute__ ((format (printf, 3, 4)));
> -extern int xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_alert_tag(const struct xfs_mount *mp, int tag,
> +extern void xfs_alert_tag(const struct xfs_mount *mp, int tag,
>  			 const char *fmt, ...)
>          __attribute__ ((format (printf, 3, 4)));
> -extern int xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
> -extern int xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
>  
>  #ifdef DEBUG
> -extern int xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> +extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
>          __attribute__ ((format (printf, 2, 3)));
>  #else
> -#define xfs_debug(mp, fmt, ...)	(0)
> +static inline void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
> +{
> +}
>  #endif
>  
>  extern void assfail(char *expr, char *f, int l);
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
