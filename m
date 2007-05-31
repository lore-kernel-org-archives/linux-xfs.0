Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 30 May 2007 19:36:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4V2amWt011319
	for <xfs@oss.sgi.com>; Wed, 30 May 2007 19:36:50 -0700
Date: Thu, 31 May 2007 12:36:40 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 2/3] Fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
Message-ID: <20070531023640.GI85884050@sgi.com>
References: <20070530125954.706423971@suse.cz> <20070530143043.611931865@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530143043.611931865@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michal Marek <mmarek@suse.cz>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 02:59:56PM +0200, Michal Marek wrote:
> 32bit struct xfs_fsop_handlereq has different size and offsets (due to
> pointers). TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE
> still not handled.
> 
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>  fs/xfs/linux-2.6/xfs_ioctl32.c |   63 +++++++++++++++++++++++++++++++++++++----
>  1 file changed, 58 insertions(+), 5 deletions(-)
> 
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl32.c
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl32.c
> @@ -139,6 +139,44 @@ xfs_ioctl32_bulkstat(
>  }
>  #endif
>  
> +typedef struct xfs_fsop_handlereq32 {

xfs_fsop_handlereq_32

> +	__u32		fd;		/* fd for FD_TO_HANDLE		*/
> +	compat_uptr_t	path;		/* user pathname		*/
> +	__u32		oflags;		/* open flags			*/
> +	compat_uptr_t	ihandle;	/* user supplied handle		*/
> +	__u32		ihandlen;	/* user supplied length		*/
> +	compat_uptr_t	ohandle;	/* user buffer for handle	*/
> +	compat_uptr_t	ohandlen;	/* user buffer length		*/
> +} xfs_fsop_handlereq32_t;

xfs_fsop_handlereq_32_t

Add a empty line here...

> +#define XFS_IOC_PATH_TO_FSHANDLE_32 _IOWR('X', 104, struct xfs_fsop_handlereq32)
> +#define XFS_IOC_PATH_TO_HANDLE_32   _IOWR('X', 105, struct xfs_fsop_handlereq32)
> +#define XFS_IOC_FD_TO_HANDLE_32	    _IOWR('X', 106, struct xfs_fsop_handlereq32)
> +#define XFS_IOC_OPEN_BY_HANDLE_32   _IOWR('X', 107, struct xfs_fsop_handlereq32)
> +#define XFS_IOC_READLINK_BY_HANDLE_32 _IOWR('X', 108, struct xfs_fsop_handlereq32)

Looks kinda whitespacey here - it's mixing spaces and tabs....

> +STATIC unsigned long xfs_ioctl32_fshandle(unsigned long arg)
> +{
> +	xfs_fsop_handlereq32_t __user *p32 = (void __user *)arg;
> +	xfs_fsop_handlereq_t __user *p = compat_alloc_user_space(sizeof(*p));
> +	u32 addr;
> +
> +	if (copy_in_user(&p->fd, &p32->fd, sizeof(__u32)) ||
> +	    get_user(addr, &p32->path) ||
> +	    put_user(compat_ptr(addr), &p->path) ||
> +	    copy_in_user(&p->oflags, &p32->oflags, sizeof(__u32)) ||
> +	    get_user(addr, &p32->ihandle) ||
> +	    put_user(compat_ptr(addr), &p->ihandle) ||
> +	    copy_in_user(&p->ihandlen, &p32->ihandlen, sizeof(__u32)) ||
> +	    get_user(addr, &p32->ohandle) ||
> +	    put_user(compat_ptr(addr), &p->ohandle) ||
> +	    get_user(addr, &p32->ohandlen) ||
> +	    put_user(compat_ptr(addr), &p->ohandlen))
> +		return -EFAULT;
> +
> +	return (unsigned long)p;
> +}
> +
> +
>  STATIC long
>  xfs_compat_ioctl(
>  	int		mode,
> @@ -164,12 +202,7 @@ xfs_compat_ioctl(
>  	case XFS_IOC_GETBMAPA:
>  	case XFS_IOC_GETBMAPX:
>  /* not handled
> -	case XFS_IOC_FD_TO_HANDLE:
> -	case XFS_IOC_PATH_TO_HANDLE:
> -	case XFS_IOC_PATH_TO_FSHANDLE:
> -	case XFS_IOC_OPEN_BY_HANDLE:
>  	case XFS_IOC_FSSETDM_BY_HANDLE:
> -	case XFS_IOC_READLINK_BY_HANDLE:
>  	case XFS_IOC_ATTRLIST_BY_HANDLE:
>  	case XFS_IOC_ATTRMULTI_BY_HANDLE:
>  */
> @@ -226,6 +259,26 @@ xfs_compat_ioctl(
>  		arg = xfs_ioctl32_bulkstat(arg);
>  		break;
>  #endif
> +	case XFS_IOC_FD_TO_HANDLE_32:
> +		arg = xfs_ioctl32_fshandle(arg);
> +		cmd = XFS_IOC_FD_TO_HANDLE;
> +		break;
> +	case XFS_IOC_PATH_TO_HANDLE_32:
> +		arg = xfs_ioctl32_fshandle(arg);
> +		cmd = XFS_IOC_PATH_TO_HANDLE;
> +		break;
> +	case XFS_IOC_PATH_TO_FSHANDLE_32:
> +		arg = xfs_ioctl32_fshandle(arg);
> +		cmd = XFS_IOC_PATH_TO_FSHANDLE;
> +		break;
> +	case XFS_IOC_OPEN_BY_HANDLE_32:
> +		arg = xfs_ioctl32_fshandle(arg);
> +		cmd = XFS_IOC_OPEN_BY_HANDLE;
> +		break;
> +	case XFS_IOC_READLINK_BY_HANDLE_32:
> +		arg = xfs_ioctl32_fshandle(arg);
> +		cmd = XFS_IOC_READLINK_BY_HANDLE;
> +		break;

+	case XFS_IOC_FD_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_HANDLE_32:
+	case XFS_IOC_PATH_TO_FSHANDLE_32:
+	case XFS_IOC_OPEN_BY_HANDLE_32:
+	case XFS_IOC_READLINK_BY_HANDLE_32:
+		arg = xfs_ioctl32_fshandle(arg);
+		cmd = _NATIVE_IOC(cmd, struct xfs_fsop_handlereq);
+		break;

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
