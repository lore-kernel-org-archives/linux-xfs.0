Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7M6hnqj036394 for <xfs@oss.sgi.com>; Mon, 22 Aug 2011 01:43:50 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C617A1388818
	for <xfs@oss.sgi.com>; Sun, 21 Aug 2011 23:46:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OYpKTIr1TddWjhmQ for <xfs@oss.sgi.com>;
	Sun, 21 Aug 2011 23:46:21 -0700 (PDT)
Date: Mon, 22 Aug 2011 16:43:45 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/5] xfs: reduce ioend latency
Message-ID: <20110822064345.GM3162@dastard>
References: <20110814222412.359079843@bombadil.infradead.org>
	<20110814222518.001177781@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110814222518.001177781@bombadil.infradead.org>
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

On Sun, Aug 14, 2011 at 06:24:15PM -0400, Christoph Hellwig wrote:
> There is no reason to queue up ioends for processing in user context
> unless we actually need it.  Just complete ioends that do not convert
> unwritten extents or need a size update from the end_io context.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/xfs/xfs_aops.c
> ===================================================================
> --- xfs.orig/fs/xfs/xfs_aops.c	2011-08-13 10:57:57.559366326 -0700
> +++ xfs/fs/xfs/xfs_aops.c	2011-08-13 10:57:57.979364052 -0700
> @@ -150,6 +150,15 @@ xfs_ioend_new_eof(
>  }
>  
>  /*
> + * Fast and loose check if this write could update the on-disk inode size.
> + */
> +static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
> +{
> +	return ioend->io_offset + ioend->io_size >
> +		XFS_I(ioend->io_inode)->i_d.di_size;
> +}
> +
> +/*
>   * Update on-disk file size now that data has been written to disk.  The
>   * current in-memory file size is i_size.  If a write is beyond eof i_new_size
>   * will be the intended file size until i_size is updated.  If this write does
> @@ -186,6 +195,9 @@ xfs_setfilesize(
>  
>  /*
>   * Schedule IO completion handling on the final put of an ioend.
> + *
> + * If there is no work to do we might as well call it a day and free the
> + * ioend right now.
>   */
>  STATIC void
>  xfs_finish_ioend(
> @@ -194,8 +206,10 @@ xfs_finish_ioend(
>  	if (atomic_dec_and_test(&ioend->io_remaining)) {
>  		if (ioend->io_type == IO_UNWRITTEN)
>  			queue_work(xfsconvertd_workqueue, &ioend->io_work);
> -		else
> +		else if (xfs_ioend_is_append(ioend))
>  			queue_work(xfsdatad_workqueue, &ioend->io_work);
> +		else
> +			xfs_destroy_ioend(ioend);
>  	}
>  }

That's similar to a check I added in a previous patch series to
avoid taking the ILOCK in IO completion if it wasn't necessary. THis
just checks earlier to avoid the workqueue switch, so it definitely
better than what I did.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
