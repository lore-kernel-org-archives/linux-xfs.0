Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26510 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753170AbdJSWtP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 18:49:15 -0400
Date: Thu, 19 Oct 2017 15:49:09 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/15] xfs: make better use of the 'state' variable in
 xfs_bmap_del_extent_real
Message-ID: <20171019224909.GR4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20171019065942.18813-3-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:29AM +0200, Christoph Hellwig wrote:
> We already have all the information about the fork aѕ well as additional
> tracing information, so pass that to xfs_iext_remove().
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 676fc8aed67f..06a9ac7dcdab 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -5022,8 +5022,7 @@ xfs_bmap_del_extent_real(
>  		 * Matches the whole extent.  Delete the entry.
>  		 */
>  		trace_xfs_bmap_pre_update(ip, *idx, state, _THIS_IP_);
> -		xfs_iext_remove(ip, *idx, 1,
> -				whichfork == XFS_ATTR_FORK ? BMAP_ATTRFORK : 0);
> +		xfs_iext_remove(ip, *idx, 1, state);
>  		--*idx;
>  
>  		XFS_IFORK_NEXT_SET(ip, whichfork,
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
