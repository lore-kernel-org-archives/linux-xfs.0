Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96BOY3L181119 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 06:24:34 -0500
Subject: Re: [PATCH] xfs: fix unused variable warning
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1317877059-7024-1-git-send-email-david@fromorbit.com>
References: <1317877059-7024-1-git-send-email-david@fromorbit.com>
Date: Thu, 6 Oct 2011 06:24:27 -0500
Message-ID: <1317900267.3139.9.camel@doink>
MIME-Version: 1.0
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

On Thu, 2011-10-06 at 15:57 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Fix this warning:
> 
> fs/xfs/xfs_aops.c: In function 'xfs_end_io_direct_write':
> fs/xfs/xfs_aops.c:1280:17: warning: unused variable 'inode' [-Wunused-variable]
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

That line of code is not present in the current XFS
master branch on oss.sgi.com.

					-Alex

> ---
>  fs/xfs/xfs_aops.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 462e937..11b2aad 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -1277,7 +1277,6 @@ xfs_end_io_direct_write(
>  	bool			is_async)
>  {
>  	struct xfs_ioend	*ioend = iocb->private;
> -	struct inode		*inode = ioend->io_inode;
>  
>  	/*
>  	 * blockdev_direct_IO can return an error even after the I/O



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
