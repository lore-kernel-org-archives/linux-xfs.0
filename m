Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D212DC433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 00:59:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbiCDBAX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 20:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbiCDBAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 20:00:22 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 354B11533A1
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 16:59:36 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 73B575300F6;
        Fri,  4 Mar 2022 11:59:35 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPwIA-001ELF-Fe; Fri, 04 Mar 2022 11:59:34 +1100
Date:   Fri, 4 Mar 2022 11:59:34 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V7 03/17] xfs: Use xfs_extnum_t instead of basic data
 types
Message-ID: <20220304005934.GY59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-4-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-4-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62216477
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=HL_xtbCECYRVnjyPwl8A:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:24PM +0530, Chandan Babu R wrote:
> xfs_extnum_t is the type to use to declare variables which have values
> obtained from xfs_dinode->di_[a]nextents. This commit replaces basic
> types (e.g. uint32_t) with xfs_extnum_t for such variables.
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       | 2 +-
>  fs/xfs/libxfs/xfs_inode_buf.c  | 2 +-
>  fs/xfs/libxfs/xfs_inode_fork.c | 2 +-
>  fs/xfs/scrub/inode.c           | 2 +-
>  fs/xfs/xfs_trace.h             | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)

Nice little cleanup.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Something to think about for a followup - how do we ensure we catch
this sort type mismatch in future as it could end up with overflow
bugs?

> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 703ab9a84530..98541be873d8 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -54,7 +54,7 @@ xfs_bmap_compute_maxlevels(
>  {
>  	int		level;		/* btree level */
>  	uint		maxblocks;	/* max blocks at this level */
> -	uint		maxleafents;	/* max leaf entries possible */
> +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index e6f9bdc4558f..5c95a5428fc7 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -336,7 +336,7 @@ xfs_dinode_verify_fork(
>  	struct xfs_mount	*mp,
>  	int			whichfork)
>  {
> -	uint32_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);
> +	xfs_extnum_t		di_nextents = XFS_DFORK_NEXTENTS(dip, whichfork);

e.g. should we convert macros like this to static inline functions
so that we get type checking of the returned value?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
