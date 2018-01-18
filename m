Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:34256 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756351AbeARO0s (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:26:48 -0500
Date: Thu, 18 Jan 2018 15:26:44 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] xfs: reflink should break pnfs leases before
        sharing blocks
Message-ID: <20180118142644.GA23196@lst.de>
References: <151626134674.25794.7913544634631149739.stgit@magnolia> <151626135332.25794.4917048406130796904.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151626135332.25794.4917048406130796904.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org

On Wed, Jan 17, 2018 at 11:42:33PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before we share blocks between files, we need to break the pnfs leases
> on the layout before we start slicing and dicing the block map.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_reflink.c |   32 +++++++++++++++++++++++++++++++-
>  1 file changed, 31 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index da5c490..a701336 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1249,6 +1249,34 @@ xfs_reflink_remap_blocks(
>  }
>  
>  /*
> + * Grab the exclusive iolock for a data copy from in to out, making sure to
> + * break the pnfs layout leases on out before proceeding.
> + */
> +static int
> +xfs_iolock_two_inodes_and_break_layout(
> +	struct inode		*inode_in,
> +	struct inode		*inode_out)
> +{
> +	uint			iolock = XFS_IOLOCK_EXCL;
> +	int			error;
> +
> +	if (inode_in < inode_out) {
> +		inode_lock(inode_in);
> +		inode_lock_nested(inode_out, I_MUTEX_NONDIR2);
> +	} else {
> +		inode_lock(inode_out);
> +	}
> +	error = xfs_break_layouts(inode_out, &iolock);
> +	if (error) {
> +		inode_unlock(inode_in);
> +		return error;
> +	}
> +	if (inode_in > inode_out)
> +		inode_lock_nested(inode_in, I_MUTEX_NONDIR2);
> +	return 0;

So we'll keep the other inode lock while recalling in one of the
cases?  In general I suspect we should be dropping all loops and
just restart all checks, similar to what we do for various cases
in the write path.
