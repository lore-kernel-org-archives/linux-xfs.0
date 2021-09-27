Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97BC6C433F5
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 23:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AECD6103B
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Sep 2021 23:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhI0XIT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Sep 2021 19:08:19 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:42933 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229901AbhI0XIS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 19:08:18 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id E2BBA860104;
        Tue, 28 Sep 2021 09:06:38 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUzhl-00HTvQ-Sf; Tue, 28 Sep 2021 09:06:37 +1000
Date:   Tue, 28 Sep 2021 09:06:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V3 09/12] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20210927230637.GL1756565@dread.disaster.area>
References: <20210916100647.176018-1-chandan.babu@oracle.com>
 <20210916100647.176018-10-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916100647.176018-10-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=JYX8GbI94EFIXoEu5KIA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 16, 2021 at 03:36:44PM +0530, Chandan Babu R wrote:
> The following changes are made to enable userspace to obtain 64-bit extent
> counters,
> 1. To hold 64-bit extent counters, carve out the new 64-bit field
>    xfs_bulkstat->bs_extents64 from xfs_bulkstat->bs_pad[].
> 2. Carve out a new 64-bit field xfs_bulk_ireq->bulkstat_flags from
>    xfs_bulk_ireq->reserved[] to hold bulkstat specific operational flags.  As of
>    this commit, XFS_IBULK_NREXT64 is the only valid flag that this field can
>    hold. It indicates that userspace has the necessary infrastructure to
>    receive 64-bit extent counters.
> 3. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>    xfs_bulk_ireq->bulkstat_flags has valid flags set.

This seems unnecessarily complex. It adds a new flag to define a new
flag field in the same structure and then define a new and a new
flag in the new flag field to define a new behaviour.

Why can't this be done with just a single new flag in the existing
flags field?

> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 19 ++++++++++++++-----
>  fs/xfs/xfs_ioctl.c     |  7 +++++++
>  fs/xfs/xfs_itable.c    | 25 +++++++++++++++++++++++--
>  fs/xfs/xfs_itable.h    |  2 ++
>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>  5 files changed, 51 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 2594fb647384..b76906914d89 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -394,7 +394,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents32;	/* 32-bit data fork extent counter */
>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/

I don't think renaming structure members is a good idea - it breaks
the user API and forces applications to require source level
modifications just to compile on both old and new xfsprogs installs.

> @@ -403,8 +403,9 @@ struct xfs_bulkstat {
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
> @@ -469,7 +470,8 @@ struct xfs_bulk_ireq {
>  	uint32_t	icount;		/* I: count of entries in buffer */
>  	uint32_t	ocount;		/* O: count of entries filled out */
>  	uint32_t	agno;		/* I: see comment for IREQ_AGNO	*/
> -	uint64_t	reserved[5];	/* must be zero			*/
> +	uint64_t	bulkstat_flags; /* I: Bulkstat operation flags */
> +	uint64_t	reserved[4];	/* must be zero			*/
>  };
>  
>  /*
> @@ -492,9 +494,16 @@ struct xfs_bulk_ireq {
>   */
>  #define XFS_BULK_IREQ_METADIR	(1 << 2)
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> +#define XFS_BULK_IREQ_BULKSTAT	(1 << 3)
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
>  				 XFS_BULK_IREQ_SPECIAL | \
> -				 XFS_BULK_IREQ_METADIR)
> +				 XFS_BULK_IREQ_METADIR | \
> +				 XFS_BULK_IREQ_BULKSTAT)

What's this XFS_BULK_IREQ_METADIR thing? I haven't noticed that when
scanning any recent proposed patch series....

> +#define XFS_BULK_IREQ_BULKSTAT_NREXT64 (1 << 0)
> +
> +#define XFS_BULK_IREQ_BULKSTAT_FLAGS_ALL (XFS_BULK_IREQ_BULKSTAT_NREXT64)

As per above, this seems unnecessarily complex.

> @@ -134,7 +136,26 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = ip->i_extsize;
> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> +
> +	nextents = xfs_ifork_nextents(&ip->i_df);
> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> +		xfs_extnum_t max_nextents = XFS_IFORK_EXTCNT_MAXS32;
> +
> +		if (unlikely(XFS_TEST_ERROR(false, mp,
> +				XFS_ERRTAG_REDUCE_MAX_IEXTENTS)))
> +			max_nextents = 10;
> +
> +		if (nextents > max_nextents) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			xfs_irele(ip);
> +			error = -EINVAL;
> +			goto out_advance;
> +		}

So we return an EINVAL error if any extent overflows the 32 bit
counter? Why isn't this -EOVERFLOW?

> +		buf->bs_extents32 = nextents;
> +	} else {
> +		buf->bs_extents64 = nextents;
> +	}
> +
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> @@ -356,7 +377,7 @@ xfs_bulkstat_to_bstat(
>  	bs1->bs_blocks = bstat->bs_blocks;
>  	bs1->bs_xflags = bstat->bs_xflags;
>  	bs1->bs_extsize = XFS_FSB_TO_B(mp, bstat->bs_extsize_blks);
> -	bs1->bs_extents = bstat->bs_extents;
> +	bs1->bs_extents = bstat->bs_extents32;
>  	bs1->bs_gen = bstat->bs_gen;
>  	bs1->bs_projid_lo = bstat->bs_projectid & 0xFFFF;
>  	bs1->bs_forkoff = bstat->bs_forkoff;
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index f5a13f69883a..f61685da3837 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -22,6 +22,8 @@ struct xfs_ibulk {
>  /* Signal that we can return metadata directories. */
>  #define XFS_IBULK_METADIR	(XFS_IWALK_METADIR)
>  
> +#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
> +
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
>   * buffer is now full, return the appropriate error code.
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index d7a082e45cbf..27a6842a1bb5 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -31,8 +31,11 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>  /* Signal that we can return metadata directories. */
>  #define XFS_IWALK_METADIR	(0x2)
>  
> -#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG | \
> -				 XFS_IWALK_METADIR)
> +#define XFS_IWALK_NREXT64	(0x4)

Can we use '(1 << 2)' style notation for new bit field defines?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
