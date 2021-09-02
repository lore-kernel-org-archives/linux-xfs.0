Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DDBC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E99A96101A
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 23:31:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233191AbhIBXcq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 19:32:46 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34732 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232756AbhIBXcq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 19:32:46 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 202961B795F;
        Fri,  3 Sep 2021 09:31:42 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLwBF-0080eQ-62; Fri, 03 Sep 2021 09:31:37 +1000
Date:   Fri, 3 Sep 2021 09:31:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: clean up some inconsistent indenting
Message-ID: <20210902233137.GB1826899@dread.disaster.area>
References: <20210902225219.57929-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902225219.57929-1-colin.king@canonical.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=DfNHnWVPAAAA:8 a=7-415B0cAAAA:8
        a=x60gd4Zx0dgWRERlB1gA:9 a=CjuIK1q_8ugA:10 a=rjTVMONInIDnV1a_A2c_:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 02, 2021 at 11:52:19PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There are bunch of statements where the indentation is not correct,
> clean these up.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/xfs/xfs_log.c | 29 ++++++++++++++---------------
>  1 file changed, 14 insertions(+), 15 deletions(-)

Good idea, but I see no point in only fixing one of the many style
violations this ancient debug code has whilst introducing new ones
(i.e line lengths > 80 columns).

> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index f6cd2d4aa770..9afc58a1a9ee 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -3700,21 +3700,20 @@ xlog_verify_tail_lsn(
>  	xfs_lsn_t	tail_lsn = be64_to_cpu(iclog->ic_header.h_tail_lsn);
>  	int		blocks;
>  
> -    if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
> -	blocks =
> -	    log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));
> -	if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))
> -		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
> -    } else {
> -	ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);
> -
> -	if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
> -		xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
> -
> -	blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
> -	if (blocks < BTOBB(iclog->ic_offset) + 1)
> -		xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);
> -    }
> +	if (CYCLE_LSN(tail_lsn) == log->l_prev_cycle) {
> +		blocks = log->l_logBBsize - (log->l_prev_block - BLOCK_LSN(tail_lsn));

Line length.

> +		if (blocks < BTOBB(iclog->ic_offset)+BTOBB(log->l_iclog_hsize))

Lack of whitespace around "="

> +			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);

Line length.

> +	} else {

Return from the if {} block rather than using an else statement, and
the indent of this block doesn't change:

> +		ASSERT(CYCLE_LSN(tail_lsn)+1 == log->l_prev_cycle);

Whitespace.
> +
> +		if (BLOCK_LSN(tail_lsn) == log->l_prev_block)
> +			xfs_emerg(log->l_mp, "%s: tail wrapped", __func__);
> +
> +		blocks = BLOCK_LSN(tail_lsn) - log->l_prev_block;
> +		if (blocks < BTOBB(iclog->ic_offset) + 1)
> +			xfs_emerg(log->l_mp, "%s: ran out of log space", __func__);

And because this doesn't need indent because of the return above, it
won't violate line length limits...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
