Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75690C433F5
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Mar 2022 02:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiCDCJx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Mar 2022 21:09:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237627AbiCDCJw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Mar 2022 21:09:52 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 562EF14E967
        for <linux-xfs@vger.kernel.org>; Thu,  3 Mar 2022 18:09:05 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 1A59F10E15A1;
        Fri,  4 Mar 2022 13:09:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nPxNP-001FTL-4s; Fri, 04 Mar 2022 13:09:03 +1100
Date:   Fri, 4 Mar 2022 13:09:03 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH V7 10/17] xfs: Use xfs_rfsblock_t to count maximum blocks
 that can be used by BMBT
Message-ID: <20220304020903.GF59715@dread.disaster.area>
References: <20220301103938.1106808-1-chandan.babu@oracle.com>
 <20220301103938.1106808-11-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301103938.1106808-11-chandan.babu@oracle.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=622174c0
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=58bDc9IKzz-6lAH3:21 a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=QyXUC8HyAAAA:8
        a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=_2Vq0KIdBaHNJLdYnVEA:9
        a=CjuIK1q_8ugA:10 a=1UyW3QdATXJC5VGpHapA:22 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 01, 2022 at 04:09:31PM +0530, Chandan Babu R wrote:
> Reported-by: kernel test robot <lkp@intel.com>

What was reported by the robot? I don't quite see the relevance of
this change to the overall patchset just from the change being made.

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 9df98339a43a..a01d9a9225ae 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -53,8 +53,8 @@ xfs_bmap_compute_maxlevels(
>  	int		whichfork)	/* data or attr fork */
>  {
>  	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> +	xfs_rfsblock_t	maxblocks;	/* max blocks at this level */

typedef uint64_t        xfs_rfsblock_t; /* blockno in filesystem (raw) */

Usage of the type doesn't seem to match it's definition. This
function is calculating a block count, not a block number. If you
must use a xfs type, then:

typedef uint64_t        xfs_filblks_t;  /* number of blocks in a file */

is a better match, but I think this should just use uint64_t because
the count has nothing to do with block addresses or files..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
