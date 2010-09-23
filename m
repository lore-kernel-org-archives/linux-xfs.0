Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NHGEgr137896 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 12:16:15 -0500
Subject: Re: [PATCH 12/16] xfs: implement batched inode lookups for AG walking
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1285137869-10310-13-git-send-email-david@fromorbit.com>
References: <1285137869-10310-1-git-send-email-david@fromorbit.com>
	<1285137869-10310-13-git-send-email-david@fromorbit.com>
Date: Thu, 23 Sep 2010 12:17:05 -0500
Message-ID: <1285262225.1973.60.camel@doink>
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

On Wed, 2010-09-22 at 16:44 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> With the reclaim code separated from the generic walking code, it is
> simple to implement batched lookups for the generic walk code.
> Separate out the inode validation from the execute operations and
> modify the tree lookups to get a batch of inodes at a time.

Two comments below.  I noticed your discussion with Christoph
so I'll look for the new version before I stamp it "reviewed."

> Reclaim operations will be optimised separately.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_sync.c    |  104 +++++++++++++++++++++++-----------------
>  fs/xfs/linux-2.6/xfs_sync.h    |    3 +-
>  fs/xfs/quota/xfs_qm_syscalls.c |   26 +++++-----
>  3 files changed, 75 insertions(+), 58 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 7737a13..227ecde 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
> @@ -39,11 +39,19 @@
>  #include <linux/kthread.h>
>  #include <linux/freezer.h>
>  
> +/*
> + * The inode lookup is done in batches to keep the amount of lock traffic and
> + * radix tree lookups to a minimum. The batch size is a trade off between
> + * lookup reduction and stack usage. This is in the reclaim path, so we can't
> + * be too greedy.
> + */
> +#define XFS_LOOKUP_BATCH	32

Did you come up with 32 empirically?  As the OS evolves might another
value be better?  And if a larger value would improve things, how
would allocating the arrays rather than making them automatic (stack)
affect things?  (Just a discussion point, I think it's fine as-is.)

>  STATIC int
>  xfs_inode_ag_walk(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> +	int			(*grab)(struct xfs_inode *ip),
>  	int			(*execute)(struct xfs_inode *ip,
>  					   struct xfs_perag *pag, int flags),
>  	int			flags)
> @@ -52,48 +60,68 @@ xfs_inode_ag_walk(
>  	int			last_error = 0;
>  	int			skipped;
>  	int			done;
> +	int			nr_found;
>  
>  restart:
>  	done = 0;
>  	skipped = 0;
>  	first_index = 0;
> +	nr_found = 0;
>  	do {
>  		int		error = 0;
> -		int		nr_found;
> -		xfs_inode_t	*ip;
> +		int		i;
> +		struct xfs_inode *batch[XFS_LOOKUP_BATCH];
>  
>  		read_lock(&pag->pag_ici_lock);
>  		nr_found = radix_tree_gang_lookup(&pag->pag_ici_root,
> -				(void **)&ip, first_index, 1);
> +					(void **)batch, first_index,
> +					XFS_LOOKUP_BATCH);
>  		if (!nr_found) {
>  			read_unlock(&pag->pag_ici_lock);
>  			break;
>  		}
>  
>  		/*
> -		 * Update the index for the next lookup. Catch overflows
> -		 * into the next AG range which can occur if we have inodes
> -		 * in the last block of the AG and we are currently
> -		 * pointing to the last inode.
> +		 * Grab the inodes before we drop the lock. if we found
> +		 * nothing, nr == 0 and the loop will be skipped.
>  		 */
> -		first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> -		if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> -			done = 1;
> -
> -		/* execute releases pag->pag_ici_lock */
> -		error = execute(ip, pag, flags);
> -		if (error == EAGAIN) {
> -			skipped++;
> -			continue;
> +		for (i = 0; i < nr_found; i++) {
> +			struct xfs_inode *ip = batch[i];
> +
> +			if (done || grab(ip))
> +				batch[i] = NULL;
> +
> +			/*
> +			 * Update the index for the next lookup. Catch overflows
> +			 * into the next AG range which can occur if we have inodes
> +			 * in the last block of the AG and we are currently
> +			 * pointing to the last inode.
> +			 */
> +			first_index = XFS_INO_TO_AGINO(mp, ip->i_ino + 1);
> +			if (first_index < XFS_INO_TO_AGINO(mp, ip->i_ino))
> +				done = 1;

It sounds like you're going to re-work this, but
I'll mention this for you to consider anyway.  I
don't know that the "done" flag here should be
needed.  The gang lookup should never return
anything beyond the end of the AG.  It seems
like you ought to be able to detect when you've
covered all the whole AG elsewhere, *not*
on every entry found in this inner loop and
also *not* while holding the lock.


> +		}
> +
> +		/* unlock now we've grabbed the inodes. */
> +		read_unlock(&pag->pag_ici_lock);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
