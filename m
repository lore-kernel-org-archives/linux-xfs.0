Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 34CE87F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 20:41:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B511CAC001
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:41:26 -0800 (PST)
Received: from mail-ob0-f173.google.com (mail-ob0-f173.google.com
	[209.85.214.173]) by cuda.sgi.com with ESMTP id
	oEIq2j7tgzKCfn7Y (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 18:41:25 -0800 (PST)
Received: by mail-ob0-f173.google.com with SMTP id gq1so8261988obb.18
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 18:41:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125213601.GH8803@dastard>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-3-git-send-email-zwu.kernel@gmail.com>
	<20131125213601.GH8803@dastard>
Date: Thu, 28 Nov 2013 10:41:24 +0800
Message-ID: <CAEH94LgFV9SUB0oy5TEn-FOegXw+cNfUSUv13fRAxD9V88XFQA@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] xfs: add xfs_create_tmpfile() for O_TMPFILE
	support
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

On Tue, Nov 26, 2013 at 5:36 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Mon, Nov 25, 2013 at 07:32:32PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> The function is used to create one O_TMPFILE file.
>>
>> http://oss.sgi.com/archives/xfs/2013-08/msg00339.html
>>
>> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>> ---
>>  fs/xfs/xfs_inode.c       |  129 ++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/xfs/xfs_inode.h       |    2 +
>>  fs/xfs/xfs_shared.h      |    4 +-
>>  fs/xfs/xfs_trans_resv.c  |   35 ++++++++++++
>>  fs/xfs/xfs_trans_resv.h  |    2 +
>>  fs/xfs/xfs_trans_space.h |    2 +
>>  6 files changed, 173 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
>> index 1c23bdf..e1832de 100644
>> --- a/fs/xfs/xfs_inode.c
>> +++ b/fs/xfs/xfs_inode.c
>> @@ -1337,6 +1337,135 @@ xfs_create(
>>  }
>>
>>  int
>> +xfs_create_tmpfile(
>> +     xfs_mount_t             *mp,
>> +     umode_t                 mode,
>> +     dev_t                   rdev,
>> +     xfs_inode_t             **ipp)
>> +{
>> +     struct xfs_inode        *ip = NULL;
>> +     struct xfs_trans        *tp = NULL;
>> +     int                     error;
>> +     uint                    cancel_flags = XFS_TRANS_RELEASE_LOG_RES;
>> +     struct xfs_dquot        *udqp = NULL;
>> +     struct xfs_dquot        *gdqp = NULL;
>> +     struct xfs_dquot        *pdqp = NULL;
>> +     struct xfs_trans_res    *tres;
>> +     uint                    resblks;
>> +
>> +     if (XFS_FORCED_SHUTDOWN(mp))
>> +             return XFS_ERROR(EIO);
>> +
>> +     /*
>> +      * Make sure that we have allocated dquot(s) on disk.
>> +      */
>> +     error = xfs_qm_vop_dqalloc(NULL, mp, xfs_kuid_to_uid(current_fsuid()),
>> +                                     xfs_kgid_to_gid(current_fsgid()),
>> +                                     XFS_PROJID_DEFAULT,
>> +                                     XFS_QMOPT_QUOTALL | XFS_QMOPT_INHERIT,
>> +                                     &udqp, &gdqp, &pdqp);
>> +     if (error)
>> +             return error;
>
> Is XFS_PROJID_DEFAULT correct here? If we are getting a parent inode
> from ->tmpfile, then this should be handled the same way as for
> xfs_create.
ok, will fix it.
>
>> +
>> +     resblks = XFS_CREATE_TMPFILE_SPACE_RES(mp);
>> +     tp = xfs_trans_alloc(mp, XFS_TRANS_CREATE_TMPFILE);
>> +
>> +     /*
>> +      * Initially assume that the file does not exist and
>> +      * reserve the resources for that case.  If that is not
>> +      * the case we'll drop the one we have and get a more
>> +      * appropriate transaction later.
>> +      */
>> +     tres = &M_RES(mp)->tr_create_tmpfile;
>> +     error = xfs_trans_reserve(tp, tres, resblks, 0);
>> +     if (error == ENOSPC) {
>> +             /* flush outstanding delalloc blocks and retry */
>> +             xfs_flush_inodes(mp);
>> +             error = xfs_trans_reserve(tp, tres, resblks, 0);
>> +     }
>> +     if (error == ENOSPC) {
>> +             /* No space at all so try a "no-allocation" reservation */
>> +             resblks = 0;
>> +             error = xfs_trans_reserve(tp, tres, 0, 0);
>> +     }
>> +     if (error) {
>> +             cancel_flags = 0;
>> +             goto out_trans_cancel;
>> +     }
>
> I don't think this is necessary here. The ENOSPC flushing in
> xfs_create() is done to ensure we have space for directory block
> creation, not so much for inode allocation. Hence it doesn't make a
> lot of sense to have this here....
Good explaination, will fix it, thanks.
>
>> +     /*
>> +      * Reserve disk quota and the inode.
>> +      */
>> +     error = xfs_trans_reserve_quota(tp, mp, udqp, gdqp,
>> +                                             pdqp, resblks, 1, 0);
>> +     if (error)
>> +             goto out_trans_cancel;
>> +
>> +     /*
>> +      * A newly created regular or special file just has one directory
>> +      * entry pointing to them, but a directory also the "." entry
>> +      * pointing to itself.
>> +      */
>> +     error = xfs_dir_ialloc(&tp, NULL, mode, 1, rdev,
>> +                             XFS_PROJID_DEFAULT, resblks > 0,
>> +                             &ip, NULL);
>> +     if (error) {
>> +             if (error == ENOSPC)
>> +                     goto out_trans_cancel;
>> +             goto out_trans_abort;
>> +     }
>> +
>> +     /*
>> +      * If this is a synchronous mount, make sure that the
>> +      * create transaction goes to disk before returning to
>> +      * the user.
>> +      */
>> +     if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
>> +             xfs_trans_set_sync(tp);
>
> I'm not sure that XFS_MOUNT_DIRSYNC shoul dbe checked here, as there
> is no directory operations to synchronise at all...
ok, will fix it.
>
>> +STATIC uint
>> +xfs_calc_icreate_tmpfile_reservation(xfs_mount_t *mp)
>> +{
>> +     return XFS_DQUOT_LOGRES(mp) +
>> +             xfs_calc_icreate_resv_alloc(mp) +
>> +             xfs_calc_inode_res(mp, 1) +
>> +             xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
>> +             xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>> +}
>> +
>> +STATIC uint
>> +__xfs_calc_create_tmpfile_reservation(
>> +     struct xfs_mount        *mp)
>> +{
>> +     return XFS_DQUOT_LOGRES(mp) +
>> +             xfs_calc_create_resv_alloc(mp) +
>> +             xfs_calc_inode_res(mp, 1) +
>> +             xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, 1)) +
>> +             xfs_calc_buf_res(2, mp->m_sb.sb_sectsize);
>> +}
>
> What exactly is being modified here? All of the other reservations
> have comments explaining what each of the individual components of
> the reservation are. Yes, I can see that there's an inode, a
> filesystem block and 2 sectors being reserved, but what are they?
Will add some comments in next version.
>
> It's also double counting the XFS_DQUOT_LOGRES(), as they are
> accounted for in xfs_calc_[i]create_reservation().
I don't understand why you said it double counts XFS_DQUOT_LOGRES()? i
only see it is counted once. Can you say more details?

