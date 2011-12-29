Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBTECXqs010586 for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 08:12:33 -0600
Received: from mail-tul01m020-f181.google.com (mail-tul01m020-f181.google.com
	[209.85.214.181]) by cuda.sgi.com with ESMTP id
	KC2ByeqLM2pIbJ1A for <xfs@oss.sgi.com>;
	Thu, 29 Dec 2011 06:12:31 -0800 (PST)
Received: by obbup6 with SMTP id up6so10955010obb.26
	for <xfs@oss.sgi.com>; Thu, 29 Dec 2011 06:12:31 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 29 Dec 2011 19:42:31 +0530
Message-ID: <CAJ61zBCgsy8=Ty9swem_TsWeVh-7iHrRfy1tMwvB4UePRj3c=w@mail.gmail.com>
Subject: Conversion Routine Help
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
To: xfs@oss.sgi.com

Hi list,

Can anyone please provide me links about the basic explanations of XFS
basic blocks and filesystem logical block mapping and conversion
routines?

I tried to understand from code but its not clear to me:
#define XFS_FSB_TO_BB(mp,fsbno) ((fsbno) << (mp)->m_blkbb_log)
#define XFS_BB_TO_FSB(mp,bb) =A0 =A0\
=A0 =A0 =A0 =A0(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
#define XFS_BB_TO_FSBT(mp,bb) =A0 ((bb) >> (mp)->m_blkbb_log)
#define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))

lets consider the last one:
#define XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize - 1))

if basic block (512 byte size) number is 7 and m_bsize is 12
(considering FS block size 4096), then this will return 3 [e.g. ( 7 &
11) ]. then what does 3 means here? what offset value it is denoting?

Thanks in advance.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
