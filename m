Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n23GEd9C021902 for <xfs@oss.sgi.com>; Tue, 3 Mar 2009 10:14:39 -0600
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CB2A16A6B9
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2009 08:14:11 -0800 (PST)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id HD9cEsHDsyq6Zkoh for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2009 08:14:11 -0800 (PST)
Message-ID: <49AD5748.9050302@sandeen.net>
Date: Tue, 03 Mar 2009 10:14:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: only issues a cache flush on unmount if barriers
	are	enabled.
References: <20090224133354.GA15820@infradead.org>
In-Reply-To: <20090224133354.GA15820@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Currently we unconditionally issue a flush from xfs_free_buftarg, but
> since 2.6.29-rc1 this gives a warning in the style of
> 
> 	Filesystem "vdb": Disabling barriers, trial barrier write failed
> 
> when the underlying device doesn't support these cache flushes.  So make
> the flush conditional on the barrier flag.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Patch seems fine,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

but it seems that the changelog is not quite correct; the message shown
above should only ever happen on mount, not unmount, I think.

So I'd either put the right message in or just make a vague reference to
it, because otherwise it's confusing.  :)

Thanks,
-Eric

> Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-02-23 22:46:03.363048798 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2009-02-23 22:48:47.915052140 +0100
> @@ -34,6 +34,12 @@
>  #include <linux/backing-dev.h>
>  #include <linux/freezer.h>
>  
> +#include "xfs_sb.h"
> +#include "xfs_inum.h"
> +#include "xfs_ag.h"
> +#include "xfs_dmapi.h"
> +#include "xfs_mount.h"
> +
>  static kmem_zone_t *xfs_buf_zone;
>  STATIC int xfsbufd(void *);
>  STATIC int xfsbufd_wakeup(int, gfp_t);
> @@ -1442,10 +1448,12 @@ xfs_unregister_buftarg(
>  
>  void
>  xfs_free_buftarg(
> -	xfs_buftarg_t		*btp)
> +	struct xfs_mount	*mp,
> +	struct xfs_buftarg	*btp)
>  {
>  	xfs_flush_buftarg(btp, 1);
> -	xfs_blkdev_issue_flush(btp);
> +	if (mp->m_flags & XFS_MOUNT_BARRIER)
> +		xfs_blkdev_issue_flush(btp);
>  	xfs_free_bufhash(btp);
>  	iput(btp->bt_mapping->host);
>  
> Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2009-02-23 22:46:03.375049208 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2009-02-23 22:46:35.660960473 +0100
> @@ -416,7 +416,7 @@ static inline int XFS_bwrite(xfs_buf_t *
>   *	Handling of buftargs.
>   */
>  extern xfs_buftarg_t *xfs_alloc_buftarg(struct block_device *, int);
> -extern void xfs_free_buftarg(xfs_buftarg_t *);
> +extern void xfs_free_buftarg(struct xfs_mount *, struct xfs_buftarg *);
>  extern void xfs_wait_buftarg(xfs_buftarg_t *);
>  extern int xfs_setsize_buftarg(xfs_buftarg_t *, unsigned int, unsigned int);
>  extern int xfs_flush_buftarg(xfs_buftarg_t *, int);
> Index: xfs/fs/xfs/linux-2.6/xfs_super.c
> ===================================================================
> --- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2009-02-23 22:46:46.637924949 +0100
> +++ xfs/fs/xfs/linux-2.6/xfs_super.c	2009-02-23 22:47:19.787924537 +0100
> @@ -740,15 +740,15 @@ xfs_close_devices(
>  {
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>  		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
> -		xfs_free_buftarg(mp->m_logdev_targp);
> +		xfs_free_buftarg(mp, mp->m_logdev_targp);
>  		xfs_blkdev_put(logdev);
>  	}
>  	if (mp->m_rtdev_targp) {
>  		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
> -		xfs_free_buftarg(mp->m_rtdev_targp);
> +		xfs_free_buftarg(mp, mp->m_rtdev_targp);
>  		xfs_blkdev_put(rtdev);
>  	}
> -	xfs_free_buftarg(mp->m_ddev_targp);
> +	xfs_free_buftarg(mp, mp->m_ddev_targp);
>  }
>  
>  /*
> @@ -817,9 +817,9 @@ xfs_open_devices(
>  
>   out_free_rtdev_targ:
>  	if (mp->m_rtdev_targp)
> -		xfs_free_buftarg(mp->m_rtdev_targp);
> +		xfs_free_buftarg(mp, mp->m_rtdev_targp);
>   out_free_ddev_targ:
> -	xfs_free_buftarg(mp->m_ddev_targp);
> +	xfs_free_buftarg(mp, mp->m_ddev_targp);
>   out_close_rtdev:
>  	if (rtdev)
>  		xfs_blkdev_put(rtdev);
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
