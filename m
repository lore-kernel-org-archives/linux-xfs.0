Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAGNOYJK235634 for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 17:24:34 -0600
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B11E5256EB9
	for <xfs@oss.sgi.com>; Wed, 16 Nov 2011 15:24:32 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZDJ1WDqT2g00Qwth for <xfs@oss.sgi.com>;
	Wed, 16 Nov 2011 15:24:32 -0800 (PST)
Date: Thu, 17 Nov 2011 10:24:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20111116232430.GB7046@dastard>
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

....

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

Don't need the undef here anymore as the #define is in the header
file and not local to the function.

> Index: linux-2.6/fs/xfs/xfs_mount.h
> ===================================================================
> --- linux-2.6.orig/fs/xfs/xfs_mount.h	2011-11-10 16:50:40.787796774 +0100
> +++ linux-2.6/fs/xfs/xfs_mount.h	2011-11-15 09:15:25.053316473 +0100
> @@ -211,6 +211,12 @@ typedef struct xfs_mount {
>  	struct shrinker		m_inode_shrink;	/* inode reclaim shrinker */
>  	int64_t			m_low_space[XFS_LOWSP_MAX];
>  						/* low free space thresholds */
> +
> +	struct workqueue_struct	*m_data_workqueue;
> +	struct workqueue_struct	*m_unwritten_workqueue;
> +#define XFS_WQ_NAME_LEN		512
> +	char			m_data_workqueue_name[XFS_WQ_NAME_LEN];
> +	char			m_unwritten_workqueue_name[XFS_WQ_NAME_LEN];
>  } xfs_mount_t;

Can't say I'm a great fan of this - making the workqueue code use
kstrdup() would be a much better better solution, IMO, just like was
done a while for the SLAB cache names to solve exactly the same
problem....

Regardless,

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
