Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57078 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751426AbdHGR0L (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Aug 2017 13:26:11 -0400
Date: Mon, 7 Aug 2017 13:26:09 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Message-ID: <20170807172605.GA49072@bfoster.bfoster>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap>
 <20170807151651.GA43920@bfoster.bfoster>
 <20170807163744.GL24087@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807163744.GL24087@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Alex Lyakas <alex@zadarastorage.com>, linux-xfs@vger.kernel.org, david@fromorbit.com, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

On Mon, Aug 07, 2017 at 09:37:44AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 07, 2017 at 11:16:54AM -0400, Brian Foster wrote:
> > On Mon, Aug 07, 2017 at 03:54:03PM +0300, Alex Lyakas wrote:
> > > The new attribute leaf buffer is not held locked across the transaction roll
> > > between the shortform->leaf modification and the addition of the new entry.
> > > As a result, the attribute buffer modification being made is not atomic
> > > from an operational perspective.
> > > Hence the AIL push can grab it in the transient state of "just created"
> > > after the initial transaction is rolled, because the buffer has been
> > > released.
> > > This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
> > > treating this as in-memory corruption, and shutting down the filesystem.
> > > 
> > > More info at:
> > > https://www.spinics.net/lists/linux-xfs/msg08778.html
> > > 
...
> 
> > > fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
> > > fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
> > > fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
> > > 3 files changed, 26 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> > > index 353fb42..c0ced12 100644
> > > --- a/fs/xfs/libxfs/xfs_attr.c
> > > +++ b/fs/xfs/libxfs/xfs_attr.c
...
> > > @@ -328,48 +329,65 @@ xfs_attr_set(
...
> > >         if (error) {
> > >             ASSERT(committed);
> > > +            if (leaf_bp)
> > > +                xfs_buf_relse(leaf_bp);
> > 
> > Hmm, I don't think this is right. We don't want to release the buffer
> > while the transaction still has a reference. Perhaps we should move this
> > to the "out:" patch after the transaction cancel (and make sure the
> > pointer is reset at the appropriate place)..?
> 
> I would've thought that the buffer would be relse'd by xfs_trans_cancel,
> having been bjoined to the first args.trans and bheld to any subsequent
> transactions?
> 

I'm not following what you mean. I guess if the transaction has been
committed by xfs_bmap_finish(), then the buffer is actually not in the
current transaction, but I think we need to release it either way (so
perhaps this code is fine).

> > 
> > >             args.trans = NULL;
> > >             xfs_bmap_cancel(&flist);
> > >             goto out;
> > >         }
> > > 
> > >         /*
> > >          * bmap_finish() may have committed the last trans and started
> > >          * a new one.  We need the inode to be in all transactions.
> > > +         * We also need to rejoin the leaf buffer to the new transaction
> > > +         * and prevent it from being unlocked, before we commit it in
> > > xfs_trans_roll().
> > > +         * If bmap_finish() did not commit, then we are in the same
> > > transaction,
> > > +         * and no need to call xfs_trans_bhold() again.
> > >          */
> > > -        if (committed)
> > > +        if (committed) {
> > >             xfs_trans_ijoin(args.trans, dp, 0);
> > > +            xfs_trans_bjoin(args.trans, leaf_bp);
> > > +            xfs_trans_bhold(args.trans, leaf_bp);
> > 
> > I don't see why this is necessary. We still have the buffer held and
> > locked, yes?
> 
> The bhold means that after the transaction roll leaf_bp is still locked
> but not associated with a transaction, so it is necessary to bjoin
> leaf_bp to the new transaction.  Since the very next thing we do is roll
> the transaction again, we also want to bhold it for the second roll.
> 

Ok, so we've created the empty block, logged it in the first
transaction, marked it held and committed the tx. At that point the
buffer can make it to the AIL, but we still have it locked (and held) so
it cannot be written back. What difference does it make whether the
buffer is added to this transaction? It won't be dirtied in the
transaction, it can't be written back either way and we eventually join
it to the transaction that creates the attr (after the roll).

> (Question: is the second roll even necessary for this case?)
> 

It's probably moot because I believe this code goes away in recent
kernels as the committed thing was cleaned out, probably before we
converted this over to xfs_defer_finish().

...
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> > > index b7cd0a0..2e03c32 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
...
> > > @@ -733,20 +734,22 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> > >         ASSERT(error == -ENOATTR);
> > >         error = xfs_attr3_leaf_add(bp, &nargs);
> > >         ASSERT(error != -ENOSPC);
> > >         if (error)
> > >             goto out;
> > >         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> > >     }
> > >     error = 0;
> > > 
> > > out:
> > > +    if (error == 0)
> > > +        *bpp = bp;
> > 
> > It looks like the only way error == 0 is where it is set just above, so
> > we could probably move this before the label.
> > 
> > I'm also wondering whether it might be cleaner to 1.) conditionally
> > return the buffer when sf->hdr.count == 0 because that is the only case
> > where the problem occurs and 2.) do the trans_bhold() here in
> > shortform_to_leaf() when we do actually return it.
> 
> I /think/ you could get rid of that second roll and do the bhold in
> shortform_to_leaf, though you'd still have to re-bjoin it after
> defer_finish.
> 

Yeah, the semantic is basically to return a buffer iff the callee held
it in the tx because it was empty (maybe reneame leaf_bp to empty_bp or
something more clear?), thereby making the caller responsible to release
it. The caller happens to do that by joining it to the transaction that
will add the attr.

Brian

> --D
> 
> > 
> > Brian
> > 
> > >     kmem_free(tmpbuffer);
> > >     return error;
> > > }
> > > 
> > > /*
> > >  * Check a leaf attribute block to see if all the entries would fit into
> > >  * a shortform attribute list.
> > >  */
> > > int
> > > xfs_attr_shortform_allfit(
> > > diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > index 4f3a60a..d58e9e4 100644
> > > --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> > > +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> > > @@ -41,21 +41,21 @@ typedef struct xfs_attr_inactive_list {
> > >  * Function prototypes for the kernel.
> > >  *========================================================================*/
> > > 
> > > /*
> > >  * Internal routines when attribute fork size < XFS_LITINO(mp).
> > >  */
> > > void    xfs_attr_shortform_create(struct xfs_da_args *args);
> > > void    xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
> > > int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
> > > int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> > > -int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
> > > +int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args, xfs_buf_t
> > > **bpp);
> > > int    xfs_attr_shortform_remove(struct xfs_da_args *args);
> > > int    xfs_attr_shortform_list(struct xfs_attr_list_context *context);
> > > int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
> > > int    xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes);
> > > void    xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
> > > 
> > > /*
> > >  * Internal routines when attribute fork size == XFS_LBSIZE(mp).
> > >  */
> > > int    xfs_attr3_leaf_to_node(struct xfs_da_args *args);
> > > -- 
> > > 1.9.1
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
