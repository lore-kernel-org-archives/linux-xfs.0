Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B6AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbiAEA2Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236756AbiAEA2W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:28:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFAEC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 16:28:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97A96B810B6
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58F31C36AEB;
        Wed,  5 Jan 2022 00:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641342499;
        bh=laPcnHxa90FRaU5C0YTPlDlCeCQZcsiKalmiHNMUuAg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lrc2Jp6MQwTJ1ExvjuTVJ5Y/XO+Z/QIQXVJ50B0SVxSshwiRihaL1/9zwxhtKYaFo
         +tLH4LogqSJO+bY7Bidmh5rGETgIkr6RXRs2jZKbyCMIWF59pvwXoNni8B30rKyzU5
         TmSrq9O6IBLLr9aHh33ccNiANVsqmZ7v8IBFweB3AjDTIWI67or6P4IKzHOy1VXG3T
         JSUp71/7LB2nv9xEBPsiPDgRuNLvTBVAvEdeLkqa1DQYT9r0ZkIORWONlGI8IZtlqu
         orIZN/AkOd6XWD7TpnkG5UwZ29+I8ezfDCFJbEyxbYj3EabJIFSdtVmFtqBc8w36dk
         HgKIZzRzz3gYA==
Date:   Tue, 4 Jan 2022 16:28:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 14/16] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220105002819.GQ31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-15-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-15-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:17PM +0530, Chandan Babu R wrote:
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
>  fs/xfs/xfs_itable.c    | 24 +++++++++++++++++++++++-
>  fs/xfs/xfs_itable.h    |  2 ++
>  fs/xfs/xfs_iwalk.h     |  7 +++++--
>  5 files changed, 41 insertions(+), 7 deletions(-)
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
> +
> +#define XFS_BULK_IREQ_FLAGS_ALL	(XFS_BULK_IREQ_AGNO |	 \
> +				 XFS_BULK_IREQ_SPECIAL | \
> +				 XFS_BULK_IREQ_NREXT64)
>  
>  /* Operate on the root directory inode. */
>  #define XFS_BULK_IREQ_SPECIAL_ROOT	(1)
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index 174cd8950cb6..d9e9a805b67b 100644
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
> index c08c79d9e311..53ec0afebdc9 100644
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
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 7078d10c9b12..a561acd95383 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -19,6 +19,8 @@ struct xfs_ibulk {
>  /* Only iterate within the same AG as startino */
>  #define XFS_IBULK_SAME_AG	(XFS_IWALK_SAME_AG)
>  
> +#define XFS_IBULK_NREXT64	(XFS_IWALK_NREXT64)
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

The ability of the caller to handle 64-bit extent counters is not
relevant to the internal inode walking code, so I don't think this
belongs in the iwalk flags namespace.

IOWs, XFS_IBULK_NREXT64 should be defined like this:

#define XFS_IBULK_NREXT64	(1U << 31)

and xfs_bulkstat should be changed to translate only the relevant
breq->flags into the appropriate IWALK bits.  Sorry for the code
smell...

--D

> +
> +#define XFS_IWALK_FLAGS_ALL	(XFS_IWALK_SAME_AG |	\
> +				 XFS_IWALK_NREXT64)
>  
>  /* Walk all inode btree records in the filesystem starting from @startino. */
>  typedef int (*xfs_inobt_walk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
> -- 
> 2.30.2
> 
