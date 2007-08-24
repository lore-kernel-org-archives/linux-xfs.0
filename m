Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Aug 2007 17:26:27 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7O0QN4p024212
	for <xfs@oss.sgi.com>; Thu, 23 Aug 2007 17:26:24 -0700
Date: Fri, 24 Aug 2007 10:26:12 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 11/17] remove dependency of the quota module on behaviors.
Message-ID: <20070824002612.GC72985246@sgi.com>
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
>  
> -STATIC int
> -xfs_qm_syncall(
> -	struct bhv_desc		*bhv,
> -	int			flags,
> -	cred_t			*credp)
.....
> -	/*
> -	 * Get the Quota Manager to flush the dquots.
> -	 */
> -	if (XFS_IS_QUOTA_ON(mp)) {
> -		if ((error = xfs_qm_sync(mp, flags))) {
> -			/*
> -			 * If we got an IO error, we will be shutting down.
> -			 * So, there's nothing more for us to do here.
> -			 */
> -			ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
> -			if (XFS_FORCED_SHUTDOWN(mp)) {
> -				return XFS_ERROR(error);
> -			}
> -		}

So we check for quota being enabled here before syncing.

> @@ -941,6 +962,21 @@ xfs_sync(
>  	cred_t		*credp)
>  {
>  	xfs_mount_t	*mp = XFS_BHVTOM(bdp);
> +	int		error;
> +
> +	/*
> +	 * Get the Quota Manager to flush the dquots.
> +	 */
> +	error = XFS_QM_DQSYNC(mp, flags);
> +	if (error) {
> +		/*
> +		 * If we got an IO error, we will be shutting down.
> +		 * So, there's nothing more for us to do here.
> +		 */
> +		ASSERT(error != EIO || XFS_FORCED_SHUTDOWN(mp));
> +		if (XFS_FORCED_SHUTDOWN(mp))
> +			return XFS_ERROR(error);
> +	}

but we don't for the new code. I assume that this is because
of the stub:

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

That returns no error.

This is slightly non-obvious that if quotas are not enabled or loaded
that this quota sync does not actually return an error. Perhaps a small
addition to the comment above XFS_QM_DQSYNC() to explain this would
help prevent future misunderstandings.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
