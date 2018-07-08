Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:58202 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbeGHPxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Jul 2018 11:53:44 -0400
Date: Sun, 8 Jul 2018 08:53:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 6/8] xfs: fix imbalanced locking
Message-ID: <20180708155344.GD8625@infradead.org>
References: <1530846750-6686-1-git-send-email-shan.hai@oracle.com>
 <1530846750-6686-7-git-send-email-shan.hai@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1530846750-6686-7-git-send-email-shan.hai@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Shan Hai <shan.hai@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Fri, Jul 06, 2018 at 11:12:27AM +0800, Shan Hai wrote:
> The XFS_ILOCK_SHARED type lock is held in the xfs_ioc_fsgetxattr
> but does not released when the inode is in local format, fix it by
> eleasing the lock on the local format inode.
> 
> Signed-off-by: Shan Hai <shan.hai@oracle.com>
> ---
>  fs/xfs/xfs_ioctl.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 0ef5ece5634c..246562615ccd 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -907,7 +907,10 @@ xfs_ioc_fsgetxattr(
>  	} else {
>  		if (ip->i_df.if_flags & XFS_IFEXTENTS)
>  			fa.fsx_nextents = xfs_iext_count(&ip->i_df);
> -		else
> +		else if (ip->i_df.if_flags & XFS_IFINLINE) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			return 0;
> +		} else
>  			fa.fsx_nextents = ip->i_d.di_nextents;
>  	}
>  	xfs_iunlock(ip, XFS_ILOCK_SHARED);

This looks odd, and the changelog confuses even more.

Please avoid the early return, which means we miss the copy_to_user
of the fa struct.  It seems to me like this should be something like:

		if (ip->i_df.if_flags & XFS_IFEXTENTS)
                        fa.fsx_nextents = xfs_iext_count(&ip->i_df);
		esle if (ip->i_df.if_flags & XFS_IFINLINE)
			fa.fsx_nextents = 0;
                else
			fa.fsx_nextents = ip->i_d.di_nextents;
