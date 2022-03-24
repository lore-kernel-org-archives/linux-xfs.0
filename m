Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C92DC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 22:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355369AbiCXW3q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 18:29:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355364AbiCXW3o (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 18:29:44 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB70511158
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 15:28:11 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DE42E10E522C;
        Fri, 25 Mar 2022 09:28:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXVw9-009TWq-Q1; Fri, 25 Mar 2022 09:28:09 +1100
Date:   Fri, 25 Mar 2022 09:28:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 16/19] xfs: Conditionally upgrade existing inodes to
 use large extent counters
Message-ID: <20220324222809.GM1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-17-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321051750.400056-17-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=623cf07b
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8
        a=GN4HbevCwQPIViT8a2UA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 10:47:47AM +0530, Chandan Babu R wrote:
> This commit enables upgrading existing inodes to use large extent counters
> provided that underlying filesystem's superblock has large extent counter
> feature enabled.
> 
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c       |  9 ++++++-
>  fs/xfs/libxfs/xfs_bmap.c       | 10 ++++++--
>  fs/xfs/libxfs/xfs_inode_fork.c | 27 +++++++++++++++++++++
>  fs/xfs/libxfs/xfs_inode_fork.h |  2 ++
>  fs/xfs/xfs_bmap_item.c         |  8 ++++++-
>  fs/xfs/xfs_bmap_util.c         | 43 ++++++++++++++++++++++++++++++----
>  fs/xfs/xfs_dquot.c             |  9 ++++++-
>  fs/xfs/xfs_iomap.c             | 17 ++++++++++++--
>  fs/xfs/xfs_reflink.c           | 17 ++++++++++++--
>  fs/xfs/xfs_rtalloc.c           |  9 ++++++-
>  10 files changed, 136 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 23523b802539..6e56aa17fd82 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -776,8 +776,15 @@ xfs_attr_set(
>  	if (args->value || xfs_inode_hasattr(dp)) {
>  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
>  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> -		if (error)
> +		if (error && error != -EFBIG)
>  			goto out_trans_cancel;
> +
> +		if (error == -EFBIG) {
> +			error = xfs_iext_count_upgrade(args->trans, dp,
> +					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> +			if (error)
> +				goto out_trans_cancel;
> +		}

Neater and more compact to do this by checking explicitly for
-EFBIG:

		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
		if (error == -EFBIG)
			error = xfs_iext_count_upgrade(args->trans, dp,
					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
		if (error)
			goto out_trans_cancel;
	}
>  
>  	error = xfs_attr_lookup(args);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 5a089674c666..0cb915bf8285 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4524,13 +4524,19 @@ xfs_bmapi_convert_delalloc(
>  		return error;
>  
>  	xfs_ilock(ip, XFS_ILOCK_EXCL);
> +	xfs_trans_ijoin(tp, ip, 0);
>  
>  	error = xfs_iext_count_may_overflow(ip, whichfork,
>  			XFS_IEXT_ADD_NOSPLIT_CNT);
> -	if (error)
> +	if (error && error != -EFBIG)
>  		goto out_trans_cancel;
>  
> -	xfs_trans_ijoin(tp, ip, 0);
> +	if (error == -EFBIG) {
> +		error = xfs_iext_count_upgrade(tp, ip,
> +				XFS_IEXT_ADD_NOSPLIT_CNT);
> +		if (error)
> +			goto out_trans_cancel;
> +	}
>  
>  	if (!xfs_iext_lookup_extent(ip, ifp, offset_fsb, &bma.icur, &bma.got) ||
>  	    bma.got.br_startoff > offset_fsb) {
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index bb5d841aac58..aff9242db829 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -756,3 +756,30 @@ xfs_iext_count_may_overflow(
>  
>  	return 0;
>  }
> +
> +int
> +xfs_iext_count_upgrade(
> +	struct xfs_trans	*tp,
> +	struct xfs_inode	*ip,
> +	int			nr_to_add)

nr_to_add can only be positive, so should be unsigned.

> +{
> +	if (!xfs_has_large_extent_counts(ip->i_mount) ||
> +	    (ip->i_diflags2 & XFS_DIFLAG2_NREXT64) ||
> +	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
> +		return -EFBIG;
> +
> +	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
> +	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
> +
> +	/*
> +	 * The value of nr_to_add cannot be larger than 2^17
> +	 *
> +	 * - XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL
> +	 *   i.e. 2^32 - 2^15
> +	 * - XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL
> +	 *   i.e. 2^48 - 2^31
> +	 */
> +	ASSERT(nr_to_add <= (1 << 17));

That's a comment for the function head and/or the format
documentation in xfs_format.h, not hidden in the code itself as a
magic number. i.e. it is a format definition because it is bound by
on-disk format constants, not by code constratints. Hence this
should probably be defined in xfs_format.h alongside the large/small
extent counts, such as:

#define XFS_MAX_EXTCNT_UPGRADE_NR	\
	min(XFS_MAX_EXTCNT_ATTR_FORK_LARGE - XFS_MAX_EXTCNT_ATTR_FORK_SMALL, \
	    XFS_MAX_EXTCNT_DATA_FORK_LARGE - XFS_MAX_EXTCNT_DATA_FORK_SMALL)

And the ASSERT checking the incoming nr_to_add placed right at the
top of the function because the assert then documents API
constraints and always catches violations of them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
