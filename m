Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGJ16di204383 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 13:01:07 -0600
Date: Wed, 16 Nov 2011 13:01:20 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111116190120.GG29840@sgi.com>
References: <20111115201407.038216766@bombadil.infradead.org>
	<20111115201426.686729205@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20111115201426.686729205@bombadil.infradead.org>
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

On Tue, Nov 15, 2011 at 03:14:09PM -0500, Christoph Hellwig wrote:
> commit 77d7a0c "xfs: Non-blocking inode locking in IO completion" introduced
> a trylocked and defer scheme in xfs_setfilesize to avoid deadlocks when on
> XFS filesystem is used ontop of another using the loop device, and we
> fsync in the loop filesystem.
> 
> Now that we have the cheap enough concurrency managed workqueues, we can
> create per-filesystem instead of global workqueues and remove this scheme
> again, given that it has the potential of delaying size updates and is not
> helpful once we start to log the inode size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

>  /*
> @@ -168,10 +161,12 @@ xfs_finish_ioend(
>  	struct xfs_ioend	*ioend)
>  {
>  	if (atomic_dec_and_test(&ioend->io_remaining)) {
> +		struct xfs_mount	*mp = XFS_I(ioend->io_inode)->i_mount;
> +
>  		if (ioend->io_type == IO_UNWRITTEN)
> -			queue_work(xfsconvertd_workqueue, &ioend->io_work);
> +			queue_work(mp->m_unwritten_workqueue, &ioend->io_work);
>  		else if (xfs_ioend_is_append(ioend))

I wonder if we could skip size updates due to the 'fast and loose'
nature of xfs_ioend_is_append, and end up destroying the ioend below,
without updating the file size.  It's not strictly related to your patch
though.

> -			queue_work(xfsdatad_workqueue, &ioend->io_work);
> +			queue_work(mp->m_data_workqueue, &ioend->io_work);
>  		else
>  			xfs_destroy_ioend(ioend);
>  	}

...

> Index: linux-2.6/fs/xfs/xfs_super.c
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_super.c	2011-11-10 16:50:40.771795378 +0100
> +++ linux-2.6/fs/xfs/xfs_super.c	2011-11-15 09:17:13.763315819 +0100
> @@ -769,6 +769,42 @@ xfs_setup_devices(
>  	return 0;
>  }
>  
> +STATIC int
> +xfs_init_mount_workqueues(
> +	struct xfs_mount	*mp)
> +{
> +	snprintf(mp->m_data_workqueue_name, XFS_WQ_NAME_LEN,
> +		 "xfs-data/%s", mp->m_fsname);
> +	mp->m_data_workqueue =
> +		alloc_workqueue(mp->m_data_workqueue_name, WQ_MEM_RECLAIM, 1);
> +	if (!mp->m_data_workqueue)
> +		goto out;
> +
> +	snprintf(mp->m_unwritten_workqueue_name, XFS_WQ_NAME_LEN,
> +		 "xfs-conv/%s", mp->m_fsname);
> +	mp->m_unwritten_workqueue =
> +		alloc_workqueue(mp->m_unwritten_workqueue_name,
> +				WQ_MEM_RECLAIM, 1);

Hrm... mp->m_fsname can be MAXNAMELEN (256 in xfs), and XFS_WQ_NAME_LEN
you chose is 512.  As it stands there really isn't a problem here.

And, it sounds like you are wanting to replace this once Tejun improves
the interface...  maybe that was worth pointing out.

> +	if (!mp->m_unwritten_workqueue)
> +		goto out_destroy_data_iodone_queue;
> +
> +	return 0;
> +
> +out_destroy_data_iodone_queue:
> +	destroy_workqueue(mp->m_data_workqueue);
> +out:
> +	return -ENOMEM;
> +#undef XFS_WQ_NAME_LEN

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
