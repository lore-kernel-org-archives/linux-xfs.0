Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:57668 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750821AbeDQHMe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Apr 2018 03:12:34 -0400
Date: Tue, 17 Apr 2018 00:12:33 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: validate allocated inode number
Message-ID: <20180417071233.GD18079@infradead.org>
References: <20180417063916.13069-1-david@fromorbit.com>
 <20180417063916.13069-3-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417063916.13069-3-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, viro@ZenIV.linux.org.uk

On Tue, Apr 17, 2018 at 04:39:16PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we have corrupted free inode btrees, we can attempt to
> allocate inodes that we know are already allocated. Catch allocation
> of these inodes and report corruption as early as possible to
> prevent corruption propagation or deadlocks.
> 
> Signed-Off-By: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 7b764f746ff2..12e6c1aec386 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -790,6 +790,19 @@ xfs_ialloc(
>  	}
>  	ASSERT(*ialloc_context == NULL);
>  
> +	/*
> +	 * Protect against obviously corrupt allocation btree records. Later
> +	 * xfs_iget checks will catch re-allocation of other active in-memory
> +	 * and on-disk inodes. If we don't catch reallocating the parent inode
> +	 * here we will deadlock in xfs_iget() so we have to do these checks
> +	 * first.
> +	 */
> +	if ((pip && ino == pip->i_ino) ||
> +	    !xfs_verify_dir_ino(mp, ino)) {

Seems like the whole conditional would fit onto a single line.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
