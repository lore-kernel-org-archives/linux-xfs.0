Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 223A1C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Mar 2022 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241714AbiCXVoU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Mar 2022 17:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355203AbiCXVoT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Mar 2022 17:44:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF729B6E45
        for <linux-xfs@vger.kernel.org>; Thu, 24 Mar 2022 14:42:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id B09A910E51DB;
        Fri, 25 Mar 2022 08:42:45 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nXVEC-009SeU-LH; Fri, 25 Mar 2022 08:42:44 +1100
Date:   Fri, 25 Mar 2022 08:42:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH V8 11/19] xfs: Use uint64_t to count maximum blocks that
 can be used by BMBT
Message-ID: <20220324214244.GI1544202@dread.disaster.area>
References: <20220321051750.400056-1-chandan.babu@oracle.com>
 <20220321051750.400056-12-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220321051750.400056-12-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=623ce5d6
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=58bDc9IKzz-6lAH3:21 a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=Cwqj2Xwg_Q0cogzIBXwA:9
        a=CjuIK1q_8ugA:10 a=1UyW3QdATXJC5VGpHapA:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 21, 2022 at 10:47:42AM +0530, Chandan Babu R wrote:
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9f38e33d6ce2..b317226fb4ba 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
>  	xfs_mount_t	*mp,		/* file system mount structure */
>  	int		whichfork)	/* data or attr fork */
>  {
> -	int		level;		/* btree level */
> -	uint		maxblocks;	/* max blocks at this level */
> +	uint64_t	maxblocks;	/* max blocks at this level */
>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> +	int		level;		/* btree level */
>  	int		maxrootrecs;	/* max records in root block */
>  	int		minleafrecs;	/* min records in leaf block */
>  	int		minnoderecs;	/* min records in node block */
> @@ -88,7 +88,7 @@ xfs_bmap_compute_maxlevels(
>  		if (maxblocks <= maxrootrecs)
>  			maxblocks = 1;
>  		else
> -			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
> +			maxblocks = howmany_64(maxblocks, minnoderecs);
>  	}
>  	mp->m_bm_maxlevels[whichfork] = level;
>  	ASSERT(mp->m_bm_maxlevels[whichfork] <= xfs_bmbt_maxlevels_ondisk());

Hmmmm. Shouldn't this be rolled up into the earlier patch that
converts a seperate part of this function to use howmany_64()?
That was done in "[PATCH V8 07/19] xfs: Promote xfs_extnum_t and
xfs_aextnum_t to 64 and 32-bits respectively" - it seems to me like
this should definitely be part of the type size extension rather
than a stand-alone change.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
