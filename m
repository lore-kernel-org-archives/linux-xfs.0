Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6EEBC433EF
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Jan 2022 00:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbiAEADS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 19:03:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiAEADS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 19:03:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B9CC061761
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 16:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E2B9615D4
        for <linux-xfs@vger.kernel.org>; Wed,  5 Jan 2022 00:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A8FC36AE0;
        Wed,  5 Jan 2022 00:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641340996;
        bh=qLK5eWD/qRO+gDuEqar+LmAlhS8KixNnzN0Vd/w04B4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=F+1T5itpiQ9RVFintXHak63rh/paxUgudstnPZAOFfyuHXTDF+H4XGgnO99czclSw
         j6dnVkTAZ5jK38iaONA2vu9MwH+rUynecmqk93BEcBUSiucFuhPyE9n62ixR0EVa1c
         tcAQnuSEeO48xlXoOsL1o5EGXmXFKEW9sKLYG9rGSE6m97quor8TBrtpi0WQSTT8A7
         AMYrdfjZhvTGu/s9iql9a1tWsbM8FB+/SZ7AB7oMGR/7UdJEwCauk1Qbx3RRv3N7tB
         Jp4pWLpYIi6d6Od3VqDeIj9V8lgkKKGqMlSARP9Hbitw+XjSLfQ1weylbKGsVZeHc3
         A6sCcqoQYq8Wg==
Date:   Tue, 4 Jan 2022 16:03:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH V4 07/16] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and
 associated per-fs feature bit
Message-ID: <20220105000316.GN31583@magnolia>
References: <20211214084519.759272-1-chandan.babu@oracle.com>
 <20211214084519.759272-8-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214084519.759272-8-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 14, 2021 at 02:15:10PM +0530, Chandan Babu R wrote:
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
> which support large per-inode extent counters. This commit defines the new
> incompat feature bit and the corresponding per-fs feature bit (along with
> inline functions to work on it).
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_format.h | 1 +
>  fs/xfs/libxfs/xfs_sb.c     | 3 +++
>  fs/xfs/xfs_mount.h         | 2 ++
>  3 files changed, 6 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index e5654b578ec0..7972cbc22608 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
>  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
> +#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* 64-bit data fork extent counter */

EXT6, I like it. :P

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

>  #define XFS_SB_FEAT_INCOMPAT_ALL \
>  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
>  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
> index f4e84aa1d50a..bd632389ae92 100644
> --- a/fs/xfs/libxfs/xfs_sb.c
> +++ b/fs/xfs/libxfs/xfs_sb.c
> @@ -124,6 +124,9 @@ xfs_sb_version_to_features(
>  		features |= XFS_FEAT_BIGTIME;
>  	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR)
>  		features |= XFS_FEAT_NEEDSREPAIR;
> +	if (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_NREXT64)
> +		features |= XFS_FEAT_NREXT64;
> +
>  	return features;
>  }
>  
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 00720a02e761..10941481f7e6 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -276,6 +276,7 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_INOBTCNT	(1ULL << 23)	/* inobt block counts */
>  #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
>  #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
> +#define XFS_FEAT_NREXT64	(1ULL << 26)	/* 64-bit inode extent counters */
>  
>  /* Mount features */
>  #define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
> @@ -338,6 +339,7 @@ __XFS_HAS_FEAT(realtime, REALTIME)
>  __XFS_HAS_FEAT(inobtcounts, INOBTCNT)
>  __XFS_HAS_FEAT(bigtime, BIGTIME)
>  __XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)
> +__XFS_HAS_FEAT(nrext64, NREXT64)
>  
>  /*
>   * Mount features
> -- 
> 2.30.2
> 
