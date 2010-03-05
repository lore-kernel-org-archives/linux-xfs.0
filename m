Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o25FiRUk256800 for <xfs@oss.sgi.com>; Fri, 5 Mar 2010 09:44:27 -0600
Subject: Re: [PATCH 3/3] xfs: Increase the default size of the reserved
	blocks pool
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1267667185-7736-4-git-send-email-david@fromorbit.com>
References: <1267667185-7736-1-git-send-email-david@fromorbit.com>
	<1267667185-7736-4-git-send-email-david@fromorbit.com>
Date: Fri, 05 Mar 2010 09:45:53 -0600
Message-ID: <1267803953.2478.13.camel@doink>
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

On Thu, 2010-03-04 at 12:46 +1100, Dave Chinner wrote:
> The current default size of the reserved blocks pool is easy to deplete
> with certain workloads, in particular workloads that do lots of concurrent
> delayed allocation extent conversions.  If enough transactions are running
> in parallel and the entire pool is consumed then subsequent calls to
> xfs_trans_reserve() will fail with ENOSPC.  Also add a rate limited
> warning so we know if this starts happening again.
> 
> This is an updated version of an old patch from Lachlan McIlroy.

Looks good.  The comment and code rearrangements are an
improvement.

I have also reviewed the other two patches in the series
(including the updated patch 2) and they too look good.

> Signed-off-by: Dave Chinner <david@fromorbit.com>
         So is it got to be fromorbit or redhat?
         (You used both in this series.)

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_mount.c |   49 +++++++++++++++++++++++++++++--------------------
>  1 files changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> index c207fef..e79b56b 100644
> --- a/fs/xfs/xfs_mount.c
> +++ b/fs/xfs/xfs_mount.c
> @@ -1097,13 +1097,15 @@ xfs_default_resblks(xfs_mount_t *mp)
>  	__uint64_t resblks;
>  
>  	/*
> -	 * We default to 5% or 1024 fsbs of space reserved, whichever is smaller.
> -	 * This may drive us straight to ENOSPC on mount, but that implies
> -	 * we were already there on the last unmount. Warn if this occurs.
> +	 * We default to 5% or 8192 fsbs of space reserved, whichever is
> +	 * smaller.  This is intended to cover concurrent allocation
> +	 * transactions when we initially hit enospc. These each require a 4
> +	 * block reservation. Hence by default we cover roughly 2000 concurrent
> +	 * allocation reservations.
>  	 */
>  	resblks = mp->m_sb.sb_dblocks;
>  	do_div(resblks, 20);
> -	resblks = min_t(__uint64_t, resblks, 1024);
> +	resblks = min_t(__uint64_t, resblks, 8192);
>  	return resblks;
>  }
>  
> @@ -1417,6 +1419,9 @@ xfs_mountfs(
>  	 * when at ENOSPC. This is needed for operations like create with
>  	 * attr, unwritten extent conversion at ENOSPC, etc. Data allocations
>  	 * are not allowed to use this reserved space.
> +	 *
> +	 * This may drive us straight to ENOSPC on mount, but that implies
> +	 * we were already there on the last unmount. Warn if this occurs.
>  	 */
>  	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
>  		resblks = xfs_default_resblks(mp);
> @@ -1725,26 +1730,30 @@ xfs_mod_incore_sb_unlocked(
>  				lcounter += rem;
>  			}
>  		} else {				/* Taking blocks away */
> -
>  			lcounter += delta;
> +			if (lcounter >= 0) {
> +				mp->m_sb.sb_fdblocks = lcounter +
> +							XFS_ALLOC_SET_ASIDE(mp);
> +				return 0;
> +			}
>  
> -		/*
> -		 * If were out of blocks, use any available reserved blocks if
> -		 * were allowed to.
> -		 */

I was just looking at this code yesterday, and got confused
by the indentation of this comment.  You beat me to fixing it.
I also think your rearranging of the logic below is an improvement.

> +			/*
> +			 * We are out of blocks, use any available reserved
> +			 * blocks if were allowed to.
> +			 */
> +			if (!rsvd)
> +				return XFS_ERROR(ENOSPC);
>  
> -			if (lcounter < 0) {
> -				if (rsvd) {
> -					lcounter = (long long)mp->m_resblks_avail + delta;
> -					if (lcounter < 0) {
> -						return XFS_ERROR(ENOSPC);
> -					}
> -					mp->m_resblks_avail = lcounter;
> -					return 0;
> -				} else {	/* not reserved */
> -					return XFS_ERROR(ENOSPC);
> -				}
> +			lcounter = (long long)mp->m_resblks_avail + delta;
> +			if (lcounter >= 0) {
> +				mp->m_resblks_avail = lcounter;
> +				return 0;
>  			}
> +			printk_once(KERN_WARNING
> +				"Filesystem \"%s\": reserve blocks depleted! "
> +				"Consider increasing reserve pool size.",
> +				mp->m_fsname);
> +			return XFS_ERROR(ENOSPC);
>  		}
>  
>  		mp->m_sb.sb_fdblocks = lcounter + XFS_ALLOC_SET_ASIDE(mp);



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
