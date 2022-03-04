Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EBF7C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 01:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiCDBal (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiCDBal (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 20:30:41 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 994217E5BB
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 17:29:54 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 45F6D10E1610;
        Fri,  4 Mar 2022 12:29:53 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPwlU-001EqD-Fa; Fri, 04 Mar 2022 12:29:52 +1100
Date:   Fri, 4 Mar 2022 12:29:52 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V7 06/17] xfs: Promote xfs_extnum_t and xfs_aextnum_t to
 64 and 32-bits respectively
Message-ID: <20220304012952.GZ59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-7-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-7-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62216b91
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=ssDC1eHdflC7AiTqyBEA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:27PM +0530, Chandan Babu R wrote:
> A future commit will introduce a 64-bit on-disk data extent counter and a
> 32-bit on-disk attr extent counter. This commit promotes xfs_extnum_t and
> xfs_aextnum_t to 64 and 32-bits in order to correctly handle in-core versions
> of these quantities.
> 
> Reported-by: kernel test robot <lkp@intel.com>

What was reported by the test robot? This change isn't a bug that
needed fixing, it's a core part of the patchset...

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 6 +++---
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.h | 2 +-
>  fs/xfs/libxfs/xfs_types.h      | 4 ++--
>  fs/xfs/xfs_inode.c             | 4 ++--
>  fs/xfs/xfs_trace.h             | 2 +-
>  6 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 98541be873d8..9df98339a43a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */

Unnecessary.

> @@ -83,7 +83,7 @@ xfs_bmap_compute_maxlevels(
>  	maxrootrecs = xfs_bmdr_maxrecs(sz, 0);
>  	minleafrecs = mp->m_bmap_dmnr[0];
>  	minnoderecs = mp->m_bmap_dmnr[1];
> -	maxblocks = (maxleafents + minleafrecs - 1) / minleafrecs;
> +	maxblocks = howmany_64(maxleafents, minleafrecs);
>  	for (level = 1; maxblocks > 1; level++) {
>  		if (maxblocks <= maxrootrecs)
>  			maxblocks = 1;
> @@ -467,7 +467,7 @@ xfs_bmap_check_leaf_extents(
>  	if (bp_release)
>  		xfs_trans_brelse(NULL, bp);
>  error_norelse:
> -	xfs_warn(mp, "%s: BAD after btree leaves for %d extents",
> +	xfs_warn(mp, "%s: BAD after btree leaves for %llu extents",
>  		__func__, i);
>  	xfs_err(mp, "%s: CORRUPTED BTREE OR SOMETHING", __func__);
>  	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 829739e249b6..ce690abe5dce 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -117,7 +117,7 @@ xfs_iformat_extents(
>  	 * we just bail out rather than crash in kmem_alloc() or memcpy() below.
>  	 */
>  	if (unlikely(size < 0 || size > XFS_DFORK_SIZE(dip, mp, whichfork))) {
> -		xfs_warn(ip->i_mount, "corrupt inode %Lu ((a)extents = %d).",
> +		xfs_warn(ip->i_mount, "corrupt inode %llu ((a)extents = %llu).",
>  			(unsigned long long) ip->i_ino, nex);

Isn't ip->i_ino explicitly defined as an unsigned long long? If you are going
to fix one part of the printk formatting for ip->i_ino, you should
probably should get rid of the unnecessary cast, too.

Otherwise looks OK.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
