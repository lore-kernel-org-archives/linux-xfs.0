Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388868AbeHANx0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 1 Aug 2018 09:53:26 -0400
Date: Wed, 1 Aug 2018 08:07:56 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH 2/2] xfs: check da node magic in _node_lookup_int
Message-ID: <20180801120755.GD48176@bfoster>
References: <153307925470.7924.18204385078598751297.stgit@magnolia>
 <153307926059.7924.13909891112765252120.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153307926059.7924.13909891112765252120.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Tue, Jul 31, 2018 at 04:21:00PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Before we start processing what we /think/ is a da3 node block, actually
> check the magic to make sure that we're looking at a node block.  This
> way we won't blow the asserts in _node_hdr_from_disk on corrupted
> metadata.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_da_btree.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
> index 8ffe17b223da..376bee94b5dd 100644
> --- a/fs/xfs/libxfs/xfs_da_btree.c
> +++ b/fs/xfs/libxfs/xfs_da_btree.c
> @@ -1523,8 +1523,10 @@ xfs_da3_node_lookup_int(
>  			break;
>  		}
>  
> -		blk->magic = XFS_DA_NODE_MAGIC;
> +		if (magic != XFS_DA_NODE_MAGIC && magic != XFS_DA3_NODE_MAGIC)
> +			return -EFSCORRUPTED;
>  
> +		blk->magic = XFS_DA_NODE_MAGIC;
>  
>  		/*
>  		 * Search an intermediate node for a match.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
