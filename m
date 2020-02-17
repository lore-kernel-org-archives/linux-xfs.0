Return-Path: <SRS0=xOwi=4F=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F0C34022
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E79EF20801
	for <linux-xfs@archiver.kernel.org>; Mon, 17 Feb 2020 23:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgBQXGM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 17 Feb 2020 18:06:12 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41747 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725922AbgBQXGM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 18:06:12 -0500
Received: from dread.disaster.area (pa49-179-138-28.pa.nsw.optusnet.com.au [49.179.138.28])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 40E5E7E9BF8;
        Tue, 18 Feb 2020 10:06:10 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j3pSq-0003lP-Vv; Tue, 18 Feb 2020 10:06:08 +1100
Date:   Tue, 18 Feb 2020 10:06:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 13/31] xfs: remove the xfs_inode argument to
 xfs_attr_get_ilocked
Message-ID: <20200217230608.GN10776@dread.disaster.area>
References: <20200217125957.263434-1-hch@lst.de>
 <20200217125957.263434-14-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217125957.263434-14-hch@lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=zAxSp4fFY/GQY8/esVNjqw==:117 a=zAxSp4fFY/GQY8/esVNjqw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=JN481nXcWmN7Hznr6AAA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Feb 17, 2020 at 01:59:39PM +0100, Christoph Hellwig wrote:
> The inode can easily be derived from the args structure.  Also
> don't bother with else statements after early returns.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 15 +++++++--------
>  fs/xfs/libxfs/xfs_attr.h |  2 +-
>  fs/xfs/scrub/attr.c      |  2 +-
>  3 files changed, 9 insertions(+), 10 deletions(-)

Looks ok, but....
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 288b39e81efd..fd095e3d4a9a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -77,19 +77,18 @@ xfs_inode_hasattr(
>   */
>  int
>  xfs_attr_get_ilocked(
> -	struct xfs_inode	*ip,
>  	struct xfs_da_args	*args)
>  {
> -	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
> +	ASSERT(xfs_isilocked(args->dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
>  
> -	if (!xfs_inode_hasattr(ip))
> +	if (!xfs_inode_hasattr(args->dp))
>  		return -ENOATTR;
> -	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
> +
> +	if (args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
>  		return xfs_attr_shortform_getvalue(args);
> -	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
>  		return xfs_attr_leaf_get(args);
> -	else
> -		return xfs_attr_node_get(args);
> +	return xfs_attr_node_get(args);
>  }
>  
>  /*
> @@ -133,7 +132,7 @@ xfs_attr_get(
>  		args->op_flags |= XFS_DA_OP_ALLOCVAL;
>  
>  	lock_mode = xfs_ilock_attr_map_shared(args->dp);
> -	error = xfs_attr_get_ilocked(args->dp, args);
> +	error = xfs_attr_get_ilocked(args);
>  	xfs_iunlock(args->dp, lock_mode);

... at this point I really would like to see the "args->dp" pointer
get renamed. "dp" was originally short for "directory inode
pointer", but it's clear that it hasn't meant that for a long time.
It's just an inode pointer.

That's out of scope for this patch set, though, so maybe the next
cleanup patchset?

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
