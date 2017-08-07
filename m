Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11583 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751247AbdHGPQ4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Aug 2017 11:16:56 -0400
Date: Mon, 7 Aug 2017 11:16:54 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Message-ID: <20170807151651.GA43920@bfoster.bfoster>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8948A7010F7A4A758A580103D54CE381@alyakaslap>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, david@fromorbit.com, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

On Mon, Aug 07, 2017 at 03:54:03PM +0300, Alex Lyakas wrote:
> The new attribute leaf buffer is not held locked across the transaction roll
> between the shortform->leaf modification and the addition of the new entry.
> As a result, the attribute buffer modification being made is not atomic
> from an operational perspective.
> Hence the AIL push can grab it in the transient state of "just created"
> after the initial transaction is rolled, because the buffer has been
> released.
> This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
> treating this as in-memory corruption, and shutting down the filesystem.
> 
> More info at:
> https://www.spinics.net/lists/linux-xfs/msg08778.html
> 

FYI.. I'm not sure how appropriate it is to use URLs in commit log
descriptions. Perhaps somebody else can chime in on that.

> This patch is based on kernel 3.18.19, which is a long-term (although EOL)
> kernel.
> This is the reason it is marked as RFC.
> 

It's probably best to develop against the latest kernel, get the fix
right, then worry about v3.18 for a backport.

> Reproducing the issue is achieved by adding "msleep(1000)" after the
> xfs_trans_roll() call.
> From the limited testing, this patch seems to fix the issue.
> Once/if the community approves this patch, we will do a formal testing.
> 
> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> ---

Note that your patch doesn't apply for me:

...
patching file fs/xfs/libxfs/xfs_attr.c
Hunk #1 FAILED at 285.
patch: **** malformed patch at line 70: commits */

Perhaps it has been damaged by your mailer? Otherwise, a few initial
comments...

> fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
> fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
> fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
> 3 files changed, 26 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 353fb42..c0ced12 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -285,20 +285,21 @@ xfs_attr_set(
> 
>     xfs_trans_ijoin(args.trans, dp, 0);
> 
>     /*
>      * If the attribute list is non-existent or a shortform list,
>      * upgrade it to a single-leaf-block attribute list.
>      */
>     if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>         (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>          dp->i_d.di_anextents == 0)) {
> +        xfs_buf_t *leaf_bp = NULL;

Use struct xfs_buf here and throughout. We're attempting to remove uses
of the old typedefs wherever possible.

> 
>         /*
>          * Build initial attribute list (if required).
>          */
>         if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>             xfs_attr_shortform_create(&args);
> 
>         /*
>          * Try to add the attr to the attribute list in
>          * the inode.
> @@ -328,48 +329,65 @@ xfs_attr_set(
>             xfs_iunlock(dp, XFS_ILOCK_EXCL);
> 
>             return error ? error : err2;
>         }
> 
>         /*
>          * It won't fit in the shortform, transform to a leaf block.
>          * GROT: another possible req'mt for a double-split btree op.
>          */
>         xfs_bmap_init(args.flist, args.firstblock);
> -        error = xfs_attr_shortform_to_leaf(&args);
> +        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
> +        /* hold the leaf buffer locked, when "args.trans" transaction
> commits */
> +        if (leaf_bp)
> +            xfs_trans_bhold(args.trans, leaf_bp);

Indentation looks off here and throughout.

> +
>         if (!error) {
>             error = xfs_bmap_finish(&args.trans, args.flist,
>                         &committed);
>         }
>         if (error) {
>             ASSERT(committed);
> +            if (leaf_bp)
> +                xfs_buf_relse(leaf_bp);

Hmm, I don't think this is right. We don't want to release the buffer
while the transaction still has a reference. Perhaps we should move this
to the "out:" patch after the transaction cancel (and make sure the
pointer is reset at the appropriate place)..?

>             args.trans = NULL;
>             xfs_bmap_cancel(&flist);
>             goto out;
>         }
> 
>         /*
>          * bmap_finish() may have committed the last trans and started
>          * a new one.  We need the inode to be in all transactions.
> +         * We also need to rejoin the leaf buffer to the new transaction
> +         * and prevent it from being unlocked, before we commit it in
> xfs_trans_roll().
> +         * If bmap_finish() did not commit, then we are in the same
> transaction,
> +         * and no need to call xfs_trans_bhold() again.
>          */
> -        if (committed)
> +        if (committed) {
>             xfs_trans_ijoin(args.trans, dp, 0);
> +            xfs_trans_bjoin(args.trans, leaf_bp);
> +            xfs_trans_bhold(args.trans, leaf_bp);

I don't see why this is necessary. We still have the buffer held and
locked, yes?

> +        }
> 
>         /*
>          * Commit the leaf transformation.  We'll need another (linked)
>          * transaction to add the new attribute to the leaf.
>          */
> 
>         error = xfs_trans_roll(&args.trans, dp);
> -        if (error)
> +        if (error) {
> +            xfs_buf_relse(leaf_bp);

Same problem as above.

>             goto out;
> +        }
> 
> +        /* rejoin the leaf buffer to the new transaction */
> +        xfs_trans_bjoin(args.trans, leaf_bp);

This comment should point out that this allows a subsequent read to find
the buffer in the transaction (and avoid a deadlock).

>     }
> 
>     if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>         error = xfs_attr_leaf_addname(&args);
>     else
>         error = xfs_attr_node_addname(&args);
>     if (error)
>         goto out;
> 
>     /*
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index b7cd0a0..2e03c32 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -649,23 +649,24 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>         args->valuelen = sfe->valuelen;
>         memcpy(args->value, &sfe->nameval[args->namelen],
>                             args->valuelen);
>         return -EEXIST;
>     }
>     return -ENOATTR;
> }
> 
> /*
>  * Convert from using the shortform to the leaf.
> + * Upon success, return the leaf buffer.
>  */
> int
> -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, xfs_buf_t **bpp)
> {
>     xfs_inode_t *dp;
>     xfs_attr_shortform_t *sf;
>     xfs_attr_sf_entry_t *sfe;
>     xfs_da_args_t nargs;
>     char *tmpbuffer;
>     int error, i, size;
>     xfs_dablk_t blkno;
>     struct xfs_buf *bp;
>     xfs_ifork_t *ifp;
> @@ -733,20 +734,22 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>         ASSERT(error == -ENOATTR);
>         error = xfs_attr3_leaf_add(bp, &nargs);
>         ASSERT(error != -ENOSPC);
>         if (error)
>             goto out;
>         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
>     }
>     error = 0;
> 
> out:
> +    if (error == 0)
> +        *bpp = bp;

It looks like the only way error == 0 is where it is set just above, so
we could probably move this before the label.

I'm also wondering whether it might be cleaner to 1.) conditionally
return the buffer when sf->hdr.count == 0 because that is the only case
where the problem occurs and 2.) do the trans_bhold() here in
shortform_to_leaf() when we do actually return it.

Brian

>     kmem_free(tmpbuffer);
>     return error;
> }
> 
> /*
>  * Check a leaf attribute block to see if all the entries would fit into
>  * a shortform attribute list.
>  */
> int
> xfs_attr_shortform_allfit(
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index 4f3a60a..d58e9e4 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -41,21 +41,21 @@ typedef struct xfs_attr_inactive_list {
>  * Function prototypes for the kernel.
>  *========================================================================*/
> 
> /*
>  * Internal routines when attribute fork size < XFS_LITINO(mp).
>  */
> void    xfs_attr_shortform_create(struct xfs_da_args *args);
> void    xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
> int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> -int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
> +int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args, xfs_buf_t
> **bpp);
> int    xfs_attr_shortform_remove(struct xfs_da_args *args);
> int    xfs_attr_shortform_list(struct xfs_attr_list_context *context);
> int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> int    xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
> void    xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
> 
> /*
>  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
>  */
> int    xfs_attr3_leaf_to_node(struct xfs_da_args *args);
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
