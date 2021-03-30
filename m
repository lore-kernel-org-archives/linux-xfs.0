Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9910C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:23:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926E9619BC
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Mar 2021 15:23:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhC3PXH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Mar 2021 11:23:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232057AbhC3PW6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Mar 2021 11:22:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D720A619AB;
        Tue, 30 Mar 2021 15:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617117778;
        bh=cFdMvbTtUW2JyTTKD9C3aUdKrY/CkqAqHMlpE2OLdhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F2RLRzWZl69bGsX1C/Io4AdZhD7Z87olS8T0SOe8Mn1J73RtDgomTqyXS/o9MdTsI
         5BOGnMXi29Qz+wMNvWWwEiqkVaqrIFG0mle5T3pdY+I4i5XTX4w170mrwUPNNBf6z0
         +8MZEIm8Ew/VKO9gMs1AtCB+kP/iodnx4JkMXUbTBtxWgGDcEyA72ZYCV9g2LFZKSh
         tYQ+VXVKfCg/IqhRRODhYlBIX7urZ4bjllQ1/aQpjzaaV8XrbfrKRVrZhrsUTuQY7+
         ro+qDuYPDakGV0HKRWcK88xm1iTVN/db3mOfWQF3ZWOUU62MM1t4j2I9ze6hUWlxi4
         NRhBN7zi/ZAAQ==
Date:   Tue, 30 Mar 2021 08:22:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/20] xfs: use a union for i_cowextsize and i_flushiter
Message-ID: <20210330152256.GO4090233@magnolia>
References: <20210329053829.1851318-1-hch@lst.de>
 <20210329053829.1851318-16-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210329053829.1851318-16-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 29, 2021 at 07:38:24AM +0200, Christoph Hellwig wrote:
> The i_cowextsize field is only used for v3 inodes, and the i_flushiter
> field is only used for v1/v2 inodes.  Use a union to pack the inode a
> littler better after adding a few missing guards around their usage.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me (and tests ok this time),
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_inode_buf.c |  3 ++-
>  fs/xfs/xfs_inode.c            |  6 ++++--
>  fs/xfs/xfs_inode.h            |  7 +++++--
>  fs/xfs/xfs_ioctl.c            | 15 +++++++++------
>  4 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 3c7eb01c66ace4..88ec7be551a89d 100644
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
> index 06d779c9334b80..e483c380afd1db 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3483,8 +3483,10 @@ xfs_iflush(
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
> index abe5b44b46220a..abb8672da0ceb4 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -58,8 +58,11 @@ typedef struct xfs_inode {
>  	xfs_rfsblock_t		i_nblocks;	/* # of direct & btree blocks */
>  	prid_t			i_projid;	/* owner's project id */
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
> index 7909e46b5c5a18..2028a4aa2bb20a 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1123,7 +1123,8 @@ xfs_fill_fsxattr(
>  	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
>  
>  	fa->fsx_extsize = XFS_FSB_TO_B(mp, ip->i_extsize);
> -	fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
> +	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> +		fa->fsx_cowextsize = XFS_FSB_TO_B(mp, ip->i_cowextsize);
>  	fa->fsx_projid = ip->i_projid;
>  	if (ifp && (ifp->if_flags & XFS_IFEXTENTS))
>  		fa->fsx_nextents = xfs_iext_count(ifp);
> @@ -1523,11 +1524,13 @@ xfs_ioctl_setattr(
>  		ip->i_extsize = XFS_B_TO_FSB(mp, fa->fsx_extsize);
>  	else
>  		ip->i_extsize = 0;
> -	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> -	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
> -		ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
> -	else
> -		ip->i_cowextsize = 0;
> +
> +	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
> +		if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
> +			ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
> +		else
> +			ip->i_cowextsize = 0;
> +	}
>  
>  	error = xfs_trans_commit(tp);
>  
> -- 
> 2.30.1
> 
