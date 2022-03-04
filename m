Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92D89C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 01:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbiCDB6T (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiCDB6O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 20:58:14 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B082817CC5E
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 17:57:24 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 4289C10E1527;
        Fri,  4 Mar 2022 12:57:23 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPxC6-001FIy-96; Fri, 04 Mar 2022 12:57:22 +1100
Date:   Fri, 4 Mar 2022 12:57:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 07/17] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and
 associated per-fs feature bit
Message-ID: <20220304015722.GD59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-8-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-8-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62217203
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=MHNsT_NJw_jZ9TKhzeUA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:28PM +0530, Chandan Babu R wrote:
> XFS_SB_FEAT_INCOMPAT_NREXT64 incompat feature bit will be set on filesystems
> which support large per-inode extent counters. This commit defines the new
> incompat feature bit and the corresponding per-fs feature bit (along with
> inline functions to work on it).
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
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

Not a big fan of "nrext64" naming.

I'd really like the feature macro to be human readable such as:

__XFS_HAS_FEAT(large_extent_counts, NREXT64)

So that it reads like this:

	if (xfs_has_large_extent_counts(mp)) {
		.....
	}

because then the code is much easier to read and is largely self
documenting. In this case, I don't really care about the flag names
(they can remain NREXT64) because they are only seen deep down in
the code.  But for (potentially complex) conditional logic, the
clarity of human readable names makes a big difference.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
