Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:40072 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754628AbeEHHZv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 May 2018 03:25:51 -0400
Received: by mail-yw0-f195.google.com with SMTP id p144-v6so9381534ywg.7
        for <linux-xfs@vger.kernel.org>; Tue, 08 May 2018 00:25:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180507233648.GS11261@magnolia>
References: <1525627494-12873-1-git-send-email-allison.henderson@oracle.com>
 <1525627494-12873-4-git-send-email-allison.henderson@oracle.com> <20180507233648.GS11261@magnolia>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 8 May 2018 10:25:50 +0300
Message-ID: <CAOQ4uxj6B74MuUv61_DDjzTz5SL+K1wdidZHOZSBEQz=8yBobA@mail.gmail.com>
Subject: Re: [PATCH 03/21] xfs: Add attibute set and helper functions
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, May 8, 2018 at 2:36 AM, Darrick J. Wong <darrick.wong@oracle.com> wrote:
> On Sun, May 06, 2018 at 10:24:36AM -0700, Allison Henderson wrote:
>> This patch adds xfs_attr_set_args and xfs_bmap_set_attrforkoff.
>> These sub-routines set the attributes specified in @args.
>> We will use this later for setting parent pointers as a deferred
>> attribute operation.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>  fs/xfs/libxfs/xfs_attr.c | 217 ++++++++++++++++++++++++++++-------------------
>>  fs/xfs/libxfs/xfs_attr.h |   2 +
>>  fs/xfs/libxfs/xfs_bmap.c |  49 ++++++-----
>>  fs/xfs/libxfs/xfs_bmap.h |   1 +
>>  4 files changed, 165 insertions(+), 104 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 0ade22b..99c4a31 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -168,6 +168,134 @@ xfs_attr_get(
>>  }
>>
>>  /*
>> + * Set the attribute specified in @args. In the case of the parent attribute
>> + * being set, we do not want to roll the transaction on shortform-to-leaf
>> + * conversion, as the attribute must be added in the same transaction as the
>> + * parent directory modifications. Hence @roll_trans needs to be set
>> + * appropriately to control whether the transaction is committed during this
>> + * function.
>> + */
>> +int
>> +xfs_attr_set_args(
>> +     struct xfs_da_args      *args,
>> +     int                     flags,
>> +     struct xfs_buf          *leaf_bp,
>> +     bool                    roll_trans)
>> +{
>> +     struct xfs_inode        *dp = args->dp;
>> +     struct xfs_mount        *mp = dp->i_mount;
>> +     int                     error = 0;
>> +     int                     err2 = 0;
>> +     int                     sf_size;
>> +
>> +     /*
>> +      * New inodes setting the parent pointer attr will
>> +      * not have an attribute fork yet. So set the attribute
>> +      * fork appropriately
>> +      */
>> +     if (XFS_IFORK_Q((args->dp)) == 0) {
>> +             sf_size = sizeof(struct xfs_attr_sf_hdr) +
>> +                  XFS_ATTR_SF_ENTSIZE_BYNAME(args->namelen, args->valuelen);
>> +             xfs_bmap_set_attrforkoff(args->dp, sf_size, NULL);
>> +             args->dp->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_SLEEP);
>> +             args->dp->i_afp->if_flags = XFS_IFEXTENTS;
>> +     }
>> +
>> +     xfs_trans_ijoin(args->trans, dp, 0);
>> +     /*
>> +      * If the attribute list is non-existent or a shortform list,
>> +      * upgrade it to a single-leaf-block attribute list.
>> +      */
>> +     if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
>> +         (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
>> +          dp->i_d.di_anextents == 0)) {
>> +
>> +             /*
>> +              * Build initial attribute list (if required).
>> +              */
>> +             if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> +                     xfs_attr_shortform_create(args);
>> +
>> +             /*
>> +              * Try to add the attr to the attribute list in the inode.
>> +              */
>> +             error = xfs_attr_shortform_addname(args, roll_trans);
>> +             if (error != -ENOSPC) {
>> +                     if (roll_trans) {
>
> I dislike this roll_trans parameter.  Most other places in xfs when a
> function is passed in a defer_ops or a transaction it's assumed that we
> don't own the transaction or the defer_ops and so while it's ok to
> attach dirty things to the dfops or the tp, we let the caller decide
> when it's appropriate to start committing things.
>
> This function is getting rather long and indenty, can it be broken up
> into smaller pieces?  That should make it easier to reuse the core
> logic of "try to stuff it in the sfattr, if it doesn't fit then convert
> to attr block and retry the add" without having to add extra parameters
> to control whether or not we commit transactions.
>
> This is more complex than in other parts of xfs because we're (for the
> moment anyway) leaving both the deferred and non-deferred paths, but at
> least the attr logic and the transaction management logic should be
> split into separate functions to handle the unique situations of both
> the deferred and non-deferred xattr setting code.
>
> Also, please don't hoist code into a helper function /and/ change its
> behavior & parameters in the same patch.
>

Indeed. I was going to comment that the description should say
"factor out helper" and "doesn't change logic" so reviewers can
review it properly, although now I am not sure if that is really the
case, so please make it the case.

Thanks,
Amir.
