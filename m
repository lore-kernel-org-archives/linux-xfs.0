Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:36948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753713AbeFJQTK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 12:19:10 -0400
Subject: Re: [PATCH v2 03/27] xfsprogs: Add trans toggle to attr routines
References: <1528607272-11122-1-git-send-email-allison.henderson@oracle.com>
 <1528607272-11122-4-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxhOSw-wLWh8x-_gLbSp6WEvtfDppABC7vo5YuurKykOYA@mail.gmail.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <dcd479bc-ac2a-3896-469c-7597c6686a97@oracle.com>
Date: Sun, 10 Jun 2018 09:19:00 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhOSw-wLWh8x-_gLbSp6WEvtfDppABC7vo5YuurKykOYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 06/10/2018 12:02 AM, Amir Goldstein wrote:
> On Sun, Jun 10, 2018 at 8:07 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> This patch adds a roll_trans parameter to all attribute routines.
>> Calling functions may pass true to roll transactions as normal,
>> or false to hold them.  We will need this later for delayed
>> attribute operations.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   libxfs/xfs_attr.c      | 165 ++++++++++++++++++++++++++++---------------------
>>   libxfs/xfs_attr_leaf.c |  12 ++--
>>   libxfs/xfs_attr_leaf.h |  10 +--
>>   3 files changed, 108 insertions(+), 79 deletions(-)
>>
>> diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
>> index 51b567d..7ef35f3 100644
>> --- a/libxfs/xfs_attr.c
>> +++ b/libxfs/xfs_attr.c
>> @@ -50,21 +50,21 @@
>>   /*
>>    * Internal routines when attribute list fits inside the inode.
>>    */
>> -STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args, bool roll_trans);
>>
> 
> So "working on another solution to path 3" means folding roll_trans into
> xfs_da_args_t? if yes, then no further comments.
> 
Well, I think maybe the boolean is not the most graceful solution?  It's 
really more the result of me following my nose through a lot of tracing 
and applying a band-aid everywhere it rolled out the transaction too 
soon.  In the last revision we had talked about trying to re-roll the 
transaction by bailing out of the roll with an EAGAIN, but that is 
something I am still looking at.  I need to update my code base too (i 
think I'm still on 4.16), but I wanted to push out now and get another 
sweep of reviews before too much time gets away. :-)

