Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010CDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 21:37:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354204AbiCXViz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354198AbiCXViy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 17:38:54 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B502AB6E58
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 14:37:21 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C1CA8533EFF;
        Fri, 25 Mar 2022 08:37:20 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXV8x-009Sau-VV; Fri, 25 Mar 2022 08:37:20 +1100
Date:   Fri, 25 Mar 2022 08:37:19 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 08/19] xfs: Introduce XFS_SB_FEAT_INCOMPAT_NREXT64 and
 associated per-fs feature bit
Message-ID: <20220324213719.GG1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-9-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321051750.400056-9-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623ce491
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=GUbOC9SsMdtl6a5Rw88A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 10:47:39AM +0530, Chandan Babu R wrote:
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
> index b5e9256d6d32..64ff0c310696 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -372,6 +372,7 @@ xfs_sb_has_ro_compat_feature(
>  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
>  #define XFS_SB_FEAT_INCOMPAT_BIGTIME	(1 << 3)	/* large timestamps */
>  #define XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR (1 << 4)	/* needs xfs_repair */
> +#define XFS_SB_FEAT_INCOMPAT_NREXT64	(1 << 5)	/* large extent counters */
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

Shouldn't enabling the feature be the last patch in the series, once
all the infrastructure to support the feature is in place? i.e. if
someone does a bisect on a XFS_FEAT_NREXT64 enabled filesystem, they
can land in the middle of this series where the fs tries to use
XFS_FEAT_NREXT64 but the functionality is not complete.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
