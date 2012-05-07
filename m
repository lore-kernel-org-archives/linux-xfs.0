Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q47NIhYZ212428 for <xfs@oss.sgi.com>; Mon, 7 May 2012 18:18:43 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	VEjVB5g3s5O1f2Eg for <xfs@oss.sgi.com>;
	Mon, 07 May 2012 16:18:40 -0700 (PDT)
Date: Tue, 8 May 2012 09:18:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs: fix memory reclaim deadlock on agi buffer
Message-ID: <20120507231838.GB5091@dastard>
References: <CAH4wwdHb0=9UtTiwz-fAYovXGO6J8soda31S+dgCGNKBA3j5sw@mail.gmail.com>
	<1336421497-1554-1-git-send-email-treestem@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1336421497-1554-1-git-send-email-treestem@gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Mon, May 07, 2012 at 04:11:37PM -0400, Peter Watkins wrote:
> Note xfs_iget can be called while holding a locked agi buffer. If
> it goes into memory reclaim then inode teardown may try to lock the
> same buffer. Prevent the deadlock by calling radix_tree_preload
> with GFP_NOFS.
> 
> Signed-off-by: Peter Watkins <treestem@gmail.com>

This might be one for the stable kernel as well. Ben, can you add a
"cc: stable@vger.kernel.org" to the commit message for this one?

> ---
>  fs/xfs/xfs_iget.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index bcc6c24..8c6f806 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -334,9 +334,10 @@ xfs_iget_cache_miss(
>  	/*
>  	 * Preload the radix tree so we can insert safely under the
>  	 * write spinlock. Note that we cannot sleep inside the preload
> -	 * region.
> +	 * region. Since we can be called from transaction context, don't
> +	 * recurse into the file system.
>  	 */
> -	if (radix_tree_preload(GFP_KERNEL)) {
> +	if (radix_tree_preload(GFP_NOFS)) {
>  		error = EAGAIN;
>  		goto out_destroy;
>  	}

Looks good. Thanks for the quick turn-around, Peter.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
