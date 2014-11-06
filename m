Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AEF27F51
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 10:32:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 68F978F8033
	for <xfs@oss.sgi.com>; Thu,  6 Nov 2014 08:32:11 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h5CDzDYqGBHHFWox (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Nov 2014 08:32:10 -0800 (PST)
Date: Thu, 6 Nov 2014 11:32:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: bulkstat main loop logic is a mess
Message-ID: <20141106163206.GC31429@bfoster.bfoster>
References: <1415279699-8739-1-git-send-email-david@fromorbit.com>
	<1415279699-8739-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415279699-8739-5-git-send-email-david@fromorbit.com>
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

On Fri, Nov 07, 2014 at 12:14:57AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are a bunch of variables tha tare more wildy scoped than they
> need to be, obfuscated user buffer checks and tortured "next inode"
> tracking. This all needs cleaning up to expose the real issues that
> need fixing.
> 
> cc: <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---

This one contains the changes to the outer loop to move the ubleft
checks from the iteration logic to within the loop (before the end_of_ag
check). Changes look fine to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_itable.c | 56 +++++++++++++++++++++++------------------------------
>  1 file changed, 24 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7ea2b11..acae335 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -348,30 +348,23 @@ xfs_bulkstat(
>  	xfs_agino_t		agino;	/* inode # in allocation group */
>  	xfs_agnumber_t		agno;	/* allocation group number */
>  	xfs_btree_cur_t		*cur;	/* btree cursor for ialloc btree */
> -	int			end_of_ag; /* set if we've seen the ag end */
> -	int			error;	/* error code */
> -	int			icount;	/* count of inodes good in irbuf */
>  	size_t			irbsize; /* size of irec buffer in bytes */
> -	xfs_ino_t		ino;	/* inode number (filesystem) */
> -	xfs_inobt_rec_incore_t	*irbp;	/* current irec buffer pointer */
>  	xfs_inobt_rec_incore_t	*irbuf;	/* start of irec buffer */
> -	xfs_inobt_rec_incore_t	*irbufend; /* end of good irec buffer entries */
>  	xfs_ino_t		lastino; /* last inode number returned */
>  	int			nirbuf;	/* size of irbuf */
>  	int			rval;	/* return value error code */
>  	int			ubcount; /* size of user's buffer */
> -	int			stat;
>  	struct xfs_bulkstat_agichunk ac;
> +	int			error = 0;
>  
>  	/*
>  	 * Get the last inode value, see if there's nothing to do.
>  	 */
> -	ino = (xfs_ino_t)*lastinop;
> -	lastino = ino;
> -	agno = XFS_INO_TO_AGNO(mp, ino);
> -	agino = XFS_INO_TO_AGINO(mp, ino);
> +	lastino = *lastinop;
> +	agno = XFS_INO_TO_AGNO(mp, lastino);
> +	agino = XFS_INO_TO_AGINO(mp, lastino);
>  	if (agno >= mp->m_sb.sb_agcount ||
> -	    ino != XFS_AGINO_TO_INO(mp, agno, agino)) {
> +	    lastino != XFS_AGINO_TO_INO(mp, agno, agino)) {
>  		*done = 1;
>  		*ubcountp = 0;
>  		return 0;
> @@ -396,8 +389,13 @@ xfs_bulkstat(
>  	 * inode returned; 0 means start of the allocation group.
>  	 */
>  	rval = 0;
> -	while (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft) && agno < mp->m_sb.sb_agcount) {
> -		cond_resched();
> +	while (agno < mp->m_sb.sb_agcount) {
> +		struct xfs_inobt_rec_incore	*irbp = irbuf;
> +		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
> +		bool				end_of_ag = false;
> +		int				icount = 0;
> +		int				stat;
> +
>  		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
>  		if (error)
>  			break;
> @@ -407,10 +405,6 @@ xfs_bulkstat(
>  		 */
>  		cur = xfs_inobt_init_cursor(mp, NULL, agbp, agno,
>  					    XFS_BTNUM_INO);
> -		irbp = irbuf;
> -		irbufend = irbuf + nirbuf;
> -		end_of_ag = 0;
> -		icount = 0;
>  		if (agino > 0) {
>  			/*
>  			 * In the middle of an allocation group, we need to get
> @@ -435,7 +429,7 @@ xfs_bulkstat(
>  			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
>  		}
>  		if (error || stat == 0) {
> -			end_of_ag = 1;
> +			end_of_ag = true;
>  			goto del_cursor;
>  		}
>  
> @@ -448,7 +442,7 @@ xfs_bulkstat(
>  
>  			error = xfs_inobt_get_rec(cur, &r, &stat);
>  			if (error || stat == 0) {
> -				end_of_ag = 1;
> +				end_of_ag = true;
>  				goto del_cursor;
>  			}
>  
> @@ -470,7 +464,7 @@ xfs_bulkstat(
>  			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>  			error = xfs_btree_increment(cur, 0, &stat);
>  			if (error || stat == 0) {
> -				end_of_ag = 1;
> +				end_of_ag = true;
>  				goto del_cursor;
>  			}
>  			cond_resched();
> @@ -491,7 +485,7 @@ del_cursor:
>  		 */
>  		irbufend = irbp;
>  		for (irbp = irbuf;
> -		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ac.ac_ubleft);
> +		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
>  		     irbp++) {
>  			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
>  					formatter, statstruct_size, &ac,
> @@ -502,17 +496,15 @@ del_cursor:
>  			cond_resched();
>  		}
>  
> -		/*
> -		 * Set up for the next loop iteration.
> -		 */
> -		if (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft)) {
> -			if (end_of_ag) {
> -				agno++;
> -				agino = 0;
> -			} else
> -				agino = XFS_INO_TO_AGINO(mp, lastino);
> -		} else
> +		/* If we've run out of space, we are done */
> +		if (ac.ac_ubleft < statstruct_size)
>  			break;
> +
> +		if (end_of_ag) {
> +			agno++;
> +			agino = 0;
> +		} else
> +			agino = XFS_INO_TO_AGINO(mp, lastino);
>  	}
>  	/*
>  	 * Done, we're either out of filesystem or space to put the data.
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
