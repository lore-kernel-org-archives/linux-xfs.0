Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38283 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758497AbdEVTHL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 May 2017 15:07:11 -0400
Date: Mon, 22 May 2017 12:07:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix unaligned access in xfs_btree_visit_blocks
Message-ID: <20170522190710.GB17100@infradead.org>
References: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <105ed603-971a-e7db-6040-b85e5eecd928@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, May 22, 2017 at 10:48:14AM -0500, Eric Sandeen wrote:
> This was throwing unaligned access warnings on sparc64:
> 
> Kernel unaligned access at TPC[1043c088] xfs_btree_visit_blocks+0x88/0xe0 [xfs]
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
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

Hm..  We don't really do this for the return value of of xfs_btree_ptr_addr
anywhere else.  So if it really returns something not suitably enough
aligned we're in much deeper trouble. 
