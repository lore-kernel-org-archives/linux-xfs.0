Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBGKnpfL122842 for <xfs@oss.sgi.com>; Thu, 16 Dec 2010 14:49:51 -0600
Subject: Re: [PATCH 1/7] xfs: ensure sync write errors are returned
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1292376208-16282-2-git-send-email-david@fromorbit.com>
References: <1292376208-16282-1-git-send-email-david@fromorbit.com>
	<1292376208-16282-2-git-send-email-david@fromorbit.com>
Date: Thu, 16 Dec 2010 14:50:49 -0600
Message-ID: <1292532649.2457.54.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2010-12-15 at 12:23 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> xfs_file_aio_write() only returns the error from synchronous
> flushing of the data and inode if error == 0. At the point where
> error is being checked, it is guaranteed to be > 0. Therefore any

Actually, we have this above the affected code:
        ...
        error = -ret;   
        if (ret <= 0)
                goto out_unlock_internal;

So ret must be positive, therefore error is negative
(the negative of the number of bytes written).  In
other words, we enter this block without having seen
an error.

The return at the end of the function is:
	return -error;

And by the convoluted logic here, that means that the
value of error should be a negative byte count if
successful, or a positive errno otherwise.

And since filemap_write_and_wait_range() returns a
negative errno, your fix doesn't look right to me.

The existing code is wrong and should be fixed, but a
better fix might make the meaning of the variable "error"
a little less weird.

					-Alex

> errors returned by the data or fsync flush will never be returned.
> Fix the checks so we overwrite the current error once and only if an
> error really occurred.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index ba8ad42..e1eaec2 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -769,7 +769,7 @@ write_retry:
>  			mutex_unlock(&inode->i_mutex);
>  
>  		error2 = filemap_write_and_wait_range(mapping, pos, end);
> -		if (!error)
> +		if (error2)
>  			error = error2;
>  		if (need_i_mutex)
>  			mutex_lock(&inode->i_mutex);
> @@ -777,7 +777,7 @@ write_retry:
>  
>  		error2 = -xfs_file_fsync(file,
>  					 (file->f_flags & __O_SYNC) ? 0 : 1);
> -		if (!error)
> +		if (error2 && error >= 0)
>  			error = error2;
>  	}
>  



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
