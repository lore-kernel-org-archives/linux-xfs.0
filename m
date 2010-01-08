Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o08L10Hu072472 for <xfs@oss.sgi.com>; Fri, 8 Jan 2010 15:01:00 -0600
Content-class: urn:content-classes:message
MIME-Version: 1.0
Subject: RE: [PATCH] XFS: Don't flush stale inodes
Date: Fri, 8 Jan 2010 14:59:40 -0600
Message-ID: <1AB9A794DBDDF54A8A81BE2296F7BDFE012A6936@cf--amer001e--3.americas.sgi.com>
In-Reply-To: <1262399980-19277-1-git-send-email-david@fromorbit.com>
From: "Alex Elder" <aelder@sgi.com>
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

Dave Chinner wrote:
> Because inodes remain in cache much longer than inode buffers do
> under memory pressure, we can get the situation where we have stale,
> dirty inodes being reclaimed but the backing storage has been freed.
> Hence we should never, ever flush XFS_ISTALE inodes to disk as
> there is no guarantee that the backing buffer is in cache and
> still marked stale when the flush occurs.

Looks good.  Seems like this could be the source of
some pretty gnarly problems.

> Signed-off-by: Dave Chinner <david@fromorbit.com>

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_inode.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index c2618db..e5c9953 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2846,10 +2846,14 @@ xfs_iflush(
>  	mp = ip->i_mount;
> 
>  	/*
> -	 * If the inode isn't dirty, then just release the inode
> -	 * flush lock and do nothing.
> +	 * If the inode isn't dirty, then just release the inode flush lock and
> +	 * do nothing. Treat stale inodes the same; we cannot rely on the
> +	 * backing buffer remaining stale in cache for the remaining life of
> +	 * the stale inode and so xfs_itobp() below may give us a buffer that
> +	 * no longer contains inodes below. Doing this stale check here also
> +	 * avoids forcing the log on pinned, stale inodes.
>  	 */
> -	if (xfs_inode_clean(ip)) {
> +	if (xfs_inode_clean(ip) || xfs_iflags_test(ip, XFS_ISTALE)) {
>  		xfs_ifunlock(ip);
>  		return 0;
>  	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
