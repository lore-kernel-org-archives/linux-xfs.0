Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6DHCZDP173822 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 12:12:36 -0500
Date: Fri, 13 Jul 2012 12:18:10 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 1/2] xfs: really fix the cursor leak in
	xfs_alloc_ag_vextent_near
Message-ID: <20120713171810.GG29979@sgi.com>
References: <1342042843-1773-1-git-send-email-david@fromorbit.com>
	<1342042843-1773-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1342042843-1773-2-git-send-email-david@fromorbit.com>
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

Hi Dave,

On Thu, Jul 12, 2012 at 07:40:42AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current cursor is reallocated when retrying the allocation, so
> the existing cursor needs to be destroyed in both the restart and
> the failure cases.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Tested-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  fs/xfs/xfs_alloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_alloc.c b/fs/xfs/xfs_alloc.c
> index 9d1aeb7..f654f51 100644
> --- a/fs/xfs/xfs_alloc.c
> +++ b/fs/xfs/xfs_alloc.c
> @@ -1074,13 +1074,13 @@ restart:
>  	 * If we couldn't get anything, give up.
>  	 */
>  	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
> +		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> +

I'd suggest setting cnt_cur = NULL here, but it is very clearly overwritten
right away in the case of goto restart.  No need.

This looks good to me.  I'll pull this in today.

Reviewed-by: Ben Myers <bpm@sgi.com>

Regards,
	Ben

>  		if (!forced++) {
>  			trace_xfs_alloc_near_busy(args);
>  			xfs_log_force(args->mp, XFS_LOG_SYNC);
>  			goto restart;
>  		}
> -
> -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  		trace_xfs_alloc_size_neither(args);
>  		args->agbno = NULLAGBLOCK;
>  		return 0;
> -- 
> 1.7.10
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
