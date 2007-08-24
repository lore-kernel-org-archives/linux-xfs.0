Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 24 Aug 2007 00:32:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O7WX4p027894
	for <xfs@oss.sgi.com>; Fri, 24 Aug 2007 00:32:35 -0700
Date: Fri, 24 Aug 2007 17:32:22 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 11/17] remove dependency of the quota module on behaviors.
Message-ID: <20070824073222.GN72985246@sgi.com>
References: <20070823193935.GL8050@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823193935.GL8050@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Thu, Aug 23, 2007 at 09:39:35PM +0200, Christoph Hellwig wrote:
> Mount options are now parsed by the main XFS module and rejected if quota
> support is not available, and there are some new quota operation for the
> quotactl syscall and calls to quote in the mount, unmount and sync
> callchains.
....
> @@ -110,7 +112,7 @@ xfs_noquota_init(
>  	return error;
>  }
>  
> -xfs_qmops_t	xfs_qmcore_stub = {
> +static struct xfs_qmops xfs_qmcore_stub = {
>  	.xfs_qminit		= (xfs_qminit_t) xfs_noquota_init,
>  	.xfs_qmdone		= (xfs_qmdone_t) fs_noerr,
>  	.xfs_qmmount		= (xfs_qmmount_t) fs_noerr,
> @@ -124,4 +126,38 @@ xfs_qmops_t	xfs_qmcore_stub = {
>  	.xfs_dqvoprename	= (xfs_dqvoprename_t) fs_noerr,
>  	.xfs_dqvopchown		= xfs_dqvopchown_default,
>  	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
> +	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
> +	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
> +	.xfs_quotactl		= (xfs_quotactl_t) fs_noerr,

quotactl needs to return ENOSYS when quota is not enabled on
the filesystem, otherwise the quota tools think quota is
enabled, no error occurred and they interpret unitialised data
as quota data.

This causes all the xfsdump/restore tests to fail in xfsqa because
they erroneously detect that quota is enabled and dump/restore
garbage for the quota. This:


---
 fs/xfs/xfs_qmops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6.x-xfs-experimental/fs/xfs/xfs_qmops.c
===================================================================
--- 2.6.x-xfs-experimental.orig/fs/xfs/xfs_qmops.c	2007-08-24 12:47:50.000000000 +1000
+++ 2.6.x-xfs-experimental/fs/xfs/xfs_qmops.c	2007-08-24 17:05:44.765805482 +1000
@@ -128,7 +128,7 @@ static struct xfs_qmops xfs_qmcore_stub 
 	.xfs_dqvopchownresv	= (xfs_dqvopchownresv_t) fs_noerr,
 	.xfs_dqstatvfs		= (xfs_dqstatvfs_t) fs_noval,
 	.xfs_dqsync		= (xfs_dqsync_t) fs_noerr,
-	.xfs_quotactl		= (xfs_quotactl_t) fs_noerr,
+	.xfs_quotactl		= (xfs_quotactl_t) fs_nosys,
 };
 
 int

makes qa tests 026 028 046 047 063 065 066 (all in the dump group) pass.

Otherwise, the patch set passes xfsqa without introducing any new
regressions.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
