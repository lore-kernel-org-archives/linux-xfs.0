Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTGiPoT018633 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 10:44:25 -0600
Received: from mail-lpp01m010-f53.google.com (mail-lpp01m010-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id 24UOpuOZ1K52suc8
	for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 08:44:21 -0800 (PST)
Received: by lagr15 with SMTP id r15so6474559lag.26
	for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 08:44:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJ61zBCgsy8=Ty9swem_TsWeVh-7iHrRfy1tMwvB4UePRj3c=w@mail.gmail.com>
References: <CAJ61zBCgsy8=Ty9swem_TsWeVh-7iHrRfy1tMwvB4UePRj3c=w@mail.gmail.com>
Date: Thu, 29 Dec 2011 22:14:20 +0530
Message-ID: <CADDb1s3XKAhhz5V6XTw=Dp-AqtxVwEq7ndLdmeAtiuT9v7tjKg@mail.gmail.com>
Subject: Re: Conversion Routine Help
From: Amit Sahrawat <amit.sahrawat83@gmail.com>
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
To: Vijay Chauhan <kernel.vijay@gmail.com>
Cc: xfs@oss.sgi.com

On Thu, Dec 29, 2011 at 7:42 PM, Vijay Chauhan <kernel.vijay@gmail.com> wro=
te:
> Hi list,
>
> Can anyone please provide me links about the basic explanations of XFS
> basic blocks and filesystem logical block mapping and conversion
> routines?
You can refer the XFSdocuments from the links:
http://oss.sgi.com/projects/xfs/papers/xfs_filesystem_structure.pdf
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/htm=
l/index.html
But the information which you are looking for is actually - trying to
dig into the layout of filesystem on disk.
After going through intial documents - few things can be verified by
taking a hexdump of the disk and then analysing the data. Keeping the
filesystem partition to empty and to a small partition size will help
fast analyses. You can give this a try with a 100MB XFS formatted
partition.
>
> I tried to understand from code but its not clear to me:
> #define XFS_FSB_TO_BB(mp,fsbno) ((fsbno) << (mp)->m_blkbb_log)
> #define XFS_BB_TO_FSB(mp,bb) =A0 =A0\
> =A0 =A0 =A0 =A0(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
> #define XFS_BB_TO_FSBT(mp,bb) =A0 ((bb) >> (mp)->m_blkbb_log)
> #define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
>
> lets consider the last one:
> #define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))
>
> if basic block (512 byte size) number is 7 and m_bsize is 12
> (considering FS block size 4096), then this will return 3 [e.g. ( 7 &
> 11) ]. then what does 3 means here? what offset value it is denoting?
If I am correct this indicates the starting block with respect to that
partition.
So, If I have 20GB disk with 10-10 GB partitions, and Suppose the
second partition is XFS formatted - then layout will be in terms of
offset on that partition and not with respect to Starting of the disk.
For actually checking the data about some file and understanding more:
Create a file on XFS partition and then use xfs_bmap to view the block
mapping of the file(xfs_db can also be used - this is explained in the
documents - but this works on unmounted device)
xfs_bmap <filename> will return a layout for the file(in terms of extent)
0: [0..9503]:          67181048..67190551
where the values in [] - indicates starting and ending offset, while
the values next to it represent the block numbers on that disk with
respect to that partition. These values are in terms of 'sectors' and
not in blocks - so to actually correlate them - divide each values by
'8'(512 =3D4096/8)


Thanks
Amit Sahrawat
>
> Thanks in advance.
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
