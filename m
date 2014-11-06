Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CB7C97F51
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 10:32:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3CE3E8F8035
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 08:32:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id SQQ15YocNDVPgZCh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 08:32:24 -0800 (PST)
Date: Thu, 6 Nov 2014 11:32:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 6/6] xfs: track bulkstat progress by agino
Message-ID: <20141106163221.GD31429@bfoster.bfoster>
References: <1415279699-8739-1-git-send-email-david@fromorbit.com>
	<1415279699-8739-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415279699-8739-7-git-send-email-david@fromorbit.com>
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

On Fri, Nov 07, 2014 at 12:14:59AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The bulkstat main loop progress is tracked by the "lastino"
> variable, which is a full 64 bit inode. However, the loop actually
> works on agno/agino pairs, and so there's a significant disconnect
> between the rest of the loop and the main cursor. Convert this to
> use the agino, and pass the agino into the chunk formatting function
> and convert it too.
> 
> This gets rid of the inconsistency in the loop processing, and
> finally makes it simple for us to skip inodes at any point in the
> loop simply by incrementing the agino cursor.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_itable.c | 68 ++++++++++++++++++++++++++---------------------------
>  1 file changed, 34 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ff3f431..05e83a6 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -282,30 +282,31 @@ xfs_bulkstat_ag_ichunk(
>  	bulkstat_one_pf			formatter,
>  	size_t				statstruct_size,
>  	struct xfs_bulkstat_agichunk	*acp,
> -	xfs_ino_t			*lastino)
> +	xfs_agino_t			*last_agino)
>  {
>  	char				__user **ubufp = acp->ac_ubuffer;
>  	int				chunkidx;
>  	int				error = 0;
> -	xfs_agino_t			agino;
> +	xfs_agino_t			agino = irbp->ir_startino;
>  
> -	agino = irbp->ir_startino;
>  	for (chunkidx = 0; chunkidx < XFS_INODES_PER_CHUNK;
>  	     chunkidx++, agino++) {
>  		int		fmterror;
>  		int		ubused;
> -		xfs_ino_t	ino = XFS_AGINO_TO_INO(mp, agno, agino);
> +
> +		/* inode won't fit in buffer, we are done */
> +		if (acp->ac_ubleft < statstruct_size)
> +			break;
>  
>  		/* Skip if this inode is free */
> -		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free) {
> -			*lastino = ino;
> +		if (XFS_INOBT_MASK(chunkidx) & irbp->ir_free)
>  			continue;
> -		}
>  
>  		/* Get the inode and fill in a single buffer */
>  		ubused = statstruct_size;
> -		error = formatter(mp, ino, *ubufp, acp->ac_ubleft,
> -				  &ubused, &fmterror);
> +		error = formatter(mp, XFS_AGINO_TO_INO(mp, agno, agino),
> +				  *ubufp, acp->ac_ubleft, &ubused, &fmterror);
> +
>  		if (fmterror == BULKSTAT_RV_GIVEUP ||
>  		    (error && error != -ENOENT && error != -EINVAL)) {
>  			acp->ac_ubleft = 0;
> @@ -315,7 +316,6 @@ xfs_bulkstat_ag_ichunk(
>  
>  		/* be careful not to leak error if at end of chunk */
>  		if (fmterror == BULKSTAT_RV_NOTHING || error) {
> -			*lastino = ino;
>  			error = 0;
>  			continue;
>  		}
> @@ -323,12 +323,18 @@ xfs_bulkstat_ag_ichunk(
>  		*ubufp += ubused;
>  		acp->ac_ubleft -= ubused;
>  		acp->ac_ubelem++;
> -		*lastino = ino;
> -
> -		if (acp->ac_ubleft < statstruct_size)
> -			break;
>  	}
>  
> +	/*
> +	 * Post-update *last_agino. At this point, agino will always point one
> +	 * inode past the last inode we processed successfully. Hence we
> +	 * substract that inode when setting the *last_agino cursor so that we
> +	 * return the correct cookie to userspace. On the next bulkstat call,
> +	 * the inode under the lastino cookie will be skipped as we have already
> +	 * processed it here.
> +	 */
> +	*last_agino = agino - 1;
> +
>  	return error;
>  }
>  
> @@ -352,7 +358,6 @@ xfs_bulkstat(
>  	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
>  	size_t			irbsize; /* size of irec buffer in bytes */
>  	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
> -	xfs_ino_t		lastino; /* last inode number returned */
>  	int			nirbuf;	/* size of irbuf */
>  	int			ubcount; /* size of user's buffer */
>  	struct xfs_bulkstat_agichunk ac;
> @@ -361,11 +366,10 @@ xfs_bulkstat(
>  	/*
>  	 * Get the last inode value, see if there's nothing to do.
>  	 */
> -	lastino = *lastinop;
> -	agno = XFS_INO_TO_AGNO(mp, lastino);
> -	agino = XFS_INO_TO_AGINO(mp, lastino);
> +	agno = XFS_INO_TO_AGNO(mp, *lastinop);
> +	agino = XFS_INO_TO_AGINO(mp, *lastinop);
>  	if (agno >= mp->m_sb.sb_agcount ||
> -	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
> +	    *lastinop != XFS_AGINO_TO_INO(mp, agno, agino)) {
>  		*done = 1;
>  		*ubcountp = 0;
>  		return 0;
> @@ -420,7 +424,6 @@ xfs_bulkstat(
>  				irbp->ir_freecount = r.ir_freecount;
>  				irbp->ir_free = r.ir_free;
>  				irbp++;
> -				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>  			}
>  			/* Increment to the next record */
>  			error = xfs_btree_increment(cur, 0, &stat);
> @@ -461,7 +464,6 @@ xfs_bulkstat(
>  			/*
>  			 * Set agino to after this chunk and bump the cursor.
>  			 */

This comment could be updated since it's not safe to set agino here any
longer. Other than that, this all looks pretty good to me now:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> -			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>  			error = xfs_btree_increment(cur, 0, &stat);
>  			if (error || stat == 0) {
>  				end_of_ag = true;
> @@ -481,7 +483,9 @@ del_cursor:
>  		if (error)
>  			break;
>  		/*
> -		 * Now format all the good inodes into the user's buffer.
> +		 * Now format all the good inodes into the user's buffer. The
> +		 * call to xfs_bulkstat_ag_ichunk() sets up the agino pointer
> +		 * for the next loop iteration.
>  		 */
>  		irbufend = irbp;
>  		for (irbp = irbuf;
> @@ -489,7 +493,7 @@ del_cursor:
>  		     irbp++) {
>  			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
>  					formatter, statstruct_size, &ac,
> -					&lastino);
> +					&agino);
>  			if (error)
>  				break;
>  
> @@ -506,8 +510,7 @@ del_cursor:
>  		if (end_of_ag) {
>  			agno++;
>  			agino = 0;
> -		} else
> -			agino = XFS_INO_TO_AGINO(mp, lastino);
> +		}
>  	}
>  	/*
>  	 * Done, we're either out of filesystem or space to put the data.
> @@ -525,16 +528,13 @@ del_cursor:
>  	if (ac.ac_ubelem)
>  		error = 0;
>  
> -	if (agno >= mp->m_sb.sb_agcount) {
> -		/*
> -		 * If we ran out of filesystem, mark lastino as off
> -		 * the end of the filesystem, so the next call
> -		 * will return immediately.
> -		 */
> -		*lastinop = (xfs_ino_t)XFS_AGINO_TO_INO(mp, agno, 0);
> +	/*
> +	 * If we ran out of filesystem, lastino will point off the end of
> +	 * the filesystem so the next call will return immediately.
> +	 */
> +	*lastinop = XFS_AGINO_TO_INO(mp, agno, agino);
> +	if (agno >= mp->m_sb.sb_agcount)
>  		*done = 1;
> -	} else
> -		*lastinop = (xfs_ino_t)lastino;
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
