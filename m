Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B788C43219
	for <linux-xfs@archiver.kernel.org>; Thu, 13 Oct 2022 22:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiJMWcy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 13 Oct 2022 18:32:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiJMWcw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 18:32:52 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CF46D18DAA3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Oct 2022 15:32:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au [49.181.106.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 123CF1101955;
        Fri, 14 Oct 2022 09:32:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oj6kx-001eST-WD; Fri, 14 Oct 2022 09:32:48 +1100
Date:   Fri, 14 Oct 2022 09:32:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: don't track the AGFL buffer in the scrub AG
 context
Message-ID: <20221013223247.GZ3600936@dread.disaster.area>
References: <166473478844.1083155.9238102682926048449.stgit@magnolia>
 <166473478879.1083155.7048621417340358108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473478879.1083155.7048621417340358108.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=63489211
        a=j6JUzzrSC7wlfFge/rmVbg==:117 a=j6JUzzrSC7wlfFge/rmVbg==:17
        a=kj9zAlcOel0A:10 a=Qawa6l4ZSaYA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=wpKp6sT172n5eCWdWcQA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:19:48AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While scrubbing an allocation group, we don't need to hold the AGFL
> buffer as part of the scrub context.  All that is necessary to lock an
> AG is to hold the AGI and AGF buffers, so fix all the existing users of
> the AGFL buffer to grab them only when necessary.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/agheader.c        |   47 +++++++++++++++++++++++++---------------
>  fs/xfs/scrub/agheader_repair.c |    1 -
>  fs/xfs/scrub/common.c          |    8 -------
>  fs/xfs/scrub/repair.c          |   11 +++++----
>  fs/xfs/scrub/scrub.h           |    1 -
>  5 files changed, 35 insertions(+), 33 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

> @@ -717,24 +731,21 @@ xchk_agfl(
>  
>  	/* Allocate buffer to ensure uniqueness of AGFL entries. */
>  	agf = sc->sa.agf_bp->b_addr;
> -	agflcount = be32_to_cpu(agf->agf_flcount);
> -	if (agflcount > xfs_agfl_size(sc->mp)) {
> +	sai.agflcount = be32_to_cpu(agf->agf_flcount);
> +	if (sai.agflcount > xfs_agfl_size(sc->mp)) {
>  		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
>  		goto out;
>  	}
> -	memset(&sai, 0, sizeof(sai));
> -	sai.sc = sc;
> -	sai.sz_entries = agflcount;
> -	sai.entries = kmem_zalloc(sizeof(xfs_agblock_t) * agflcount,
> -			KM_MAYFAIL);
> +	sai.entries = kvcalloc(sai.agflcount, sizeof(xfs_agblock_t),
> +			GFP_KERNEL | __GFP_RETRY_MAYFAIL);

The code is fine, but I'm curious why kvcalloc()? Are there really
devices out there with sector sizes large than 4kB that we support?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
