Return-Path: <SRS0=EbdE=C2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A4A8C43461
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:19:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E10F20707
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Sep 2020 08:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgIQITo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:19:44 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49583 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726171AbgIQITn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 04:19:43 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 42A69826A87;
        Thu, 17 Sep 2020 18:19:41 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kIp8m-0001z5-EN; Thu, 17 Sep 2020 18:19:40 +1000
Date:   Thu, 17 Sep 2020 18:19:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] xfs: clean up xfs_bui_item_recover
 iget/trans_alloc/ilock ordering
Message-ID: <20200917081940.GL12131@dread.disaster.area>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337657.3624582.4680281255744277782.stgit@magnolia>
 <20200917070802.GW7955@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917070802.GW7955@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=KcmsTjQD c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Zg5_l0vOYAU0EKD2UZcA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 12:08:02AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In most places in XFS, we have a specific order in which we gather
> resources: grab the inode, allocate a transaction, then lock the inode.
> xfs_bui_item_recover doesn't do it in that order, so fix it to be more
> consistent.  This also makes the error bailout code a bit less weird.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: fix the error-out paths to free the BUI if the BUD hasn't been
> created
> ---
>  fs/xfs/xfs_bmap_item.c |   49 +++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 4e5aa29f75b7..f088cfd495bd 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -432,7 +432,7 @@ xfs_bui_item_recover(
>  	struct xfs_inode		*ip = NULL;
>  	struct xfs_mount		*mp = lip->li_mountp;
>  	struct xfs_map_extent		*bmap;
> -	struct xfs_bud_log_item		*budp;
> +	struct xfs_bud_log_item		*budp = NULL;
>  	xfs_fsblock_t			startblock_fsb;
>  	xfs_fsblock_t			inode_fsb;
>  	xfs_filblks_t			count;
> @@ -475,27 +475,26 @@ xfs_bui_item_recover(
>  	    (bmap->me_flags & ~XFS_BMAP_EXTENT_FLAGS))
>  		goto garbage;
>  
> -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> -			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> -	if (error) {
> -		xfs_bui_release(buip);
> -		return error;
> -	}
> -
> -	budp = xfs_trans_get_bud(tp, buip);
> -
>  	/* Grab the inode. */
> -	error = xfs_iget(mp, tp, bmap->me_owner, 0, XFS_ILOCK_EXCL, &ip);
> +	error = xfs_iget(mp, NULL, bmap->me_owner, 0, 0, &ip);
>  	if (error)
> -		goto err_inode;
> +		goto err_bui;

err_bui could be combined with the garbage error return if error is
initialised to -EFSCORRUPTED.

Otherwise it looks OK.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
