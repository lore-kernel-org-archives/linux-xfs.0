Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5EA4C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:24:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90D9360E08
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbhGNX1h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:27:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhGNX1g (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:27:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A517A613CC;
        Wed, 14 Jul 2021 23:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626305084;
        bh=eUFw4BRfWDCxlIhIOCKDXEfbcDvYSAyMry2c+ObWCe8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IPd5jrIcLckO3IDjxH8gpQ8jTSoejXMgfd+tHY45RGKRtTcbf7PkwQZNJtoybC0h9
         L2X8sZRDJae5tJl1nali2lq5j7ZK8ABgwATfRkxGId1B7chdOgioy/aXrmMM3rEr6U
         qz+n9l0EaInyZ9e+0MKgA4BnPoVbxVQQZqorakbPRuEGgwg899XkDV8V54KusoYwcX
         fj2kVRLtdmFNg3CPFK3Sk9pGGT4+BxlnM2f+ioIMAMdEi/pZk63XISGWsxzMsLRhcJ
         GAb0hPzGAKXzmpUy3m5FlMQ48ZtXJDfRR3TuGGCoQzgOPGmeQzvHc/OLIoW9ZdL898
         LGUBkLFyXCITw==
Date:   Wed, 14 Jul 2021 16:24:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/16] xfs: kill xfs_sb_version_has_v3inode()
Message-ID: <20210714232444.GJ22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-17-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-17-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:12PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All callers to xfs_dinode_good_version() and XFS_DINODE_SIZE() in
> both the kernel and userspace have a xfs_mount structure available
> which means they can use mount features checks instead looking
> directly are the superblock.
> 
> Convert these functions to take a mount and use a xfs_has_v3inodes()
> check and move it out of the libxfs/xfs_format.h file as it really
> doesn't have anything to do with the definition of the on-disk
> format.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h    | 18 +++---------------
>  fs/xfs/libxfs/xfs_ialloc.c    |  3 +--
>  fs/xfs/libxfs/xfs_inode_buf.c |  2 +-
>  fs/xfs/libxfs/xfs_inode_buf.h | 11 ++++++++++-
>  4 files changed, 15 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e1ecb3237075..452ae4114c92 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -399,18 +399,6 @@ xfs_sb_has_incompat_log_feature(
>  }
>  
>  
> -/*
> - * v5 file systems support V3 inodes only, earlier file systems support
> - * v2 and v1 inodes.
> - */
> -static inline bool xfs_dinode_good_version(struct xfs_sb *sbp,
> -		uint8_t version)
> -{
> -	if (xfs_sb_is_v5(sbp))
> -		return version == 3;
> -	return version == 1 || version == 2;
> -}
> -
>  static inline bool
>  xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
>  {
> @@ -877,12 +865,12 @@ enum xfs_dinode_fmt {
>  /*
>   * Inode size for given fs.
>   */
> -#define XFS_DINODE_SIZE(sbp) \
> -	(xfs_sb_is_v5(sbp) ? \
> +#define XFS_DINODE_SIZE(mp) \
> +	(xfs_has_crc(mp) ? \
>  		sizeof(struct xfs_dinode) : \
>  		offsetof(struct xfs_dinode, di_crc))
>  #define XFS_LITINO(mp) \
> -	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(&(mp)->m_sb))
> +	((mp)->m_sb.sb_inodesize - XFS_DINODE_SIZE(mp))
>  
>  /*
>   * Inode data & attribute fork sizes, per inode.
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 51768f8999e5..702d4e11dd7f 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -337,7 +337,6 @@ xfs_ialloc_inode_init(
>  		xfs_buf_zero(fbuf, 0, BBTOB(fbuf->b_length));
>  		for (i = 0; i < M_IGEO(mp)->inodes_per_cluster; i++) {
>  			int	ioffset = i << mp->m_sb.sb_inodelog;
> -			uint	isize = XFS_DINODE_SIZE(&mp->m_sb);
>  
>  			free = xfs_make_iptr(mp, fbuf, i);
>  			free->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
> @@ -354,7 +353,7 @@ xfs_ialloc_inode_init(
>  			} else if (tp) {
>  				/* just log the inode core */
>  				xfs_trans_log_buf(tp, fbuf, ioffset,
> -						  ioffset + isize - 1);
> +					  ioffset + XFS_DINODE_SIZE(mp) - 1);
>  			}
>  		}
>  
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 08b4413d3ac4..327d05300f24 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -58,7 +58,7 @@ xfs_inode_buf_verify(
>  		dip = xfs_buf_offset(bp, (i << mp->m_sb.sb_inodelog));
>  		unlinked_ino = be32_to_cpu(dip->di_next_unlinked);
>  		di_ok = xfs_verify_magic16(bp, dip->di_magic) &&
> -			xfs_dinode_good_version(&mp->m_sb, dip->di_version) &&
> +			xfs_dinode_good_version(mp, dip->di_version) &&
>  			xfs_verify_agino_or_null(mp, agno, unlinked_ino);
>  		if (unlikely(XFS_TEST_ERROR(!di_ok, mp,
>  						XFS_ERRTAG_ITOBP_INOTOBP))) {
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
> index 7f865bb4df84..585ed5a110af 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.h
> +++ b/fs/xfs/libxfs/xfs_inode_buf.h
> @@ -21,7 +21,7 @@ struct xfs_imap {
>  
>  int	xfs_imap_to_bp(struct xfs_mount *mp, struct xfs_trans *tp,
>  		       struct xfs_imap *imap, struct xfs_buf **bpp);
> -void	xfs_dinode_calc_crc(struct xfs_mount *, struct xfs_dinode *);
> +void	xfs_dinode_calc_crc(struct xfs_mount *mp, struct xfs_dinode *dip);
>  void	xfs_inode_to_disk(struct xfs_inode *ip, struct xfs_dinode *to,
>  			  xfs_lsn_t lsn);
>  int	xfs_inode_from_disk(struct xfs_inode *ip, struct xfs_dinode *from);
> @@ -42,4 +42,13 @@ static inline uint64_t xfs_inode_encode_bigtime(struct timespec64 tv)
>  struct timespec64 xfs_inode_from_disk_ts(struct xfs_dinode *dip,
>  		const xfs_timestamp_t ts);
>  
> +static inline bool
> +xfs_dinode_good_version(struct xfs_mount *mp, uint8_t version)
> +{
> +	if (xfs_has_v3inodes(mp))
> +		return version == 3;
> +	return version == 1 || version == 2;
> +}
> +
> +
>  #endif	/* __XFS_INODE_BUF_H__ */
> -- 
> 2.31.1
> 
