Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o82FoifJ210833 for <xfs@oss.sgi.com>; Thu, 2 Sep 2010 10:50:44 -0500
Subject: Re: [PATCH] xfs: prevent 32bit overflow in space reservation
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1283404663-28105-1-git-send-email-david@fromorbit.com>
References: <1283404663-28105-1-git-send-email-david@fromorbit.com>
Date: Thu, 02 Sep 2010 10:51:19 -0500
Message-ID: <1283442679.5727.35.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Thu, 2010-09-02 at 15:17 +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> If we attempt to preallocate more than 2^32 blocks of space in a
> single syscall, the transaction block reservation will overflow
> leading to a hangs in the superblock block accounting code. This
> is trivially reproduced with xfs_io. Fix the problem by capping the
> allocation reservation to the maximum number of blocks a single
> xfs_bmapi() call can allocate (2^21 blocks).

This looks OK, but I have two comments, below.

> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_vnodeops.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index 66d585c..91dd9c8 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -2299,15 +2299,21 @@ xfs_alloc_file_space(
>  			e = allocatesize_fsb;
>  		}
>  
> +		/*
> +		 * we can't allocate more than @nimaps extents at a time,
> +		 * so prevent a 32bit overflow on the transaction reserve
> +		 * by trying to reserve > 16TB worth of blocks for the
> +		 * preallocation.
> +

This comment could use rewording.  How about something like:

	A 32-bit block count limits the amount of space that can
	be reserved in a transaction, so we need to limit the
	number of blocks reserved to avoid overflow.  We can't
	allocate more than @nimaps extents (whose size won't
	exceed 32 bits) at a time anyway, so use that to enforce
	the limit.

> 		 */
> +		resblks = min_t(xfs_fileoff_t, (e - s), (MAXEXTLEN * nimaps));

I guess it's clear that MAXEXTLEN fits in 32 bits because of
sizeof (xfs_extlen_t).  And inspection shows that nimaps is
just 1, so this does the 32-bit limiting.  But that just
seems indirect.  (Actually, now that I've written this I
updated the above comment and it's better...)

						-Alex


>  		if (unlikely(rt)) {
> -			resrtextents = qblocks = (uint)(e - s);
> +			resrtextents = qblocks = resblks;
>  			resrtextents /= mp->m_sb.sb_rextsize;
>  			resblks = XFS_DIOSTRAT_SPACE_RES(mp, 0);
>  			quota_flag = XFS_QMOPT_RES_RTBLKS;
>  		} else {
>  			resrtextents = 0;
> -			resblks = qblocks = \
> -				XFS_DIOSTRAT_SPACE_RES(mp, (uint)(e - s));
> +			resblks = qblocks = XFS_DIOSTRAT_SPACE_RES(mp, resblks);
>  			quota_flag = XFS_QMOPT_RES_REGBLKS;
>  		}
>  



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
