Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6458DC433FE
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 05:10:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJNFKM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 01:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiJNFKL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 01:10:11 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C7A2B3FEED
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 22:10:10 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C58DC8AD994;
        Fri, 14 Oct 2022 16:10:09 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ojCxU-001lAq-FB; Fri, 14 Oct 2022 16:10:08 +1100
Date:   Fri, 14 Oct 2022 16:10:08 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: check quota files for unwritten extents
Message-ID: <20221014051008.GS3600936@dread.disaster.area>
References: <166473480864.1083927.11062319917293302327.stgit@magnolia>
 <166473480929.1083927.16868038391470181366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473480929.1083927.16868038391470181366.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=6348ef32
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=hidGBXtOwuC2-TEjnHkA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:09AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Teach scrub to flag quota files containing unwritten extents.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/quota.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
> index d15682e2f2a3..7b21e1012eff 100644
> --- a/fs/xfs/scrub/quota.c
> +++ b/fs/xfs/scrub/quota.c
> @@ -14,6 +14,7 @@
>  #include "xfs_inode.h"
>  #include "xfs_quota.h"
>  #include "xfs_qm.h"
> +#include "xfs_bmap.h"
>  #include "scrub/scrub.h"
>  #include "scrub/common.h"
>  
> @@ -192,11 +193,12 @@ xchk_quota_data_fork(
>  	for_each_xfs_iext(ifp, &icur, &irec) {
>  		if (xchk_should_terminate(sc, &error))
>  			break;
> +
>  		/*
> -		 * delalloc extents or blocks mapped above the highest
> +		 * delalloc/unwritten extents or blocks mapped above the highest
>  		 * quota id shouldn't happen.
>  		 */
> -		if (isnullstartblock(irec.br_startblock) ||
> +		if (!xfs_bmap_is_written_extent(&irec) ||
>  		    irec.br_startoff > max_dqid_off ||
>  		    irec.br_startoff + irec.br_blockcount - 1 > max_dqid_off) {
>  			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK,
> 

Looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
