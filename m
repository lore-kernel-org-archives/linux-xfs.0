Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGC4aql048720 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 06:04:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 62838152E123
	for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 04:06:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id EzDKflbXa60iOMMV for
	<xfs@oss.sgi.com>; Thu, 16 Dec 2010 04:06:29 -0800 (PST)
Date: Thu, 16 Dec 2010 07:06:29 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] xfs: split direct IO write path from
	xfs_file_aio_write
Message-ID: <20101216120629.GC20445@infradead.org>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1292376208-16282-5-git-send-email-david@fromorbit.com>
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

> +STATIC ssize_t
> +xfs_file_dio_aio_write(
> +	struct kiocb		*iocb,
> +	const struct iovec	*iovp,
> +	unsigned long		nr_segs,
> +	loff_t			pos,
> +	size_t			ocount,
> +	int			*need_i_mutex,
> +	int			*iolock)

need_i_mutex == 1 is equivalent to iolock == XFS_IOLOCK_EXCL, I think
it's a good idea to throw in a patch to remove the need_i_mutex variable
before this patch.

Maybe that patch can even add xfs_rw_lock or similar helpers to
manipulate the i_mutex, the iolock, and the iolock variable together?

Speaking of that, shouldn't xfs_file_aio_read also take the iolock
exclusive during the page invalidation and then demote it, just like
the write case?  The above helpers would enforce that nicely.

> +	if ((pos & target->bt_smask) || (count & target->bt_smask))
> +		return XFS_ERROR(-EINVAL);

For the error traps to work this needs to be

	-XFS_ERROR(EINVAL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
