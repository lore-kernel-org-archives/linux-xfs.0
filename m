Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0A2167F4E
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 19:48:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BE1148F8070
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 17:48:34 -0800 (PST)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	0EBfScPHE6smgL2J (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 27 Nov 2013 17:48:30 -0800 (PST)
Received: by mail-ob0-f170.google.com with SMTP id wp18so8299909obc.29
	for <xfs@oss.sgi.com>; Wed, 27 Nov 2013 17:48:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131125134821.GB30189@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<1385379154-3802-3-git-send-email-zwu.kernel@gmail.com>
	<20131125134821.GB30189@infradead.org>
Date: Thu, 28 Nov 2013 09:48:29 +0800
Message-ID: <CAEH94Lhx2Zz62GEWHq1pr3TcFH7TWKdX-bZfVDwyBw=grZNFmQ@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

OK, will fix or cleanup all the comments, thanks.

On Mon, Nov 25, 2013 at 9:48 PM, Christoph Hellwig <hch@infradead.org> wrote:
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
>
>>  int
>> +xfs_create_tmpfile(
>> +     xfs_mount_t             *mp,
>> +     umode_t                 mode,
>> +     dev_t                   rdev,
>> +     xfs_inode_t             **ipp)
>
> Please use struct xfs_mount and struct xfs_inode for any new code.
>
>> +     /*
>> +      * Initially assume that the file does not exist and
>> +      * reserve the resources for that case.  If that is not
>> +      * the case we'll drop the one we have and get a more
>> +      * appropriate transaction later.
>> +      */
>
> I can't see how this comment makes any sense.
>
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
>
> Please factor this into a new xfs_trans_reserver_create helper (better
> names welcome of course).
> similar.
>
>> +     /*
>> +      * Reserve disk quota and the inode.
>> +      */
>
> I don't think that comment adds a whole lot of value.  (Same for the
> other quota comment above).
>
>> +     /*
>> +      * A newly created regular or special file just has one directory
>> +      * entry pointing to them, but a directory also the "." entry
>> +      * pointing to itself.
>> +      */
>
> Given that we only create regular files here the comment can be removed.
>
>>
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
>> +
>> +STATIC uint
>> +xfs_calc_create_tmpfile_reservation(
>> +     struct xfs_mount        *mp)
>> +{
>> +     if (xfs_sb_version_hascrc(&mp->m_sb))
>> +             return xfs_calc_icreate_tmpfile_reservation(mp);
>> +     return __xfs_calc_create_tmpfile_reservation(mp);
>
> Shouldn't we name this xfs_calc_create_tmpfile_reservation_v4 and _v5
> or no postix and _crc?  Either way the double underscore naming looks
> confusing.
It follows up with the current naming style of regular file
reservation functions.
After we adopt Dave's suggestion, this issue will disappear.

>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
