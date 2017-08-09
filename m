Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39185 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbdHINRj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Aug 2017 09:17:39 -0400
Date: Wed, 9 Aug 2017 09:17:37 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of an attribute
Message-ID: <20170809131737.GD62448@bfoster.bfoster>
References: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502276772-24293-1-git-send-email-alex@zadarastorage.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: alex@zadarastorage.com
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, darrick.wong@oracle.com, libor.klepac@bcom.cz

On Wed, Aug 09, 2017 at 02:06:12PM +0300, alex@zadarastorage.com wrote:
> From: Alex Lyakas <alex@zadarastorage.com>
> 
> The new attribute leaf buffer is not held locked across
> the transaction roll between the shortform->leaf modification
> and the addition of the new entry. As a result, the attribute
> buffer modification being made is not atomic from
> an operational perspective. Hence the AIL push can grab it in
> the transient state of "just created" after the initial
> transaction is rolled, because the buffer has been released.
> This leads to xfs_attr3_leaf_verify() asserting that
> hdr.count is zero, treating this as in-memory corruption,
> and shutting down the filesystem.
> 
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> ---

Thanks for the fixups Alex. This patch applies clean and looks correct
to me. Some minor comments..

>  fs/xfs/libxfs/xfs_attr.c      | 19 ++++++++++++++++++-
>  fs/xfs/libxfs/xfs_attr_leaf.c |  4 +++-
>  fs/xfs/libxfs/xfs_attr_leaf.h |  3 ++-
>  3 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index de7b9bd..982e322 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -216,10 +216,11 @@
>  	struct xfs_defer_ops	dfops;
>  	struct xfs_trans_res	tres;
>  	xfs_fsblock_t		firstblock;
>  	int			rsvd = (flags & ATTR_ROOT) != 0;
>  	int			error, err2, local;
> +	struct xfs_buf		*leaf_bp = NULL;
>  
>  	XFS_STATS_INC(mp, xs_attr_set);
>  
>  	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
>  		return -EIO;
> @@ -325,11 +326,17 @@
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
>  		 * GROT: another possible req'mt for a double-split btree op.
>  		 */
>  		xfs_defer_init(args.dfops, args.firstblock);
> -		error = xfs_attr_shortform_to_leaf(&args);
> +		error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
> +		/*
> +		 * Prevent the leaf buffer from being unlocked
> +		 * when "args.trans" transaction commits.
> +		 */

I think this comment should explain why we're keeping the buffer locked
here rather than reiterating what the code is doing. For example,
something like the following:

"Keep the buffer locked across the leaf conversion transaction to
prevent it from being written back before the new xattr is added. The
buffer could be in an invalid, intermediate state (i.e., empty) and
trigger write verifier failure."

> +		if (leaf_bp)
> +			xfs_trans_bhold(args.trans, leaf_bp);
>  		if (!error)
>  			error = xfs_defer_finish(&args.trans, args.dfops, dp);
>  		if (error) {
>  			args.trans = NULL;
>  			xfs_defer_cancel(&dfops);
> @@ -343,10 +350,18 @@
>  
>  		error = xfs_trans_roll(&args.trans, dp);
>  		if (error)
>  			goto out;
>  
> +		/*
> +		 * Rejoin the leaf buffer to the new transaction.
> +		 * This allows a subsequent read to find the buffer in the
> +		 * transaction (and avoid a deadlock).
> +		 */

"Join the leaf buffer to the new transaction so addname can read it in
its locked state (and avoid a deadlock)."

> +		xfs_trans_bjoin(args.trans, leaf_bp);
> +		/* Prevent from being released at the end of the function */

Combine this comment with the one above (or just kill it, the code is
self-explanatory).

> +		leaf_bp = NULL;
>  	}
>  
>  	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>  		error = xfs_attr_leaf_addname(&args);
>  	else
> @@ -374,10 +389,12 @@
>  	return error;
>  
>  out:
>  	if (args.trans)
>  		xfs_trans_cancel(args.trans);
> +	if (leaf_bp)
> +		xfs_buf_relse(leaf_bp);
>  	xfs_iunlock(dp, XFS_ILOCK_EXCL);
>  	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index c6c15e5..ab73e4b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -738,13 +738,14 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
>  	return -ENOATTR;
>  }
>  
>  /*
>   * Convert from using the shortform to the leaf.
> + * Upon success, return the leaf buffer.
>   */
>  int
> -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, struct xfs_buf **bpp)
>  {
>  	xfs_inode_t *dp;
>  	xfs_attr_shortform_t *sf;
>  	xfs_attr_sf_entry_t *sfe;
>  	xfs_da_args_t nargs;
> @@ -820,10 +821,11 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
>  		if (error)
>  			goto out;
>  		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
>  	}
>  	error = 0;
> +	*bpp = bp;

This was probably lost in the discussion noise, but one thing I
mentioned for the rfc was to call xfs_trans_bhold() here rather than in
xfs_attr_set(), and do so (and set bpp) only when the leaf buffer is
actually empty. If the inode already has xattrs, then it's fine for it
to be written back in the meantime.

I don't care as much about not holding the buffer when not totally
necessary, but rather what I like about this is that it defines clear
semantics for any callers of the function that the buffer, when
returned, is the caller responsibility to put into a valid state before
it is released. This seems a bit more clear to me than always setting
the buffer on return.

That said, this is a minor, subjective design point and I'm fine with
the code as it is if that is preferred.

Brian

>  
>  out:
>  	kmem_free(tmpbuffer);
>  	return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index f7dda0c..2b3c69df 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -46,11 +46,12 @@
>   */
>  void	xfs_attr_shortform_create(struct xfs_da_args *args);
>  void	xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
>  int	xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> -int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
> +int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
> +					struct xfs_buf **bpp);
>  int	xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>  void	xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>  
> -- 
> 1.9.1
> 
