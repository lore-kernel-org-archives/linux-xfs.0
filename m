Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4A7557F6B
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 05:35:22 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3A4498F8040
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:35:13 -0800 (PST)
Received: from mail-oa0-f47.google.com (mail-oa0-f47.google.com
	[209.85.219.47]) by cuda.sgi.com with ESMTP id uQQku2EHh6wHUm47
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:34:47 -0800 (PST)
Received: by mail-oa0-f47.google.com with SMTP id k1so1908983oag.6
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 03:34:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125214611.GI8803@dastard>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
	<20131125214611.GI8803@dastard>
Date: Fri, 13 Dec 2013 19:34:43 +0800
Message-ID: <CAEH94Lixcey+PYGsLf3waeK1sv9QYriacMNe+pen-3jor3fG4g@mail.gmail.com>
Subject: Re: [RFC PATCH 4/4] xfs: allow linkat() on O_TMPFILE files
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Tue, Nov 26, 2013 at 5:46 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 25, 2013 at 07:32:34PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> Enable O_TMPFILE support in linkat().
>>
>> http://oss.sgi.com/archives/xfs/2013-08/msg00341.html
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/xfs/xfs_inode.c      |   23 +++++++++++++++++++++--
>>  fs/xfs/xfs_trans_resv.c |   13 +++++++++++++
>>  fs/xfs/xfs_trans_resv.h |    2 ++
>>  3 files changed, 36 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index e1832de..7ab029b 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -62,6 +62,8 @@ kmem_zone_t *xfs_inode_zone;
>>
>>  STATIC int xfs_iflush_int(xfs_inode_t *, xfs_buf_t *);
>>
>> +STATIC int xfs_iunlink_remove(xfs_trans_t *, xfs_inode_t *);
>> +
>>  /*
>>   * helper function to extract extent size hint from inode
>>   */
>> @@ -1119,7 +1121,9 @@ xfs_bumplink(
>>  {
>>       xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
>>
>> -     ASSERT(ip->i_d.di_nlink > 0);
>> +     if ((VFS_I(ip)->i_nlink == 0) &&
>> +         !(VFS_I(ip)->i_state & I_LINKABLE))
>> +             ASSERT(ip->i_d.di_nlink > 0);
>>       ip->i_d.di_nlink++;
>>       inc_nlink(VFS_I(ip));
>>       if ((ip->i_d.di_version == 1) &&
>> @@ -1473,6 +1477,7 @@ xfs_link(
>>  {
>>       xfs_mount_t             *mp = tdp->i_mount;
>>       xfs_trans_t             *tp;
>> +     struct xfs_trans_res    *tres;
>>       int                     error;
>>       xfs_bmap_free_t         free_list;
>>       xfs_fsblock_t           first_block;
>> @@ -1498,7 +1503,14 @@ xfs_link(
>>       tp = xfs_trans_alloc(mp, XFS_TRANS_LINK);
>>       cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>>       resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
>> -     error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, resblks, 0);
>> +
>> +     if ((VFS_I(sip)->i_nlink == 0) &&
>> +         (VFS_I(sip)->i_state & I_LINKABLE))
>> +             tres = &M_RES(mp)->tr_link_tmpfile;
>> +     else
>> +             tres = &M_RES(mp)->tr_link;
>> +
>> +     error = xfs_trans_reserve(tp, tres, resblks, 0);
>
> Uggh. For the small amount of extra space needed for the unlinked
> list reservation, I would simply add it to the tr_link reservation
> and be done with it. That gets rid of the need for the noise here.
>
>
> As per above, fold this into xfs_calc_link_reservation() by adding a:
>
>
>                 + xfs_calc_iunlink_remove_resv(mp);
This way seems to not work...
In xfs_calc_link_reservation(), How to determine if it is for one
regular file or O_TMPFILE file? since this functions is only passed in
mp?

>
> to the end of it.  Then you can also modify
> xfs_calc_ifree_reservation() to use the same
> xfs_calc_iunlink_remove_resv() function as well.
>
> [ And similarly, looking back on the previous patch
> xfs_calc_iunlink_add_resv can be used in xfs_calc_remove_reservation
> so all the unlinked list manipulations are covered by the same
> reservation calculations. ]
>
> Cheers,
>
> Dave.
> --
> Dave Chinner
> david@fromorbit.com



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
