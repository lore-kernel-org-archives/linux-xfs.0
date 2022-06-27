Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AACC43334
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jun 2022 01:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiF0Bhe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 21:37:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiF0Bhd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 21:37:33 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 357EF2AF1
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 18:37:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 745F310E783B;
        Mon, 27 Jun 2022 11:37:32 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o5dgx-00BUy9-71; Mon, 27 Jun 2022 11:37:31 +1000
Date:   Mon, 27 Jun 2022 11:37:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 3/3] xfs: dont treat rt extents beyond EOF as eofblocks
 to be cleared
Message-ID: <20220627013731.GB227878@dread.disaster.area>
References: <165628102728.4040423.16023948770805941408.stgit@magnolia>
 <165628104422.4040423.6482533913763183686.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165628104422.4040423.6482533913763183686.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62b909dc
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=BHhn6S3YTmKYF10LwYoA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 26, 2022 at 03:04:04PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> On a system with a realtime volume and a 28k realtime extent,
> generic/491 fails because the test opens a file on a frozen filesystem
> and closing it causes xfs_release -> xfs_can_free_eofblocks to
> mistakenly think that the the blocks of the realtime extent beyond EOF
> are posteof blocks to be freed.  Realtime extents cannot be partially
> unmapped, so this is pointless.  Worse yet, this triggers posteof
> cleanup, which stalls on a transaction allocation, which is why the test
> fails.
> 
> Teach the predicate to account for realtime extents properly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_bmap_util.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 52be58372c63..85e1a26c92e8 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -686,6 +686,8 @@ xfs_can_free_eofblocks(
>  	 * forever.
>  	 */
>  	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)XFS_ISIZE(ip));
> +	if (XFS_IS_REALTIME_INODE(ip) && mp->m_sb.sb_rextsize > 1)
> +		end_fsb = roundup_64(end_fsb, mp->m_sb.sb_rextsize);
>  	last_fsb = XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes);
>  	if (last_fsb <= end_fsb)
>  		return false;

Ok, that works.

However, I was looking at xfs_can_free_eofblocks() w.r.t. freeze a
couple of days ago and wondering why there isn't a freeze/RO state
check in xfs_can_free_eofblocks(). Shouldn't we have one here so
that we never try to run xfs_free_eofblocks() on RO/frozen
filesystems regardless of unexpected state/alignment issues?

Cheers,

Dave.


-- 
Dave Chinner
david@fromorbit.com
