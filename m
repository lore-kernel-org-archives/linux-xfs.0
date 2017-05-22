Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45522 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933464AbdEVUoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 16:44:12 -0400
Date: Mon, 22 May 2017 13:43:35 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH V2] xfs: fix unaligned access in xfs_btree_visit_blocks
Message-ID: <20170522204335.GM4519@birch.djwong.org>
References: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
 <1ad226af-4b1b-18ca-274c-20a030ca4768@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ad226af-4b1b-18ca-274c-20a030ca4768@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>

On Mon, May 22, 2017 at 03:06:40PM -0500, Eric Sandeen wrote:
> This structure copy was throwing unaligned access warnings on sparc64:
> 
> Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]
> 
> xfs_btree_copy_ptrs does a memcpy, which avoids it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Heh. :(

Looks ok to me...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 5392674..3a673ba 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4395,7 +4395,7 @@ struct xfs_btree_split_args {
>  			xfs_btree_readahead_ptr(cur, ptr, 1);
>  
>  			/* save for the next iteration of the loop */
> -			lptr = *ptr;
> +			xfs_btree_copy_ptrs(cur, &lptr, ptr, 1);
>  		}
>  
>  		/* for each buffer in the level */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
