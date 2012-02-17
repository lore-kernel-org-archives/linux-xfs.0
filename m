Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HJFS58103768 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 13:15:29 -0600
Date: Fri, 17 Feb 2012 14:15:23 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] xfs: fix buffer flushing during log unmount
Message-ID: <20120217191522.GB13870@infradead.org>
References: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1329306980-17997-1-git-send-email-amit.sahrawat83@gmail.com>
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
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: Nam-Jae Jeon <linkinjeon@gmail.com>, Alex Elder <elder@kernel.org>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>

> Whenever there is a mount/unmount failure - there is a chance of calling the
> callbacks functions once - transaction ail mount pointer is destroyed. So, it results
> in NULL pointer exception followed by hang. So, before unmount of the log - flush all
> the pending buffers.

>  void
>  xfs_log_unmount(xfs_mount_t *mp)
>  {
> +	int error = 0;
> +	/*
> +	 * Make sure all buffers have been flushed and completed before
> +	 * unmounting the log.
> +	 */
> +	error = xfs_flush_buftarg(mp->m_ddev_targp, 1);
> +	if (error)
> +		cmn_err(CE_WARN, "%d busy buffers during log unmount.", error);
> +	xfs_wait_buftarg(mp->m_ddev_targp);
> +	

We do exactly that sequence before the xfs_log_unmount_write call on
umount.  Care to explain what code in xfs_log_unmount_write would
require this to be called again?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
