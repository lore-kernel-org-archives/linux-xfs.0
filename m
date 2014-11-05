Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6396B7F3F
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 08:59:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E4A01AC006
	for <xfs@oss.sgi.com>; Wed,  5 Nov 2014 06:59:20 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VSbc56Vo1W1NqnXh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 05 Nov 2014 06:59:19 -0800 (PST)
Date: Wed, 5 Nov 2014 09:59:15 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/6] xfs: bulkstat chunk-formatter has issues
Message-ID: <20141105145914.GA35056@bfoster.bfoster>
References: <1415145921-31507-1-git-send-email-david@fromorbit.com>
	<1415145921-31507-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415145921-31507-4-git-send-email-david@fromorbit.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Nov 05, 2014 at 11:05:18AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The loop construct has issues:
> 	- clustidx is completely unused, so remove it.
> 	- the loop tries to be smart by terminating when the
> 	  "freecount" tells it that all inodes are free. Just drop
> 	  it as in most cases we have to scan all inodes in the
> 	  chunk anyway.
> 	- move the "user buffer left" condition check to the only
> 	  point where we consume space int eh user buffer.
> 	- move the initialisation of agino out of the loop, leaving
> 	  just a simple loop control logic using the clusteridx.
> 
> Also, double handling of the user buffer variables leads to problems
> tracking the current state - use the cursor variables directly
> rather than keeping local copies and then having to update the
> cursor before returning.
> 
> cc: <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_itable.c | 58 ++++++++++++++++++++++-------------------------------
>  1 file changed, 24 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 50a3e59..7ea2b11 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -283,59 +283,49 @@ xfs_bulkstat_ag_ichunk(
>  	xfs_ino_t			*lastino)
>  {
>  	char				__user **ubufp = acp->ac_ubuffer;
> -	int				ubleft = acp->ac_ubleft;
> -	int				ubelem = acp->ac_ubelem;
> -	int				chunkidx, clustidx;
> +	int				chunkidx;
>  	int				error = 0;
>  	xfs_agino_t			agino;
>  
> -	for (agino = irbp->ir_startino, chunkidx = clustidx = 0;
> -	     XFS_BULKSTAT_UBLEFT(ubleft) &&
> -	     irbp->ir_freecount < XFS_INODES_PER_CHUNK;
> -	     chunkidx++, clustidx++, agino++) {
> -		int		fmterror;	/* bulkstat formatter result */
> +	agino = irbp->ir_startino;
> +	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
> +	     chunkidx++, agino++) {
> +		int		fmterror;
>  		int		ubused;
>  		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
>  
> -		ASSERT(chunkidx < XFS_INODES_PER_CHUNK);
> -
>  		/* Skip if this inode is free */
>  		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
>  			*lastino = ino;
>  			continue;
>  		}
>  
> -		/*
> -		 * Count used inodes as free so we can tell when the
> -		 * chunk is used up.
> -		 */
> -		irbp->ir_freecount++;
> -
>  		/* Get the inode and fill in a single buffer */
>  		ubused = statstruct_size;
> -		error = formatter(mp, ino, *ubufp, ubleft, &ubused, &fmterror);
> -		if (fmterror == BULKSTAT_RV_NOTHING) {
> -			if (error && error != -ENOENT && error != -EINVAL) {
> -				ubleft = 0;
> -				break;
> -			}
> -			*lastino = ino;
> -			continue;
> -		}
> -		if (fmterror == BULKSTAT_RV_GIVEUP) {
> -			ubleft = 0;
> +		error = formatter(mp, ino, *ubufp, acp->ac_ubleft,
> +				  &ubused, &fmterror);
> +		if (fmterror == BULKSTAT_RV_GIVEUP ||
> +		    (error && error != -ENOENT && error != -EINVAL)) {
> +			acp->ac_ubleft = 0;
>  			ASSERT(error);
>  			break;
>  		}
> -		if (*ubufp)
> -			*ubufp += ubused;
> -		ubleft -= ubused;
> -		ubelem++;
> +
> +		/* be careful not to leak error if at end of chunk */
> +		if (fmterror == BULKSTAT_RV_NOTHING || error) {
> +			*lastino = ino;
> +			error = 0;
> +			continue;
> +		}
> +
> +		*ubufp += ubused;
> +		acp->ac_ubleft -= ubused;
> +		acp->ac_ubelem++;
>  		*lastino = ino;
> -	}
>  
> -	acp->ac_ubleft = ubleft;
> -	acp->ac_ubelem = ubelem;
> +		if (acp->ac_ubleft < statstruct_size)
> +			break;
> +	}
>  
>  	return error;
>  }
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
