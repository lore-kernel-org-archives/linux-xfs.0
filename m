Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF233C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:03:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE0176108B
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Oct 2021 23:03:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhJNXFl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Oct 2021 19:05:41 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:57072 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230503AbhJNXFk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Oct 2021 19:05:40 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 79B66106BA78;
        Fri, 15 Oct 2021 10:03:34 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mb9l7-006Jay-U3; Fri, 15 Oct 2021 10:03:33 +1100
Date:   Fri, 15 Oct 2021 10:03:33 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 14/17] xfs: compute the maximum height of the rmap btree
 when reflink enabled
Message-ID: <20211014230333.GT2361455@dread.disaster.area>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424269189.756780.15045314476103501683.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163424269189.756780.15045314476103501683.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6168b746
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=l8IGwGuVVEMWRS38W_EA:9
        a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 14, 2021 at 01:18:11PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Instead of assuming that the hardcoded XFS_BTREE_MAXLEVELS value is big
> enough to handle the maximally tall rmap btree when all blocks are in
> use and maximally shared, let's compute the maximum height assuming the
> rmapbt consumes as many blocks as possible.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_btree.c       |   33 +++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_btree.h       |    2 ++
>  fs/xfs/libxfs/xfs_rmap_btree.c  |   45 +++++++++++++++++++++++----------------
>  fs/xfs/libxfs/xfs_trans_resv.c  |   16 ++++++++++++++
>  fs/xfs/libxfs/xfs_trans_space.h |    7 ++++++
>  5 files changed, 85 insertions(+), 18 deletions(-)

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

>  /* Calculate the refcount btree size for some records. */
> diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
> index c879e7754ee6..6f83d9b306ee 100644
> --- a/fs/xfs/libxfs/xfs_trans_resv.c
> +++ b/fs/xfs/libxfs/xfs_trans_resv.c
> @@ -814,6 +814,19 @@ xfs_trans_resv_calc(
>  	struct xfs_mount	*mp,
>  	struct xfs_trans_resv	*resp)
>  {
> +	unsigned int		rmap_maxlevels = mp->m_rmap_maxlevels;
> +
> +	/*
> +	 * In the early days of rmap+reflink, we always set the rmap maxlevels
> +	 * to 9 even if the AG was small enough that it would never grow to
> +	 * that height.  Transaction reservation sizes influence the minimum
> +	 * log size calculation, which influences the size of the log that mkfs
> +	 * creates.  Use the old value here to ensure that newly formatted
> +	 * small filesystems will mount on older kernels.
> +	 */
> +	if (xfs_has_rmapbt(mp) && xfs_has_reflink(mp))
> +		mp->m_rmap_maxlevels = XFS_OLD_REFLINK_RMAP_MAXLEVELS;
> +

As an aside, what are your plans to get your "legacy minimum log
size reservations" calculation patch moved upstream so we can stop
having to care about this in future?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
