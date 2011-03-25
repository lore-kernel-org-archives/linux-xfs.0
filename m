Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKxn3a246370 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:59:49 -0500
Subject: Re: [PATCH 6/6] xfs: stop using the page cache to back the buffer
	cache
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-7-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-7-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:02:53 -0500
Message-ID: <1301086973.2537.686.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that the buffer cache has it's own LRU, we do not need to use
> the page cache to provide persistent caching and reclaim
> infrastructure. Convert the buffer cache to use alloc_pages()
> instead of the page cache. This will remove all the overhead of page
> cache management from setup and teardown of the buffers, as well as
> needing to mark pages accessed as we find buffers in the buffer
> cache.
> 
> By avoiding the page cache, we also remove the need to keep state in
> the page_private(page) field for persistant storage across buffer
> free/buffer rebuild and so all that code can be removed. This also
> fixes the long-standing problem of not having enough bits in the
> page_private field to track all the state needed for a 512
> sector/64k page setup.
> 
> It also removes the need for page locking during reads as the pages
> are unique to the buffer and nobody else will be attempting to
> access them.
> 
> Finally, it removes the buftarg address space lock as a point of
> global contention on workloads that allocate and free buffers
> quickly such as when creating or removing large numbers of inodes in
> parallel. This remove the 16TB limit on filesystem size on 32 bit
> machines as the page index (32 bit) is no longer used for lookups
> of metadata buffers - the buffer cache is now solely indexed by disk
> address which is stored in a 64 bit field in the buffer.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

This is really a great change, a long time coming.

I have two comments below, one of which I think is
a real (but simple) problem.

I've been using this series all week without problems.  
This patch cleans things up so nicely I *would* like
to include it in 2.6.39 if you can update it and turn
it around with a pull request for me.

If so, I'll do some sanity testing and push it to
oss.sgi.com, then send a pull request to Linus with
it early next week.

Reviewed-by: Alex Elder <aelder@sgi.com>

PS  I'm sorry it took so long to get back to you on
    this stuff.  I've had a hard time getting my brain
    re-engaged this week after coming back from vacation
    for some reason...

> ---
>  fs/xfs/linux-2.6/xfs_buf.c |  337 ++++++++++----------------------------------
>  fs/xfs/linux-2.6/xfs_buf.h |   40 +-----
>  2 files changed, 81 insertions(+), 296 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
> index fe51e09..19b0769 100644
> --- a/fs/xfs/linux-2.6/xfs_buf.c
> +++ b/fs/xfs/linux-2.6/xfs_buf.c

. . .

> @@ -719,7 +659,7 @@ xfs_buf_readahead(
>  {
>  	struct backing_dev_info *bdi;
>  
> -	bdi = target->bt_mapping->backing_dev_info;
> +	bdi = blk_get_backing_dev_info(target->bt_bdev);
>  	if (bdi_read_congested(bdi))
>  		return;

Why not just target->bt_bdi here?  In which case, just skip
the local variable and call:

	if (bdi_read_congested(target->bt_bdi))
		return;

. . .

> @@ -1728,12 +1546,11 @@ xfs_alloc_buftarg(
>  	btp->bt_mount = mp;
>  	btp->bt_dev =  bdev->bd_dev;
>  	btp->bt_bdev = bdev;
> +	btp->bt_bdi = blk_get_backing_dev_info(bdev);

I think you need to check for a null return value here.

	if (!btp->bt_bdi)
		goto error;

>  	INIT_LIST_HEAD(&btp->bt_lru);
>  	spin_lock_init(&btp->bt_lru_lock);
>  	if (xfs_setsize_buftarg_early(btp, bdev))
>  		goto error;
> -	if (xfs_mapping_buftarg(btp, bdev))
> -		goto error;
>  	if (xfs_alloc_delwrite_queue(btp, fsname))
>  		goto error;
>  	btp->bt_shrinker.shrink = xfs_buftarg_shrink;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
