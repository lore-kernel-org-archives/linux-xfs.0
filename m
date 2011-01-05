Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p051q6ts074320 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 19:52:07 -0600
Subject: Re: [PATCH 2/8] xfs: factor common post-write isize handling code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294116518-14908-3-git-send-email-david@fromorbit.com>
References: <1294116518-14908-1-git-send-email-david@fromorbit.com>
	<1294116518-14908-3-git-send-email-david@fromorbit.com>
Date: Tue, 04 Jan 2011 19:54:14 -0600
Message-ID: <1294192454.2485.719.camel@doink>
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

On Tue, 2011-01-04 at 15:48 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 

With one exception noted below, this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/linux-2.6/xfs_file.c |   52 +++++++++++++++++++++++-------------------
>  1 files changed, 28 insertions(+), 24 deletions(-)

. . .

> @@ -742,16 +755,7 @@ write_retry:
>  
>  	current->backing_dev_info = NULL;
>  
> -	isize = i_size_read(inode);
> -	if (unlikely(ret < 0 && ret != -EFAULT && iocb->ki_pos > isize))
> -		iocb->ki_pos = isize;
> -
> -	if (iocb->ki_pos > ip->i_size) {
> -		xfs_ilock(ip, XFS_ILOCK_EXCL);
> -		if (iocb->ki_pos > ip->i_size)
> -			ip->i_size = iocb->ki_pos;
> -		xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	}
> +	xfs_aio_write_isize_update(inode, &iocb->ki_pos, ret);
>  
>  	if (ret <= 0)
>  		goto out_unlock_internal;

Just below this point in the original code there is a
call to XFS_STATS_ADD(xs_write_bytes, ret); that also
needs to be removed, because xfs_aio_write_isize_update()
now does it for you.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
