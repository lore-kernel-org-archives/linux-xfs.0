Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0DAE57CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 18:16:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CFD3AC003
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 16:16:09 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	bYlGBob2u9lupdxx for <xfs@oss.sgi.com>;
	Tue, 30 Jul 2013 16:16:08 -0700 (PDT)
Date: Wed, 31 Jul 2013 09:16:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v7 6/7] xfs: add capable check to free eofblocks ioctl
Message-ID: <20130730231606.GO13468@dastard>
References: <20130729230705.128e4509@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130729230705.128e4509@oracle.com>
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
To: Dwight Engen <dwight.engen@oracle.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 29, 2013 at 11:07:05PM -0400, Dwight Engen wrote:
> Check for CAP_SYS_ADMIN since the caller can truncate preallocated
> blocks from files they do not own nor have write access to. A more
> fine grained access check was considered: require the caller to
> specify their own uid/gid and to use inode_permission to check for
> write, but this would not catch the case of an inode not reachable
> via path traversal from the callers mount namespace.
> 
> Add check for read-only filesystem to free eofblocks ioctl.
> 
> Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6e72eff..b1990ac 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1613,6 +1613,12 @@ xfs_file_ioctl(
>  		struct xfs_fs_eofblocks eofb;
>  		struct xfs_eofblocks keofb;
>  
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (IS_RDONLY(inode))
> +			return -XFS_ERROR(EROFS);
> +
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
