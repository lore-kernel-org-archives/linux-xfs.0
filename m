Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A672C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B41960FDC
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Oct 2021 05:49:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhJMFvp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Oct 2021 01:51:45 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:46018 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232366AbhJMFvo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Oct 2021 01:51:44 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id AAC51861A51;
        Wed, 13 Oct 2021 16:49:40 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1maX91-005ezA-JY; Wed, 13 Oct 2021 16:49:39 +1100
Date:   Wed, 13 Oct 2021 16:49:39 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 10/15] xfs: compute actual maximum btree height for
 critical reservation calculation
Message-ID: <20211013054939.GC2361455@dread.disaster.area>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408160882.4151249.14701173486144926020.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163408160882.4151249.14701173486144926020.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=61667374
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=8gfv0ekSlNoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=07X43_9vRTjvD5sruDgA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 12, 2021 at 04:33:28PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Compute the actual maximum btree height when deciding if per-AG block
> reservation is critically low.  This only affects the sanity check
> condition, since we /generally/ will trigger on the 10% threshold.
> This is a long-winded way of saying that we're removing one more
> usage of XFS_BTREE_MAXLEVELS.

And replacing it with a branchy dynamic calculation that has a
static, unchanging result. :(

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag_resv.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag_resv.c b/fs/xfs/libxfs/xfs_ag_resv.c
> index 2aa2b3484c28..d34d4614f175 100644
> --- a/fs/xfs/libxfs/xfs_ag_resv.c
> +++ b/fs/xfs/libxfs/xfs_ag_resv.c
> @@ -60,6 +60,20 @@
>   * to use the reservation system should update ask/used in xfs_ag_resv_init.
>   */
>  
> +/* Compute maximum possible height for per-AG btree types for this fs. */
> +static unsigned int
> +xfs_ag_btree_maxlevels(
> +	struct xfs_mount	*mp)
> +{
> +	unsigned int		ret = mp->m_ag_maxlevels;
> +
> +	ret = max(ret, mp->m_bm_maxlevels[XFS_DATA_FORK]);
> +	ret = max(ret, mp->m_bm_maxlevels[XFS_ATTR_FORK]);
> +	ret = max(ret, M_IGEO(mp)->inobt_maxlevels);
> +	ret = max(ret, mp->m_rmap_maxlevels);
> +	return max(ret, mp->m_refc_maxlevels);
> +}

Hmmmm. perhaps mp->m_ag_maxlevels should be renamed to
mp->m_agbno_maxlevels and we pre-calculate mp->m_ag_maxlevels from
the above function and just use the variable in the
xfs_ag_resv_critical() check?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
