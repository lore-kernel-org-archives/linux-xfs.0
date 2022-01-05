Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44940C433F5
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 01:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236840AbiAEBI2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 20:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233194AbiAEBI1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 20:08:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C514C061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 17:08:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DFFBB81810
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 01:08:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3159C36AED;
        Wed,  5 Jan 2022 01:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641344904;
        bh=4foUHYJSpM74Wk80HE7msPBZ9HeDDIjTCw+e+LzS8d8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uFrNn7di+fgYx/6rQatq50YF6AzOP+pQPY/+yvINqNcPis8EVuObHwj0XJ31VdEMm
         cKHqFWTiN5iqwkQVa7obfHUlkcsSG6KqSA97rBhHuxrojTExTj9jAG5HwtR2o8lf7h
         Yp9UgNDtc8QzgAuacEYp2bFPS1qgOpDJHgkSnvKYeiOhY3dDbQ3SgIv1M8+i1L7luE
         8sGqOOThNxkYp+64gWEyRolyqwXWbB4Fk904HP6p9LvM0SY89PJ9JNgWSbfGymTw5R
         8nJv2Ym4Vip4keeRMlIYRpcGVJYw1OHNJE9hOhFPGyGt3XPbd7uE06az6PVvr1r7fR
         kT4lH0AQbQCtA==
Date:   Tue, 4 Jan 2022 17:08:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 10/20] xfsprogs: Introduce XFS_DIFLAG2_NREXT64 and
 associated helpers
Message-ID: <20220105010824.GA656707@magnolia>
References: <20211214084811.764481-1-chandan.babu@oracle.com>
 <20211214084811.764481-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084811.764481-11-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:18:01PM +0530, Chandan Babu R wrote:
> This commit adds the new per-inode flag XFS_DIFLAG2_NREXT64 to indicate that
> an inode supports 64-bit extent counters. This flag is also enabled by default
> on newly created inodes when the corresponding filesystem has large extent
> counter feature bit (i.e. XFS_FEAT_NREXT64) set.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  db/inode.c          |  3 +++
>  include/xfs_inode.h |  5 +++++
>  libxfs/xfs_format.h | 10 +++++++++-
>  libxfs/xfs_ialloc.c |  2 ++
>  4 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/db/inode.c b/db/inode.c
> index 9afa6426..b1f92d36 100644
> --- a/db/inode.c
> +++ b/db/inode.c
> @@ -178,6 +178,9 @@ const field_t	inode_v3_flds[] = {
>  	{ "bigtime", FLDT_UINT1,
>  	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_BIGTIME_BIT - 1), C1,
>  	  0, TYP_NONE },
> +	{ "nrext64", FLDT_UINT1,
> +	  OI(COFF(flags2) + bitsz(uint64_t) - XFS_DIFLAG2_NREXT64_BIT-1), C1,

Nit: spaces around the '-' operator.

--D

> +	  0, TYP_NONE },
>  	{ NULL }
>  };
>  
> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 08a62d83..79a5c526 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h
> @@ -164,6 +164,11 @@ static inline bool xfs_inode_has_bigtime(struct xfs_inode *ip)
>  	return ip->i_diflags2 & XFS_DIFLAG2_BIGTIME;
>  }
>  
> +static inline bool xfs_inode_has_nrext64(struct xfs_inode *ip)
> +{
> +	return ip->i_diflags2 & XFS_DIFLAG2_NREXT64;
> +}
> +
>  typedef struct cred {
>  	uid_t	cr_uid;
>  	gid_t	cr_gid;
> diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
> index 23ecbc7d..58186f2b 100644
> --- a/libxfs/xfs_format.h
> +++ b/libxfs/xfs_format.h
> @@ -1180,15 +1180,17 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
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
> @@ -1196,6 +1198,12 @@ static inline bool xfs_dinode_has_bigtime(const struct xfs_dinode *dip)
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
> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 570349b8..77501317 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c
> @@ -2770,6 +2770,8 @@ xfs_ialloc_setup_geometry(
>  	igeo->new_diflags2 = 0;
>  	if (xfs_sb_version_hasbigtime(&mp->m_sb))
>  		igeo->new_diflags2 |= XFS_DIFLAG2_BIGTIME;
> +	if (xfs_sb_version_hasnrext64(&mp->m_sb))
> +		igeo->new_diflags2 |= XFS_DIFLAG2_NREXT64;
>  
>  	/* Compute inode btree geometry. */
>  	igeo->agino_log = sbp->sb_inopblog + sbp->sb_agblklog;
> -- 
> 2.30.2
> 
