Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9UHu6Wg061164 for <xfs@oss.sgi.com>; Tue, 30 Oct 2012 12:56:24 -0500
Date: Mon, 29 Oct 2012 17:22:11 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: [PATCH 02/25] xfs: invalidate allocbt blocks moved to the free
	list
Message-ID: <20121030002211.GD30227@caliban.engr.sgi.com>
References: <1351146854-19343-1-git-send-email-david@fromorbit.com>
	<1351146854-19343-3-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1351146854-19343-3-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This looks OK by me.

Reviewed-by: Phil White <pwhite@sgi.com>

On Thu, Oct 25, 2012 at 05:33:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we free a block from the alloc btree tree, we move it to the
> freelist held in the AGFL and mark it busy in the busy extent tree.
> This typically happens when we merge btree blocks.
> 
> Once the transaction is committed and checkpointed, the block can
> remain on the free list for an indefinite amount of time.  Now, this
> isn't the end of the world at this point - if the free list is
> shortened, the buffer is invalidated in the transaction that moves
> it back to free space. If the buffer is allocated as metadata from
> the free list, then all the modifications getted logged, and we have
> no issues, either. And if it gets allocated as userdata direct from
> the freelist, it gets invalidated and so will never get written.
> 
> However, during the time it sits on the free list, pressure on the
> log can cause the AIL to be pushed and the buffer that covers the
> block gets pushed for write. IOWs, we end up writing a freed
> metadata block to disk. Again, this isn't the end of the world
> because we know from the above we are only writing to free space.
> 
> The problem, however, is for validation callbacks. If the block was
> on old btree root block, then the level of the block is going to be
> higher than the current tree root, and so will fail validation.
> There may be other inconsistencies in the block as well, and
> currently we don't care because the block is in free space. Shutting
> down the filesystem because a freed block doesn't pass write
> validation, OTOH, is rather unfriendly.
> 
> So, make sure we always invalidate buffers as they move from the
> free space trees to the free list so that we guarantee they never
> get written to disk while on the free list.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_alloc_btree.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_alloc_btree.c b/fs/xfs/xfs_alloc_btree.c
> index f1647ca..f7876c6 100644
> --- a/fs/xfs/xfs_alloc_btree.c
> +++ b/fs/xfs/xfs_alloc_btree.c
> @@ -121,6 +121,8 @@ xfs_allocbt_free_block(
>  	xfs_extent_busy_insert(cur->bc_tp, be32_to_cpu(agf->agf_seqno), bno, 1,
>  			      XFS_EXTENT_BUSY_SKIP_DISCARD);
>  	xfs_trans_agbtree_delta(cur->bc_tp, -1);
> +
> +	xfs_trans_binval(cur->bc_tp, bp);
>  	return 0;
>  }
>  
> -- 
> 1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
