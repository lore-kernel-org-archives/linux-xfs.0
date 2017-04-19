Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22664 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935696AbdDST6D (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 15:58:03 -0400
Date: Wed, 19 Apr 2017 12:57:57 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 1/3] xfs: remove the unused XFS_MAXLINK_1 define
Message-ID: <20170419195757.GJ5193@birch.djwong.org>
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419192904.22203-2-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 09:29:02PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_format.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 6b7579e7b60a..d114ed80a076 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -930,10 +930,8 @@ static inline uint xfs_dinode_size(int version)
>  /*
>   * The 32 bit link count in the inode theoretically maxes out at UINT_MAX.
>   * Since the pathconf interface is signed, we use 2^31 - 1 instead.
> - * The old inode format had a 16 bit link count, so its maximum is USHRT_MAX.
>   */
>  #define	XFS_MAXLINK		((1U << 31) - 1U)
> -#define	XFS_MAXLINK_1		65535U

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  
>  /*
>   * Values for di_format
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
