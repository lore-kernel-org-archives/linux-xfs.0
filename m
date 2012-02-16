Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1G6vNB1234983 for <xfs@oss.sgi.com>; Thu, 16 Feb 2012 00:57:23 -0600
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	l66uwbrPVfBz7ZBj for <xfs@oss.sgi.com>;
	Wed, 15 Feb 2012 22:57:21 -0800 (PST)
Date: Thu, 16 Feb 2012 17:57:19 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/5] xfs: use per-filesystem I/O completion workqueues
Message-ID: <20120216065719.GA14132@dastard>
References: <20120207181037.745771452@bombadil.infradead.org>
	<20120207181154.999363063@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120207181154.999363063@bombadil.infradead.org>
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

On Tue, Feb 07, 2012 at 01:10:38PM -0500, Christoph Hellwig wrote:
> The new concurrency managed workqueues are cheap enough that we can create
> per-filesystem instead of global workqueues.  This allows us to remove the
> trylock or defer scheme on the ilock, which is not helpful once we have
> outstanding log reservations until finishing a size update.

Agreed.

And it removes some of the issues with dependencies between
filesystems like loopback mounted XFS-on-XFS filesystems, though to
fix them completely we also need per-filesystem log workqueues. Is
it worth just converting that one as well in this patch just to
remove all global work queues?


> Signed-off-by: Christoph Hellwig <hch@lst.de>

....
> +STATIC int
> +xfs_init_mount_workqueues(
> +	struct xfs_mount	*mp)
> +{
> +#define XFS_WQ_NAME_LEN		512
> +	char			name[XFS_WQ_NAME_LEN];
> +
> +	snprintf(name, XFS_WQ_NAME_LEN, "xfs-data/%s", mp->m_fsname);
> +	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1);
> +	if (!mp->m_data_workqueue)
> +		goto out;

As of b196be8 ("workqueue: make alloc_workqueue() take printf fmt and
args for name"), this dance is not necessary. somethign like:

	mp->m_data_workqueue = alloc_workqueue(name, WQ_MEM_RECLAIM, 1,
						"xfs-data/%s", mp->m_fsname);

will work just fine.

Also, I thin kwe want significant parallelism on this workqueue -
having an inode block on an ilock shoul dnot stop us from processing
other ioends in the same fs....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