>
> Also, the directory create reservations are broken up into two
> components - the inode allocation and the common directory name
> creation component, and so the tmpfile reservation should probably
> be broken up the same way. i.e this:
>
>> +
>> +STATIC uint
>> +xfs_calc_create_tmpfile_reservation(
>> +     struct xfs_mount        *mp)
>> +{
>> +     if (xfs_sb_version_hascrc(&mp->m_sb))
>> +             return xfs_calc_icreate_tmpfile_reservation(mp);
>> +     return __xfs_calc_create_tmpfile_reservation(mp);
>> +}
>
> Could simply be:
>
> STATIC uint
> xfs_calc_create_tmpfile_reservation(
>         struct xfs_mount        *mp)
> {
>         uint    res;
>
>         if (xfs_sb_version_hascrc(&mp->m_sb))
>                 res = xfs_calc_icreate_resv_alloc(mp);
>         else
>                 res = xfs_calc_create_resv_alloc(mp);
>         return res + xfs_calc_iunlink_add_resv(mp);
> }
Good suggestion, will apply this.
>
>
>> diff --git a/fs/xfs/xfs_trans_space.h b/fs/xfs/xfs_trans_space.h
>> index 7d2c920..16fba89 100644
>> --- a/fs/xfs/xfs_trans_space.h
>> +++ b/fs/xfs/xfs_trans_space.h
>> @@ -61,6 +61,8 @@
>>       (XFS_DAENTER_SPACE_RES(mp, XFS_ATTR_FORK) + XFS_B_TO_FSB(mp, v))
>>  #define      XFS_CREATE_SPACE_RES(mp,nl)     \
>>       (XFS_IALLOC_SPACE_RES(mp) + XFS_DIRENTER_SPACE_RES(mp,nl))
>> +#define      XFS_CREATE_TMPFILE_SPACE_RES(mp)        \
>> +     XFS_IALLOC_SPACE_RES(mp)
>
> I wouldn't bother with this macro - just use XFS_IALLOC_SPACE_RES()
> directly.
ok, will remove this macro.

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
