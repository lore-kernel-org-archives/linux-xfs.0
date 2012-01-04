Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q047uAuW122125 for <xfs@oss.sgi.com>; Wed, 4 Jan 2012 01:56:10 -0600
Received: from mail-tul01m020-f181.google.com (mail-tul01m020-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	iPg7cx04j68IOToA for <xfs@oss.sgi.com>;
	Tue, 03 Jan 2012 23:56:09 -0800 (PST)
Received: by obbup6 with SMTP id up6so15709130obb.26
	for <xfs@oss.sgi.com>; Tue, 03 Jan 2012 23:56:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20111229215412.GM23662@dastard>
References: <CAJ61zBCgsy8=Ty9swem_TsWeVh-7iHrRfy1tMwvB4UePRj3c=w@mail.gmail.com>
	<20111229215412.GM23662@dastard>
Date: Wed, 4 Jan 2012 13:26:09 +0530
Message-ID: <CAJ61zBCBT7-vr0SCyt4teXTA9JezpEtPRuuPkH9NSrZdx8Pb8Q@mail.gmail.com>
Subject: Re: Conversion Routine Help
From: Vijay Chauhan <kernel.vijay@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Hi,


>>
>> Can anyone please provide me links about the basic explanations of XFS
>> basic blocks and filesystem logical block mapping and conversion
>> routines?
>>
>> I tried to understand from code but its not clear to me:
>> #define XFS_FSB_TO_BB(mp,fsbno) ((fsbno) << (mp)->m_blkbb_log)
>
> Convert FileSystem Blocks to Basic Blocks
>
> FSBs are defined at mkfs time, BBs are always 512 bytes.
>
>> #define XFS_BB_TO_FSB(mp,bb) =A0 =A0\
>> =A0 =A0 =A0 =A0(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
>
> Convert BB to FSB, rounding up to the next FSB
>
>> #define XFS_BB_TO_FSBT(mp,bb) =A0 ((bb) >> (mp)->m_blkbb_log)
>
> Convert BB to FSB, rounding down to the FSB containing the BB
>
>> #define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
>
> Offset of the give BB within a FSB. e.g. if FSB =3D 4k =3D 8BB, then
> "bb =3D 5" would return 5, "bb =3D 63" would return 7...
>
>> lets consider the last one:
>> #define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
>>
>> if basic block (512 byte size) number is 7 and m_bsize is 12
>
> m_bsize is the FSB in BB, which will always be a power of 2.
>
>> (considering FS block size 4096), then this will return 3 [e.g. ( 7 &
>
> in that case, m_bsize =3D 8.
>
>> 11) ]. then what does 3 means here? what offset value it is denoting?
>
> It's the offset of the BB within the first partial FSB in the range
> given. This was once used for sub-block zeroing needed by direct IO,
> but is now stale code as the generic DIO layer does this zeroing.
> Care to submit a patch to remove that macro?
>

Thanks Dave. I understand.

I am newbie and learning. Sure, i'll create the patch but before let
me try out further in the code.

Thanks.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
