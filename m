Return-Path: <SRS0=uikP=7R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3C9C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:59:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC53B2077D
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Jun 2020 21:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgFDV7Z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 17:59:25 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58868 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726062AbgFDV7Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Jun 2020 17:59:25 -0400
Received: from dread.disaster.area (pa49-180-124-177.pa.nsw.optusnet.com.au [49.180.124.177])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 4A7D86ABC9B;
        Fri,  5 Jun 2020 07:59:20 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jgxtN-0000s0-Ct; Fri, 05 Jun 2020 07:59:17 +1000
Date:   Fri, 5 Jun 2020 07:59:17 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Gao Xiang <hsiangkao@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v2] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Message-ID: <20200604215917.GS2040@dread.disaster.area>
References: <20200602145238.1512-1-hsiangkao@redhat.com>
 <20200603121156.3399-1-hsiangkao@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603121156.3399-1-hsiangkao@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=k3aV/LVJup6ZGWgigO6cSA==:117 a=k3aV/LVJup6ZGWgigO6cSA==:17
        a=kj9zAlcOel0A:10 a=nTHF0DUjJn0A:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=yksqt7v7tRNYJ86jkAMA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 03, 2020 at 08:11:56PM +0800, Gao Xiang wrote:
> In the course of some operations, we look up the perag from
> the mount multiple times to get or change perag information.
> These are often very short pieces of code, so while the
> lookup cost is generally low, the cost of the lookup is far
> higher than the cost of the operation we are doing on the
> perag.
> 
> Since we changed buffers to hold references to the perag
> they are cached in, many modification contexts already hold
> active references to the perag that are held across these
> operations. This is especially true for any operation that
> is serialised by an allocation group header buffer.
> 
> In these cases, we can just use the buffer's reference to
> the perag to avoid needing to do lookups to access the
> perag. This means that many operations don't need to do
> perag lookups at all to access the perag because they've
> already looked up objects that own persistent references
> and hence can use that reference instead.
> 
> Cc: Dave Chinner <dchinner@redhat.com>
> Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
> Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> ---
> changes since v1:
>  - update the commit message suggested by Dave;
>  - fold in all corresponding ASSERTs I made;

Ok, I think we had a small misunderstanding there. I was trying to
say the asserts that were in the first patch were fine, but we
didn't really need any more because the new asserts mostly matched
an existing pattern.

I wasn't suggesting that we do this everywhere:

> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 9d84007a5c65..4b8c7cb87b84 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -563,7 +563,9 @@ xfs_ag_get_geometry(
>  	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
>  	if (error)
>  		goto out_agi;
> -	pag = xfs_perag_get(mp, agno);
> +
> +	pag = agi_bp->b_pag;
> +	ASSERT(pag->pag_agno == agno);

.... because we've already checked this in xfs_ialloc_read_agi() a
few lines of code back up the function.

That's the pattern I was refering to - we tend to check
relationships when they are first brought into a context, then we
don't need to check them again in that context.  Hence the asserts
in xfs_ialloc_read_agi() and xfs_alloc_read_agf() effectively cover
all the places where we pull the pag from those buffers, and so
there's no need to validate the correct perag is attached to the
buffer every time we access it....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
