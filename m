Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49250 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdGMTXw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 15:23:52 -0400
Date: Thu, 13 Jul 2017 12:23:47 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: fixup xfs_attr_get_ilocked
Message-ID: <20170713192347.GF4151@magnolia>
References: <20170713113304.8079-1-hch@lst.de>
 <20170713113304.8079-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713113304.8079-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2017 at 01:33:01PM +0200, Christoph Hellwig wrote:
> The comment mentioned the wrong lock.  Also add an ASSERT to assert
> this locking precondition.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ef8a1c75a467..de7b9bd30bec 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -114,12 +114,14 @@ xfs_inode_hasattr(
>   * Overall external interface routines.
>   *========================================================================*/
>  
> -/* Retrieve an extended attribute and its value.  Must have iolock. */
> +/* Retrieve an extended attribute and its value.  Must have ilock. */
>  int
>  xfs_attr_get_ilocked(
>  	struct xfs_inode	*ip,
>  	struct xfs_da_args	*args)
>  {
> +	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> +
>  	if (!xfs_inode_hasattr(ip))
>  		return -ENOATTR;
>  	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
