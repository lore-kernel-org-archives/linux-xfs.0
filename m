Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3B9AC433EF
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiDGBdv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242166AbiDGBcI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:32:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A5C1FCE6
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31C1FB8269A
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4D9C385A3;
        Thu,  7 Apr 2022 01:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294952;
        bh=6gVrImuTxI18fh0f/KFPrQ4Zu3DMQKMuvLI29Xz2SMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YvPo2kSjiV8n7YYkkEMak524bspkLOvmE1yUrnyIb0yO19qaZcx4wDH+zoZ+iPZfa
         HejnpSvM1SdtjjkV+txEr+JOd6KUNGk+fn8H4qrkjcBKr8Q0ndjOFtyue8yzo954I4
         4OtufkKzdT18EqZjuKbcrI3345jEIiW3j5UNn+czKlEXRlazVlxtGuB+I2oIhWQ0rg
         I1z9p4cCj1W/8UHsGmnHhpacEUkP+EgCeO1Uw47B1DRuIdo4/8TqIemUNFPI71oGT5
         MIfXhM0udkXzbHoPI+N/0zIQ5c7zxmjUeLR4YWq0PKFunHUBl/CagiSOONYZdoyonH
         55lcEPni3AIxA==
Date:   Wed, 6 Apr 2022 18:29:12 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH V9 18/19] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220407012912.GT27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-19-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-19-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:49:02AM +0530, Chandan Babu R wrote:
> The following changes are made to enable userspace to obtain 64-bit extent
> counters,
> 1. Carve out a new 64-bit field xfs_bulkstat->bs_extents64 from
>    xfs_bulkstat->bs_pad[] to hold 64-bit extent counter.
> 2. Define the new flag XFS_BULK_IREQ_BULKSTAT for userspace to indicate that
>    it is capable of receiving 64-bit extent counters.
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Suggested-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h | 20 ++++++++++++++++----
>  fs/xfs/xfs_ioctl.c     |  3 +++
>  fs/xfs/xfs_itable.c    | 13 ++++++++++++-
>  fs/xfs/xfs_itable.h    |  2 ++
>  4 files changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 1f7238db35cc..2a42bfb85c3b 100644
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
> index 83481005317a..e9eadc7337ce 100644
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
> index 71ed4905f206..847f03f75a38 100644
> --- a/fs/xfs/xfs_itable.c
> +++ b/fs/xfs/xfs_itable.c
> @@ -64,6 +64,7 @@ xfs_bulkstat_one_int(
>  	struct xfs_inode	*ip;		/* incore inode pointer */
>  	struct inode		*inode;
>  	struct xfs_bulkstat	*buf = bc->buf;
> +	xfs_extnum_t		nextents;
>  	int			error = -EINVAL;
>  
>  	if (xfs_internal_inum(mp, ino))
> @@ -102,7 +103,17 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = ip->i_extsize;
> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> +
> +	nextents = xfs_ifork_nextents(&ip->i_df);
> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64)) {
> +		if (nextents > XFS_MAX_EXTCNT_DATA_FORK_SMALL)
> +			buf->bs_extents = XFS_MAX_EXTCNT_DATA_FORK_SMALL;
> +		else
> +			buf->bs_extents = nextents;

buf->bs_extents = min(nextents, XFS_MAX_EXTCNT_DATA_FORK_SMALL); ?

> +	} else {
> +		buf->bs_extents64 = nextents;
> +	}
> +
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 2cf3872fcd2f..0150fd53d18e 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -19,6 +19,8 @@ struct xfs_ibulk {
>  /* Only iterate within the same AG as startino */
>  #define XFS_IBULK_SAME_AG	(1 << 0)
>  
> +#define XFS_IBULK_NREXT64	(1 << 1)

Needs a comment here.

/* Fill out the bs_extents64 field if set. */
#define XFS_IBULK_NREXT64	(1U << 1)

(Are we supposed to do "1U" now?)

--D

> +
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
>   * buffer is now full, return the appropriate error code.
> -- 
> 2.30.2
> 
