Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmailnode02.adl6.internode.on.net ([150.101.137.148]:29533
        "EHLO ipmailnode02.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752740AbdHOA1t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Aug 2017 20:27:49 -0400
Date: Tue, 15 Aug 2017 10:25:40 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RFC 2/2] xfs: don't log dirty ranges for ordered buffers
Message-ID: <20170815002540.GC21024@dastard>
References: <20170814165451.43788-1-bfoster@redhat.com>
 <20170814165451.43788-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170814165451.43788-3-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Aug 14, 2017 at 12:54:51PM -0400, Brian Foster wrote:
> Ordered buffers are attached to transactions and pushed through the
> logging infrastructure just like normal buffers with the exception
> that they are not actually written to the log. Therefore, we don't
> need to log dirty ranges of ordered buffers. xfs_trans_log_buf() is
> called on ordered buffers to set up all of the dirty state on the
> transaction, buffer and log item and prepare the buffer for I/O.
> 
> Now that xfs_trans_dirty_buf() is available, call it from
> xfs_trans_ordered_buf() so the latter is now mutually exclusive with
> xfs_trans_log_buf(). This reflects the implementation of ordered
> buffers and helps eliminate confusion over the need to log ranges of
> ordered buffers just to set up internal log state.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c  |  3 ++-
>  fs/xfs/libxfs/xfs_ialloc.c |  2 --
>  fs/xfs/xfs_trans_buf.c     | 25 +++++++++++++------------
>  3 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> index e0bcc4a..9c97896 100644
> --- a/fs/xfs/libxfs/xfs_btree.c
> +++ b/fs/xfs/libxfs/xfs_btree.c
> @@ -4466,7 +4466,8 @@ xfs_btree_block_change_owner(
>  	if (bp) {
>  		if (cur->bc_tp) {
>  			xfs_trans_ordered_buf(cur->bc_tp, bp);
> -			xfs_btree_log_block(cur, bp, XFS_BB_OWNER);
> +			/*xfs_trans_buf_set_type(cur->bc_tp, bp,
> +					       XFS_BLFT_BTREE_BUF);*/

Not sure we need this - a owner change is a rare once-off operation
(e.g. defrag) and so typically we don't need to keep the btree
blocks cached for next reuse.

i.e. the logging of the btree block would do this to reset the age
of the buffer in the LRU as we're expecting it to be used again
soon. e.g. next allocation to that file, next allocation from an AG,
next allocation of an inode, etc.

xfs_btree_block_change_owner() just isn't one of those "likely to
use again shortly" type operations, so I think you can just get rid
of it...

Otherwise the patches look good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
