Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:36429 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdHGRMA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Aug 2017 13:12:00 -0400
Received: by mail-vk0-f42.google.com with SMTP id u133so4079779vke.3
        for <linux-xfs@vger.kernel.org>; Mon, 07 Aug 2017 10:11:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170807163744.GL24087@magnolia>
References: <8948A7010F7A4A758A580103D54CE381@alyakaslap> <20170807151651.GA43920@bfoster.bfoster>
 <20170807163744.GL24087@magnolia>
From: Alex Lyakas <alex@zadarastorage.com>
Date: Mon, 7 Aug 2017 20:11:58 +0300
Message-ID: <CAOcd+r3uryhnjpiUwu9030MgxXHOyy=Kqv9n4b+JYJNmW2T2Cw@mail.gmail.com>
Subject: Re: [RFC - PATCH] xfs: hold xfs_buf locked between shortform->leaf
 conversion and the addition of the first attribute
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>, Shyam Kaushik <shyam@zadarastorage.com>, Yair Hershko <yair@zadarastorage.com>

Hi Darrick,


On Mon, Aug 7, 2017 at 7:37 PM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Mon, Aug 07, 2017 at 11:16:54AM -0400, Brian Foster wrote:
>> On Mon, Aug 07, 2017 at 03:54:03PM +0300, Alex Lyakas wrote:
>> > The new attribute leaf buffer is not held locked across the transaction roll
>> > between the shortform->leaf modification and the addition of the new entry.
>> > As a result, the attribute buffer modification being made is not atomic
>> > from an operational perspective.
>> > Hence the AIL push can grab it in the transient state of "just created"
>> > after the initial transaction is rolled, because the buffer has been
>> > released.
>> > This leads to xfs_attr3_leaf_verify() asserting that hdr.count is zero,
>> > treating this as in-memory corruption, and shutting down the filesystem.
>> >
>> > More info at:
>> > https://www.spinics.net/lists/linux-xfs/msg08778.html
>> >
>>
>> FYI.. I'm not sure how appropriate it is to use URLs in commit log
>> descriptions. Perhaps somebody else can chime in on that.
>
> I prefer the changelog directly quote the relevant parts of the message
> in case spinics should end up getting knocked offline like gmane, though
> you can certainly use the url to cite the quotation.
>
>> > This patch is based on kernel 3.18.19, which is a long-term (although EOL)
>> > kernel.
>> > This is the reason it is marked as RFC.
>> >
>>
>> It's probably best to develop against the latest kernel, get the fix
>> right, then worry about v3.18 for a backport.
>
> Yes, we've renamed a few things since then...
>
>> > Reproducing the issue is achieved by adding "msleep(1000)" after the
>> > xfs_trans_roll() call.
>> > From the limited testing, this patch seems to fix the issue.
>> > Once/if the community approves this patch, we will do a formal testing.
>
> Do you have a reproducer script that could be turned into an xfstest to
> prevent future regressions?  We could add an error injection site at
> that point that would force an ail push to simulate the problem.
>
I have a two-liner "script" that creates a file and sets an ACL with
length=100 bytes on it using setfattr. I run several of these in
multiple processes. But the problem reproduces only if I add
msleep(1000), after the call to xfs_trans_roll() before adding the
first attribute to the leaf. Then the problem reproduces easily.


