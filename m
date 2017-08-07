Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38858 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751820AbdHGR7b (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Aug 2017 13:59:31 -0400
Date: Mon, 7 Aug 2017 13:59:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Message-ID: <20170807175928.GB49072@bfoster.bfoster>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap>
 <20170807151651.GA43920@bfoster.bfoster>
 <CAOcd+r2=tfvHuH=EE3j9y2w9KT42k9_HXdjUzB+4jCnd4KQx+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOcd+r2=tfvHuH=EE3j9y2w9KT42k9_HXdjUzB+4jCnd4KQx+Q@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Alex Lyakas <alex@zadarastorage.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

On Mon, Aug 07, 2017 at 08:00:46PM +0300, Alex Lyakas wrote:
> Hello Brian,
> 
> Thanks for the review.
> 
> On Mon, Aug 7, 2017 at 6:16 PM, Brian Foster <bfoster@redhat.com> wrote:
> > On Mon, Aug 07, 2017 at 03:54:03PM +0300, Alex Lyakas wrote:
> >> The new attribute leaf buffer is not held locked across the transaction roll
> >> between the shortform->leaf modification and the addition of the new entry.
> >> As a result, the attribute buffer modification being made is not atomic
> >> from an operational perspective.
> >> Hence the AIL push can grab it in the transient state of "just created"
> >> after the initial transaction is rolled, because the buffer has been
> >> released.
> >> This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
> >> treating this as in-memory corruption, and shutting down the filesystem.
> >>
> >> More info at:
> >> https://www.spinics.net/lists/linux-xfs/msg08778.html
> >>
> >
> > FYI.. I'm not sure how appropriate it is to use URLs in commit log
> > descriptions. Perhaps somebody else can chime in on that.
> I will get rid of it.
> 
> >
> >> This patch is based on kernel 3.18.19, which is a long-term (although EOL)
> >> kernel.
> >> This is the reason it is marked as RFC.
> >>
> >
> > It's probably best to develop against the latest kernel, get the fix
> > right, then worry about v3.18 for a backport.
> Unfortunately, for us this is exactly the opposite. We are running
> kernel 3.18 in production, and that's where we need the fix. Moving to
> a different kernel is a significant effort for us. We do it from time
> to time, but it's always to a long-term stable kernel and not to one
> of the latests. Still, below I provide a patch for 4.13-rc4.
> 

This is the same as for most people. Nobody is running the latest
for-next kernel in a critical production environment. We debug/diagnose
issues against older kernels all the time, fix in the latest development
tree and backport from there as needed. Once the fix is backported and
picked up in a stable kernel, you can update your production systems at
that point.

It sounds like you have a reliable reproducer (albeit with injection of
an artificial delay), so you should be able to reproduce and test/verify
against a development kernel. This doesn't require moving any of your
infrastructure to the latest kernel (use a vm, for example).

> >
> >> Reproducing the issue is achieved by adding "msleep(1000)" after the
> >> xfs_trans_roll() call.
> >> From the limited testing, this patch seems to fix the issue.
> >> Once/if the community approves this patch, we will do a formal testing.
> >>
> >> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
> >> ---
> >
> > Note that your patch doesn't apply for me:
> >
> > ...
> > patching file fs/xfs/libxfs/xfs_attr.c
> > Hunk #1 FAILED at 285.
> > patch: **** malformed patch at line 70: commits */
> >
> > Perhaps it has been damaged by your mailer? Otherwise, a few initial
> > comments...
> Trying a different mailer now.
> 

Same problem. It looks like everything is converted to spaces. Are you
copy+pasting the patch into an email? Note that usually will not work.
You can use something like 'git send-email' to post correctly formatted
patches over mail. Also note you can send it to yourself initially and
test apply it (and/or run scripts/checkpatch.pl against it) to make sure
it works.

> >
> >> fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
> >> fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
> >> fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
> >> 3 files changed, 26 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> >> index 353fb42..c0ced12 100644
> >> --- a/fs/xfs/libxfs/xfs_attr.c
> >> +++ b/fs/xfs/libxfs/xfs_attr.c
...
> >> @@ -328,48 +329,65 @@ xfs_attr_set(
...
> > Hmm, I don't think this is right. We don't want to release the buffer
> > while the transaction still has a reference. Perhaps we should move this
> > to the "out:" patch after the transaction cancel (and make sure the
> > pointer is reset at the appropriate place)..?
> I think I understand what you are saying. After we call
> xfs_trans_bhold(), we need first the original transaction to commit or
> to abort. Then we must either rejoin the buffer to a different
> transaction or release it. I believe the below patch addresses this
> issue.
> 

As noted in the last mail, it may not matter since the tx is committed
or aborted by the time an error is returned here. That said, I still
prefer the code you have below. :)

...
> >> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> >> index b7cd0a0..2e03c32 100644
> >> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> >> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> >> @@ -649,23 +649,24 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
> >>         args->valuelen = sfe->valuelen;
> >>         memcpy(args->value, &sfe->nameval[args->namelen],
> >>                             args->valuelen);
> >>         return -EEXIST;
> >>     }
> >>     return -ENOATTR;
> >> }
> >>
> >> /*
> >>  * Convert from using the shortform to the leaf.
> >> + * Upon success, return the leaf buffer.
> >>  */
> >> int
> >> -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> >> +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, xfs_buf_t **bpp)
> >> {
> >>     xfs_inode_t *dp;
> >>     xfs_attr_shortform_t *sf;
> >>     xfs_attr_sf_entry_t *sfe;
> >>     xfs_da_args_t nargs;
> >>     char *tmpbuffer;
> >>     int error, i, size;
> >>     xfs_dablk_t blkno;
> >>     struct xfs_buf *bp;
> >>     xfs_ifork_t *ifp;
> >> @@ -733,20 +734,22 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> >>         ASSERT(error == -ENOATTR);
> >>         error = xfs_attr3_leaf_add(bp, &nargs);
> >>         ASSERT(error != -ENOSPC);
> >>         if (error)
> >>             goto out;
> >>         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
> >>     }
> >>     error = 0;
> >>
> >> out:
> >> +    if (error == 0)
> >> +        *bpp = bp;
> >
> > It looks like the only way error == 0 is where it is set just above, so
> > we could probably move this before the label.
> I am a bit confused by this code in xfs_attr_shortform_to_leaf():
>     ...
>     error = xfs_attr3_leaf_create(args, blkno, &bp);
>     if (error) {
>         error = xfs_da_shrink_inode(args, 0, bp);
>         bp = NULL;
>         if (error)
>             goto out;
>         xfs_idata_realloc(dp, size, XFS_ATTR_FORK);    /* try to put */
>         memcpy(ifp->if_u1.if_data, tmpbuffer, size);    /* it back */
>         goto out;
>     }
> Here we fail to convert to a leaf. But if xfs_da_shrink_inode()
> succeeds, we return error==0 back to the caller. But we actually
> failed to convert. This, however, is not directly related to your
> comment.
> 

