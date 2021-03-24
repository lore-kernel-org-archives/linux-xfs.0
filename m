Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7DF1C433E0
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93AB461A09
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 18:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237474AbhCXSdb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:33:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237464AbhCXSdM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Mar 2021 14:33:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CCC561A12;
        Wed, 24 Mar 2021 18:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616610792;
        bh=OXd0n/ZOn/diQ5O6WDEXnQSR4usUHkUZJRsesAA0w5s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A0enueC+vqXtOEGRGIkspyLXnj/oxHqen4PlzGMvIbXMQNE/Kv+7oOr+2EbTe9wGu
         j4xp1X+piCTAq3Dk1IyuMhHhLCfTcbheWkbp9HKbcWS3PybMt9qSyhl/Od+JjVMmvF
         SGVqx073FfPMG6lX/cTscmQ8+LyUkB49C3+Gq1VhchgLgX5FGhEIGkQMpPXnz0d/mb
         ulCMGM1FIPUDCyu4NdpOcVJu2fnVL4gOMDxoLRUV3XgriBq3M6QTkkkBS8P/PehsjR
         r4Xb+/hgkZ6EHimoIr33xHu2U2D7OaoavDvFs9+VEmORdvV07QprEnBBEP/qFIVWNl
         yTXKgxj73aDDQ==
Date:   Wed, 24 Mar 2021 11:33:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 13/18] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20210324183311.GL22100@magnolia>
References: <20210324142129.1011766-1-hch@lst.de>
 <20210324142129.1011766-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324142129.1011766-14-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 24, 2021 at 03:21:24PM +0100, Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes, that's a nice compression opportunity.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c | 3 ++-
>  fs/xfs/xfs_inode.c            | 6 ++++--
>  fs/xfs/xfs_inode.h            | 7 +++++--
>  fs/xfs/xfs_ioctl.c            | 6 +++++-
>  4 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index d090274fb8a152..96db2649f6b2fe 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -193,7 +193,8 @@ xfs_inode_from_disk(
>  	 * inode. If the inode is unused, mode is zero and we shouldn't mess
>  	 * with the uninitialized part of it.
>  	 */
> -	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
> +	if (!xfs_sb_version_has_v3inode(&ip->i_mount->m_sb))
> +		ip->i_flushiter = be16_to_cpu(from->di_flushiter);
>  	inode->i_generation = be32_to_cpu(from->di_gen);
>  	inode->i_mode = be16_to_cpu(from->di_mode);
>  	if (!inode->i_mode)
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index e951ea48b3a276..b4b6fddccd1ca0 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3459,8 +3459,10 @@ xfs_iflush(
>  	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
>  
>  	/* Wrap, we never let the log put out DI_MAX_FLUSH */
> -	if (ip->i_flushiter == DI_MAX_FLUSH)
> -		ip->i_flushiter = 0;
> +	if (!xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (ip->i_flushiter == DI_MAX_FLUSH)
> +			ip->i_flushiter = 0;
> +	}
>  
>  	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
>  	if (XFS_IFORK_Q(ip))
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 6246ee8a4359ab..7ba0ffa50ede20 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,11 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	uint32_t		i_projid;	/* owner's project id */
>  	xfs_extlen_t		i_extsize;	/* basic/minimum extent size */
> -	xfs_extlen_t		i_cowextsize;	/* basic cow extent size */
> -	uint16_t		i_flushiter;	/* incremented on flush */
> +	/* cowextsize is only used for v3 inodes, flushiter for v1/2 */
> +	union {
> +		xfs_extlen_t	i_cowextsize;	/* basic cow extent size */
> +		uint16_t	i_flushiter;	/* incremented on flush */
> +	};
>  
>  	struct xfs_icdinode	i_d;		/* most of ondisk inode */
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index e45bce9b11082c..3405a5f5bacfda 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1121,7 +1121,11 @@ xfs_fill_fsxattr(
>  
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
> -	fa->fsx_cowextsize = ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb) &&
> +	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)) {
> +		fa->fsx_cowextsize =
> +			ip->i_cowextsize << ip->i_mount->m_sb.sb_blocklog;
> +	}
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> -- 
> 2.30.1
> 
