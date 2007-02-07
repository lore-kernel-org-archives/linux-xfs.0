Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 07 Feb 2007 05:05:36 -0800 (PST)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l17D5Sm7002340
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 05:05:30 -0800
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id l17Cskb2007812
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 7 Feb 2007 13:54:46 +0100
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id l17Csk9E007810
	for xfs@oss.sgi.com; Wed, 7 Feb 2007 13:54:46 +0100
Date: Wed, 7 Feb 2007 13:54:46 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] use struct kvec in struct uio
Message-ID: <20070207125446.GB7740@lst.de>
References: <20061129154607.GB6400@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061129154607.GB6400@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Nov 29, 2006 at 04:46:07PM +0100, Christoph Hellwig wrote:
> All but one useage of struct uio are for kernel pointers, so let's use
> struct kvec instead of struct iovec.  Because readlink by handle still
> uses it with a user pointer we still have two sparse warnings, but the
> noise level is reduced quite a bit by this.

ping?

> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: linux-2.6/fs/xfs/support/move.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/support/move.h	2006-11-29 16:27:25.000000000 +0100
> +++ linux-2.6/fs/xfs/support/move.h	2006-11-29 16:30:18.000000000 +0100
> @@ -55,7 +55,7 @@
>  };
>  
>  struct uio {
> -	struct iovec	*uio_iov;   /* pointer to array of iovecs */
> +	struct kvec	*uio_iov;   /* pointer to array of iovecs */
>  	int		uio_iovcnt; /* number of iovecs in array */
>  	xfs_off_t	uio_offset; /* offset in file this uio corresponds to */
>  	int		uio_resid;  /* residual i/o count */
> @@ -63,7 +63,7 @@
>  };
>  
>  typedef struct uio uio_t;
> -typedef struct iovec iovec_t;
> +typedef struct kvec iovec_t;
>  
>  extern int	xfs_uio_read (caddr_t, size_t, uio_t *);
>  
> Index: linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/linux-2.6/xfs_ioctl.c	2006-11-29 16:33:37.000000000 +0100
> +++ linux-2.6/fs/xfs/linux-2.6/xfs_ioctl.c	2006-11-29 16:34:43.000000000 +0100
> @@ -388,7 +388,7 @@
>  	aiov.iov_len	= olen;
>  	aiov.iov_base	= hreq.ohandle;
>  
> -	auio.uio_iov	= &aiov;
> +	auio.uio_iov	= (struct kvec *)&aiov;
>  	auio.uio_iovcnt	= 1;
>  	auio.uio_offset	= 0;
>  	auio.uio_segflg	= UIO_USERSPACE;
---end quoted text---
