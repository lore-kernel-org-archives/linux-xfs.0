Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2AE4C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 02:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB78E20718
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 02:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAXCA6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 21:00:58 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45899 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730158AbgAXCA6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 21:00:58 -0500
Received: from dread.disaster.area (pa49-195-162-125.pa.nsw.optusnet.com.au [49.195.162.125])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BD09B7E9BC0;
        Fri, 24 Jan 2020 13:00:54 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iuoHG-0000WF-2Y; Fri, 24 Jan 2020 13:00:54 +1100
Date:   Fri, 24 Jan 2020 13:00:54 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 10/12] xfs: make xfs_*read_agf return EAGAIN to
 ALLOC_FLAG_TRYLOCK callers
Message-ID: <20200124020054.GK7090@dread.disaster.area>
References: <157976531016.2388944.3654360225810285604.stgit@magnolia>
 <157976537480.2388944.15713995061702153624.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157976537480.2388944.15713995061702153624.stgit@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=eqEhQ2W7mF93FbYHClaXRw==:117 a=eqEhQ2W7mF93FbYHClaXRw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=Jdjhy38mL1oA:10
        a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=jlTcdTlnpCs_MG2KHv0A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 22, 2020 at 11:42:54PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_read_agf and xfs_alloc_read_agf to return EAGAIN if the
> caller passed TRYLOCK and we weren't able to get the lock; and change
> the callers to recognize this.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c |   34 +++++++++++++++-------------------
>  fs/xfs/libxfs/xfs_bmap.c  |   11 ++++++-----
>  fs/xfs/xfs_filestream.c   |   11 ++++++-----
>  3 files changed, 27 insertions(+), 29 deletions(-)
.....
> @@ -2992,10 +2987,11 @@ xfs_alloc_read_agf(
>  	error = xfs_read_agf(mp, tp, agno,
>  			(flags & XFS_ALLOC_FLAG_TRYLOCK) ? XBF_TRYLOCK : 0,
>  			bpp);
> -	if (error)
> +	if (error) {
> +		/* We don't support trylock when freeing. */
> +		ASSERT(error != -EAGAIN || !(flags & XFS_ALLOC_FLAG_FREEING));
>  		return error;

Shouldn't we check this with asserts before we call xfs_read_agf()?
i.e.

	/* We don't support trylock when freeing. */
	ASSERT((flags & (XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK)) !=
			(XFS_ALLOC_FLAG_FREEING | XFS_ALLOC_FLAG_TRYLOCK));
	....

> -	if (!*bpp)
> -		return 0;
> +	}
>  	ASSERT(!(*bpp)->b_error);
>  
>  	agf = XFS_BUF_TO_AGF(*bpp);
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index cfcef076c72f..9a6d7a84689a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -3311,11 +3311,12 @@ xfs_bmap_longest_free_extent(
>  	pag = xfs_perag_get(mp, ag);
>  	if (!pag->pagf_init) {
>  		error = xfs_alloc_pagf_init(mp, tp, ag, XFS_ALLOC_FLAG_TRYLOCK);
> -		if (error)
> -			goto out;
> -
> -		if (!pag->pagf_init) {
> -			*notinit = 1;
> +		if (error) {
> +			/* Couldn't lock the AGF, so skip this AG. */
> +			if (error == -EAGAIN) {
> +				*notinit = 1;
> +				error = 0;
> +			}
>  			goto out;
>  		}
>  	}
> diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
> index 5f12b5d8527a..3ccdab463359 100644
> --- a/fs/xfs/xfs_filestream.c
> +++ b/fs/xfs/xfs_filestream.c
> @@ -159,16 +159,17 @@ xfs_filestream_pick_ag(
>  
>  		if (!pag->pagf_init) {
>  			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
> -			if (err && !trylock) {
> +			if (err == -EAGAIN) {
> +				/* Couldn't lock the AGF, skip this AG. */
> +				xfs_perag_put(pag);
> +				continue;
> +			}
> +			if (err) {
>  				xfs_perag_put(pag);
>  				return err;
>  			}

Might neater to do:

		if (!pag->pagf_init) {
			err = xfs_alloc_pagf_init(mp, NULL, ag, trylock);
			if (err) {
				xfs_perag_put(pag);
				if (err != -EAGAIN)
					return err;
				/* Couldn't lock the AGF, skip this AG. */
				continue;
			}
		}

Otherwise it all looks ok.

-Dave
-- 
Dave Chinner
david@fromorbit.com
