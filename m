Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TB9D67065674 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 06:09:13 -0500
Subject: Re: [PATCH] xfs: add a shrinker to background inode reclaim
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1272429248-5269-1-git-send-email-david@fromorbit.com>
References: <1272429248-5269-1-git-send-email-david@fromorbit.com>
Date: Thu, 29 Apr 2010 06:07:33 -0500
Message-ID: <1272539253.3221.64.camel@doink>
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

On Wed, 2010-04-28 at 14:34 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> On low memory boxes or those with highmem, kernel can OOM before the
> background reclaims inodes via xfssyncd. Add a shrinker to run inode
> reclaim so that it inode reclaim is expedited when memory is low.
> 
> This is more complex than it needs to be because the VM folk don't
> want a context added to the shrinker infrastructure. Hence we need
> to add a global list of XFS mount structures so the shrinker can
> traverse them.

I have some comments; one of them suggests a fairness
change.  But I know this fix is very important and
we're short on time so I'm going to pull this in as-is
and ask Linus to pull it as well.  

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/linux-2.6/xfs_super.c   |    5 ++
>  fs/xfs/linux-2.6/xfs_sync.c    |  112 +++++++++++++++++++++++++++++++++++++---
>  fs/xfs/linux-2.6/xfs_sync.h    |    7 ++-
>  fs/xfs/quota/xfs_qm_syscalls.c |    3 +-
>  fs/xfs/xfs_ag.h                |    1 +
>  fs/xfs/xfs_mount.h             |    1 +
>  6 files changed, 120 insertions(+), 9 deletions(-)
> 

. . .

> diff --git a/fs/xfs/linux-2.6/xfs_sync.c b/fs/xfs/linux-2.6/xfs_sync.c
> index 3a64179..3884e20 100644
> --- a/fs/xfs/linux-2.6/xfs_sync.c
> +++ b/fs/xfs/linux-2.6/xfs_sync.c
. . .
> @@ -134,7 +135,7 @@ restart:
>  		if (error == EFSCORRUPTED)
>  			break;
>  
> -	} while (1);
> +	} while ((*nr_to_scan)--);

Do you ever plan to return a negative value in *nr_to_scan?
(I know it matches the shrinker->shrink nr_to_scan argument
type.  More explanation on this question below.)

>  
>  	if (skipped) {
>  		delay(1);
. . .
> @@ -165,14 +169,18 @@ xfs_inode_ag_iterator(
>  			continue;
>  		}
>  		error = xfs_inode_ag_walk(mp, pag, execute, flags, tag,
> -						exclusive);
> +						exclusive, &nr);
>  		xfs_perag_put(pag);
>  		if (error) {
>  			last_error = error;
>  			if (error == EFSCORRUPTED)
>  				break;
>  		}
> +		if (nr <= 0)
> +			break;

Why check for negative here?  It will never go negative
as currently used.  (Defensive coding is a reasonable
explanation.)

>  	}
> +	if (nr_to_scan)
> +		*nr_to_scan = nr;
>  	return XFS_ERROR(last_error);
>  }
>  
. . .

> @@ -817,5 +827,93 @@ xfs_reclaim_inodes(
>  	int		mode)
>  {
>  	return xfs_inode_ag_iterator(mp, xfs_reclaim_inode, mode,
> -					XFS_ICI_RECLAIM_TAG, 1);
> +					XFS_ICI_RECLAIM_TAG, 1, NULL);
> +}
> +
> +/*
> + * Shrinker infrastructure.
> + *
> + * This is all far more complex than it needs to be. It adds a global list of
> + * mounts because the shrinkers can only call a global context. We need to make
> + * the shrinkers pass a context to avoid the need for global state.
> + */
> +static LIST_HEAD(xfs_mount_list);
> +static struct rw_semaphore xfs_mount_list_lock;
> +
> +static int
> +xfs_reclaim_inode_shrink(
> +	int		nr_to_scan,
> +	gfp_t		gfp_mask)
> +{
> +	struct xfs_mount *mp;
> +	struct xfs_perag *pag;
> +	xfs_agnumber_t	ag;
> +	int		reclaimable = 0;
> +
> +	if (nr_to_scan) {
> +		if (!(gfp_mask & __GFP_FS))
> +			return -1;
> +
> +		down_read(&xfs_mount_list_lock);
> +		list_for_each_entry(mp, &xfs_mount_list, m_mplist) {
> +			xfs_inode_ag_iterator(mp, xfs_reclaim_inode, 0,
> +					XFS_ICI_RECLAIM_TAG, 1, &nr_to_scan);
> +			if (nr_to_scan <= 0)
> +				break;

So we limit our scan using nr_to_scan, and we'll break out as
soon as we have exhausted that many scans (i.e., reclaimed
inodes).  We're enforcing this limit across the global list of
all mounts.  Since we don't update the list, and we traverse
the list from the beginning each time, the first mount always
gets hit, the ones later in the list may never be reached.

I think--given the restricted environment we're working in
here--we could make the scans more fair by rotating the starting
point for scans each time through.  I.e., record the last mount
point we scanned and pick up there next time (or at the front
of the list if that mount went away).

> +		}
> +		up_read(&xfs_mount_list_lock);
> +	}
> +
> +	down_read(&xfs_mount_list_lock);
> +	list_for_each_entry(mp, &xfs_mount_list, m_mplist) {
> +		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++) {
> +
> +			pag = xfs_perag_get(mp, ag);
> +			if (!pag->pag_ici_init) {
> +				xfs_perag_put(pag);
> +				continue;
> +			}
> +			reclaimable += pag->pag_ici_reclaimable;
> +			xfs_perag_put(pag);
> +		}
> +	}
> +	up_read(&xfs_mount_list_lock);
> +	return reclaimable;
> +}
> +
> +static struct shrinker xfs_inode_shrinker = {
> +	.shrink = xfs_reclaim_inode_shrink,
> +	.seeks = DEFAULT_SEEKS,
> +};
. . .
(The rest is fine)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
