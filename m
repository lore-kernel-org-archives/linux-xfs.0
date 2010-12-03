Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB33o0Rw059397 for <xfs@oss.sgi.com>; Thu, 2 Dec 2010 21:50:01 -0600
Received: from mx3-phx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 86E4C140D133
	for <xfs@oss.sgi.com>; Thu,  2 Dec 2010 19:51:44 -0800 (PST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id C8aEQCkSdAmJ8kZ3 for
	<xfs@oss.sgi.com>; Thu, 02 Dec 2010 19:51:44 -0800 (PST)
Date: Thu, 2 Dec 2010 22:51:32 -0500 (EST)
From: Lachlan McIlroy <lmcilroy@redhat.com>
Message-ID: <275948151.359301291348292101.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <121488966.359171291347997519.JavaMail.root@zmail05.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH] xfs: prevent NMI timeouts in cmn_err
MIME-Version: 1.0
Reply-To: Lachlan McIlroy <lmcilroy@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Dave, overall it looks good - just a few minor points below.
Thanks for doing this.

----- "Dave Chinner" <david@fromorbit.com> wrote:

> From: Dave Chinner <dchinner@redhat.com>
> 
> We currently have a global error message buffer in cmn_err that is
> protected by a spin lock that disables interrupts.  Recently there
> have been reports of NMI timeouts occurring when the console is
> being flooded by SCSI error reports due to cmn_err() getting stuck
> trying to print to the console while holding this lock (i.e. with
> interrupts disabled). The NMI watchdog is seeing this CPU as
> non-responding and so is triggering a panic.  While the trigger for
> the reported case is SCSI errors, pretty much anything that spams
> the kernel log could cause this to occur.
> 
> Realistically the only reason that we have the intemediate message
> buffer is to prepend the correct kernel log level prefix to the log
> message. The only reason we have the lock is to protect the global
> message buffer and the only reason the message buffer is global is
> to keep it off the stack. Hence if we can avoid needing a global
> message buffer we avoid needing the lock, and we can do this with a
> small amount of cleanup and some preprocessor tricks:
> 
> 	1. clean up xfs_cmn_err() panic mask functionality to avoid
> 	   needing debug code in xfs_cmn_err()
> 	2. remove the couple of "!" message prefixes that still exist that
> 	   the existing cmn_err() code steps over.
> 	3. redefine CE_* levels directly to KERN_*
> 	4. redefine cmn_err() and friends to use printk() directly
> 	   via variable argument length macros.
> 
> By doing this, we can completely remove the cmn_err() code and the
> lock that is causing the problems, and rely solely on printk()
> serialisation to ensure that we don't get garbled messages.
> 
> A series of followup patches is really needed to clean up all the
> cmn_err() calls and related messages properly, but that results in a
> series that is not easily back portable to enterprise kernels. Hence
> this initial fix is only to address the direct problem in the lowest
> impact way possible.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sysctl.c |   22 +++++++++++-
>  fs/xfs/support/debug.c        |   76
> -----------------------------------------
>  fs/xfs/support/debug.h        |   40 +++++++++++++++++-----
>  fs/xfs/xfs_error.c            |   31 -----------------
>  fs/xfs/xfs_error.h            |   14 ++-----
>  fs/xfs/xfs_log.c              |    2 +-
>  fs/xfs/xfs_log_recover.c      |    2 +-
>  7 files changed, 58 insertions(+), 129 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c
> b/fs/xfs/linux-2.6/xfs_sysctl.c
> index 7bb5092..768acd8 100644
> --- a/fs/xfs/linux-2.6/xfs_sysctl.c
> +++ b/fs/xfs/linux-2.6/xfs_sysctl.c
> @@ -51,6 +51,26 @@ xfs_stats_clear_proc_handler(
>  
>  	return ret;
>  }
> +
> +STATIC int
> +xfs_panic_mask_proc_handler(
> +	ctl_table	*ctl,
> +	int		write,
> +	void		__user *buffer,
> +	size_t		*lenp,
> +	loff_t		*ppos)
> +{
> +	int		ret, *valp = ctl->data;
> +
> +	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
> +	if (!ret && write) {
> +		xfs_panic_mask = *valp;
> +#ifdef DEBUG
> +		xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
> +#endif
> +	}
> +	return ret;
> +}
>  #endif /* CONFIG_PROC_FS */
>  
>  static ctl_table xfs_table[] = {
> @@ -77,7 +97,7 @@ static ctl_table xfs_table[] = {
>  		.data		= &xfs_params.panic_mask.val,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_dointvec_minmax,
> +		.proc_handler	= xfs_panic_mask_proc_handler,
>  		.extra1		= &xfs_params.panic_mask.min,
>  		.extra2		= &xfs_params.panic_mask.max
>  	},
> diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
> index 975aa10..fa39e98 100644
> --- a/fs/xfs/support/debug.c
> +++ b/fs/xfs/support/debug.c
> @@ -25,82 +25,6 @@
>  #include "xfs_mount.h"
>  #include "xfs_error.h"
>  
> -static char		message[1024];	/* keep it off the stack */
> -static DEFINE_SPINLOCK(xfs_err_lock);
> -
> -/* Translate from CE_FOO to KERN_FOO, err_level(CE_FOO) == KERN_FOO
> */
> -#define XFS_MAX_ERR_LEVEL	7
> -#define XFS_ERR_MASK		((1 << 3) - 1)
> -static const char * const	err_level[XFS_MAX_ERR_LEVEL+1] =
> -					{KERN_EMERG, KERN_ALERT, KERN_CRIT,
> -					 KERN_ERR, KERN_WARNING, KERN_NOTICE,
> -					 KERN_INFO, KERN_DEBUG};
> -
> -void
> -cmn_err(register int level, char *fmt, ...)
> -{
> -	char	*fp = fmt;
> -	int	len;
> -	ulong	flags;
> -	va_list	ap;
> -
> -	level &= XFS_ERR_MASK;
> -	if (level > XFS_MAX_ERR_LEVEL)
> -		level = XFS_MAX_ERR_LEVEL;
> -	spin_lock_irqsave(&xfs_err_lock,flags);
> -	va_start(ap, fmt);
> -	if (*fmt == '!') fp++;
> -	len = vsnprintf(message, sizeof(message), fp, ap);
> -	if (len >= sizeof(message))
> -		len = sizeof(message) - 1;
> -	if (message[len-1] == '\n')
> -		message[len-1] = 0;
> -	printk("%s%s\n", err_level[level], message);
> -	va_end(ap);
> -	spin_unlock_irqrestore(&xfs_err_lock,flags);
> -	BUG_ON(level == CE_PANIC);
> -}
> -
> -void
> -xfs_fs_vcmn_err(
> -	int			level,
> -	struct xfs_mount	*mp,
> -	char			*fmt,
> -	va_list			ap)
> -{
> -	unsigned long		flags;
> -	int			len = 0;
> -
> -	level &= XFS_ERR_MASK;
> -	if (level > XFS_MAX_ERR_LEVEL)
> -		level = XFS_MAX_ERR_LEVEL;
> -
> -	spin_lock_irqsave(&xfs_err_lock,flags);
> -
> -	if (mp) {
> -		len = sprintf(message, "Filesystem \"%s\": ", mp->m_fsname);
> -
> -		/*
> -		 * Skip the printk if we can't print anything useful
> -		 * due to an over-long device name.
> -		 */
> -		if (len >= sizeof(message))
> -			goto out;
> -	}
> -
> -	len = vsnprintf(message + len, sizeof(message) - len, fmt, ap);
> -	if (len >= sizeof(message))
> -		len = sizeof(message) - 1;
> -	if (message[len-1] == '\n')
> -		message[len-1] = 0;
> -
> -	printk("%s%s\n", err_level[level], message);
> - out:
> -	spin_unlock_irqrestore(&xfs_err_lock,flags);
> -
> -	BUG_ON(level == CE_PANIC);
> -}
> -
>  void
>  assfail(char *expr, char *file, int line)
>  {
> diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
> index d2d2046..f659bd0 100644
> --- a/fs/xfs/support/debug.h
> +++ b/fs/xfs/support/debug.h
> @@ -20,15 +20,37 @@
>  
>  #include <stdarg.h>
>  
> -#define CE_DEBUG        7               /* debug        */
> -#define CE_CONT         6               /* continuation */
> -#define CE_NOTE         5               /* notice       */
> -#define CE_WARN         4               /* warning      */
> -#define CE_ALERT        1               /* alert        */
> -#define CE_PANIC        0               /* panic        */
> -
> -extern void cmn_err(int, char *, ...)
> -	__attribute__ ((format (printf, 2, 3)));
> +#define CE_DEBUG        KERN_DEBUG
> +#define CE_CONT         KERN_INFO
> +#define CE_NOTE         KERN_NOTICE
> +#define CE_WARN         KERN_WARNING
> +#define CE_ALERT        KERN_ALERT
> +#define CE_PANIC        KERN_EMERG
> +
> +#define cmn_err(lvl, fmt, args...)	\
> +	do { \
> +		printk(lvl fmt, ## args); \

The old cmn_err() routine would append a newline if one was not supplied.
As far as I know printk() will not do the same so either we need to fix
all calls to cmn_err() to supply a '\n' or add it here (at the risk of
having two newlines) - maybe:

printk(lvl fmt "\n", ## args);

> +		BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0); \
> +	} while (0)
> +
> +#define xfs_fs_cmn_err(lvl, mp, fmt, args...)	\
> +	do { \
> +		printk(lvl "Filesystem %s: " fmt, (mp)->m_fsname, ## args); \

printk(lvl "Filesystem %s: " fmt "\n", (mp)->m_fsname, ## args);

> +		BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0); \
> +	} while (0)
> +
> +/* All callers to xfs_cmn_err use CE_ALERT, so don't bother testing
> lvl */
> +#define xfs_cmn_err(panic_tag, lvl, mp, fmt, args...)	\
> +	do { \
> +		int	panic = 0; \
> +		if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) { \
> +			printk(KERN_ALERT "XFS: Transforming an alert into a BUG."); \
> +			panic = 1; \
> +		} \
> +		printk(KERN_ALERT "Filesystem %s: " fmt, (mp)->m_fsname, ## args);
> \
> +		BUG_ON(panic); \
> +	} while (0)

I think we can simplify this case a bit and remove the panic variable,
like this:

	do { \
		printk(KERN_ALERT "Filesystem %s: " fmt "\n", (mp)->m_fsname, ## args);
		if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) { \
			printk(KERN_ALERT "XFS: Transforming an alert into a BUG.\n"); \
			BUG_ON(1); \
		} \
	} while (0)

This also reorders the messages which I think makes more sense.

> +
>  extern void assfail(char *expr, char *f, int l);
>  
>  #define ASSERT_ALWAYS(expr)	\
> diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
> index c78cc6a..4c7db74 100644
> --- a/fs/xfs/xfs_error.c
> +++ b/fs/xfs/xfs_error.c
> @@ -152,37 +152,6 @@ xfs_errortag_clearall(xfs_mount_t *mp, int loud)
>  }
>  #endif /* DEBUG */
>  
> -
> -void
> -xfs_fs_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
> -{
> -	va_list ap;
> -
> -	va_start(ap, fmt);
> -	xfs_fs_vcmn_err(level, mp, fmt, ap);
> -	va_end(ap);
> -}
> -
> -void
> -xfs_cmn_err(int panic_tag, int level, xfs_mount_t *mp, char *fmt,
> ...)
> -{
> -	va_list ap;
> -
> -#ifdef DEBUG
> -	xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
> -#endif
> -
> -	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)
> -	    && (level & CE_ALERT)) {
> -		level &= ~CE_ALERT;
> -		level |= CE_PANIC;
> -		cmn_err(CE_ALERT, "XFS: Transforming an alert into a BUG.");
> -	}
> -	va_start(ap, fmt);
> -	xfs_fs_vcmn_err(level, mp, fmt, ap);
> -	va_end(ap);
> -}
> -
>  void
>  xfs_error_report(
>  	const char		*tag,
> diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
> index f338847..6b518d2 100644
> --- a/fs/xfs/xfs_error.h
> +++ b/fs/xfs/xfs_error.h
> @@ -162,21 +162,15 @@ extern int xfs_errortag_clearall(xfs_mount_t
> *mp, int loud);
>  
>  struct xfs_mount;
>  
> -extern void xfs_fs_vcmn_err(int level, struct xfs_mount *mp,
> -		char *fmt, va_list ap)
> -	__attribute__ ((format (printf, 3, 0)));
> -extern void xfs_cmn_err(int panic_tag, int level, struct xfs_mount
> *mp,
> -			char *fmt, ...)
> -	__attribute__ ((format (printf, 4, 5)));
> -extern void xfs_fs_cmn_err(int level, struct xfs_mount *mp, char
> *fmt, ...)
> -	__attribute__ ((format (printf, 3, 4)));
> -
>  extern void xfs_hex_dump(void *p, int length);
>  
>  #define xfs_fs_repair_cmn_err(level, mp, fmt, args...) \
>  	xfs_fs_cmn_err(level, mp, fmt "  Unmount and run xfs_repair.", ##
> args)
>  
>  #define xfs_fs_mount_cmn_err(f, fmt, args...) \
> -	((f & XFS_MFSI_QUIET)? (void)0 : cmn_err(CE_WARN, "XFS: " fmt, ##
> args))
> +	do { \
> +		if (!(f & XFS_MFSI_QUIET)) 	\
> +			cmn_err(CE_WARN, "XFS: " fmt, ## args); \
> +	} while (0)
>  
>  #endif	/* __XFS_ERROR_H__ */
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index abdcbd0..2209035 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -431,7 +431,7 @@ xfs_log_mount(
>  		cmn_err(CE_NOTE, "XFS mounting filesystem %s", mp->m_fsname);
>  	else {
>  		cmn_err(CE_NOTE,
> -			"!Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will
> be inconsistent.",
> +			"Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will
> be inconsistent.",
>  			mp->m_fsname);
>  		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
>  	}
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 6e7dfbb..411f3a9 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3934,7 +3934,7 @@ xlog_recover_finish(
>  		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
>  	} else {
>  		cmn_err(CE_DEBUG,
> -			"!Ending clean XFS mount for filesystem: %s\n",
> +			"Ending clean XFS mount for filesystem: %s\n",
>  			log->l_mp->m_fsname);
>  	}
>  	return 0;
> -- 
> 1.7.2.3
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