Hm, I'm not aware of any reason to intentionally clear the error in that
case. That may be a bug.

Brian

> >
> > I'm also wondering whether it might be cleaner to 1.) conditionally
> > return the buffer when sf->hdr.count == 0 because that is the only case
> > where the problem occurs and 2.) do the trans_bhold() here in
> > shortform_to_leaf() when we do actually return it.
> >
> > Brian
> >
> >>     kmem_free(tmpbuffer);
> >>     return error;
> >> }
> >>
> 
> Here is the patch based on kernel 4.13-rc4.
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index de7b9bd..982e322 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -218,6 +218,7 @@
>      xfs_fsblock_t        firstblock;
>      int            rsvd = (flags & ATTR_ROOT) != 0;
>      int            error, err2, local;
> +    struct xfs_buf        *leaf_bp = NULL;
> 
>      XFS_STATS_INC(mp, xs_attr_set);
> 
> @@ -327,7 +328,13 @@
>           * GROT: another possible req'mt for a double-split btree op.
>           */
>          xfs_defer_init(args.dfops, args.firstblock);
> -        error = xfs_attr_shortform_to_leaf(&args);
> +        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
> +        /*
> +         * Prevent the leaf buffer from being unlocked
> +         * when "args.trans" transaction commits.
> +         */
> +        if (leaf_bp)
> +            xfs_trans_bhold(args.trans, leaf_bp);
>          if (!error)
>              error = xfs_defer_finish(&args.trans, args.dfops, dp);
>          if (error) {
> @@ -345,6 +352,14 @@
>          if (error)
>              goto out;
> 
> +        /*
> +         * Rejoin the leaf buffer to the new transaction.
> +         * This allows a subsequent read to find the buffer in the
> +         * transaction (and avoid a deadlock).
> +         */
> +        xfs_trans_bjoin(args.trans, leaf_bp);
> +        /* Prevent from being released at the end of the function */
> +        leaf_bp = NULL;
>      }
> 
>      if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> @@ -376,6 +391,8 @@
>  out:
>      if (args.trans)
>          xfs_trans_cancel(args.trans);
> +    if (leaf_bp)
> +        xfs_buf_relse(leaf_bp);
>      xfs_iunlock(dp, XFS_ILOCK_EXCL);
>      return error;
>  }
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index c6c15e5..ab73e4b 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -740,9 +740,10 @@ STATIC void xfs_attr3_leaf_moveents(struct
> xfs_da_args *args,
> 
>  /*
>   * Convert from using the shortform to the leaf.
> + * Upon success, return the leaf buffer.
>   */
>  int
> -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
> +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, struct xfs_buf **bpp)
>  {
>      xfs_inode_t *dp;
>      xfs_attr_shortform_t *sf;
> @@ -822,6 +823,7 @@ STATIC void xfs_attr3_leaf_moveents(struct
> xfs_da_args *args,
>          sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
>      }
>      error = 0;
> +    *bpp = bp;
> 
>  out:
>      kmem_free(tmpbuffer);
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index f7dda0c..7382d4e 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -48,7 +48,7 @@
>  void    xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
>  int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
>  int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
> -int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
> +int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args, struct
> xfs_buf **bpp);
>  int    xfs_attr_shortform_remove(struct xfs_da_args *args);
>  int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>  int    xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
