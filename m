Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p34K6PU7183066 for <xfs@oss.sgi.com>; Mon, 4 Apr 2011 15:06:25 -0500
Subject: Re: [PATCH] xfs: fix extent format buffer allocation size
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1301453521-5614-1-git-send-email-david@fromorbit.com>
References: <1301453521-5614-1-git-send-email-david@fromorbit.com>
Date: Mon, 04 Apr 2011 15:09:09 -0500
Message-ID: <1301947749.2630.75.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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

On Wed, 2011-03-30 at 13:52 +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When formatting an inode item, we have to allocate a separate buffer
> to hold extents when there are delayed allocation extents on the
> inode and it is in extent format. The allocation size is derived
> from the in-core data fork representation, which accounts for
> delayed allocation extents, while the on-disk representation does
> not contain any delalloc extents.
> 
> As a result of this mismatch, the allocated buffer can be far larger
> than needed to hold the real extent list which, due to the fact the
> inode is in extent format, is limited to the size of the literal
> area of the inode. However, we can have thousands of delalloc
> extents, resulting in an allocation size orders of magnitude larger
> than is needed to hold all the real extents.
> 
> Fix this by limiting the size of the buffer being allocated to the
> size of the literal area of the inodes in the filesystem (i.e. the
> maximum size an inode fork can grow to).
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

I think one of your comments helps explain why you came about
the fix but it maybe distracts a bit from explaining what
the code is doing.  (See below.)  But the change looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>

> ---
>  fs/xfs/xfs_inode_item.c |   69 ++++++++++++++++++++++++++++------------------
>  1 files changed, 42 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 46cc401..12cdc39 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -198,6 +198,43 @@ xfs_inode_item_size(
>  }
>  
>  /*
> + * xfs_inode_item_format_extents - convert in-core extents to on-disk form
> + *
> + * For either the data or attr fork in extent format, we need to endian convert
> + * the in-core extent as we place them into the on-disk inode. In this case, we
> + * ned to do this conversion before we write the extents into the log. Because
     need

> + * we don't have the disk inode to write into here, we allocate a buffer and
> + * format the extents into it via xfs_iextents_copy(). We free the buffer in
> + * the unlock routine after the copy for the log has been made.
> + *
> + * For the data fork, there can be delayed allocation extents
> + * in the inode as well, so the in-core data fork can be much larger than the
> + * on-disk data representation of real inodes. Hence we need to limit the size
> + * of the allocation to what will fit in the inode fork, otherwise we could be
> + * asking for excessively large allocation sizes.

I think the comment here is sort of oriented toward the old way
of looking at things.  I don't think there's any need to justify
the use of the max fork size rather than xfs_ifork->if_bytes.

Just say that any on-disk inode in extent format will fill
no more than that much space on disk, therefore the buffer
we allocate can be limited to that size.  (And perhaps as an
afterthought, delayed allocation extents are never recorded
to disk and therefore don't need space for endian-converting
them.)

> + */
> +STATIC void
> +xfs_inode_item_format_extents(
> +	struct xfs_inode	*ip,
> +	struct xfs_log_iovec	*vecp,
> +	int			whichfork,
> +	int			type)
> +{

. . .

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
