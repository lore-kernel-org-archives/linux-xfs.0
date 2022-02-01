Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C5D8C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Feb 2022 19:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242245AbiBATYx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Feb 2022 14:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231995AbiBATYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Feb 2022 14:24:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1FAC061714
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 11:24:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 260CDB82F4F
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 19:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA6EC340EB;
        Tue,  1 Feb 2022 19:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643743489;
        bh=GcqGuLyxU+g3wUUKi0B1E0OOLbvfNk/G6I0T1ib8GLk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M9Wze4+CXihmDpS2o4I1FQcAEIjqWCZhC46xDe43kW8yekyU6CLTHPBY0XeY2lOy0
         77vJ5MtV730B4apPbRArIt6vhKZlkHNLK/9zQH5+ZrzkQx+S4AeGnIBRlqFhE02Y33
         IjcI3wRUaeSM/Zg5d0MJ2+AfxP/gTGRbJOLgupSWPBNLUZj22JIJiBLNIO6cmGhHf4
         abUoKIeW79v2JbjVLSnkBdork4sSBuHRqCNCtWVr6EmcxNYeunB4AyvCD2rrUJEHPH
         uous+U1XJY/1PaYvn8iB1jLd9FsNRGvJxDw3h7tcitYFmstuk9H6YKoBsGXKhGXJ0e
         GQY5bcVqkS7yw==
Date:   Tue, 1 Feb 2022 11:24:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V5 14/16] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220201192449.GB8338@magnolia>
References: <20220121051857.221105-1-chandan.babu@oracle.com>
 <20220121051857.221105-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121051857.221105-15-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jan 21, 2022 at 10:48:55AM +0530, Chandan Babu R wrote:
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
>  fs/xfs/libxfs/xfs_fs.h | 12 ++++++++----
>  fs/xfs/xfs_ioctl.c     |  3 +++
>  fs/xfs/xfs_itable.c    | 27 +++++++++++++++++++++++++--
>  fs/xfs/xfs_itable.h    |  7 ++++++-
>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>  5 files changed, 47 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 42bc39501d81..4e12530eb518 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -393,7 +393,7 @@ struct xfs_bulkstat {
>  	uint32_t	bs_extsize_blks; /* extent size hint, blocks	*/
>  
>  	uint32_t	bs_nlink;	/* number of links		*/
> -	uint32_t	bs_extents;	/* number of extents		*/
> +	uint32_t	bs_extents;	/* 32-bit data fork extent counter */
>  	uint32_t	bs_aextents;	/* attribute number of extents	*/
>  	uint16_t	bs_version;	/* structure version		*/
>  	uint16_t	bs_forkoff;	/* inode fork offset in bytes	*/
> @@ -402,8 +402,9 @@ struct xfs_bulkstat {
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
> @@ -484,8 +485,11 @@ struct xfs_bulk_ireq {
>   */
>  #define XFS_BULK_IREQ_SPECIAL	(1 << 1)
>  
> -#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO | \
> -				 XFS_BULK_IREQ_SPECIAL)
> +#define XFS_BULK_IREQ_NREXT64	(1 << 2)

This needs a comment specifying the behavior of this flag.

If the flag is set and the data fork extent count fits in both fields,
will they both be filled out?

If the flag is set but the data fork extent count only fits in
bs_extents64, what will be written to bs_extents?

If the flag is not set and the data fork extent count won't fit in
bs_extents, do we return an error value?  Fill it with garbage?

> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> +				 XFS_BULK_IREQ_SPECIAL | \
> +				 XFS_BULK_IREQ_NREXT64)
>  
>  /* Operate on the root directory inode. */
>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 29231a8c8a45..5d0781745a28 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -893,6 +893,9 @@ xfs_bulk_ireq_setup(
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
> index c08c79d9e311..c9b44e8d0235 100644
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
> +		xfs_extnum_t max_nextents = XFS_MAX_EXTCNT_DATA_FORK_OLD;
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
> +
> +		buf->bs_extents = nextents;
> +	} else {
> +		buf->bs_extents64 = nextents;
> +	}
> +
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> @@ -279,7 +301,8 @@ xfs_bulkstat(
>  	if (error)
>  		goto out;
>  
> -	error = xfs_iwalk(breq->mp, tp, breq->startino, breq->flags,
> +	error = xfs_iwalk(breq->mp, tp, breq->startino,
> +			breq->flags & XFS_IBULK_IWALK_MASK,

I think it would be cleaner if this function did:

	unsigned int	iwalk_flags = 0;

	if (breq->flags & XFS_IBULK_SAME_AG)
		iwalk_flags |= XFS_IWALK_SAME_AG;

	...

	error = xfs_iwalk(breq->mp, tp, breq->startino, iwalk_flags,
			xfs_bulkstat_iwalk, breq->icount, &bc);

to make the flags translation explicit.  That enables a full cleanup
of...

>  			xfs_bulkstat_iwalk, breq->icount, &bc);
>  	xfs_trans_cancel(tp);
>  out:
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 7078d10c9b12..38f6900176a8 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -13,12 +13,17 @@ struct xfs_ibulk {
>  	xfs_ino_t		startino; /* start with this inode */
>  	unsigned int		icount;   /* number of elements in ubuffer */
>  	unsigned int		ocount;   /* number of records returned */
> -	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
> +	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */
>  };
>  
>  /* Only iterate within the same AG as startino */
>  #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>  
> +#define XFS_IBULK_ONLY_OFFSET	32
> +#define XFS_IBULK_IWALK_MASK	((1ULL << XFS_IBULK_ONLY_OFFSET) - 1)
> +
> +#define XFS_IBULK_NREXT64	(1ULL << XFS_IBULK_ONLY_OFFSET)

...the code smells in the XFS_IBULK* flag space:

/* Only iterate within the same AG as startino */
#define XFS_IBULK_SAME_AG	(1 << 0)

/* Whatever it is that nrext64 does */
#define XFS_IBULK_NREXT64	(1 << 31)

> +
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
>   * buffer is now full, return the appropriate error code.
> diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
> index 37a795f03267..11be9dbb45c7 100644
> --- a/fs/xfs/xfs_iwalk.h
> +++ b/fs/xfs/xfs_iwalk.h
> @@ -26,9 +26,12 @@ int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
>  		unsigned int inode_records, bool poll, void *data);
>  
>  /* Only iterate inodes within the same AG as @startino. */
> -#define XFS_IWALK_SAME_AG	(0x1)
> +#define XFS_IWALK_SAME_AG	(1 << 0)
>  
> -#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
> +#define XFS_IWALK_NREXT64	(1 << 1)
> +
> +#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
> +				 XFS_IWALK_NREXT64)

XFS_IWALK_NREXT64 isn't used anywhere.

--D

>  
>  /* Walk all inode btree records in the filesystem starting from @startino. */
>  typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> -- 
> 2.30.2
> 
