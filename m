Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q06B2scj014542 for <xfs@oss.sgi.com>; Fri, 6 Jan 2012 05:02:54 -0600
MIME-Version: 1.0
In-Reply-To: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
References: <1325848338-6063-1-git-send-email-amit.sahrawat83@gmail.com>
Date: Fri, 6 Jan 2012 16:32:48 +0530
Message-ID: <CADDb1s3fBFEXY5Z=ZjJtzOM09fdH4n_Je2eGAgkgqGF9n__oFg@mail.gmail.com>
Subject: Re: [PATCH 2/2] xfs: cleanup XFS_BB_FSB_OFFSET
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
To: Alex Elder <aelder@sgi.com>, Ben Myers <bpm@sgi.com>, xfs masters <xfs-masters@oss.sgi.com>, xfs <xfs@oss.sgi.com>, linux kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Amit Sahrawat <amit.sahrawat83@gmail.com>

Courtesy: Dave Chinner


Thanks & Regards,
Amit Sahrawat

On Fri, Jan 6, 2012 at 4:42 PM, Amit Sahrawat <amit.sahrawat83@gmail.com> w=
rote:
> Removing the macro, as this is no more needed in the code.
> Tried to find the reference when it was last used - but the usage
> for this seemed to have been dropped long time ago.
>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
> =A0fs/xfs/xfs_sb.h | =A0 =A01 -
> =A01 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_sb.h b/fs/xfs/xfs_sb.h
> index cb6ae71..f429d9d 100644
> --- a/fs/xfs/xfs_sb.h
> +++ b/fs/xfs/xfs_sb.h
> @@ -529,7 +529,6 @@ static inline int xfs_sb_version_hasprojid32bit(xfs_s=
b_t *sbp)
> =A0#define =A0 =A0 =A0 =A0XFS_BB_TO_FSB(mp,bb) =A0 =A0\
> =A0 =A0 =A0 =A0(((bb) + (XFS_FSB_TO_BB(mp,1) - 1)) >> (mp)->m_blkbb_log)
> =A0#define =A0 =A0 =A0 =A0XFS_BB_TO_FSBT(mp,bb) =A0 ((bb) >> (mp)->m_blkb=
b_log)
> -#define =A0 =A0 =A0 =A0XFS_BB_FSB_OFFSET(mp,bb) ((bb) & ((mp)->m_bsize -=
 1))
>
> =A0/*
> =A0* File system block to byte conversions.
> --
> 1.7.2.3
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
