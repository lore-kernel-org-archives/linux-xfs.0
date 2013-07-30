Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 10B7C7CBF
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 07:37:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02E60304077
	for <xfs@oss.sgi.com>; Tue, 30 Jul 2013 05:37:01 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 5O1IY2AZfnH2kERE for
	<xfs@oss.sgi.com>; Tue, 30 Jul 2013 05:37:00 -0700 (PDT)
Message-ID: <51F7B2A3.7030007@redhat.com>
Date: Tue, 30 Jul 2013 08:33:39 -0400
From: Brian Foster <bfoster@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH v7 6/7] xfs: add capable check to free eofblocks ioctl
References: <20130729230705.128e4509@oracle.com>
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

On 07/29/2013 11:07 PM, Dwight Engen wrote:
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

I see that we aren't using XFS_ERROR() on the EPERM returns in
xfs_file_ioctl(), but I see it used for other capability checks
elsewhere (i.e., down in xfs_growfs_data()). Perhaps somebody can chime
in as to the reasoning for that..? I guess it could be that we wouldn't
want to fire a BUG() at the interface point (ioctl()) on debug kernels
for every time a user attempts an operation they don't have the ability
to perform (e.g., we should notice on internal failures, not when
userspace sends us something wrong).

> +		if (IS_RDONLY(inode))
> +			return -XFS_ERROR(EROFS);
> +

This should probably be consistent with the other read-only checks in
the ioctl code and check the xfs_mount structure:

	if (mp->m_flags & XFS_MOUNT_RDONLY)
		return -XFS_ERROR(EROFS);

Brian

>  		if (copy_from_user(&eofb, arg, sizeof(eofb)))
>  			return -XFS_ERROR(EFAULT);
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
