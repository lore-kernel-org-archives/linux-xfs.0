Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26590 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdJSWtc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2017 18:49:32 -0400
Date: Thu, 19 Oct 2017 15:49:27 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 03/15] xfs: remove post-bmap tracing in
 xfs_bmap_local_to_extents
Message-ID: <20171019224927.GS4755@magnolia>
References: <20171019065942.18813-1-hch@lst.de>
 <20171019065942.18813-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019065942.18813-4-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

On Thu, Oct 19, 2017 at 08:59:30AM +0200, Christoph Hellwig wrote:
> Now that we use xfs_iext_insert this is already covered by the tracing
> in that function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

> ---
>  fs/xfs/libxfs/xfs_bmap.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 06a9ac7dcdab..8c2e5d6bced2 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -920,8 +920,6 @@ xfs_bmap_local_to_extents(
>  	rec.br_state = XFS_EXT_NORM;
>  	xfs_iext_insert(ip, 0, 1, &rec, 0);
>  
> -	trace_xfs_bmap_post_update(ip, 0, xfs_bmap_fork_to_state(whichfork),
> -			_THIS_IP_);
>  	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
>  	ip->i_d.di_nblocks = 1;
>  	xfs_trans_mod_dquot_byino(tp, ip,
> -- 
> 2.14.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
