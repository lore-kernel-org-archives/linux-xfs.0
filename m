Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B06C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiDGBdw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242152AbiDGBcH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:32:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DC3190EB5
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:26:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E36C360AF5
        for <linux-xfs@vger.kernel.org>; Thu,  7 Apr 2022 01:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B44C385A1;
        Thu,  7 Apr 2022 01:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294811;
        bh=BdcllleRo4A/QHlA2HorAK+irTVIH0i7eXyTd1Ez9Xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=unEXG7Eaf/tW7xjOgEy+bcCm+48Pr03pHy2aVk5sdWkgiJooGfLZX6qsYFmNR9Q3l
         bZFxUAkKV/NtIbuRlvDmZQo59S5Tf/RXbpWA9Z+Y2ph+TZZZan9/j7fS2limZV7Fh2
         uSDTdOnq/KlSHtxoqh15fZWZwqH8aGfEydloQ1EqBlGhnV3cuCndFrBue88fG0cfVd
         RdUMz4/Cz+6nZRZHWJCCrth2FSRYWP+rndPiV0nlW21EkOI6c4jLv0giDkwtQLTLLm
         93rkZlU4DYFzjjWc8A+EgUVvySLsmRxsW+cgfTyF4MpDbmrhBcIsPGOO4z6Gq0N7qi
         xWLKug5QSMp9w==
Date:   Wed, 6 Apr 2022 18:26:50 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V9 19/19] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the
 list of supported flags
Message-ID: <20220407012650.GS27690@magnolia>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-20-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:49:03AM +0530, Chandan Babu R wrote:
> This commit enables XFS module to work with fs instances having 64-bit
> per-inode extent counters by adding XFS_SB_FEAT_INCOMPAT_NREXT64 flag to the
> list of supported incompat feature flags.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 3 ++-
>  fs/xfs/xfs_super.c         | 5 +++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index bb327ea43ca1..b3f4a33b986c 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -378,7 +378,8 @@ xfs_sb_has_ro_compat_feature(
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
>  		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
>  		 XFS_SB_FEAT_INCOMPAT_BIGTIME| \
> -		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
> +		 XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR| \
> +		 XFS_SB_FEAT_INCOMPAT_NREXT64)
>  
>  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
>  static inline bool
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 54be9d64093e..14591492c384 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1639,6 +1639,11 @@ xfs_fs_fill_super(
>  		goto out_filestream_unmount;
>  	}
>  
> +	if (xfs_has_large_extent_counts(mp)) {
> +		xfs_warn(mp,
> +	"EXPERIMENTAL Large extent counts feature in use. Use at your own risk!");
> +	}

Style nit: no need for braces here.

But thanks for putting on the EXPERIMENTAL tag.

--D

> +
>  	error = xfs_mountfs(mp);
>  	if (error)
>  		goto out_filestream_unmount;
> -- 
> 2.30.2
> 
