Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55540 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727079AbfHNVjF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Aug 2019 17:39:05 -0400
Date: Thu, 15 Aug 2019 07:37:53 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 01/18] xfs: compat_ioctl: use compat_ptr()
Message-ID: <20190814213753.GP6129@dread.disaster.area>
References: <20190814204259.120942-1-arnd@arndb.de>
 <20190814204259.120942-2-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814204259.120942-2-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>, Allison Collins <allison.henderson@oracle.com>, Nick Bowler <nbowler@draconx.ca>, Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <dchinner@redhat.com>

On Wed, Aug 14, 2019 at 10:42:28PM +0200, Arnd Bergmann wrote:
> For 31-bit s390 user space, we have to pass pointer arguments through
> compat_ptr() in the compat_ioctl handler.

Seems fair enough, but...
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/xfs/xfs_ioctl32.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index 7fcf7569743f..ad91e81a2fcf 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -547,7 +547,7 @@ xfs_file_compat_ioctl(
>  	struct inode		*inode = file_inode(filp);
>  	struct xfs_inode	*ip = XFS_I(inode);
>  	struct xfs_mount	*mp = ip->i_mount;
> -	void			__user *arg = (void __user *)p;
> +	void			__user *arg = compat_ptr(p);
>  	int			error;
>  
>  	trace_xfs_file_compat_ioctl(ip);
> @@ -576,7 +576,7 @@ xfs_file_compat_ioctl(
>  	case XFS_IOC_SCRUB_METADATA:
>  	case XFS_IOC_BULKSTAT:
>  	case XFS_IOC_INUMBERS:
> -		return xfs_file_ioctl(filp, cmd, p);
> +		return xfs_file_ioctl(filp, cmd, (unsigned long)arg);

I don't really like having to sprinkle special casts through the
code because of this.

Perhaps do something like:

static inline unsigned long compat_ptr_mask(unsigned long p)
{
	return (unsigned long)compat_ptr(p);
}

and then up front you can do:

	void	__user *arg;

	p = compat_ptr_mask(p);
	arg = (void __user *)p;


and then the rest of the code remains unchanged by now uses p
correctly instead of having to change all the code to cast arg back
to an unsigned long...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
