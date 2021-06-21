Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 022A2C4743C
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:17:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CCA6861164
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Jun 2021 23:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhFUXTg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Jun 2021 19:19:36 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:38526 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230130AbhFUXTg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Jun 2021 19:19:36 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 75CE51B12B3;
        Tue, 22 Jun 2021 09:17:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lvTAN-00FUTW-Du; Tue, 22 Jun 2021 09:17:19 +1000
Date:   Tue, 22 Jun 2021 09:17:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix endianness issue in xfs_ag_shrink_space
Message-ID: <20210621231719.GX664593@dread.disaster.area>
References: <20210621223436.GF3619569@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621223436.GF3619569@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=H_pVOhNOFlLZ4-ih4J0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 21, 2021 at 03:34:36PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The AGI buffer is in big-endian format, so we must convert the
> endianness to CPU format to do any comparisons.
> 
> Fixes: 46141dc891f7 ("xfs: introduce xfs_ag_shrink_space()")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c |    7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index c68a36688474..afff2ab7e9f1 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -510,6 +510,7 @@ xfs_ag_shrink_space(
>  	struct xfs_buf		*agibp, *agfbp;
>  	struct xfs_agi		*agi;
>  	struct xfs_agf		*agf;
> +	xfs_agblock_t		aglen;
>  	int			error, err2;
>  
>  	ASSERT(agno == mp->m_sb.sb_agcount - 1);
> @@ -524,14 +525,14 @@ xfs_ag_shrink_space(
>  		return error;
>  
>  	agf = agfbp->b_addr;
> +	aglen = be32_to_cpu(agi->agi_length);
>  	/* some extra paranoid checks before we shrink the ag */
>  	if (XFS_IS_CORRUPT(mp, agf->agf_length != agi->agi_length))
>  		return -EFSCORRUPTED;
> -	if (delta >= agi->agi_length)
> +	if (delta >= aglen)
>  		return -EINVAL;
>  
> -	args.fsbno = XFS_AGB_TO_FSB(mp, agno,
> -				    be32_to_cpu(agi->agi_length) - delta);
> +	args.fsbno = XFS_AGB_TO_FSB(mp, agno, aglen - delta);

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

FWIW, my plan for this stuff is to move the perag geometry stuff
into the xfs_perag. That gets rid of all this "need the on disk
buffer to get AG size" stuff. It also avoids having to calculate
valid ranges of types on every verify call (expensive) because, at
most per-ag type verifier call sites, we already have the perag on
hand...

Cheers,
-- 
Dave Chinner
david@fromorbit.com
