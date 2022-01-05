Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC84C433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiAEAnJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbiAEAnJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:43:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A88D7C061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 16:43:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE0D61615
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B106AC36AEB;
        Wed,  5 Jan 2022 00:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641343387;
        bh=U04jGeDerVKs/LMTmIAWQ/qXOYkSfmir1y39ZWs/3yA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bin7PCyhbcjqN5f23EkU5ZqgW9VYTsSDTzSfIEOensD3hLlmzrOEVeDsKRcdtHzBl
         w3betxKvEFO1TCi7TRSTt9lBqThB/w4YeUgMLRWUEjEX1YbHPwmfmCGuptZxJhZxjI
         d5aqb/XeRmd2Fg+9M5GrQemRqtSpcOo9VwMXs7ZrL/kByc/ffUibT+jhrYUNvaWMyb
         pCxBe5WSoKjh4lq7AUTJNSr3NRfqzeCDbMB4tyQdGRLvD2/7qLmm36FurfOP8nYEZJ
         daeXIZC8cRXhNoFJpIebSUDNKwbPU1IX5dJRtIx0OxJ1OO8oQVLt/boXVB6PSsE3UJ
         BKV/8MN1xhqqQ==
Date:   Tue, 4 Jan 2022 16:43:07 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 09/16] xfs: Introduce XFS_DIFLAG2_NREXT64 and
 associated helpers
Message-ID: <20220105004307.GS31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-10-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-10-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:12PM +0530, Chandan Babu R wrote:
> This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
> an inode supports 64-bit extent counters. This flag is also enabled by default
> on newly created inodes when the corresponding filesystem has large extent
> counter feature bit (i.e. XFS_FEAT_NREXT64) set.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>

Seems pretty straightforward so far; let's see what I think as I keep
going...

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_format.h      | 10 +++++++++-
>  fs/xfs/libxfs/xfs_ialloc.c      |  2 ++
>  fs/xfs/xfs_inode.h              |  5 +++++
>  fs/xfs/xfs_inode_item_recover.c |  6 ++++++
>  4 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 7972cbc22608..9934c320bf01 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -992,15 +992,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
>  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
>  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
>  #define XFS_DIFLAG2_BIGTIME_BIT	3	/* big timestamps */
> +#define XFS_DIFLAG2_NREXT64_BIT 4	/* 64-bit extent counter enabled */
>  
>  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
>  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
>  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
>  #define XFS_DIFLAG2_BIGTIME	(1 << XFS_DIFLAG2_BIGTIME_BIT)
> +#define XFS_DIFLAG2_NREXT64	(1 << XFS_DIFLAG2_NREXT64_BIT)
>  
>  #define XFS_DIFLAG2_ANY \
>  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> -	 XFS_DIFLAG2_BIGTIME)
> +	 XFS_DIFLAG2_BIGTIME | XFS_DIFLAG2_NREXT64)
>  
>  static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  {
> @@ -1008,6 +1010,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
>  	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_BIGTIME));
>  }
>  
> +static inline bool xfs_dinode_has_nrext64(const struct xfs_dinode *dip)
> +{
> +	return dip->di_version >= 3 &&
> +	       (dip->di_flags2 & cpu_to_be64(XFS_DIFLAG2_NREXT64));
> +}
> +
>  /*
>   * Inode number format:
>   * low inopblog bits - offset in block
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index b418fe0c0679..1d2ba51483ec 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -2772,6 +2772,8 @@ xfs_ialloc_setup_geometry(
>  	igeo->new_diflags2 = 0;
>  	if (xfs_has_bigtime(mp))
>  		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
> +	if (xfs_has_nrext64(mp))
> +		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
>  
>  	/* Compute inode btree geometry. */
>  	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index c447bf04205a..97946156359d 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -218,6 +218,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
>  }
>  
> +static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
> +{
> +	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
> +}
> +
>  /*
>   * Return the buftarg used for data allocations on a given inode.
>   */
> diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> index 239dd2e3384e..767a551816a0 100644
> --- a/fs/xfs/xfs_inode_item_recover.c
> +++ b/fs/xfs/xfs_inode_item_recover.c
> @@ -142,6 +142,12 @@ xfs_log_dinode_to_disk_ts(
>  	return ts;
>  }
>  
> +static inline bool xfs_log_dinode_has_nrext64(const struct xfs_log_dinode *ld)
> +{
> +	return ld->di_version >= 3 &&
> +	       (ld->di_flags2 & XFS_DIFLAG2_NREXT64);
> +}
> +
>  STATIC void
>  xfs_log_dinode_to_disk(
>  	struct xfs_log_dinode	*from,
> -- 
> 2.30.2
> 
