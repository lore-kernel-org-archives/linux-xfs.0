Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9HMhFOM027498 for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 17:43:16 -0500
Received: from ipmail05.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2DD9A147F54C
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 15:51:04 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	wXcMNuhpZ1xFsdQ5 for <xfs@oss.sgi.com>;
	Mon, 17 Oct 2011 15:51:04 -0700 (PDT)
Date: Tue, 18 Oct 2011 09:43:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
Message-ID: <20111017224309.GT3159@dastard>
References: <1318885528-7650-1-git-send-email-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1318885528-7650-1-git-send-email-cmaiolino@redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 17, 2011 at 07:05:28PM -0200, Carlos Maiolino wrote:
> Fixes a possible memory corruption when the link is larger than
> MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> S_ISLNK assert, since the inode mode is checked previously in
> xfs_readlink_by_handle() and via VFS.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good. One minor thing for consistency, but consider it:

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> ---
>  fs/xfs/xfs_vnodeops.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 51fc429..9ca6676 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -123,13 +123,18 @@ xfs_readlink(
>  
>  	xfs_ilock(ip, XFS_ILOCK_SHARED);
>  
> -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> -
>  	pathlen = ip->i_d.di_size;
>  	if (!pathlen)
>  		goto out;
>  
> +	if (pathlen > MAXPATHLEN) {
> +		xfs_emerg(mp, "%s: inode (%lld) symlink length (%d) too long",
> +			 __func__, (unsigned long long)ip->i_ino, pathlen);

xfs_alert() is generally used for such messages - it's not a fatal
error (yet)....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
