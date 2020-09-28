Return-Path: <SRS0=Pbt4=DF=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B427C2D0A8
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 05:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23DAF22574
	for <linux-xfs@archiver.kernel.org>; Mon, 28 Sep 2020 05:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgI1F2p (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 28 Sep 2020 01:28:45 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35365 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgI1F2p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 28 Sep 2020 01:28:45 -0400
Received: from dread.disaster.area (pa49-195-191-192.pa.nsw.optusnet.com.au [49.195.191.192])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 0885B82781D;
        Mon, 28 Sep 2020 15:28:43 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kMliM-0004j8-Do; Mon, 28 Sep 2020 15:28:42 +1000
Date:   Mon, 28 Sep 2020 15:28:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 3/4] xfs: xfs_defer_capture should absorb remaining block
 reservation
Message-ID: <20200928052842.GE14422@dread.disaster.area>
References: <160125006793.174438.10683462598722457550.stgit@magnolia>
 <160125008731.174438.2552492068404088327.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160125008731.174438.2552492068404088327.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Ubgvt5aN c=1 sm=1 tr=0 cx=a_idp_d
        a=vvDRHhr1aDYKXl+H6jx2TA==:117 a=vvDRHhr1aDYKXl+H6jx2TA==:17
        a=kj9zAlcOel0A:10 a=reM5J-MqmosA:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=Ur0FfYQsl0IS6X0Mhg4A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Sep 27, 2020 at 04:41:27PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When xfs_defer_capture extracts the deferred ops and transaction state
> from a transaction, it should absorb the remaining block reservation so
> that when we continue the dfops chain, we still have those blocks to
> use.
> 
> This adds the requirement that every log intent item recovery function
> must be careful to reserve enough blocks to handle both itself and all
> defer ops that it can queue.  On the other hand, this enables us to do
> away with the handwaving block estimation nonsense that was going on in
> xlog_finish_defer_ops.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_defer.c |    4 ++++
>  fs/xfs/libxfs/xfs_defer.h |    1 +
>  fs/xfs/xfs_log_recover.c  |   18 +-----------------
>  3 files changed, 6 insertions(+), 17 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 0de7672fe63d..85d70f1edc1c 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -574,6 +574,8 @@ xfs_defer_capture(
>  	list_splice_init(&tp->t_dfops, &dfc->dfc_dfops);
>  	dfc->dfc_tpflags = tp->t_flags & XFS_TRANS_LOWMODE;
>  	tp->t_flags &= ~XFS_TRANS_LOWMODE;
> +	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
> +	tp->t_blk_res = tp->t_blk_res_used;
>  
>  	return dfc;
>  }

I think this needs an explanation in the function/API comment to
explain why it is being done.

Otherwise looks good.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
