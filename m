Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36276 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387835AbeHAN5g (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Aug 2018 09:57:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id h9-v6so19888101wro.3
        for <linux-xfs@vger.kernel.org>; Wed, 01 Aug 2018 05:12:05 -0700 (PDT)
Date: Wed, 1 Aug 2018 14:12:02 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 2/2] xfs: check da node magic in _node_lookup_int
Message-ID: <20180801121202.2nk4qwwizmvhla57@odin.usersys.redhat.com>
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

The patch looks good, but why wouldn't merge it into the previous one?

Both patches look reasonable to fit into a single one.

But, merging both or not.

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> ---
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

-- 
Carlos
