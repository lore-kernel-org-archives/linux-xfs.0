Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C470D7F3F
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 08:45:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63C4CAC003
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2014 06:45:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id B0P9wzx9QhQHDCTC for <xfs@oss.sgi.com>;
	Thu, 16 Oct 2014 06:45:06 -0700 (PDT)
Message-ID: <543FCBE0.2040609@sandeen.net>
Date: Thu, 16 Oct 2014 08:45:04 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: bulkstat doesn't release AGI buffer on error
References: <1413324728-4008-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On 10/14/14 5:12 PM, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The recent refactoring of the bulkstat code left a small landmine in
> the code. If a inobt read fails, then the tree walk is aborted and
> returns without releasing the AGI buffer or freeing the cursor. This
> can lead to a subsequent bulkstat call hanging trying to grab the
> AGI buffer again.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Can you add a cc: stable, too?

> ---
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
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
