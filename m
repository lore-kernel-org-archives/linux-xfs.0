Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23413 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936149AbdDST7N (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Apr 2017 15:59:13 -0400
Date: Wed, 19 Apr 2017 12:59:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 2/3] xfs: remove unused values from xfs_exntst_t
Message-ID: <20170419195909.GK5193@birch.djwong.org>
References: <20170419192904.22203-1-hch@lst.de>
 <20170419192904.22203-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170419192904.22203-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Wed, Apr 19, 2017 at 09:29:03PM +0200, Christoph Hellwig wrote:
> We only ever use the normal and unwritten states.  And the actual
> ondisk format (this enum isn't despite being in xfs_format.h) only
> has space for the unwritten bit anyway.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index d114ed80a076..8425884668a8 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -1588,7 +1588,6 @@ typedef enum {
>   */
>  typedef enum {
>  	XFS_EXT_NORM, XFS_EXT_UNWRITTEN,
> -	XFS_EXT_DMAPI_OFFLINE, XFS_EXT_INVALID
>  } xfs_exntst_t;
>  
>  /*
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
