Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8393C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 04:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF52F23B19
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Dec 2020 04:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgLIE1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 8 Dec 2020 23:27:43 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:55450 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgLIE1n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Dec 2020 23:27:43 -0500
Received: from dread.disaster.area (pa49-179-6-140.pa.nsw.optusnet.com.au [49.179.6.140])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id F38B43E0067;
        Wed,  9 Dec 2020 15:27:00 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kmr48-0021WD-BE; Wed, 09 Dec 2020 15:27:00 +1100
Date:   Wed, 9 Dec 2020 15:27:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Zorro Lang <zlang@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix the forward progress assertion in
 xfs_iwalk_run_callbacks
Message-ID: <20201209042700.GZ3913616@dread.disaster.area>
References: <20201208171651.GA1943235@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208171651.GA1943235@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=uDU3YIYVKEaHT0eX+MXYOQ==:117 a=uDU3YIYVKEaHT0eX+MXYOQ==:17
        a=kj9zAlcOel0A:10 a=zTNgK-yGK50A:10 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=-lf4FeGQNLXjq8aQY3wA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 08, 2020 at 09:16:51AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> In commit 27c14b5daa82 we started tracking the last inode seen during an
> inode walk to avoid infinite loops if a corrupt inobt record happens to
> have a lower ir_startino than the record preceeding it.  Unfortunately,
> the assertion trips over the case where there are completely empty inobt
> records (which can happen quite easily on 64k page filesystems) because
> we advance the tracking cursor without actually putting the empty record
> into the processing buffer.  Fix the assert to allow for this case.
> 
> Reported-by: zlang@redhat.com
> Fixes: 27c14b5daa82 ("xfs: ensure inobt record walks always make forward progress")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_iwalk.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
> index 2a45138831e3..eae3aff9bc97 100644
> --- a/fs/xfs/xfs_iwalk.c
> +++ b/fs/xfs/xfs_iwalk.c
> @@ -363,7 +363,7 @@ xfs_iwalk_run_callbacks(
>  	/* Delete cursor but remember the last record we cached... */
>  	xfs_iwalk_del_inobt(tp, curpp, agi_bpp, 0);
>  	irec = &iwag->recs[iwag->nr_recs - 1];
> -	ASSERT(next_agino == irec->ir_startino + XFS_INODES_PER_CHUNK);
> +	ASSERT(next_agino >= irec->ir_startino + XFS_INODES_PER_CHUNK);

Looks sensible.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
