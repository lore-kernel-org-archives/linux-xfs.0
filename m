Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BF3F7F8C
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 12:59:15 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EE657304062
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 10:59:14 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cB8MaihSlrjtlcHK (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 10:59:13 -0800 (PST)
Date: Tue, 4 Nov 2014 13:59:08 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 4/6] xfs: bulkstat main loop logic is a mess
Message-ID: <20141104185908.GF55611@bfoster.bfoster>
References: <1415105601-6455-1-git-send-email-david@fromorbit.com>
	<1415105601-6455-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415105601-6455-5-git-send-email-david@fromorbit.com>
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

On Tue, Nov 04, 2014 at 11:53:19PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> There are a bunch of variables tha tare more wildy scoped than they
> need to be, obfuscated user buffer checks and tortured "next inode"
> tracking. This all needs cleaning up to expose the real issues that
> need fixing.
> 
> cc: <stable@vger.kernel.org>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_itable.c | 55 ++++++++++++++++++++++-------------------------------
>  1 file changed, 23 insertions(+), 32 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index ff31965..fc4cf5d 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -345,30 +345,23 @@ xfs_bulkstat(
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
> @@ -393,8 +386,13 @@ xfs_bulkstat(
>  	 * inode returned; 0 means start of the allocation group.
>  	 */
>  	rval = 0;
> -	while (XFS_BULKSTAT_UBLEFT(ac.ac_ubleft) && agno < mp->m_sb.sb_agcount) {
> -		cond_resched();
> +	while (ac.ac_ubleft >= statstruct_size && agno < mp->m_sb.sb_agcount) {
> +		struct xfs_inobt_rec_incore	*irbp = irbuf;
> +		struct xfs_inobt_rec_incore	*irbufend = irbuf + nirbuf;
> +		bool				end_of_ag = false;
> +		int				icount = 0;
> +		int				stat;
> +
>  		error = xfs_ialloc_read_agi(mp, NULL, agno, &agbp);
>  		if (error)
>  			break;
> @@ -404,10 +402,6 @@ xfs_bulkstat(
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
> @@ -432,7 +426,7 @@ xfs_bulkstat(
>  			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
>  		}
>  		if (error || stat == 0) {
> -			end_of_ag = 1;
> +			end_of_ag = true;
>  			goto del_cursor;
>  		}
>  
> @@ -445,7 +439,7 @@ xfs_bulkstat(
>  
>  			error = xfs_inobt_get_rec(cur, &r, &stat);
>  			if (error || stat == 0) {
> -				end_of_ag = 1;
> +				end_of_ag = true;
>  				goto del_cursor;
>  			}
>  
> @@ -467,7 +461,7 @@ xfs_bulkstat(
>  			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>  			error = xfs_btree_increment(cur, 0, &stat);
>  			if (error || stat == 0) {
> -				end_of_ag = 1;
> +				end_of_ag = true;
>  				goto del_cursor;
>  			}
>  			cond_resched();
> @@ -488,7 +482,7 @@ del_cursor:
>  		 */
>  		irbufend = irbp;
>  		for (irbp = irbuf;
> -		     irbp < irbufend && XFS_BULKSTAT_UBLEFT(ac.ac_ubleft);
> +		     irbp < irbufend && ac.ac_ubleft >= statstruct_size;
>  		     irbp++) {
>  			error = xfs_bulkstat_ag_ichunk(mp, agno, irbp,
>  					formatter, statstruct_size, &ac,
> @@ -499,17 +493,14 @@ del_cursor:
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
> +		if (error)
>  			break;

This stood out to me as potentially broken as it introduces a
non-deterministic error path. The preceding loop can overwrite error
since it iterates until either all records are handled or the buffer is
consumed.

That said, this is all fixed up by the next patch and the rest looks
fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

... though I think the error check should technically be introduced by
the next patch.

Brian

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
