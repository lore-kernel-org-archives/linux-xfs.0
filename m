Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:16057 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753301AbdJMBBv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2017 21:01:51 -0400
Date: Fri, 13 Oct 2017 12:01:22 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/30] xfs: refactor btree block header checking functions
Message-ID: <20171013010122.GW15067@dastard>
References: <150777244315.1724.6916081372861799350.stgit@magnolia>
 <150777246790.1724.5365622613986439998.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150777246790.1724.5365622613986439998.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2017 at 06:41:07PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the btree block header checks to have an internal function that
> returns the address of the failing check without logging errors.  The
> scrubber will call the internal function, while the external version
> will maintain the current logging behavior.

.....

> diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> index 8f52eda..baf7064 100644
> --- a/fs/xfs/libxfs/xfs_btree.h
> +++ b/fs/xfs/libxfs/xfs_btree.h
> @@ -255,6 +255,11 @@ typedef struct xfs_btree_cur
>   */
>  #define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
>  
> +/* Internal long and short btree block checks. */
> +void *__xfs_btree_check_lblock(struct xfs_btree_cur *cur,
> +		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
> +void *__xfs_btree_check_sblock(struct xfs_btree_cur *cur,
> +		struct xfs_btree_block *block, int level, struct xfs_buf *bp);

/*
 * Internal long and short btree block checks. They return NULL if
 * the block is OK, otherwise they return the address of the failed
 * check.
 */

>  
>  /*
>   * Check that block header is ok.
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index dcd1292..b825953 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -142,6 +142,13 @@ typedef __u32			xfs_nlink_t;
>  #define SYNCHRONIZE()	barrier()
>  #define __return_address __builtin_return_address(0)
>  
> +/*
> + * Return the address of a label.  Use asm volatile so that the optimizer
> + * won't try anything stupid like refactoring the error jumpouts into a
> + * single return, which throws off the reported address.
> + */
> +#define __this_address  ({ __label__ __here; __here: asm volatile(""); &&__here; })

I think this should probably use barrier() rather than an asm
statement - can you check that this works correctly with gcc?  Other
compilers won't work with a asm statement (llvm/intel) but should
DTRT with a compiler barrier intrinsic...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
