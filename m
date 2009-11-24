Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAONOxwk176475 for <xfs@oss.sgi.com>; Tue, 24 Nov 2009 17:24:59 -0600
Message-ID: <4B0C6B5A.6080702@sandeen.net>
Date: Tue, 24 Nov 2009 17:25:14 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH XFS] Fix error return for fallocate() on XFS
References: <20091124215253.GA10693@obsidianresearch.com>
In-Reply-To: <20091124215253.GA10693@obsidianresearch.com>
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
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Jason Gunthorpe wrote:
> Noticed that through glibc fallocate would return 28 rather than -1
> and errno = 28 for ENOSPC. The xfs routines uses XFS_ERROR format
> positive return error codes while the syscalls use negative return codes.
> Fixup the two cases in xfs_vn_fallocate syscall to convert to negative.

grumblegrumble xfs error signs grumble...

> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

Thanks,

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> ---
>  fs/xfs/linux-2.6/xfs_iops.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/linux-2.6/xfs_iops.c b/fs/xfs/linux-2.6/xfs_iops.c
> index cd42ef7..1f3b4b8 100644
> --- a/fs/xfs/linux-2.6/xfs_iops.c
> +++ b/fs/xfs/linux-2.6/xfs_iops.c
> @@ -573,8 +573,8 @@ xfs_vn_fallocate(
>  	bf.l_len = len;
>  
>  	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> -	error = xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
> -				      0, XFS_ATTR_NOLOCK);
> +	error = -xfs_change_file_space(ip, XFS_IOC_RESVSP, &bf,
> +				       0, XFS_ATTR_NOLOCK);
>  	if (!error && !(mode & FALLOC_FL_KEEP_SIZE) &&
>  	    offset + len > i_size_read(inode))
>  		new_size = offset + len;
> @@ -585,7 +585,7 @@ xfs_vn_fallocate(
>  
>  		iattr.ia_valid = ATTR_SIZE;
>  		iattr.ia_size = new_size;
> -		error = xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
> +		error = -xfs_setattr(ip, &iattr, XFS_ATTR_NOLOCK);
>  	}
>  
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
