Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36852 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751820AbdHGRAr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 13:00:47 -0400
Received: by mail-vk0-f44.google.com with SMTP id u133so3959886vke.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2017 10:00:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170807151651.GA43920@bfoster.bfoster>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap> <20170807151651.GA43920@bfoster.bfoster>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Mon, 7 Aug 2017 20:00:46 +0300
Message-ID: <CAOcd+r2=tfvHuH=EE3j9y2w9KT42k9_HXdjUzB+4jCnd4KQx+Q@mail.gmail.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

Hello Brian,

Thanks for the review.

On Mon, Aug 7, 2017 at 6:16 PM, Brian Foster <bfoster@redhat.com> wrote:
> On Mon, Aug 07, 2017 at 03:54:03PM +0300, Alex Lyakas wrote:
>> The new attribute leaf buffer is not held locked across the transaction roll
>> between the shortform->leaf modification and the addition of the new entry.
>> As a result, the attribute buffer modification being made is not atomic
>> from an operational perspective.
>> Hence the AIL push can grab it in the transient state of "just created"
>> after the initial transaction is rolled, because the buffer has been
>> released.
>> This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
>> treating this as in-memory corruption, and shutting down the filesystem.
>>
>> More info at:
>> https://www.spinics.net/lists/linux-xfs/msg08778.html
>>
>
> FYI.. I'm not sure how appropriate it is to use URLs in commit log
> descriptions. Perhaps somebody else can chime in on that.
I will get rid of it.

>
>> This patch is based on kernel 3.18.19, which is a long-term (although EOL)
>> kernel.
>> This is the reason it is marked as RFC.
>>
>
> It's probably best to develop against the latest kernel, get the fix
> right, then worry about v3.18 for a backport.
Unfortunately, for us this is exactly the opposite. We are running
kernel 3.18 in production, and that's where we need the fix. Moving to
a different kernel is a significant effort for us. We do it from time
to time, but it's always to a long-term stable kernel and not to one
of the latests. Still, below I provide a patch for 4.13-rc4.

>
>> Reproducing the issue is achieved by adding "msleep(1000)" after the
>> xfs_trans_roll() call.
>> From the limited testing, this patch seems to fix the issue.
>> Once/if the community approves this patch, we will do a formal testing.
>>
>> Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
>> ---
>
> Note that your patch doesn't apply for me:
>
> ...
> patching file fs/xfs/libxfs/xfs_attr.c
> Hunk #1 FAILED at 285.
> patch: **** malformed patch at line 70: commits */
>
> Perhaps it has been damaged by your mailer? Otherwise, a few initial
> comments...
Trying a different mailer now.

