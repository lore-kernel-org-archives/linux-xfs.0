Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33904 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751384AbdGMTXn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 15:23:43 -0400
Date: Thu, 13 Jul 2017 12:23:38 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/4] xfs: assert =?utf-8?Q?lock?=
 =?utf-8?Q?ing_precond=D1=96tion?= in xfs_attr_list_int_ilocked
Message-ID: <20170713192338.GE4151@magnolia>
References: <20170713113304.8079-1-hch@lst.de>
 <20170713113304.8079-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170713113304.8079-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Jul 13, 2017 at 01:33:02PM +0200, Christoph Hellwig wrote:

Not sure about the garbled utf8 crud in the subject line, but otherwise
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_attr_list.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> index 545eca508d42..7740c8a5e736 100644
> --- a/fs/xfs/xfs_attr_list.c
> +++ b/fs/xfs/xfs_attr_list.c
> @@ -463,6 +463,8 @@ xfs_attr_list_int_ilocked(
>  {
>  	struct xfs_inode		*dp = context->dp;
>  
> +	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> +
>  	/*
>  	 * Decide on what work routines to call based on the inode size.
>  	 */
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