>> > Signed-off-by: Alex Lyakas <alex@zadarastorage.com>
>> > ---
>>
>> Note that your patch doesn't apply for me:
>>
>> ...
>> patching file fs/xfs/libxfs/xfs_attr.c
>> Hunk #1 FAILED at 285.
>> patch: **** malformed patch at line 70: commits */
>>
>> Perhaps it has been damaged by your mailer? Otherwise, a few initial
>> comments...
>
> Yes, I also see severe whitespace damage.
>
>> > fs/xfs/libxfs/xfs_attr.c      | 24 +++++++++++++++++++++---
>> > fs/xfs/libxfs/xfs_attr_leaf.c |  5 ++++-
>> > fs/xfs/libxfs/xfs_attr_leaf.h |  2 +-
>> > 3 files changed, 26 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> > index 353fb42..c0ced12 100644
>> > --- a/fs/xfs/libxfs/xfs_attr.c
>> > +++ b/fs/xfs/libxfs/xfs_attr.c
>> > @@ -285,20 +285,21 @@ xfs_attr_set(
>> >
>> >     xfs_trans_ijoin(args.trans, dp, 0);
>> >
>> >     /*
>> >      * If the attribute list is non-existent or a shortform list,
>> >      * upgrade it to a single-leaf-block attribute list.
>> >      */
>> >     if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> >         (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> >          dp->i_d.di_anextents == 0)) {
>> > +        xfs_buf_t *leaf_bp = NULL;
>>
>> Use struct xfs_buf here and throughout. We're attempting to remove uses
>> of the old typedefs wherever possible.
>>
>> >
>> >         /*
>> >          * Build initial attribute list (if required).
>> >          */
>> >         if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> >             xfs_attr_shortform_create(&args);
>> >
>> >         /*
>> >          * Try to add the attr to the attribute list in
>> >          * the inode.
>> > @@ -328,48 +329,65 @@ xfs_attr_set(
>> >             xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> >
>> >             return error ? error : err2;
>> >         }
>> >
>> >         /*
>> >          * It won't fit in the shortform, transform to a leaf block.
>> >          * GROT: another possible req'mt for a double-split btree op.
>> >          */
>> >         xfs_bmap_init(args.flist, args.firstblock);
>> > -        error = xfs_attr_shortform_to_leaf(&args);
>> > +        error = xfs_attr_shortform_to_leaf(&args, &leaf_bp);
>> > +        /* hold the leaf buffer locked, when "args.trans" transaction
>> > commits */
>> > +        if (leaf_bp)
>> > +            xfs_trans_bhold(args.trans, leaf_bp);
>>
>> Indentation looks off here and throughout.
>>
>> > +
>> >         if (!error) {
>> >             error = xfs_bmap_finish(&args.trans, args.flist,
>> >                         &committed);
>
> (FYI this is now xfs_defer_finish...)
>
>> >         }
>> >         if (error) {
>> >             ASSERT(committed);
>> > +            if (leaf_bp)
>> > +                xfs_buf_relse(leaf_bp);
>>
>> Hmm, I don't think this is right. We don't want to release the buffer
>> while the transaction still has a reference. Perhaps we should move this
>> to the "out:" patch after the transaction cancel (and make sure the
>> pointer is reset at the appropriate place)..?
>
> I would've thought that the buffer would be relse'd by xfs_trans_cancel,
> having been bjoined to the first args.trans and bheld to any subsequent
> transactions?
According to Brian's comment, and also reviewing the code, after
holding the buffer, we need first to let the transaction commit or
abort. Then we know that it is not touching the buffer anymore. At
this point, we must either re-join the buffer to a different
transaction, or explicitly release it. That's my understanding:)

>
>>
>> >             args.trans = NULL;
>> >             xfs_bmap_cancel(&flist);
>> >             goto out;
>> >         }
>> >
>> >         /*
>> >          * bmap_finish() may have committed the last trans and started
>> >          * a new one.  We need the inode to be in all transactions.
>> > +         * We also need to rejoin the leaf buffer to the new transaction
>> > +         * and prevent it from being unlocked, before we commit it in
>> > xfs_trans_roll().
>> > +         * If bmap_finish() did not commit, then we are in the same
>> > transaction,
>> > +         * and no need to call xfs_trans_bhold() again.
>> >          */
>> > -        if (committed)
>> > +        if (committed) {
>> >             xfs_trans_ijoin(args.trans, dp, 0);
>> > +            xfs_trans_bjoin(args.trans, leaf_bp);
>> > +            xfs_trans_bhold(args.trans, leaf_bp);
>>
>> I don't see why this is necessary. We still have the buffer held and
>> locked, yes?
>
> The bhold means that after the transaction roll leaf_bp is still locked
> but not associated with a transaction, so it is necessary to bjoin
> leaf_bp to the new transaction.  Since the very next thing we do is roll
> the transaction again, we also want to bhold it for the second roll.
>
I think that Brian is right, and we don't care if there was another
transaction rolled in-between. We can, of course, re-join it and bhold
it on an intermediate transaction (if any). This doesn't harm, but
seems unnecessary. My understanding again:)

Thanks,
Alex.
