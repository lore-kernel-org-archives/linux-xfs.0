Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D21A87F3F
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 07:42:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6F3DFAC001
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2014 05:42:36 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id heq32UhIO93t1kSN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 26 Aug 2014 05:42:35 -0700 (PDT)
Date: Tue, 26 Aug 2014 08:42:31 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 3/4] xfs: fix double free in xlog_recover_commit_trans
Message-ID: <20140826124231.GD52815@bfoster.bfoster>
References: <1409016101-9511-1-git-send-email-david@fromorbit.com>
	<1409016101-9511-4-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1409016101-9511-4-git-send-email-david@fromorbit.com>
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

On Tue, Aug 26, 2014 at 11:21:40AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When an error occurs during buffer submission in
> xlog_recover_commit_trans(), we free the trans structure twice. Fix
> it by only freeing the structure in the caller regardless of the
> success or failure of the function.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_recover.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index 460cf98..23895d5 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3524,8 +3524,6 @@ out:
>  	if (!list_empty(&done_list))
>  		list_splice_init(&done_list, &trans->r_itemq);
>  
> -	xlog_recover_free_trans(trans);
> -
>  	error2 = xfs_buf_delwri_submit(&buffer_list);
>  	return error ? error : error2;
>  }
> @@ -3571,6 +3569,11 @@ xlog_recovery_process_ophdr(
>  	if (flags & XLOG_WAS_CONT_TRANS)
>  		flags &= ~XLOG_CONTINUE_TRANS;
>  
> +	/*
> +	 * Callees must not free the trans structure. We own it, so we'll decide
> +	 * if we need to free it or not based on the operation being done and
> +	 * it's result.

	   its

> +	 */
>  	switch (flags) {
>  	/* expected flag values */
>  	case 0:
> @@ -3582,7 +3585,8 @@ xlog_recovery_process_ophdr(
>  		break;
>  	case XLOG_COMMIT_TRANS:
>  		error = xlog_recover_commit_trans(log, trans, pass);
> -		break;
> +		xlog_recover_free_trans(trans);
> +		return error;
>  
>  	/* unexpected flag values */
>  	case XLOG_UNMOUNT_TRANS:
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
