Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2PKvWru245735 for <xfs@oss.sgi.com>; Fri, 25 Mar 2011 15:57:32 -0500
Subject: Re: [PATCH 1/6] xfs: preallocation transactions do not need to be
	synchronous
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1300860870-15471-2-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
	<1300860870-15471-2-git-send-email-david@fromorbit.com>
Date: Fri, 25 Mar 2011 16:00:36 -0500
Message-ID: <1301086836.2537.679.camel@doink>
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

On Wed, 2011-03-23 at 17:14 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Preallocation and hole punch transactions are currently synchronous
> and this is causing performance problems in some cases. The
> transactions don't need to be synchronous as we don't need to
> guarantee the preallocation is persistent on disk until a
> fdatasync, fsync, sync operation occurs. If the file is opened
> O_SYNC or O_DATASYNC, only then should the transaction be issued
> synchronously.

There's a minor (but important) bug in this.  Other than that
this looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/linux-2.6/xfs_file.c  |    4 ++++
>  fs/xfs/linux-2.6/xfs_ioctl.c |    4 ++++
>  fs/xfs/xfs_vnodeops.c        |    3 ++-
>  fs/xfs/xfs_vnodeops.h        |    1 +
>  4 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_file.c b/fs/xfs/linux-2.6/xfs_file.c
> index ae59865..baa2cb3 100644
> --- a/fs/xfs/linux-2.6/xfs_file.c
> +++ b/fs/xfs/linux-2.6/xfs_file.c
> @@ -896,6 +896,7 @@ xfs_file_fallocate(
>  	xfs_flock64_t	bf;
>  	xfs_inode_t	*ip = XFS_I(inode);
>  	int		cmd = XFS_IOC_RESVSP;
> +	int		attr_flags = XFS_ATTR_NOLOCK;
>  
>  	if (mode & ~(FALLOC_FL_KEEP_SIZE |
>  		     FALLOC_FL_PUNCH_HOLE |
> @@ -922,6 +923,9 @@ xfs_file_fallocate(
>  			goto out_unlock;
>  	}
>  
> +	if (file->f_flags & O_DSYNC)
> +		attr_flags |= XFS_ATTR_SYNC;
> +
>  	error = -xfs_change_file_space(ip, cmd, &bf, 0, XFS_ATTR_NOLOCK);

You need to pass attr_flags as the last argument here.

>  	if (error)
>  		goto out_unlock;

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
