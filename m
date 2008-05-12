Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 11 May 2008 19:04:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4C23lZD009800
	for <xfs@oss.sgi.com>; Sun, 11 May 2008 19:03:50 -0700
Date: Mon, 12 May 2008 12:04:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 4/10] sort out opening and closing of the block devices
Message-ID: <20080512020421.GW155679365@sgi.com>
References: <20080501220105.GD2315@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501220105.GD2315@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, May 02, 2008 at 12:01:05AM +0200, Christoph Hellwig wrote:
> +STATIC int
> +xfs_open_devices(
> +	struct xfs_mount	*mp,
> +	struct xfs_mount_args	*args)
> +{
> +	struct block_device	*ddev = mp->m_super->s_bdev;
> +	struct block_device	*logdev = NULL, *rtdev = NULL;
> +	int			error;
> +
> +	/*
> +	 * Open real time and log devices - order is important.
> +	 */
> +	if (args->logname[0]) {
> +		error = xfs_blkdev_get(mp, args->logname, &logdev);
> +		if (error)
> +			goto out;
> +	}
> +
> +	if (args->rtname[0]) {
> +		error = xfs_blkdev_get(mp, args->rtname, &rtdev);
> +		if (error)
> +			goto out_close_logdev;
> +
> +		if (rtdev == ddev || rtdev == logdev) {
> +			cmn_err(CE_WARN,
> +	"XFS: Cannot mount filesystem with identical rtdev and ddev/logdev.");

error needs to be set to something here.

> +			goto out_close_rtdev;
> +		}
> +	}
> +
> +	/*
> +	 * Setup xfs_mount buffer target pointers
> +	 */
> +	error = ENOMEM;
> +	mp->m_ddev_targp = xfs_alloc_buftarg(ddev, 0);
> +	if (!mp->m_ddev_targp)
> +		goto out_close_rtdev;
> +
> +	if (rtdev) {
> +		mp->m_rtdev_targp = xfs_alloc_buftarg(rtdev, 1);
> +		if (!mp->m_rtdev_targp)
> +			goto out_free_ddev_targ;
> +	}
> +
> +	if (logdev && logdev != ddev) {
> +		mp->m_logdev_targp = xfs_alloc_buftarg(logdev, 1);
> +		if (!mp->m_logdev_targp)
> +			goto out_free_rtdev_targ;
> +	} else {
> +		mp->m_logdev_targp = mp->m_ddev_targp;
> +	}
> +
> +	return 0;
> +
> + out_free_rtdev_targ:
> +	if (mp->m_rtdev_targp)
> +		xfs_free_buftarg(mp->m_rtdev_targp);
> + out_free_ddev_targ:
> +	xfs_free_buftarg(mp->m_ddev_targp);
> + out_close_rtdev:
> +	if (mp->m_rtdev_targp)
> +		xfs_blkdev_put(mp->m_rtdev_targp->bt_bdev);

And that looks broken - we either haven't allocated m_rtdev_targp
yet or we've freed it above.

incremental patch to fix is fine...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