>
>> fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
>> fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
>> fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>> 3 files changed, 26 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 353fb42..c0ced12 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -285,20 +285,21 @@ xfs_attr_set(
>>
>>     xfs_trans_ijoin(args.trans, dp, 0);
>>
>>     /*
>>      * If the attribute list is non-existent or a shortform list,
>>      * upgrade it to a single-leaf-block attribute list.
>>      */
>>     if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>>         (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>>          dp->i_d.di_anextents == 0)) {
>> +        xfs_buf_t *leaf_bp = NULL;
>
> Use struct xfs_buf here and throughout. We're attempting to remove uses
> of the old typedefs wherever possible.
Noted.

>
>>
>>         /*
>>          * Build initial attribute list (if required).
>>          */
>>         if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>>             xfs_attr_shortform_create(&args);
>>
>>         /*
>>          * Try to add the attr to the attribute list in
>>          * the inode.
>> @@ -328,48 +329,65 @@ xfs_attr_set(
>>             xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>
>>             return error ? error : err2;
>>         }
>>
>>         /*
>>          * It won't fit in the shortform, transform to a leaf block.
>>          * GROT: another possible req'mt for a double-split btree op.
>>          */
>>         xfs_bmap_init(args.flist, args.firstblock);
>> -        error = xfs_attr_shortform_to_leaf(&args);
>> +        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>> +        /* hold the leaf buffer locked, when "args.trans" transaction
>> commits */
>> +        if (leaf_bp)
>> +            xfs_trans_bhold(args.trans, leaf_bp);
>
> Indentation looks off here and throughout.
>
>> +
>>         if (!error) {
>>             error = xfs_bmap_finish(&args.trans, args.flist,
>>                         &committed);
>>         }
>>         if (error) {
>>             ASSERT(committed);
>> +            if (leaf_bp)
>> +                xfs_buf_relse(leaf_bp);
>
> Hmm, I don't think this is right. We don't want to release the buffer
> while the transaction still has a reference. Perhaps we should move this
> to the "out:" patch after the transaction cancel (and make sure the
> pointer is reset at the appropriate place)..?
I think I understand what you are saying. After we call
xfs_trans_bhold(), we need first the original transaction to commit or
to abort. Then we must either rejoin the buffer to a different
transaction or release it. I believe the below patch addresses this
issue.

>
>>             args.trans = NULL;
>>             xfs_bmap_cancel(&flist);
>>             goto out;
>>         }
>>
>>         /*
>>          * bmap_finish() may have committed the last trans and started
>>          * a new one.  We need the inode to be in all transactions.
>> +         * We also need to rejoin the leaf buffer to the new transaction
>> +         * and prevent it from being unlocked, before we commit it in
>> xfs_trans_roll().
>> +         * If bmap_finish() did not commit, then we are in the same
>> transaction,
>> +         * and no need to call xfs_trans_bhold() again.
>>          */
>> -        if (committed)
>> +        if (committed) {
>>             xfs_trans_ijoin(args.trans, dp, 0);
>> +            xfs_trans_bjoin(args.trans, leaf_bp);
>> +            xfs_trans_bhold(args.trans, leaf_bp);
>
> I don't see why this is necessary. We still have the buffer held and
> locked, yes?
I believe you are right. We don't care if there was another
transaction in-between. Addressed this.

>
>> +        }
>>
>>         /*
>>          * Commit the leaf transformation.  We'll need another (linked)
>>          * transaction to add the new attribute to the leaf.
>>          */
>>
>>         error = xfs_trans_roll(&args.trans, dp);
>> -        if (error)
>> +        if (error) {
>> +            xfs_buf_relse(leaf_bp);
>
> Same problem as above.
>
>>             goto out;
>> +        }
>>
>> +        /* rejoin the leaf buffer to the new transaction */
>> +        xfs_trans_bjoin(args.trans, leaf_bp);
>
> This comment should point out that this allows a subsequent read to find
> the buffer in the transaction (and avoid a deadlock).
Done.

>
>>     }
>>
>>     if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>>         error = xfs_attr_leaf_addname(&args);
>>     else
>>         error = xfs_attr_node_addname(&args);
>>     if (error)
>>         goto out;
>>
>>     /*
>> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
>> index b7cd0a0..2e03c32 100644
>> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
>> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
>> @@ -649,23 +649,24 @@ xfs_attr_shortform_getvalue(xfs_da_args_t *args)
>>         args->valuelen = sfe->valuelen;
>>         memcpy(args->value, &sfe->nameval[args->namelen],
>>                             args->valuelen);
>>         return -EEXIST;
>>     }
>>     return -ENOATTR;
>> }
>>
>> /*
>>  * Convert from using the shortform to the leaf.
>> + * Upon success, return the leaf buffer.
>>  */
>> int
>> -xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>> +xfs_attr_shortform_to_leaf(xfs_da_args_t *args, xfs_buf_t **bpp)
>> {
>>     xfs_inode_t *dp;
>>     xfs_attr_shortform_t *sf;
>>     xfs_attr_sf_entry_t *sfe;
>>     xfs_da_args_t nargs;
>>     char *tmpbuffer;
>>     int error, i, size;
>>     xfs_dablk_t blkno;
>>     struct xfs_buf *bp;
>>     xfs_ifork_t *ifp;
>> @@ -733,20 +734,22 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
>>         ASSERT(error == -ENOATTR);
>>         error = xfs_attr3_leaf_add(bp, &nargs);
>>         ASSERT(error != -ENOSPC);
>>         if (error)
>>             goto out;
>>         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
>>     }
>>     error = 0;
>>
>> out:
>> +    if (error == 0)
>> +        *bpp = bp;
>
> It looks like the only way error == 0 is where it is set just above, so
> we could probably move this before the label.
I am a bit confused by this code in xfs_attr_shortform_to_leaf():
    ...
    error = xfs_attr3_leaf_create(args, blkno, &bp);
    if (error) {
        error = xfs_da_shrink_inode(args, 0, bp);
        bp = NULL;
        if (error)
            goto out;
        xfs_idata_realloc(dp, size, XFS_ATTR_FORK);    /* try to put */
        memcpy(ifp->if_u1.if_data, tmpbuffer, size);    /* it back */
        goto out;
    }
