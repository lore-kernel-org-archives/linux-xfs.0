Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0VMu6oN125535 for <xfs@oss.sgi.com>; Tue, 31 Jan 2012 16:56:06 -0600
Date: Wed, 1 Feb 2012 09:56:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch] xfs: remove an unneeded NULL check
Message-ID: <20120131225601.GQ9090@dastard>
References: <20120128105501.GB25092@elgon.mountain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20120128105501.GB25092@elgon.mountain>
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: xfs-masters@oss.sgi.com, Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

On Sat, Jan 28, 2012 at 01:55:01PM +0300, Dan Carpenter wrote:
> Smatch complains because we check "commit_lsn" for NULL inconsistently.
> fs/xfs/xfs_log_cil.c +705 xfs_log_commit_cil(43) error: we previously
> 	assumed 'commit_lsn' could be null (see line 688)
> xfs_log_commit_cil() is only called from one place, and "commit_lsn" is
> a valid pointer, so I've removed the NULL check.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index d4fadbe..d9c4652 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -685,8 +685,7 @@ xfs_log_commit_cil(
>  
>  	/* lock out background commit */
>  	down_read(&log->l_cilp->xc_ctx_lock);
> -	if (commit_lsn)
> -		*commit_lsn = log->l_cilp->xc_ctx->sequence;
> +	*commit_lsn = log->l_cilp->xc_ctx->sequence;
>  
>  	xlog_cil_insert_items(log, log_vector, tp->t_ticket);

There's a set of reviewed patches (for 3.3) that change all this
code. The null check might still be there, but that needs to be
checked.

On that note, Ben, can you get all of the reviewed patches that are
currently outstanding into the for-next branch of the oss tree? We
need this done sooner rather than later so that all our current
testing during development is done with those patches applied. it
also helps us to avoid conflicts between patchsets that touch the
same code (which I have quite a few of at the moment)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
