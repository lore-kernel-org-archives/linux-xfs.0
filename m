Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B13C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:31:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234628AbiDGBdp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241287AbiDGBay (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:30:54 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 084EA1BBE38
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:23:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 418A953457E;
        Thu,  7 Apr 2022 11:23:48 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncGsF-00EfLU-07; Thu, 07 Apr 2022 11:23:47 +1000
Date:   Thu, 7 Apr 2022 11:23:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9 19/19] xfs: Add XFS_SB_FEAT_INCOMPAT_NREXT64 to the
 list of supported flags
Message-ID: <20220407012346.GG1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-20-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-20-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624e3d24
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=hd0ETXrtVO7WQ9fHu_EA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
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

Thanks for adding this. :)

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
