Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:40134 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753440AbeFJPa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Jun 2018 11:30:56 -0400
Subject: Re: [PATCH v7 02/23] xfs: Add helper function xfs_attr_try_sf_addname
References: <1528607108-11059-1-git-send-email-allison.henderson@oracle.com>
 <1528607108-11059-3-git-send-email-allison.henderson@oracle.com>
 <CAOQ4uxh5Ojx_HsdwFBtrB_Tde87ms2O6Xhca6Q9GhfNU+X2H0g@mail.gmail.com>
From: Allison Henderson <allison.henderson@oracle.com>
Message-ID: <97aeb132-a594-bc86-9e41-7fde32d24a4b@oracle.com>
Date: Sun, 10 Jun 2018 08:30:50 -0700
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxh5Ojx_HsdwFBtrB_Tde87ms2O6Xhca6Q9GhfNU+X2H0g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On 06/09/2018 11:58 PM, Amir Goldstein wrote:
> On Sun, Jun 10, 2018 at 8:04 AM, Allison Henderson
> <allison.henderson@oracle.com> wrote:
>> This patch adds a subroutine xfs_attr_try_sf_addname
>> used by xfs_attr_set.  This subrotine will attempt to
>> add the attribute name specified in args in shortform,
>> as well and perform error handling previously done in
>> xfs_attr_set.
>>
>> This patch helps to pre-simplify xfs_attr_set for reviewing
>> purposes and reduce indentation.  New function will be added
>> in the next patch.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 64 +++++++++++++++++++++++++++++++-----------------
>>   1 file changed, 41 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ce4a34a..1524197 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -203,6 +203,44 @@ xfs_attr_calc_size(
>>          return nblks;
>>   }
>>
>> +STATIC int
>> +xfs_attr_try_sf_addname(
>> +       struct xfs_inode        *dp,
>> +       struct xfs_da_args      *args,
>> +       int                     flags)
>> +{
>> +
>> +       struct xfs_mount        *mp = dp->i_mount;
>> +       int                     error;
>> +       int                     err2;
>> +
>> +       error = xfs_attr_shortform_addname(args);
>> +       if (error != -ENOSPC) {
> 
> Not sure it made sense before, but in the context of this helper
> nesting most of the code path for the likely case is weird.
> Please return error if (error == -ENOSPC)
Sure, maybe I could do that change in the next patch.  I'm trying to 
avoid moving code and then changing it at the same time because I think 
it makes the reviews a little harder on folks.  Will fix though.  Thx!

Allison

> 
>> +               /*
>> +                * Commit the shortform mods, and we're done.
>> +                * NOTE: this is also the error path
>> +                * (EEXIST, etc).
>> +                */
>> +               ASSERT(args->trans != NULL);
>> +
>> +               /*
>> +                * If this is a synchronous mount, make sure
>> +                * that the transaction goes to disk before
>> +                * returning to the user.
>> +                */
>> +               if (mp->m_flags & XFS_MOUNT_WSYNC)
>> +                       xfs_trans_set_sync(args->trans);
>> +
>> +               if (!error && (flags & ATTR_KERNOTIME) == 0) {
>> +                       xfs_trans_ichgtime(args->trans, dp,
>> +                                       XFS_ICHGTIME_CHG);
>> +               }
>> +               err2 = xfs_trans_commit(args->trans);
>> +               error = error ? error : err2;
>> +       }
>> +       return error;
>> +}
>> +
>>   int
>>   xfs_attr_set(
>>          struct xfs_inode        *dp,
>> @@ -218,7 +256,7 @@ xfs_attr_set(
>>          struct xfs_trans_res    tres;
>>          xfs_fsblock_t           firstblock;
>>          int                     rsvd = (flags & ATTR_ROOT) != 0;
>> -       int                     error, err2, local;
>> +       int                     error, local;
>>
>>          XFS_STATS_INC(mp, xs_attr_set);
>>
>> @@ -297,30 +335,10 @@ xfs_attr_set(
>>                   * Try to add the attr to the attribute list in
>>                   * the inode.
>>                   */
>> -               error = xfs_attr_shortform_addname(&args);
>> +               error = xfs_attr_try_sf_addname(dp, &args, flags);
>>                  if (error != -ENOSPC) {
>> -                       /*
>> -                        * Commit the shortform mods, and we're done.
>> -                        * NOTE: this is also the error path (EEXIST, etc).
>> -                        */
>> -                       ASSERT(args.trans != NULL);
>> -
>> -                       /*
>> -                        * If this is a synchronous mount, make sure that
>> -                        * the transaction goes to disk before returning
>> -                        * to the user.
>> -                        */
>> -                       if (mp->m_flags & XFS_MOUNT_WSYNC)
>> -                               xfs_trans_set_sync(args.trans);
>> -
>> -                       if (!error && (flags & ATTR_KERNOTIME) == 0) {
>> -                               xfs_trans_ichgtime(args.trans, dp,
>> -                                                       XFS_ICHGTIME_CHG);
>> -                       }
>> -                       err2 = xfs_trans_commit(args.trans);
>>                          xfs_iunlock(dp, XFS_ILOCK_EXCL);
>> -
>> -                       return error ? error : err2;
>> +                       return error;
>>                  }
>>
>>                  /*
>> --
>> 2.7.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=xVunh0uk8Pktex1LHFbHolstfv3eqBBkWt5RkoG7tPA&s=eaQpPcYIgNL0hFyZdNc-dOXhzugeysrtVYd50uOAO1Q&e=
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=http-3A__vger.kernel.org_majordomo-2Dinfo.html&d=DwIBaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=LHZQ8fHvy6wDKXGTWcm97burZH5sQKHRDMaY1UthQxc&m=xVunh0uk8Pktex1LHFbHolstfv3eqBBkWt5RkoG7tPA&s=eaQpPcYIgNL0hFyZdNc-dOXhzugeysrtVYd50uOAO1Q&e=
> 
