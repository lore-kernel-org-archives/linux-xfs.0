Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0A74D7F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:28:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8CCCCAC001
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:28:45 -0800 (PST)
Received: from mail-ob0-f181.google.com (mail-ob0-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	mb8GuKV2HIiwOfcK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 18:28:44 -0800 (PST)
Received: by mail-ob0-f181.google.com with SMTP id uy5so8294141obc.12
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:28:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125214611.GI8803@dastard>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-5-git-send-email-zwu.kernel@gmail.com>
	<20131125214611.GI8803@dastard>
Date: Thu, 28 Nov 2013 10:28:43 +0800
Message-ID: <CAEH94LgHoM+_fG4MSozZ9N07fFmjHuEL7hDD0rK07qa=xsqikQ@mail.gmail.com>
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
will apply this.
>
>>       if (error == ENOSPC) {
>>               resblks = 0;
>>               error = xfs_trans_reserve(tp, &M_RES(mp)->tr_link, 0, 0);
>> @@ -1530,6 +1542,13 @@ xfs_link(
>>
>>       xfs_bmap_init(&free_list, &first_block);
>>
>> +     if ((VFS_I(sip)->i_nlink == 0) &&
>> +         (VFS_I(sip)->i_state & I_LINKABLE)) {
>> +             error = xfs_iunlink_remove(tp, sip);
>> +             if (error)
>> +                     goto abort_return;
>> +     }
>> +
>>       error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
>>                                       &first_block, &free_list, resblks);
>>       if (error)
>> diff --git a/fs/xfs/xfs_trans_resv.c b/fs/xfs/xfs_trans_resv.c
>> index f1eebe4..7c1234e 100644
>> --- a/fs/xfs/xfs_trans_resv.c
>> +++ b/fs/xfs/xfs_trans_resv.c
>> @@ -228,6 +228,15 @@ xfs_calc_link_reservation(
>>                                     XFS_FSB_TO_B(mp, 1))));
>>  }
>>
>> +STATIC uint
>> +xfs_calc_link_tmpfile_reservation(
>> +     struct xfs_mount        *mp)
>> +{
>> +     return xfs_calc_link_reservation(mp) +
>> +             xfs_calc_buf_res(2, XFS_FSB_TO_B(mp, 1)) +
>> +             xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>> +}
>
> As per above, fold this into xfs_calc_link_reservation() by adding a:
>
>
>                 + xfs_calc_iunlink_remove_resv(mp);
>
> to the end of it.  Then you can also modify
> xfs_calc_ifree_reservation() to use the same
> xfs_calc_iunlink_remove_resv() function as well.
>
> [ And similarly, looking back on the previous patch
> xfs_calc_iunlink_add_resv can be used in xfs_calc_remove_reservation
> so all the unlinked list manipulations are covered by the same
> reservation calculations. ]
Good suggestion, will try to apply them in next version, thanks.
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
