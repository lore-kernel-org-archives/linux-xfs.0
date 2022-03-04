Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1854DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 08:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbiCDIKW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Mar 2022 03:10:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiCDIKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Mar 2022 03:10:21 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBA4EB3E70
        for <linux-xfs@vger.kernel.org>; Fri,  4 Mar 2022 00:09:33 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E6010533CE4;
        Fri,  4 Mar 2022 19:09:32 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nQ30G-001Lbw-4A; Fri, 04 Mar 2022 19:09:32 +1100
Date:   Fri, 4 Mar 2022 19:09:32 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220304080932.GK59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-16-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=6221c93d
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=xzpNzMKjZBXIPvwZF7cA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:36PM +0530, Chandan Babu R wrote:
> The following changes are made to enable userspace to obtain 64-bit extent
> counters,
> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>    it is capable of receiving 64-bit extent counters.
> 
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>  fs/xfs/xfs_ioctl.c     |  3 +++
>  fs/xfs/xfs_itable.c    | 30 ++++++++++++++++++++++++++++--
>  fs/xfs/xfs_itable.h    |  4 +++-
>  fs/xfs/xfs_iwalk.h     |  2 +-
>  5 files changed, 51 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2204d49d0c3a..31ccbff2f16c 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -378,7 +378,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> @@ -387,8 +387,9 @@ struct xfs_bulkstat {
>  	uint16_t	bs_checked;	/* checked inode metadata	*/
>  	uint16_t	bs_mode;	/* type and mode		*/
>  	uint16_t	bs_pad2;	/* zeroed			*/
> +	uint64_t	bs_extents64;	/* 64-bit data fork extent counter */
>  
> -	uint64_t	bs_pad[7];	/* zeroed			*/
> +	uint64_t	bs_pad[6];	/* zeroed			*/
>  };
>  
>  #define XFS_BULKSTAT_VERSION_V1	(1)
> @@ -469,8 +470,19 @@ struct xfs_bulk_ireq {
>   */
>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> -				 XFS_BULK_IREQ_SPECIAL)
> +/*
> + * Return data fork extent count via xfs_bulkstat->bs_extents64 field and assign
> + * 0 to xfs_bulkstat->bs_extents when the flag is set.  Otherwise, use
> + * xfs_bulkstat->bs_extents for returning data fork extent count and set
> + * xfs_bulkstat->bs_extents64 to 0. In the second case, return -EOVERFLOW and
> + * assign 0 to xfs_bulkstat->bs_extents if data fork extent count is larger than
> + * XFS_MAX_EXTCNT_DATA_FORK_OLD.
> + */
> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> +				 XFS_BULK_IREQ_SPECIAL | \
> +				 XFS_BULK_IREQ_NREXT64)
>  
>  /* Operate on the root directory inode. */
>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 2515fe8299e1..22947c5ffd34 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -813,6 +813,9 @@ xfs_bulk_ireq_setup(
>  	if (XFS_INO_TO_AGNO(mp, breq->startino) >= mp->m_sb.sb_agcount)
>  		return -ECANCELED;
>  
> +	if (hdr->flags & XFS_BULK_IREQ_NREXT64)
> +		breq->flags |= XFS_IBULK_NREXT64;
> +
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> index c08c79d9e311..0272a3c9d8b1 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -20,6 +20,7 @@
>  #include "xfs_icache.h"
>  #include "xfs_health.h"
>  #include "xfs_trans.h"
> +#include "xfs_errortag.h"
>  
>  /*
>   * Bulk Stat
> @@ -64,6 +65,7 @@ xfs_bulkstat_one_int(
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bulkstat	*buf = bc->buf;
> +	xfs_extnum_t		nextents;
>  	int			error = -EINVAL;
>  
>  	if (xfs_internal_inum(mp, ino))
> @@ -102,7 +104,27 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = ip->i_extsize;
> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> +
> +	nextents = xfs_ifork_nextents(&ip->i_df);
> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> +		xfs_extnum_t	max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
> +
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
> +			max_nextents = 10;
> +
> +		if (nextents > max_nextents) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			xfs_irele(ip);
> +			error = -EOVERFLOW;
> +			goto out;
> +		}

This just seems wrong. This will cause a total abort of the bulkstat
pass which will just be completely unexpected by any application
taht does not know about 64 bit extent counts. Most of them likely
don't even care about the extent count in the data being returned.

Really, I think this should just set the extent count to the MAX
number and just continue onwards, otherwise existing application
will not be able to bulkstat a filesystem with large extents counts
in it at all.

> @@ -256,6 +278,7 @@ xfs_bulkstat(
>  		.breq		= breq,
>  	};
>  	struct xfs_trans	*tp;
> +	unsigned int		iwalk_flags = 0;
>  	int			error;
>  
>  	if (breq->mnt_userns != &init_user_ns) {
> @@ -279,7 +302,10 @@ xfs_bulkstat(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
> +	if (breq->flags & XFS_IBULK_SAME_AG)
> +		iwalk_flags |= XFS_IWALK_SAME_AG;
> +
> +	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  	xfs_trans_cancel(tp);
>  out:

This looks like an unrelated bug fix and doesn't make any sense in
the context of the change being made in this patch.

> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 7078d10c9b12..9223529cd7bd 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -17,7 +17,9 @@ struct xfs_ibulk {
>  };
>  
>  /* Only iterate within the same AG as startino */
> -#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
> +#define XFS_IBULK_SAME_AG	(1ULL << 0)
> +
> +#define XFS_IBULK_NREXT64	(1ULL << 1)

Why are these defined as ULL? AFAICT they are only ever stored in an
unsigned int.

>  
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 37a795f03267..3a68766fd909 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -26,7 +26,7 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>  		unsigned int inode_records, bool poll, void *data);
>  
>  /* Only iterate inodes within the same AG as @startino. */
> -#define XFS_IWALK_SAME_AG	(0x1)
> +#define XFS_IWALK_SAME_AG	(1 << 0)

This also seems unrelated. If these flags need changing, can you
pull it out into a separate patch explaining the what and why it
needs changing because I'm getting lost in the 3-layer-deep (or is
it 4?) iwalk/ibulk/ibulkreq flag munging that is all intertwined in
this patch....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
