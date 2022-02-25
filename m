Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96BB4C433EF
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Feb 2022 05:10:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234063AbiBYFKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Feb 2022 00:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbiBYFKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 00:10:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 982762692EA
        for <linux-xfs@vger.kernel.org>; Thu, 24 Feb 2022 21:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B226618F3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 05:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DBDC340E7;
        Fri, 25 Feb 2022 05:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645765810;
        bh=GoYlKL9KcvFmw3kDejhbsP3NU9a9oP/mIWIJQaxTO2o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A+qjDVBzyyx2CTDoNCH/R3D/lWP436VPVkYkzBvlP9+9bOn04Wo8XJ6gr6ZWSU/hm
         rqaGKLTa3fY8u1dKWQzH2Hz6OKoq+03dtiFVVDHp4OlobZjkIbQTZU6+P8V+Ld2qXM
         +Ymb7rYpqPHl3NlPinM+2irY/uwMu16ryjgOTjZ7smBME/rZntlZ+2hzf4LyTqN9tf
         OvXE34KLCq8ucNHwAeCifMKlux6YI1qesbbyxngpdvd2vsU76010/yg2LUeereJS1i
         LXJfvp7bdSrcdkXYZC83xWU5Iy+oAjWhKGA6VX0il05sPBj107v6u2XDb9xo799GSB
         4714cAIBXFm2g==
Date:   Thu, 24 Feb 2022 21:10:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V6 15/17] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220225051010.GK8338@magnolia>
References: <20220224130211.1346088-1-chandan.babu@oracle.com>
 <20220224130211.1346088-16-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224130211.1346088-16-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 24, 2022 at 06:32:09PM +0530, Chandan Babu R wrote:
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
>  fs/xfs/xfs_itable.h    |  6 ++++--
>  fs/xfs/xfs_iwalk.h     |  2 +-
>  5 files changed, 52 insertions(+), 9 deletions(-)
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
> index c08c79d9e311..11e5245756f7 100644
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

Nit: space between type ^^^^^ and variable name.

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
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 7078d10c9b12..2cb5611c873e 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -13,11 +13,13 @@ struct xfs_ibulk {
>  	xfs_ino_t		startino; /* start with this inode */
>  	unsigned int		icount;   /* number of elements in ubuffer */
>  	unsigned int		ocount;   /* number of records returned */
> -	unsigned int		flags;    /* see XFS_IBULK_FLAG_* */
> +	unsigned long long	flags;    /* see XFS_IBULK_FLAG_* */

I wonder if this could have been left an unsigned int and the flags
below assigned adjacent bits instead of widening the field...

>  };
>  
>  /* Only iterate within the same AG as startino */
> -#define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
> +#define XFS_IBULK_SAME_AG	(1ULL << 0)
> +
> +#define XFS_IBULK_NREXT64	(1ULL << 32)

...but was your purpose here to make it really obvious that we've
separated IWALK and IBULK?

--D

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
>  
>  #define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG)
>  
> -- 
> 2.30.2
> 
