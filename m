Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38881 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932126AbdJWPmf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Oct 2017 11:42:35 -0400
Date: Mon, 23 Oct 2017 08:42:30 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/4] xfs: add asserts for the mmap lock in
 xfs_{insert,collapse}_file_space
Message-ID: <20171023154230.GD5483@magnolia>
References: <20171023063017.11520-1-hch@lst.de>
 <20171023063017.11520-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171023063017.11520-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Mon, Oct 23, 2017 at 08:30:14AM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/xfs_bmap_util.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 034f3429ca8c..170b74c7f2d5 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1334,6 +1334,8 @@ xfs_collapse_file_space(
>  	bool			done = false;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> +
>  	trace_xfs_collapse_file_space(ip);
>  
>  	error = xfs_free_file_space(ip, offset, len);
> @@ -1408,6 +1410,8 @@ xfs_insert_file_space(
>  	bool			done = false;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_IOLOCK_EXCL));
> +	ASSERT(xfs_isilocked(ip, XFS_MMAPLOCK_EXCL));
> +
>  	trace_xfs_insert_file_space(ip);
>  
>  	error = xfs_prepare_shift(ip, offset);
> -- 
> 2.14.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
