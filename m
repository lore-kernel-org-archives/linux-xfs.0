Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 23:31:24 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5R6VJed026490
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 23:31:20 -0700
Date: Fri, 27 Jun 2008 02:32:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix use after free when closing log/rt devices
Message-ID: <20080627063219.GA25015@infradead.org>
References: <48647746.5010007@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48647746.5010007@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jun 27, 2008 at 03:14:46PM +1000, Lachlan McIlroy wrote:
> The call to xfs_free_buftarg() will free the memory used by it's argument
> so we need to save the bdev to pass to xfs_blkdev_put()
>
> Lachlan
>
> --- fs/xfs/linux-2.6/xfs_super.c_1.432	2008-06-27 14:51:17.000000000 +1000
> +++ fs/xfs/linux-2.6/xfs_super.c	2008-06-27 14:59:26.000000000 +1000
> @@ -781,13 +781,17 @@ STATIC void
> xfs_close_devices(
> 	struct xfs_mount	*mp)
> {
> +	struct block_device	*bdev;
> +
> 	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
> +		bdev = mp->m_logdev_targp->bt_bdev;
> 		xfs_free_buftarg(mp->m_logdev_targp);
> -		xfs_blkdev_put(mp->m_logdev_targp->bt_bdev);
> +		xfs_blkdev_put(bdev);
> 	}
> 	if (mp->m_rtdev_targp) {
> +		bdev = mp->m_rtdev_targp->bt_bdev;
> 		xfs_free_buftarg(mp->m_rtdev_targp);
> -		xfs_blkdev_put(mp->m_rtdev_targp->bt_bdev);
> +		xfs_blkdev_put(bdev);
> 	}

Looks good, alhough two local variables inside the ifs might be cleaner:

	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;

		xfs_free_buftarg(mp->m_logdev_targp);
		xfs_blkdev_put(logdev);
	}

	...
