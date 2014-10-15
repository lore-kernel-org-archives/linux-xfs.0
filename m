Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DA3B37F3F
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 07:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AC1CE304032
	for <xfs@oss.sgi.com>; Wed, 15 Oct 2014 05:59:41 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id OgTdDQObRwJhjw2O (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 Oct 2014 05:59:37 -0700 (PDT)
Date: Wed, 15 Oct 2014 08:59:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: bulkstat doesn't release AGI buffer on error
Message-ID: <20141015125927.GA63003@bfoster.bfoster>
References: <1413324728-4008-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1413324728-4008-1-git-send-email-david@fromorbit.com>
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

On Wed, Oct 15, 2014 at 09:12:08AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent refactoring of the bulkstat code left a small landmine in
> the code. If a inobt read fails, then the tree walk is aborted and
> returns without releasing the AGI buffer or freeing the cursor. This
> can lead to a subsequent bulkstat call hanging trying to grab the
> AGI buffer again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_itable.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index f1deb96..ef8ea05 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -427,7 +427,7 @@ xfs_bulkstat(
>  
>  			error = xfs_bulkstat_grab_ichunk(cur, agino, &icount, &r);
>  			if (error)
> -				break;
> +				goto del_cursor;
>  			if (icount) {
>  				irbp->ir_startino = r.ir_startino;
>  				irbp->ir_freecount = r.ir_freecount;
> @@ -442,7 +442,7 @@ xfs_bulkstat(
>  			error = xfs_inobt_lookup(cur, 0, XFS_LOOKUP_GE, &tmp);
>  		}
>  		if (error)
> -			break;
> +			goto del_cursor;
>  
>  		/*
>  		 * Loop through inode btree records in this ag,
> @@ -454,7 +454,7 @@ xfs_bulkstat(
>  			error = xfs_inobt_get_rec(cur, &r, &i);
>  			if (error || i == 0) {
>  				end_of_ag = 1;
> -				break;
> +				goto del_cursor;
>  			}
>  
>  			/*
> @@ -476,13 +476,17 @@ xfs_bulkstat(
>  			error = xfs_btree_increment(cur, 0, &tmp);
>  			cond_resched();
>  		}
> +
>  		/*
> -		 * Drop the btree buffers and the agi buffer.
> -		 * We can't hold any of the locks these represent
> -		 * when calling iget.
> +		 * Drop the btree buffers and the agi buffer as we can't hold any
> +		 * of the locks these represent when calling iget. If there is a
> +		 * pending error, then we are done.
>  		 */
> +del_cursor:
>  		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
>  		xfs_buf_relse(agbp);
> +		if (error)
> +			break;
>  		/*
>  		 * Now format all the good inodes into the user's buffer.
>  		 */
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