>>   /*
>>    * Internal routines when attribute list is one block.
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
>> +STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
>>
>>   /*
>>    * Internal routines when attribute list is more than one block.
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> -STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
>> +STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>
>> @@ -202,15 +202,16 @@ STATIC int
>>   xfs_attr_try_sf_addname(
>>          struct xfs_inode        *dp,
>>          struct xfs_da_args      *args,
>> -       int                     flags)
>> +       int                     flags,
>> +       bool                    roll_trans)
>>   {
>>
>>          struct xfs_mount        *mp = dp->i_mount;
>>          int                     error;
>>          int                     err2;
>>
>> -       error = xfs_attr_shortform_addname(args);
>> -       if (error != -ENOSPC) {
>> +       error = xfs_attr_shortform_addname(args, roll_trans);
>> +       if (error != -ENOSPC && roll_trans) {
>>                  /*
>>                   * Commit the shortform mods, and we're done.
>>                   * NOTE: this is also the error path
>> @@ -330,7 +331,7 @@ xfs_attr_set(
>>                   * Try to add the attr to the attribute list in
>>                   * the inode.
>>                   */
>> -               error = xfs_attr_try_sf_addname(dp, &args, flags);
>> +               error = xfs_attr_try_sf_addname(dp, &args, flags, true);
>>                  if (error != -ENOSPC) {
>>                          xfs_iunlock(dp, XFS_ILOCK_EXCL);
>>                          return error;
>> @@ -369,9 +370,9 @@ xfs_attr_set(
>>          }
>>
>>          if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
>> -               error = xfs_attr_leaf_addname(&args);
>> +               error = xfs_attr_leaf_addname(&args, true);
>>          else
>> -               error = xfs_attr_node_addname(&args);
>> +               error = xfs_attr_node_addname(&args, true);
>>          if (error)
>>                  goto out;
>>
>> @@ -466,11 +467,11 @@ xfs_attr_remove(
>>                  error = -ENOATTR;
>>          } else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
>>                  ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
>> -               error = xfs_attr_shortform_remove(&args);
>> +               error = xfs_attr_shortform_remove(&args, true);
>>          } else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>> -               error = xfs_attr_leaf_removename(&args);
>> +               error = xfs_attr_leaf_removename(&args, true);
>>          } else {
>> -               error = xfs_attr_node_removename(&args);
>> +               error = xfs_attr_node_removename(&args, true);
>>          }
>>
>>          if (error)
>> @@ -511,7 +512,7 @@ out:
>>    * This is the external routine.
>>    */
>>   STATIC int
>> -xfs_attr_shortform_addname(xfs_da_args_t *args)
>> +xfs_attr_shortform_addname(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          int newsize, forkoff, retval;
>>
>> @@ -523,7 +524,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>          } else if (retval == -EEXIST) {
>>                  if (args->flags & ATTR_CREATE)
>>                          return retval;
>> -               retval = xfs_attr_shortform_remove(args);
>> +               retval = xfs_attr_shortform_remove(args, roll_trans);
>>                  ASSERT(retval == 0);
>>          }
>>
>> @@ -538,7 +539,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>          if (!forkoff)
>>                  return -ENOSPC;
>>
>> -       xfs_attr_shortform_add(args, forkoff);
>> +       xfs_attr_shortform_add(args, forkoff, roll_trans);
>>          return 0;
>>   }
>>
>> @@ -554,7 +555,7 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * if bmap_one_block() says there is only one block (ie: no remote blks).
>>    */
>>   STATIC int
>> -xfs_attr_leaf_addname(xfs_da_args_t *args)
>> +xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          xfs_inode_t *dp;
>>          struct xfs_buf *bp;
>> @@ -617,36 +618,42 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>>                   * can manage its own transactions.
>>                   */
>>                  xfs_defer_init(args->dfops, args->firstblock);
>> -               error = xfs_attr3_leaf_to_node(args);
>> +               error = xfs_attr3_leaf_to_node(args, roll_trans);
>>                  if (error)
>>                          goto out_defer_cancel;
>>                  xfs_defer_ijoin(args->dfops, dp);
>> -               error = xfs_defer_finish(&args->trans, args->dfops);
>> -               if (error)
>> -                       goto out_defer_cancel;
>> +               if (roll_trans) {
>> +                       error = xfs_defer_finish(&args->trans, args->dfops);
>> +                       if (error)
>> +                               goto out_defer_cancel;
>>
>> -               /*
>> -                * Commit the current trans (including the inode) and start
>> -                * a new one.
>> -                */
>> -               error = xfs_trans_roll_inode(&args->trans, dp);
>> -               if (error)
>> -                       return error;
>> +                       /*
>> +                        * Commit the current trans (including the inode) and
>> +                        * start a new one.
>> +                        */
>> +                       error = xfs_trans_roll_inode(&args->trans, dp);
>> +                       if (error)
>> +                               return error;
>> +               }
>>
>>                  /*
>>                   * Fob the whole rest of the problem off on the Btree code.
>>                   */
>> -               error = xfs_attr_node_addname(args);
>> +               error = xfs_attr_node_addname(args, roll_trans);
>> +
>>                  return error;
>>          }
>>
>> -       /*
>> -        * Commit the transaction that added the attr name so that
>> -        * later routines can manage their own transactions.
>> -        */
>> -       error = xfs_trans_roll_inode(&args->trans, dp);
>> -       if (error)
>> -               return error;
>> +
>> +       if (roll_trans) {
>> +               /*
>> +                * Commit the transaction that added the attr name so that
>> +                * later routines can manage their own transactions.
>> +                */
>> +               error = xfs_trans_roll_inode(&args->trans, dp);
>> +               if (error)
>> +                       return error;
>> +       }
>>
>>          /*
>>           * If there was an out-of-line value, allocate the blocks we
>> @@ -704,9 +711,11 @@ xfs_attr_leaf_addname(xfs_da_args_t *args)
>>                  /*
>>                   * If the result is small enough, shrink it all into the inode.
>>                   */
>> -               if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> +               if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) &&
>> +                               roll_trans) {
>>                          xfs_defer_init(args->dfops, args->firstblock);
>> -                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
>> +                                       roll_trans);
>>                          /* bp is gone due to xfs_da_shrink_inode */
>>                          if (error)
>>                                  goto out_defer_cancel;
>> @@ -740,7 +749,7 @@ out_defer_cancel:
>>    * if bmap_one_block() says there is only one block (ie: no remote blks).
>>    */
>>   STATIC int
>> -xfs_attr_leaf_removename(xfs_da_args_t *args)
>> +xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          xfs_inode_t *dp;
>>          struct xfs_buf *bp;
>> @@ -769,15 +778,19 @@ xfs_attr_leaf_removename(xfs_da_args_t *args)
>>           * If the result is small enough, shrink it all into the inode.
>>           */
>>          if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -               xfs_defer_init(args->dfops, args->firstblock);
>> -               error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +               if (roll_trans)
>> +                       xfs_defer_init(args->dfops, args->firstblock);
>> +               error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
>> +                                                       roll_trans);
>>                  /* bp is gone due to xfs_da_shrink_inode */
>>                  if (error)
>>                          goto out_defer_cancel;
>>                  xfs_defer_ijoin(args->dfops, dp);
>> -               error = xfs_defer_finish(&args->trans, args->dfops);
>> -               if (error)
>> -                       goto out_defer_cancel;
>> +               if (roll_trans) {
>> +                       error = xfs_defer_finish(&args->trans, args->dfops);
>> +                       if (error)
>> +                               goto out_defer_cancel;
>> +               }
>>          }
>>          return 0;
>>   out_defer_cancel:
>> @@ -832,7 +845,7 @@ xfs_attr_leaf_get(xfs_da_args_t *args)
>>    * add a whole extra layer of confusion on top of that.
>>    */
>>   STATIC int
>> -xfs_attr_node_addname(xfs_da_args_t *args)
>> +xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          xfs_da_state_t *state;
>>          xfs_da_state_blk_t *blk;
>> @@ -898,21 +911,24 @@ restart:
>>                          xfs_da_state_free(state);
>>                          state = NULL;
>>                          xfs_defer_init(args->dfops, args->firstblock);
>> -                       error = xfs_attr3_leaf_to_node(args);
>> +                       error = xfs_attr3_leaf_to_node(args, roll_trans);
>>                          if (error)
>>                                  goto out_defer_cancel;
>>                          xfs_defer_ijoin(args->dfops, dp);
>> -                       error = xfs_defer_finish(&args->trans, args->dfops);
>> -                       if (error)
>> -                               goto out_defer_cancel;
>> -
>> -                       /*
>> -                        * Commit the node conversion and start the next
>> -                        * trans in the chain.
>> -                        */
>> -                       error = xfs_trans_roll_inode(&args->trans, dp);
>> -                       if (error)
>> -                               goto out;
>> +                       if (roll_trans) {
>> +                               error = xfs_defer_finish(&args->trans,
>> +                                               args->dfops);
>> +                               if (error)
>> +                                       goto out_defer_cancel;
>> +
>> +                               /*
>> +                                * Commit the node conversion and start the next
>> +                                * trans in the chain.
>> +                                */
>> +                               error = xfs_trans_roll_inode(&args->trans, dp);
>> +                               if (error)
>> +                                       goto out;
>> +                       }
>>
>>                          goto restart;
>>                  }
>> @@ -928,9 +944,11 @@ restart:
>>                  if (error)
>>                          goto out_defer_cancel;
>>                  xfs_defer_ijoin(args->dfops, dp);
>> -               error = xfs_defer_finish(&args->trans, args->dfops);
>> -               if (error)
>> -                       goto out_defer_cancel;
>> +               if (roll_trans) {
>> +                       error = xfs_defer_finish(&args->trans, args->dfops);
>> +                       if (error)
>> +                               goto out_defer_cancel;
>> +               }
>>          } else {
>>                  /*
>>                   * Addition succeeded, update Btree hashvals.
>> @@ -949,9 +967,11 @@ restart:
>>           * Commit the leaf addition or btree split and start the next
>>           * trans in the chain.
>>           */
>> -       error = xfs_trans_roll_inode(&args->trans, dp);
>> -       if (error)
>> -               goto out;
>> +       if (roll_trans) {
>> +               error = xfs_trans_roll_inode(&args->trans, dp);
>> +               if (error)
>> +                       goto out;
>> +       }
>>
>>          /*
>>           * If there was an out-of-line value, allocate the blocks we
>> @@ -1026,9 +1046,12 @@ restart:
>>                          if (error)
>>                                  goto out_defer_cancel;
>>                          xfs_defer_ijoin(args->dfops, dp);
>> -                       error = xfs_defer_finish(&args->trans, args->dfops);
>> -                       if (error)
>> -                               goto out_defer_cancel;
>> +                       if (roll_trans) {
>> +                               error = xfs_defer_finish(&args->trans,
>> +                                               args->dfops);
>> +                               if (error)
>> +                                       goto out_defer_cancel;
>> +                       }
>>                  }
>>
>>                  /*
>> @@ -1067,7 +1090,7 @@ out_defer_cancel:
>>    * the root node (a special case of an intermediate node).
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(xfs_da_args_t *args)
>> +xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          xfs_da_state_t *state;
>>          xfs_da_state_blk_t *blk;
>> @@ -1176,9 +1199,11 @@ xfs_attr_node_removename(xfs_da_args_t *args)
>>                  if (error)
>>                          goto out;
>>
>> -               if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> +               if ((forkoff = xfs_attr_shortform_allfit(bp, dp)) &&
>> +                                       roll_trans) {
>>                          xfs_defer_init(args->dfops, args->firstblock);
>> -                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +                       error = xfs_attr3_leaf_to_shortform(bp, args, forkoff,
>> +                                       roll_trans);
>>                          /* bp is gone due to xfs_da_shrink_inode */
>>                          if (error)
>>                                  goto out_defer_cancel;
>> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
>> index c3682eb..ef53215 100644
>> --- a/libxfs/xfs_attr_leaf.c
>> +++ b/libxfs/xfs_attr_leaf.c
>> @@ -541,7 +541,7 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
>>    * Overflow from the inode has already been checked for.
>>    */
>>   void
>> -xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
>> +xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff, bool roll_trans)
>>   {
>>          xfs_attr_shortform_t *sf;
>>          xfs_attr_sf_entry_t *sfe;
>> @@ -613,7 +613,7 @@ xfs_attr_fork_remove(
>>    * Remove an attribute from the shortform attribute list structure.
>>    */
>>   int
>> -xfs_attr_shortform_remove(xfs_da_args_t *args)
>> +xfs_attr_shortform_remove(xfs_da_args_t *args, bool roll_trans)
>>   {
>>          xfs_attr_shortform_t *sf;
>>          xfs_attr_sf_entry_t *sfe;
>> @@ -965,7 +965,8 @@ int
>>   xfs_attr3_leaf_to_shortform(
>>          struct xfs_buf          *bp,
>>          struct xfs_da_args      *args,
>> -       int                     forkoff)
>> +       int                     forkoff,
>> +       bool                    roll_trans)
>>   {
>>          struct xfs_attr_leafblock *leaf;
>>          struct xfs_attr3_icleaf_hdr ichdr;
>> @@ -1034,7 +1035,7 @@ xfs_attr3_leaf_to_shortform(
>>                  nargs.valuelen = be16_to_cpu(name_loc->valuelen);
>>                  nargs.hashval = be32_to_cpu(entry->hashval);
>>                  nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(entry->flags);
>> -               xfs_attr_shortform_add(&nargs, forkoff);
>> +               xfs_attr_shortform_add(&nargs, forkoff, roll_trans);
>>          }
>>          error = 0;
>>
>> @@ -1048,7 +1049,8 @@ out:
>>    */
>>   int
>>   xfs_attr3_leaf_to_node(
>> -       struct xfs_da_args      *args)
>> +       struct xfs_da_args      *args,
>> +       bool                    roll_trans)
>>   {
>>          struct xfs_attr_leafblock *leaf;
>>          struct xfs_attr3_icleaf_hdr icleafhdr;
>> diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
>> index 4da08af..79c236c 100644
>> --- a/libxfs/xfs_attr_leaf.h
>> +++ b/libxfs/xfs_attr_leaf.h
>> @@ -45,12 +45,13 @@ typedef struct xfs_attr_inactive_list {
>>    * Internal routines when attribute fork size < XFS_LITINO(mp).
>>    */
>>   void   xfs_attr_shortform_create(struct xfs_da_args *args);
>> -void   xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff);
>> +void   xfs_attr_shortform_add(struct xfs_da_args *args, int forkoff,
>> +                       bool roll_trans);
>>   int    xfs_attr_shortform_lookup(struct xfs_da_args *args);
>>   int    xfs_attr_shortform_getvalue(struct xfs_da_args *args);
>>   int    xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
>>                          struct xfs_buf **leaf_bp);
>> -int    xfs_attr_shortform_remove(struct xfs_da_args *args);
>> +int    xfs_attr_shortform_remove(struct xfs_da_args *args, bool roll_trans);
>>   int    xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
>>   int    xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
>>   xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
>> @@ -59,9 +60,10 @@ void xfs_attr_fork_remove(struct xfs_inode *ip, struct xfs_trans *tp);
>>   /*
>>    * Internal routines when attribute fork size == XFS_LBSIZE(mp).
>>    */
>> -int    xfs_attr3_leaf_to_node(struct xfs_da_args *args);
>> +int    xfs_attr3_leaf_to_node(struct xfs_da_args *args, bool roll_trans);
>>   int    xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>> -                                  struct xfs_da_args *args, int forkoff);
>> +                       struct xfs_da_args *args, int forkoff,
>> +                       bool roll_trans);
>>   int    xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>>   int    xfs_attr3_leaf_setflag(struct xfs_da_args *args);
>>   int    xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=4T_oG8VHnaL8I5DKuoJ84kc5w28til1Dib_6WuBJnnA&s=WuTPogezCUjTLZLd4sppEhtNBAwBUVSwlctPWtH9H50&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=4T_oG8VHnaL8I5DKuoJ84kc5w28til1Dib_6WuBJnnA&s=WuTPogezCUjTLZLd4sppEhtNBAwBUVSwlctPWtH9H50&e=
> 
