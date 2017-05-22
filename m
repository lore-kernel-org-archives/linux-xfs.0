Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:45296 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758088AbdEVQCV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 May 2017 12:02:21 -0400
Subject: Re: [PATCH] xfs: fix unaligned access in xfs_btree_visit_blocks
References: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <391768ae-059c-d915-c0fb-d4e6a18c4fd4@sandeen.net>
Date: Mon, 22 May 2017 11:02:19 -0500
MIME-Version: 1.0
In-Reply-To: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

On 5/22/17 10:48 AM, Eric Sandeen wrote:
> This was throwing unaligned access warnings on sparc64:
> 
> Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---

(FYI lightly tested only - did a mount & fs traversal of the fs in
question with this patch)

-Eric
 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index 5392674..84089f8 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4395,7 +4395,7 @@ struct xfs_btree_split_args {
>  			xfs_btree_readahead_ptr(cur, ptr, 1);
>  
>  			/* save for the next iteration of the loop */
> -			lptr = *ptr;
> +			lptr = get_unaligned(ptr);
>  		}
>  
>  		/* for each buffer in the level */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
