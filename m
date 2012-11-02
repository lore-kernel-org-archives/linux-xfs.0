Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA2LLmd8185173 for <xfs@oss.sgi.com>; Fri, 2 Nov 2012 16:21:48 -0500
Message-ID: <509439D9.7030506@sgi.com>
Date: Fri, 02 Nov 2012 16:23:37 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/6] xfs: invalidate allocbt blocks moved to the free list
References: <1351816724-3000-1-git-send-email-david@fromorbit.com>
	<1351816724-3000-4-git-send-email-david@fromorbit.com>
In-Reply-To: <1351816724-3000-4-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 11/01/12 19:38, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
