Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB347C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 02:57:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbiDMC7p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 22:59:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiDMC7o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 22:59:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D61E120BE
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 19:57:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C7EB82032
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 02:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E8CDC385A5;
        Wed, 13 Apr 2022 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649818641;
        bh=QmEeyPH45tsYepNv+UTir+D3BSnLdMjxyF8kSmoVwEk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OKOrVUBqS6XOJAWxV6QXw1fQbtTTtkp/4HT0YKpY1g7cF8aVEOtoZGBowRhVFDzFd
         HBCmpW4+2Y9pceZnfY8RImPc5UCs3McZWP/VBnrfjTyOzFYR3+S9EqCD5qOSv17tst
         uR8npC6wEAwfqafUzXzymUEqiqonYAFxr/EGCdbvET50LBU2n3nuQPAFYYICTL4q2J
         fCSrutIRmL6UCXBYpH5eCsK37qO2eCPNtOTZ69sWJSNdSzz8OL6pT3IGDqRONI4Fti
         DbgqIdv8qr7ekPddMNiPLVQ0+vk1U6RapQG/0yT3Y7G3s7Bp+h7G4J/UhuO2ln2zta
         50FEKemDwU9sg==
Date:   Tue, 12 Apr 2022 19:57:20 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9.1] xfs: Enable bulkstat ioctl to support 64-bit
 per-inode extent counters
Message-ID: <20220413025720.GL16799@magnolia>
References: <20220406061904.595597-19-chandan.babu@oracle.com>
 <20220409135709.495356-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409135709.495356-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Apr 09, 2022 at 07:27:09PM +0530, Chandan Babu R wrote:
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
>  fs/xfs/xfs_itable.c    |  9 ++++++++-
>  fs/xfs/xfs_itable.h    |  3 +++
>  4 files changed, 30 insertions(+), 5 deletions(-)
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

This /probably/ ought to be (1U << 2) but ... fmeh, I don't have gcc 5
and don't care to install it, so because the logic looks ok to me:

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

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
> index 71ed4905f206..f74c9fff72bb 100644
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
> @@ -102,7 +103,13 @@ xfs_bulkstat_one_int(
>  
>  	buf->bs_xflags = xfs_ip2xflags(ip);
>  	buf->bs_extsize_blks = ip->i_extsize;
> -	buf->bs_extents = xfs_ifork_nextents(&ip->i_df);
> +
> +	nextents = xfs_ifork_nextents(&ip->i_df);
> +	if (!(bc->breq->flags & XFS_IBULK_NREXT64))
> +		buf->bs_extents = min(nextents, XFS_MAX_EXTCNT_DATA_FORK_SMALL);
> +	else
> +		buf->bs_extents64 = nextents;
> +
>  	xfs_bulkstat_health(ip, buf);
>  	buf->bs_aextents = xfs_ifork_nextents(ip->i_afp);
>  	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
> diff --git a/fs/xfs/xfs_itable.h b/fs/xfs/xfs_itable.h
> index 5ee1d3f44ce9..e2d0eba43f35 100644
> --- a/fs/xfs/xfs_itable.h
> +++ b/fs/xfs/xfs_itable.h
> @@ -19,6 +19,9 @@ struct xfs_ibulk {
>  /* Only iterate within the same AG as startino */
>  #define XFS_IBULK_SAME_AG	(1U << 0)
>  
> +/* Fill out the bs_extents64 field if set. */
> +#define XFS_IBULK_NREXT64	(1U << 1)
> +
>  /*
>   * Advance the user buffer pointer by one record of the given size.  If the
>   * buffer is now full, return the appropriate error code.
> -- 
> 2.30.2
> 
