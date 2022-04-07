Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67D8C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  7 Apr 2022 01:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236240AbiDGBfJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Apr 2022 21:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240366AbiDGBaA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Apr 2022 21:30:00 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3AA61A5D63
        for <linux-xfs@vger.kernel.org>; Wed,  6 Apr 2022 18:22:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5A02C10E57A1;
        Thu,  7 Apr 2022 11:22:26 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ncGqv-00EfKm-8L; Thu, 07 Apr 2022 11:22:25 +1000
Date:   Thu, 7 Apr 2022 11:22:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V9 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
Message-ID: <20220407012225.GF1544202@dread.disaster.area>
References: <20220406061904.595597-1-chandan.babu@oracle.com>
 <20220406061904.595597-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406061904.595597-17-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=624e3cd2
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=sRn_VnjLVPXUQlATQWYA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 06, 2022 at 11:49:00AM +0530, Chandan Babu R wrote:
> This commit enables upgrading existing inodes to use large extent counters
> provided that underlying filesystem's superblock has large extent counter
> feature enabled.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       | 10 ++++++++++
>  fs/xfs/libxfs/xfs_bmap.c       |  6 ++++--
>  fs/xfs/libxfs/xfs_format.h     |  8 ++++++++
>  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_bmap_item.c         |  2 ++
>  fs/xfs/xfs_bmap_util.c         | 13 +++++++++++++
>  fs/xfs/xfs_dquot.c             |  3 +++
>  fs/xfs/xfs_iomap.c             |  5 +++++
>  fs/xfs/xfs_reflink.c           |  5 +++++
>  fs/xfs/xfs_rtalloc.c           |  3 +++
>  11 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 23523b802539..66c4fc55c9d7 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -776,8 +776,18 @@ xfs_attr_set(
>  	if (args->value || xfs_inode_hasattr(dp)) {
>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +		if (error == -EFBIG)
> +			error = xfs_iext_count_upgrade(args->trans, dp,
> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
>  		if (error)
>  			goto out_trans_cancel;
> +
> +		if (error == -EFBIG) {
> +			error = xfs_iext_count_upgrade(args->trans, dp,
> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +			if (error)
> +				goto out_trans_cancel;
> +		}
>  	}

Did you forgot to remove the original xfs_iext_count_upgrade() call?

> diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> index 43de892d0305..bb327ea43ca1 100644
> --- a/fs/xfs/libxfs/xfs_format.h
> +++ b/fs/xfs/libxfs/xfs_format.h
> @@ -934,6 +934,14 @@ enum xfs_dinode_fmt {
>  #define XFS_MAX_EXTCNT_DATA_FORK_SMALL	((xfs_extnum_t)((1ULL << 31) - 1))
>  #define XFS_MAX_EXTCNT_ATTR_FORK_SMALL	((xfs_extnum_t)((1ULL << 15) - 1))
>  
> +/*
> + * This macro represents the maximum value by which a filesystem operation can
> + * increase the value of an inode's data/attr fork extent count.
> + */
> +#define XFS_MAX_EXTCNT_UPGRADE_NR	\
> +	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
> +	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)

You don't need to write "This macro represents" in a comment above
the macro that that the comment is describing. If you need to refer
to the actual macro, use it's name directly.

As it is, the comment could be improved:

/*
 * When we upgrade an inode to the large extent counts, the maximum
 * value by which the extent count can increase is bound by the
 * change in size of the on-disk field. No upgrade operation should
 * ever be adding more than a few tens of, so if we get a really
 * large value it is a sign of a code bug or corruption.
 */
#define XFS_MAX_EXTCNT_UPGRADE_NR	\
	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL,	\
	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)

Otherwise it looks OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
