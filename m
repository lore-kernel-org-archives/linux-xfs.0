Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A104C43334
	for <linux-xfs@archiver.kernel.org>; Fri,  1 Jul 2022 01:08:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiGABIw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 30 Jun 2022 21:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiGABIw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 21:08:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCADC599E6
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 18:08:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 7F0D510E7999;
        Fri,  1 Jul 2022 11:08:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o759N-00D4m7-Bt; Fri, 01 Jul 2022 11:08:49 +1000
Date:   Fri, 1 Jul 2022 11:08:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 2/6] xfs_repair: clear DIFLAG2_NREXT64 when filesystem
 doesn't support nrext64
Message-ID: <20220701010849.GD227878@dread.disaster.area>
References: <165644935451.1089996.13716062701488693755.stgit@magnolia>
 <165644936573.1089996.11135224585697421312.stgit@magnolia>
 <Yr470cSmZ2+gvSdz@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr470cSmZ2+gvSdz@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62be4923
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=PIWlSXfoMe-Zfz66HQAA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 30, 2022 at 05:12:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Clear the nrext64 inode flag if the filesystem doesn't have the nrext64
> feature enabled in the superblock.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: remove unnecessary clearing of extent counters, we reset them anyway
> ---
>  repair/dinode.c |   13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/repair/dinode.c b/repair/dinode.c
> index 00de31fb..7610cd45 100644
> --- a/repair/dinode.c
> +++ b/repair/dinode.c
> @@ -2690,6 +2690,19 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
>  			}
>  		}
>  
> +		if (xfs_dinode_has_large_extent_counts(dino) &&
> +		    !xfs_has_large_extent_counts(mp)) {
> +			if (!uncertain) {
> +				do_warn(
> +	_("inode %" PRIu64 " is marked large extent counts but file system does not support large extent counts\n"),
> +					lino);
> +			}
> +			flags2 &= ~XFS_DIFLAG2_NREXT64;
> +
> +			if (!no_modify)
> +				*dirty = 1;
> +		}
> +
>  		if (!verify_mode && flags2 != be64_to_cpu(dino->di_flags2)) {
>  			if (!no_modify) {
>  				do_warn(_("fixing bad flags2.\n"));
> 

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
