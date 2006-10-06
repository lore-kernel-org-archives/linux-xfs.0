Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 05 Oct 2006 23:47:03 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k966ksaG026229
	for <xfs@oss.sgi.com>; Thu, 5 Oct 2006 23:46:56 -0700
Date: Fri, 6 Oct 2006 16:46:08 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: set blocksize patch - libxfs & mkfs
Message-ID: <20061006064608.GE11034@melbourne.sgi.com>
References: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <778901771D2CDD34FDDE6CFA@timothy-shimmins-power-mac-g5.local>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: xfs-dev@sgi.com, xfs@oss.sgi.com

On Fri, Oct 06, 2006 at 04:34:03PM +1000, Timothy Shimmin wrote:
> Request for review of libxfs patch.
....
> Index: xfsprogs/libxfs/darwin.c
> ===================================================================
> --- xfsprogs/libxfs/darwin.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/darwin.c	2006-10-06 14:14:03.000000000 +1000
> @@ -51,8 +51,8 @@
> 	return (writable == 0);
> }
> 
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
> int fatal)
> {
> }

Should "return fatal;" to fail specific setting of this until it is
supported on this platform.

> 
> Index: xfsprogs/libxfs/freebsd.c
> ===================================================================
> --- xfsprogs/libxfs/freebsd.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/freebsd.c	2006-10-06 14:14:03.000000000 +1000
> @@ -91,8 +91,8 @@
> 	return 0;
> }
> 
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
> int fatal)
> {
> 	return;
> }

Ditto...

> Index: xfsprogs/libxfs/irix.c
> ===================================================================
> --- xfsprogs/libxfs/irix.c.orig	2006-10-06 14:12:27.000000000 +1000
> +++ xfsprogs/libxfs/irix.c	2006-10-06 14:14:03.000000000 +1000
> @@ -36,8 +36,8 @@
> 	return 1;
> }
> 
> -void
> -platform_set_blocksize(int fd, char *path, dev_t device, int blocksize)
> +int
> +platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, 
> int fatal)
> {
> 	return;
> }

and again.

Otherwise looks ok.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
