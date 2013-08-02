Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FEE729DFB
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 21:46:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 0A06E304097
	for <xfs@oss.sgi.com>; Thu,  1 Aug 2013 19:46:27 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id eOlEdNvtqZg2b4TA for
	<xfs@oss.sgi.com>; Thu, 01 Aug 2013 19:46:26 -0700 (PDT)
Message-ID: <51FB1DBF.4030502@cn.fujitsu.com>
Date: Fri, 02 Aug 2013 10:47:27 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
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

On 08/01/2013 11:30 PM, Dwight Engen wrote:
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


looks good to me, thanks

Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>

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
