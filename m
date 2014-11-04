Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D545B7F8C
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 12:58:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A3F63304067
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 10:58:29 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GLwU1yJoGrapEJlP (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Nov 2014 10:58:25 -0800 (PST)
Date: Tue, 4 Nov 2014 13:58:21 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 1/6] xfs: bulkstat btree walk doesn't terminate
Message-ID: <20141104185821.GC55611@bfoster.bfoster>
References: <1415105601-6455-1-git-send-email-david@fromorbit.com>
	<1415105601-6455-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1415105601-6455-2-git-send-email-david@fromorbit.com>
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

On Tue, Nov 04, 2014 at 11:53:16PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The bulkstat code has several different ways of detecting the end of
> an AG when doing a walk. They are not consistently detected, and the
> code that checks for the end of AG conditions is not consistently
> coded. Hence the are conditions where the walk code can get stuck in
> an endless loop making no progress and not triggering any
> termination conditions.
> 
> Convert all the "tmp/i" status return codes from btree operations
> to a common name (stat) and apply end-of-ag detection to these
> operations consistently.
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks Ok...

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_itable.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index 7765ff7..16737cb 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -356,7 +356,6 @@ xfs_bulkstat(
>  	int			end_of_ag; /* set if we've seen the ag end */
>  	int			error;	/* error code */
>  	int                     fmterror;/* bulkstat formatter result */
> -	int			i;	/* loop index */
>  	int			icount;	/* count of inodes good in irbuf */
>  	size_t			irbsize; /* size of irec buffer in bytes */
>  	xfs_ino_t		ino;	/* inode number (filesystem) */
> @@ -366,11 +365,11 @@ xfs_bulkstat(
>  	xfs_ino_t		lastino; /* last inode number returned */
>  	int			nirbuf;	/* size of irbuf */
>  	int			rval;	/* return value error code */
> -	int			tmp;	/* result value from btree calls */
>  	int			ubcount; /* size of user's buffer */
>  	int			ubleft;	/* bytes left in user's buffer */
>  	char			__user *ubufp;	/* pointer into user's buffer */
>  	int			ubelem;	/* spaces used in user's buffer */
> +	int			stat;
>  
>  	/*
>  	 * Get the last inode value, see if there's nothing to do.
> @@ -436,13 +435,15 @@ xfs_bulkstat(
>  				agino = r.ir_startino + XFS_INODES_PER_CHUNK;
>  			}
>  			/* Increment to the next record */
> -			error = xfs_btree_increment(cur, 0, &tmp);
> +			error = xfs_btree_increment(cur, 0, &stat);
>  		} else {
>  			/* Start of ag.  Lookup the first inode chunk */
> -			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
> +			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &stat);
>  		}
> -		if (error)
> +		if (error || stat == 0) {
> +			end_of_ag = 1;
>  			goto del_cursor;
> +		}
>  
>  		/*
>  		 * Loop through inode btree records in this ag,
> @@ -451,8 +452,8 @@ xfs_bulkstat(
>  		while (irbp < irbufend && icount < ubcount) {
>  			struct xfs_inobt_rec_incore	r;
>  
> -			error = xfs_inobt_get_rec(cur, &r, &i);
> -			if (error || i == 0) {
> +			error = xfs_inobt_get_rec(cur, &r, &stat);
> +			if (error || stat == 0) {
>  				end_of_ag = 1;
>  				goto del_cursor;
>  			}
> @@ -473,8 +474,8 @@ xfs_bulkstat(
>  			 * Set agino to after this chunk and bump the cursor.
>  			 */
>  			agino = r.ir_startino + XFS_INODES_PER_CHUNK;
> -			error = xfs_btree_increment(cur, 0, &tmp);
> -			if (error) {
> +			error = xfs_btree_increment(cur, 0, &stat);
> +			if (error || stat == 0) {
>  				end_of_ag = 1;
>  				goto del_cursor;
>  			}
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
