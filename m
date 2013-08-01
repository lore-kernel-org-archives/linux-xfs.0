Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4985329DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 11:22:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF2CDAC006
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 09:22:19 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WVNzegjLiMvIYNCm for
	<xfs@oss.sgi.com>; Thu, 01 Aug 2013 09:22:19 -0700 (PDT)
Message-ID: <51FA8C67.9020305@redhat.com>
Date: Thu, 01 Aug 2013 12:27:19 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v8 6/7] xfs: add capability check to free eofblocks ioctl
References: <20130801113020.0d43302f@oracle.com>
In-Reply-To: <20130801113020.0d43302f@oracle.com>
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

On 08/01/2013 11:30 AM, Dwight Engen wrote:
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

Thanks Dwight!

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_ioctl.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 60d9d1e..c8f3511 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1620,6 +1620,12 @@ xfs_file_ioctl(
>  		struct xfs_fs_eofblocks eofb;
>  		struct xfs_eofblocks keofb;
>  
> +		if (!capable(CAP_SYS_ADMIN))
> +			return -EPERM;
> +
> +		if (mp->m_flags & XFS_MOUNT_RDONLY)
> +			return -XFS_ERROR(EROFS);
> +
>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
