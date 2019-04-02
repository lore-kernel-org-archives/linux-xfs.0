Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:48982 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfDBSgp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Apr 2019 14:36:45 -0400
Date: Tue, 2 Apr 2019 10:56:32 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs: return correct XFS_IOC_DIOINFO for DAX inode
Message-ID: <20190402175632.GD5147@magnolia>
References: <b3af182f-a547-9d04-3b29-232857e83fc4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3af182f-a547-9d04-3b29-232857e83fc4@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>

On Tue, Apr 02, 2019 at 10:44:38AM -0500, Eric Sandeen wrote:
> pmem is byte addressable, and indeed byte-aligned DIO works on
> a DAX file.  So, teach XFS_IOC_DIOINFO to return the correct
> alignment information if IS_DAX(inode).

If it's a DAX filesystem, do we want to try to steer people towards
things like 2MB pages since (in theory) we can get away with fewer page
table mappings?  And (seeing as that's mmap that cares, not directio)
would advertising preferential page mapping sizes be more appropriate
advertised in a different ioctl?

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 6ecdbb3..35eae7d 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1919,12 +1919,21 @@ xfs_file_ioctl(
>  	}
>  	case XFS_IOC_DIOINFO: {
>  		struct dioattr	da;
> -		xfs_buftarg_t	*target =
> -			XFS_IS_REALTIME_INODE(ip) ?
> -			mp->m_rtdev_targp : mp->m_ddev_targp;
>  
> -		da.d_mem =  da.d_miniosz = target->bt_logical_sectorsize;
> -		da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> +		if (IS_DAX(inode)) {
> +			/* pmem is byte addressable */
> +			da.d_mem = 1;
> +			da.d_miniosz = 1;
> +			da.d_maxiosz = INT_MAX;
> +		} else {
> +			xfs_buftarg_t	*target =
> +				XFS_IS_REALTIME_INODE(ip) ?
> +				mp->m_rtdev_targp : mp->m_ddev_targp;
> +
> +			da.d_mem = target->bt_logical_sectorsize;
> +			da.d_miniosz = target->bt_logical_sectorsize;
> +			da.d_maxiosz = INT_MAX & ~(da.d_miniosz - 1);
> +		}
>  
>  		if (copy_to_user(arg, &da, sizeof(da)))
>  			return -EFAULT;
> 