Here we fail to convert to a leaf. But if xfs_da_shrink_inode()
succeeds, we return error==0 back to the caller. But we actually
failed to convert. This, however, is not directly related to your
comment.

>
> I'm also wondering whether it might be cleaner to 1.) conditionally
> return the buffer when sf->hdr.count == 0 because that is the only case
> where the problem occurs and 2.) do the trans_bhold() here in
> shortform_to_leaf() when we do actually return it.
>
> Brian
>
>>     kmem_free(tmpbuffer);
>>     return error;
>> }
>>

Here is the patch based on kernel 4.13-rc4.

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index de7b9bd..982e322 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -218,6 +218,7 @@
     xfs_fsblock_t        firstblock;
     int            rsvd = (flags & ATTR_ROOT) != 0;
     int            error, err2, local;
+    struct xfs_buf        *leaf_bp = NULL;

     XFS_STATS_INC(mp, xs_attr_set);

@@ -327,7 +328,13 @@
          * GROT: another possible req'mt for a double-split btree op.
          */
         xfs_defer_init(args.dfops, args.firstblock);
-        error = xfs_attr_shortform_to_leaf(&args);
+        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
+        /*
+         * Prevent the leaf buffer from being unlocked
+         * when "args.trans" transaction commits.
+         */
+        if (leaf_bp)
+            xfs_trans_bhold(args.trans, leaf_bp);
         if (!error)
             error = xfs_defer_finish(&args.trans, args.dfops, dp);
         if (error) {
@@ -345,6 +352,14 @@
         if (error)
             goto out;

+        /*
+         * Rejoin the leaf buffer to the new transaction.
+         * This allows a subsequent read to find the buffer in the
+         * transaction (and avoid a deadlock).
+         */
+        xfs_trans_bjoin(args.trans, leaf_bp);
+        /* Prevent from being released at the end of the function */
+        leaf_bp = NULL;
     }

     if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -376,6 +391,8 @@
 out:
     if (args.trans)
         xfs_trans_cancel(args.trans);
+    if (leaf_bp)
+        xfs_buf_relse(leaf_bp);
     xfs_iunlock(dp, XFS_ILOCK_EXCL);
     return error;
 }
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index c6c15e5..ab73e4b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -740,9 +740,10 @@ STATIC void xfs_attr3_leaf_moveents(struct
xfs_da_args *args,

 /*
  * Convert from using the shortform to the leaf.
+ * Upon success, return the leaf buffer.
  */
 int
-xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
+xfs_attr_shortform_to_leaf(xfs_da_args_t *args, struct xfs_buf **bpp)
 {
     xfs_inode_t *dp;
     xfs_attr_shortform_t *sf;
@@ -822,6 +823,7 @@ STATIC void xfs_attr3_leaf_moveents(struct
xfs_da_args *args,
         sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
     }
     error = 0;
+    *bpp = bp;

 out:
     kmem_free(tmpbuffer);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index f7dda0c..7382d4e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -48,7 +48,7 @@
 void    xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
 int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
 int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
-int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args);
+int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args, struct
xfs_buf **bpp);
 int    xfs_attr_shortform_remove(struct xfs_da_args *args);
 int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int    xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
